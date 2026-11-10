#!/usr/bin/env bash
# #356: Mail Import into a mailbox that already has mail, from more than one
# source, repeated. Runs the repo's mail_import_run.sh in a THROWAWAY container
# of the hermes_dovecot image with no network: a second Dovecot inside it plays
# the source IMAP server with fake accounts. Nothing on the host or in the
# live hermes_dovecot is touched.
#
# Before v261107 the runner used `doveadm sync -1R`, which copied nothing from
# a second source's INBOX/Sent/... once the mailbox held a first source's.
source "$(dirname "$0")/../lib.sh"

image="${MAIL_IMPORT_TEST_IMAGE:-$(docker inspect -f '{{.Config.Image}}' hermes_dovecot 2>/dev/null)}"
[[ -n "$image" ]] || skip "hermes_dovecot is not running (needed for its image)"
runner="$HERMES_ROOT/config/dovecot-2.4/scripts/mail_import_run.sh"
[[ -f "$runner" ]] || { fail "runner not found: $runner"; done_check; }

inner="$(mktemp)"
trap 'rm -f "$inner"' EXIT
cat > "$inner" <<'INNER'
set -u
V=$(dovecot --version | sed 's/[-+ ].*//')
STATE=/logs/mail_import
mkdir -p /src /srcrun /tgt "$STATE"; chmod 777 /src /tgt

common() { # <home pattern>
cat <<C
first_valid_uid = 0
passdb static {
  driver = static
  passdb_static_password = pw
}
userdb static {
  driver = static
  fields {
    uid = 65534
    gid = 65534
    home = $1
  }
}
mail_driver = maildir
mail_path = ~/Maildir
namespace inbox {
  inbox = yes
  separator = /
}
C
}

{ printf 'dovecot_config_version = %s\ndovecot_storage_version = %s\n' "$V" "$V"
  printf 'base_dir = /srcrun\nlog_path = /tmp/srclog\nprotocols = imap\nlisten = 127.0.0.1\nauth_allow_cleartext = yes\n'
  printf 'service imap-login {\n  inet_listener imap {\n    port = 1143\n  }\n  inet_listener imaps {\n    port = 0\n  }\n}\n'
  common '/src/%{user}'
} > /tmp/src.conf
{ printf 'dovecot_config_version = %s\ndovecot_storage_version = %s\n' "$V" "$V"
  printf 'protocols =\nlog_path = /tmp/tgtlog\n'
  common '/tgt/%{user}'
} > /etc/dovecot/dovecot.conf
dovecot -c /tmp/src.conf && dovecot || { echo "RESULT setup=failed"; exit 0; }

S="doveadm -c /tmp/src.conf"
save() { # <conf> <user> <folder> <count> <tag>
  local i
  # Every fifth message has a folded Message-ID header (ID on the next line),
  # as Exchange writes them; it once broke the runner's UID sets.
  local i fold
  for i in $(seq 1 "$4"); do
    fold=' '; (( i % 5 == 0 )) && fold=$'\n '
    printf 'From: a@b\nSubject: %s %s\nMessage-ID:%s<%s.%s@test>\n\nbody\n' "$5" "$i" "$fold" "$5" "$i" \
      | doveadm -c "$1" save -u "$2" -m "$3"
  done
}
for u in support helpdesk; do $S mailbox create -u $u Sent; done
$S mailbox create -u helpdesk "Deleted Items"
$S mailbox create -u helpdesk "Skip Me"
save /tmp/src.conf support  INBOX 30 sup-in
save /tmp/src.conf support  Sent  10 sup-sent
save /tmp/src.conf helpdesk INBOX 20 hd-in
save /tmp/src.conf helpdesk Sent   5 hd-sent
save /tmp/src.conf helpdesk "Deleted Items" 3 hd-del
save /tmp/src.conf helpdesk "Skip Me" 4 hd-skip
save /etc/dovecot/dovecot.conf joe@test INBOX 3 local

