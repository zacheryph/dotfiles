#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
command_key=$(printf '%s' "$input" | jq -r '
  if .tool_input.command? then "command"
  elif .tool_input.cmd? then "cmd"
  else ""
  end
')

if [[ -z "$command_key" ]]; then
  echo '{}'
  exit 0
fi

cmd=$(printf '%s' "$input" | jq -r --arg key "$command_key" '.tool_input[$key]')

if printf '%s' "$cmd" | grep -q -- '--no-gpg-sign\|commit\.gpgsign'; then
  echo '{}'
  exit 0
fi

newcmd=$(printf '%s' "$cmd" | sed -E 's/(^|[^a-zA-Z0-9_])git (commit|rebase|merge)([[:space:]]|$)/\1git -c commit.gpgsign=false \2\3/g')

if [[ "$newcmd" == "$cmd" ]]; then
  echo '{}'
  exit 0
fi

updated_input=$(printf '%s' "$input" | jq -c --arg key "$command_key" --arg cmd "$newcmd" '.tool_input | .[$key] = $cmd')
jq -n --argjson updated_input "$updated_input" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "allow",
    permissionDecisionReason: "auto no-gpg-sign",
    updatedInput: $updated_input
  }
}'
