# bitwarden-aarch64 (ARM64) for Linux

This project exists because official Bitwarden Linux aarch64 support is currently incomplete across common Linux distribution channels.

While community-maintained aarch64 Flatpak packages are available on [Flathub](https://github.com/flathub/com.bitwarden.desktop) (added in [March 2026](https://github.com/flathub/com.bitwarden.desktop/commit/308)), Bitwarden does not provide a complete first-party Linux aarch64 delivery story across key channels such as Homebrew, Snap, `.deb`/`.rpm`, and AppImage.

This repository publishes community-built Linux aarch64 AppImages for Bitwarden Desktop and will continue doing so until Bitwarden provides formal, first-party Linux on ARM support.

## Scope

- Track upstream Bitwarden desktop releases from `bitwarden/clients`
- Rebuild aarch64 AppImages from official upstream release assets
- Publish releases with the same upstream tag (for example `desktop-v2026.1.1`)
- Include upstream changelog content and links back to the matching Bitwarden release

## Automation model

- GitHub Actions polls upstream releases on a schedule
- If a matching release tag does not already exist in this repo, CI builds and publishes it
- Manual workflow dispatch is available for specific versions

## Local build

Required dependencies:

- `bash`
- `curl`
- `jq`
- `tar`
- `file`
- `unsquashfs` and `mksquashfs` (usually from `squashfs-tools`)
- `grep`, `awk`, `sed`, `sha256sum`

Run:

```bash
./scripts/build.sh --version 2026.1.1
```

Output:

- `dist/Bitwarden-<version>-aarch64.AppImage`
