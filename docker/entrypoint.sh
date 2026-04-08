#!/bin/sh
set -eu

node /app/dist/src/cli.js

if [ -n "${MQTT_USERNAME:-}" ] && [ -n "${MQTT_PASSWORD:-}" ]; then
  mosquitto_passwd -b -c "${MQTT_PASSWORD_FILE:-/mosquitto/config/passwordfile}" "$MQTT_USERNAME" "$MQTT_PASSWORD"
fi

exec mosquitto -c "${MQTT_CONFIG_OUTPUT:-/mosquitto/config/mosquitto.conf}"

