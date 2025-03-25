#!/bin/bash
set -xeuo pipefail

# Check if API key is set
if [ -z "$API_KEY" ]; then
  echo "You must add an API key"
  exit 1
fi

# Initialize previous incidents variable
declare -A PREVIOUS_INCIDENTS

while true; do
  # Check triggered alarms
  INCIDENTS=$(curl -s -H "Authorization: Token token=$API_KEY" -H "Accept: application/vnd.pagerduty+json;version=2" \
    "https://api.pagerduty.com/incidents?statuses[]=triggered&user_ids[]=$USER_ID" | jq -r '.incidents[] | .id')

  for INCIDENT_ID in $INCIDENTS; do
    # Get incident details
    INCIDENT_DETAILS=$(curl -s -H "Authorization: Token token=$API_KEY" -H "Accept: application/vnd.pagerduty+json;version=2" \
      "https://api.pagerduty.com/incidents/$INCIDENT_ID" | jq -r '.incident.summary')

    # Check if the incident is new
    if [ -z "${PREVIOUS_INCIDENTS[$INCIDENT_ID]}" ]; then
      echo "New alarm detected: $INCIDENT_ID - $INCIDENT_DETAILS"
      
      # Send alarm info to Home Assistant
      curl -X POST -H "Content-Type: application/json" -d '{"incident_id": "'"$INCIDENT_ID"'", "incident_details": "'"$INCIDENT_DETAILS"'"}' "$HOME_ASSISTANT_URL"
      
      # Update the previous incidents variable
      PREVIOUS_INCIDENTS[$INCIDENT_ID]=$INCIDENT_DETAILS
    fi
  done

  # Remove resolved incidents from previous incidents
  for INCIDENT_ID in "${!PREVIOUS_INCIDENTS[@]}"; do
    if ! echo "$INCIDENTS" | grep -q "$INCIDENT_ID"; then
      unset "PREVIOUS_INCIDENTS[$INCIDENT_ID]"
    fi
  done

  # Wait for next scan
  sleep $SLEEP_TIME
done
