#!/usr/bin/env bash
# Shared validation helpers for reusable build and quality scripts.

# Validate the test configuration name supplied through kind.
validate_config() {
  local value="${kind:-}"

  if [[ -z $value || ! $value =~ ^[A-Za-z0-9_.-]+$ || $value == *..* ]]; then
    echo "invalid kind: $value" >&2
    return 1
  fi
}

# Validate the Go package path supplied through package.
validate_package() {
  local value="${package:-}"
  local remaining
  local part

  if [[ -z $value || $value == /* || $value == *..* ]]; then
    echo "invalid package: $value" >&2
    return 1
  fi

  if [[ $value == "." ]]; then
    return 0
  fi

  remaining="$value"
  while [[ $remaining == */* ]]; do
    part="${remaining%%/*}"

    if ! _validate_package_part "$part"; then
      echo "invalid package: $value" >&2
      return 1
    fi

    remaining="${remaining#*/}"
  done

  if ! _validate_package_part "$remaining"; then
    echo "invalid package: $value" >&2
    return 1
  fi
}

# Validate profile filename components supplied through environment variables.
validate_profile() {
  local key
  local value

  for key in "$@"; do
    value="${!key:-}"

    if [[ -z $value ]]; then
      continue
    fi

    if [[ ! $value =~ ^[A-Za-z0-9_.-]+$ || $value == *..* ]]; then
      echo "invalid $key: $value" >&2
      return 1
    fi
  done
}

_validate_package_part() {
  local part="$1"

  [[ -n $part && $part != "." && $part =~ ^[A-Za-z0-9_.-]+$ ]]
}
