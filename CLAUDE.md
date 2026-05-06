# Dotfiles

Personal Linux desktop dotfiles for an i3-based setup. Configs are managed as symlinks: `setup.sh` installs dependencies and links everything from `~/Documents/dotfiles/<tool>/` → `~/.config/<tool>/`, so editing files in this repo edits the live config directly.

## Structure

| Path | What it configures |
|---|---|
| `fish/` | Fish shell — functions, aliases, prompt |
| `i3/` | i3 window manager + monitor-detection scripts |
| `kitty.conf` | Kitty terminal — keybindings, colors, fonts |
| `nvim/` | NeoVim via LazyVim |
| `polybar/` | Status bar modules and launch script |
| `picom/` | Compositor config and launch script |
| `rofi/` | App launcher and power-menu scripts |
| `dunst/` | Notification daemon |
| `nitrogen/` | Wallpaper manager |
| `Dockerfile.claude` | Docker image used by the `claudio` Fish function |
| `setup.sh` | Full install + symlink script (clone to `~/Documents/dotfiles/`) |

## Conventions

- **Script permissions:** All scripts under config dirs must be executable. `setup.sh` runs `chmod +x` over polybar, rofi, dunst, picom, and i3 script dirs — re-run it after adding new scripts.
- **Auto-generated files:** `i3/scripts/workspace_outputs.conf` is written at i3 startup by `setup_monitors.sh`. It's gitignored — do not manually edit or commit it.
- **Gitignored intentionally:** `nvim/lazy-lock.json` (LazyVim lockfile) and `i3/john-config` (machine-specific i3 overrides).
- **Debian compat aliases:** `bat` → `batcat`, `fd` → `fdfind` (Debian names these differently from upstream).

## Multi-monitor system

`i3/scripts/get_monitors.sh` detects outputs by type (eDP = internal, DP = left external, HDMI = right external). `setup_monitors.sh` uses it to generate dynamic workspace-to-output mappings on each i3 start. Workspace layout: left monitor (1, 4, 7), center (2, 5, 8), right (3, 6, 9).

## Primary shell

Fish. Bash and Zsh configs exist for compatibility, but aliases and functions live in `fish/`.

Notable functions:
- `claudio` — runs Claude Code CLI inside the Docker image from `Dockerfile.claude`, with workspace and git config bind-mounted
- `patt` — auto-restarting PHP Artisan Tinker REPL (Laravel dev)
