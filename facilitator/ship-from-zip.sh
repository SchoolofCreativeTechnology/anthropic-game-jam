#!/usr/bin/env bash
# Open a gallery PR from a student's dist/<handle>.zip (fallback when gh failed for them).
# Run as the SCAD GitHub account: GH_CONFIG_DIR=~/.config/gh gh auth switch -u nmadrid2797 first,
# or export GH_TOKEN for it. Usage: bash facilitator/ship-from-zip.sh <path/to/handle.zip>
set -euo pipefail
zip=${1:?zip path}; gallery=${GALLERY:-SchoolofCreativeTechnology/jam-gallery}
handle=$(basename "$zip" .zip)
[[ "$handle" =~ ^[a-z0-9-]{2,30}$ ]] || { echo "bad handle from file name: $handle" >&2; exit 1; }
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
gh repo clone "$gallery" "$tmp/g" -- -q
python3 -m zipfile -e "$zip" "$tmp/unz"
[ -d "$tmp/unz/games/$handle" ] || { echo "zip must contain games/$handle/ (have the team rebuild it with /jam-ship; the zip name must be the handle)" >&2; exit 1; }
cd "$tmp/g"
[ -e "games/$handle" ] && { echo "games/$handle already exists in the gallery" >&2; exit 1; }
git switch -q -c "game/$handle"
cp -R "$tmp/unz/games/$handle" games/
find "games/$handle" \( -name .DS_Store -o -name Thumbs.db -o -name '._*' \) -delete   # OS junk fails the credit check
if grep -rlE 'vck_[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}' "games/$handle"; then echo "key-shaped string in the game; not shipping" >&2; exit 1; fi
node scripts/build-index.mjs >/dev/null   # same validation the PR check runs
git add "games/$handle" && git commit -qm "game: $handle"
node scripts/build-index.mjs --pr-scope origin/main   # the fork-only PR check skips same-repo branches
git push -q -f -u origin "game/$handle"   # -f: a re-shipped zip replaces the earlier one
gh pr view "game/$handle" -R "$gallery" >/dev/null 2>&1 && { echo "updated the existing PR for game/$handle"; exit 0; }
gh pr create -R "$gallery" --head "game/$handle" --title "game: $handle" --body "Shipped from zip by the facilitator."
