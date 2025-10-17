#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
APP_PACKAGE="${PROJECT_ROOT}/swift/NovaIntelligenceApp"

if ! command -v swift >/dev/null 2>&1; then
  echo "error: Swift toolchain not found. Install Xcode or the Swift toolchain from swift.org." >&2
  exit 1
fi

cd "${APP_PACKAGE}"
exec swift run --configuration release NovaIntelligenceApp "$@"
