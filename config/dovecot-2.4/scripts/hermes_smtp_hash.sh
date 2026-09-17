#!/bin/sh
set -eu

# Reads SMTP password from stdin and returns doveadm hash output on stdout.
if ! command -v script >/dev/null 2>&1; then
  echo "SCRIPT_UTILITY_MISSING" >&2
  exit 127
fi

tmp_dir="$(mktemp -d /tmp/hermes_smtp_hash.XXXXXX)" || {
  echo "TEMP_DIR_CREATE_FAILED" >&2
  exit 1
}
[ -n "$tmp_dir" ] || {
  echo "TEMP_DIR_CREATE_FAILED" >&2
  exit 1
}

cleanup() {
  if [ -n "${password_file:-}" ]; then
    rm -f "$password_file"
  fi
  rmdir "$tmp_dir" 2>/dev/null || true
}
trap cleanup EXIT INT TERM HUP

password_file="$tmp_dir/password.input"
cat > "$password_file" || {
  echo "PASSWORD_READ_FAILED" >&2
  exit 1
}

if script -q -c "doveadm pw -s ARGON2ID" /dev/null < "$password_file"; then
  hash_rc=0
else
  hash_rc=$?
fi

exit "$hash_rc"
