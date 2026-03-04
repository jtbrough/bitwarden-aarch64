[
  .[]
  | select(.draft | not)
  | select(.prerelease | not)
  | select((.name // "") | startswith("Desktop "))
  | select((.tag_name // "") | test("^desktop-v[0-9.]+$"))
  | select(any(.assets[]?; (.name // "") | test("^Bitwarden-[0-9.]+-x86_64\\.AppImage$")))
]
| first // empty
