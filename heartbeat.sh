#!/bin/bash
# ~/.dms/heartbeat.sh
#
# One job: push a heartbeat. Nothing else.
#
# No retry loop. The timer runs daily and the switch threshold is seven days,
# so six consecutive failures have to happen before anything is at stake.
# In-script retry would only duplicate that and hide which day actually failed.
#
# On failure it pushes an ntfy notification, because a heartbeat that stops is
# otherwise silent from this side - and silence is exactly what the switch
# interprets as absence. GitHub's own failure email covers the workflow half.
#
# Exits non-zero if the push did not succeed, so systemd records it and
# `journalctl --user -t dms-heartbeat` shows which days landed.

set -uo pipefail
cd "$(dirname "$0")" || exit 1

NTFY=https://ntfy.sh/lw-hb-x8q2mn

NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "$NOW" > heartbeat.txt

git add heartbeat.txt
git commit -q -m "heartbeat $NOW" || true

if git push -q origin main; then
  echo "$(date -Is) OK $NOW"
  exit 0
fi

echo "$(date -Is) FAILED $NOW - push did not succeed"

# Never let the notifier affect the outcome: short timeout, errors swallowed.
# The payload stays uninformative because ntfy topics are public - the topic
# name is the only secret, so the message must not add to it.
curl -s -m 15 \
  -H "Title: hb fail" \
  -H "Priority: high" \
  -H "Tags: warning" \
  -d "push failed $NOW" \
  "$NTFY" >/dev/null 2>&1 || true

exit 1
