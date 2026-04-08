FROM node:20-alpine

RUN apk add --no-cache mosquitto mosquitto-clients

WORKDIR /app

COPY package.json tsconfig.json ./
COPY src ./src
COPY docker ./docker

RUN npm install && npm run build && npm prune --omit=dev

RUN chmod +x /app/docker/entrypoint.sh \
    && mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log

ENV MQTT_HOST=0.0.0.0 \
    MQTT_PORT=1883 \
    MQTT_ALLOW_ANONYMOUS=false \
    MQTT_PERSISTENCE=true \
    MQTT_PERSISTENCE_LOCATION=/mosquitto/data/ \
    MQTT_LOG_DEST=stdout \
    MQTT_TOPIC_PREFIX=piphi \
    MQTT_CONFIG_OUTPUT=/mosquitto/config/mosquitto.conf \
    MQTT_PASSWORD_FILE=/mosquitto/config/passwordfile

EXPOSE 1883

VOLUME ["/mosquitto/config", "/mosquitto/data", "/mosquitto/log"]

ENTRYPOINT ["/app/docker/entrypoint.sh"]

