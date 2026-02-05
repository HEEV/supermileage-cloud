#!/usr/bin/env bash
set -euo pipefail

SECRETS_FILE="secrets/dev.yaml"
TMP_FILE="$(mktemp)"

cleanup() { rm -f "$TMP_FILE"; }
trap cleanup EXIT

sops -d "$SECRETS_FILE" > "$TMP_FILE"

export MOSQUITTO_USERS_JSON=$(yq -o=json '.mosquitto.users' "$TMP_FILE")

docker compose up -d
