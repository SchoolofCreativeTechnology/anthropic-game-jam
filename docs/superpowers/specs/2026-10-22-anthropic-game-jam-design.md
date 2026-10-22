# Anthropic Game Jam: Design

Date: 2026-10-22 · Jam: 2026-11-06 (single 4-hour session) · Owner: Nathan Madrid

## Intent

Students build a browser game in 4 hours with three.js and Claude Code (Opus 5.5). The repo is the course material: students start from it, a coaching agent walks them through the process, and the finished games go to a shared public gallery.

The why: students should come out having *directed* an AI build, not watched one. The game concept, the decisions, and the record of those decisions stay theirs. This is the ESF Companion stance (`~/projects/esf-companion/.claude/agents/esf-companion.md`) narrowed to one jam.

## Audience

- Mixed: some game-dev students, some with no coding background. Coding is not required.
- Everyone has used Claude before. Students new to the terminal get a live onboarding session from Nathan (terminal setup, unzip, run `claude`).
- Mixed macOS and Windows. Every command in skills, README, and RUNBOOK must work on both (Windows: Claude Code runs on Git for Windows / Git Bash; `gh` via winget; Python as `py` or `python`). Skills detect the OS and give the matching fix.

## Goals

1. A student with zero code experience can go from unzip to a playable, published game in 4 hours.
2. The student authors the concept and the decision record; Claude builds from their direction.
3. Every finished game appears in one shared gallery with its devlog.

## Non-goals

- Teaching three.js or JavaScript systematically. The companion explains on request only.
- Multiplayer, backends, accounts, asset pipelines, build tooling for the default path.
- Automating personal Vercel deploys. Nathan walks interested students through that by hand.
- Porting ESF's install script, release tooling, Defense Pack, or multi-platform files.

## Anti-goals (failure even if it "works")

- Claude invents the game idea, or "prefills" context docs with its own content.
- The devlog reads as Claude's narration of what Claude did.
- A student burns the first hour on setup instead of building.
- Student real names or work published without consent.

## Two repos

### 1. `~/projects/anthropic-game-jam` (private, GitHub `nmadrid27/anthropic-game-jam`)

The template. Never cloned by students. Nathan packages it with `git archive` into a zip; `.gitattributes` `export-ignore` keeps facilitator-only files (`docs/`, `facilitator/`) out of the student package.

Student package contents:

```
AGENTS.md                 canonical instructions (jam rules, file ownership, no-build-step default)
CLAUDE.md                 shim: @AGENTS.md
README.md                 student quickstart (unzip, cd, claude, /jam-start)
index.html                starter three.js scene, three.js via CDN import map
main.js                   camera, light, render loop, one controllable object
context/
  CONCEPT.md              the game in the student's words: pitch, player fantasy, why it's theirs
  MECHANIC.md             core loop, controls, win/lose
  LOOK.md                 art direction, mood, references
  SCOPE.md                in for 4 hours / out / stretch
devlog/
  DEVLOG.md               empty, timestamped entries go here
  RUNBOOK.md              how to run, edit, and ship this game
.claude/
  agents/jam-companion.md
  agents/devlog.md
  skills/jam-start/SKILL.md
  skills/jam-ship/SKILL.md
jam-state.md              current phase, start time, student handle, repo URL
```

Context templates hold headings, a guiding prompt per section, and one short example. Never pre-written answers.

### 2. `jam-gallery` (public, GitHub `nmadrid27/jam-gallery`, deployed on Nathan's Vercel free tier)

```
index.html                gallery page listing every game (title, handle, play link, devlog link)
games/<handle>/           one static game per student, plus its DEVLOG.md
```

Students fork it; `/jam-ship` opens a PR; Nathan merges; Vercel redeploys.

## Agents

### `jam-companion` (main session, `claude --agent jam-companion`, `model: inherit`, student selects Opus 5.5)

The student's build partner and coach. Principles taken from ESF:

- Student direction first: build from `context/`, never replace it.
- Fluency is not a quality signal: after a polished change, ask the student to play it and react.
- Rejections are evidence of judgment: welcome them.
- Ownership requires articulation: ask "why this?" on key choices, lightly.

Jam-specific behavior:

- Writes game code (that is the jam), but each change starts from a student request or a choice the student made between options.
- Phases on the clock, read from `jam-state.md` start time: Concept + Context (0:00 to 0:45), First build (to 1:15), Iterate (to 3:15), Ship (to 4:00). Nudges scope cuts when behind; never forces.
- Drift flag: 3+ consecutive changes accepted without modification or comment triggers one light check-in.
- Explains three.js concepts on request, at the student's level.
- Never writes to `devlog/`.

### `devlog` (second terminal, `claude --agent devlog`)

The student's scribe. Launched in a separate terminal in the same folder (`--agent` flag verified in Claude Code 2.1.308).

