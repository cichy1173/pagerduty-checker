#!/bin/bash
set -xeuo pipefail

# check if key is set
if [ -z "$API_KEY" ]; then
  echo "You had to add API key"
  exit 1
fi

# Initialize previous incidents variable
PREVIOUS_INCIDENTS=""

while true; do
  # Check triggered alarms
  INCIDENTS=$(curl -s -H "Authorization: Token token=$API_KEY" -H "Accept: application/vnd.pagerduty+json;version=2" \
    "https://api.pagerduty.com/incidents?statuses[]=triggered&user_ids[]=$USER_ID" | jq -r '.incidents')

  if [ "$INCIDENTS" == "[]" ]; then
    echo "You do not have any triggered alarms"
  else
    # Convert incidents to a string for comparison
    INCIDENT_DETAILS=$(echo "$INCIDENTS" | jq -r '.[] | "\(.id): \(.summary)"')
    
    # Check if the current incidents are the same as the previous ones
    if [ "$INCIDENT_DETAILS" == "$PREVIOUS_INCIDENTS" ]; then
      echo "No new alarms detected, skipping notification."
    else
      echo "You have triggered alarms:"
      echo "$INCIDENT_DETAILS"
      
      # Send alarm info to Home Assistant
      curl -X POST -H "Content-Type: application/json" -d '{"incident_details": "'"$INCIDENT_DETAILS"'"}' "$HOME_ASSISTANT_URL"
      
      # Update the previous incidents variable
      PREVIOUS_INCIDENTS="$INCIDENT_DETAILS"
    fi
  fi

  # Wait for next scan
  sleep $SLEEP_TIME
done