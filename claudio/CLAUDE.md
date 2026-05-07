# Global Context

## Environment
Running inside the `claudio` Docker container. Host is Linux with i3, Fish shell, kitty terminal.

## claudio Container Constraints
- **Workspace:** mounted from host's project directory, read/write
- **Git:** mounted separately, read-only by default
- **Git hooks:** always read-only — cannot be changed
- **Network:** bridge network only — no access to Docker Compose services (MySQL, Nginx, etc.); outbound internet unrestricted
- **No runtimes:** cannot run `artisan`, `composer`, `npm`, tests, etc. — code read/write only

## Notable Host Aliases
- `bat` → `batcat`, `fd` → `fdfind` (Debian naming)
