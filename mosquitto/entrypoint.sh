#!/usr/bin/env sh
set -e

umask 077

PASSWD_FILE="/mosquitto/data/passwd"
ACL_FILE="/mosquitto/config/acl"

mkdir -p "$(dirname "$PASSWD_FILE")"
touch "$PASSWD_FILE"

if [ -z "${MOSQUITTO_USERS_B64:-}" ]; then
  echo "ERROR: MOSQUITTO_USERS_B64 is empty or not set"
  exit 1
fi

USERS_PASS_LIST=$(echo "$MOSQUITTO_USERS_B64" | base64 -d)

echo "Generating Mosquitto password file"


# Generate passwd entries
echo "$USERS_PASS_LIST" | while IFS= read -r line; do
  if [ -n "$line" ]; then
    # Split line by first colon
    user=$(echo "$line" | cut -d: -f1)
    password=$(echo "$line" | cut -d: -f2-)

    echo "Adding user: $user"
    mosquitto_passwd -b "$PASSWD_FILE" "$user" "$password"
  fi
done

chown mosquitto:mosquitto "$PASSWD_FILE"
chown mosquitto:mosquitto "$ACL_FILE"
chmod 0700 "$ACL_FILE"

exec /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf