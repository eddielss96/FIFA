#!/bin/bash
set -euo pipefail

# Only relevant in Claude Code on the web / remote environments, whose
# containers are rebuilt from scratch on every new session.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

SETTINGS_FILE="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"

if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1 && jq -e . "$SETTINGS_FILE" >/dev/null 2>&1; then
  tmp="$(mktemp)"
  jq '.attribution.commit = "" | .attribution.pr = ""' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
else
  cat > "$SETTINGS_FILE" << 'JSON'
{
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
JSON
fi
