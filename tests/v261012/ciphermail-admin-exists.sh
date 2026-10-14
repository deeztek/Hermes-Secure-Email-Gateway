#!/usr/bin/env bash
# CipherMail has an enabled admin account with login and admin roles (#306). Read-only.
source "$(dirname "$0")/../lib.sh"

n="$(docker exec hermes_db_server mariadb -u root -N -s djigzo -e "
  SELECT COUNT(DISTINCT a.cm_id) FROM cm_admin a
  JOIN cm_admin_cm_authorities x ON x.cm_admin = a.cm_id
  JOIN cm_authority r ON r.cm_id = x.cm_authorities
  WHERE a.cm_enabled = 1 AND r.cm_role = 'ROLE_ADMIN';" 2>/dev/null)"
[[ "$n" =~ ^[1-9][0-9]*$ ]] && pass "CipherMail has $n enabled admin account(s)" \
    || fail "CipherMail has no enabled admin account ('$n'); /ciphermail cannot be logged into"

done_check
