#!/bin/bash
# Repack ciphermail .deb packages with no-op postinst scripts
# This allows installation during Docker build without systemd
#
# Run this on a Linux system with dpkg-deb installed
# Usage: ./repack-debs-nosystemd.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/deb-repack-$$"

mkdir -p "$WORK_DIR"

repack_deb() {
    local deb_file="$1"
    local base_name=$(basename "$deb_file" .deb)
    local extract_dir="$WORK_DIR/$base_name"

    echo "Processing: $deb_file"

    # Extract the deb
    mkdir -p "$extract_dir"
    dpkg-deb -R "$deb_file" "$extract_dir"

    local new_deb="${deb_file%.deb}-nosystemd.deb"
    local needs_repack=false

    # Check if postinst exists and contains systemctl
    if [ -f "$extract_dir/DEBIAN/postinst" ]; then
        if grep -q "systemctl" "$extract_dir/DEBIAN/postinst"; then
            echo "  Found systemctl in postinst, creating backup and replacing..."

            # Backup original
            cp "$extract_dir/DEBIAN/postinst" "$extract_dir/DEBIAN/postinst.original"

            # Create no-op postinst that just exits successfully
            cat > "$extract_dir/DEBIAN/postinst" << 'EOF'
#!/bin/bash
# Modified for Docker build - systemctl commands removed
# Original postinst backed up as postinst.original
# Services are started by container entrypoint
exit 0
EOF
            chmod 755 "$extract_dir/DEBIAN/postinst"
            needs_repack=true
        else
            echo "  No systemctl found in postinst (copying as-is)"
        fi
    else
        echo "  No postinst script found (copying as-is)"
    fi

    # Always create -nosystemd.deb for consistent naming
    if [ "$needs_repack" = true ]; then
        # Repack modified package
        dpkg-deb -b "$extract_dir" "$new_deb"
        echo "  Created (modified): $new_deb"
    else
        # Just copy with new name for consistency
        cp "$deb_file" "$new_deb"
        echo "  Created (unchanged): $new_deb"
    fi
}

echo "=== Repacking .deb files for Docker build ==="
echo ""

# Find all .deb files excluding already-repacked ones
DEB_FILES=()
for deb in "$SCRIPT_DIR"/*.deb; do
    if [ -f "$deb" ] && [[ ! "$deb" == *"-nosystemd.deb" ]]; then
        DEB_FILES+=("$deb")
    fi
done

if [ ${#DEB_FILES[@]} -eq 0 ]; then
    echo "No .deb files found in $SCRIPT_DIR"
    exit 1
fi

echo "Found the following .deb files:"
for i in "${!DEB_FILES[@]}"; do
    echo "  $((i+1)). $(basename "${DEB_FILES[$i]}")"
done
echo ""

read -p "Process all these files? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# Process selected deb files
for deb in "${DEB_FILES[@]}"; do
    repack_deb "$deb"
done

# Cleanup
rm -rf "$WORK_DIR"

echo ""
echo "=== Done ==="
echo ""
echo "The Dockerfile will automatically use *-nosystemd.deb files"
