#!/bin/bash
# Build all Hermes SEG Docker images
# Usage: ./build-all.sh [version]
# Example: ./build-all.sh v260119
#
# IMPORTANT: On Windows, run this from Git Bash terminal (not PowerShell/cmd).
# Running "bash" from PowerShell invokes WSL bash which has an incompatible Docker.

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-docker-gl"
VERSION="${1:-v260119}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check Docker is available
if ! command -v docker &>/dev/null; then
    echo "[ERROR] Docker not found in PATH."
    echo "        Run this script from Git Bash terminal."
    exit 1
fi

# Check Docker version (need 17.04+ for nested registry paths)
DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' 2>/dev/null)
DOCKER_MAJOR=$(echo "$DOCKER_VERSION" | cut -d. -f1)
if [ -n "$DOCKER_MAJOR" ] && [ "$DOCKER_MAJOR" -lt 17 ] 2>/dev/null; then
    echo "[ERROR] Docker $DOCKER_VERSION is too old (need 17.04+)."
    echo "        You are likely running WSL's Docker instead of Docker Desktop."
    echo ""
    echo "        FIX: Run this script from Git Bash terminal, not PowerShell/cmd."
    echo "        (PowerShell's 'bash' command opens WSL which has an old Docker)"
    echo ""
    echo "        Your system has multiple bash executables:"
    which -a bash 2>/dev/null || where bash 2>/dev/null
    exit 1
fi

echo "========================================"
echo "Building Hermes SEG Docker Images"
echo "Registry: $REGISTRY"
echo "Version:  $VERSION"
echo "Script:   $SCRIPT_DIR"
echo "Docker:   $(docker --version 2>/dev/null)"
echo "Path:     $(command -v docker)"
echo "========================================"
echo ""

FAILED=()
SUCCEEDED=()

build_image() {
    local name="$1"
    local dockerfile="$2"
    local context="$3"
    local full_tag="$REGISTRY/$name:$VERSION"

    echo "----------------------------------------"
    echo "Building: $name ($VERSION)"
    echo "Tag:        $full_tag"
    echo "Dockerfile: $dockerfile"
    echo "Context:    $context"
    echo "----------------------------------------"

    # --provenance=false --sbom=false: Docker 25+ OCI attestation manifests break
    # GitLab Container Registry ("Invalid tag: missing manifest digest")
    echo "[RUN] docker build --no-cache --provenance=false --sbom=false -t \"$full_tag\" -f \"$dockerfile\" \"$context\""
    docker build --no-cache --provenance=false --sbom=false -t "$full_tag" -f "$dockerfile" "$context"

    if [ $? -eq 0 ]; then
        echo "[OK] $name built successfully"
        echo ""
        SUCCEEDED+=("$name")
    else
        echo "[FAILED] $name build failed!"
        echo ""
        FAILED+=("$name")
    fi
}

# Ciphermail (requires repack-debs-nosystemd.sh to have been run first)
if ! ls "$SCRIPT_DIR"/ciphermail/build/djigzo_*-nosystemd.deb 1>/dev/null 2>&1; then
    echo "[WARN] Ciphermail: No -nosystemd.deb files found."
    echo "       Run Docker/ciphermail/build/repack-debs-nosystemd.sh first."
    echo "       Skipping ciphermail build."
    echo ""
    FAILED+=("hermes-ciphermail (skipped - run repack-debs-nosystemd.sh first)")
else
    build_image "hermes-ciphermail" \
        "$SCRIPT_DIR/ciphermail/dockerfiles/ciphermail/Dockerfile" \
        "$SCRIPT_DIR/ciphermail/"
fi

# Commandbox
build_image "hermes-commandbox" \
    "$SCRIPT_DIR/commandbox/dockerfiles/commandbox/Dockerfile" \
    "$SCRIPT_DIR/commandbox/"

# Postfix-DKIM
build_image "hermes-postfix-dkim" \
    "$SCRIPT_DIR/postfix_dkim/dockerfiles/postfix_dkim/Dockerfile" \
    "$SCRIPT_DIR/postfix_dkim/"

# Mail Filter
build_image "hermes-mail-filter" \
    "$SCRIPT_DIR/mail_filter/dockerfiles/mail_filter/Dockerfile" \
    "$SCRIPT_DIR/mail_filter/"

# Nginx
build_image "hermes-nginx" \
    "$SCRIPT_DIR/nginx/dockerfiles/nginx/Dockerfile" \
    "$SCRIPT_DIR/nginx/"

# OpenLDAP
build_image "hermes-openldap" \
    "$SCRIPT_DIR/openldap/dockerfiles/openldap/Dockerfile" \
    "$SCRIPT_DIR/openldap/"

# DMARC
build_image "hermes-dmarc" \
    "$SCRIPT_DIR/opendmarc/dockerfiles/opendmarc/Dockerfile" \
    "$SCRIPT_DIR/opendmarc/"

# Summary
echo "========================================"
echo "Build Summary"
echo "========================================"
if [ ${#SUCCEEDED[@]} -gt 0 ]; then
    echo "SUCCEEDED (${#SUCCEEDED[@]}):"
    for s in "${SUCCEEDED[@]}"; do
        echo "  - $s"
    done
fi
if [ ${#FAILED[@]} -gt 0 ]; then
    echo "FAILED (${#FAILED[@]}):"
    for f in "${FAILED[@]}"; do
        echo "  - $f"
    done
fi
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "All ${#SUCCEEDED[@]} images built successfully!"
fi

echo ""
echo "To push all images:"
echo "  for img in hermes-ciphermail hermes-commandbox hermes-postfix-dkim hermes-mail-filter hermes-nginx hermes-openldap hermes-dmarc; do"
echo "    docker push $REGISTRY/\$img:$VERSION"
echo "  done"
echo ""
echo "To promote to latest after testing:"
echo "  for img in hermes-ciphermail hermes-commandbox hermes-postfix-dkim hermes-mail-filter hermes-nginx hermes-openldap hermes-dmarc; do"
echo "    docker tag $REGISTRY/\$img:$VERSION $REGISTRY/\$img:latest"
echo "    docker push $REGISTRY/\$img:latest"
echo "  done"
