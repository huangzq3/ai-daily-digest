#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="daily-digest-9am-push"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/${SKILL_NAME}"
DEST_ROOT="${CODEX_HOME:-/opt/codex}/skills"
DEST_DIR="${DEST_ROOT}/${SKILL_NAME}"

mkdir -p "$DEST_ROOT"
rm -rf "$DEST_DIR"
cp -R "$SRC_DIR" "$DEST_DIR"

echo "Installed skill to: $DEST_DIR"
