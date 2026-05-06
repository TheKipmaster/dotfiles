## Claudio — Claude Code Dev Container Wrapper

### What It Is
A Fish shell function (`claudio`) that launches Claude Code inside a Docker container with scoped access. Designed to be reusable across projects — lives in dotfiles, not per-project config.

### Security Model
The container is deliberately limited:

- **Filesystem:** Only the source code directory is mounted read/write (defaults to `./src`). No access to `.env`, `docker-compose.yml`, `deploy.sh`, `docker/`, or `~/.ssh/`.
- **Git:** `.git` is mounted separately, read-only by default. Hooks are always read-only regardless of the git-write flag — prevents malicious hook injection.
- **Network:** Container runs on Docker's default bridge network, isolated from any project's compose network (no access to MySQL, Nginx, queue workers, etc.). Outbound internet is unrestricted (required for Anthropic API auth).
- **User:** Runs as UID 1000 (`claudio`), matching the host user. No root access inside the container.

### State Persistence
Claude Code's credentials and config are persisted on the host at `~/.claude-dev/state/`, mounted into the container at `/home/claudio/.claude` and `/home/claudio/.claude.json`. The script creates these paths before `docker run` to prevent Docker from creating them as root. Treat `~/.claude-dev/state/` as sensitive (like `~/.ssh/`).

### Usage
- `claudio` — launch with defaults (`./src`, read-only git)
- `claudio --dir .` — mount the project root instead of `./src`
- `claudio --git-write` or `claudio -w` — enable git write access
- `claudio --dir . --git-write` — combine flags

### Design Defaults (Secure by Default)
- Mount directory: `./src` (not project root)
- Git access: read-only
- Git hooks: always read-only (no flag to override)

### Infrastructure
- **Dockerfile** (`Dockerfile.claude` in dotfiles): Ubuntu 24.04, Brazilian apt mirror, Node 22 via NodeSource, Claude Code installed globally via npm, non-root user `claudio` at UID 1000, `WORKDIR /workspace`.
- **Fish function** (`claudio.fish` in dotfiles): wrapper around `docker run` that handles mount logic, validation, state persistence, and flag parsing.
- **Docker image** name: `claude-dev`

### Known Limitations (v1)
- No project-specific runtimes (PHP, Composer, npm) — Claude can read and write code but can't execute `artisan`, run tests, or install packages.
- No domain whitelisting on outbound network traffic.
- `--dir` with an absolute path produces a malformed mount path.
- No per-project config file — everything is flags.

### Open Questions for Future Versions
- **Runtime access:** Installing PHP/Node in the container makes it project-specific, conflicting with the reusable goal. Options discussed: fat image, per-project Dockerfiles extending the base, or runtime detection.
- **Network restriction:** Domain whitelisting requires either a proxy container or iptables rules — deferred as too complex for v1.