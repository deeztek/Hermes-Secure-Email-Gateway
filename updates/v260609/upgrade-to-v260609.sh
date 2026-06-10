#!/bin/bash
# ============================================================================
# upgrade-to-v260609.sh — one-time upgrade bridge:  v260119 -> v260609
# ============================================================================
# WHY THIS EXISTS
#   v260609 introduces the update orchestrator's pre-scripts/ hook and
#   self-re-exec. The v260119 orchestrator predates BOTH, so when it drives the
#   upgrade it never runs v260609's pre-container credential migration
#   (updates/v260609/pre-scripts/01-migrate-authelia-creds.sh), which must move
#   the Authelia DB credentials keys/ -> creds/ BEFORE `docker compose up`.
#   Run the normal `system_update_docker.sh v260609` from v260119 and compose up
#   fails on the new AUTHELIA_STORAGE_USERNAME/PASSWORD secrets:
#       "bind source path does not exist".
#
#   The fix ships INSIDE v260609, so it cannot bootstrap itself onto a v260119
#   box. This bridge checks out v260609 FIRST, then runs v260609's OWN
#   orchestrator with --skip-git, so the pre-scripts hook fires before compose.
#
#   ONLY needed for the v260119 -> v260609 hop. Every later upgrade is normal
#   (`system_update_docker.sh <tag>`) because v260609+ self-re-execs.
#
# USAGE (recommended — one command, from your install directory)
#   cd /opt/hermes-seg
#   git fetch --tags origin
#   sudo bash <(git show v260609:updates/v260609/upgrade-to-v260609.sh)
#
# USAGE (if you already have v260609 checked out)
#   sudo ./updates/v260609/upgrade-to-v260609.sh
# ============================================================================

set -euo pipefail

TARGET_TAG="v260609"

# --- must be root (the orchestrator restarts containers) --------------------
if [[ "$(id -u)" -ne 0 ]]; then
    echo "ERROR: run as root, e.g.:" >&2
    echo "  sudo bash <(git show ${TARGET_TAG}:updates/${TARGET_TAG}/upgrade-to-v260609.sh)" >&2
    exit 1
fi

# --- locate the install root by walking up from the current directory -------
#   PWD-based (not BASH_SOURCE-based) so it still works when this script is fed
#   via process substitution, where BASH_SOURCE is /dev/fd/* and not in the tree.
HERMES_ROOT="$PWD"
while [[ "$HERMES_ROOT" != "/" ]]; do
    [[ -f "$HERMES_ROOT/docker-compose.yml" ]] && break
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
if [[ "$HERMES_ROOT" == "/" ]]; then
    echo "ERROR: not inside a Hermes install (no docker-compose.yml at or above $PWD)." >&2
    echo "       cd into your install directory (e.g. /opt/hermes-seg) and re-run." >&2
    exit 1
fi
cd "$HERMES_ROOT"

echo "============================================================"
echo " Hermes SEG one-time upgrade bridge:  v260119 -> ${TARGET_TAG}"
echo " Install root: ${HERMES_ROOT}"
echo "============================================================"

# --- 1. set aside install-time config drift (#256) so preflight passes ------
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "==> Stashing install-time config drift so the updater preflight passes..."
    git stash push -m "pre-${TARGET_TAG}-upgrade" >/dev/null
    echo "    (saved to the git stash; recover with 'git stash list' if ever needed)"
else
    echo "==> Working tree clean; nothing to stash."
fi

# --- 2. make the ${TARGET_TAG} orchestrator the one on disk -----------------
echo "==> Fetching tags from origin..."
git fetch --tags --quiet origin
if ! git rev-parse --verify --quiet "refs/tags/${TARGET_TAG}" >/dev/null; then
    echo "ERROR: tag ${TARGET_TAG} not found after fetch. Is it published on origin?" >&2
    exit 1
fi
echo "==> Checking out ${TARGET_TAG}..."
git checkout --quiet "${TARGET_TAG}"

# --- 3. run v260609's orchestrator with --skip-git --------------------------
#   --skip-git: we already checked out the tag above. This also skips the
#   self-re-exec (a no-op here, since the tag is already checked out).
echo "==> Launching the ${TARGET_TAG} update orchestrator."
echo "    (the Authelia credential pre-script runs in Phase 2, before compose up)"
echo
exec ./scripts/system_update_docker.sh --skip-git "${TARGET_TAG}"
