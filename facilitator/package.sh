#!/usr/bin/env bash
# Build the student zip from the committed HEAD. Facilitator-only paths are
# dropped by export-ignore rules in .gitattributes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
if ! git diff --quiet HEAD; then
  echo "package: uncommitted changes to tracked files; commit first so the zip matches HEAD" >&2
  exit 1
fi
mkdir -p dist
git archive --format=zip --prefix=anthropic-game-jam/ -o dist/anthropic-game-jam.zip HEAD
echo "dist/anthropic-game-jam.zip"
