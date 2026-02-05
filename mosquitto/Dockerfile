FROM eclipse-mosquitto:2

RUN apk add --no-cache jq

COPY entrypoint.sh /mosquitto/entrypoint.sh
RUN chmod +x /mosquitto/entrypoint.sh

ENTRYPOINT ["/mosquitto/entrypoint.sh"]
