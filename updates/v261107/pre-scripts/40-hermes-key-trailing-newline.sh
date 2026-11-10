#!/usr/bin/env bash
# FRESH-INSTALL: n/a  v261107's installer writes hermes.key without a newline
#
# v261107 -- keep stored credentials readable on Lucee 6.2 (#402).
#
# hermes.key is the AES key every encrypted credential in the database was
# made with. Installs wrote it with a trailing newline (`openssl rand -base64
# 32 > hermes.key`, and cffile's default addnewline). Lucee 5 ignored that
# newline when decoding the key; Lucee 6.2 does not, derives different key
# bytes from the same file, and every credential stored before the upgrade
# fails with "Given final block not properly padded" (relay host and domain
# transport credentials, malware feed API keys, CipherMail secrets, ...).
#
# Removing the trailing whitespace makes Lucee 6.2 derive exactly the key
# Lucee 5 used, so nothing has to be re-encrypted. This runs before the new
# console image starts, so nothing has been written with the other key yet.
#
# Rewritten in place (same inode, owner and mode). A copy of the original is
# kept beside it as hermes.key.pre-v261107 (mode 600). Idempotent: a key with
# no trailing whitespace is left alone.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        [[ -f "$HERMES_ROOT/docker-compose.yml" ]] && break
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "  Could not locate docker-compose.yml walking up from $SCRIPT_DIR; skipping." >&2
        exit 0
    fi
fi

KEY="${HERMES_ROOT}/config/hermes/opt/hermes/keys/hermes.key"
[[ -f "$KEY" ]] || { echo "  No hermes.key; nothing to change."; exit 0; }

clean="$(tr -d ' \t\r\n' < "$KEY")"
if [[ ! "$clean" =~ ^[A-Za-z0-9+/]+=*$ ]]; then
    echo "  hermes.key is not a single base64 value; left alone." >&2
    exit 0
fi
if [[ "$(wc -c < "$KEY")" -eq "${#clean}" ]]; then
    echo "  hermes.key has no trailing newline."
    exit 0
fi

backup="${KEY}.pre-v261107"
if [[ ! -e "$backup" ]]; then
    ( umask 077; cp -p "$KEY" "$backup" )
    chmod 600 "$backup"
fi
printf '%s' "$clean" > "$KEY"
echo "  hermes.key trailing newline removed (backup: keys/hermes.key.pre-v261107)."
