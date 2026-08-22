#!/usr/bin/env bash
#
# check_fresh_install_parity.sh
#
# Per-release artifacts under updates/<version>/ run on UPGRADE ONLY. A fresh
# install builds from config/database/hermes_install.sql plus
# scripts/install_hermes_docker.sh, and never executes a single line of
# updates/. Anything that lands in one and not the other makes an upgraded
# gateway and a newly installed one diverge, on the same release tag.
#
# Nothing enforced that pairing. It held release after release purely because
# whoever wrote the phase script happened to remember. On v260815 it did not
# hold: 40-fix-smtp-tls-chain-path.sh moved the SMTP TLS path from the leaf to
# the bundle for every upgraded install, while the installer kept writing the
# leaf and the baseline seeded a third value again (the Debian snakeoil path).
# Because generate_postfix_configuration.cfm rebuilds main.cf from those rows,
# the first Postfix settings save of any kind swapped a fresh install onto a
# certificate Hermes does not manage. Same failure shape as #251.
#
# This script does not try to work out coverage on its own -- that is not
# mechanically decidable. It forces the AUTHOR to answer the question, at
# authoring time, in a form a machine can check is present.
#
# Every phase script and every numbered section of schema_updates.sql must
# carry one declaration:
#
#   # FRESH-INSTALL: covered-by <path>[ <note>]
#   # FRESH-INSTALL: n/a <reason>
#
# For SQL sections use "-- FRESH-INSTALL:" instead of "#".
#
# covered-by  the named file must exist, and is where a fresh install gets the
#             same outcome. Usually config/database/hermes_install.sql or
#             scripts/install_hermes_docker.sh.
# n/a         genuinely upgrade-only. Repairing data that only a pre-existing
#             install can have is the common honest case.
#
# Usage:
#   scripts/check_fresh_install_parity.sh              # newest release (default)
#   scripts/check_fresh_install_parity.sh v260815      # one release
#   scripts/check_fresh_install_parity.sh --all        # every release, incl. pre-convention
#
# Exit 0 clean, 1 if any artifact is undeclared or names a missing file.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; CYAN=$'\033[0;36m'; NC=$'\033[0m'

# Default scope is the NEWEST release only. Releases before this convention
# existed are not retro-annotated: making a new guard demand a cleanup of
# history is how guards get disabled. Forward-only is the point.
TARGET="${1:-}"
if [[ "$TARGET" == "--all" ]]; then
    DIRS=$(find updates -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
elif [[ -n "$TARGET" ]]; then
    DIRS="updates/${TARGET}"
    [[ -d "$DIRS" ]] || { echo "${RED}No such release dir: ${DIRS}${NC}"; exit 1; }
else
    DIRS=$(find updates -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -V | tail -1)
fi

FAILED=0
CHECKED=0

note_fail() { echo "${RED}  MISSING${NC}  $1"; FAILED=$((FAILED + 1)); }

# Validate one declaration line. $1 = the text after "FRESH-INSTALL:", $2 = where.
validate_decl() {
    local decl where target
    decl="$(echo "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    where="$2"
    case "$decl" in
        covered-by\ *)
            target="$(echo "$decl" | awk '{print $2}')"
            if [[ ! -e "$target" ]]; then
                note_fail "${where}: covered-by names a path that does not exist: ${target}"
                return 1
            fi
            ;;
        n/a\ *) : ;;
        n/a)
            note_fail "${where}: 'n/a' needs a reason after it"
            return 1
            ;;
        *)
            note_fail "${where}: unrecognised declaration '${decl}' (expected 'covered-by <path>' or 'n/a <reason>')"
            return 1
            ;;
    esac
    return 0
}

echo "${CYAN}Fresh-install parity check${NC}"
echo

for d in $DIRS; do
    rel="$(basename "$d")"
    echo "${CYAN}${rel}${NC}"

    # ---- phase scripts ----
    shopt -s nullglob
    for f in "$d"/scripts/*.sh; do
        CHECKED=$((CHECKED + 1))
        line="$(grep -m1 -E '^[[:space:]]*#[[:space:]]*FRESH-INSTALL:' "$f" 2>/dev/null)"
        if [[ -z "$line" ]]; then
            note_fail "$f  (no '# FRESH-INSTALL:' declaration)"
            continue
        fi
        validate_decl "${line#*FRESH-INSTALL:}" "$f" && echo "${GREEN}  ok${NC}       $f"
    done

    # ---- schema_updates.sql, per numbered section ----
    sql="$d/sql/schema_updates.sql"
    if [[ -f "$sql" ]]; then
        while IFS='|' read -r lineno header; do
            [[ -z "$lineno" ]] && continue
            CHECKED=$((CHECKED + 1))
            note_fail "${sql}:${lineno}  section '${header}' has no '-- FRESH-INSTALL:' declaration"
        done < <(awk '
            function flush() { if (sec != "" && !found) printf "%d|%s\n", secline, sec }
            /^--[[:space:]]*[0-9]+\./ { flush(); sec=$0; sub(/^--[[:space:]]*/, "", sec); secline=NR; found=0; next }
            /^--[[:space:]]*FRESH-INSTALL:/ { found=1 }
            END { flush() }
        ' "$sql")

        # validate the declarations that ARE present
        while IFS=':' read -r lineno rest; do
            [[ -z "$lineno" ]] && continue
            validate_decl "${rest#*FRESH-INSTALL:}" "${sql}:${lineno}" >/dev/null
        done < <(grep -nE '^--[[:space:]]*FRESH-INSTALL:' "$sql" 2>/dev/null)

        local_ok=$(grep -cE '^--[[:space:]]*FRESH-INSTALL:' "$sql" 2>/dev/null)
        echo "${GREEN}  ok${NC}       ${sql}  (${local_ok} section declaration(s))"
    fi
    shopt -u nullglob
    echo
done

if [[ $FAILED -gt 0 ]]; then
    echo "${RED}FAILED${NC}: ${FAILED} artifact(s) undeclared out of ${CHECKED} checked."
    echo
    echo "Add one of these to each, near the top for a script, inside the section"
    echo "comment for SQL:"
    echo
    echo "  ${YELLOW}# FRESH-INSTALL: covered-by config/database/hermes_install.sql${NC}"
    echo "  ${YELLOW}# FRESH-INSTALL: covered-by scripts/install_hermes_docker.sh  <function or line>${NC}"
    echo "  ${YELLOW}# FRESH-INSTALL: n/a  repairs data only a pre-existing install can have${NC}"
    echo
    echo "If you cannot honestly write one, the fresh-install path is missing and"
    echo "that is the bug this check exists to catch."
    exit 1
fi

echo "${GREEN}PASS${NC}: ${CHECKED} artifact(s) declared."
exit 0
