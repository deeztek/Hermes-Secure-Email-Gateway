#!/bin/bash
# Re-tag an existing release's images to a new version, in the GitLab registry.
#
# Use this when a release ships without any change to the image build context:
# `git diff --name-only <oldtag>..HEAD -- Docker/` is empty, so the images are
# byte-identical and rebuilding them produces the same layers more slowly.
#
# The new tag still has to EXIST, because docker-compose pins every image with
# one HERMES_DOCKER_IMG_VERSION, and system_update_docker.sh only pins a release
# tag if `docker manifest inspect` finds it. One missing image means the whole
# release cannot be pinned.
#
# Images changed for this release are skipped with --skip, so a rebuilt image
# is not overwritten by an older one carrying the same new tag.
#
# Usage: ./retag-version.sh <from-version> <to-version> [--skip img,img] [--dry-run]
#
# Example, where only Link Guard was rebuilt:
#     ./retag-version.sh v260815 v260912 --skip hermes-linkguard
#
# Pulls from the registry if an image is not already local, so it works on a
# clean machine. Afterwards, promote-gl-to-ghcr.sh moves the set to ghcr.
set -uo pipefail

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-docker-gl"

IMAGES=(
    "hermes-ciphermail" "hermes-commandbox" "hermes-postfix-dkim"
    "hermes-mail-filter" "hermes-nginx" "hermes-openldap" "hermes-dmarc"
    "hermes-dovecot" "hermes-unbound" "hermes-body-milter" "hermes-openarc"
    "hermes-linkguard"
)

FROM_VER=""; TO_VER=""; SKIP=""; DRY=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip)     SKIP="$2"; shift 2 ;;
        --skip=*)   SKIP="${1#*=}"; shift ;;
        --dry-run)  DRY=1; shift ;;
        -h|--help)  sed -n '2,25p' "$0"; exit 0 ;;
        *) if   [[ -z "$FROM_VER" ]]; then FROM_VER="$1"
           elif [[ -z "$TO_VER"   ]]; then TO_VER="$1"
           else echo "Unexpected argument: $1" >&2; exit 2; fi; shift ;;
    esac
done

if [[ -z "$FROM_VER" || -z "$TO_VER" ]]; then
    echo "Usage: $0 <from-version> <to-version> [--skip img,img] [--dry-run]" >&2
    echo "Example: $0 v260815 v260912 --skip hermes-linkguard" >&2
    exit 2
fi

echo "Re-tag ${FROM_VER} -> ${TO_VER}"
echo "  registry: ${REGISTRY}"
[[ -n "$SKIP" ]] && echo "  skipping: ${SKIP}"
[[ $DRY -eq 1 ]] && echo "  DRY RUN, nothing will be pushed"
echo

OK=(); FAILED=(); SKIPPED=()

for img in "${IMAGES[@]}"; do
    if [[ ",${SKIP}," == *",${img},"* ]]; then
        echo "[skip] ${img}"
        SKIPPED+=("$img")
        continue
    fi

    src="${REGISTRY}/${img}:${FROM_VER}"
    dst="${REGISTRY}/${img}:${TO_VER}"
    echo "[${img}]"

    # Pull only when it is not already local, so a rerun is fast.
    if ! docker image inspect "$src" >/dev/null 2>&1; then
        echo "  pulling ${FROM_VER}"
        if ! docker pull "$src" >/dev/null 2>&1; then
            echo "  FAILED: ${FROM_VER} not found locally or in the registry"
            FAILED+=("$img")
            continue
        fi
    fi

    if [[ $DRY -eq 1 ]]; then
        echo "  would tag and push ${TO_VER}"
        OK+=("$img")
        continue
    fi

    docker tag "$src" "$dst" || { echo "  FAILED: tag"; FAILED+=("$img"); continue; }
    if docker push "$dst" >/dev/null 2>&1; then
        echo "  pushed ${TO_VER}"
        OK+=("$img")
    else
        echo "  FAILED: push (is docker logged in to ${REGISTRY%%/*}?)"
        FAILED+=("$img")
    fi
done

echo
echo "========================================"
echo "Summary: ${#OK[@]} ok, ${#SKIPPED[@]} skipped, ${#FAILED[@]} failed"
echo "========================================"
[[ ${#SKIPPED[@]} -gt 0 ]] && printf '  skipped: %s\n' "${SKIPPED[*]}"
[[ ${#FAILED[@]}  -gt 0 ]] && printf '  FAILED:  %s\n' "${FAILED[*]}"

# Verify the full set, including anything skipped, since a release needs every
# image at the tag or the version cannot be pinned.
echo
echo "Checking all ${#IMAGES[@]} images at ${TO_VER}:"
MISSING=0
for img in "${IMAGES[@]}"; do
    if docker manifest inspect "${REGISTRY}/${img}:${TO_VER}" >/dev/null 2>&1; then
        echo "  ok      ${img}"
    else
        echo "  MISSING ${img}"
        MISSING=$((MISSING + 1))
    fi
done

echo
if [[ $MISSING -eq 0 ]]; then
    echo "All ${#IMAGES[@]} images present at ${TO_VER}. Ready for promote-gl-to-ghcr.sh."
    exit 0
fi
echo "${MISSING} image(s) missing at ${TO_VER}. The release cannot be pinned until they exist."
exit 1
