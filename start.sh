#!/usr/bin/env bash
set -euo pipefail

export PORT="${PORT:-10000}"
export HOME="${HOME:-/tmp/home}"
mkdir -p "$HOME/.openclaw"

export WORKSPACE_DIR="${WORKSPACE_DIR:-/tmp/workspace}"

mkdir -p "$WORKSPACE_DIR"

if [ -n "${WORKSPACE_REPO_URL:-}" ]; then
  if [ ! -d "$WORKSPACE_DIR/.git" ]; then
    git clone "$WORKSPACE_REPO_URL" "$WORKSPACE_DIR"
  else
    git -C "$WORKSPACE_DIR" pull --ff-only || true
  fi
fi

cat > "$HOME/.openclaw/openclaw.json" <<EOF
{
  "identity": {
    "name": "Jarvis",
    "theme": "assistente pessoal e técnico",
    "emoji": "🤖"
  },
  "agents": {
    "defaults": {
      "workspace": "$WORKSPACE_DIR"
    }
  },
  "model": {
    "primary": "openai/gpt-5.4"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN:-}",
      "dmPolicy": "pairing",
      "groups": {
        "*": {
          "requireMention": true
        }
      }
    }
  }
}
EOF

echo "Starting OpenClaw on port $PORT"
exec openclaw gateway --bind lan --port "$PORT" --token "$OPENCLAW_GATEWAY_TOKEN"
