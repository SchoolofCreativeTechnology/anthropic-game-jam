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

required="AGENTS.md CLAUDE.md README.md JUDGING.md index.html main.js meta.json
context/CONCEPT.md context/MECHANIC.md context/LOOK.md context/SCOPE.md
devlog/DEVLOG.md devlog/RUNBOOK.md devlog/AI-USE-LOG.md jam-state.md
context/STARTERS.md context/BUILD-PLAN.md install.sh .gitignore .claude/settings.json
.claude/agents/jam-companion.md .claude/agents/devlog.md
.claude/agents/jam-builder.md .claude/agents/jam-helper.md
.claude/skills/jam-start/SKILL.md .claude/skills/jam-plan/SKILL.md .claude/skills/jam-ship/SKILL.md"
for r in $required; do
  grep -qxF "$r" <<< "$files" || err "missing: $r"
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
unzip -q "$zip" -d "$tmp"
root="$tmp/anthropic-game-jam"
for a in "$root"/.claude/agents/*.md; do
  [ -e "$a" ] || continue
  grep -qE '^model: (inherit|claude-code/vmc/jam-[a-z]+)$' "$a" || err "agent model must be inherit or claude-code/vmc/jam-*: ${a#$root/}"
done
secret='nathan@nathanmadrid\.com|sk-ant-|vck_[A-Za-z0-9_-]{20,}'
if grep -rlE "$secret" "$root" >/dev/null 2>&1; then
  err "personal email or API key in: $(grep -rlE "$secret" "$root" | sed "s#$root/##" | tr '\n' ' ')"
fi
[ -e "$root/.claude/settings.local.json" ] && err "gateway key file leaked into package: .claude/settings.local.json"
grep -qxF '.claude/settings.local.json' "$root/.gitignore" || err ".gitignore lacks .claude/settings.local.json"
bash -n "$root/install.sh" || err "install.sh has a syntax error"
python3 -m json.tool "$root/.claude/settings.json" >/dev/null || err ".claude/settings.json is not valid JSON"

# npx serve defaults to port 3000; every doc sends students to :8000.
if grep -rnE 'npx serve' "$root" | grep -v 'npx serve -l 8000' >/dev/null; then
  err "npx serve without -l 8000: $(grep -rnE 'npx serve' "$root" | grep -v 'npx serve -l 8000' | sed "s#$root/##" | cut -d: -f1,2 | tr '\n' ' ')"
fi

# Interfaces other files depend on: DEVLOG headings and jam-state fields.
for h in '## Entries' '## Reflection' '## AI Use Disclosure'; do
  [ -f "$root/devlog/DEVLOG.md" ] && ! grep -qxF "$h" "$root/devlog/DEVLOG.md" && err "DEVLOG.md lacks heading: $h"
done
for h in '## Your log' '## Worked example'; do
  [ -f "$root/devlog/AI-USE-LOG.md" ] && ! grep -qxF "$h" "$root/devlog/AI-USE-LOG.md" && err "AI-USE-LOG.md lacks heading: $h"
done
for f in '- Team:' '- Card:' '- Handle:' '- Start time:' '- Phase:' '- Repo URL:' '- Gallery PR:'; do
  [ -f "$root/jam-state.md" ] && ! grep -q "^$f" "$root/jam-state.md" && err "jam-state.md lacks field: $f"
done

[ "$fail" -eq 0 ] && echo "check-package: PASS" || exit 1
