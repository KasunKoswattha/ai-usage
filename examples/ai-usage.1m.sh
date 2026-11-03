#!/usr/bin/env bash
# SwiftBar / xbar plugin: Claude and Codex limits in the macOS menu bar.
# Copy into your plugins folder. The "1m" in the name sets a one-minute refresh.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

json=$(ai-usage --json 2>/dev/null) || { echo "AI ?"; exit 0; }

# Menu bar title: the highest 5-hour usage of the two tools.
top=$(printf '%s' "$json" | jq -r '[.claude, .codex][].windows[] | select(.window == "5h") | .used_percent' | sort -n | tail -1)
echo "AI ${top:-?}%"
echo "---"
ai-usage --short | awk -F ' │ ' '{ for (i = 1; i <= NF; i++) print $i }'
echo "---"
echo "Refresh | refresh=true"
