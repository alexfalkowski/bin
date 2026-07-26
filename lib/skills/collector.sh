#!/usr/bin/env bash
# shellcheck disable=SC2329
# Shared retry/validation wrapper for skill collector scripts.

# Runs a skill's Ruby collector with completed-run validation and one bounded
# retry, printing the validated JSON to standard output.
# Usage: run_skill_collector <label> <collector_script> [collector_args...]
run_skill_collector() {
  local label="$1"
  local collector_script="$2"
  shift 2

  local max_attempts=2
  local attempt=1
  local output=""

  cleanup() { [[ -z $output ]] || rm -f "$output"; }
  interrupted() {
    printf '%s: collector invocation interrupted; output was discarded\n' "$label" >&2
    exit 130
  }
  trap cleanup EXIT
  trap interrupted HUP INT TERM

  if ! command -v ruby >/dev/null 2>&1; then
    printf '%s: ruby is required to run the collector\n' "$label" >&2
    exit 127
  fi

  for argument in "$@"; do
    if [[ $argument == '--help' || $argument == '-h' ]]; then
      exec ruby "$collector_script" "$@"
    fi
  done

  if ! command -v jq >/dev/null 2>&1; then
    printf '%s: jq is required to validate collector output\n' "$label" >&2
    exit 127
  fi

  while ((attempt <= max_attempts)); do
    output="$(mktemp "${TMPDIR:-/tmp}/${label}.XXXXXX")"

    set +e
    ruby "$collector_script" "$@" >"$output"
    rc=$?
    set -e

    local validation_error=""
    if ((rc != 0)); then
      validation_error="collector completed with exit code $rc"
    elif ! test -s "$output"; then
      validation_error='collector completed without JSON output'
    elif ! jq empty "$output" >/dev/null 2>&1; then
      validation_error='collector completed with invalid JSON output'
    elif ! jq -e -s 'length == 1 and (.[0] | type == "object")' "$output" >/dev/null; then
      validation_error='collector completed without exactly one JSON object'
    fi

    if [[ -z $validation_error ]]; then
      cat "$output"
      return 0
    fi

    if ((attempt == max_attempts)); then
      printf '%s: %s after retry\n' "$label" "$validation_error" >&2
      ((rc == 0)) && rc=1
      exit "$rc"
    fi

    printf '%s: %s; retrying once\n' "$label" "$validation_error" >&2
    rm -f "$output"
    output=""
    ((attempt += 1))
  done
}
