#!/bin/bash
# =============================================================================
# Hermes SEG - Publish Template Manifest (Interactive Wrapper)
# =============================================================================
# Interactive wrapper that guides you through generating and uploading
# a template manifest to the license validation server.
#
# Usage:
#   ./scripts/publish_manifest.sh
#
# This script will prompt for:
#   - Build version (e.g., build-260120)
#   - API key (if not set via environment variable)
#   - Confirmation before upload
#
# Environment Variables (optional):
#   HERMES_MANIFEST_API_KEY - Pre-set API key to skip prompt
#   HERMES_VALIDATE_URL     - Override validation server URL
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║          Hermes SEG - Template Manifest Publisher              ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# Step 1: Get build version
# =============================================================================
echo -e "${CYAN}Step 1: Build Version${NC}"
echo "Enter the build version (e.g., build-260120):"
read -p "> " VERSION

if [ -z "$VERSION" ]; then
    echo -e "${RED}Error: Version is required${NC}"
    exit 1
fi

echo ""

# =============================================================================
# Step 2: Generate manifest
# =============================================================================
echo -e "${CYAN}Step 2: Generate Manifest${NC}"
echo -e "Generating manifest for ${GREEN}${VERSION}${NC}..."
echo ""

"${SCRIPT_DIR}/generate_manifest.sh" "$VERSION"

echo ""

# =============================================================================
# Step 3: Confirm upload
# =============================================================================
echo -e "${CYAN}Step 3: Upload to License Server${NC}"
read -p "Upload manifest to validate.hermesseg.io? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Upload cancelled. Manifest saved to manifest.json${NC}"
    echo "To upload later, run:"
    echo "  ./scripts/upload_manifest.sh $VERSION"
    exit 0
fi

echo ""

# =============================================================================
# Step 4: Get API key
# =============================================================================
if [ -z "$HERMES_MANIFEST_API_KEY" ]; then
    echo -e "${CYAN}Step 4: API Authentication${NC}"
    echo "Enter the manifest upload API key:"
    read -s -p "> " API_KEY
    echo ""

    if [ -z "$API_KEY" ]; then
        echo -e "${RED}Error: API key is required${NC}"
        exit 1
    fi

    export HERMES_MANIFEST_API_KEY="$API_KEY"
fi

echo ""

# =============================================================================
# Step 5: Upload manifest
# =============================================================================
echo -e "${CYAN}Step 5: Uploading Manifest${NC}"
echo ""

"${SCRIPT_DIR}/upload_manifest.sh" "$VERSION"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Manifest Published!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Build $VERSION is now ready for deployment."
echo ""
