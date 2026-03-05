#!/usr/bin/env bash

set -euo pipefail

die() {
  echo "ERROR: $*" >&2
  exit 1
}

log() {
  printf '[verify] %s\n' "$*"
}

appimage="${1:-}"
[[ -n "$appimage" ]] || die "Usage: $0 /path/to/AppImage"
[[ -f "$appimage" ]] || die "AppImage not found: $appimage"

chmod +x "$appimage"

file_out="$(file "$appimage")"
grep -qi 'ELF' <<< "$file_out" || die "Not an ELF binary: $file_out"
grep -qi 'ARM aarch64' <<< "$file_out" || die "Not an ARM aarch64 AppImage: $file_out"

# Some runtimes print version output while returning non-zero.
version_out="$("$appimage" --appimage-version 2>&1 || true)"
[[ -n "$version_out" ]] || die "Missing --appimage-version output"
grep -qi 'version' <<< "$version_out" || die "Unexpected --appimage-version output: $version_out"
log "Runtime version output: $version_out"

offset_out="$("$appimage" --appimage-offset)"
[[ "$offset_out" =~ ^[0-9]+$ ]] || die "Non-numeric --appimage-offset output: $offset_out"
(( offset_out > 0 )) || die "Invalid AppImage offset: $offset_out"
log "Runtime offset output: $offset_out"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
unsquashfs -no-xattrs -d "$tmpdir/AppDir" -offset "$offset_out" "$appimage" >/dev/null

[[ -x "$tmpdir/AppDir/AppRun" ]] || die "Missing or non-executable AppRun in AppImage payload"
[[ -f "$tmpdir/AppDir/bitwarden-app" ]] || die "Missing bitwarden-app in AppImage payload"

embedded_out="$(file "$tmpdir/AppDir/bitwarden-app")"
grep -qi 'ARM aarch64' <<< "$embedded_out" || die "Embedded bitwarden-app is not ARM aarch64: $embedded_out"
log "Embedded binary check passed: $embedded_out"

log "Verification passed: $appimage"
