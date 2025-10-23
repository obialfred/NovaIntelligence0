#!/usr/bin/env python3
"""Download and prepare the Nova Intelligence (beta) web bundle."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path
from typing import Iterable

try:
    import tarfile
except ImportError:  # pragma: no cover - tarfile is part of the stdlib
    tarfile = None

TEXT_EXTENSIONS = {
    ".css",
    ".html",
    ".js",
    ".json",
    ".map",
    ".md",
    ".svg",
    ".txt",
    ".xml",
    ".webmanifest",
    ".yml",
    ".yaml",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--version", required=True)
    parser.add_argument("--brand", required=True)
    parser.add_argument("--pip", default=os.environ.get("PYTHON", sys.executable))
    return parser.parse_args()


def download_package(python: str, version: str, destination: Path) -> Path:
    destination.mkdir(parents=True, exist_ok=True)
    cmd = [
        python,
        "-m",
        "pip",
        "download",
        f"open-webui=={version}",
        "--no-deps",
        "-d",
        str(destination),
    ]
    subprocess.run(cmd, check=True)
    candidates = sorted(destination.glob("open_webui-*"))
    if not candidates:
        raise FileNotFoundError("pip download did not produce an open_webui artifact")
    return candidates[-1]


def extract_artifact(artifact: Path, destination: Path) -> Path:
    destination.mkdir(parents=True, exist_ok=True)
    if artifact.suffix == ".whl" or artifact.name.endswith(".whl"):
        with zipfile.ZipFile(artifact) as archive:
            archive.extractall(destination)
    elif artifact.suffixes[-2:] == [".tar", ".gz"] and tarfile is not None:
        with tarfile.open(artifact) as archive:
            archive.extractall(destination)
    else:
        raise ValueError(f"Unsupported artifact format: {artifact.name}")
    return destination


def find_frontend(root: Path) -> Path:
    for candidate in root.rglob("frontend"):
        if (candidate / "index.html").exists():
            return candidate
    raise FileNotFoundError("Unable to locate the frontend assets inside the package")


def clear_directory(path: Path) -> None:
    if not path.exists():
        path.mkdir(parents=True, exist_ok=True)
        return
    for entry in path.iterdir():
        if entry.is_dir():
            shutil.rmtree(entry)
        else:
            entry.unlink()


def copy_frontend(frontend: Path, destination: Path) -> None:
    clear_directory(destination)
    for entry in frontend.iterdir():
        target = destination / entry.name
        if entry.is_dir():
            shutil.copytree(entry, target, dirs_exist_ok=True)
        else:
            shutil.copy2(entry, target)


def iter_textual_files(root: Path) -> Iterable[Path]:
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        suffix = path.suffix.lower()
        if suffix in TEXT_EXTENSIONS or path.name in {"LICENSE", "CREDITS"}:
            yield path


def rebrand(root: Path, brand: str) -> None:
    replacements = [
        ("Open\u00a0WebUI", brand.replace(" ", "\u00a0")),
        ("Open WebUI", brand),
        ("Open-WebUI", brand),
        ("OPEN WEBUI", brand.upper()),
        ("OPEN-WEBUI", brand.upper()),
        ("open webui", brand.lower()),
    ]

    for path in iter_textual_files(root):
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        original = text
        for old, new in replacements:
            text = text.replace(old, new)
        if text != original:
            path.write_text(text, encoding="utf-8")



def write_metadata(destination: Path, version: str, artifact_name: str) -> None:
    payload = {
        "version": version,
        "source": artifact_name,
        "prepared": True,
    }
    (destination / ".nova-intelligence.json").write_text(
        json.dumps(payload, indent=2), encoding="utf-8"
    )



def main() -> int:
    args = parse_args()
    output = args.output.resolve()
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_path = Path(tmpdir)
        artifact = download_package(args.pip, args.version, tmp_path)
        extracted = extract_artifact(artifact, tmp_path / "extract")
        frontend = find_frontend(extracted)
        copy_frontend(frontend, output)
        rebrand(output, args.brand)
        write_metadata(output, args.version, artifact.name)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as exc:
        print(f"Failed to download open-webui: {exc}", file=sys.stderr)
        sys.exit(exc.returncode)
    except Exception as exc:  # noqa: BLE001 - surface a helpful error upstream
        print(f"prepare_bundle.py error: {exc}", file=sys.stderr)
        sys.exit(1)
