#!/usr/bin/env bash
# FRESH-INSTALL: covered-by config/hermes/opt/hermes/conf_files/ofelia_config.ini  the template carries smtp-tls-skip-verify, so a fresh install renders it and this is a no-op
#
# v260912 -- let Ofelia's failure notifications actually send
#
# WHY THIS EXISTS
#
# Ofelia emails admin_email when a scheduled job fails. It dials
# hermes_postfix_dkim by container name, and :10026 offers STARTTLS with the
# console certificate. No certificate carries a container name as a SAN, so
# verification fails, the mail is dropped, and the failure it existed to report
# goes unnoticed.
#
# Every install, not a particular one: the container name is constant, so the
# mismatch does not depend on which certificate is present.
#
# #303 already fixed the networking half of this by putting Ofelia on
# hermes_net_ext so :10026 would accept it at all. This is the remaining half.
#
# smtp-tls-skip-verify keeps the hop encrypted and makes Ofelia behave like
# everything else on that port: Postfix connects there with opportunistic TLS
# and logs "Untrusted TLS connection established" for the identical mismatch.
#
# WHAT IT DOES
#
# Edits the GENERATED config, which is what the container reads. The template is
# fixed in the repo, but an upgrade never re-runs ofelia_generate_config.cfm, so
# without this an upgraded gateway keeps sending nothing.
#
# Works through docker cp rather than a filesystem path, so it needs no install
# root and no tools inside the image, which is minimal. Same reasoning as
# 10-restore-body-milter-chain.sh, which stays entirely inside docker exec.
#
# Idempotent: already present, or Ofelia not running, and it does nothing.
set -uo pipefail

if ! docker ps --format '{{.Names}}' | grep -qx hermes_ofelia; then
    echo "  hermes_ofelia is not running; skipping notification fix."
    exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if ! docker cp hermes_ofelia:/etc/ofelia/config.ini "$tmp/config.ini" 2>/dev/null; then
    echo "  WARNING: could not read Ofelia's config; skipping."
    exit 0
fi

if grep -q '^smtp-tls-skip-verify' "$tmp/config.ini"; then
    echo "  ofelia notification TLS setting already present"
    exit 0
fi

if ! grep -q '^smtp-port' "$tmp/config.ini"; then
    echo "  WARNING: no smtp-port line in Ofelia's config; leaving it alone."
    exit 0
fi

sed -i '/^smtp-port/a smtp-tls-skip-verify = true' "$tmp/config.ini"

if ! docker cp "$tmp/config.ini" hermes_ofelia:/etc/ofelia/config.ini 2>/dev/null; then
    echo "  WARNING: could not write Ofelia's config; leaving it alone."
    exit 0
fi
echo "  ofelia: smtp-tls-skip-verify added"

docker restart hermes_ofelia >/dev/null 2>&1 \
    && echo "  hermes_ofelia restarted" \
    || echo "  WARNING: could not restart hermes_ofelia; restart it manually"
exit 0
