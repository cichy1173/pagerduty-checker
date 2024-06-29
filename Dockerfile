FROM alpine:latest

RUN apk add --no-cache bash curl jq

RUN mkdir -p /usr/local/bin

COPY check_pagerduty_alarms.sh /usr/local/bin/check_pagerduty_alarms.sh


RUN chmod +x /usr/local/bin/check_pagerduty_alarms.sh

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]