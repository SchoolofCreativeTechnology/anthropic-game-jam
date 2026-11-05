#!/usr/bin/env bash
# Create one capped AI Gateway key per jam entry on the SCAD Vercel team and
# write them to dist/keys.txt (mode 600, gitignored) for printing on slips.
# Usage: bash facilitator/make-keys.sh <count> <dollars-per-key> [first-number]
# Env: VERCEL_CFG (default ~/.vercel-scad), VERCEL_SCOPE (default nmadrid-6296s-projects)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
count=${1:?count}; limit=${2:?dollars per key}; first=${3:-1}
cfg=${VERCEL_CFG:-$HOME/.vercel-scad}; scope=${VERCEL_SCOPE:-nmadrid-6296s-projects}
umask 077; mkdir -p dist; out=dist/keys.txt; touch "$out"
for n in $(seq "$first" $((first + count - 1))); do
  name=$(printf 'jam-entry-%02d' "$n")
  res=$(vercel --global-config "$cfg" --scope "$scope" ai-gateway api-keys create \
    --name "$name" --limit "$limit" --expiration 7d --non-interactive 2>&1 </dev/null) || true
  key=$(grep -oE 'vck_[A-Za-z0-9_-]+' <<< "$res" | head -1 || true)
  [ -n "$key" ] || { echo "FAIL: could not create $name:" >&2; grep -vE 'vck_' <<< "$res" | tail -5 >&2; exit 1; }
  printf '%s  %s\n' "$name" "$key" >> "$out"
  echo "created $name (\$$limit)"
done
echo "keys written to $out; print it, then delete it: rm $out"
