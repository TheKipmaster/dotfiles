# Global Context

## Environment
Running inside the `claudio` Docker container. Host is Linux with i3, Fish shell, kitty terminal.

## claudio Container Mounts
| Host path | Container path | Access |
|---|---|---|
| `./src` (or `--dir` override) | `/workspace` | read/write |
| `./.git/` | `/workspace/.git` | read-only (writable with `-w`); check `$CLAUDIO_GIT_WRITE` |
| `./.git/hooks/` | `/workspace/.git/hooks` | always read-only, cannot be changed |
| `~/.claudio/.claude/` | `/home/claudio/.claude` | read/write; files are symlinked to `~/Documents/dotfiles/claudio/` — never copy them |
| `~/.claudio/.claude.json` | `/home/claudio/.claude.json` | read/write |
| `~/Documents/dotfiles/claudio/` | `/home/felipe/Documents/dotfiles/claudio` | read/write |

## claudio Container Constraints
- **Network:** bridge network only — no access to Docker Compose services (MySQL, Nginx, etc.); outbound internet unrestricted
- **No runtimes:** cannot run `artisan`, `composer`, `npm`, tests, etc. — code read/write only
- **Non-root:** runs as UID 1000 — no `sudo` or `apt install`

## Notable Host Aliases
- `bat` → `batcat`, `fd` → `fdfind` (Debian naming)
