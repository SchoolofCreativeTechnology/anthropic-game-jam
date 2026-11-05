# Anthropic Game Jam

Build a browser game during the jam (**11:00 AM to 4:00 PM**) with three.js and Claude Code. You direct; Claude builds.

How the pieces fit together: [STACK.md](STACK.md).

## The one rule

Your game is built around **one action the player repeats**: jump, dodge, run, aim, time a tap. Think Subway Surfers (switch lanes), Flappy Bird (tap to flap), or the Chrome dino (jump). The jam is short: pick one action, get it playable, then make it feel good. Extra moves go on your Stretch list. The idea, the world, and the look are yours.

## Before you start

- A GitHub account and the GitHub CLI (macOS: `brew install gh`; Windows: `winget install GitHub.cli`), logged in: `gh auth login`
- Claude Code installed and logged in
- Python 3 for the local preview (macOS: `xcode-select --install`; Windows: `winget install Python.Python.3.12`)
- Windows: run everything in **Git Bash**
- **References:** collect images (screenshots, photos, sketches) and links (in `links.md`) that show the look and feel you want, and drop them in `context/references/`. Claude builds from them; they never ship.

## Start

```bash
git clone https://github.com/SchoolofCreativeTechnology/anthropic-game-jam
cd anthropic-game-jam
claude --agent jam-companion
```

In Claude, run `/model` and choose **Opus 5.5**, then type:

```
/jam-start
```

It checks your setup, can create your own private GitHub repo, and walks you through describing your game.

## Playtests

At **1:15 PM** and **2:15 PM** (official jam clock, even if you started late) you'll swap with a classmate and play each other's games. When someone plays yours: say nothing, just watch. Then ask "Tell me the story of what just happened." Tell your devlog what you saw before you change anything.

Until the second playtest, keep the game in plain shapes and get the one action feeling right. The look comes after **2:15 PM**.

## Your devlog

Open a **second terminal** in the same folder:

```bash
claude --agent devlog
```

Tell it what you tried, what broke, and what you decided. It keeps your devlog in your words and updates `devlog/AI-USE-LOG.md` when you use Claude or any other AI (generators, sound tools, and the like). Log each use as it happens so your end-of-jam disclosure is accurate.

## See your game

| macOS | Windows (Git Bash) |
|---|---|
| `python3 -m http.server 8000` | `py -m http.server 8000` |

Open http://localhost:8000. Don't double-click `index.html`; it won't load.

## Ship

In the build terminal: `/jam-ship`. Aim for **3:30 PM** so your game is live by **4:00 PM** at https://jam-gallery.vercel.app.

## Example demo (optional)

The repo includes a finished showcase game, [Zombie Runner](demos/zombie-runner-showcase/), to show what is possible in a jam—not a template to copy. Live demo: https://zombie-runner-showcase.vercel.app. From that folder, run a local server (same as above) and open the page it serves.

For a draft of what AI or automated evaluation might look at (the rubric is **not finalized**), see [JUDGING.md](JUDGING.md).
