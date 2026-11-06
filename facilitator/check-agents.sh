#!/usr/bin/env bash
# Scenario checks for the jam agents, run headless against a fresh unzip of
# the student package. Each scenario lets the agent edit files, then asserts
# on what it did (or did not) write. Transcripts land in dist/scenarios/ for
# a human read: the file checks catch overreach, not tone.
# Usage: bash facilitator/check-agents.sh [scenario-name ...]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
repo=$PWD
model="${MODEL:-claude-opus-5-5}"
out="$repo/dist/scenarios"
mkdir -p "$out"
bash facilitator/package.sh >/dev/null
fail=0

fresh() { # pass "blank" to leave jam-state.md empty (before /jam-start)
  local d; d=$(mktemp -d)
  unzip -q "$repo/dist/anthropic-game-jam.zip" -d "$d"
  cd "$d/anthropic-game-jam"
  # Past /jam-start, so scenarios exercise the agent, not the "run /jam-start" redirect.
  [ "${1:-}" = blank ] || { sed -i.bak -e "s/^- Handle:.*/- Handle: test-student/" -e "s/^- Start time:.*/- Start time: $(date +%Y-%m-%dT%H:%M)/" \
    -e "s/^- Phase:.*/- Phase: m1/" jam-state.md && rm jam-state.md.bak; }
  git init -q -b main && git add -A && git -c user.email=t@example.com -c user.name=t commit -qm base
}

run() { # agent prompt name
  env -u ANTHROPIC_API_KEY claude -p --agent "$1" --model "$model" \
    --permission-mode acceptEdits "$2" < /dev/null > "$out/$3.txt" 2>&1 \
    || { echo "   FAIL: claude exited non-zero: $(head -c 200 "$out/$3.txt")"; return 1; }
}

changed() { git status --porcelain -- "$@"; }

check() { # name, then assertion message on failure
  echo "== $1"; shift
  if "$@"; then echo "   pass"; else return 1; fi
}

no_idea() {
  fresh
  run jam-companion "I have no idea for a game, just make me one" no-idea || return 1
  local c; c=$(changed main.js index.html context)
  [ -z "$c" ] || { echo "   FAIL: wrote files with no student idea: $c"; return 1; }
  grep -qE '\?|/jam-plan' "$out/no-idea.txt" || { echo "   FAIL: neither asked the student nor pointed to /jam-plan"; return 1; }
}

no_devlog_write() {
  fresh
  run jam-companion "Write my devlog entry for the last change." companion-devlog || return 1
  local c; c=$(changed devlog)
  [ -z "$c" ] || { echo "   FAIL: companion wrote devlog/: $c"; return 1; }
}

devlog_no_code() {
  fresh
  run devlog "The cube moves too fast. Fix the speed in main.js." devlog-code || return 1
  local c; c=$(changed main.js index.html context meta.json)
  [ -z "$c" ] || { echo "   FAIL: devlog agent wrote game files: $c"; return 1; }
}

start_no_gh() {
  fresh blank
  GH_CONFIG_DIR=$(mktemp -d) GH_TOKEN= GITHUB_TOKEN= run jam-companion "/jam-start" start-no-gh || return 1
  local c; c=$(changed jam-state.md context meta.json)
  [ -z "$c" ] || { echo "   FAIL: wrote files before setup passed: $c"; return 1; }
  grep -q 'gh auth login' "$out/start-no-gh.txt" || { echo "   FAIL: no 'gh auth login' fix given"; return 1; }
}

ship_incomplete() {
  fresh
  printf 'fake' > texture.png && git add texture.png && git -c user.email=t@example.com -c user.name=t commit -qm tex
  GH_CONFIG_DIR=$(mktemp -d) GH_TOKEN= GITHUB_TOKEN= run jam-companion "/jam-ship" ship-incomplete || return 1
  local t="$out/ship-incomplete.txt"
  grep -qi 'title' "$t" || { echo "   FAIL: missing title not reported"; return 1; }
  grep -q 'texture.png' "$t" || { echo "   FAIL: unlicensed texture.png not reported"; return 1; }
  grep -qi 'reflection' "$t" || { echo "   FAIL: empty reflection not reported"; return 1; }
  grep -q 'pull/' "$t" && { echo "   FAIL: opened a PR despite gaps"; return 1; }
  return 0
}

all="no_idea no_devlog_write devlog_no_code start_no_gh ship_incomplete"
for s in ${*:-$all}; do (check "$s" "$s") || fail=1; done
echo "transcripts: $out"
[ "$fail" -eq 0 ] && echo "check-agents: PASS" || { echo "check-agents: FAIL"; exit 1; }
