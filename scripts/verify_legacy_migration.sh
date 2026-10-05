#!/usr/bin/env bash
# ============================================================================
# verify_legacy_migration.sh
# ============================================================================
# Post-run verification for migrate_legacy_to_docker.sh (#322).
#
# Answers the question the migration log cannot: did the schema bridge actually
# land what it claimed? Run it on the Docker host AFTER a migration.
#
# Read-only against `hermes`. It builds a throwaway `hermes_vref` from the
# shipped baseline to compare against, because the migration drops its own
# `hermes_ref` when it finishes, and drops it again at the end.
#
# Exits non-zero if any check FAILs, so it can gate a test run.
#
# Usage:  sudo ./scripts/verify_legacy_migration.sh
# ============================================================================
set -uo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

# Self-locating: walk up from this script until docker-compose.yml is found.
# Depth-independent, per the repo convention (CLAUDE.md, rotate_db_credentials.sh).
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_ROOT="$_SCRIPT_DIR"
while [[ "$HERMES_ROOT" != "/" && ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
[[ -f "$HERMES_ROOT/docker-compose.yml" ]] || { echo "Could not locate the Hermes root." >&2; exit 2; }

INSTALL_SQL="${HERMES_ROOT}/config/database/hermes_install.sql"
MIGRATE_SH="${HERMES_ROOT}/scripts/migrate_legacy_to_docker.sh"
[[ -f "$INSTALL_SQL" ]] || { echo "Missing ${INSTALL_SQL}" >&2; exit 2; }
[[ -f "$MIGRATE_SH"  ]] || { echo "Missing ${MIGRATE_SH}" >&2; exit 2; }

FAILED=0
pass() { echo -e "  ${GREEN}PASS${NC}  $1"; }
fail() { echo -e "  ${RED}FAIL${NC}  $1"; FAILED=1; }
info() { echo -e "  ${BLUE}    ${NC}  $1"; }
note() { echo -e "  ${YELLOW}NOTE${NC}  $1"; }
head2() { echo ""; echo -e "${BLUE}=== $1 ===${NC}"; }

q()  { docker exec hermes_db_server mariadb -u root -N -e "$1" 2>/dev/null; }

# Pipe SQL into a NAMED database. The database argument is not optional: the
# baseline has its CREATE DATABASE and USE lines stripped before being piped in,
# so without it every CREATE TABLE fails with "No database selected". This
# function used to omit it, and stderr was discarded, so the reference schema
# silently came out empty and every comparison against it passed vacuously.
# The database argument is OPTIONAL, because most callers here use
# fully-qualified `hermes`.`table` names and need no default schema. It is
# required only where the SQL does not qualify, which is the baseline import
# below: its CREATE DATABASE and USE lines are stripped, so without a database
# every CREATE TABLE fails with "No database selected". That is what happened,
# with stderr discarded, so the reference came out empty and every comparison
# against it passed vacuously. The real protection is the table-count guard
# after the import, not this signature.
qi() { docker exec -i hermes_db_server mariadb -u root -N ${1:+"$1"} 2>&1; }

docker ps --format '{{.Names}}' | grep -qx hermes_db_server \
    || { echo "hermes_db_server is not running." >&2; exit 2; }

echo "Hermes root: ${HERMES_ROOT}"

# ---------------------------------------------------------------------------
# Reference DB from the shipped baseline.
# ---------------------------------------------------------------------------
head2 "Building reference schema (hermes_vref) from the baseline"
q "DROP DATABASE IF EXISTS hermes_vref; CREATE DATABASE hermes_vref;" >/dev/null
_ref_err=$(grep -vE '^(CREATE DATABASE|USE `)' "$INSTALL_SQL" | qi hermes_vref)
REF_TABLES=$(q "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='hermes_vref';")
info "hermes_vref built: ${REF_TABLES} tables"

# An empty or short reference makes checks 3, 5 and 6 compare against nothing
# and report PASS regardless. A gate that cannot fail is worse than no gate, so
# stop here rather than produce a reassuring result.
if [[ -z "$REF_TABLES" || "$REF_TABLES" -lt 50 ]]; then
    fail "reference schema did not build (${REF_TABLES:-0} tables). Checks 3, 5 and 6 cannot run."
    [[ -n "$_ref_err" ]] && printf '      %s\n' "$(printf '%s' "$_ref_err" | head -5)"
    q "DROP DATABASE IF EXISTS hermes_vref;" >/dev/null
    exit 1
fi

cleanup() { q "DROP DATABASE IF EXISTS hermes_vref;" >/dev/null; }
trap cleanup EXIT

# ---------------------------------------------------------------------------
# 1. Release stamps
# ---------------------------------------------------------------------------
head2 "1. Release stamps"
EXPECT_BUILD=$(ls -1 "${HERMES_ROOT}/updates/" 2>/dev/null | grep -oE '^v[0-9]{6}$' | sort | tail -1)
GOT_BUILD=$(q "SELECT value FROM hermes.system_settings WHERE parameter='build_no';" | tr -d '[:space:]')
GOT_VER=$(q "SELECT value FROM hermes.system_settings WHERE parameter='version_no';" | tr -d '[:space:]')

[[ "$GOT_BUILD" == "$EXPECT_BUILD" ]] \
    && pass "build_no = ${GOT_BUILD}" \
    || fail "build_no = '${GOT_BUILD}', expected '${EXPECT_BUILD}' (legacy value is 240815)"
[[ "$GOT_VER" == "Docker" ]] \
    && pass "version_no = Docker" \
    || fail "version_no = '${GOT_VER}', expected 'Docker' (legacy value is the Ubuntu release)"

# ---------------------------------------------------------------------------
# 2. v260807 / #293 postscreen DNSBL return-code filters
# ---------------------------------------------------------------------------
head2 "2. Postscreen DNSBL return-code filters (v260807 / #293)"
UNFILTERED=$(q "SELECT COUNT(*) FROM hermes.parameters
                WHERE parent_name='postscreen_dnsbl_sites' AND child=1
                  AND parameter NOT LIKE '%=%';")
[[ "${UNFILTERED:-1}" == "0" ]] \
    && pass "every postscreen DNSBL entry carries a return-code filter" \
    || fail "${UNFILTERED} DNSBL entr(ies) still have no =returncode filter"
q "SELECT CONCAT('      ', parameter, IF(enabled=1,'  [enabled]','  [disabled]'))
   FROM hermes.parameters WHERE parent_name='postscreen_dnsbl_sites' AND child=1 ORDER BY parameter;"

BARRACUDA=$(q "SELECT COUNT(*) FROM hermes.parameters
               WHERE parent_name='postscreen_dnsbl_sites' AND child=1
                 AND parameter LIKE 'b.barracudacentral.org%' AND enabled=1;")
[[ "${BARRACUDA:-0}" -gt 0 ]] && note "b.barracudacentral.org is enabled at weight 7 (threshold 3). Deliberate: not removed by the migration. Disable it under System / RBL Configuration unless this host's IP is registered."

# ---------------------------------------------------------------------------
# 3. Seed-row coverage: no table below the baseline
# ---------------------------------------------------------------------------
head2 "3. Seed-row coverage (every baseline-seeded table)"
SEEDED=$(grep -oE '^INSERT (IGNORE )?INTO `[a-z_0-9]+`' "$INSTALL_SQL" | sed 's/.*`\(.*\)`/\1/' | sort -u)
SEEDED_LIST=$(printf "'%s'," $SEEDED | sed 's/,$//')

SHORT=$(qi <<GEN | qi
SELECT CONCAT(
  'SELECT CONCAT(''', t.TABLE_NAME, ': baseline '', ',
  '(SELECT COUNT(*) FROM \`hermes_vref\`.\`', t.TABLE_NAME, '\`), '' > migrated '', ',
  '(SELECT COUNT(*) FROM \`hermes\`.\`', t.TABLE_NAME, '\`))',
  ' FROM DUAL WHERE (SELECT COUNT(*) FROM \`hermes\`.\`', t.TABLE_NAME, '\`)',
  ' < (SELECT COUNT(*) FROM \`hermes_vref\`.\`', t.TABLE_NAME, '\`);')
FROM information_schema.TABLES t
WHERE t.TABLE_SCHEMA='hermes_vref' AND t.TABLE_NAME IN (${SEEDED_LIST})
  AND EXISTS (SELECT 1 FROM information_schema.TABLES h
              WHERE h.TABLE_SCHEMA='hermes' AND h.TABLE_NAME=t.TABLE_NAME)
ORDER BY t.TABLE_NAME;
GEN
)
if [[ -z "$SHORT" ]]; then
    pass "no seeded table is below its baseline row count"
else
    fail "tables still short of the baseline:"
    printf '        %s\n' $SHORT
fi

# ---------------------------------------------------------------------------
# 4. Join-table referential integrity
# ---------------------------------------------------------------------------
head2 "4. Join-table foreign ids resolve (the newest merge code)"
DANGLE_FRC=$(q "SELECT COUNT(*) FROM hermes.file_rule_components c
                LEFT JOIN hermes.files f ON f.id = c.file_id
                WHERE f.id IS NULL;")
[[ "${DANGLE_FRC:-1}" == "0" ]] \
    && pass "file_rule_components.file_id all resolve to a files row" \
    || fail "${DANGLE_FRC} file_rule_components row(s) point at a missing files.id"

DANGLE_MFU=$(q "SELECT COUNT(*) FROM hermes.malware_feed_urls u
                LEFT JOIN hermes.malware_feeds_config c ON c.id = u.feed_id
                WHERE c.id IS NULL;")
[[ "${DANGLE_MFU:-1}" == "0" ]] \
    && pass "malware_feed_urls.feed_id all resolve to a malware_feeds_config row" \
    || fail "${DANGLE_MFU} malware_feed_urls row(s) point at a missing malware_feeds_config.id"

# ---------------------------------------------------------------------------
# 5. The merge must not have duplicated anything
# ---------------------------------------------------------------------------
head2 "5. No natural key duplicated beyond what the baseline itself holds"
KEYS=$(sed -n '/local SEED_MERGE_KEYS="/,/^"$/p' "$MIGRATE_SH" | grep -E '^[a-z_0-9]+:[a-z_0-9]+$')
DUPFOUND=0
while read -r t; do
    [[ -z "$t" ]] && continue
    cols=$(printf '%s\n' "$KEYS" | awk -F: -v k="$t" '$1==k {printf "`%s`,", $2}' | sed 's/,$//')
    [[ -z "$cols" ]] && continue
    hd=$(q "SELECT COALESCE(SUM(c-1),0) FROM (SELECT COUNT(*) c FROM hermes.\`${t}\` GROUP BY ${cols}) x;")
    bd=$(q "SELECT COALESCE(SUM(c-1),0) FROM (SELECT COUNT(*) c FROM hermes_vref.\`${t}\` GROUP BY ${cols}) x;")
    [[ -z "$hd" || -z "$bd" ]] && continue
    if [[ "$hd" -gt "$bd" ]]; then
        # More duplicates than the baseline has is only a problem if the legacy
        # DB did not already carry them, so report rather than assume.
        note "${t}: ${hd} duplicate natural key(s) vs ${bd} in the baseline (check whether legacy already had them)"
        DUPFOUND=1
    fi
done < <(printf '%s\n' "$KEYS" | cut -d: -f1 | sort -u)
[[ "$DUPFOUND" == "0" ]] && pass "no table carries more duplicate natural keys than the baseline"

# ---------------------------------------------------------------------------
# 6. Operator data preserved
# ---------------------------------------------------------------------------
head2 "6. Operator data (tables where this gateway exceeds the baseline)"
info "These should exceed the baseline. A count AT the baseline where you expect"
info "more means operator rows were lost, which the merge cannot cause but a"
info "failed restore can."
for t in message_rules files policy spam_policies parameters2 system_settings aliases; do
    h=$(q "SELECT COUNT(*) FROM hermes.\`${t}\`;")
    b=$(q "SELECT COUNT(*) FROM hermes_vref.\`${t}\`;")
    printf "        %-18s migrated %-6s baseline %s\n" "$t" "${h:-?}" "${b:-?}"
done

# ---------------------------------------------------------------------------
head2 "Result"
if [[ "$FAILED" == "0" ]]; then
    echo -e "  ${GREEN}All checks passed.${NC}"
    exit 0
else
    echo -e "  ${RED}One or more checks FAILED. See above.${NC}"
    exit 1
fi
