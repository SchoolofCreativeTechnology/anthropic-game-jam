# Anthropic Game Jam Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A private template repo students receive as a zip (starter three.js game, context templates, coaching + devlog agents, start/ship skills) and a public gallery repo that validates and lists shipped games on Vercel.

**Architecture:** Two repos. `~/projects/anthropic-game-jam` (private) holds the student package plus facilitator-only files excluded by `export-ignore`. `~/projects/jam-gallery` (public) holds `games/<handle>/` folders; a Node build script validates every `meta.json` and writes `games.json`, run by Vercel on deploy and by a GitHub Action on every PR. Agents and skills are Markdown; the only executable code is the gallery build script and the package check.

**Tech Stack:** three.js 0.186.1 via jsDelivr import map, plain HTML + ES modules, Claude Code agents/skills, Node 22 (`node:test`, no dependencies) for the gallery, GitHub Actions, Vercel free tier.

**Spec:** `docs/superpowers/specs/2026-10-22-anthropic-game-jam-design.md`

## Global Constraints

- No build step and no `npm install` in the student package. three.js pinned to `0.186.1` via import map.
- Every command in README, RUNBOOK, and skills works on macOS (zsh) and Windows (Git Bash). Give the Windows variant inline where it differs (`py`/`python` vs `python3`, `winget install GitHub.cli` vs `brew install gh`).
- Agent frontmatter `model: inherit`. README tells students to run `/model` and choose Opus 5.5.
- Build session (`jam-companion`) owns game code and `context/`; devlog session owns `devlog/`. Neither writes the other's files.
- Claude never invents the game concept or fills `context/` with its own content. Seed ideas allowed, then step back.
- Handle format: `^[a-z0-9-]{2,30}$`. Public in the gallery.
- Every downloaded asset has `source` and `license` in `meta.json`; AI-generated assets listed in `ai_assets` and named in the DEVLOG disclosure.
- No secrets, no shared tokens, in either repo.
- Commits in both repos use `222878840+nmadrid27@users.noreply.github.com` (GitHub email-privacy blocks the personal address).
- Phases: Concept + Context 0:00–0:45, First build to 1:15, Iterate to 3:15, Ship to 4:00. Ship window (PRs open) from 3:30.

## Review Focus

1. **Student runs the game by double-clicking `index.html`** (`file://`): ES modules fail silently to a blank page. Expect a visible on-page message telling them to use the serve command. Pinned in Task 2.
2. **Handle already taken in the gallery, or invalid (`My Name!`)**: expect the build to fail with a message naming the handle, not a silent overwrite. Pinned in Task 7 tests.
3. **Downloaded asset missing license**: expect the gallery build and PR check to fail naming the file. Pinned in Task 7 tests.
4. **`gh` not logged in, or not installed, on Windows**: expect `/jam-start` to stop with the Windows-specific fix, not a raw error. Pinned in Task 5 scenario check.
5. **Student says "just make me a game"**: expect the companion to offer a few seeds and ask them to choose or change one, not to write a pitch or code. Pinned in Task 4 scenario check.

---

## File Structure

`~/projects/anthropic-game-jam/`
```
AGENTS.md, CLAUDE.md, README.md, .gitattributes, .gitignore
index.html, main.js, meta.json
context/CONCEPT.md, MECHANIC.md, LOOK.md, SCOPE.md
devlog/DEVLOG.md, RUNBOOK.md
jam-state.md
.claude/agents/jam-companion.md, devlog.md
.claude/skills/jam-start/SKILL.md, jam-ship/SKILL.md
facilitator/CHECKLIST.md, package.sh, check-package.sh     (export-ignore)
docs/                                                      (export-ignore)
```

`~/projects/jam-gallery/`
```
index.html, vercel.json, package.json
scripts/build-index.mjs, scripts/build-index.test.mjs
games/example/ (index.html, main.js, meta.json, DEVLOG.md)
.github/workflows/check.yml
README.md
```

---

### Task 1: Template skeleton and packaging

**Files:**
- Create: `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitattributes`, `facilitator/package.sh`, `facilitator/check-package.sh`, `facilitator/CHECKLIST.md`
- Modify: `.gitignore`

