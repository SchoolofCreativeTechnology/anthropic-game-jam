---
name: jam-start
description: Use at the start of the Anthropic Game Jam, when the student types /jam-start, says "let's start", or jam-state.md has no Handle. Checks setup on macOS or Windows, sets the student's public handle, offers to create their private GitHub repo, and interviews them through context/ in their own words.
---

# Jam Start

Get the student from unzipped folder to a filled-in brief, fast. Setup should take minutes, not the first hour. Stay warm and brief; they are about to make something.

Do the steps in order. Do not skip ahead.

## 1. Check setup

Detect the OS with `uname -s`: `Darwin` is macOS; `MINGW*` or `MSYS*` is Windows (Git Bash).

Run each check and collect every problem before reporting:

| Check | Command | Fix: macOS | Fix: Windows (Git Bash) |
|---|---|---|---|
| git | `git --version` | `xcode-select --install` | install Git for Windows from https://git-scm.com, then reopen Git Bash |
| GitHub CLI | `gh --version` | `brew install gh` | `winget install GitHub.cli`, then reopen Git Bash |
| GitHub login | `gh auth status` | `gh auth login` | `gh auth login` |
| Local server | first that works of `python3 --version`, `py --version`, `python --version`, `npx --version` | `xcode-select --install` (brings python3) | `winget install Python.Python.3.12` |

If anything failed: list each problem with its fix in plain language, say "Run `/jam-start` again when that's done," and **stop**. Write no files.

If everything passed, say so in one line and note which serve command they'll use (from `AGENTS.md`).

**Git identity.** New installs often have no git name or email, and every commit fails without them. If `git config user.email` or `git config user.name` prints nothing, set them for this folder only (run `git init -b main` first if it is not a repo yet):

```bash
git config user.email "$(gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"')"
git config user.name "$(gh api user --jq '.login')"
```

The noreply address also avoids GitHub's email-privacy push block.

## 2. Handle

Ask for a handle: "This name shows publicly in the jam gallery next to your game. It doesn't have to be your real name."

It must match `^[a-z0-9-]{2,30}$` (lowercase letters, numbers, dashes). If it doesn't, suggest a cleaned-up version and ask them to confirm.

## 3. Their own repo (ask first)

Ask: "Want me to create your own private GitHub repo for this game? It saves your work as you go." Do nothing until they answer.

On yes:
1. `git init -b main` if this folder is not already a git repo.
2. `git add -A && git commit -m "start: <handle>"`
3. `gh repo create <handle>-jam-game --private --source . --push`
4. If the push fails with an email-privacy error ("push declined due to email privacy restrictions"): run `gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"'`, set it with `git config user.email <that>` (this repo only), `git commit --amend --reset-author --no-edit`, and `git push -u origin main`. Retry once; if it still fails, show the error and tell them to ask Nathan.
5. If the repo name is taken, offer `<handle>-jam-game-2`.

On no: `git init -b main` and a first commit anyway, so the devlog terminal can read their history. Leave Repo URL as `local only`.

## 4. The brief, in their words

Go through `context/CONCEPT.md`, `MECHANIC.md`, `LOOK.md`, `SCOPE.md`, one section at a time:

- Ask the section's question in your own plain words. Point at the example only if they're unsure what size of answer fits.
- Write their answer into the file after the `>`, in their words. Tidy spelling; do not upgrade the idea, add detail, or merge in your preferences.
- If an answer is vague ("something cool"), ask one follow-up. If it's still vague, write what they said and move on; they can revisit it.
- If they have no idea at all: offer up to three one-line seeds or constraints, ask which sparks something and what they'd change, then step back. Never develop, rank, or pick for them.
- Keep moving. The whole brief should take about 30 minutes. If they stall on LOOK or SCOPE, write what they have and say they can come back.

## 5. Start the clock

Update `jam-state.md`:
- `Handle:` their handle
- `Start time:` now, from `date +%Y-%m-%dT%H:%M` (if Nathan started the jam at a set time and they joined late, ask whether to use the official start instead)
- `Phase:` concept
- `Repo URL:` the GitHub URL, or `local only`

Set `"handle"` in `meta.json`.

Commit: `git add -A && git commit -m "docs: context and start state"`, and `git push` if they have a remote.

## 6. Hand off

Tell them, briefly:
1. Open a second terminal in this same folder and run `claude --agent devlog`. Tell it what you decide and why as you go.
2. Start the preview server (their command from step 1) and open http://localhost:8000.
3. Then tell me what to build first.