run() { # <job id> <source user> <target> [exclude]
  local token; token=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')
  { printf 'HOST=127.0.0.1\nPORT=1143\nSSL=no\nVERIFY=no\nTARGET=%s\nQUOTA=0\nFEATURES=\nPREFIX=\n' "$3"
    printf 'SINCE_DAYS=0\nMAX_MB=0\nTIMEOUT=60\nJOB=%s\nUSER=%s\nPASS=pw\n' "$1" "$2"
    [[ -n "${4:-}" ]] && printf 'EXCLUDE=%s\n' "$4"
  } | bash /scripts/mail_import_run.sh start "$token" > /dev/null
  for _ in $(seq 1 120); do [[ -f "$STATE/$token.status" ]] && break; sleep 1; done
  sed -n 's/^exit=//p' "$STATE/$token.status" 2>/dev/null || echo timeout
}
count() { # <user> <folder>
  doveadm mailbox status -u "$1" messages "$2" 2>/dev/null | sed -n 's/.*messages=//p'
}

echo "RESULT run1_exit=$(run 1 support joe@test)"
echo "RESULT after_support_inbox=$(count joe@test INBOX)"
echo "RESULT run2_exit=$(run 2 helpdesk joe@test 'Skip Me')"
echo "RESULT after_helpdesk_inbox=$(count joe@test INBOX)"
echo "RESULT after_helpdesk_sent=$(count joe@test Sent)"
echo "RESULT after_helpdesk_deleted=$(count joe@test 'Deleted Items')"
echo "RESULT after_helpdesk_skip=$(count joe@test 'Skip Me')"
run 2 helpdesk joe@test 'Skip Me' > /dev/null
echo "RESULT repeat_inbox=$(count joe@test INBOX)"
echo "RESULT repeat_sent=$(count joe@test Sent)"
# New mail at the source, and one imported message deleted in Hermes.
save /tmp/src.conf helpdesk INBOX 2 hd-new
doveadm expunge -u joe@test mailbox INBOX header Message-ID '<hd-in.1@test>'
run 2 helpdesk joe@test 'Skip Me' > /dev/null
echo "RESULT incremental_inbox=$(count joe@test INBOX)"
# A mailbox already filled by the old sync-based runner gets no duplicates.
printf 'support' > /tmp/u; printf 'pw' > /tmp/p
{ cat /etc/dovecot/dovecot.conf
  printf 'imapc_host = 127.0.0.1\nimapc_port = 1143\nimapc_ssl = no\nimapc_user = </tmp/u\nimapc_password = </tmp/p\nimapc_features = no-metadata\n'
} > /tmp/old.conf
doveadm -c /tmp/old.conf sync -1R -u kim@test imapc: > /dev/null 2>&1
echo "RESULT legacy_before=$(count kim@test INBOX)"
run 3 support kim@test > /dev/null
echo "RESULT legacy_after=$(count kim@test INBOX)"
INNER

out="$(docker run --rm --network none \
        -v "$runner:/scripts/mail_import_run.sh:ro" -v "$inner:/inner.sh:ro" \
        --entrypoint bash "$image" /inner.sh 2>&1)"
r() { sed -n "s/^RESULT $1=//p" <<< "$out" | tail -1; }
expect() { # <key> <value> <description>
    local got; got="$(r "$1")"
    [[ "$got" == "$2" ]] && pass "$3" || fail "$3 (got '${got}', expected $2)"
}

if [[ "$(r setup)" == "failed" ]]; then
    fail "test harness did not start"; echo "$out" | tail -5; done_check
fi
expect run1_exit 0 "first source imports cleanly"
expect after_support_inbox 33 "first source merges into a mailbox with local mail (3 + 30)"
expect run2_exit 0 "second source imports cleanly"
expect after_helpdesk_inbox 53 "second source's INBOX merges in (33 + 20)"
expect after_helpdesk_sent 15 "second source's Sent merges in (10 + 5)"
expect after_helpdesk_deleted 3 "second source's new folder is created"
expect after_helpdesk_skip "" "Exclude Folders is honoured"
expect repeat_inbox 53 "repeat run copies nothing twice (INBOX)"
expect repeat_sent 15 "repeat run copies nothing twice (Sent)"
expect incremental_inbox 54 "repeat run takes only new mail and does not restore a deleted message (53 - 1 + 2)"
expect legacy_before 30 "harness: old sync-based import filled the mailbox"
expect legacy_after 30 "a mailbox filled by the old runner gets no duplicates"
done_check
