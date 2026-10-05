#!/usr/bin/env bash
#
# check_release_readiness.sh - mechanical pre-flight for a release cut
#
# WHY THIS EXISTS
#
# docs/install/release-and-update-methodology.md has a 14-step release
# procedure. The steps that are easy to skip are the ones no human notices:
# the baseline build_no floor sat three releases stale (v260723 through
# v260918) even though step 3 explicitly says to bump it, because nothing
# reads it on a normal install.
#
# A checklist that gets skipped needs a machine, not louder wording. This
# checks only what can be checked mechanically. Testing, judgement and the
# release notes' content are still human work.
#
# Run it at step 1 and again before step 8.
#
#   ./scripts/check_release_readiness.sh
#
# Exit: 0 all checks pass, 1 at least one FAIL, 2 could not run.

set -uo pipefail

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'; BOLD=$'\033[1m'; NC=$'\033[0m'

FAILED=0
WARNED=0

pass() { echo "  ${GREEN}PASS${NC}  $*"; }
fail() { echo "  ${RED}FAIL${NC}  $*"; FAILED=$((FAILED+1)); }
warn() { echo "  ${YELLOW}WARN${NC}  $*"; WARNED=$((WARNED+1)); }

# Walk up to the repo root, per the self-locating convention in CLAUDE.md.
find_repo_root() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "$dir" != "/" ]]; do
        [[ -f "$dir/docker-compose.yml" ]] && { echo "$dir"; return 0; }
        dir="$(dirname "$dir")"
    done
    return 1
}
ROOT="$(find_repo_root)" || { echo "ERROR: could not locate repo root" >&2; exit 2; }
cd "$ROOT" || exit 2

BASELINE="config/database/hermes_install.sql"
ENV_TEMPLATE=".env.template"

# The release being cut is the newest updates/v<YYMMDD>/ directory. That is the
# same source install_hermes_docker.sh derive_install_version() uses, so this
# agrees with the installer by construction rather than by convention.
VERSION="$(ls -1 updates/ 2>/dev/null | grep -oE '^v[0-9]{6}$' | sort | tail -1)"
[[ -n "$VERSION" ]] || { echo "ERROR: no updates/v<YYMMDD>/ directory found" >&2; exit 2; }

echo ""
echo "${BOLD}Release readiness for ${VERSION}${NC}"
echo ""

# ---------------------------------------------------------------- 1. baseline floor
# Only a floor (the installer overwrites it), but a hand-run
# `mysql < hermes_install.sql` has nothing else to go on.
echo "${BOLD}1. Baseline build_no floor${NC}"
floor="$(grep -oE "'build_no', 'v[0-9]{6}'" "$BASELINE" 2>/dev/null | grep -oE 'v[0-9]{6}' | head -1)"
if [[ -z "$floor" ]]; then
    fail "no build_no literal found in $BASELINE"
elif [[ "$floor" == "$VERSION" ]]; then
    pass "baseline floor is $floor"
else
    fail "baseline floor is $floor, expected $VERSION  (step 3: bump it in $BASELINE)"
fi

# ---------------------------------------------------------------- 2. version stamp
# MUST be last, so a partially applied upgrade is not recorded as complete.
echo "${BOLD}2. schema_updates.sql version stamp${NC}"
SU="updates/${VERSION}/sql/schema_updates.sql"
if [[ ! -f "$SU" ]]; then
    warn "no $SU (fine only if this release has no schema change)"
else
    stamped="$(grep -oE "value = '${VERSION}' WHERE parameter = 'build_no'" "$SU" | head -1)"
    if [[ -z "$stamped" ]]; then
        fail "$SU does not stamp build_no to $VERSION"
    else
        pass "stamps build_no to $VERSION"
    fi
    # Last non-comment, non-blank line must be that UPDATE.
    last="$(grep -vE '^\s*(--|$)' "$SU" | tail -1)"
    if [[ "$last" == *"build_no"* ]]; then
        pass "the stamp is the last statement"
    else
        fail "the last statement is not the build_no stamp, it is: ${last:0:60}"
    fi
fi

# ---------------------------------------------------------------- 3. release notes
# This file IS the GitHub Release body (git_release.sh --notes-file).
echo "${BOLD}3. Release notes${NC}"
RN="updates/${VERSION}/README.md"
if [[ ! -f "$RN" ]]; then
    fail "$RN missing. It is the GitHub Release body"
