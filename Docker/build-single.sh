#!/bin/bash
# Build a single Hermes SEG Docker image
# Usage: ./build-single.sh [image-name] [version]
# Example: ./build-single.sh hermes-dovecot v260119
#
# Available images:
#   hermes-ciphermail, hermes-commandbox, hermes-postfix-dkim,
#   hermes-mail-filter, hermes-nginx, hermes-openldap, hermes-dmarc, hermes-dovecot,
#   hermes-unbound

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-docker-gl"
DEFAULT_VERSION="v260119"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Available images mapped to their directory names (image-name → subdir)
declare -A IMAGES=(
    ["hermes-ciphermail"]="ciphermail"
    ["hermes-commandbox"]="commandbox"
    ["hermes-postfix-dkim"]="postfix_dkim"
    ["hermes-mail-filter"]="mail_filter"
    ["hermes-nginx"]="nginx"
    ["hermes-openldap"]="openldap"
    ["hermes-dmarc"]="opendmarc"
    ["hermes-dovecot"]="dovecot"
    ["hermes-unbound"]="unbound"
)

# Check Docker is available
if ! command -v docker &>/dev/null; then
    echo "[ERROR] Docker not found in PATH."
    echo "        Run this script from Git Bash terminal."
    exit 1
fi

# Prompt for image name if not provided
if [ -n "$1" ]; then
    IMAGE_NAME="$1"
else
    echo "Available images:"
    for img in "${!IMAGES[@]}"; do
        echo "  - $img"
    done
    echo ""
    read -p "Enter image name to build: " IMAGE_NAME
fi

# Validate image name
if [ -z "${IMAGES[$IMAGE_NAME]}" ]; then
    echo "[ERROR] Unknown image: '$IMAGE_NAME'"
    echo "        Valid options: ${!IMAGES[@]}"
    exit 1
fi

SUBDIR="${IMAGES[$IMAGE_NAME]}"

# Prompt for version if not provided
if [ -n "$2" ]; then
    VERSION="$2"
else
    read -p "Enter version tag [$DEFAULT_VERSION]: " VERSION
    VERSION="${VERSION:-$DEFAULT_VERSION}"
fi

# Validate version format (vYYMMDD)
if ! echo "$VERSION" | grep -qE '^v[0-9]{6}$'; then
    echo "[WARN] Version '$VERSION' does not match expected format (vYYMMDD, e.g., v260119)"
    read -p "Continue anyway? [y/N]: " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo "Aborted."
        exit 1
    fi
fi

# Special handling: ciphermail requires repack-debs-nosystemd.sh to have been run
if [ "$IMAGE_NAME" = "hermes-ciphermail" ]; then
    if ! ls "$SCRIPT_DIR/$SUBDIR/build/djigzo_"*-nosystemd.deb 1>/dev/null 2>&1; then
        echo "[ERROR] No -nosystemd.deb files found."
        echo "        Run Docker/ciphermail/build/repack-debs-nosystemd.sh first."
        exit 1
    fi
fi

# Determine dockerfile path (some images use the image name, some use different subdir names)
DOCKERFILE_SUBDIR="$SUBDIR"
case "$IMAGE_NAME" in
    "hermes-postfix-dkim") DOCKERFILE_SUBDIR="postfix_dkim" ;;
    "hermes-mail-filter") DOCKERFILE_SUBDIR="mail_filter" ;;
    "hermes-dmarc") DOCKERFILE_SUBDIR="opendmarc" ;;
esac

DOCKERFILE="$SCRIPT_DIR/$SUBDIR/dockerfiles/$DOCKERFILE_SUBDIR/Dockerfile"
CONTEXT="$SCRIPT_DIR/$SUBDIR/"
FULL_TAG="$REGISTRY/$IMAGE_NAME:$VERSION"

echo "========================================"
echo "Building: $IMAGE_NAME ($VERSION)"
echo "Tag:        $FULL_TAG"
echo "Dockerfile: $DOCKERFILE"
echo "Context:    $CONTEXT"
echo "========================================"
echo ""

# --provenance=false --sbom=false: Docker 25+ OCI attestation manifests break
# GitLab Container Registry ("Invalid tag: missing manifest digest")
docker build --no-cache --provenance=false --sbom=false \
    -t "$FULL_TAG" \
    -f "$DOCKERFILE" \
    "$CONTEXT"

if [ $? -eq 0 ]; then
    echo ""
    echo "[OK] $IMAGE_NAME built successfully"
else
    echo ""
    echo "[FAILED] $IMAGE_NAME build failed!"
    exit 1
fi
