# Nova Intelligence Platform

This repository contains the building blocks required to rebrand [Open WebUI](https://github.com/open-webui/open-webui) as **Nova Intelligence** and to provide a multiplatform SwiftUI shell that can host the branded experience on Apple devices.

## Contents

| Path | Description |
| --- | --- |
| `Dockerfile` | Builds a Nova-branded variant of the official Open WebUI container image. |
| `docs/llama4-endpoint-setup.md` | Step-by-step instructions for wiring a Llama 4 endpoint into Nova Intelligence. |
| `docs/falcon-endpoint-setup.md` | Guide for running a local Falcon model as the inaugural Nova I-Go assistant. |
| `swift/NovaIntelligenceApp` | SwiftUI application package capable of running on macOS, iOS, and tvOS. |

## Zero-dependency offline preview

If you simply want to explore the Nova Intelligence interface on macOS without Docker, localhost ports, or any backend setup, run the bundled SwiftUI shell. It ships with an offline HTML/JS demo that opens instantly and mirrors the branded experience.

```bash
cd NovaIntelligence0
./scripts/launch-mac.sh
```

The script compiles the Swift package if needed and launches the "Nova Intelligence" app window. From there you can:

* Interact with the offline chat sandbox to feel the navigation and styling.
* Open the toolbar address bar and paste a real Nova deployment URL when you're ready to connect to a live backend.

> **Note:** The script requires the macOS Swift toolchain (installed automatically with Xcode 15+ or the standalone Swift installer). No additional dependencies are needed.

## Nova-branded container image

The `Dockerfile` extends the upstream Open WebUI image and performs the following:

* Replaces human-visible strings so "Open WebUI" becomes "Nova Intelligence" everywhere in the bundle.
* Updates backend defaults to prevent the original brand suffix from reappearing at runtime.
* Renames custom HTTP headers to `X-Nova-*` variants for network consistency.
* Removes unused OLED/Her themes from the compiled frontend and limits the theme picker to System/Dark/Light.
* Scrubs any literal "(Open WebUI)" suffixes left in static assets.
* Sets brand-focused default environment variables and allows optional asset injection at build time via the `NOVA_ASSETS_TARBALL` build argument.

Build the image locally (from the repository root so Docker can find the bundled `Dockerfile`):

```bash
cd NovaIntelligence0            # skip if you are already inside the repo folder
docker build -t nova-intelligence .
```

Run it on a fresh localhost port (4173 in this example):

```bash
docker run --rm -p 4173:8080 nova-intelligence
```

Then open <http://localhost:4173> in your browser to confirm the Nova Intelligence UI loads without errors.

Configure upstream model backends (for example, Llama 4) through the generated Nova Intelligence UI as you would with the original Open WebUI deployment.

> **Troubleshooting tip:** Seeing `failed to read dockerfile: open Dockerfile: no such file or directory` means the command was run from a directory that does not contain the project `Dockerfile`. Change into the cloned repository directory and rerun the command with the trailing `.` build context as shown above.

## SwiftUI host application

The Swift package `swift/NovaIntelligenceApp` exposes a minimal executable product that wraps the Nova Intelligence web experience inside a `WKWebView` while providing room for native controls such as a toolbar, address bar, and settings sheet.

### Features

* **Unified codebase:** The same SwiftUI code runs across macOS, iOS, and tvOS with adaptive navigation chrome.
* **Brand-forward UI:** Toolbar colors and icons align with the Nova palette and naming.
* **Configurable endpoint:** Users can adjust the backend URL via the in-app address bar, with validation helpers to normalize user input.
* **Extensible settings:** `@AppStorage` toggles illustrate how to persist Nova-specific preferences.

### Running in Xcode

1. Open the folder `swift/NovaIntelligenceApp` in Xcode 15 or newer (`File → Open…`).
2. Select the `NovaIntelligenceApp` scheme.
3. Choose the desired destination (iOS Simulator, My Mac, Apple TV, etc.).
4. Press **Run** to launch the hosted Nova Intelligence experience.

To point the shell at a production deployment, update the default URL in `NovaIntelligenceApp.swift` or adjust it at runtime through the address bar.

### Next steps

* Integrate secure authentication flows shared with the Docker deployment (e.g., OAuth, API tokens).
* Package the SwiftUI app as a signed `.app` bundle and submit to TestFlight for limited testing (<50 users) while securing the necessary enterprise license.
* When the Nova Intelligence LLM is ready, update the backend configuration to use the new inference endpoints without altering the Swift client.

## Syncing your local work to GitHub

All artifacts in this repository start on your machine. To publish updates to your private GitHub fork or origin repository:

```bash
git status                     # review pending changes
git add <files>                # stage the updates you want to share
git commit -m "Describe change"
git push origin <branch-name>  # replace with your working branch
```

If `git push` reports authentication issues, ensure your GitHub CLI session or personal access token has permission to update the target repository.
