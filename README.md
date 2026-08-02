# deadmans-switch

`heartbeat.txt` gets a fresh timestamp pushed every 2 days by a systemd user timer on the laptop. A scheduled GitHub Action checks the age of the last commit to that file daily. If it's been 4+ days since the last heartbeat, the action makes every private repo under kyotodesertfox public.

## Setup required (one-time, manual)

1. Create a fine-grained personal access token with **Administration: write** on all target repos (or a classic PAT with `repo` scope).
2. Add it as a repository secret named `DEADMAN_PAT` in this repo's Settings > Secrets and variables > Actions.

## Testing

Run the workflow manually via Actions tab > "heartbeat check" > "Run workflow", `dry_run` defaults to true and only lists what would change without flipping anything.