else
    lines="$(wc -l < "$RN")"
    if (( lines < 20 )); then
        warn "$RN is only ${lines} lines. It is published verbatim as the Release body"
    else
        pass "$RN present (${lines} lines)"
    fi
    grep -q "$VERSION" "$RN" || warn "$RN never mentions $VERSION"
fi

# ---------------------------------------------------------------- 4. env template
# A fresh install copies this. Pinning it would freeze every future install on
# this release.
echo "${BOLD}4. .env.template image version${NC}"
imgver="$(grep -E '^HERMES_DOCKER_IMG_VERSION=' "$ENV_TEMPLATE" 2>/dev/null | cut -d= -f2- | tr -d '"'"'"' \r')"
if [[ "$imgver" == "latest" ]]; then
    pass "HERMES_DOCKER_IMG_VERSION=latest"
else
    fail "HERMES_DOCKER_IMG_VERSION=$imgver, expected 'latest' (step 5: pin per host with --image-version instead)"
fi

# ---------------------------------------------------------------- 5. Nextcloud
# A bumped NCVERSION means step 6's integration check is mandatory, and #338
# means the gap to the previous release matters.
echo "${BOLD}5. Nextcloud version${NC}"
nc_now="$(grep -E '^NCVERSION=' "$ENV_TEMPLATE" 2>/dev/null | cut -d= -f2- | tr -d '"'"'"' \r')"
prev_tag="$(git tag --list 'v[0-9][0-9][0-9][0-9][0-9][0-9]' --sort=-creatordate 2>/dev/null | head -1)"
if [[ -z "$prev_tag" ]]; then
    warn "no previous release tag found, cannot compare NCVERSION"
else
    nc_prev="$(git show "${prev_tag}:${ENV_TEMPLATE}" 2>/dev/null | grep -E '^NCVERSION=' | cut -d= -f2- | tr -d '"'"'"' \r')"
    if [[ "$nc_now" == "$nc_prev" ]]; then
        pass "NCVERSION unchanged at $nc_now since $prev_tag (step 6 not required)"
    else
        warn "NCVERSION moved ${nc_prev} -> ${nc_now} since ${prev_tag}"
        echo "        Step 6 is MANDATORY: run scripts/test_nc_integration.sh on Test."
        if [[ "${nc_now%%.*}" != "${nc_prev%%.*}" ]]; then
            echo "        This is a MAJOR bump. Per #338 an install that skipped a release"
            echo "        can be two majors behind and the updater will refuse. Confirm the"
            echo "        refusal is what you want for this release."
        fi
    fi
fi

# ---------------------------------------------------------------- 6. seed drift
echo "${BOLD}6. Generated artifacts match their seed${NC}"
if [[ -x scripts/check_ofelia_seed_drift.sh ]]; then
    if out="$(bash scripts/check_ofelia_seed_drift.sh 2>&1)"; then
        pass "$(echo "$out" | tail -1)"
    else
        fail "ofelia seed drift. Run scripts/check_ofelia_seed_drift.sh"
    fi
else
    warn "scripts/check_ofelia_seed_drift.sh not executable, skipped"
fi

# ---------------------------------------------------------------- 7. tree state
echo "${BOLD}7. Working tree${NC}"
if [[ -n "$(git status --porcelain 2>/dev/null | grep -vE '^\?\?')" ]]; then
    fail "uncommitted tracked changes. git_release.sh refuses an unclean tree"
else
    pass "no uncommitted tracked changes"
fi
untracked="$(git status --porcelain 2>/dev/null | grep -cE '^\?\?' || true)"
(( untracked > 0 )) && warn "${untracked} untracked file(s). Confirm none belong in the release"

# ---------------------------------------------------------------- 8. tag
echo "${BOLD}8. Tag${NC}"
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    warn "$VERSION already exists locally. Fine at step 9+, wrong at step 1"
else
    pass "$VERSION not yet tagged"
fi

echo ""
if (( FAILED > 0 )); then
    echo "${RED}${BOLD}${FAILED} check(s) FAILED${NC}${WARNED:+, ${WARNED} warning(s)}"
    echo "Fix these before step 8. See docs/install/release-and-update-methodology.md"
    echo ""
    exit 1
fi
echo "${GREEN}${BOLD}All mechanical checks passed${NC}${WARNED:+ (${WARNED} warning(s) to read)}"
echo ""
echo "${BOLD}Still human work:${NC}"
echo "  - Build to the STAGING registry (build-all.sh), NOT ghcr (step 8)"
echo "  - Fresh install AND upgrade on Test, plus the real mail path (step 10)"
echo "  - Nothing reaches ghcr.io until step 11, after testing"
echo ""
exit 0
