#!/bin/sh
# Links every config in this repo into place. Safe to re-run.
set -eu
D=$(cd "$(dirname "$0")" && pwd)

link() {
    mkdir -p "$(dirname "$2")"
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        mv "$2" "$2.bak"
        echo "kept existing $2 as $2.bak"
    fi
    ln -sfn "$D/$1" "$2"
}

link ghostty/config         ~/.config/ghostty/config
link ghostty/themes         ~/.config/ghostty/themes
link fish/conf.d/theme.fish ~/.config/fish/conf.d/theme.fish
link fish/themes/mine.theme ~/.config/fish/themes/mine.theme
link herdr/config.toml      ~/.config/herdr/config.toml
link zed/settings.json      ~/.config/zed/settings.json

# Claude Code keeps other machine-local state in settings.json, so only the theme key is set.
mkdir -p ~/.claude
python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.claude/settings.json")
s = json.load(open(p)) if os.path.exists(p) else {}
s["theme"] = "auto"
json.dump(s, open(p, "w"), indent=2)
PY
echo "done. Ghostty: cmd+shift+, to reload. herdr: herdr server reload-config. fish: open a new shell."
