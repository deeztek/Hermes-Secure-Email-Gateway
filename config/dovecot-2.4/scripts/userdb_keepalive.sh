#!/bin/sh
#
# Hermes SEG - keep the Dovecot auth-worker's database connection warm
#
# WHAT THIS IS FOR (GitHub #342)
#
# The auth-worker holds one pooled MySQL connection. When that connection has
# gone away, it detects this on next use and then CRASHES in the retry path
# instead of reconnecting, with SIGSEGV, SIGABRT, "free(): invalid pointer" or
# "munmap_chunk(): invalid pointer" depending on where it lands.
#
# LMTP consults the userdb at RCPT TO, so the visible symptom is a local
# mailbox refusing mail with "451 4.3.0 Temporary internal error" and Postfix
# deferring it. Nothing is lost: the worker respawns at once, and the retry a
# few minutes later succeeds. It is a delay, not a failure, which is exactly
# why it went unnoticed for months.
#
# This is not a fix. The crash is a Dovecot defect, reported upstream in 2021
# and never answered, and no configuration setting prevents it. What this does
# is stop the connection ever going stale, by using it more often than the
# database's idle timeout. If one does go stale anyway, this scheduled lookup
# takes the crash and real mail meets a freshly respawned worker.
#
# WHY A DELIBERATELY NON-EXISTENT ADDRESS
#
# The lookup does not need to succeed. It only needs Dovecot to RUN the userdb
# query, which is what keeps the connection in use. A real mailbox would tie
# this to data someone might delete, and would not work at all on a relay-only
# deployment, which has no mailboxes. A reserved .invalid address always
# exercises the query and never resolves to anything.
#
# TWO THINGS THAT WOULD SILENTLY BREAK THIS
#
# 1. The schedule must stay well under MariaDB's wait_timeout. It is 28800
#    (8 hours) and this job runs every 4. Lower wait_timeout below the job
#    interval and the connection starts going stale again between runs.
#    See the note in config/database/etc/my.cnf.d/hermes.cnf.
#
# 2. Dovecot auth caching must stay off. It is off by default and Hermes does
#    not set auth_cache_size. Turn it on and a repeated negative lookup can be
#    served from cache without reaching the database, so this job would run,
#    report success, and warm nothing. See the note in
#    /opt/hermes/templates/dovecot.conf.
#
# Both fail quietly and months later, which is why they are written down here
# and in the two files someone would be editing at the time.
#
# Harmless but pointless on a relay-only server: no mailboxes means no userdb
# lookups, so there is no exposure to the bug in the first place. It runs
# everywhere rather than being conditionally generated, because one schedule is
# easier to reason about than two.

# Failure is expected and fine. The address does not exist, so doveadm exits
# non-zero after running the query, which is all we wanted. Swallow it so the
# scheduler does not record a failed job every four hours.
doveadm user keepalive@hermes.invalid >/dev/null 2>&1 || true

exit 0
