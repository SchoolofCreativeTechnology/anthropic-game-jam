# Anthropic Game Jam

Build a browser game in 4 hours with three.js and Claude Code. You direct; Claude builds.

How the pieces fit together: [STACK.md](STACK.md).

## The one rule

Your game is built around **one action the player repeats**: jump, dodge, run, aim, time a tap. Think Subway Surfers (switch lanes), Flappy Bird (tap to flap), or the Chrome dino (jump). You have 4 hours: pick one action, get it playable, then make it feel good. Extra moves go on your Stretch list. The idea, the world, and the look are yours.

## Before you start

- A GitHub account, logged in: `gh auth login`
- Claude Code installed and logged in
- Windows: run everything in **Git Bash**
- **References:** collect images (screenshots, photos, sketches) and links (in `links.md`) that show the look and feel you want, and drop them in `context/references/`. Claude builds from them; they never ship.

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

## Playtests

At **1:15** and **2:15** you'll swap with a classmate and play each other's games. When someone plays yours: say nothing, just watch. Then ask "Tell me the story of what just happened." Tell your devlog what you saw before you change anything.

Until the second playtest, keep the game in plain shapes and get the one action feeling right. The look comes after.

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
