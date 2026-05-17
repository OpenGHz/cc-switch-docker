# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project uses semantic versioning when releases are created.

## [Unreleased]

### Added

- Ubuntu 22.04 Docker image definition for running the CC Switch Linux AppImage on older hosts.
- Project-directory AppImage auto-discovery using the `CC-Switch-v*-Linux-x86_64.AppImage` filename pattern.
- Noto CJK fonts and UTF-8 Chinese locale support for Chinese UI rendering.
- Runtime script with X11, D-Bus, host networking, and host configuration directory mounts.
- Host `$HOME/.agents` mount so CC Switch can manage global agent skills.
- Desktop autostart helper for launching CC Switch after user login.
- Documentation and community health files for open source publication.
