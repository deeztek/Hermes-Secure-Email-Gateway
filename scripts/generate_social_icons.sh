#!/bin/bash
#
# generate_social_icons.sh
#
# Fetches brand SVG icons from Simple Icons (https://simpleicons.org/, MIT
# licensed) and renders them to small brand-colored PNGs that the Personal
# Signature template gallery (#226 Phase 1) loads as base64 data URLs at
# template-pick time. The data URLs flow through the existing cid: extraction
# pipeline in inc/signature_write_and_reload.cfm so they become real
# multipart/related image attachments in delivered mail.
#
# Run once on a workstation that has imagemagick OR rsvg-convert installed.
# The output PNGs get committed to the repo so end-user installs don't need
# any conversion tooling.
#
#   ImageMagick path:    sudo apt-get install imagemagick
#   librsvg path:        sudo apt-get install librsvg2-bin
#
# The script auto-detects whichever is available. ImageMagick's SVG renderer
# (via librsvg/rsvg-convert delegate or its built-in MSVG) handles the
# Simple Icons SVGs cleanly at this size.
#
# Usage:
#   ./scripts/generate_social_icons.sh
#
# Re-run any time you want to refresh icons or add new ones - it is idempotent
# and overwrites existing PNGs in the destination directory.
#
# Adding a new icon: append a "<slug> <hex_color>" line in the ICONS list
# below. The slug must match the Simple Icons file name (see
# https://simpleicons.org/ search for the brand). Brand colors are documented
# on the Simple Icons site and on each icon's detail page.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${REPO_ROOT}/config/hermes/var/www/html/users/2/inc/social_icons"
SIZE_PX=24

# slug:hex_color (Simple Icons brand color, no leading #)
# website + email get Bootstrap Icons fallbacks (not in Simple Icons).
ICONS=(
    "linkedin:0A66C2"
    "x:000000"
    "github:181717"
    "youtube:FF0000"
    "instagram:E4405F"
    "facebook:1877F2"
)

# Bootstrap Icons (https://icons.getbootstrap.com/, MIT) for non-brand glyphs.
# slug:hex_color
BS_ICONS=(
    "globe:0d6efd"
    "envelope:6c757d"
)

mkdir -p "${DEST}"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

# Detect renderer
if command -v rsvg-convert >/dev/null 2>&1; then
    RENDERER="rsvg"
elif command -v convert >/dev/null 2>&1; then
    RENDERER="imagemagick"
else
    echo "ERROR: neither rsvg-convert nor convert (ImageMagick) found." >&2
    echo "Install one of:" >&2
    echo "  sudo apt-get install librsvg2-bin     # rsvg-convert" >&2
    echo "  sudo apt-get install imagemagick      # convert" >&2
    exit 1
fi
echo "Using ${RENDERER} for SVG -> PNG conversion."

render_svg_to_png() {
    local svg_path="$1"
    local png_path="$2"
    case "${RENDERER}" in
        rsvg)
            rsvg-convert -w "${SIZE_PX}" -h "${SIZE_PX}" "${svg_path}" -o "${png_path}"
            ;;
        imagemagick)
            convert -background none -density 200 "${svg_path}" \
                -resize "${SIZE_PX}x${SIZE_PX}" "${png_path}"
            ;;
    esac
}

render_brand_icon() {
    # Generic fetch + recolor pipeline. Works for both Simple Icons and
    # Bootstrap Icons because both ship as monochrome SVG with fill=
    # baked into the <svg> root tag (Simple Icons uses black, Bootstrap
    # Icons uses currentColor). We strip the existing fill from just
    # the <svg> opening tag, then inject the requested brand color.
    # Skipping the strip causes librsvg to reject the SVG with
    # "Attribute fill redefined".
    local slug="$1"
    local color="$2"
    local url="$3"
    local svg_in="${TMPDIR}/${slug}.svg"
    local svg_colored="${TMPDIR}/${slug}-colored.svg"
    if ! curl -sfL "${url}" -o "${svg_in}"; then
        echo "WARN: failed to fetch ${slug} from ${url}" >&2
        return 1
    fi
    sed -E -e 's|(<svg[^>]*) fill="[^"]*"|\1|' \
           -e "s|<svg|<svg fill=\"#${color}\"|" \
           "${svg_in}" > "${svg_colored}"
    render_svg_to_png "${svg_colored}" "${DEST}/${slug}.png"
    if [ ! -s "${DEST}/${slug}.png" ]; then
        echo "WARN: ${slug}.png missing or empty after render" >&2
        return 1
    fi
    echo "  ${slug}.png  (${color})"
}

echo "Rendering ${SIZE_PX}x${SIZE_PX} PNG icons to ${DEST}/"
echo

echo "Simple Icons (brand):"
# jsDelivr-hosted npm mirror is more reliable than cdn.simpleicons.org
# (which has had transient 5xx fetch failures on a per-icon basis).
# Same upstream package; Simple Icons returns black SVG that we recolor.
for entry in "${ICONS[@]}"; do
    slug="${entry%%:*}"
    color="${entry#*:}"
    url="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/${slug}.svg"
    render_brand_icon "${slug}" "${color}" "${url}" || true
done

echo
echo "Bootstrap Icons (generic):"
for entry in "${BS_ICONS[@]}"; do
    slug="${entry%%:*}"
    color="${entry#*:}"
    url="https://cdn.jsdelivr.net/npm/bootstrap-icons/icons/${slug}.svg"
    render_brand_icon "${slug}" "${color}" "${url}" || true
done

echo
echo "Done. Files in ${DEST}/:"
ls -la "${DEST}/"
