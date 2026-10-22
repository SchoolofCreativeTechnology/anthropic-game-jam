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
- [ ] `jam-gallery` live on Vercel; PR check workflow green on `main`
- [ ] Build the zip: `bash facilitator/check-package.sh && bash facilitator/package.sh`
- [ ] Dry run done on macOS and Windows (see plan Task 8)

## During

- 0:00 Hand out `dist/anthropic-game-jam.zip`
- From 3:30 merge PRs: `gh pr list -R nmadrid27/jam-gallery`, check the PR check is green, `gh pr merge <n> -R nmadrid27/jam-gallery --squash`
- Confirm each game plays at the gallery URL

## After

- Personal Vercel walkthroughs for students who want their own URL
