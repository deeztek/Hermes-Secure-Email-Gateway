#!/usr/bin/env bash
#
# v260815 -- point smtpd_tls_cert_file at the chain, on installs that already
# had a certificate bound
#
# WHY THIS EXISTS
#
# Postfix sends the peer whatever is in smtpd_tls_cert_file. That was pointed
# at the bare leaf: _hermes.pem for an imported certificate, cert.pem for an
# ACME one, with the intermediates passed separately as smtpd_tls_CAfile, which
# exists to verify remote CLIENT certificates and does not reliably put the
# server's own chain on the wire. A peer without the intermediate cached had no
# path to a trust anchor, which for a sending MTA can mean refusing TLS or
# falling back to plaintext. The symptom is one certificate instead of several:
#
#     openssl s_client -connect <host>:465 -showcerts | grep -c "BEGIN CERT"
#
# The code fix is in edit_smtp_tls_settings.cfm. This exists because that fix
# alone does not reach an install that already has a certificate bound.
#
# Nginx and Dovecot compute their certificate path every time their config is
# generated, so both correct themselves as soon as this upgrade runs. SMTP TLS
# does not: edit_smtp_tls_settings.cfm writes the literal path into the
# parameters table, and generate_postfix_configuration.cfm only emits what is
# stored. So the stale leaf path survives every regeneration until an
# administrator happens to open that page and save it, which is not a thing to
# leave to chance for a setting that governs whether mail is accepted over TLS.
#
# WHAT THIS DOES
#
# Rewrites the stored path from the leaf to the chain-bearing file, and only
# when that file is genuinely present:
#
#     <name>_hermes.pem            ->  <name>_hermes.bundle.pem
#     <dir>/cert.pem               ->  <dir>/fullchain.pem
#
# Anything else is left alone. If the replacement is missing, nothing changes:
# a leaf-only chain is a degraded certificate, whereas a path to a file that
# does not exist stops Postfix serving TLS at all, and this must not turn the
# first into the second.
#
# Idempotent: a path already pointing at the chain does not match.

set -euo pipefail

log()  { echo "[v260815] $*"; }
warn() { echo "[v260815] WARNING: $*" >&2; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$here"
while [[ "$root" != "/" && ! -f "$root/docker-compose.yml" ]]; do
    root="$(dirname "$root")"
done
if [[ ! -f "$root/docker-compose.yml" ]]; then
    warn "Could not locate the Hermes root; skipping the SMTP TLS chain path."
    exit 0
fi

for c in hermes_db_server hermes_postfix_dkim; do
    if ! docker inspect -f '{{.State.Running}}' "$c" 2>/dev/null | grep -q true; then
        warn "$c is not running; skipping the SMTP TLS chain path."
        exit 0
    fi
done

db() { docker exec -i hermes_db_server mariadb -u root -N -B hermes; }

current="$(printf '%s\n' "
SELECT parameter FROM parameters
WHERE parent_name = 'smtpd_tls_cert_file' AND child = '1' AND enabled = '1'
LIMIT 1;" | db || true)"
current="$(printf '%s' "$current" | tr -d '\r')"

if [[ -z "$current" ]]; then
    log "No SMTP TLS certificate is configured; nothing to correct."
    exit 0
fi

case "$current" in
    *_hermes.pem)  wanted="${current%_hermes.pem}_hermes.bundle.pem" ;;
    */cert.pem)    wanted="${current%/cert.pem}/fullchain.pem" ;;
    *)             log "SMTP TLS certificate path already carries the chain; nothing to correct."
                   exit 0 ;;
esac

if ! docker exec hermes_postfix_dkim test -f "$wanted" 2>/dev/null; then
    warn "Would point SMTP TLS at ${wanted}, but that file is not there."
    warn "Leaving ${current} in place: serving a leaf without its chain is degraded,"
    warn "whereas naming a file that does not exist stops Postfix serving TLS at all."
    warn "Re-import the certificate with its CA chain, then save SMTP TLS Settings."
    exit 0
fi

printf '%s\n' "
UPDATE parameters SET parameter = '${wanted}'
WHERE parent_name = 'smtpd_tls_cert_file' AND child = '1' AND enabled = '1';" | db

docker exec hermes_postfix_dkim postconf -e "smtpd_tls_cert_file=${wanted}" >/dev/null 2>&1 || true
docker exec hermes_postfix_dkim postfix reload >/dev/null 2>&1 || true

log "SMTP TLS now serves the full chain:"
log "    was: ${current}"
log "    now: ${wanted}"
log "Confirm with: openssl s_client -connect <host>:465 -showcerts | grep -c 'BEGIN CERT'"
