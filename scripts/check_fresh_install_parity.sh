#!/usr/bin/env bash
#
# check_fresh_install_parity.sh
#
# Two guards, both about a change landing on every install path rather than
# just the one the author was thinking about. Fresh-vs-upgrade is declared,
# because it is not mechanically decidable. Migration seed coverage is computed,
# because it is.
#
# Per-release artifacts under updates/<version>/ run on UPGRADE ONLY. A fresh
# install builds from config/database/hermes_install.sql plus
# scripts/install_hermes_docker.sh, and never executes a single line of
# updates/. Anything that lands in one and not the other makes an upgraded
# gateway and a newly installed one diverge, on the same release tag.
#
# Nothing enforces that pairing. It holds release after release because whoever
# writes the phase script happens to remember, which is not a mechanism.
#
# This script does not try to work out coverage on its own. That is not
# mechanically decidable, and an attempt to infer it produces confident wrong
# answers: the SMTP TLS path was investigated exactly that way on 2026-08-22 and
# the conclusion was wrong in both directions, because the reasoning ran on a
# truncated grep and missed the installer block that already handled it (#254).
#
# So it forces the AUTHOR to answer the question, at authoring time, in a form a
# machine can check is present. A declaration someone wrote deliberately beats an
# inference nobody checked.
#
# It catches OMISSION only. It cannot catch the case where both paths exist and
# produce different answers. That needs comparing end states; see #321.
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

MIGRATION_FAILED=0

# ---------------------------------------------------------------------------
# Migration seed coverage (the THIRD install path)
# ---------------------------------------------------------------------------
# A feature has to land on three paths, not two: new install, existing install,
# and a legacy 240815 box brought across by migrate_legacy_to_docker.sh.
#
# The fresh-vs-upgrade question above is not mechanically decidable, so it is
# answered by a declaration. This one IS decidable, so it needs no declaration
# at all: every table the baseline seeds must be carried onto a migrated install
# by merge_seed_rows(), either through SEED_MERGE_KEYS, through the join-table
# handler, or by a deliberate written exemption.
#
# Without this, adding a seeded table silently produces a migrated gateway whose
# new feature has no configuration rows, and nobody finds out until a migration
# runs on a customer's box. That is exactly the class #322 was opened for.
# ---------------------------------------------------------------------------
check_migration_seed_coverage() {
    local baseline="config/database/hermes_install.sql"
    local migrate="scripts/migrate_legacy_to_docker.sh"

    if [[ ! -f "$baseline" || ! -f "$migrate" ]]; then
        echo "${YELLOW}  skipped${NC}  baseline or migration script not found"
        return 0
    fi

    local seeded mapped joined exempt covered uncovered n_seeded
    seeded=$(grep -oE '^INSERT (IGNORE )?INTO `[a-z_0-9]+`' "$baseline" \
        | sed 's/.*`\(.*\)`/\1/' | sort -u)

    # Tables merged on a declared natural key.
    mapped=$(sed -n '/SEED_MERGE_KEYS="/,/^"$/p' "$migrate" \
        | grep -E '^[a-z_0-9]+:[a-z_0-9]+$' | cut -d: -f1 | sort -u)

    # Tables whose identity is a foreign id, resolved in the join-table handler.
    joined=$(sed -n '/^merge_join_table_rows()/,/^}/p' "$migrate" \
        | grep -oE 'INSERT INTO `hermes`\.`[a-z_0-9]+`' \
        | sed 's/.*`\(.*\)`/\1/' | sort -u)

    # Deliberate exemptions, written in the migration script as:
    #   # MIGRATION-SEED-EXEMPT: <table>  <reason>
    exempt=$(grep -oE '^#[[:space:]]*MIGRATION-SEED-EXEMPT:[[:space:]]*[a-z_0-9]+' "$migrate" \
        | sed -E 's/.*:[[:space:]]*//' | sort -u)

    covered=$(printf '%s\n%s\n%s\n' "$mapped" "$joined" "$exempt" | grep -v '^$' | sort -u)
    uncovered=$(comm -23 <(printf '%s\n' "$seeded" | grep -v '^$') <(printf '%s\n' "$covered"))

    n_seeded=$(printf '%s\n' "$seeded" | grep -c . )

    if [[ -n "$uncovered" ]]; then
        while read -r t; do
            [[ -z "$t" ]] && continue
            note_fail "config/database/hermes_install.sql seeds '${t}', which merge_seed_rows() does not carry"
            CHECKED=$((CHECKED + 1))
        done <<< "$uncovered"
        MIGRATION_FAILED=1
    else
        CHECKED=$((CHECKED + 1))
        echo "${GREEN}  ok${NC}       all ${n_seeded} seeded table(s) carried by merge_seed_rows()"
    fi
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

echo "${CYAN}Migration seed coverage${NC}"
check_migration_seed_coverage
echo

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
    if [[ $MIGRATION_FAILED -eq 1 ]]; then
        echo "For a table the baseline seeds but the migration does not carry, add"
        echo "its natural key to SEED_MERGE_KEYS in merge_seed_rows(), or if it"
        echo "genuinely should not be carried, declare that deliberately:"
        echo
        echo "  ${YELLOW}# MIGRATION-SEED-EXEMPT: <table>  <reason>${NC}"
        echo
        echo "A migrated gateway is the third install path. A seeded table nobody"
        echo "carried across is a feature with no configuration rows on it."
        echo
    fi
    echo "If you cannot honestly write one, the fresh-install path is missing and"
    echo "that is the bug this check exists to catch."
    exit 1
fi

echo "${GREEN}PASS${NC}: ${CHECKED} artifact(s) declared."
exit 0
