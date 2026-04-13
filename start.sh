#!/usr/bin/env bash
set -euo pipefail

export OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-8080}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/tmp/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/tmp/workspace}"
export OPENCLAW_MODEL="${OPENCLAW_MODEL:-openai/gpt-5.4}"

mkdir -p "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

if [ -n "${WORKSPACE_REPO_URL:-}" ]; then
  if [ ! -d "$OPENCLAW_WORKSPACE_DIR/.git" ]; then
    git clone "$WORKSPACE_REPO_URL" "$OPENCLAW_WORKSPACE_DIR"
  else
    git -C "$OPENCLAW_WORKSPACE_DIR" pull --ff-only || true
  fi
fi

cat > "$OPENCLAW_STATE_DIR/openclaw.json" <<EOF
{
  "identity": {
    "name": "Jarvis",
    "theme": "assistente pessoal e técnico",
    "emoji": "🤖"
  },
  "agent": {
    "workspace": "$OPENCLAW_WORKSPACE_DIR",
    "model": {
      "primary": "$OPENCLAW_MODEL"
    }
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

export OPENCLAW_CONFIG_PATH="$OPENCLAW_STATE_DIR/openclaw.json"

exec openclaw gateway --bind 0.0.0.0 --port "$OPENCLAW_GATEWAY_PORT"
