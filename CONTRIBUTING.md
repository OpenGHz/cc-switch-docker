# Contributing

Thanks for helping improve CC Switch Docker Runner.

## Scope

This repository contains Docker packaging and helper scripts for running the CC Switch Linux AppImage from an Ubuntu 22.04 container on older Linux hosts. Keep changes focused on packaging, documentation, and operational reliability.

## Development Setup

```bash
git clone <repo-url>
cd cc-switch-docker
./build-image.sh
./run-cc-switch.sh
```

Set a custom AppImage path when needed:

```bash
APPIMAGE_HOST=/path/to/CC-Switch.AppImage ./run-cc-switch.sh
```

## Before Submitting

Run lightweight checks:

```bash
bash -n *.sh
docker build -t cc-switch-ubuntu22:local .
```

If you change route/proxy behavior, verify that host CLI tools can still reach the local proxy endpoint after CC Switch starts.

## Pull Request Guidelines

- Explain the user-visible problem being fixed.
- Include the host distribution, Docker version, and desktop session type when reporting runtime behavior.
- Avoid committing downloaded AppImage files, logs, credentials, or user-specific configuration.
- Keep documentation changes concise and copy-pastable.
