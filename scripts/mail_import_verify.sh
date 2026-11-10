#!/usr/bin/env bash
# Read-only: list source IMAP messages whose Message-ID is in NO folder of a
# Hermes mailbox. Run on the Docker host. Nothing is written to either mailbox.
# The source password is read without echo, passed on stdin, kept in a mode 600
# temp dir inside hermes_dovecot and removed on exit.
set -euo pipefail

read -rp "Source IMAP host: " HOST
read -rp "Source port [993]: " PORT; PORT=${PORT:-993}
read -rp "Source SSL (imaps/starttls/no) [imaps]: " SSL; SSL=${SSL:-imaps}
read -rp "Source username: " SUSER
read -rsp "Source password: " SPASS; echo
read -rp "Hermes mailbox (e-mail address): " TARGET

{ printf '%s\n' "$SUSER"; printf '%s\n' "$SPASS"; } | docker exec -i hermes_dovecot bash -c "$(cat <<'INNER'
set -u
host="$1" port="$2" ssl="$3" target="$4"
umask 077
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
IFS= read -r u; IFS= read -r p
printf '%s' "${u//%\{/%%\{}" > "$d/user"; printf '%s' "${p//%\{/%%\{}" > "$d/pw"
{ grep -m1 '^dovecot_config_version' /etc/dovecot/dovecot.conf
  printf '!include /etc/dovecot/dovecot.conf\n'
  printf 'imapc_host = %s\nimapc_port = %s\nimapc_ssl = %s\n' "$host" "$port" "$ssl"
  printf 'imapc_user = <%s\nimapc_password = <%s\n' "$d/user" "$d/pw"
  printf 'imapc_features = no-metadata\nsieve_enabled = no\n'
} > "$d/job.conf"

# Hermes side: every Message-ID in every folder. A folded header puts the ID on
# its own line; trimming each line handles that.
doveadm -f tab fetch -u "$target" 'hdr.message-id' all 2>/dev/null \
  | tail -n +2 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | grep -v '^$' | sort -u > "$d/have"

# Source side: folder, uid, Message-ID (continuation lines joined back).
if ! doveadm -c "$d/job.conf" -o mail_driver=imapc -o mail_path= -f tab \
       fetch -u "$target" 'mailbox uid hdr.message-id' all > "$d/src" 2> "$d/err"; then
  if [[ ! -s "$d/src" ]]; then echo "Could not read the source:"; tail -3 "$d/err"; exit 1; fi
fi

awk -F'\t' -v total=0 '
  FILENAME == ARGV[1] { have[$0] = 1; next }
  FNR == 1 { next }
  function emit() { if (mb == "") return; gsub(/^[ \t]+|[ \t]+$/, "", id); total++
                    if (id == "") { noid++; return }
                    if (!(id in have)) { missing++; printf "MISSING  %s  uid %s  %s\n", mb, uid, id } }
  /^[^\t]*\t[0-9]+\t/ { emit(); mb = $1; uid = $2; id = substr($0, length($1) + length($2) + 3); next }
  { id = id " " $0 }
  END { emit()
        printf "\nSource messages: %d   in Hermes: %d   missing: %d   no Message-ID (not checkable): %d\n",
               total, total - missing - noid, missing + 0, noid + 0 }
' "$d/have" "$d/src"
INNER
)" -- "$HOST" "$PORT" "$SSL" "$TARGET"
