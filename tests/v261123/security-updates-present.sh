#!/usr/bin/env bash
# v261123 is an images-only security release. Every claim it makes is a
# package version, so check the running containers, as floors (later
# releases ship newer packages):
#   nginx (Ubuntu) 1.24.0-2ubuntu7.21  nginx security release of 2026-11-18
#   OpenJDK 21 21.0.13.1 / 11 11.0.33.1  OpenJDK advisory of 2026-11-17 (#420)
#   Nextcloud 34.0.6 in .env.template and the live .env (PHP fixes of
#   2026-11-19; the PHP itself is checked by v261107/nextcloud-php-patched.sh)
# Read-only.
source "$(dirname "$0")/../lib.sh"

# $1 container, $2 package, $3 minimum version (dpkg ordering)
pkg_floor() {
    docker ps --format '{{.Names}}' | grep -qx "$1" || { fail "$1 is not running"; return; }
    local got
    got="$(docker exec "$1" dpkg-query -W -f '${Version}' "$2" 2>/dev/null)"
    if [[ -z "$got" ]]; then
        fail "$1: package $2 not installed"
    elif docker exec "$1" dpkg --compare-versions "$got" ge "$3"; then
        pass "$1: $2 $got ($3 or newer)"
    else
        fail "$1: $2 $got, expected $3 or newer"
    fi
}

pkg_floor hermes_nginx      nginx                   1.24.0-2ubuntu7.21
pkg_floor hermes_commandbox openjdk-21-jre-headless 21.0.13.1
pkg_floor hermes_ciphermail openjdk-11-jre-headless 11.0.33.1

for f in .env.template .env; do
    nc="$(sed -n 's/^NCVERSION=//p' "$f" 2>/dev/null | tr -d '\r' | head -1)"
    if [[ -z "$nc" ]]; then
        fail "$f has no NCVERSION"
    elif [[ "${nc%%.*}" -gt 34 || "$(printf '%s\n%s\n' 34.0.6 "$nc" | sort -V | head -1)" == "34.0.6" ]]; then
        pass "$f: NCVERSION=$nc (34.0.6 or newer)"
    else
        fail "$f: NCVERSION=$nc, expected 34.0.6 or newer"
    fi
done
done_check
