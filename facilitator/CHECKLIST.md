# Facilitator Checklist

Excluded from the student package.

## Before the jam (by 2026-11-05)

- [ ] Headcount: ____ (sets how tight the 3:30 to 4:00 merge window is)
- [ ] SCAD publishing/consent policy checked; any minors? If so, confirm handle + consent prompt is enough
- [ ] Every student has a GitHub account
- [ ] Onboarding session: Claude Code installed, `gh` installed, `gh auth login` done
  - macOS: `brew install gh`
  - Windows: `winget install GitHub.cli`, Git for Windows (Git Bash) installed
- [ ] Python 3 or Node present (local preview)
- [ ] Every student's Claude plan includes Opus 5.5
- [x] `jam-gallery` live on Vercel (https://jam-gallery.vercel.app, team "Nathan Madrid's projects", auto-deploys on push to main); PR check workflow green on `main`
- [ ] Fork-PR workflow approval: GitHub holds checks on PRs from first-time contributors. In `jam-gallery` Settings, Actions, General, "Approval for running fork pull request workflows", choose the least strict option, or plan to click "Approve and run" on each PR during the merge window
- [ ] Build the zip: `bash facilitator/check-package.sh && bash facilitator/package.sh`
- [ ] Dry run done on macOS and Windows (see plan Task 8)

## During

- 0:00 Hand out `dist/anthropic-game-jam.zip`
- Before 1:15: pair students for Playtest 1; plan different partners for Playtest 2 (2:15). Odd count: one group of three
- 1:15 and 2:15 Playtests, about 10 minutes each: call the swap; each student plays the partner's game ~3 minutes, maker silent, then "Tell me the story of what just happened" and "Where were you bored or stuck?"; then swap roles. Walk the room and stop makers from explaining
- Watch for look work before 2:15: plain shapes until Playtest 2
- At playtests and before ship: remind students to keep `devlog/AI-USE-LOG.md` updated (not only the end-of-jam disclosure in `DEVLOG.md`)
- From 3:30 merge PRs: `gh pr list -R nmadrid27/jam-gallery`, check the PR check is green, `gh pr merge <n> -R nmadrid27/jam-gallery --squash`
- Confirm each game plays at the gallery URL

## After

- Personal Vercel walkthroughs for students who want their own URL
