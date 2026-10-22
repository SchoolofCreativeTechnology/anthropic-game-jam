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
| First build | 0:45 to 1:15 | Something playable, however rough |
| Iterate | 1:15 to 3:15 | Play, react, change |
| Ship | 3:15 to 4:00 | `/jam-ship` by 3:30 so it can go live |

The start time lives in `jam-state.md`.

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
- `devlog/DEVLOG.md`: timestamped entries, reflection, AI use disclosure.
- `devlog/RUNBOOK.md`: how to run and ship this game.
- `jam-state.md`: handle, start time, phase, repo URL, gallery PR.
- `meta.json`: title, handle, description, asset credits. Shipped to the gallery.
