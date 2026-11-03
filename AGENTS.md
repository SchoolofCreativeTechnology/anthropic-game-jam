# Anthropic Game Jam

A 4-hour jam: one student, one browser game, built with three.js and Claude Code. The student directs; Claude builds. The game idea, the decisions, and the record of those decisions belong to the student.

## Sessions

- **Build terminal:** `claude --agent jam-companion`. Builds the game and coaches. Run `/jam-start` first, `/jam-ship` at the end.
- **Devlog terminal:** a second terminal in the same folder, `claude --agent devlog`. The student tells it what happened and why; it writes that down.

Pick Opus 5.5 with `/model` in each terminal.

## Clock

| Phase | Time | Goal |
|---|---|---|
| Concept + Context | 0:00 to 0:45 | Fill `context/` in your own words |
| First build | 0:45 to 1:15 | The one action playable with plain shapes |
| **Playtest 1** | 1:15 | A classmate plays; you watch in silence |
| Feel | 1:15 to 2:15 | Tune the one action; plain shapes only |
| **Playtest 2** | 2:15 | A new classmate plays; you watch in silence |
| Look | 2:15 to 3:15 | Now build the look from `LOOK.md` and your references |
| Ship | 3:15 to 4:00 | `/jam-ship` by 3:30 so it can go live |

The start time lives in `jam-state.md`. `Phase` is one of `concept`, `first-build`, `feel`, `look`, `ship`, `shipped`.

## Playtests

The maker can't see their own game's problems; a fresh player can. At each playtest, a classmate plays for about 3 minutes with **no explanation**. The maker says nothing: no tips, no laughing, no "oh, that's a bug." The build terminal stays quiet too. Afterward the maker asks only "Tell me the story of what just happened," then "Where were you bored or stuck?" Never "What should I change?": the maker decides the change. The story goes to the devlog before anything gets changed.

## Iterating: one change per loop

Each loop is one change. Before building it, the student says what they expect it to do; after playing it, what actually happened. The devlog records both. Small, single changes are how you learn what works.

## The jam constraint

Every game is built around **one repeatable core action** (jump, dodge, run, aim, time a tap), like Subway Surfers, Flappy Bird, or the Chrome dino. There are only 4 hours, so build one action first and make it feel good; any second move (Subway Surfers' roll on top of its jump) waits on the `SCOPE.md` Stretch list until the first one is playable. This constraint is Nathan's, not Claude's: state it, and hold the game to it, but the student still chooses the action, the world, and the look.

## Rules for every agent in this repo

1. **The idea is the student's.** Never invent the game concept or write content into `context/` the student did not say. You may offer up to three one-line seeds or constraints when asked, then step back.
2. **File ownership.** The build session owns game code (`index.html`, `main.js`, other `.js`/`.css`, assets, `meta.json`) and `context/`. The devlog session owns `devlog/`. Never write the other's files.
3. **No build step.** Plain HTML and ES modules. three.js comes from the import map in `index.html`, pinned to 0.186.1. No `npm install`.
4. **Assets.** Every downloaded file goes in `meta.json` `assets` with its `source` and `license`. Every file Claude creates (texture, model, sound) goes in `ai_assets`.
5. **Preview locally** with a server, never by double-clicking `index.html`:
   - macOS: `python3 -m http.server 8000`
   - Windows (Git Bash): `py -m http.server 8000` (or `python -m http.server 8000`)
   - Either, with Node: `npx serve -l 8000`
   Then open http://localhost:8000.
6. **Mac and Windows.** Students use both. Give the Windows (Git Bash) variant whenever a command differs.
7. **No secrets** in any file.

## Files

- `context/`: CONCEPT, MECHANIC, LOOK, SCOPE. The brief for every build.
- `devlog/DEVLOG.md`: timestamped entries, reflection, AI use disclosure (summary).
- `devlog/AI-USE-LOG.md`: running log of each AI use during the jam (tool, prompt, outcome, assets).
- `devlog/RUNBOOK.md`: how to run and ship this game.
- `jam-state.md`: handle, start time, phase, repo URL, gallery PR.
- `meta.json`: title, handle, description, asset credits. Shipped to the gallery.

Gallery: https://jam-gallery.vercel.app (source: https://github.com/nmadrid27/jam-gallery).
