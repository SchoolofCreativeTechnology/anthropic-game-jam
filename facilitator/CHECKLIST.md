# Facilitator Checklist

Excluded from the student package. Gateway commands: [GATEWAY.md](GATEWAY.md).

## Tonight (2026-11-05)

- [x] Kit repo public: https://github.com/SchoolofCreativeTechnology/anthropic-game-jam
- [x] Gallery repo public: https://github.com/SchoolofCreativeTechnology/jam-gallery
- [x] Gallery live on the SCAD Vercel team: https://stec-jam-gallery.vercel.app
- [ ] Gallery auto-deploys on merge: install the Vercel GitHub app on the org, then connect the repo in the `stec-jam-gallery` project settings (Git). Until then, after merging run `vercel --global-config ~/.vercel-scad --scope nmadrid-6296s-projects deploy --prod` from a clone of the gallery's `main`.
- [x] Virtual models `vmc/jam-guide`, `jam-lead`, `jam-build`, `jam-cheap` created
- [ ] Team budget (ceiling) and model allowlist set (GATEWAY.md)
- [ ] Dry run done (zombie runner), per-entry budget decided
- [ ] Keys made: `bash facilitator/make-keys.sh <entries> <dollars>`; slips printed; `dist/keys.txt` deleted
- [ ] Gallery repo, Settings, Actions, General: "Approval for running fork pull request workflows" set to the least strict option (or approve each PR's run in the merge window)
- [ ] Kit PR merged to `main` (the installer downloads `main`)
- [ ] SCAD publishing and consent policy checked; any minors?

## 10:00 onboarding

- Hand out key slips (one per entry). Teams: one machine, one slip.
- Students run the install command from the README, then `claude --agent jam-companion` and `/jam-start`.
- Common fixes: `gh auth login`; reopen Git Bash after `winget` installs; `rm .claude/settings.local.json` and rerun the installer for a mistyped key (the installer refuses an existing folder: move it first).

## During

- **11:00** call the plan block (`/jam-plan`). **12:30** break. **12:45** remind everyone: `/model claude-code/vmc/jam-lead`, then "build M1".
- Pair entries for Playtest 1 (after M2, about 1:45) and Playtest 2 (after M3, about 2:30), different partners each time. Maker silent; "Tell me the story of what just happened" and "Where were you bored or stuck?"
- Watch spend per key in the SCAD dashboard (AI Gateway, Logs). Swap a virtual model with `virtual-models edit` if one misbehaves.
- **3:15 PM** remind the `JUDGING.md` self-check. **3:30 PM** ship cutoff.
- From **3:30 PM** merge PRs: `gh pr list -R SchoolofCreativeTechnology/jam-gallery`, check the PR check is green, `gh pr merge <n> -R SchoolofCreativeTechnology/jam-gallery --squash` (as `nmadrid2797`). Zip fallbacks: `bash facilitator/ship-from-zip.sh <handle>.zip`.
- Deploy if auto-deploy isn't connected (see above). Confirm each game plays at the gallery URL.

## After

- `bash facilitator/revoke-keys.sh --yes`
- Personal Vercel walkthroughs for students who want their own URL
