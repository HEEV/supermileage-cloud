#!/usr/bin/env sh
set -e

: "${MOSQUITTO_USERS_JSON:?}"

PASSWD_FILE="/mosquitto/data/passwd"

echo "Generating Mosquitto password file"

# Start fresh every time
rm -f "$PASSWD_FILE"

echo "$MOSQUITTO_USERS_JSON" \
  | jq -r 'to_entries[] | "\(.key):\(.value)"' \
  | while IFS=: read -r user password; do
      mosquitto_passwd -b "$PASSWD_FILE" "$user" "$password"
    done

exec /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
