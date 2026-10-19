# dotfiles

Light/dark theme setup that follows the macOS appearance, for Ghostty, fish, herdr, Zed and Claude Code.
Dark colors are the hand-tuned ones; light is Solarized Light with a darker foreground.

```sh
git clone <this repo> ~/dotfiles && ~/dotfiles/install.sh
```

Prerequisites on a fresh account: Ghostty, fish 4.x, herdr, Zed, Claude Code, and the fish prompt
(`fisher install jorgebucaran/fisher rafaelrinaldi/pure`). Zed installs the Solarized theme
extension itself on its next start.

| Path | What |
| --- | --- |
| `ghostty/config`, `ghostty/themes/mine-{dark,light}` | `theme = light:mine-light,dark:mine-dark`, colors only in the theme files |
| `fish/themes/mine.theme` | `[dark]` / `[light]` / `[unknown]` fish syntax colors |
| `fish/conf.d/theme.fish` | picks the theme and switches pure prompt colors on `fish_terminal_color_theme` |
| `herdr/config.toml` | `[theme] auto_switch = true` |
| `zed/settings.json` | `theme` and `icon_theme` in `mode: system` |
| `claude/statusline.sh` | Claude Code status line: model · effort, lines changed vs main, context and 5h/7d limit bars in the prompt colors of the current appearance (needs `jq`) |

`install.sh` symlinks the files. If an app ever rewrites its config and replaces a link with a plain
file, `install.sh` keeps that file as `*.bak` next to the new link so nothing is lost.