**Interfaces:**
- Produces: `bash facilitator/package.sh` writes `dist/anthropic-game-jam.zip` from `HEAD` via `git archive`. `bash facilitator/check-package.sh` exits 0 only when the zip passes the checks below. Later tasks run it as their regression check.

- [ ] **Step 1: Write `facilitator/check-package.sh`** (the test). It runs `package.sh`, lists the zip with `unzip -Z1`, and fails loud (`set -euo pipefail`, message per failure) when:
  - any path starts with `docs/`, `facilitator/`, or `dist/`
  - any of these is missing: `AGENTS.md CLAUDE.md README.md index.html main.js meta.json context/CONCEPT.md context/MECHANIC.md context/LOOK.md context/SCOPE.md devlog/DEVLOG.md devlog/RUNBOOK.md jam-state.md .claude/agents/jam-companion.md .claude/agents/devlog.md .claude/skills/jam-start/SKILL.md .claude/skills/jam-ship/SKILL.md`
  - any agent file under `.claude/agents/` lacks `model: inherit`
  - any packaged text file contains `nathan@nathanmadrid.com` or matches `sk-ant-`

- [ ] **Step 2: Write `facilitator/package.sh`**: `git archive --format=zip --prefix=anthropic-game-jam/ -o dist/anthropic-game-jam.zip HEAD` (create `dist/`; refuse with a message if the working tree is dirty). Add `dist/` to `.gitignore`. Note: the `--prefix` means the check strips `anthropic-game-jam/` before matching.

- [ ] **Step 3: Run check, expect FAIL** listing every missing file. Run: `bash facilitator/check-package.sh`

- [ ] **Step 4: Write `.gitattributes`** with `docs/ export-ignore`, `facilitator/ export-ignore`, `.gitattributes export-ignore`.

- [ ] **Step 5: Write `AGENTS.md`** (student-facing): what the jam is, the four phases and times, how to start (`claude --agent jam-companion`, then `/jam-start`), how to open the devlog terminal (`claude --agent devlog`), file-ownership rule, no-build-step rule, asset rules, "the idea is yours" rule. `CLAUDE.md` is `@AGENTS.md` plus one shim line, matching `~/AGENTS.md` convention.

- [ ] **Step 6: Write `README.md`**: unzip, `cd anthropic-game-jam`, `claude --agent jam-companion`, `/model` choose Opus 5.5, `/jam-start`. Mac and Windows (Git Bash) blocks side by side. Under 40 lines.

- [ ] **Step 7: Write `facilitator/CHECKLIST.md`**: before jam (students have GitHub accounts; `gh auth login` done in onboarding; Git Bash on Windows; Claude plan includes Opus 5.5; SCAD publishing/consent policy checked; any minors; headcount; gallery repo live and Vercel connected), during (merge PRs from 3:30, `gh pr list -R nmadrid27/jam-gallery`), after (personal-Vercel walkthroughs).

- [ ] **Step 8: Commit** (`feat: add template skeleton and packaging`). Check still fails until Tasks 2–6 land; that is expected.

---

### Task 2: Starter three.js scene

**Files:**
- Create: `index.html`, `main.js`, `meta.json`

**Interfaces:**
- Produces: `meta.json` schema used by Tasks 6 and 7:
  `{ "title": string, "handle": string, "description": string, "assets": [{ "file": string, "source": string, "license": string }], "ai_assets": [string] }`. Template ships with `title: ""`, `handle: ""`, empty arrays.

- [ ] **Step 1: Write `index.html`**: import map `"three": "https://cdn.jsdelivr.net/npm/three@0.186.1/build/three.module.js"` and `"three/addons/": "https://cdn.jsdelivr.net/npm/three@0.186.1/examples/jsm/"`; `<script type="module" src="./main.js">`; a `<noscript>`-style fallback div `#file-warning` shown by a tiny inline classic script when `location.protocol === 'file:'`, text: "This game needs a local server. In this folder run: python3 -m http.server 8000 (Windows: py -m http.server 8000), then open http://localhost:8000".

- [ ] **Step 2: Write `main.js`**: scene, perspective camera, hemisphere + directional light, ground plane, one cube moved by WASD/arrow keys, resize handler, `renderer.setAnimationLoop`. Under 60 lines, commented for a non-coder reading it.

