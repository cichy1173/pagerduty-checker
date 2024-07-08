#!/bin/bash
set -xeuo pipefail

# check if key is set
if [ -z "$API_KEY" ]; then
  echo "You had to add API key"
  exit 1
fi

while true; do
  # Check triggered alarms
  INCIDENTS=$(curl -s -H "Authorization: Token token=$API_KEY" -H "Accept: application/vnd.pagerduty+json;version=2" \
    "https://api.pagerduty.com/incidents?statuses[]=triggered&user_ids[]=$USER_ID" | jq -r '.incidents')

  if [ "$INCIDENTS" == "[]" ]; then
    echo "You do not have any triggered alarms"
  else
    echo "You have triggered alarms:"
    INCIDENT_DETAILS=$(echo "$INCIDENTS" | jq -r '.[] | "\(.id): \(.summary)"')
    echo "$INCIDENT_DETAILS"
    # Send alarm info to Home Assistant
    curl -X POST -H "Content-Type: application/json" -d '{"incident_details": "$INCIDENT_DETAILS"}' "$HOME_ASSISTANT_URL"
  fi

  # Wait for next scan
  sleep $SLEEP_TIME
done