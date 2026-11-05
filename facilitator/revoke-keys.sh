#!/usr/bin/env bash
# Remove every jam-entry-* AI Gateway key on the SCAD Vercel team (run after the jam).
# Usage: bash facilitator/revoke-keys.sh [--yes]
set -euo pipefail
cfg=${VERCEL_CFG:-$HOME/.vercel-scad}; scope=${VERCEL_SCOPE:-nmadrid-6296s-projects}
v() { vercel --global-config "$cfg" --scope "$scope" "$@"; }
ids=$(v ai-gateway api-keys list 2>/dev/null | python3 -c '
import sys,json,re
t=sys.stdin.read(); t=t[t.index("{"):]
for k in json.loads(t).get("apiKeys",[]):
    if k.get("name","").startswith("jam-entry-"): print(k["id"], k["name"])')
[ -n "$ids" ] || { echo "no jam-entry keys"; exit 0; }
echo "$ids"
[ "${1:-}" = --yes ] || { echo "rerun with --yes to remove these"; exit 0; }
while read -r id name; do v ai-gateway api-keys remove "$id" --yes >/dev/null 2>&1 && echo "removed $name"; done <<< "$ids"
