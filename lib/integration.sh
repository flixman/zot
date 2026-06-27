#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

run_imagetrust_integration() {
  local coverprofile cleanup
  cleanup=0

  if [[ -n "${IMAGETRUST_INTEGRATION_COVERPROFILE:-}" ]]; then
    coverprofile="${IMAGETRUST_INTEGRATION_COVERPROFILE}"
  else
    coverprofile="$(mktemp "${TMPDIR:-/tmp}/imagetrust-integration.XXXXXX.coverprofile")"
    cleanup=1
  fi

  cd "${repo_root}"
  go test -v -coverprofile="${coverprofile}" -tags imagetrust ./pkg/extensions/imagetrust

  if [[ "${cleanup}" -eq 1 ]]; then
    rm -f "${coverprofile}"
  fi
}

main() {
  run_imagetrust_integration
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
