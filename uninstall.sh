#!/usr/bin/env bash
set -e

SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "🪽 Hermes — Uninstaller"
echo ""

if [ ! -f "$SETTINGS" ]; then
  echo "Nothing to uninstall."
  exit 0
fi

python3 - <<'PYEOF'
import json, os

settings_path = os.path.expanduser("~/.claude/settings.json")

with open(settings_path, "r") as f:
  settings = json.load(f)

settings.get("extraKnownMarketplaces", {}).pop("hermes", None)
settings.get("enabledPlugins", {}).pop("hermes@hermes", None)

with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)

print("✅ Removed hermes from settings.json")
PYEOF

CACHE="$HOME/.claude/plugins/cache/hermes"
if [ -d "$CACHE" ]; then
  rm -rf "$CACHE"
  echo "🗑️  Cleared plugin cache"
fi

echo ""
echo "✅ Hermes uninstalled. Restart Claude Code."
echo ""
