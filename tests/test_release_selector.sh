#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
selector="$repo_root/scripts/select-desktop-release.jq"
fixture="$repo_root/tests/fixtures/bitwarden-clients-releases-sample.json"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

selection="$(jq -crf "$selector" "$fixture")"
selected_tag="$(jq -r '.tag_name' <<< "$selection")"
selected_name="$(jq -r '.name' <<< "$selection")"

[[ "$selected_tag" == "desktop-v2026.1.1" ]] || fail "expected desktop-v2026.1.1, got ${selected_tag}"
[[ "$selected_name" == "Desktop v2026.1.1" ]] || fail "expected Desktop v2026.1.1, got ${selected_name}"

no_match_input="$(mktemp)"
trap 'rm -f "$no_match_input"' EXIT
cat > "$no_match_input" <<'EOF'
[
  {
    "name": "Desktop v2026.1.2",
    "tag_name": "desktop-v2026.1.2",
    "draft": false,
    "prerelease": true,
    "assets": [
      {
        "name": "Bitwarden-2026.1.2-x86_64.AppImage"
      }
    ]
  },
  {
    "name": "Desktop v2026.1.1",
    "tag_name": "desktop-v2026.1.1-beta",
    "draft": false,
    "prerelease": false,
    "assets": [
      {
        "name": "Bitwarden-2026.1.1-x86_64.AppImage"
      }
    ]
  },
  {
    "name": "Desktop v2026.1.0",
    "tag_name": "desktop-v2026.1.0",
    "draft": false,
    "prerelease": false,
    "assets": []
  }
]
EOF

empty_selection="$(jq -crf "$selector" "$no_match_input")"
[[ -z "$empty_selection" ]] || fail "expected empty selection for non-matching releases"

echo "release selector tests passed"
