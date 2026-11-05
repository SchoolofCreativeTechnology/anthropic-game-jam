#!/usr/bin/env bash
# Anthropic Game Jam kit installer (macOS and Windows Git Bash).
#
# Usage, from the folder where you want the kit (for example your Desktop):
#   curl -fsSL https://raw.githubusercontent.com/SchoolofCreativeTechnology/anthropic-game-jam/main/install.sh | bash
#
# It checks your tools, downloads the kit into ./anthropic-game-jam, asks for the
# gateway key on your slip (typing is hidden), and tests the key.
#
# Facilitator overrides (env): JAM_REPO, JAM_REF, JAM_SOURCE (local checkout,
# for dry runs), JAM_GATEWAY_KEY (skip the prompt), JAM_DIR (target folder).
set -euo pipefail

REPO="${JAM_REPO:-SchoolofCreativeTechnology/anthropic-game-jam}"
REF="${JAM_REF:-main}"
DIR="${JAM_DIR:-anthropic-game-jam}"
GATEWAY="https://ai-gateway.vercel.sh/claude-code"

case "$(uname -s)" in
  Darwin) os=mac ;;
  MINGW*|MSYS*|CYGWIN*) os=win ;;
  *) os=other ;;
esac

say() { printf '%s\n' "$*"; }
fix() { [ "$os" = win ] && say "    fix: $2" || say "    fix: $1"; }

# 1. Tools. Collect every problem, then stop before writing anything.
missing=0
need() { # name, check command, mac fix, windows fix
  if ! eval "$2" >/dev/null 2>&1; then say "  missing: $1"; fix "$3" "$4"; missing=1; fi
}
say "Checking your tools..."
need git "git --version" "xcode-select --install" "install Git for Windows from https://git-scm.com, then reopen Git Bash"
need "GitHub CLI (gh)" "gh --version" "brew install gh" "winget install GitHub.cli, then reopen Git Bash"
need "Python 3" "python3 --version || py --version || python --version" "xcode-select --install" "winget install Python.Python.3.12, then reopen Git Bash"
need "Claude Code" "claude --version" "curl -fsSL https://claude.ai/install.sh | bash" "in PowerShell: irm https://claude.ai/install.ps1 | iex, then reopen Git Bash"
need curl "curl --version" "comes with macOS" "comes with Git Bash"
need tar "tar --version" "comes with macOS" "comes with Git Bash"
if [ "$missing" -ne 0 ]; then
  say ""
  say "Install what's missing, then run this command again. Nothing was written."
  exit 1
fi
blender=no
for b in blender /Applications/Blender.app/Contents/MacOS/Blender "/c/Program Files/Blender Foundation"/Blender*/blender.exe; do
  if [ -x "$b" ] || command -v "$b" >/dev/null 2>&1; then blender=yes; break; fi
done
[ "$blender" = yes ] && say "  Blender: found" || say "  Blender: not found (optional; you can still make the game)"
say "  All required tools found."

# 2. The kit.
if [ -e "$DIR" ]; then
  say "A folder named $DIR already exists here. Move it, or run this from another folder."
  exit 1
fi
mkdir "$DIR"
if [ -n "${JAM_SOURCE:-}" ]; then
  git -C "$JAM_SOURCE" archive HEAD | tar -x -C "$DIR"
else
  # GitHub archives honor export-ignore, so facilitator files stay out.
  if ! curl -fsSL "https://codeload.github.com/$REPO/tar.gz/$REF" | tar -xz -C "$DIR" --strip-components=1; then
    rm -rf "$DIR"
    say "Could not download the kit. Check your internet connection and try again."
    exit 1
  fi
fi
cd "$DIR"
grep -qxF '.claude/settings.local.json' .gitignore || printf '.claude/settings.local.json\n' >> .gitignore
say "  Kit downloaded into $DIR/"

# 3. The gateway key. Under curl | bash, stdin is this script, so read from the terminal.
key="${JAM_GATEWAY_KEY:-}"
while [ -z "$key" ]; do
  printf 'Paste the gateway key from your slip (it stays hidden), then press Enter: '
  IFS= read -rs key < /dev/tty || true
  printf '\n'
  key="$(printf '%s' "$key" | tr -d '[:space:]')"
  case "$key" in
    vck_*) ;;
    *) [ -n "$key" ] && say "That doesn't look like a gateway key (it starts with vck_). Try again."; key="" ;;
  esac
done
case "$key" in *[!A-Za-z0-9_-]*) say "The key has unexpected characters. Ask Nathan for a new slip."; exit 1 ;; esac

mkdir -p .claude
umask 077
cat > .claude/settings.local.json <<EOF
{
  "model": "claude-code/vmc/jam-guide",
  "env": {
    "ANTHROPIC_BASE_URL": "$GATEWAY",
    "ANTHROPIC_AUTH_TOKEN": "$key",
    "ANTHROPIC_API_KEY": "",
    "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": "1",
    "ENABLE_TOOL_SEARCH": "true",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-code/vmc/jam-lead",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-code/vmc/jam-build",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-code/vmc/jam-cheap"
  }
}
EOF
umask 022

# One tiny request. The key goes in on stdin (-H @-), never on the command line.
code=$(printf 'x-api-key: %s\n' "$key" | curl -s -o /dev/null -w '%{http_code}' -H @- \
  -H 'content-type: application/json' -H 'anthropic-version: 2023-06-01' \
  "$GATEWAY/v1/messages" \
  -d '{"model":"vmc/jam-guide","max_tokens":5,"messages":[{"role":"user","content":"Say OK"}]}' || true)
key=""
case "$code" in
  200) say "  Key works." ;;
  401) say "  The gateway rejected the key (401). Check it against your slip: rm .claude/settings.local.json, then run this again." ; exit 1 ;;
  402) say "  This key's budget is used up (402). Ask Nathan." ; exit 1 ;;
  403) say "  The gateway blocked the model (403). Ask Nathan." ; exit 1 ;;
  *) say "  Could not test the key (HTTP ${code:-none}). Check your internet; the key is saved, so you can still try the next step." ;;
esac

say ""
say "Done. Next:"
say "  cd $DIR"
say "  claude --agent jam-companion"
say "Then type /jam-start"
