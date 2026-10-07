#!/usr/bin/env bash
# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  generate_nginx_config() renders from the updated template
#
# v261006 -- remove the /hermes-api/ location from the live nginx config.
# Edits only that block, keeps a copy of the original, validates with
# nginx -t and restores on failure. Idempotent.

set -euo pipefail

# ---- Self-locate HERMES_ROOT (walk up to find docker-compose.yml) ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "${HERMES_ROOT:-}" ]]; then
    HERMES_ROOT="$SCRIPT_DIR"
    while [[ "$HERMES_ROOT" != "/" ]]; do
        [[ -f "$HERMES_ROOT/docker-compose.yml" ]] && break
        HERMES_ROOT="$(dirname "$HERMES_ROOT")"
    done
    if [[ "$HERMES_ROOT" == "/" ]]; then
        echo "  Could not locate docker-compose.yml walking up from $SCRIPT_DIR; skipping." >&2
        exit 0
    fi
fi

NGINX_DIR="${HERMES_ROOT}/config/nginx/etc/nginx"
# "location /hermes-api/", any modifier, trailing slash optional.
PATTERN='^[[:space:]]*location[[:space:]]+([=^~*]+[[:space:]]+)?/hermes-api/?([[:space:]]|[{]|$)'

# Regular files only (skip symlinks); skip *.BACKUP* in sites-available.
targets=()
for d in "${NGINX_DIR}/sites-available" "${NGINX_DIR}/sites-enabled"; do
    [[ -d "$d" ]] || continue
    while IFS= read -r -d '' f; do
        if [[ "$d" == */sites-available && "$(basename "$f")" == *.BACKUP* ]]; then
            continue
        fi
        if grep -qE "$PATTERN" "$f"; then
            targets+=( "$f" )
        fi
    done < <(find "$d" -maxdepth 1 -type f -print0)
done

if (( ${#targets[@]} == 0 )); then
    echo "  No /hermes-api/ location in the live nginx config; nothing to do."
    exit 0
fi

nginx_running=0
if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx hermes_nginx; then
    nginx_running=1
fi

# Was the config valid before the edit?
pre_ok=0
if (( nginx_running )) && docker exec hermes_nginx nginx -t >/dev/null 2>&1; then
    pre_ok=1
fi

# Backups go outside the directories nginx loads.
stamp="$(date +%Y%m%d%H%M%S)"
BACKUP_DIR="${NGINX_DIR}/.hermes-api-removal-${stamp}"
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"
originals=()

backup_path() {
    # sites-enabled/hermes-ssl.conf -> sites-enabled__hermes-ssl.conf
    echo "${BACKUP_DIR}/$(basename "$(dirname "$1")")__$(basename "$1")"
}

restore_all() {
    local o
    for o in "${originals[@]}"; do
        cp -a "$(backup_path "$o")" "$o"
    done
}

for f in "${targets[@]}"; do
    bak="$(backup_path "$f")"
    tmp="${bak}.new"
    cp -a "$f" "$bak"
    originals+=( "$f" )

    # Remove the block (brace-counted, nested location included) and one
    # trailing blank line.
    if ! awk -v pat="$PATTERN" '
        eat { eat = 0; if ($0 ~ /^[[:space:]]*$/) next }
        !skip && $0 ~ pat { skip = 1; depth = 0; opened = 0 }
        skip {
            line = $0
            sub(/#.*/, "", line)
            o = gsub(/\{/, "{", line)
            c = gsub(/\}/, "}", line)
            depth += o - c
            if (o > 0) opened = 1
            if (opened && depth <= 0) { skip = 0; eat = 1 }
            next
        }
        { print }
        END { if (skip) exit 3 }
    ' "$f" > "$tmp"; then
        rm -f "$tmp"
        restore_all
        echo "  ERROR: the /hermes-api/ block in ${f} is not brace-balanced; left unchanged." >&2
        echo "  Remove the 'location /hermes-api/ { ... }' block by hand, then run: docker exec hermes_nginx nginx -t" >&2
        exit 1
    fi

    if grep -qE "$PATTERN" "$tmp"; then
        rm -f "$tmp"
        restore_all
        echo "  ERROR: /hermes-api/ still present in ${f} after the edit; left unchanged." >&2
        exit 1
    fi

    chmod --reference="$f" "$tmp" 2>/dev/null || true
    chown --reference="$f" "$tmp" 2>/dev/null || true
    mv "$tmp" "$f"
    echo "  Removed the /hermes-api/ location from ${f#${HERMES_ROOT}/}"
done
echo "  Originals saved in ${BACKUP_DIR#${HERMES_ROOT}/}"

if (( ! nginx_running )); then
    echo "  hermes_nginx is not running; the change applies when it starts."
    exit 0
fi

if docker exec hermes_nginx nginx -t >/dev/null 2>&1; then
    if docker exec hermes_nginx nginx -s reload >/dev/null 2>&1; then
        echo "  Reloaded nginx."
    else
        echo "  WARNING: nginx reload failed; the change applies at the next nginx restart." >&2
    fi
elif (( pre_ok )); then
    restore_all
    echo "  ERROR: nginx rejected the config after removing /hermes-api/; backups restored." >&2
    echo "  Run 'docker exec hermes_nginx nginx -t' to see why, then remove the block by hand." >&2
    exit 1
else
    echo "  WARNING: nginx was already rejecting its config before this change, so it was not reloaded." >&2
    echo "  The /hermes-api/ route is removed from the files; fix the existing error, then reload nginx." >&2
fi
