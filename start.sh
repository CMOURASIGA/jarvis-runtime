#!/usr/bin/env bash
set -euxo pipefail

export PORT="${PORT:-10000}"

echo "===== BASIC START TEST ====="
echo "PORT=$PORT"
echo "OPENCLAW_GATEWAY_TOKEN_SET=${OPENCLAW_GATEWAY_TOKEN:+yes}"

exec openclaw gateway --bind lan --port "$PORT" --token "$OPENCLAW_GATEWAY_TOKEN"
