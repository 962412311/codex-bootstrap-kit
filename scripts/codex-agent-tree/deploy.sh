#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd)
target_dir="$HOME/.codex"
source_dir="$repo_root/codex-home"
archive=""
tmp_dir=""

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'ERROR: required command not found: %s\n' "$1" >&2
    exit 1
  fi
}

make_tmp_dir() {
  tmp_base=${TMPDIR:-/tmp}
  tmp_base=${tmp_base%/}
  mktemp -d "$tmp_base/codex-agent-tree.XXXXXX"
}

usage() {
  cat <<'USAGE'
Usage:
  scripts/codex-agent-tree/deploy.sh [--target PATH]
  scripts/codex-agent-tree/deploy.sh --archive PATH [--target PATH]

Deploys the archived global Codex Agent file tree into a .codex directory.
Only the archived Agent tree is overwritten; auth, sessions, memories, cache,
state databases, and other runtime files are not removed.
USAGE
}

cleanup() {
  if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
}
trap cleanup EXIT INT TERM

for command_name in cp mktemp rsync tar; do
  require_command "$command_name"
done

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || { printf 'ERROR: --target requires a path\n' >&2; exit 1; }
      target_dir="$2"
      shift 2
      ;;
    --archive)
      [ "$#" -ge 2 ] || { printf 'ERROR: --archive requires a path\n' >&2; exit 1; }
      archive="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'ERROR: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -n "$archive" ]; then
  [ -f "$archive" ] || { printf 'ERROR: archive not found: %s\n' "$archive" >&2; exit 1; }
  tmp_dir=$(make_tmp_dir)
  COPYFILE_DISABLE=1 tar -xzf "$archive" -C "$tmp_dir"
  source_dir="$tmp_dir"
fi

for required in AGENTS.md BOOTSTRAP.md GLOBAL-AGENT.md KARPATHY-INTEGRATION.md RTK.md path.sh global-rules vendor_imports/andrej-karpathy-skills; do
  if [ ! -e "$source_dir/$required" ]; then
    printf 'ERROR: missing archived path: %s\n' "$required" >&2
    exit 1
  fi
done

mkdir -p "$target_dir"

for file in AGENTS.md BOOTSTRAP.md GLOBAL-AGENT.md KARPATHY-INTEGRATION.md RTK.md path.sh; do
  cp "$source_dir/$file" "$target_dir/$file"
done

mkdir -p "$target_dir/global-rules"
rsync -a --delete --exclude '.DS_Store' \
  "$source_dir/global-rules/" \
  "$target_dir/global-rules/"

mkdir -p "$target_dir/vendor_imports/andrej-karpathy-skills"
rsync -a --delete --exclude '.git/' --exclude '.DS_Store' \
  "$source_dir/vendor_imports/andrej-karpathy-skills/" \
  "$target_dir/vendor_imports/andrej-karpathy-skills/"

if command -v zsh >/dev/null 2>&1; then
  zsh -n "$target_dir/path.sh"
fi

printf 'deployed=%s\n' "$target_dir"
