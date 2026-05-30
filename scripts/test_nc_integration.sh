#!/bin/bash
# ============================================================================
# Hermes SEG Nextcloud integration check (#261)
# ============================================================================
# Pre-release sanity test for a Nextcloud version bump. Run this AFTER you
# have manually updated NCVERSION in .env.template AND restarted the
# hermes_nextcloud container (`docker compose pull hermes_nextcloud &&
# docker compose up -d hermes_nextcloud`). The script does NOT mutate state
# -- read-only occ queries + log scan only -- so it is safe to re-run.
#
# Workflow:
#   1. Bump NCVERSION in .env.template
#   2. docker compose pull hermes_nextcloud
#   3. docker compose up -d hermes_nextcloud
#   4. Wait ~30s for NC to finish initialization on first start
#   5. ./scripts/test_nc_integration.sh
#   6. All PASS -> safe to cut a release that ships this NC bump.
#      Any FAIL -> investigate, fix the integration, re-run.
#
# Exit code: 0 if no FAIL, 1 if any FAIL. WARNs do not flip the exit code.
#
# Modeled on hermes_smoke_test.sh. Self-locates HERMES_ROOT by walking up
# from BASH_SOURCE[0] looking for docker-compose.yml.

set -uo pipefail

# ---- Self-locate HERMES_ROOT ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]] && [[ ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml in any parent of $SCRIPT_DIR" >&2
        echo "Set HERMES_ROOT environment variable and retry." >&2
        exit 1
    fi
fi

# ---- Colors ----
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() { printf "  [${GREEN}PASS${NC}] %s\n" "$1"; PASS_COUNT=$((PASS_COUNT+1)); }
warn() { printf "  [${YELLOW}WARN${NC}] %s\n" "$1"; WARN_COUNT=$((WARN_COUNT+1)); }
fail() { printf "  [${RED}FAIL${NC}] %s\n" "$1"; FAIL_COUNT=$((FAIL_COUNT+1)); }
section() { printf "\n${BOLD}== %s ==${NC}\n" "$1"; }

# ---- Helpers ----
occ() { docker exec hermes_nextcloud php occ "$@" 2>&1; }

# ---- Read expected version from .env.template ----
EXPECTED_VERSION=$(grep -E '^NCVERSION=' "$HERMES_ROOT/.env.template" 2>/dev/null \
    | cut -d= -f2 | tr -d '"' | tr -d "'" | tr -d '[:space:]')
if [[ -z "$EXPECTED_VERSION" ]]; then
    echo "ERROR: NCVERSION not found in $HERMES_ROOT/.env.template" >&2
    exit 1
fi

printf "${BOLD}Hermes SEG Nextcloud integration check (#261)${NC}\n"
printf "  Expected NCVERSION (from .env.template):  ${BOLD}%s${NC}\n" "$EXPECTED_VERSION"
printf "  Reading live state from hermes_nextcloud container...\n"

# ============================================================================
section "Container + version"
# ============================================================================

if ! docker exec hermes_nextcloud true 2>/dev/null; then
    fail "hermes_nextcloud container not running or not responsive"
    echo ""
    printf "${RED}Cannot proceed -- the NC container must be running.${NC}\n"
    exit 1
else
    pass "hermes_nextcloud container is up and responsive"
fi

STATUS_JSON=$(occ status --output=json 2>/dev/null)
if [[ -z "$STATUS_JSON" ]]; then
    fail "occ status returned no output (NC may still be installing on first start -- wait 30s and re-run)"
else
    INSTALLED=$(echo "$STATUS_JSON" | jq -r '.installed' 2>/dev/null)
    MAINTENANCE=$(echo "$STATUS_JSON" | jq -r '.maintenance' 2>/dev/null)
    NEEDS_DB_UPGRADE=$(echo "$STATUS_JSON" | jq -r '.needsDbUpgrade' 2>/dev/null)
    LIVE_VERSION=$(echo "$STATUS_JSON" | jq -r '.versionstring' 2>/dev/null)

    [[ "$INSTALLED" == "true" ]] && pass "NC reports installed=true" || fail "NC reports installed=$INSTALLED"
    [[ "$MAINTENANCE" == "false" ]] && pass "NC is NOT in maintenance mode" || fail "NC is in maintenance mode (maintenance=$MAINTENANCE)"
    [[ "$NEEDS_DB_UPGRADE" == "false" ]] && pass "NC does not need a DB upgrade" || fail "NC reports needsDbUpgrade=$NEEDS_DB_UPGRADE -- run occ upgrade first"

    # Live version should start with the .env.template pin (NC reports
    # "30.0.15.1" sometimes -- the .4th component is internal).
    if [[ "$LIVE_VERSION" == "$EXPECTED_VERSION"* ]]; then
        pass "Live versionstring '$LIVE_VERSION' matches expected pin '$EXPECTED_VERSION'"
    else
        fail "Live versionstring '$LIVE_VERSION' does NOT match expected pin '$EXPECTED_VERSION'"
    fi
fi

# ============================================================================
section "Integration apps enabled + compatible"
# ============================================================================

# Apps Hermes integration depends on. If any of these are missing,
# disabled, or marked incompatible, the upgrade is not safe to release.
REQUIRED_APPS=(user_oidc user_ldap mail twofactor_totp external)
APPS_JSON=$(occ app:list --output=json 2>/dev/null)

if [[ -z "$APPS_JSON" ]]; then
    fail "occ app:list returned no output"
