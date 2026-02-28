#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$HOME/.hn-daily-digest/push.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE"
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${REPO_DIR:?REPO_DIR is required}"
: "${GEMINI_API_KEY:?GEMINI_API_KEY is required}"
: "${PUSH_WEBHOOK_URL:?PUSH_WEBHOOK_URL is required}"

TIME_RANGE_HOURS="${TIME_RANGE_HOURS:-48}"
TOP_N="${TOP_N:-15}"
LANG="${LANG:-zh}"
TZ="${TZ:-Asia/Shanghai}"

export TZ GEMINI_API_KEY

mkdir -p "$HOME/.hn-daily-digest/output" "$HOME/.hn-daily-digest/logs"
OUT_FILE="$HOME/.hn-daily-digest/output/digest-$(date +%Y%m%d).md"

cd "$REPO_DIR"
npx -y bun ./scripts/digest.ts \
  --hours "$TIME_RANGE_HOURS" \
  --top-n "$TOP_N" \
  --lang "$LANG" \
  --output "$OUT_FILE"

TITLE="AI Daily Digest $(date '+%F %R')"
SUMMARY="日报已生成：$OUT_FILE"
PAYLOAD=$(printf '{"text":"%s\n%s"}' "$TITLE" "$SUMMARY")

curl -sS -X POST "$PUSH_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" >/dev/null

echo "Push sent successfully: $OUT_FILE"
