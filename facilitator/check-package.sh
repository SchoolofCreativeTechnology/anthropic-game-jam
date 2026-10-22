#!/usr/bin/env bash
# Build the student zip and fail loud if it leaks facilitator files,
# misses a required file, or carries a personal email or API key.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
bash facilitator/package.sh >/dev/null
zip=dist/anthropic-game-jam.zip
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

files=$(unzip -Z1 "$zip" | sed 's#^anthropic-game-jam/##' | grep -v '^$')

while read -r f; do
  case "$f" in docs/*|facilitator/*|dist/*|.superpowers/*) err "leaked into package: $f" ;; esac
done <<< "$files"

required="AGENTS.md CLAUDE.md README.md index.html main.js meta.json
context/CONCEPT.md context/MECHANIC.md context/LOOK.md context/SCOPE.md
devlog/DEVLOG.md devlog/RUNBOOK.md jam-state.md
.claude/agents/jam-companion.md .claude/agents/devlog.md
.claude/skills/jam-start/SKILL.md .claude/skills/jam-ship/SKILL.md"
for r in $required; do
  grep -qxF "$r" <<< "$files" || err "missing: $r"
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
unzip -q "$zip" -d "$tmp"
root="$tmp/anthropic-game-jam"
for a in "$root"/.claude/agents/*.md; do
  [ -e "$a" ] || continue
  grep -q '^model: inherit$' "$a" || err "agent lacks 'model: inherit': ${a#$root/}"
done
if grep -rlE 'nathan@nathanmadrid\.com|sk-ant-' "$root" >/dev/null 2>&1; then
  err "personal email or API key in: $(grep -rlE 'nathan@nathanmadrid\.com|sk-ant-' "$root" | sed "s#$root/##" | tr '\n' ' ')"
fi

# Interfaces other files depend on: DEVLOG headings and jam-state fields.
for h in '## Entries' '## Reflection' '## AI Use Disclosure'; do
  [ -f "$root/devlog/DEVLOG.md" ] && ! grep -qxF "$h" "$root/devlog/DEVLOG.md" && err "DEVLOG.md lacks heading: $h"
done
for f in '- Handle:' '- Start time:' '- Phase:' '- Repo URL:' '- Gallery PR:'; do
  [ -f "$root/jam-state.md" ] && ! grep -q "^$f" "$root/jam-state.md" && err "jam-state.md lacks field: $f"
done

[ "$fail" -eq 0 ] && echo "check-package: PASS" || exit 1
