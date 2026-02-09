#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SECRETS_FILE="$ROOT_DIR/mosquitto/secrets/dev.yaml"

echo "Using secrets file: $SECRETS_FILE"

if [ ! -f "$SECRETS_FILE" ]; then
  echo "ERROR: Secrets file not found at $SECRETS_FILE" >&2
  exit 1
fi

# Decrypt and extract users
MOSQUITTO_USERS_B64="$(
  sops -d "$SECRETS_FILE" \
    | yq -o=json '.mosquitto.users' \
    | jq -r 'to_entries[] | "\(.key):\(.value)"' \
    | base64 -w 0
)"

if [ -z "$MOSQUITTO_USERS_B64" ] || [ "$MOSQUITTO_USERS_B64" = "null" ]; then
  echo "ERROR: mosquitto.users is empty or missing" >&2
  exit 1
fi

export MOSQUITTO_USERS_B64

docker compose -f "$ROOT_DIR/docker-compose.yaml" up -d