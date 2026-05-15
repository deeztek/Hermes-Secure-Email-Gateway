#!/bin/bash
# Push all Hermes SEG Docker images to registry
# Usage: ./push-all.sh [version]
# Example: ./push-all.sh v260119
#
# Optionally promotes images to 'latest' after pushing.

REGISTRY="hub.deeztek.com/dedwards/hermes-seg-docker-gl"
DEFAULT_VERSION="v260119"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# List of images to push (must match build-all.sh)
IMAGES=(
    "hermes-ciphermail"
    "hermes-commandbox"
    "hermes-postfix-dkim"
    "hermes-mail-filter"
    "hermes-nginx"
    "hermes-openldap"
    "hermes-dmarc"
    "hermes-dovecot"
    "hermes-unbound"
    "hermes-body-milter"
    "hermes-openarc"
)

# Check Docker is available
if ! command -v docker &>/dev/null; then
    echo "[ERROR] Docker not found in PATH."
    echo "        Run this script from Git Bash terminal."
    exit 1
fi

# Prompt for version (use arg if provided, otherwise prompt)
if [ -n "$1" ]; then
    VERSION="$1"
else
    read -p "Enter version tag to push [$DEFAULT_VERSION]: " VERSION
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

echo "========================================"
echo "Pushing Hermes SEG Docker Images"
echo "Registry: $REGISTRY"
echo "Version:  $VERSION"
echo "========================================"
echo ""

# Confirm before pushing
read -p "Push ${#IMAGES[@]} images with tag '$VERSION'? [y/N]: " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Aborted."
    exit 0
fi
echo ""

FAILED=()
SUCCEEDED=()

for img in "${IMAGES[@]}"; do
    full_tag="$REGISTRY/$img:$VERSION"
    echo "----------------------------------------"
    echo "Pushing: $full_tag"
    echo "----------------------------------------"

    # Check image exists locally
    if ! docker image inspect "$full_tag" &>/dev/null; then
        echo "[SKIP] $img - image not found locally (build it first)"
        FAILED+=("$img (not found locally)")
        echo ""
        continue
    fi

    docker push "$full_tag"

    if [ $? -eq 0 ]; then
        echo "[OK] $img pushed successfully"
        SUCCEEDED+=("$img")
    else
        echo "[FAILED] $img push failed!"
        FAILED+=("$img")
    fi
    echo ""
done

# Summary
echo "========================================"
echo "Push Summary"
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
echo ""

# Prompt to promote to latest
if [ ${#SUCCEEDED[@]} -gt 0 ] && [ ${#FAILED[@]} -eq 0 ]; then
    read -p "Promote successfully pushed images to 'latest'? [y/N]: " PROMOTE
    if [ "$PROMOTE" = "y" ] || [ "$PROMOTE" = "Y" ]; then
        echo ""
        echo "========================================"
        echo "Promoting to latest"
        echo "========================================"
        for img in "${SUCCEEDED[@]}"; do
            full_tag="$REGISTRY/$img:$VERSION"
            latest_tag="$REGISTRY/$img:latest"
            echo "Tagging $img as latest..."
            docker tag "$full_tag" "$latest_tag"
            docker push "$latest_tag"
            if [ $? -eq 0 ]; then
                echo "[OK] $img:latest pushed"
            else
                echo "[FAILED] $img:latest push failed"
            fi
        done
    fi
fi

echo ""
echo "Done."
