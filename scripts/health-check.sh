#!/usr/bin/env bash
#
# Daily health check for Zuri Market's backend.
# Run manually to test, then scheduled via cron (see CRON_SETUP.md).
#
# set -euo pipefail:
#   -e : exit immediately if any command fails
#   -u : treat unset variables as an error, not silent empty strings
#   -o pipefail : a pipeline fails if ANY command in it fails, not just the last
# This is standard defensive Bash — it turns silent, confusing failures into
# loud, obvious ones.
set -euo pipefail

APP_URL="${APP_URL:-http://localhost:5000/api/store}"
REPORT_FILE="${REPORT_FILE:-$(dirname "$0")/health-report.log}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# curl -o /dev/null throws away the response body (we only care about status).
# -w "%{http_code}" prints just the HTTP status code.
# --max-time 10 : never hang forever waiting on a dead server.
# `|| echo "000"` : if curl itself fails (server unreachable, DNS fails, etc.)
# rather than returning a bad HTTP code, we still record SOMETHING instead of
# the whole script crashing (which -e would otherwise cause).
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$APP_URL" || echo "000")

# >> appends a new line and keeps everything already in the file.
# A single > would OVERWRITE the file every run — the #1 mistake the guide
# warns about (Section 9: "the report file only ever shows one result").
if [ "$HTTP_STATUS" = "200" ]; then
  echo "${TIMESTAMP} | OK   | HTTP ${HTTP_STATUS} | ${APP_URL}" >> "$REPORT_FILE"
else
  echo "${TIMESTAMP} | FAIL | HTTP ${HTTP_STATUS} | ${APP_URL}" >> "$REPORT_FILE"
fi
