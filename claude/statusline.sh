#!/bin/bash
# Claude Code status line: model · effort │ +add −del │ ctx bar │ 5h bar │ 7d bar
# Colors follow the macOS appearance like the rest of ~/dotfiles:
# model = prompt directory, bars = prompt success → herdr working (50%) → error (80%).
fg() { printf '38;2;%d;%d;%d' 0x${1:0:2} 0x${1:2:2} 0x${1:4:2}; }
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = Dark ]; then
  model=73D0FF ok=DDBBFF warn=FFD580 bad=EE1111 mute=686868 plus=1DC121 # mine-dark / pure dark
else
  model=268bd2 ok=6c71c4 warn=b58900 bad=dc322f mute=93a1a1 plus=859900 # mine-light (Solarized) / pure light
fi
j=$(cat)

# Lines changed vs where this branch left the default branch: commits + uncommitted edits, not untracked files.
# --no-optional-locks so this never fights Claude's own git commands over index.lock.
git=(git -C "$(jq -r '.workspace.current_dir // .cwd' <<<"$j")" --no-optional-locks)
for b in origin/HEAD main master; do base=$("${git[@]}" merge-base HEAD "$b" 2>/dev/null) && break; done
[ -n "$base" ] && read -r add del < <("${git[@]}" diff --numstat "$base" | awk '{a+=$1; d+=$2} END {print a+0, d+0}')

jq -rj --arg model "1;$(fg $model)" --arg ok "$(fg $ok)" --arg warn "$(fg $warn)" \
       --arg bad "$(fg $bad)" --arg mute "$(fg $mute)" --arg plus "$(fg $plus)" \
       --argjson add "${add:-0}" --argjson del "${del:-0}" '
  def esc(c): "\u001b[\(c)m";
  def tag(s): esc($mute) + s + " " + esc("0");
  def color: if . >= 80 then $bad elif . >= 50 then $warn else $ok end;
  def bar(w):
    if . == null then esc($mute) + ("░" * w) + " –" + esc("0")
    else floor as $p | ($p | color) as $c | ([($p * w + 50) / 100 | floor, w] | min) as $n
      | esc($c) + (("█" * $n) // "") + esc($mute) + (("░" * (w - $n)) // "")
        + " " + esc($c) + "\($p)%" + esc("0")
    end;
  (esc($mute) + " │ " + esc("0")) as $sep
  | [ esc($model) + .model.display_name + esc("0")
        + (if .effort.level then esc($mute) + " · " + .effort.level + esc("0") else "" end),
      (if $add + $del > 0 then esc($plus) + "+\($add) " + esc($bad) + "−\($del)" + esc("0") else empty end),
      tag("ctx") + (.context_window.used_percentage | bar(10)),
      (.rate_limits // empty
        | tag("5h") + (.five_hour.used_percentage | bar(5)) + $sep
          + tag("7d") + (.seven_day.used_percentage | bar(5)))
    ] | join($sep)' <<<"$j"
