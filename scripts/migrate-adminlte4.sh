#!/bin/bash

# AdminLTE 3 to AdminLTE 4 Migration Script
# This script updates CFM files with the new AdminLTE 4 class names and data attributes

# Usage: ./migrate-adminlte4.sh /path/to/html/directory

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/html/directory"
    echo "Example: $0 /opt/hermes-seg-container-gl/config/hermes/var/www/html"
    exit 1
fi

HTML_DIR="$1"

echo "Starting AdminLTE 4 migration in: $HTML_DIR"
echo "============================================"

# Count files to be processed
TOTAL_FILES=$(find "$HTML_DIR" -name "*.cfm" | wc -l)
echo "Found $TOTAL_FILES CFM files to process"
echo ""

# 1. Body class changes
echo "Step 1: Updating body classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/class="hold-transition sidebar-mini"/class="layout-fixed sidebar-expand-lg bg-body-tertiary"/g' \
    -e 's/class="hold-transition sidebar-mini layout-fixed"/class="layout-fixed sidebar-expand-lg bg-body-tertiary"/g' \
    -e 's/class="hold-transition sidebar-mini sidebar-collapse"/class="layout-fixed sidebar-expand-lg sidebar-collapse bg-body-tertiary"/g' \
    {} \;

# 2. Wrapper div changes
echo "Step 2: Updating wrapper classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/<div class="wrapper">/<div class="app-wrapper">/g' \
    {} \;

# 3. Content wrapper changes (div to main)
echo "Step 3: Updating content-wrapper to app-main..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/<div class="content-wrapper">/<main class="app-main">/g' \
    -e 's/<\/div><!-- \/.content-wrapper -->/<\/main>/g' \
    -e 's/<!-- \/.content-wrapper -->/<\/main>\n<!-- Note: Replaced content-wrapper with app-main -->/g' \
    {} \;

# 4. Data attribute changes (Bootstrap 4 to Bootstrap 5)
echo "Step 4: Updating Bootstrap data attributes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/data-toggle="/data-bs-toggle="/g' \
    -e 's/data-dismiss="/data-bs-dismiss="/g' \
    -e 's/data-target="/data-bs-target="/g' \
    -e 's/data-backdrop="/data-bs-backdrop="/g' \
    -e 's/data-keyboard="/data-bs-keyboard="/g' \
    -e 's/data-focus="/data-bs-focus="/g' \
    -e 's/data-ride="/data-bs-ride="/g' \
    -e 's/data-slide="/data-bs-slide="/g' \
    -e 's/data-slide-to="/data-bs-slide-to="/g' \
    -e 's/data-interval="/data-bs-interval="/g' \
    -e 's/data-parent="/data-bs-parent="/g' \
    -e 's/data-spy="/data-bs-spy="/g' \
    -e 's/data-offset="/data-bs-offset="/g' \
    {} \;

# 5. Close button class changes
echo "Step 5: Updating close button classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/class="close"/class="btn-close"/g' \
    -e 's/class="close /class="btn-close /g' \
    {} \;

# 6. Margin/padding left/right to start/end (Bootstrap 5)
echo "Step 6: Updating margin/padding classes (ml/mr/pl/pr to ms/me/ps/pe)..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/class="ml-/class="ms-/g' \
    -e 's/class="mr-/class="me-/g' \
    -e 's/class="pl-/class="ps-/g' \
    -e 's/class="pr-/class="pe-/g' \
    -e 's/ ml-/ ms-/g' \
    -e 's/ mr-/ me-/g' \
    -e 's/ pl-/ ps-/g' \
    -e 's/ pr-/ pe-/g' \
    -e 's/"ml-/"ms-/g' \
    -e 's/"mr-/"me-/g' \
    -e 's/"pl-/"ps-/g' \
    -e 's/"pr-/"pe-/g' \
    {} \;

# 7. Float left/right to start/end
echo "Step 7: Updating float classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/float-left/float-start/g' \
    -e 's/float-right/float-end/g' \
    -e 's/float-sm-left/float-sm-start/g' \
    -e 's/float-sm-right/float-sm-end/g' \
    -e 's/float-md-left/float-md-start/g' \
    -e 's/float-md-right/float-md-end/g' \
    -e 's/float-lg-left/float-lg-start/g' \
    -e 's/float-lg-right/float-lg-end/g' \
    {} \;

# 8. Text alignment
echo "Step 8: Updating text alignment classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/text-left/text-start/g' \
    -e 's/text-right/text-end/g' \
    {} \;

# 9. Border left/right to start/end
echo "Step 9: Updating border classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/border-left/border-start/g' \
    -e 's/border-right/border-end/g' \
    {} \;

# 10. Badge changes
echo "Step 10: Updating badge classes..."
find "$HTML_DIR" -name "*.cfm" -exec sed -i \
    -e 's/badge-primary/text-bg-primary/g' \
    -e 's/badge-secondary/text-bg-secondary/g' \
    -e 's/badge-success/text-bg-success/g' \
    -e 's/badge-danger/text-bg-danger/g' \
    -e 's/badge-warning/text-bg-warning/g' \
    -e 's/badge-info/text-bg-info/g' \
    -e 's/badge-light/text-bg-light/g' \
    -e 's/badge-dark/text-bg-dark/g' \
    {} \;

echo ""
echo "============================================"
echo "Migration complete!"
echo ""
echo "IMPORTANT: Manual review required for:"
echo "1. Check that content-wrapper closing tags are properly replaced"
echo "2. Verify modal and dropdown functionality"
echo "3. Test all interactive components"
echo ""
echo "To rollback, restore from backup files (.adminlte3 extension)"
