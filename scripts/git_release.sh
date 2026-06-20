#!/bin/bash
# Hermes SEG release-cut helper.
#
# Codifies the two-remote workflow:
#   - GitLab (`gitlab` remote) is the dev source-of-truth (where this script ran)
#   - GitHub (`github` remote) is the distribution target
#
# Usage:
#     ./scripts/git_release.sh                       # default: dev push to gitlab only
#     ./scripts/git_release.sh --branch main         # explicit branch (default: current branch)
#     ./scripts/git_release.sh --release v260120     # release cut: push branch + tag to BOTH
#                                                    # remotes, then create the GitHub Release
#                                                    # from updates/v260120/README.md
#     ./scripts/git_release.sh --release v260120 --prerelease   # mark the Release as a pre-release
#
# Release pre-flight checks (--release mode):
#     1. Both remotes configured (gitlab + github)?
#     2. Tag matches v\d{6}?
#     3. Working tree clean?
#     4. Tag exists locally?
#
# The GitHub Release body is the per-release README at updates/<tag>/README.md.
# (There is no GitHub Actions release workflow; this script creates the Release via `gh`.)
#
# Exit codes:
#     0 = success
#     1 = pre-flight failure
#     2 = push failure
#     3 = bad usage

set -euo pipefail

# ---- Locate repo root (walk-up self-locator, same pattern as install_hermes_docker.sh) ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]] && [[ ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "ERROR: Could not locate docker-compose.yml in any parent of $SCRIPT_DIR" >&2
        echo "Run this script from inside a Hermes SEG repo clone." >&2
        exit 3
    fi
fi

cd "$HERMES_ROOT"

# ---- Output styling ----
if [[ -t 1 ]]; then
    RED=$'\e[31m'
    YELLOW=$'\e[33m'
    GREEN=$'\e[32m'
    BOLD=$'\e[1m'
    RESET=$'\e[0m'
else
    RED=""; YELLOW=""; GREEN=""; BOLD=""; RESET=""
fi

info()    { echo "${GREEN}[OK]${RESET} $*"; }
warn()    { echo "${YELLOW}[WARN]${RESET} $*"; }
fail()    { echo "${RED}[FAIL]${RESET} $*" >&2; }
header()  { echo ""; echo "${BOLD}=== $* ===${RESET}"; }

# ---- Arg parsing ----
MODE="dev"
RELEASE_TAG=""
BRANCH=""
PRERELEASE=0

usage() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --release)
            MODE="release"
            RELEASE_TAG="${2:-}"
            if [[ -z "$RELEASE_TAG" ]]; then
                fail "--release requires a tag argument (e.g., --release v260120)"
                exit 3
            fi
            shift 2
            ;;
        --branch)
            BRANCH="${2:-}"
            if [[ -z "$BRANCH" ]]; then
                fail "--branch requires a branch name"
                exit 3
            fi
            shift 2
            ;;
        --prerelease)
            PRERELEASE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            fail "Unknown argument: $1"
            usage
            exit 3
            ;;
    esac
done

# Default branch = current branch
if [[ -z "$BRANCH" ]]; then
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

# ---- Pre-flight checks ----
header "Pre-flight"

# Verify gitlab remote exists (always required)
if ! git remote get-url gitlab >/dev/null 2>&1; then
    fail "Remote 'gitlab' not configured."
    echo "       Add it with: git remote add gitlab git@gitlab.deeztek.com:dedwards/hermes-seg-docker-gl.git" >&2
    exit 1
fi
info "gitlab remote: $(git remote get-url gitlab)"

# Verify github remote exists (only required for release mode)
if [[ "$MODE" == "release" ]]; then
    if ! git remote get-url github >/dev/null 2>&1; then
        fail "Remote 'github' not configured (required for --release mode)."
        echo "       Add it with: git remote add github git@github.com:deeztek/Hermes-Secure-Email-Gateway.git" >&2
        exit 1
    fi
    info "github remote: $(git remote get-url github)"
fi

# Working tree must be clean
if ! git diff --quiet HEAD 2>/dev/null || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    fail "Working tree is not clean. Commit or stash changes before pushing."
    git status --short >&2
    exit 1
fi
info "Working tree clean"

# Branch sanity check (do we know the local branch?)
if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
    fail "Branch '$BRANCH' does not exist locally."
    exit 1
fi
info "Branch: $BRANCH"

