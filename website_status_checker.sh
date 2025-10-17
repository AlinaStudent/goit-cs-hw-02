#!/usr/bin/env bash
# website_status_checker.sh
# Проверяет доступность списка сайтов и пишет результат в лог.

LOG_FILE="website_status.log"

SITES=(
  "https://google.com"
  "https://facebook.com"
  "https://twitter.com"
)

: > "$LOG_FILE"

check_site() {
  local url="$1"
  local code
  code="$(curl -L -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")"

  if [[ "$code" == "200" ]]; then
    echo "<$url> is UP" | tee -a "$LOG_FILE"
  else
    echo "<$url> is DOWN (HTTP $code)" | tee -a "$LOG_FILE"
  fi
}

echo "==== Website status check: $(date +"%Y-%m-%d %H:%M:%S") ====" >> "$LOG_FILE"

for site in "${SITES[@]}"; do
  check_site "$site"
done

echo "Результати записані в файл лога: $LOG_FILE"
