# Anthropic Game Jam

Build a browser game in 4 hours with three.js and Claude Code. You direct; Claude builds.

## Before you start

- A GitHub account, logged in: `gh auth login`
- Claude Code installed and logged in
- Windows: run everything in **Git Bash**

## Start

```bash
cd anthropic-game-jam
claude --agent jam-companion
```

In Claude, run `/model` and choose **Opus 5.5**, then type:

```
/jam-start
```

It checks your setup, can create your own private GitHub repo, and walks you through describing your game.

## Your devlog

Open a **second terminal** in the same folder:

```bash
claude --agent devlog
```

Tell it what you tried, what broke, and what you decided. It keeps your devlog in your words.

## See your game

| macOS | Windows (Git Bash) |
|---|---|
| `python3 -m http.server 8000` | `py -m http.server 8000` |

Open http://localhost:8000. Don't double-click `index.html`; it won't load.

## Ship

In the build terminal: `/jam-ship`. Aim for 3:30 so your game is live by 4:00 at https://jam-gallery.vercel.app.
