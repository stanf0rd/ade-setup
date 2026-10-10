#!/bin/sh
# Set the $ticket token on every workspace whose git branch contains tp-NNNN.
# ponytail: no branch-change event in herdr, so a `git switch` inside a worktree
# shows the old ticket until the next startup or workspace.created.
herdr="${HERDR_BIN_PATH:-herdr}"

"$herdr" pane list | jq -r '.result.panes | unique_by(.workspace_id)[] | "\(.workspace_id)\t\(.cwd)"' |
while IFS="$(printf '\t')" read -r ws cwd; do
  t=$(git -C "$cwd" branch --show-current 2>/dev/null | grep -oiE 'tp-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
  [ -n "$t" ] && "$herdr" workspace report-metadata "$ws" --source ticket-token --token "ticket=$t" >/dev/null
done
exit 0
