# Jam Redesign: Gateway Models, Teams Optional

Date: 2026-11-05. Jam: 2026-11-06, onboarding 10:00, jam 11:00 to 4:00.
Status: v2.1 (review fixes folded in). Supersedes v1 of this file (Claude seats, shared machines). Built on `e9fcbe3`.

## Intent

Students (solo or in teams of up to three) each build one small three.js browser game in a day. They think and decide; Claude Code plans with them, then builds. Model traffic is paid from Nathan's capped Vercel AI Gateway credit, routed to cheap models, so the game itself is constrained to what cheap models can build. The kit keeps the game theirs (ESF companion model), keeps scope real, and gets every entry shipped to the gallery by 4:00.

Why: the Anthropic seats fell through. Claude Code still runs, but on gateway keys with budgets, and mostly on non-Claude models.

## Goals

1. Every entry ships a playable game to the gallery by 4:00.
2. Every entry writes its own context kit and build plan before game code exists.
3. The game, its choices, and the record of them stay the makers' (devlog in their words; AI use logged honestly).
4. Scope fits a per-card allowed-feature list sized for cheap models.
5. Spend per entry is capped and measured (dry run tonight with the zombie game).
6. Setup fits the 10:00 to 11:00 hour.

## Non-goals

- Codex support (`.agents/`, `.codex/` stay untracked, out of the kit).
- Per-card code skeletons. Cheap models build from the plan; the dry run decides if skeletons are needed for a future jam.
- A no-GitHub submit path (submit endpoint, bot account). Next jam.
- A finalized judging rubric.

## Anti-goals

- Makers watching Claude build a game they did not design.
- Claude inventing the concept or writing words into `context/` or the plan the makers did not say.
- A gateway key in the repo, the gallery, a commit, or a chat transcript.
- Students reaching models outside the jam list, or one entry draining the shared bucket.
- Heavy process: long docs, big agent fan-out.

## Constraints

