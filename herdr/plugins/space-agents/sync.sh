#!/bin/sh
# Mirror each workspace's agents into tokens a1..a6 ("● tab-name"), clearing unused slots.
# Slot count must match the $aN rows in ~/dotfiles/herdr/config.toml.
herdr="${HERDR_BIN_PATH:-herdr}"

"$herdr" api snapshot | jq -r --argjson n 6 '
  .result.snapshot as $s
  | ($s.tabs | map({key: .tab_id, value: .label}) | from_entries) as $tab
  | {idle: "○", working: "●", blocked: "!", done: "✓"} as $glyph
  | $s.workspaces[].workspace_id as $ws
  | [$s.panes[] | select(.workspace_id == $ws and .agent)] as $agents
  | [range(1; $n + 1) as $i | $agents[$i - 1] as $a
     | if $a then "--token", "a\($i)=\($glyph[$a.agent_status] // "·") \($tab[$a.tab_id] // $a.agent)"
       else "--clear-token", "a\($i)" end]
  | [$ws, "--source", "space-agents"] + . | @sh' |
while read -r args; do
  eval "\"\$herdr\" workspace report-metadata $args" >/dev/null
done
exit 0
