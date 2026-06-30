#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd)
source_dir="$repo_root/codex-home"
output_dir="${1:-$repo_root/dist}"
archive="$output_dir/codex-global-agent-tree.tar.gz"
manifest="$output_dir/codex-global-agent-tree.files"
checksum="$archive.sha256"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'ERROR: required command not found: %s\n' "$1" >&2
    exit 1
  fi
}

for command_name in find sed sort tar; do
  require_command "$command_name"
done

if [ ! -d "$source_dir" ]; then
  printf 'ERROR: source directory not found: %s\n' "$source_dir" >&2
  exit 1
fi

mkdir -p "$output_dir"

find "$source_dir" \
  \( -name '.git' \
    -o -name '.DS_Store' \
    -o -name '._*' \
    -o -name '__MACOSX' \
    -o -name 'auth.json' \
    -o -name 'config.toml' \
    -o -name 'state*.sqlite*' \
    -o -name 'sessions' \
    -o -name 'memories' \
    -o -name 'cache' \
    -o -name 'plugins' \
    -o -name 'log' \
    -o -name 'shell-snapshots' \) -prune \
  -o -type f -print \
  | sed "s|^$source_dir/||" \
  | sort > "$manifest"

COPYFILE_DISABLE=1 tar -C "$source_dir" \
  --exclude '.git' \
  --exclude '*/.git' \
  --exclude '.DS_Store' \
  --exclude '*/.DS_Store' \
  --exclude '._*' \
  --exclude '*/._*' \
  --exclude '__MACOSX' \
  --exclude '*/__MACOSX' \
  --exclude 'auth.json' \
  --exclude 'config.toml' \
  --exclude 'state*.sqlite*' \
  --exclude 'sessions' \
  --exclude 'memories' \
  --exclude 'cache' \
  --exclude 'plugins' \
  --exclude 'log' \
  --exclude 'shell-snapshots' \
  -czf "$archive" .

if command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$archive" > "$checksum"
elif command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$archive" > "$checksum"
else
  printf 'WARN: no sha256 tool found; checksum skipped\n' >&2
  rm -f "$checksum"
fi

printf 'archive=%s\n' "$archive"
printf 'manifest=%s\n' "$manifest"
[ -f "$checksum" ] && printf 'checksum=%s\n' "$checksum"