- Entries: solo or team (1 to 3 people), one machine per entry (students' own laptops or lab machines). One handle, one gateway key, one gallery entry per entry.
- macOS and Windows (Git Bash). Every command needs both variants.
- Blender installed. No build step: plain HTML, ES modules, three.js 0.186.1 import map, no `npm install`.
- Most students have GitHub accounts; `gh` handles fork and PR.
- Ship cutoff 3:30; Nathan merges 3:30 to 4:00.
- `facilitator/check-package.sh` must pass (updated for new files).

## The day

| Clock | Block | Model | Outcome |
|---|---|---|---|
| 10:00 to 11:00 | Onboarding | `jam-guide` | Kit installed, key set, GitHub login, handle, Blender checked |
| 11:00 to 12:30 | Plan: research, ideate, plan | `jam-guide` | `context/` filled and `context/BUILD-PLAN.md` approved |
| 12:30 to 12:45 | Break | | |
| 12:45 to 3:30 | Build, test, iterate, ship | `jam-lead` orchestrating | M1 to M5, two playtests, `/jam-ship` by 3:30 |
| 3:30 to 4:00 | Gallery | | Nathan merges |

Milestones (each leaves a playable game and a commit; makers check by playing):

| By | Milestone | Done when |
|---|---|---|
| 1:15 | M1 gray box | The one action works with plain shapes; restart works |
| 1:45 | M2 loop | Fail, score, restart under 2 seconds. **Playtest 1** |
| 2:30 | M3 feel | Tuning numbers in `tuning.js`; feedback on the action and on failure. **Playtest 2** |
| 3:15 | M4 look | Models, textures, sound within the card's limits; gameplay frozen |
| 3:30 | M5 ship | `JUDGING.md` self-check, `/jam-ship` |

Playtests: someone from another entry plays 3 minutes with no explanation; makers stay silent, then ask "Tell me the story of what just happened" and "Where were you bored or stuck?" Nathan pairs entries.

After each playtest, changes follow the one-change loop: makers say what they expect the change to do, the companion builds only that change, makers play it and say what happened, the devlog records both.

`Phase` in `jam-state.md`: `onboarding`, `plan`, `m1`, `m2`, `m3`, `m4`, `ship`, `shipped`.

## Models (Vercel AI Gateway)

Claude Code connects through the gateway's Claude Code endpoint (verified in Vercel docs):

```
ANTHROPIC_BASE_URL=https://ai-gateway.vercel.sh/claude-code
ANTHROPIC_AUTH_TOKEN=<per-entry gateway key>
ANTHROPIC_API_KEY=            (must be empty)
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
```

The kit names only four virtual models; Nathan picks what each points to and can change it mid-jam without touching the kit:

| Virtual model | Used by | Starting candidate | Fallback |
|---|---|---|---|
| `vmc/jam-guide` | companion in onboarding and plan block | `deepseek/deepseek-v4.1-flash` | `anthropic/claude-haiku-5.5` |
| `vmc/jam-lead` | companion in build block (orchestrator) | `moonshotai/kimi-k2.7-code` | `deepseek/deepseek-v4.1-flash` |
| `vmc/jam-build` | `jam-builder` subagent | `deepseek/deepseek-v4.1-flash` | `anthropic/claude-haiku-5.5` |
| `vmc/jam-cheap` | `jam-helper` subagent, devlog terminal | `zai/glm-4.7-flash` | `anthropic/claude-haiku-5.5` |

In Claude Code these appear as `claude-code/vmc/<slug>`. The session model is set in settings; at 12:45 the companion tells the makers to run `/model claude-code/vmc/jam-lead`. Subagents set `model: claude-code/vmc/jam-build` (or `jam-cheap`) in frontmatter. **Unverified:** that frontmatter, `/model`, and `--model` accept that ID, and how well non-Claude models drive Claude Code's tools. The dry run tests all of them; if frontmatter rejects it, use `model: sonnet` / `haiku` with the env remaps below.

The installer also sets `ANTHROPIC_DEFAULT_SONNET_MODEL=claude-code/vmc/jam-build`, `ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-code/vmc/jam-cheap`, and `ANTHROPIC_DEFAULT_OPUS_MODEL=claude-code/vmc/jam-lead`. Inference, not verified: Claude Code sends small background requests (titles, summaries) to its Haiku-class model; the remap keeps them on jam routing instead of hitting Haiku directly or the allowlist.

Spend controls, all on a dedicated Vercel account (Nathan's SCAD email, Pro team):
1. One API key per entry, with a budget and a fixed expiry of 2026-11-06 18:00 local (`vercel ai-gateway api-keys create`; check `--help` for the expiry flag). Not "1 day from creation": keys created tonight would lapse mid-jam.
2. Team model allowlist: only the virtual models' underlying models and fallbacks.
3. Team budget as the ceiling for the bucket.

Keys reach students on a slip at 10:00. The installer reads the key with hidden input and writes it only to `.claude/settings.local.json` (gitignored; never packaged, committed, or shipped). A leaked key spends at most its own budget until expiry.

## Install and onboarding (10:00)

```bash
curl -fsSL <kit-raw-url>/install.sh | bash
```

`install.sh`, modeled on `~/projects/esf-companion/install.sh`, run in an empty folder:

1. Checks git, gh, python3/py, claude, and Blender (Blender optional: warn, don't fail). Lists every missing tool with its macOS and Windows fix and exits without writing if a required one is missing.
2. Downloads the kit from a GitHub archive of the public kit repo (`export-ignore` keeps `docs/` and `facilitator/` out). Repo owner/name is one variable at the top.
3. Asks for the gateway key with `read -rs key < /dev/tty` (under `curl | bash`, stdin is the script, so a plain `read` would consume the script; Git Bash supports `/dev/tty`). Writes `.claude/settings.local.json` with the env block, the model remaps, and `"model": "claude-code/vmc/jam-guide"`; confirms `.gitignore` lists `.claude/settings.local.json`. Makes one tiny request to confirm the key works, passing the auth header on stdin (`-H @-`) so the key never appears in the process list (prints OK or the gateway error: 401 bad key, 402 budget, 403 model blocked).
4. Prints next steps: `claude --agent jam-companion`, then `/jam-start`.

Blender MCP is not in the installer this round (it pulls uv, an addon, and a user-scope MCP entry; one more failure point at 10:00). Assets use headless Blender scripts, as `assets-packs/character-pack/` does. MCP can be added after the dry run.

`/jam-start` (rewritten): confirms setup, git identity, `gh auth login` if needed, solo or team, one handle, members' initials (team), offers the private repo (optional; local git is enough). The brief moves to `/jam-plan`.

## Agents

All `AGENTS.md` rules stay, rewritten from "the student" to "the makers" (solo or team).

**`jam-companion` (main session, ESF companion model).** Guides the makers through the day, finds resources, keeps decisions theirs, enforces the card's allowed list (one line why, offer Stretch, makers decide). Owns game code, `context/`, `meta.json`, `jam-state.md`. In the build block it orchestrates: reads `BUILD-PLAN.md`, sends tasks to at most three subagents at once (only tasks that touch different files), reviews results, commits each working milestone, and checks in at each milestone (expected, saw, decide next). It does not stop for approval per task. Any change to what the game is goes back to the makers first.

**`jam-builder` (subagent, `vmc/jam-build`).** Builds one plan task. Must run a check before reporting done and report the output as evidence: `node --check <file>` on every changed `.js`, plus `curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/` returning 200 while the preview server runs, plus the task's own check. Console errors are the makers' check when they play the milestone. Both commands are on the allow list so builders don't stall on prompts.

**`jam-helper` (subagent, `vmc/jam-cheap`).** Mechanical tasks: `meta.json` credits, Blender headless asset scripts and GLB export, the `JUDGING.md` self-check, the runbook facts.

**`devlog` (second terminal on the same machine, `claude --agent devlog --model claude-code/vmc/jam-cheap`).** As today, plus: team voice with initials for who decided; logs milestone check-ins, playtests, and AI use; commits `devlog/` itself after each entry (`git add devlog && git commit`), and if `.git/index.lock` exists it waits a few seconds and retries once, since the companion commits in the same repo.

## Plan block (11:00 to 12:30): `/jam-plan`

1. Research (~20 min): starter cards, showcase demo, references into `context/references/`.
2. Ideate (~25 min): pick one card, add world, character, twist. If stuck: up to three seeds within the card.
3. Context kit (~25 min): CONCEPT, MECHANIC, LOOK, SCOPE in their words.
4. Build plan (~20 min): companion drafts `context/BUILD-PLAN.md` from the kit and the card, reads it back section by section; makers edit and approve. One page.

`BUILD-PLAN.md` sections: the game in one line and its one action; card chosen; done means (3 to 5 playable checks); milestones M1 to M5 with makers' "done when"; tasks per milestone (files, owner, check); file map (`index.html`, `main.js`, `tuning.js`, a few small modules); tuning knobs; assets plan within card limits; cut list and Stretch.

## Starter cards with allowed lists

`context/STARTERS.md`. Five cards. Each: the one action, **Allowed** (closed list; anything not listed is out), **Stretch** (only after M4 is done, since gameplay freezes at M4 otherwise), and "you bring: the world, the character, the twist." Cards are Nathan's constraint, so offering them is not inventing the concept.

Shared limits on every card: up to 3 models (kit pack, CC0, or headless Blender), up to 3 sound effects, canvas or small image textures, keyboard plus tap or click, title screen, score, game over, restart. Never: multiplayer, saves or accounts, levels built by hand, story or dialogue, inventory or shop, physics engines, complex enemy AI, cutscenes.

1. **Lane runner.** Action: switch lanes (jump allowed as the one alternate input on the same obstacle stream). Allowed: endless track, one obstacle type, one pickup, speed rises over time, distance score. Stretch: second obstacle type.
2. **Jumper.** Action: tap to flap or hop. Allowed: gaps or platforms scrolling, gravity, one hazard, score per gap. Stretch: moving gaps.
3. **Single-screen shooter.** Action: aim and fire. Allowed: fixed or slider position, one enemy type in waves, wave count rises, one projectile. Stretch: second enemy type.
4. **Arena dodger.** Action: move to dodge. Allowed: one arena, one hazard type spawning from edges, spawn rate rises, score is time alive. Stretch: one pickup.
5. **Timing tapper.** Action: press at the right moment. Allowed: one target (stack, catch, or beat), timing window that tightens, combo counter. Stretch: one visual beat cue.

## Publishing (GitHub)

- Gallery repo moves to the STEC GitHub org. `/jam-ship` keeps the fork-and-PR flow, with the gallery repo as one variable. Gallery deploys via a GitHub Action running `vercel deploy --prod` with a token from the SCAD Vercel account (org secret), not Vercel's GitHub integration. The Action triggers only on `push` to `main`, never `pull_request_target`, so fork PRs never see the token.
- Fallback (my call): if the move and Action aren't deployed and test-deployed before the dry run, the jam uses the current gallery (`nmadrid27/jam-gallery`) and the move happens after the jam. The variable makes this a one-line switch.
- Kit repo goes public (stays on Nathan's GitHub or moves to STEC; install URL is one variable). Scan history for secrets before flipping.
- Fallback: if `gh` can't work for an entry, `/jam-ship` writes `dist/<handle>.zip`; makers bring it to Nathan by AirDrop or USB stick; `facilitator/ship-from-zip.sh` opens the PR from Nathan's account.
- `/jam-ship` consent covers handle and devlog with initials; ends by offering `gh auth logout` on shared machines.
- No checks run on gallery PRs, so the fork-PR workflow approval setting stays at its default.

## Permissions

`.claude/settings.json` (committed, no secrets):

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": ["Edit", "Write", "Bash(git status)", "Bash(git diff *)", "Bash(git add *)",
              "Bash(git commit *)", "Bash(git log *)",
              "Bash(python3 -m http.server 8000)", "Bash(py -m http.server 8000)",
              "Bash(node --check *)",
              "Bash(curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/*)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.claude/settings.local.json)", "Edit(./.claude/settings.local.json)",
             "Read(./.env)", "Edit(./.env)"]
  }
}
```

The denies on `settings.local.json` keep agents from reading the key into a transcript or rewriting it. `.gitignore` gains `.claude/settings.local.json` (today it is not listed, and the companion commits with `git add -A`). Blender and `gh` calls prompt; the allow list is tuned after the dry run.

## Dry run (tonight, after build)

Nathan adds funds, creates one key and the four virtual models. Run the full day compressed on a copy of the kit, using the zombie runner as the target game: install, `/jam-start`, `/jam-plan`, build M1 to M5, `/jam-ship` to a test branch. Measure: cost per block (gateway Logs by key), whether subagent `model:` accepts the virtual model ID, tool-use failures per model, total wall time. Output: per-entry budget to set on keys, model swaps, cuts.

## Files

- New: `install.sh`, `.claude/settings.json`, `.claude/skills/jam-plan/SKILL.md`, `.claude/agents/jam-builder.md`, `.claude/agents/jam-helper.md`, `context/STARTERS.md`, `context/BUILD-PLAN.md`, `facilitator/GATEWAY.md` (Nathan's setup commands), `facilitator/ship-from-zip.sh`.
- Rewritten: `AGENTS.md`, `README.md`, `.claude/agents/jam-companion.md`, `.claude/agents/devlog.md`, `.claude/skills/jam-start/SKILL.md`, `.claude/skills/jam-ship/SKILL.md`, `devlog/DEVLOG.md`, `jam-state.md`, `.gitignore` (adds `.claude/settings.local.json`), `facilitator/CHECKLIST.md`, `JUDGING.md` (Readable code row: "One file, clear sections" becomes "Small files, clear sections").
- Updated checks: `facilitator/check-package.sh` (new required files; agent model rule allows `inherit` or `claude-code/vmc/*`; fails if any file contains a gateway-key-shaped string; fails if `.gitignore` lacks `.claude/settings.local.json`).
- Can slip: `STACK.md`, `docs/student-guide-DRAFT.md`, new `check-agents.sh` scenarios.

## Risks

- Cheap models may drive Claude Code's tools badly. Dry run; swap `jam-lead`/`jam-build` to Haiku 5.5 or Sonnet 5.5 at the gateway if so.
- Spend unknown until dry run.
- Gallery move tonight can break deploys; test-deploy after, or fall back to the current gallery (see Publishing).
- Tonight's scope is large (kit, gateway setup, gallery move, dry run). Order: kit, gateway, dry run, gallery move last.
- Students' gateway keys live on their machines; budgets and 1-day expiry contain it.

## Left to the builder

Prompt wording; template text; how `jam-builder` proves a page loads without npm; installer UX details; settings allow list after the dry run.

## AI disclosure

Drafted with Claude Code (Opus 5.5) from Nathan's direction in conversation; design decisions are Nathan's unless marked "my call". Reviewed by Nathan.
