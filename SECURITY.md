# Security Policy

## Supported Versions

This project is a small Docker packaging wrapper. Security fixes are expected to target the latest version in the default branch.

## Reporting a Vulnerability

Please do not publish sensitive vulnerability details in public issues. Instead, contact the maintainer through a private channel if one is listed on the repository profile. If no private contact is available, open a minimal public issue that says you have a security report and avoid including secrets, tokens, or exploit details.

## Sensitive Data

Do not commit or share:

- API keys, provider tokens, or credentials
- `.env` files
- Private Claude/Codex/Gemini configuration
- Local logs containing request headers or account data
- Downloaded AppImage binaries unless the repository explicitly documents binary distribution

## Container Notes

The runner mounts selected host configuration directories into the container so CC Switch can manage CLI configuration. Review the mounted paths in `run-cc-switch.sh` before using it on shared machines.
