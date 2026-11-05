---
name: jam-plan
description: Use in the Anthropic Game Jam plan block (11:00 to 12:30), when the makers type /jam-plan or jam-state.md Phase is onboarding or plan. Walks them through research, picking a starter card, writing the context kit in their own words, and approving a one-page BUILD-PLAN.md before any game code exists.
---

# Jam Plan

The plan block runs **11:00 to 12:30** (break at 12:30, build from 12:45). The makers think and decide; you ask, find, and write down. No game code in this block.

Set `Phase: plan` in `jam-state.md`. Keep moving: if a step runs long, write what they have and go on; they can revisit it.

## 1. Research (about 20 min)

- Show the five cards in `context/STARTERS.md` in one short list (name and action only).
- Offer the showcase at http://localhost:8000/demos/zombie-runner-showcase/ (with the preview server running). It shows what a finished card looks like; it's not a template.
- Ask what games they love that use one action. Look at `context/references/`; for each file, ask what it's there for and note their answer for LOOK. If it's empty, say they can drop screenshots or links (`links.md`) in any time. Images and links only.

## 2. Ideate (about 25 min)

- They pick **one card**. Write it to `jam-state.md` `Card:`.
- Then ask, one at a time: the **world** (where is this?), the **character** (who or what does the player control?), and the **twist** (what makes it theirs?).
- If they're stuck: offer up to **three one-line seeds within their card**, ask which sparks something and what they'd change, then step back. Never develop, rank, or pick for them.
- Hold the card: if an idea needs something off the Allowed list, say so in one line and offer Stretch. Their call.

## 3. Context kit (about 25 min)

Go through `context/CONCEPT.md`, `MECHANIC.md`, `LOOK.md`, `SCOPE.md`, one section at a time:

- Ask the section's question in your own plain words. Point at the example only if they're unsure what size of answer fits.
- Write their answer after the `>`, in their words. Tidy spelling; don't upgrade the idea or add detail.
- MECHANIC's one action is the card's action. SCOPE's In list is drawn from the card's Allowed list; Stretch is the card's Stretch plus anything they asked for that's off the list.
- On a team, if members disagree, ask them to decide and note whose call it was.
- Vague answer: one follow-up, then write what they said and move on.

Commit: `git add -A -- . ':!devlog' && git commit -m "docs: context kit"`.

## 4. Build plan (about 20 min)

Draft `context/BUILD-PLAN.md` from the context kit and the card, using the template's sections. Rules for the draft:

- Every line comes from their kit or their card. Don't add features, levels, or look ideas they didn't say.
- **Done means:** 3 to 5 checks they can play ("I can switch lanes with A/D", "hitting a car ends the run").
- **Milestones:** M1 to M5 with the times from `AGENTS.md`; ask them to say "done when" for each in their words.
- **Tasks:** small tasks per milestone, each with the files it touches, owner (`jam-builder` for code, `jam-helper` for credits, Blender scripts, and checks), and a check. Tasks in the same milestone that run in parallel must touch different files.
- **File map:** `index.html`, `main.js`, `tuning.js`, plus a few small modules (for example `player.js`, `spawner.js`, `ui.js`).
- **Tuning knobs:** the numbers they'll want to tune (speed, gap, spawn rate, timing window).
- **Assets plan:** within the card's limits (up to 3 models, up to 3 sounds).
- **Cut list** and **Stretch**.

Read it back to them **section by section**. They edit; you apply only their edits. When they approve, write their initials and the time on the **Approved by** line, set `Phase: m1` in `jam-state.md`, commit (`git add -A -- . ':!devlog' && git commit -m "docs: build plan approved"`), and tell them:

1. Tell the devlog terminal what you chose and why (card, world, twist).
2. Break at 12:30. At **12:45**, run `/model claude-code/vmc/jam-lead` in this terminal, then say "build M1".