if [[ "$MODE" == "release" ]]; then
    # Validate tag format
    if ! [[ "$RELEASE_TAG" =~ ^v[0-9]{6}$ ]]; then
        fail "Tag '$RELEASE_TAG' does not match expected format vYYMMDD (e.g., v260120)."
        echo "       Hermes uses calendar versioning. Reject malformed tags before they hit the registry." >&2
        exit 1
    fi
    info "Tag format OK: $RELEASE_TAG"

    # Verify tag exists locally
    if ! git rev-parse --verify "refs/tags/$RELEASE_TAG" >/dev/null 2>&1; then
        fail "Tag '$RELEASE_TAG' does not exist locally."
        echo "       Create it first:  git tag -a $RELEASE_TAG -m 'Hermes SEG $RELEASE_TAG'" >&2
        exit 1
    fi
    info "Tag exists locally: $RELEASE_TAG -> $(git rev-parse --short "$RELEASE_TAG")"
fi

# ---- Push ----
push_to() {
    local remote="$1"
    local ref="$2"
    echo ""
    echo "git push $remote $ref"
    if git push "$remote" "$ref"; then
        info "$remote: $ref pushed"
    else
        fail "$remote: $ref push failed"
        return 2
    fi
}

case "$MODE" in
    dev)
        header "Dev push -> gitlab"
        push_to gitlab "$BRANCH" || exit 2
        echo ""
        info "Done. This push did NOT reach GitHub (use --release <tag> to cut a release)."
        ;;
    release)
        header "Release push -> gitlab + github"
        echo "Branch: $BRANCH"
        echo "Tag:    $RELEASE_TAG"
        echo ""
        read -p "Confirm release push to BOTH gitlab and github? [y/N]: " CONFIRM
        if [[ "$CONFIRM" != "y" ]] && [[ "$CONFIRM" != "Y" ]]; then
            echo "Aborted."
            exit 0
        fi

        push_to gitlab "$BRANCH"   || exit 2
        push_to gitlab "$RELEASE_TAG" || exit 2
        push_to github "$BRANCH"   || exit 2
        push_to github "$RELEASE_TAG" || exit 2

        # ---- Create (or refresh) the GitHub Release from the per-release README ----
        # The per-release README (updates/<tag>/README.md) is the canonical Release body.
        header "GitHub Release"
        GH_REPO="deeztek/Hermes-Secure-Email-Gateway"
        RELEASE_NOTES="updates/${RELEASE_TAG}/README.md"
        PRE_FLAG=""
        [[ "$PRERELEASE" == "1" ]] && PRE_FLAG="--prerelease"

        if ! command -v gh >/dev/null 2>&1; then
            warn "gh CLI not found; GitHub Release NOT created."
            warn "Create it manually once gh is available:"
            echo "    gh release create $RELEASE_TAG --repo $GH_REPO --title $RELEASE_TAG --notes-file $RELEASE_NOTES $PRE_FLAG"
        elif [[ ! -f "$RELEASE_NOTES" ]]; then
            warn "Per-release notes '$RELEASE_NOTES' not found; GitHub Release NOT created."
            warn "Every release must ship updates/<tag>/README.md as its Release body. Add it, then:"
            echo "    gh release create $RELEASE_TAG --repo $GH_REPO --title $RELEASE_TAG --notes-file $RELEASE_NOTES $PRE_FLAG"
        elif gh release view "$RELEASE_TAG" --repo "$GH_REPO" >/dev/null 2>&1; then
            info "Release $RELEASE_TAG already exists; refreshing notes from $RELEASE_NOTES..."
            if gh release edit "$RELEASE_TAG" --repo "$GH_REPO" --notes-file "$RELEASE_NOTES" $PRE_FLAG; then
                info "Release notes updated."
            else
                warn "gh release edit failed."
            fi
        else
            info "Creating GitHub Release $RELEASE_TAG from $RELEASE_NOTES..."
            if gh release create "$RELEASE_TAG" --repo "$GH_REPO" --title "$RELEASE_TAG" --notes-file "$RELEASE_NOTES" $PRE_FLAG; then
                info "Release $RELEASE_TAG created."
            else
                warn "gh release create failed; create it manually:"
                echo "    gh release create $RELEASE_TAG --repo $GH_REPO --title $RELEASE_TAG --notes-file $RELEASE_NOTES $PRE_FLAG"
            fi
        fi

        echo ""
        info "Release $RELEASE_TAG pushed to both remotes; GitHub Release handled."
        info "If image-build Actions are configured, watch:"
        echo "    https://github.com/deeztek/Hermes-Secure-Email-Gateway/actions"
        ;;
esac