else
    for app in "${REQUIRED_APPS[@]}"; do
        IS_ENABLED=$(echo "$APPS_JSON" | jq -r --arg a "$app" '.enabled[$a] // empty' 2>/dev/null)
        IS_DISABLED=$(echo "$APPS_JSON" | jq -r --arg a "$app" '.disabled[$a] // empty' 2>/dev/null)
        if [[ -n "$IS_ENABLED" ]]; then
            pass "App '$app' enabled (version $IS_ENABLED)"
        elif [[ -n "$IS_DISABLED" ]]; then
            fail "App '$app' is DISABLED (should be enabled for this NC version)"
        else
            fail "App '$app' is NOT INSTALLED"
        fi
    done

    # Look for any app marked incompatible with this NC version. Reported
    # by NC under the "disabled" section with a marker like "(incompatible)".
    INCOMPATIBLE_LIST=$(occ app:list 2>/dev/null | grep -i 'incompat' || true)
    if [[ -n "$INCOMPATIBLE_LIST" ]]; then
        fail "One or more apps marked incompatible:"
        echo "$INCOMPATIBLE_LIST" | sed 's/^/         /'
    else
        pass "No apps marked incompatible with this NC version"
    fi
fi

# ============================================================================
section "Theming + console-host integration"
# ============================================================================

# trusted_domains must include at least one entry. install_hermes_docker.sh
# and edit_console_settings.cfm both populate this.
TRUSTED_RAW=$(occ config:system:get trusted_domains 2>/dev/null)
if [[ -n "$TRUSTED_RAW" ]] && echo "$TRUSTED_RAW" | grep -qE '[a-zA-Z0-9]'; then
    pass "trusted_domains is populated:"
    echo "$TRUSTED_RAW" | sed 's/^/         /'
else
    fail "trusted_domains is empty -- mailbox-user logins will be rejected"
fi

# theming:config url should match the current console host (Hermes UI sets
# this via edit_console_settings.cfm).
THEMING_URL=$(occ theming:config url 2>/dev/null | tr -d '[:space:]')
if [[ -n "$THEMING_URL" ]]; then
    pass "Theming URL set: $THEMING_URL"
else
    warn "Theming URL is empty -- not blocking, but operators see a default branding URL in NC's settings"
fi

# ============================================================================
section "OIDC + LDAP wiring (mailbox-user SSO path)"
# ============================================================================

# Authelia is the OIDC provider, registered as "Hermes_SEG" by the install
# script. If user_oidc lost the provider config on upgrade, SSO is broken.
PROVIDER_LIST=$(occ user_oidc:provider 2>/dev/null || true)
if echo "$PROVIDER_LIST" | grep -qE 'Hermes_SEG|hermes_seg'; then
    pass "user_oidc provider 'Hermes_SEG' is registered"
else
    fail "user_oidc provider 'Hermes_SEG' is MISSING -- mailbox-user SSO will fail"
fi

# LDAP backend config (from install + nextcloud_provision_user.cfm).
# `occ ldap:show-config` returns one or more configIDs; we just verify
# at least one config exists.
LDAP_CONFIG=$(occ ldap:show-config 2>/dev/null || true)
if echo "$LDAP_CONFIG" | grep -qE 'Configuration|ldapHost'; then
    pass "user_ldap backend has at least one configuration"
else
    fail "user_ldap has NO configurations -- mailbox-user provisioning is broken"
fi

# ============================================================================
section "Recent error log (last 200 lines)"
# ============================================================================

# Critical errors (level >= 3 = error) in the last 200 lines of
# nextcloud.log. A few WARN-level entries are normal; sustained errors
# are not.
LOG_PATH=/var/www/html/data/nextcloud.log
ERROR_COUNT=$(docker exec hermes_nextcloud sh -c \
    "tail -200 $LOG_PATH 2>/dev/null | grep -c '\"level\":3'" 2>/dev/null || echo 0)
FATAL_COUNT=$(docker exec hermes_nextcloud sh -c \
    "tail -200 $LOG_PATH 2>/dev/null | grep -c '\"level\":4'" 2>/dev/null || echo 0)

if [[ "$ERROR_COUNT" -eq 0 && "$FATAL_COUNT" -eq 0 ]]; then
    pass "No ERROR or FATAL entries in last 200 log lines"
elif [[ "$FATAL_COUNT" -gt 0 ]]; then
    fail "$FATAL_COUNT FATAL-level entries in last 200 log lines -- investigate"
    docker exec hermes_nextcloud sh -c "tail -200 $LOG_PATH | grep '\"level\":4' | head -3" 2>/dev/null | sed 's/^/         /'
else
    warn "$ERROR_COUNT ERROR-level entries in last 200 log lines (not blocking, but review)"
    docker exec hermes_nextcloud sh -c "tail -200 $LOG_PATH | grep '\"level\":3' | head -3" 2>/dev/null | sed 's/^/         /'
fi

# ============================================================================
# Final report
# ============================================================================

echo ""
printf "${BOLD}== Summary ==${NC}\n"
printf "  Passed: ${GREEN}%d${NC}\n" "$PASS_COUNT"
printf "  Warned: ${YELLOW}%d${NC}\n" "$WARN_COUNT"
printf "  Failed: ${RED}%d${NC}\n" "$FAIL_COUNT"
echo ""

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    printf "${RED}NOT SAFE${NC} to release this NC bump. Investigate and re-test.\n"
    exit 1
else
    printf "${GREEN}SAFE${NC} to cut a release with NCVERSION=$EXPECTED_VERSION.\n"
    [[ "$WARN_COUNT" -gt 0 ]] && printf "(Warnings above are advisory -- review before publishing if you care.)\n"
    exit 0
fi
