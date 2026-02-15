#!/bin/bash
# =============================================================================
# Hermes SEG - Upload Template Manifest
# =============================================================================
# Uploads the generated manifest to the license validation server.
# The server will sign the manifest with RSA-SHA256 and store it.
#
# Prerequisites:
#   - Run generate_manifest.sh first to create manifest.json
#
# Usage:
#   ./scripts/upload_manifest.sh [version] [--api-key KEY]
#
# Examples:
#   ./scripts/upload_manifest.sh                          # Prompts for version and API key
#   ./scripts/upload_manifest.sh build-260120             # Prompts for API key only
#   ./scripts/upload_manifest.sh build-260120 --api-key "key"  # No prompts
#
# Environment Variables:
#   HERMES_MANIFEST_API_KEY - API key (skips prompt if set)
#   HERMES_VALIDATE_URL     - Override validation server URL (optional)
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
VERSION=""
MANIFEST_FILE="manifest.json"
VALIDATE_URL="${HERMES_VALIDATE_URL:-https://validate.hermesseg.io}"
API_KEY="${HERMES_MANIFEST_API_KEY:-}"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --api-key)
            API_KEY="$2"
            shift 2
            ;;
        --manifest)
            MANIFEST_FILE="$2"
            shift 2
            ;;
        --url)
            VALIDATE_URL="$2"
            shift 2
            ;;
        *)
            # First positional arg is version
            if [[ ! "$1" =~ ^-- ]]; then
                VERSION="$1"
            fi
            shift
            ;;
    esac
done

# Prompt for version if not provided
if [ -z "$VERSION" ]; then
    echo -e "${YELLOW}Enter the build version (e.g., build-260120):${NC}"
    read -p "> " VERSION
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Error: Version is required${NC}"
        exit 1
    fi
    echo ""
fi

echo -e "${GREEN}Uploading manifest for version: ${VERSION}${NC}"
echo "Server: ${VALIDATE_URL}"
echo ""

# Check if manifest file exists
if [ ! -f "$MANIFEST_FILE" ]; then
    echo -e "${RED}Error: Manifest file not found: ${MANIFEST_FILE}${NC}"
    echo "Run generate_manifest.sh first."
    exit 1
fi

# Prompt for API key if not set
if [ -z "$API_KEY" ]; then
    echo -e "${YELLOW}Enter the manifest upload API key:${NC}"
    read -s -p "> " API_KEY
    echo ""
    if [ -z "$API_KEY" ]; then
        echo -e "${RED}Error: API key is required${NC}"
        exit 1
    fi
    echo ""
fi

# Read manifest and extract templates
echo "Reading manifest..."
if ! TEMPLATES=$(jq -c '.templates' "$MANIFEST_FILE" 2>/dev/null); then
    echo -e "${RED}Error: Failed to parse manifest JSON${NC}"
    echo "Ensure jq is installed and manifest.json is valid."
    exit 1
fi

TEMPLATE_COUNT=$(jq '.templates | length' "$MANIFEST_FILE")
echo -e "Templates: ${GREEN}${TEMPLATE_COUNT}${NC}"

# Build upload payload
PAYLOAD=$(jq -n \
    --arg version "$VERSION" \
    --argjson templates "$TEMPLATES" \
    '{version: $version, templates: $templates}')

echo ""
echo "Uploading to ${VALIDATE_URL}/upload_manifest.cfm..."

# Upload manifest
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${VALIDATE_URL}/upload_manifest.cfm" \
    -H "X-API-Key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Parse response
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo ""
echo "======================================"

if [ "$HTTP_CODE" = "200" ]; then
    # Check if response contains success
    if echo "$BODY" | jq -e '.STATUS == "success"' > /dev/null 2>&1; then
        echo -e "${GREEN}Upload successful!${NC}"
        echo ""
        echo "Response:"
        echo "$BODY" | jq .
    else
        echo -e "${RED}Upload failed${NC}"
        echo "Response: $BODY"
        exit 1
    fi
else
    echo -e "${RED}HTTP Error: ${HTTP_CODE}${NC}"
    echo "Response: $BODY"
    exit 1
fi

echo "======================================"
echo ""
echo "Manifest is now available on the license server."
echo "Clients running version $VERSION will have their templates verified."
