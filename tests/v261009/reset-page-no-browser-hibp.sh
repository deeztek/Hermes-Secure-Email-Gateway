#!/usr/bin/env bash
# The password reset page has no browser-side breached-password check (#350).
source "$(dirname "$0")/../lib.sh"

f=config/hermes/var/www/html/user-auth/reset_password.cfm
if grep -q "check_hibp" "$f"; then
    fail "reset_password.cfm still references check_hibp from the browser"
else
    pass "reset_password.cfm has no browser-side breached-password check"
fi

if grep -q "api.pwnedpasswords.com/range" "$f"; then
    pass "server-side breached-password check still present"
else
    fail "server-side breached-password check missing from reset_password.cfm"
fi

done_check
