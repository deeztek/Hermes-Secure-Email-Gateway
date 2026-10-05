#!/usr/bin/env bash
# FRESH-INSTALL: covered-by config/hermes/var/www/html/schedule/inc/quarantine_token.cfm  a fresh install mints its first key with generateSecretKey(), so there is nothing to rotate
#
# v260918 -- rotate the quarantine release token key off its weak derivation
#
# WHY THIS EXISTS
#
# The HMAC key behind every quarantine release link used to be derived as
# hash(createUUID() & now() & randRange(100000,999999), "SHA-256"). Of those
# three inputs now() carries no entropy at all, randRange() without an algorithm
# argument is java.util.Random rather than SecureRandom, and createUUID()'s
# generation is undocumented in Lucee. Hashing weak inputs does not enlarge the
# space behind them, it only makes the output look random.
#
# getQuarantineReleaseKey() returns the existing file when one is present, so
# fixing the derivation alone would leave every existing install on its old key
# forever. Only a rotation reaches them.
#
# Forging a token also requires a valid mail_id, which is not guessable from
# outside, so this was never remotely exploitable on its own. It is still not a
# property worth keeping.
#
# Reported by @quietvw.
#
# WHAT IT DOES
#
# Deletes the key file when it still holds an old-format key. The next
# quarantine notice regenerates it through generateSecretKey("AES").
#
# COST: release links already in recipients' mailboxes stop working. Links are
# valid for 72 hours, so that is at most 72 hours of notices whose Release
# button returns "This release link is not valid". Anything older had already
# expired. Recipients can still release from the User Portal.
#
# Idempotent: the old format is 64 hex characters, the new one is base64. A
# second run sees the new key and does nothing.

set -euo pipefail

KEYFILE=/opt/hermes/keys/quarantine_release_key

if ! docker ps --format '{{.Names}}' | grep -qx hermes_commandbox; then
    echo "  hermes_commandbox is not running; skipping key rotation."
    exit 0
fi

if ! docker exec hermes_commandbox test -f "$KEYFILE" 2>/dev/null; then
    echo "  No quarantine release key yet; nothing to rotate."
    exit 0
fi

current="$(docker exec hermes_commandbox cat "$KEYFILE" 2>/dev/null | tr -d '\r\n' || true)"

if ! printf '%s' "$current" | grep -qE '^[0-9a-f]{64}$'; then
    echo "  Quarantine release key is already in the new format; nothing to do."
    exit 0
fi

if docker exec hermes_commandbox rm -f "$KEYFILE" 2>/dev/null; then
    echo "  Rotated the quarantine release token key."
    echo "  Release links issued in the last 72 hours will no longer work."
    echo "  Recipients can still release from the User Portal."
else
    echo "  WARNING: could not remove ${KEYFILE}; key not rotated."
fi