- [ ] **Step 3: Verify**: `node --check main.js` passes; `python3 -m http.server 8000` then open `http://localhost:8000`, cube moves with WASD, no console errors; open `index.html` directly, `#file-warning` visible.

- [ ] **Step 4: Commit** (`feat: add starter three.js scene`).

---

### Task 3: Context, devlog, and state templates

**Files:**
- Create: `context/CONCEPT.md`, `context/MECHANIC.md`, `context/LOOK.md`, `context/SCOPE.md`, `devlog/DEVLOG.md`, `devlog/RUNBOOK.md`, `jam-state.md`

**Interfaces:**
- Produces: `jam-state.md` fields read by both agents and both skills, as a Markdown list: `- Handle:`, `- Start time:` (ISO 8601 local), `- Phase:` (one of `concept`, `first-build`, `iterate`, `ship`, `shipped`), `- Repo URL:`, `- Gallery PR:`.
- Produces: `devlog/DEVLOG.md` sections the ship check looks for: `## Entries`, `## Reflection`, `## AI Use Disclosure`.

- [ ] **Step 1: Write the four context templates.** Each section: heading, one guiding question in italics, one short example from a *different* imaginary game, then an empty answer line `> ` for the student. CONCEPT: pitch, player fantasy, why it's yours. MECHANIC: core loop, controls, win/lose. LOOK: mood, palette, references (with links). SCOPE: in for 4 hours, out, stretch.

- [ ] **Step 2: Write `devlog/DEVLOG.md`** with the three section headings, an entry format line (`### HH:MM — what I tried / what happened / what I decided and why`), and the disclosure prompt (what Claude did, what you did, AI-generated assets).

- [ ] **Step 3: Write `devlog/RUNBOOK.md`**: run locally (Mac/Windows commands), where to edit, how to ship (`/jam-ship`). Devlog agent keeps it current.

- [ ] **Step 4: Write `jam-state.md`** with empty fields above.

- [ ] **Step 5: Commit** (`feat: add context, devlog, and state templates`).

---

### Task 4: `jam-companion` agent

**Files:**
- Create: `.claude/agents/jam-companion.md`

**Interfaces:**
- Consumes: `jam-state.md` fields (Task 3), `context/*` (Task 3), `/jam-start` and `/jam-ship` names (Tasks 5, 6).

- [ ] **Step 1: Write the agent.** Frontmatter: `name: jam-companion`, `description` (build partner and coach for the Anthropic Game Jam), `model: inherit`. Body, adapted from `~/projects/esf-companion/.claude/agents/esf-companion.md` and kept under 150 lines:
  - Invariant: the game is the student's.
  - Four principles (direction first, fluency is not quality, rejections are judgment, ownership needs articulation), one short paragraph each in jam terms.
  - Session start: read `jam-state.md`; if Handle empty, tell the student to run `/jam-start`.
  - Clock: compute elapsed from Start time; at phase boundaries, one line of where they are and a scope-cut offer if behind. Never forces.
  - Building: write code only from a student request or a choice they made; after a visible change, ask them to play it and react.
  - Drift: 3+ consecutive changes accepted with no comment, one light check-in, once per phase.
  - Ideas: may offer up to three one-line seeds or constraints; never develops a pitch, ranks, or picks.
  - Never writes `devlog/`. Points the student to the devlog terminal at milestones.
  - Explains three.js only when asked, at the student's level.
  - Assets: when the student adds a downloaded file, ask for source and license and add to `meta.json`; when Claude creates an asset, add it to `ai_assets`.

- [ ] **Step 2: Scenario check** (from a scratch copy: `bash facilitator/package.sh && unzip -q dist/anthropic-game-jam.zip -d $TMP`; `cd` there):
  `env -u ANTHROPIC_API_KEY claude -p --agent jam-companion "I have no idea for a game, just make me one"`
  Expected: up to three short seeds, a question asking which to take or change; no code written, no full pitch. Run twice; both must pass.

- [ ] **Step 3: Scenario check:** `env -u ANTHROPIC_API_KEY claude -p --agent jam-companion "write my devlog entry for the last change"` Expected: declines to write `devlog/`, points to `claude --agent devlog`.

- [ ] **Step 4: Commit** (`feat: add jam-companion agent`).

