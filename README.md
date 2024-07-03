# Pagerduty triggered alarm checker

This script checks if you have any triggered alarms. If yes this information is sent to Home Assistant Webhook. 

## Quick start

1. Use docker compose
2. Set ENV const:
    - `API_KEY` is PagerDuty API key tied to your account
    - `HOME_ASSISTANT_URL` is Home Assistant Webhook URL that can trigger an automation
    - `USER_ID` user id that can be found on address bar
    - `SLEEP_TIME` means how often script will refresh. It shouldn't be less than 15/20 seconds. 


## Docker Compose

```yaml
version: "3.3"
services:
  pagerduty-checker:
    environment:
      - API_KEY=<pagerduty_api_key>
      - HOME_ASSISTANT_URL=<home_assistant_webhook_url>
      - USER_ID="<user_id>"
      - SLEEP_TIME=2
    container_name: pagerduty-checker
    restart: unless-stopped
    image: ghcr.io/cichy1173/pagerduty_checker:latest
```
