#!/usr/bin/env bash
# Remove every jam-entry-* AI Gateway key on the SCAD Vercel team (run after the jam).
# Usage: bash facilitator/revoke-keys.sh [--yes]
set -euo pipefail
cfg=${VERCEL_CFG:-$HOME/.vercel-scad}; scope=${VERCEL_SCOPE:-nmadrid-6296s-projects}
v() { vercel --global-config "$cfg" --scope "$scope" "$@" </dev/null; }
raw=$(v ai-gateway api-keys list --limit 100 --query jam-entry 2>&1) || { echo "FAIL: could not list keys:" >&2; echo "$raw" | tail -5 >&2; exit 1; }
ids=$(python3 -c '
import sys,json
t=sys.stdin.read()
if "{" not in t: sys.exit("FAIL: key list was not JSON")
for k in json.loads(t[t.index("{"):]).get("apiKeys",[]):
    if k.get("name","").startswith("jam-entry-"): print(k["id"], k["name"])' <<< "$raw")
[ -n "$ids" ] || { echo "no jam-entry keys"; exit 0; }
echo "$ids"
[ "${1:-}" = --yes ] || { echo "rerun with --yes to remove these"; exit 0; }
while read -r id name; do
  if v ai-gateway api-keys remove "$id" --yes >/dev/null 2>&1; then echo "removed $name"; else echo "FAILED $name" >&2; fi
done <<< "$ids"
