#!/usr/bin/env bash
#
# v260815 -- reconcile SAN validation state against the certificates on disk
#
# WHY THIS EXISTS
#
# Postfix is told to consult a per-domain certificate map by
# `tls_server_sni_maps`, and the console decides whether to set that
# directive by COUNTING rows:
#
#     SELECT COUNT(DISTINCT certificate) FROM mailbox_sans
#     WHERE mailbox_domain = '1' AND DNS = 'YES'
#
# but the map itself is only written for certificates whose files are
# actually present. When those two disagree, Postfix is pointed at a map
# that was never written, every TLS handshake offering SNI fails, and
# INBOUND MAIL STOPS. It fails closed and says so only in a warning:
#
#     warning: hash:/etc/postfix/sni_maps is unavailable
#     warning: tls_server_sni_maps: <host> map lookup problem
#     SSL_accept error from <sender>
#
# They disagree whenever a certificate's files vanish while its SAN rows
# keep DNS = 'YES'. Three ways that happens, all seen in the field:
#
#   1. The certificate was deleted. Until this release, deleting one threw
#      before it could clear the SAN rows, so they survived. See the
#      certificate-delete fix in this same release.
#   2. The certificate is still Pending. Requested, never issued, so no
#      files, while SAN rows validated against an EARLIER certificate stay
#      marked DNS = 'YES'.
#   3. It was imported without its chain, so no _hermes.bundle.pem exists.
#
# Case 1 is nastier than it looks. system_certificates is InnoDB, whose
# auto-increment counter is recalculated as MAX(id)+1 after a restart, so
# re-issuing can hand the new certificate the SAME id the deleted one had.
# The stale rows then point at a valid id again, which is why the SQL
# cleanup in this release cannot catch them: they are stale by history, not
# by foreign key. Only the filesystem knows.
#
# WHAT THIS DOES
#
# For every certificate with SAN rows marked validated, derives the path the
# console itself would use, checks it inside the Postfix container, and
# DELETES the rows of any whose files are missing.
#
# Delete rather than clear, because mailbox_sans is derived state, not
# configuration. sync_mailbox_sans.cfm rebuilds it from additional_sans x
# mailbox-hosting domains, which is where the operator's intent actually
# lives. A row means "this FQDN was validated against certificate N", so
# once N's files are gone the row has nothing left to say, and merely
# clearing dns would leave it still claiming an association with a dead
# certificate. That half-state is what caused this in the first place.
# Anything legitimate comes back on the next sync.
#
# It also REPORTS, without changing, any of the three console/smtp/mail
# certificate bindings that point at a certificate whose files are missing.
# Those are operator choices rather than derived state, so this says so and
# leaves them alone. Nginx and Dovecot both fall back to the bootstrap
# certificate when their files are absent; Postfix SMTP TLS does not, which
# is guarded at the point of selection instead.
#
# It then removes a dangling tls_server_sni_maps from the LIVE Postfix
# config, but only when the map file is genuinely absent. That is a single
# `postconf -X`, not a regeneration of main.cf: an unattended rewrite of a
# live main.cf is a good way to stop a gateway accepting mail. The console
# puts the directive back the moment a real certificate exists.
#
# Idempotent: on a healthy install every path resolves, nothing is updated,
# and the directive is left alone.

set -euo pipefail

log()  { echo "[v260815] $*"; }
warn() { echo "[v260815] WARNING: $*" >&2; }

# Locate the repo root by walking up for docker-compose.yml, rather than a
# dirname chain that breaks if this file ever moves.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$here"
while [[ "$root" != "/" && ! -f "$root/docker-compose.yml" ]]; do
    root="$(dirname "$root")"
done
if [[ ! -f "$root/docker-compose.yml" ]]; then
    warn "Could not locate the Hermes root; skipping SNI reconciliation."
    exit 0
fi

db() { docker exec -i hermes_db_server mariadb -u root -N -B hermes; }

# Nothing to do if the containers this needs are not up. Not an error: the
# orchestrator may be running before everything has settled.
for c in hermes_db_server hermes_postfix_dkim; do
    if ! docker inspect -f '{{.State.Running}}' "$c" 2>/dev/null | grep -q true; then
        warn "$c is not running; skipping SNI reconciliation."
        exit 0
    fi
done

# Every certificate currently claiming validated SANs, with the fields
# needed to rebuild its path. -N -B gives tab-separated rows with no header.
rows="$(printf '%s\n' "
SELECT DISTINCT ms.certificate, sc.type, sc.file_name
FROM mailbox_sans ms
JOIN system_certificates sc ON sc.id = ms.certificate
WHERE ms.dns = 'YES';" | db || true)"