---

### Task 5: `/jam-start` skill

**Files:**
- Create: `.claude/skills/jam-start/SKILL.md`

**Interfaces:**
- Consumes: `jam-state.md` fields, `context/*`, handle regex from Global Constraints.
- Produces: filled `jam-state.md` (Handle, Start time, Phase `concept`, Repo URL), commits on `main`.

- [ ] **Step 1: Write the skill**, frontmatter `name: jam-start` plus a trigger description. Steps from the spec, with these exact behaviors:
  1. Detect OS (`uname -s`; `MINGW*`/`MSYS*` = Windows). Check `git --version`, `gh auth status`, and one of `python3`/`py`/`python`/`npx`. On any miss, stop and give the OS-specific fix in plain language; do not continue.
  2. Ask for a handle; validate `^[a-z0-9-]{2,30}$`; note it is public.
  3. Ask before creating a repo. On yes: `git init -b main` if not a repo, `git add -A && git commit -m "start: <handle>"`, `gh repo create <handle>-jam-game --private --source . --push`. On push error mentioning email privacy, set repo-local `user.email` to the student's `<id>+<login>@users.noreply.github.com` (from `gh api user`) and retry once.
  4. Interview through `context/` one section at a time, writing the student's words. Flag vague answers with one follow-up; never fill. Seeds rule from Task 4.
  5. Write `jam-state.md`, commit (`docs: context and start state`), tell them to open a second terminal with `claude --agent devlog`.

- [ ] **Step 2: Scenario check** in a fresh unzip with `gh` logged out (`GH_CONFIG_DIR=$(mktemp -d)`): run `/jam-start` via `claude -p --agent jam-companion "/jam-start"`. Expected: stops at setup with the `gh auth login` fix; no files written.

- [ ] **Step 3: Manual check** with `gh` logged in, using a throwaway handle; confirm the private repo appears, then delete it (`gh repo delete <handle>-jam-game --yes`; requires `delete_repo` scope, confirm with Nathan before running).

- [ ] **Step 4: Commit** (`feat: add jam-start skill`).

---

### Task 6: `devlog` agent and `/jam-ship` skill

**Files:**
- Create: `.claude/agents/devlog.md`, `.claude/skills/jam-ship/SKILL.md`

**Interfaces:**
- Consumes: DEVLOG section headings (Task 3), `meta.json` schema (Task 2), gallery validation rules (Task 7: same handle regex and asset rules).
- Produces: PR against `nmadrid27/jam-gallery` adding `games/<handle>/`.

- [ ] **Step 1: Write `devlog.md`**: `name: devlog`, `model: inherit`. Reads `git log --oneline`, `git diff`, `context/`, `jam-state.md`. Asks the student what mattered and why; writes entries in their words under `## Entries`. Writes only `devlog/`; refuses other writes. Keeps RUNBOOK current. At ship phase, walks the student through `## Reflection` and `## AI Use Disclosure` (asks, does not draft their reflection; may draft the factual disclosure list of AI-generated assets from `meta.json` for them to confirm).

- [ ] **Step 2: Write `jam-ship/SKILL.md`**:
  1. Check: `meta.json` title, handle, description non-empty; every downloaded file in the project (images, audio, models, fonts outside the starter set) appears in `assets` with source and license; DEVLOG has non-empty Reflection and Disclosure. List every gap, stop.
  2. Consent: "Your game and devlog go to a public gallery under handle `<handle>`. OK?" Stop on anything but yes.
  3. `gh repo fork nmadrid27/jam-gallery --clone=false`; clone the fork to a temp dir; refuse if `games/<handle>/` exists upstream; copy `index.html`, `main.js`, `meta.json`, any asset files, and `devlog/DEVLOG.md` into `games/<handle>/`; commit; push; `gh pr create -R nmadrid27/jam-gallery --title "game: <handle>"`.
  4. Record PR URL in `jam-state.md`, Phase `shipped`. Tell the student the gallery URL their game will appear at once merged, and offer the personal-Vercel walkthrough with Nathan.

- [ ] **Step 3: Scenario check:** `env -u ANTHROPIC_API_KEY claude -p --agent devlog "fix the jump bug in main.js"` Expected: refuses, points to the build terminal.

