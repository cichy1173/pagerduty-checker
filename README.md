# Pagerduty triggered alarm checker

This script checks if you have any triggered alarms. If yes this information is sent to Home Assistant Webhook. 

## Quick start

1. Use docker compose
2. Set ENV const:
    - `API_KEY` is PagerDuty API key tied to your account
    - `HOME_ASSISTANT_URL` is Home Assistant Webhook URL that can trigger an automation
    - `SLEEP_TIME` means how often script will refresh. It shouldn't be less than 15/20 seconds. 


## Docker Compose

```yaml
version: "3.3"
services:
  pagerduty-checker:
    environment:
      - API_KEY=""
      - HOME_ASSISTANT_URL=""
      - SLEEP_TIME=45
    container_name: pagerduty-checker
    image: pagerduty-checker:latest
```