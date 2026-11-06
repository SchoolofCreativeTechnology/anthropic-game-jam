# Gateway Setup (Nathan)

Excluded from the student package. Everything runs on the SCAD Vercel account (`nmadrid-6296`, team `nmadrid-6296s-projects`, Pro) through its own CLI config, so the personal login is untouched:

```bash
alias vs='vercel --global-config ~/.vercel-scad --scope nmadrid-6296s-projects'
vs whoami            # must print nmadrid-6296
```

## Virtual models (done 2026-11-05)

The kit only names these four. Point them anywhere, any time, without touching the kit:

| Virtual model | Used by | Points at now | Fallback |
|---|---|---|---|
| `vmc/jam-guide` | companion, onboarding and plan | `deepseek/deepseek-v4.1-flash` | `anthropic/claude-haiku-5.5` |
| `vmc/jam-lead` | companion, build block | `moonshotai/kimi-k2.7-code` | `deepseek/deepseek-v4.1-flash` |
| `vmc/jam-build` | `jam-builder` subagent | `deepseek/deepseek-v4.1-flash` | `anthropic/claude-haiku-5.5` |
| `vmc/jam-cheap` | `jam-helper`, devlog terminal | `anthropic/claude-haiku-5.5` (was `zai/glm-4.7-flash`) | |

```bash
vs ai-gateway virtual-models list
vs ai-gateway virtual-models edit jam-lead --model anthropic/claude-haiku-5.5   # swap mid-jam
```

Gateway list prices per million tokens (input/output, 2026-11-05): deepseek-v4.1-flash $0.30/$1.20, kimi-k2.7-code $0.95/$4.00, glm-4.7-flash $0.07/$0.40, claude-haiku-5.5 $0.10/$0.50, claude-sonnet-5.5 $2/$10. Check before the jam: `curl -s https://ai-gateway.vercel.sh/v1/models`.

## Keys (one per entry)

```bash
bash facilitator/make-keys.sh 20 <dollars-per-key>     # writes dist/keys.txt (mode 600)
```

Print `dist/keys.txt` on slips, then delete it. The CLI's shortest expiry is `7d`, so keys don't lapse at 18:00; revoke them after judging:

```bash
bash facilitator/revoke-keys.sh          # lists jam-entry-* keys
bash facilitator/revoke-keys.sh --yes    # removes them
```

A leaked key spends at most its own limit. Spend shows per key under AI Gateway, Logs and Usage, in the SCAD dashboard.

## Team ceiling

```bash
vs ai-gateway budgets --help        # set a team budget as the ceiling for the bucket
```

The team model allowlist (only the four targets and fallbacks) is set in the dashboard: AI Gateway, Settings. Note: the "AI Gateway v0 Key" on this team has no budget; remove or cap it if v0 isn't used.

## Installer

Students run, from the folder where they want the kit:

```bash
curl -fsSL https://raw.githubusercontent.com/SchoolofCreativeTechnology/anthropic-game-jam/main/install.sh | bash
```

Dry run against a local checkout (no download, key from env):

```bash
cd "$(mktemp -d)" && JAM_SOURCE=~/projects/anthropic-game-jam-git JAM_GATEWAY_KEY="$(cat ~/.jam-dryrun-secrets/key)" bash ~/projects/anthropic-game-jam-git/install.sh
```
