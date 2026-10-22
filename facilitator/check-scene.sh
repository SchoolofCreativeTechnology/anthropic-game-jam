#!/usr/bin/env bash
# Headless check of the starter scene: served over http it must render a
# <canvas>; opened from file:// it must show the local-server warning.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
dump() { "$chrome" --headless=new --disable-gpu --use-angle=swiftshader --virtual-time-budget=8000 --dump-dom "$1" 2>/dev/null; }
fail=0

port=$((18760 + RANDOM % 100))
python3 -m http.server "$port" >/dev/null 2>&1 &
srv=$!
trap 'kill $srv 2>/dev/null' EXIT
sleep 1
served=$(dump "http://localhost:$port/")
grep -q '<canvas' <<< "$served" || { echo "FAIL: no <canvas> when served over http" >&2; fail=1; }
grep -q 'id="file-warning" hidden' <<< "$served" || { echo "FAIL: file warning not hidden over http" >&2; fail=1; }

local_dom=$(dump "file://$PWD/index.html")
grep -q 'id="file-warning" hidden' <<< "$local_dom" && { echo "FAIL: file warning hidden on file://" >&2; fail=1; }
grep -q 'http.server 8000' <<< "$local_dom" || { echo "FAIL: file warning text missing on file://" >&2; fail=1; }

[ "$fail" -eq 0 ] && echo "check-scene: PASS" || exit 1
