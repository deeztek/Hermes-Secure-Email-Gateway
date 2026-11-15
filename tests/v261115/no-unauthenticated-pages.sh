#!/usr/bin/env bash
# GHSA-wwxm-p5f2-q6xm, GHSA-rgx7-j3qv-h2gm: include fragments under
# /user-auth/ were directly requestable without signing in, and trusted their
# caller. This requests every CFML page in the web root WITHOUT a session,
# through nginx, the way an outsider would:
#   - /user-auth/: only the public pages may answer; everything else is 404
#     (including the helpers removed in v261115 and path-spelling variants)
#   - /users/ and /admin/: every page must send the visitor to the login
#     (302/401/403); a 200 or a 500 means a page runs without a session
# Read-only: GET requests only, no cookies.
source "$(dirname "$0")/../lib.sh"

webroot="$HERMES_ROOT/config/hermes/var/www/html"
[[ -d "$webroot/user-auth" ]] || skip "web root not found under $HERMES_ROOT"

host="$(db "SELECT value2 FROM parameters2 WHERE module='console' AND parameter='console.host' LIMIT 1")"
[[ -n "$host" ]] || skip "console.host not set in parameters2"
curl -sk -o /dev/null --max-time 10 --resolve "$host:443:127.0.0.1" "https://$host/" \
    || skip "nginx not answering on 127.0.0.1:443 for $host"

code() {   # code <path> -> HTTP status, no cookies, no redirects followed
    curl -sk -o /dev/null -w '%{http_code}' --max-time 20 \
         --resolve "$host:443:127.0.0.1" "https://$host$1"
}

public="index.cfm forgot_password.cfm reset_password.cfm quarantine_release.cfm"

# ---- /user-auth/ ----
bad=0; n=0
while IFS= read -r f; do
    rel="/${f#"$webroot"/}"
    base="${rel#/user-auth/}"
    c="$(code "$rel")"; n=$((n + 1))
    if [[ " $public " == *" $base "* ]]; then
        [[ "$c" == "404" || "$c" == 5* || "$c" == "000" ]] && { fail "public page $rel answers $c"; bad=1; }
    else
        [[ "$c" == "404" ]] || { fail "$rel answers $c without a session (want 404)"; bad=1; }
    fi
done < <(find "$webroot/user-auth" -name '*.cfm' -not -path '*/.*')
[[ $bad -eq 0 ]] && pass "/user-auth/: $n files, only the public pages answer"

# removed helpers and spelling variants must stay unreachable
bad=0
for p in /user-auth/inc/ldap_modify_user_password.cfm \
         /user-auth/inc/process_password_reset_request.cfm \
         /user-auth/inc/notify_admins_reset_request.cfm \
         //user-auth/inc/ldap_modify_user_password.cfm \
         /user-auth/./inc/ldap_modify_user_password.cfm \
         /user-auth/x/../inc/ldap_modify_user_password.cfm \
         /user-auth/inc/html_head.cfm \
         /user-auth/error.cfm; do
    c="$(code "$p")"
    [[ "$c" == "404" ]] || { fail "$p answers $c (want 404)"; bad=1; }
done
[[ $bad -eq 0 ]] && pass "removed helpers and path variants: all 404"

# ---- /users/ and /admin/: login required everywhere ----
for area in users admin; do
    bad=0; n=0
    while IFS= read -r f; do
        rel="/${f#"$webroot"/}"
        c="$(code "$rel")"; n=$((n + 1))
        case "$c" in
            302|401|403|404) ;;
            *) fail "$rel answers $c without a session (want a login redirect)"; bad=1 ;;
        esac
    done < <(find "$webroot/$area" -name '*.cfm' -not -path '*/.*')
    [[ $bad -eq 0 ]] && pass "/$area/: $n pages, none runs without a session"
done

# ---- components: never requestable, anywhere ----
bad=0; n=0
while IFS= read -r f; do
    rel="/${f#"$webroot"/}"
    c="$(code "$rel")"; n=$((n + 1))
    [[ "$c" == "404" ]] || { fail "$rel answers $c (want 404)"; bad=1; }
done < <(find "$webroot/user-auth" "$webroot/users" "$webroot/admin" -name '*.cfc' -not -path '*/.*')
[[ $bad -eq 0 ]] && pass "components (.cfc): $n files, all 404"

done_check
