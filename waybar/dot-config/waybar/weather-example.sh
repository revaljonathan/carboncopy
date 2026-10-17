#!/bin/sh

result=$(curl -s --max-time 10 'wttr.in/<yourcity>?format=j1' \
  | jq -r '.current_condition[0] | "\(.weatherDesc[0].value), \(.temp_C)°C"' 2>/dev/null)

[ -n "$result" ] && echo "$result" || echo "N/A"
