# What you can build in the jam

You direct. Claude builds. In the jam with Claude Code you can ship a small game that feels great to play. You can't ship a big one. This page tells you which is which, so you can plan around it.

For a draft checklist of what AI or automated judging might look at (the rubric is **not finalized**), see [JUDGING.md](../JUDGING.md) in the kit root.

## The one rule
Your game is built around **one action you repeat**: jump, dodge, aim, time a tap. Get that action feeling good first. Everything else goes on your Stretch list.

## You can build this
- A polished game around your one action, with 3 to 5 levels that get harder, a score, game over, and restart.
- Game feel: screen shake, hit flashes, particles, simple sound effects.
- One or two kinds of obstacle or enemy.
- Art made in code (shapes, colors, lighting, fog) or taken from the kit's art folder.
- Keyboard controls, plus tap and swipe on a phone.

## You can build this with extra effort
- Animated 3D characters from the kit (run, jump, and hit animations).
- A stylized 3D look with toon shading and a glow effect. Warning: it slows the game down, so test it on a weak laptop.
- A 2D game with scrolling layered backgrounds, using a pixel art pack from the kit.
- Your own generated art, if the jam allows it. See the next section.

## Using AI tools to make art
You may use an image or 3D generator for assets, if the jam rules allow it. A few rules keep it from eating your jam:
- **Time-box it.** Spend 20 minutes at most on one kind of asset, such as a background, a character, or a texture. Then move on.
- **Make one thing, not a set.** One good background beats five that don't match.
- **Use simple file types.** Use PNG for images and GLB for 3D models. Keep each file small.
- **Know the limits.** Generated 3D models are usually still statues with no animation. Generated 2D characters rarely match from one frame to the next, so animating them is hard.
- **Keep a fallback.** Always keep the kit art in your game, so a bad generation never blocks you.
- **Write it down.** Log each use in `devlog/AI-USE-LOG.md` as you go (the devlog agent can write rows in your words). If a tool's license bars use in a game, do not use its output.

## You can't build this in the jam
- Hand-drawn or hand-modeled characters, or rigging them to animate.
- Pro-quality pixel art.
- Multiplayer, saved progress, accounts, or leaderboards.
- Big open worlds, or enemies with complex AI.
- Ragdolls, stacking, or other heavy physics.
- Original polished music.

If your idea needs one of these, shrink it. Put the big version on your Stretch list.

## How to spend the jam

Official clock **11:00 AM to 4:00 PM**. If you start late, playtests and ship still use these times.

| Clock | Goal |
|---|---|
| 11:00 to 11:45 | Run `/jam-start`. Fill `context/` and pick your one action. |
| 11:45 to 12:30 | First build: the action playable in plain shapes. |
| **1:15 PM playtest** | Is the one action fun? Fix the feel, not the art. |
| 12:30 to 2:15 PM | Feel: tune the action, plain shapes only. |
| **2:15 PM playtest** | Fresh player. Cut anything that breaks. |
| 2:15 PM to 3:15 PM | Look: art, textures, polish from `LOOK.md`. |
| 3:15 PM | Self-check against [JUDGING.md](../JUDGING.md). Freeze new features. |
| **3:30 PM** | Run `/jam-ship`. |
| 3:30 to 4:00 PM | Gallery time: play each other's games. |

## Things that go wrong
- **Don't double-click `index.html`.** Serve the folder with `python3 -m http.server 8000 --bind 127.0.0.1` and open localhost:8000.
- **File names are case-sensitive on the gallery host.** `Zombie.glb` and `zombie.glb` are different files there.
- **Sound starts only after the first click or key press.**
- **Glow and shadow effects can make a game choppy.** Add a way to turn them off.
- **Playtest early.** One stray line can silently break a feature, so play after every change.
- **Scope creep is the usual killer.** A second mechanic, a shop, or a story goes on the Stretch list.

## Remember
A small game that feels great beats a big game that almost works. Get something ugly but playable before the first playtest. Then make it feel good. Then make it look good. We ship at 3:30 no matter what.