if [[ -z "$rows" ]]; then
    log "No certificates have validated SANs; nothing to reconcile."
else
    stale_ids=()
    while IFS=$'\t' read -r cert_id cert_type file_name; do
        [[ -z "${cert_id:-}" ]] && continue

        case "$cert_type" in
            Acme)     path="/etc/letsencrypt/live/${file_name}/fullchain.pem" ;;
            Imported) path="/opt/hermes/ssl/${file_name}_hermes.bundle.pem" ;;
            *)        warn "Certificate ${cert_id} has unknown type '${cert_type}'; treating as missing."
                      path="" ;;
        esac

        if [[ -n "$path" ]] && docker exec hermes_postfix_dkim test -f "$path" 2>/dev/null; then
            continue
        fi

        log "Certificate ${cert_id} (${file_name}) is marked validated but its file is absent:"
        log "    ${path:-<no path for type ${cert_type}>}"
        stale_ids+=("$cert_id")
    done <<< "$rows"

    if (( ${#stale_ids[@]} == 0 )); then
        log "All validated SAN certificates are present on disk."
    else
        ids="$(IFS=,; echo "${stale_ids[*]}")"
        printf '%s\n' "DELETE FROM mailbox_sans WHERE certificate IN (${ids});" | db
        log "Removed SAN rows for certificate(s): ${ids}"
        log "These are rebuilt from additional_sans by the next SAN sync, so nothing"
        log "an operator configured is lost. Re-run SAN validation once a certificate"
        log "has actually been issued."
    fi
fi

# The three single-certificate bindings are operator choices, not derived
# state, so report and do not touch. Nginx and Dovecot fall back to the
# bootstrap certificate when files are missing; Postfix SMTP TLS does not,
# and is guarded at selection time from this release on. An install that
# already has a bad binding needs a human to pick a different certificate.
bindings="$(printf '%s\n' "
SELECT p.parameter, p.value2, sc.type, sc.file_name
FROM parameters2 p
JOIN system_certificates sc ON sc.id = p.value2
WHERE p.parameter IN ('console.certificate','smtp.certificate','mail.certificate');" | db || true)"

if [[ -n "$bindings" ]]; then
    while IFS=$'\t' read -r pname cert_id cert_type file_name; do
        [[ -z "${pname:-}" ]] && continue
        case "$cert_type" in
            Acme)     bpath="/etc/letsencrypt/live/${file_name}/fullchain.pem" ;;
            Imported) bpath="/opt/hermes/ssl/${file_name}_hermes.pem" ;;
            *)        bpath="" ;;
        esac
        if [[ -n "$bpath" ]] && docker exec hermes_postfix_dkim test -f "$bpath" 2>/dev/null; then
            continue
        fi
        warn "${pname} points at certificate ${cert_id} (${file_name}) whose files are missing:"
        warn "    ${bpath:-<no path for type ${cert_type}>}"
        case "$pname" in
            console.certificate) warn "    Nginx falls back to the bootstrap certificate, so the console still serves." ;;
            mail.certificate)    warn "    Dovecot falls back to the bootstrap certificate, so IMAP still serves." ;;
            smtp.certificate)    warn "    Postfix does NOT fall back. Pick a different certificate under SMTP TLS Settings." ;;
        esac
        warn "    Not changed automatically: which certificate to use is your decision."
    done <<< "$bindings"
fi

# A live main.cf pointing at a map that is not there refuses TLS on every
# connection offering SNI. Remove the directive, and ONLY when the map is
# genuinely missing, so a healthy install is untouched.
if docker exec hermes_postfix_dkim postconf -n 2>/dev/null | grep -q '^tls_server_sni_maps'; then
    if docker exec hermes_postfix_dkim test -f /etc/postfix/sni_maps.db 2>/dev/null; then
        log "tls_server_sni_maps is set and its map exists; leaving it alone."
    else
        warn "tls_server_sni_maps is set but /etc/postfix/sni_maps.db does not exist."
        warn "In this state Postfix refuses TLS and inbound mail stops. Removing the directive."
        docker exec hermes_postfix_dkim postconf -X tls_server_sni_maps >/dev/null 2>&1 || true
        docker exec hermes_postfix_dkim postfix reload >/dev/null 2>&1 || true
        log "Removed. The console restores it automatically once a validated certificate exists."
    fi
fi
