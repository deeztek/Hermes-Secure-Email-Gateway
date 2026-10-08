#!/usr/bin/env bash
# The internal API relay is gone and nothing answers for it through nginx.
# Regression for GHSA-4p63-cq8w-q87g (v261006) and #349 (v261008).
source "$(dirname "$0")/../lib.sh"

if [[ ! -e config/hermes/var/www/html/hermes-api ]]; then
    pass "hermes-api/ directory absent"
else
    fail "config/hermes/var/www/html/hermes-api still exists"
fi

if grep -q '"/hermes-api"' config/hermes/var/www/html/server.json; then
    fail "server.json still maps /hermes-api"
else
    pass "server.json has no /hermes-api alias"
fi

if grep -rqsE '^[[:space:]]*location[[:space:]].*/hermes-api' \
        config/nginx/etc/nginx/sites-available config/nginx/etc/nginx/sites-enabled; then
    fail "live nginx config still has a /hermes-api location"
else
    pass "no /hermes-api location in the live nginx config"
fi

host="$(grep -E '^CONSOLE_HOST=' .env 2>/dev/null | cut -d= -f2- | tr -d "\"'\r")"
if [[ -z "$host" ]]; then
    fail "CONSOLE_HOST missing from .env, cannot test through nginx"
else
    body="$(curl -sk --max-time 15 --resolve "$host:443:127.0.0.1" "https://$host/hermes-api/" \
        -H 'X-Token: regression' -H 'X-Original-URL: /admin/2/inc/check_hibp.cfm')"
    if grep -qE 'Invalid Request|Unauthorized|Authorized' <<<"$body"; then
        fail "https://$host/hermes-api/ reached the API"
    else
        pass "https://$host/hermes-api/ does not reach the API"
    fi
fi

done_check
