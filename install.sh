#!/usr/bin/env bash
set -e

SETTINGS="$HOME/.claude/settings.json"
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

echo ""
echo -e "${BOLD}🪽 Hermes — Claude Code Plugin Installer${RESET}"
echo ""

# Check claude is installed
if ! command -v claude &>/dev/null; then
  echo "❌ Claude Code CLI not found. Install it first: https://claude.ai/download"
  exit 1
fi

# Check settings file exists
if [ ! -f "$SETTINGS" ]; then
  echo "⚙️  Creating ~/.claude/settings.json"
  mkdir -p "$HOME/.claude"
  echo '{}' > "$SETTINGS"
fi

# Check if python3 or node is available for JSON editing
if command -v python3 &>/dev/null; then
  python3 - <<'PYEOF'
import json, sys, os

settings_path = os.path.expanduser("~/.claude/settings.json")

with open(settings_path, "r") as f:
  settings = json.load(f)

# Add marketplace
if "extraKnownMarketplaces" not in settings:
  settings["extraKnownMarketplaces"] = {}

settings["extraKnownMarketplaces"]["hermes"] = {
  "source": {
    "source": "github",
    "repo": "linder3hs/hermes"
  }
}

# Enable plugin
if "enabledPlugins" not in settings:
  settings["enabledPlugins"] = {}

settings["enabledPlugins"]["hermes@hermes"] = True

with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)

print("✅ settings.json updated")
PYEOF
else
  echo -e "${YELLOW}⚠️  python3 not found. Add this to ~/.claude/settings.json manually:${RESET}"
  echo ""
  echo '  "extraKnownMarketplaces": { "hermes": { "source": { "source": "github", "repo": "linder3hs/hermes" } } }'
  echo '  "enabledPlugins": { "hermes@hermes": true }'
  echo ""
  exit 1
fi

# Clear plugin cache so it re-downloads fresh
CACHE="$HOME/.claude/plugins/cache/hermes"
if [ -d "$CACHE" ]; then
  rm -rf "$CACHE"
  echo "🗑️  Cleared plugin cache"
fi

echo ""
echo -e "${GREEN}${BOLD}✅ Hermes installed!${RESET}"
echo ""
echo "  Restart Claude Code and run:"
echo -e "  ${BOLD}/new-project${RESET}      — create a new project"
echo -e "  ${BOLD}/project-health${RESET}   — analyze an existing project"
echo ""
