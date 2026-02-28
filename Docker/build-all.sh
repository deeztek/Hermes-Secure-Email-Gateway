#!/bin/bash
# Build all Hermes SEG Docker images
# Usage: ./build-all.sh [version]
# Example: ./build-all.sh v260119

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-container-gl"
VERSION="${1:-v260119}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "Building Hermes SEG Docker Images"
echo "Registry: $REGISTRY"
echo "Version:  $VERSION"
echo "========================================"
echo ""

FAILED=()

build_image() {
    local name="$1"
    local dockerfile="$2"
    local context="$3"
    local full_tag="$REGISTRY/$name:$VERSION"

    echo "----------------------------------------"
    echo "Building: $name ($VERSION)"
    echo "Dockerfile: $dockerfile"
    echo "Context: $context"
    echo "----------------------------------------"

    docker build --no-cache -t "$full_tag" -f "$dockerfile" "$context"

    if [ $? -eq 0 ]; then
        echo "[OK] $name built successfully"
        echo ""
    else
        echo "[FAILED] $name build failed!"
        echo ""
        FAILED+=("$name")
    fi
}

# Ciphermail (requires repack-debs-nosystemd.sh to have been run first)
if [ ! -f "$SCRIPT_DIR/ciphermail/build/djigzo_"*"-nosystemd.deb" ] 2>/dev/null; then
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
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "All images built successfully!"
else
    echo "FAILED builds:"
    for f in "${FAILED[@]}"; do
        echo "  - $f"
    done
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