- Reads `git log`, diffs, and `context/` on its own; the student tells it what mattered and why.
- Writes only `devlog/DEVLOG.md` and `devlog/RUNBOOK.md`. Never game code, never `context/`.
- Records in the student's words; asks rather than infers rationale.
- At the end, helps the student write a short reflection plus an AI-use disclosure statement in `DEVLOG.md`.

File ownership is the collision guard: build session owns game code and `context/`; devlog session owns `devlog/`. Neither writes the other's files.

## Skills

### `/jam-start`

1. Check setup: `git`, `gh auth status`. Fail loud with a plain-language fix if missing.
2. Ask for a handle (shown publicly in the gallery; not their real name unless they choose).
3. Offer: "Want me to create your own private GitHub repo?" On yes: `git init`, first commit, `gh repo create <name> --private --source . --push`.
4. Interview the student through the four `context/` docs, writing down their answers in their words. Flag gaps and vague spots; never fill them.
   - Student has no idea: the companion may offer a few short seed ideas or constraints to spark one, then steps back. It does not develop a pitch, rank options, or push one. The student picks, changes, or rejects, and the doc records their version.
5. Record start time and handle in `jam-state.md`. Tell them how to open the devlog terminal.

### `/jam-ship`

1. Confirm the game runs locally and the devlog has a reflection and disclosure.
2. Confirm consent: "This goes to a public gallery under handle X. OK?"
3. Fork `jam-gallery` (`gh repo fork`), copy static game files and `DEVLOG.md` into `games/<handle>/`, open a PR.
4. Hand back the PR link. "Published" means live: Nathan merges during the ship window and the student confirms their game plays at the gallery URL. Mention the optional personal-Vercel walkthrough with Nathan.

## Constraints

- Assets: downloaded assets allowed; Claude-generated assets allowed (procedural geometry, canvas/SVG textures, code-generated audio, or files Claude writes). `meta.json` and `DEVLOG.md` list every downloaded asset with source and license; `/jam-ship` blocks shipping when a downloaded asset has no source/license entry. AI-generated assets are named in the disclosure.

- Default game path has no build step and no `npm install`: plain HTML + ES modules + three.js from a CDN import map with a pinned version. Game-dev students may opt into Vite in their own copy.
- Every game must be static so it can live in `games/<handle>/` unchanged.
- Opus 5.5 access depends on each student's Claude plan. Confirm plans before the jam.
- Vercel free tier for the gallery.
- No secrets in either repo. No shared tokens.

## Decided by Nathan

- three.js + Claude Code with Opus 5.5; 4-hour single session on 2026-11-06.
- Template repo private in `~/projects/`, shared as a packaged local copy.
- Coaching agent modeled on ESF Companion, focused on the jam.
- Devlog/runbook via a separate session the student steers (student stays author); no background subagent fallback.
- Agent-led onboarding offers to create the student's private repo and helps fill the docs.
- Public `jam-gallery` repo students fork; shared gallery on Vercel free; personal Vercel optional, walked through by Nathan.
- Name: Anthropic Game Jam.
- Students on mixed macOS and Windows.
- Companion may offer seed ideas but must not over-guide the concept.
- "Published" = live in the gallery by hour 4.
- Downloaded assets and Claude-created assets both allowed.

## Claude's calls (check these)

- Phase timings above.
- Handle instead of real name in the public gallery, plus an explicit consent step.
- Four context docs (CONCEPT, MECHANIC, LOOK, SCOPE).
- `jam-state.md` as the single state file.
- Facilitator-only files excluded via `export-ignore`.
- Local preview: ES modules won't load from `file://`, so `/jam-start` checks for `python3` or `npx` and the RUNBOOK names the serve command (`python3 -m http.server` or `npx serve`).
- Model: agent frontmatter uses `model: inherit`; README tells students to run `/model` and pick Opus 5.5. A hard pin would fail outright for students whose plan lacks it.
- Gallery listing built from per-game `games/<handle>/meta.json` so PRs never edit a shared file (no merge conflicts). `/jam-ship` refuses a handle folder that already exists in upstream.

- Ship window opens at 3:30 so Nathan can merge PRs before 4:00.
- Facilitator checklist (in `facilitator/`, excluded from the package): students have GitHub accounts and `gh auth login` done in onboarding; confirm Claude plans; check SCAD publishing/consent policy and whether any students are minors.

## Open (not blocking the build)

- Headcount (sets how tight the merge window is).
- SCAD consent policy; may require more than handle + consent prompt.

## Left to the builder

- Starter scene content (keep it tiny and working).
- Gallery page design.
- Exact wording of agent and skill prompts, within the principles above.
- Pinned three.js version.

## Verification before the jam

- Dry run: fresh unzip into an empty folder, a non-coder persona runs `/jam-start` through `/jam-ship` against a test gallery fork, under 4 hours.
- Confirm `claude --agent devlog` loads the repo's agent from a second terminal.
- Confirm the gallery deploy renders a merged game.
- Run the full flow once on Windows (Git Bash) as well as macOS.
