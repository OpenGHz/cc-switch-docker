# CC Switch Docker Runner

Run the CC Switch Linux AppImage inside an Ubuntu 22.04 Docker container while keeping Claude Code, Codex, Gemini, and related CLI tools on the host.

This runner is useful when the host OS is too old for the official CC Switch Linux build. For example, Ubuntu 20.04 ships `glibc` 2.31, while recent CC Switch AppImages require newer `glibc` symbols. The container supplies the newer desktop runtime and mounts host configuration directories so CC Switch can still manage the CLI tools you use on the host.

> [!NOTE]
> This project packages and launches the upstream CC Switch AppImage. It does not vendor, modify, or redistribute CC Switch itself.

## Features

- Runs CC Switch from an Ubuntu 22.04 container with `glibc` 2.35.
- Uses X11 and host D-Bus integration for the desktop UI and tray behavior.
- Includes Noto CJK fonts and a UTF-8 Chinese locale for Chinese UI rendering.
- Mounts host configuration directories for Claude Code, Codex, Gemini, CC Switch, and global agent skills.
- Uses Docker host networking so CC Switch route/proxy mode is reachable from host CLI tools.
- Supports desktop-login autostart through an XDG autostart entry.
- Avoids AppImage FUSE issues by defaulting to AppImage extract mode.

## Requirements

- Linux desktop host with Docker installed and running.
- X11 desktop session. Wayland may work through XWayland, but this runner was validated with X11.
- A downloaded CC Switch Linux x86_64 AppImage.

By default, place the AppImage in this project directory with the upstream release filename pattern:

```bash
cp /path/to/CC-Switch-v3.15.0-Linux-x86_64.AppImage ./
```

The runner scans the project directory for `CC-Switch-v*-Linux-x86_64.AppImage` and picks the newest version by filename. You can still override the path explicitly:

```bash
export APPIMAGE_HOST="$HOME/Downloads/CC-Switch-v3.15.0-Linux-x86_64.AppImage"
```

## Quick Start

Build the image:

```bash
./build-image.sh
```

Launch CC Switch:

```bash
./run-cc-switch.sh
```

Use a custom AppImage path:

```bash
APPIMAGE_HOST=/path/to/CC-Switch.AppImage ./run-cc-switch.sh
```

The container is temporary. Closing CC Switch exits the container, and running the script again creates a fresh container with the same mounted host configuration.

## How It Works

The runner keeps responsibilities split:

- The container runs only the CC Switch GUI and its local route/proxy service.
- The host continues to run `claude`, `codex`, `gemini`, and other CLI tools.
- Host configuration directories are mounted into the container so CC Switch edits the same files the host CLI tools read.

Mounted host directories:

- `$HOME/.cc-switch`
- `$HOME/.agents`
- `$HOME/.claude`
- `$HOME/.codex`
- `$HOME/.gemini`
- `$HOME/.config`

Skills-related paths covered by these mounts include `$HOME/.agents/skills`, `$HOME/.claude/skills`, `$HOME/.cc-switch/skills`, and `$HOME/.cc-switch/skill-backups`.

## Route / Proxy Mode

`run-cc-switch.sh` uses Docker host networking:

```bash
--network=host
```

This makes CC Switch route/proxy ports listen in the host network namespace. Host CLI tools can then reach the route endpoint through addresses such as `127.0.0.1:<port>`.

Restart CC Switch after route/proxy changes:

```bash
docker rm -f cc-switch-gui 2>/dev/null || true
./run-cc-switch.sh
```

Check listening ports on the host:

```bash
ss -ltnp | grep -E 'cc-switch|127.0.0.1|789|808|300|400|500|600|700|800|900'
```

## Autostart

The local setup includes a desktop-login autostart entry:

```bash
$HOME/.config/autostart/cc-switch-docker.desktop
```

It calls:

```bash
<repo>/autostart-cc-switch.sh
```

View autostart logs:

```bash
tail -n 100 ~/.local/state/cc-switch-docker/autostart.log
```

Disable autostart:

```bash
mv ~/.config/autostart/cc-switch-docker.desktop ~/.config/autostart/cc-switch-docker.desktop.disabled
```

Re-enable autostart:

```bash
mv ~/.config/autostart/cc-switch-docker.desktop.disabled ~/.config/autostart/cc-switch-docker.desktop
```

## Useful Commands

Rebuild the image after changing the Dockerfile:

```bash
./build-image.sh
```

Rebuild is required after changing fonts, locales, or system packages in `Dockerfile`.

Stop the running container:

```bash
docker rm -f cc-switch-gui
```

Check whether CC Switch is running:

```bash
docker ps --filter name=cc-switch-gui
```

Validate shell scripts:

```bash
bash -n *.sh
```

## Troubleshooting

### AppImage not found

Put the AppImage in the project directory with a matching filename:

```bash
cp /path/to/CC-Switch-v3.15.0-Linux-x86_64.AppImage ./
```

Or set `APPIMAGE_HOST` to the downloaded AppImage path:

```bash
APPIMAGE_HOST=/path/to/CC-Switch.AppImage ./run-cc-switch.sh
```

### Docker is not ready on login

The autostart wrapper waits for Docker for up to about one minute. If it still fails, start Docker manually and launch the runner again:

```bash
sudo systemctl start docker
./run-cc-switch.sh
```

### Route works in CC Switch but host CLI cannot connect

Ensure the runner is using host networking and restart the container:

```bash
grep -- '--network=host' run-cc-switch.sh
docker rm -f cc-switch-gui 2>/dev/null || true
./run-cc-switch.sh
```

### D-Bus or AppArmor warnings

Some desktop environments print D-Bus, tray, or AppArmor warnings from containers. If the main window opens and configuration changes are saved, these warnings are usually non-fatal.

## Project Structure

```text
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── Dockerfile
├── LICENSE
├── autostart-cc-switch.sh
├── build-image.sh
├── entrypoint.sh
├── README.md
├── SECURITY.md
├── SUPPORT.md
└── run-cc-switch.sh
```

## Contributing

See `CONTRIBUTING.md` for development checks and pull request guidance.

## Security

See `SECURITY.md` before sharing logs or opening issues that may include provider credentials or private CLI configuration.
