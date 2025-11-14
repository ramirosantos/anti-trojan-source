#!/usr/bin/env bash
#########################################
# Created by: Ramiro dos Santos
# Date: 14.11.2025
# Version: 0.2
#########################################
set -euo pipefail

DATA_DIR="/data"

# Preload the stdin.unref polyfill
export NODE_OPTIONS="--require=/usr/local/bin/polyfill-unref.js ${NODE_OPTIONS:-}"

if [[ ! -d "$DATA_DIR" ]]; then
  echo "Warning: ${DATA_DIR} not found. Did you forget: -v <local>:/data ?" >&2
  mkdir -p "$DATA_DIR"
fi

# Parse args. Support:
# --help, --files, -f, --verbose, -v, --json
forward_opts=()
explicit_paths=()
want_help=false
want_verbose=false

while (( "$#" )); do
  arg="$1"
  case "$arg" in
    --help)
      want_help=true
      forward_opts+=("$arg")
      shift
      ;;
    --json)
      forward_opts+=("$arg")
      shift
      ;;
    --verbose|-v)
      want_verbose=true
      forward_opts+=("$arg")
      shift
      ;;
    --files=*)
      val="${arg#*=}"
      forward_opts+=(--files "$val")
      explicit_paths+=("$val")
      shift
      ;;
    --files)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: --files requires a value" >&2
        exit 2
      fi
      forward_opts+=(--files "$1")
      explicit_paths+=("$1")
      shift
      ;;
    -f)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Error: -f requires a value" >&2
        exit 2
      fi
      forward_opts+=(-f "$1")
      explicit_paths+=("$1")
      shift
      ;;
    --*)
      forward_opts+=("$arg")
      shift
      ;;
    -*)
      forward_opts+=("$arg")
      shift
      ;;
    *)
      forward_opts+=("$arg")
      explicit_paths+=("$arg")
      shift
      ;;
  esac
done

# Build final command vector
cmd=(npx --yes anti-trojan-source)

if [[ "$want_help" == true ]]; then
  cmd+=("${forward_opts[@]}")
elif [[ "${#explicit_paths[@]}" -gt 0 ]]; then
  # User provided paths: pass through to avoid EISDIR
  cmd+=("${forward_opts[@]}")
else
  # No explicit paths: expand to regular files under /data
  mapfile -d '' files < <(find "$DATA_DIR" \
    -type d \( -name node_modules -o -name .git -o -name .svn -o -name .hg \) -prune -o \
    -type f -print0)
  if [[ "${#files[@]}" -eq 0 ]]; then
    echo "No files found under ${DATA_DIR}." >&2
    cmd+=("${forward_opts[@]}")
  else
    cmd+=("${forward_opts[@]}" "${files[@]}")
  fi
fi

# If verbose UI is requested and stdout is not a TTY, allocate a pseudo-TTY with `script`
if [[ "$want_verbose" == true && ! -t 1 ]]; then
  # Shell-escape the command for script -c
  quoted=$(
    printf '%q ' "${cmd[@]}"
  )
  exec script -qec "$quoted" /dev/null
else
  exec "${cmd[@]}"
fi