- [ ] **Step 4: Run** `bash facilitator/check-package.sh` Expected: PASS (all files present now).

- [ ] **Step 5: Commit** (`feat: add devlog agent and jam-ship skill`).

---

### Task 7: Gallery repo

**Files (new repo `~/projects/jam-gallery`):**
- Create: `scripts/build-index.mjs`, `scripts/build-index.test.mjs`, `package.json`, `index.html`, `vercel.json`, `.github/workflows/check.yml`, `games/example/*`, `README.md`

**Interfaces:**
- Produces: `buildIndex(gamesDir: string) -> Array<{handle, title, description, path}>` exported from `build-index.mjs`; throws `Error` with a message naming the handle and problem on any invalid game. CLI (`node scripts/build-index.mjs`) writes `games.json` at repo root, exits 1 on error.
- `package.json`: `"type": "module"`, scripts `"build": "node scripts/build-index.mjs"`, `"test": "node --test scripts/"`. No dependencies.

- [ ] **Step 1: Write failing tests** in `build-index.test.mjs` (fixtures built in a temp dir per test):
  - `valid game listed`: one game with complete meta → array of length 1, `handle === 'ok-handle'`, `path === 'games/ok-handle/'`.
  - `folder name must match meta.handle`: folder `a`, meta handle `b` → throws `/a.*handle/`.
  - `invalid handle rejected`: `My Name!` → throws `/handle/`.
  - `asset missing license rejected`: `assets: [{file:'x.png', source:'url', license:''}]` → throws `/x\.png.*license/`.
  - `asset file not listed rejected`: `games/h/tex.png` present, `assets: []` → throws `/tex\.png/`. (Allowed unlisted: `index.html`, `main.js`, `meta.json`, `DEVLOG.md`, any `.js`/`.css`; anything else must be in `assets` or `ai_assets`.)
  - `missing index.html rejected` → throws `/index\.html/`.
  - `sorted by title` across two games.

- [ ] **Step 2: Run** `npm test` Expected: FAIL, module not found.

- [ ] **Step 3: Implement `buildIndex`** with `node:fs` only; CLI wrapper writes `games.json` and prints the count.

- [ ] **Step 4: Run** `npm test` Expected: all PASS.

- [ ] **Step 5: Write `index.html`** (fetches `games.json`, one card per game: title, handle, Play link, Devlog link to `games/<handle>/DEVLOG.md`), `vercel.json` (`{"buildCommand": "node scripts/build-index.mjs", "outputDirectory": "."}`), `games/example/` (copy of the starter scene with valid meta), `.github/workflows/check.yml` (on `pull_request`: `actions/setup-node` 22, `npm test`, `npm run build`), `README.md` (how students submit; how Nathan merges).

- [ ] **Step 6: Verify** `npm run build` writes `games.json` with the example; `python3 -m http.server` shows the card and the example plays.

- [ ] **Step 7: Commit** (`feat: gallery index builder, page, and PR check`).

- [ ] **Step 8: Publish (confirm with Nathan first; outward-facing):** `gh repo create nmadrid27/jam-gallery --public --source . --push`; Nathan connects the repo in Vercel (free tier) and records the production URL in the template's `AGENTS.md` and `jam-ship` skill, then commits that change in the template repo.

---

### Task 8: End-to-end dry run

**Files:**
- Modify: anything the dry run breaks; `facilitator/CHECKLIST.md` with timings observed.

- [ ] **Step 1:** `bash facilitator/package.sh`; unzip into an empty folder; follow README as a non-coder persona through `/jam-start`, a first build, two iterations, devlog entries in a second terminal, `/jam-ship` against the live gallery with handle `dry-run-mac`. Record elapsed time per phase.

- [ ] **Step 2:** Confirm the PR check passes, merge, confirm the game plays at the Vercel URL. Then remove `games/dry-run-mac/` via a follow-up commit.

- [ ] **Step 3:** Repeat Step 1 on a Windows machine (Git Bash) with handle `dry-run-win`. If no Windows machine is available, record that as an open risk in CHECKLIST.md rather than marking it done.

- [ ] **Step 4:** Fix anything found, re-run `bash facilitator/check-package.sh`, commit (`fix: dry-run findings`), push both repos.
