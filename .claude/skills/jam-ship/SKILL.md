---
name: jam-ship
description: Use when the student types /jam-ship or says they're ready to ship or publish their Anthropic Game Jam game. Checks the game and devlog are complete, confirms public-gallery consent, and opens a pull request adding the game to SchoolofCreativeTechnology/jam-gallery.
---

# Jam Ship

Get the game into the public gallery. Nathan merges PRs from **3:30 PM**, so shipping by then means it's live by **4:00 PM**.

Do the steps in order. Stop at the first step that fails.

## 1. Check it's ready

Read `meta.json`, `jam-state.md`, and `devlog/DEVLOG.md`, and list the files in the project (`git ls-files`, plus untracked files from `git status --porcelain`). Collect **every** gap before reporting:

- `meta.json`: `title`, `handle`, `description` are non-empty; `handle` matches `^[a-z0-9-]{2,30}$`.
- Assets: every file except `index.html`, `meta.json`, `.js`/`.css` files, dotfiles (`.gitignore` and the like), and the kit files (`context/`, `devlog/`, `.claude/`, `assets-packs/`, `demos/`, `docs/`, `facilitator/`, `jam-state.md`, `AGENTS.md`, `CLAUDE.md`, `README.md`, `STACK.md`, `JUDGING.md`) must be listed in `meta.json` `assets` (with non-empty `source` and `license`) or in `ai_assets`. Name each unlisted file.
- `DEVLOG.md`: `## Reflection` and `## AI Use Disclosure` each have the student's own content, not just the template's italic prompt.
- `devlog/AI-USE-LOG.md` exists. If **Your log** has no real entries yet (only the blank template row), **warn** them to update it in the devlog terminal. This does **not** block shipping by itself.
- `index.html` exists and still loads `main.js`.
- **`JUDGING.md` self-check (non-blocking):** Read the checklist. Warn if they have likely gaps (console not checked, no real collision when the game needs it, restart loop missing, no thought given to FPS on a weak laptop). Suggest fixes; do **not** block ship on this list alone.

If anything **blocking** is missing: list every gap with how to fix it (asset credits and title in this terminal; reflection and disclosure in the devlog terminal), and **stop**. Do not fork, copy, or open anything. Report the AI use log warning and `JUDGING.md` warnings separately; they do not block.

## 2. Consent

Ask exactly: "Your game and devlog will be published to a public gallery under the handle `<handle>`. OK to publish?" Continue only on a clear yes. Anything else: stop, and say they can run `/jam-ship` again later.

## 3. Open the pull request

```bash
gh auth status                                   # stop with "run gh auth login" if this fails
gh api repos/SchoolofCreativeTechnology/jam-gallery/contents/games/<handle> >/dev/null 2>&1 && echo TAKEN
```

**Shipping again** (`Gallery PR:` in `jam-state.md` already has a URL, e.g. after a failed check): skip the `TAKEN` check, which would find nothing until merge, and follow the same steps below, but push with `git push --force -u origin game/<handle>` and skip `gh pr create`; the open PR updates itself. Tell them the check re-runs.

If `TAKEN`: the handle is used in the gallery. Ask for a new handle, update `meta.json` and `jam-state.md`, and repeat this step.

`<jam-folder>` below is the absolute path of their jam folder (`pwd` before you leave it). Then, from a temp folder (`tmp=$(mktemp -d)`; works in Git Bash too):

```bash
gh repo fork SchoolofCreativeTechnology/jam-gallery --clone=false   # fine if the fork already exists
gh repo clone <their-login>/jam-gallery "$tmp/jam-gallery"
cd "$tmp/jam-gallery"
git remote add upstream https://github.com/SchoolofCreativeTechnology/jam-gallery.git 2>/dev/null || true
git fetch upstream && git switch -C game/<handle> upstream/main
git config user.email "$(git -C <jam-folder> config user.email)"   # same identity as their jam repo
git config user.name "$(git -C <jam-folder> config user.name)"
mkdir -p games/<handle>
```

Copy into `games/<handle>/`: `index.html`, `meta.json`, every `.js` and `.css` file of the game (not the kit folders `assets-packs/`, `demos/`, `docs/`, `facilitator/`, `.claude/`), every asset listed in `meta.json` (including any the game loads from `assets-packs/`), and `devlog/DEVLOG.md` (as `DEVLOG.md`). Keep the relative folder layout of assets so paths in the code still work.

```bash
git add games/<handle>
git commit -m "game: <handle>"
git push -u origin game/<handle>
gh pr create -R SchoolofCreativeTechnology/jam-gallery --head <their-login>:game/<handle> \
  --title "game: <handle>" --body "<title>: <description>"
```

If `git push` fails on email privacy, use the same noreply fix as `/jam-start` step 3.

## 4. Done

- `cd` back to their jam folder. Write the PR URL into `jam-state.md` `Gallery PR:` and set `Phase: shipped`. Commit and push their repo.
- Tell them: the PR is open; the gallery check runs automatically; once Nathan merges, the game appears at https://jam-gallery.vercel.app (direct link: https://jam-gallery.vercel.app/games/<handle>/). If the check fails, show them `gh pr checks <url>` and fix what it names.
- Mention that if they want the game on their own URL too, Nathan can walk them through connecting Vercel to their repo after the jam.
- Suggest a last devlog entry about shipping.
