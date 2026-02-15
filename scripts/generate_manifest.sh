#!/bin/bash
# =============================================================================
# Hermes SEG - Generate Template Manifest
# =============================================================================
# Generates a JSON manifest of SHA-256 hashes for Pro Edition template files.
# Run this script from the repository root before uploading to the license server.
#
# Usage:
#   ./scripts/generate_manifest.sh [version]
#
# Examples:
#   ./scripts/generate_manifest.sh                    # Prompts for version
#   ./scripts/generate_manifest.sh build-260120       # Explicit version
#
# Output:
#   manifest.json - JSON file with template hashes
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Version from argument or prompt
if [ -n "$1" ]; then
    VERSION="$1"
else
    echo -e "${YELLOW}Enter the build version (e.g., build-260120):${NC}"
    read -p "> " VERSION
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Error: Version is required${NC}"
        exit 1
    fi
    echo ""
fi

# Source directory (relative to repo root)
SRC_DIR="config/hermes/var/www/html"

# Output file
OUTPUT="manifest.json"

# Pro templates config file (shared with manifest_verify.cfm and generate_manifest.ps1)
TEMPLATES_CONFIG="config/hermes/var/www/html/admin/2/inc/pro_templates.json"

# Check if jq is available (required for parsing JSON config)
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required but not installed${NC}"
    echo "Install with: apt-get install jq (Debian/Ubuntu) or brew install jq (macOS)"
    exit 1
fi

# Load templates from shared config
if [ ! -f "$TEMPLATES_CONFIG" ]; then
    echo -e "${RED}Error: Templates config not found: ${TEMPLATES_CONFIG}${NC}"
    echo "Run this script from the repository root."
    exit 1
fi

# Read templates array from JSON
mapfile -t TEMPLATES < <(jq -r '.templates[]' "$TEMPLATES_CONFIG")

echo -e "${GREEN}Generating manifest for version: ${VERSION}${NC}"
echo "Source directory: ${SRC_DIR}"
echo ""

# Check if source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo -e "${RED}Error: Source directory not found: ${SRC_DIR}${NC}"
    echo "Run this script from the repository root."
    exit 1
fi

# Start JSON
echo "{" > "$OUTPUT"
echo "  \"version\": \"$VERSION\"," >> "$OUTPUT"
echo "  \"generated\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$OUTPUT"
echo "  \"algorithm\": \"SHA-256\"," >> "$OUTPUT"
echo "  \"templates\": {" >> "$OUTPUT"

# Track processed files
FIRST=true
FOUND=0
MISSING=0

for template in "${TEMPLATES[@]}"; do
    filepath="${SRC_DIR}/${template}"

    if [ -f "$filepath" ]; then
        # Normalize line endings to LF and calculate SHA-256 hash (lowercase)
        # This ensures consistent hashes across Windows/Linux
        hash=$(sed 's/\r$//' "$filepath" | sha256sum | awk '{print tolower($1)}')

        # Add comma before all but first entry
        if [ "$FIRST" = true ]; then
            FIRST=false
        else
            echo "," >> "$OUTPUT"
        fi

        # Write JSON entry (no trailing newline yet)
        printf "    \"%s\": \"%s\"" "$template" "$hash" >> "$OUTPUT"

        echo -e "  ${GREEN}[OK]${NC} $template"
        FOUND=$((FOUND + 1))
    else
        echo -e "  ${YELLOW}[MISSING]${NC} $template"
        MISSING=$((MISSING + 1))
    fi
done

# Close templates object
echo "" >> "$OUTPUT"
echo "  }," >> "$OUTPUT"

# Compute fingerprint (SHA-256 of all hashes concatenated in sorted order)
# Sort template paths and concatenate their hashes
CONCATENATED=""
for template in $(printf '%s\n' "${TEMPLATES[@]}" | sort); do
    filepath="${SRC_DIR}/${template}"
    if [ -f "$filepath" ]; then
        # Normalize line endings to LF before hashing
        hash=$(sed 's/\r$//' "$filepath" | sha256sum | awk '{print tolower($1)}')
        CONCATENATED="${CONCATENATED}${hash}"
    fi
done

# Hash the concatenation to produce fingerprint
FINGERPRINT=$(echo -n "$CONCATENATED" | sha256sum | awk '{print $1}')

# Add fingerprint to JSON
echo "  \"fingerprint\": \"$FINGERPRINT\"" >> "$OUTPUT"
echo "}" >> "$OUTPUT"

echo ""
echo "======================================"
echo -e "Templates found: ${GREEN}${FOUND}${NC}"
if [ $MISSING -gt 0 ]; then
    echo -e "Templates missing: ${YELLOW}${MISSING}${NC}"
fi
echo -e "Fingerprint: ${GREEN}${FINGERPRINT}${NC}"
echo -e "Output file: ${GREEN}${OUTPUT}${NC}"
echo "======================================"

# Validate JSON if jq is available
if command -v jq &> /dev/null; then
    if jq empty "$OUTPUT" 2>/dev/null; then
        echo -e "${GREEN}JSON validation: OK${NC}"
    else
        echo -e "${RED}JSON validation: FAILED${NC}"
        exit 1
    fi
fi

echo ""
echo "Next step: Upload manifest to license server"
echo "  ./scripts/upload_manifest.sh $VERSION"
