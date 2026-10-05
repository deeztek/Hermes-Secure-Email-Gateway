#!/bin/bash
# Re-tag a release's images to a new version, in the GitLab registry.
#
# For a release that changed no image build context: the images are identical,
# so rebuilding produces the same layers more slowly. But the new tag still has
# to EXIST, because docker-compose pins every image with one
# HERMES_DOCKER_IMG_VERSION and system_update_docker.sh only pins a release tag
# if `docker manifest inspect` finds it. One missing image and the release
# cannot be pinned at all.
#
# An image ALREADY at the target tag is left alone. That is how a genuinely
# rebuilt image survives this: it is already there, so there is nothing to
# remember and no flag to get wrong. Re-running is therefore safe.
#
# Usage: ./retag-version.sh <from-version> <to-version> [--dry-run]
# Example: ./retag-version.sh v260815 v260912
set -uo pipefail

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-docker-gl"

IMAGES=(
    "hermes-ciphermail" "hermes-commandbox" "hermes-postfix-dkim"
    "hermes-mail-filter" "hermes-nginx" "hermes-openldap" "hermes-dmarc"
    "hermes-dovecot" "hermes-unbound" "hermes-body-milter" "hermes-openarc"
    "hermes-linkguard"
)

FROM_VER="${1:-}"; TO_VER="${2:-}"; DRY=0
[[ "${3:-}" == "--dry-run" ]] && DRY=1

if [[ -z "$FROM_VER" || -z "$TO_VER" ]]; then
    echo "Usage: $0 <from-version> <to-version> [--dry-run]" >&2
    echo "Example: $0 v260815 v260912" >&2
    exit 2
fi

echo "Re-tag ${FROM_VER} -> ${TO_VER} on ${REGISTRY}"
[[ $DRY -eq 1 ]] && echo "DRY RUN"
echo

FAILED=0

for img in "${IMAGES[@]}"; do
    src="${REGISTRY}/${img}:${FROM_VER}"
    dst="${REGISTRY}/${img}:${TO_VER}"

    if docker manifest inspect "$dst" >/dev/null 2>&1; then
        echo "${img}: already at ${TO_VER}, left alone"
        continue
    fi

    if ! docker image inspect "$src" >/dev/null 2>&1; then
        if ! docker pull "$src" >/dev/null 2>&1; then
            echo "${img}: FAILED, ${FROM_VER} not found"
            FAILED=$((FAILED + 1))
            continue
        fi
    fi

    if [[ $DRY -eq 1 ]]; then
        echo "${img}: would tag ${TO_VER}"
        continue
    fi

    if docker tag "$src" "$dst" && docker push "$dst" >/dev/null 2>&1; then
        echo "${img}: tagged ${TO_VER}"
    else
        echo "${img}: FAILED to tag or push"
        FAILED=$((FAILED + 1))
    fi
done

# The release needs EVERY image at the tag, so check rather than assume.
echo
MISSING=0
for img in "${IMAGES[@]}"; do
    docker manifest inspect "${REGISTRY}/${img}:${TO_VER}" >/dev/null 2>&1 \
        || { echo "MISSING ${img}"; MISSING=$((MISSING + 1)); }
done

if [[ $MISSING -eq 0 && $FAILED -eq 0 ]]; then
    echo "All ${#IMAGES[@]} images present at ${TO_VER}."
    exit 0
fi
echo "${MISSING} missing at ${TO_VER}. Release cannot be pinned."
exit 1
