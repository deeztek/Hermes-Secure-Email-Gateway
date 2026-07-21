#!/bin/bash
# ============================================================================
# Hermes SEG - Legacy to Docker Migration Script
# ============================================================================
#
# This script migrates a legacy (non-Docker) Hermes SEG installation to Docker.
# It processes backups created by the legacy system_backup.sh script.
#
# Prerequisites:
#   - Docker and Docker Compose installed
#   - Hermes SEG Docker repository cloned anywhere (root is auto-detected)
#   - Legacy backup file (hermes-system-*.tar.gz)
#   (no MySQL root password needed -- Docker MariaDB root auth is unix_socket)
#
# Usage:
#   ./migrate_legacy_to_docker.sh -B /path/to/hermes-system-backup.tar.gz
#
# Flags:
#   -B = Path to the legacy backup file (hermes-system-*.tar.gz)
#   -R = MySQL root password (accepted for compatibility; UNUSED -- Docker
#        MariaDB root auth is unix_socket, so no password is ever needed)
#   -D = Docker Hermes root (default: auto-detected from this script's location)
#   -M = Data mount point (default: /mnt/data)
#   -V = Vmail mount point (default: /mnt/vmail)
#
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Defaults
# HERMES_ROOT self-locates by walking up from this script looking for
# docker-compose.yml, so the install root can be anywhere (/opt/hermes-seg,
# /opt/Hermes-Secure-Email-Gateway, /opt/hermes-seg-container-gl, ...).
# -D still overrides. If the walk-up fails we do NOT silently substitute a
# guessed path -- that is what produced the misleading
# "Hermes Docker root not found: /opt/hermes-seg" when the real install was
# elsewhere. Instead flag it and let validation say what actually went wrong.
_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HERMES_ROOT="$_SCRIPT_DIR"
while [[ "$HERMES_ROOT" != "/" ]] && [[ ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
HERMES_ROOT_AUTODETECTED=1
if [[ "$HERMES_ROOT" == "/" ]]; then
    HERMES_ROOT=""
    HERMES_ROOT_AUTODETECTED=0
fi
DATA_MOUNT="/mnt/data"
ARCHIVE_MOUNT="/mnt/archive"  # #260: Amavis quarantine tier
VMAIL_MOUNT="/mnt/vmail"
TEMP_DIR="/tmp/hermes_migration_$$"
LOG_FILE="/var/log/hermes_migration_$(date +%Y%m%d_%H%M%S).log"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

header() {
    echo "" | tee -a "$LOG_FILE"
    echo -e "${BLUE}============================================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}  $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${BLUE}============================================================${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        log "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

# ----------------------------------------------------------------------------
# restore_email_archive <archive-tarball>
# ----------------------------------------------------------------------------
# Restores the legacy email quarantine (physical files) onto the Docker Archive
# tier. Touches NO database or config -- the msgs/msgrcpt/maddr metadata comes in
# with the SYSTEM restore's hermes.sql, so this half just lays the files down and
# the two reconnect.
#
# Layout: inside hermes_mail_filter amavis's $QUARANTINEDIR is /mnt/data/amavis,
# which maps to the host Archive tier at ${ARCHIVE_MOUNT}/amavis. The legacy
# tarball stores paths as `mnt/data/amavis/...`, so strip the leading `mnt/data/`
# and extract straight onto the tier -- no intermediate copy, no double space.
restore_email_archive() {
    local archive_file="$1"
    header "Restoring Email Archive (quarantine files)"

    local dest="${ARCHIVE_MOUNT}/amavis"
    mkdir -p "$dest"

    # Pre-flight: the Archive tier must have room for the expanded quarantine.
    # Quarantine content is mostly already-compressed messages, so budget ~1.3x
    # the compressed size and fail early with a clear message if it won't fit.
    local avail need_est
    avail=$(df -Pk "$dest" 2>/dev/null | awk 'NR==2{printf "%.0f", $4*1024}')
    need_est=$(( $(stat -c%s "$archive_file" 2>/dev/null || echo 0) * 13 / 10 ))
    if [[ -n "$avail" && "$avail" -lt "$need_est" ]]; then
        error "Archive tier ${ARCHIVE_MOUNT} has ~$(( avail/1024/1024/1024 ))G free but the quarantine needs ~$(( need_est/1024/1024/1024 ))G. Grow the disk (or point -A at a larger tier), then re-run --archive-only."
    fi

    log "Extracting quarantine to ${dest} (large archives take a while)..."
    # Extract only the mnt/data/amavis subtree, stripping mnt/data/ so it lands
    # directly at ${ARCHIVE_MOUNT}/amavis.
    if ! tar -xzf "$archive_file" -C "${ARCHIVE_MOUNT}" --strip-components=2 mnt/data/amavis >> "$LOG_FILE" 2>&1; then
        warn "  targeted extract failed; retrying with a full extract to ${ARCHIVE_MOUNT}"
        tar -xzf "$archive_file" -C "${ARCHIVE_MOUNT}" >> "$LOG_FILE" 2>&1 \
            || { warn "  archive extraction reported errors -- check ${LOG_FILE}."; return 1; }
    fi

    # Ownership: match the pre-provisioned Archive tier owner (the amavis uid/gid
    # the hermes_mail_filter container runs as).
    local arc_owner
    arc_owner=$(stat -c '%u:%g' "$dest" 2>/dev/null || true)
    if [[ -n "$arc_owner" ]]; then
        chown -R "$arc_owner" "$dest" >> "$LOG_FILE" 2>&1 || true
    fi
    log "Email archive restored to ${dest} (owner ${arc_owner:-unchanged})"
}

# ----------------------------------------------------------------------------
# apply_schema_forward
# ----------------------------------------------------------------------------
# After the legacy `hermes` DB is restored, its schema matches the source build
# (240815), not the current Docker baseline. Bring it forward, additively, to
# whatever schema the shipped config/database/hermes_install.sql defines:
#   1. build a throwaway `hermes_ref` DB from the baseline (current schema)
#   2. CREATE any tables the baseline has but the restored DB lacks (LIKE ref)
#   3. ADD any columns the baseline has but the restored tables lack, using the
#      baseline's exact type/nullability/default (so existing rows get correct
#      defaults, e.g. recipients.auth_type -> 'local')
#   4. verify no baseline columns remain missing, then drop `hermes_ref`
# This is self-maintaining: it always targets the shipped baseline, so it stays
# correct if the baseline schema evolves. It is additive only -- it never drops
# or retypes existing columns (legacy-only columns are left in place).
apply_schema_forward() {
    header "Bridging Schema Forward (legacy build -> current baseline)"

    local install_sql="${HERMES_ROOT}/config/database/hermes_install.sql"
    if [[ ! -f "$install_sql" ]]; then
        warn "Baseline ${install_sql} not found; skipping schema-forward."
        warn "The app may hit missing columns until the schema is reconciled."
        return 0
    fi

    log "Building current-schema reference (hermes_ref) from baseline..."
    docker exec hermes_db_server mariadb -u root \
        -e "DROP DATABASE IF EXISTS hermes_ref; CREATE DATABASE hermes_ref;" >> "$LOG_FILE" 2>&1
    grep -vE '^(CREATE DATABASE|USE `)' "$install_sql" \
        | docker exec -i hermes_db_server mariadb -u root hermes_ref >> "$LOG_FILE" 2>&1

    # 1) Create tables present in the baseline but missing from the restored DB.
    local missing_tables t
    missing_tables=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT table_name FROM information_schema.tables WHERE table_schema='hermes_ref' AND table_name NOT IN (SELECT table_name FROM information_schema.tables WHERE table_schema='hermes');" 2>/dev/null)
    for t in $missing_tables; do
        log "  + creating missing table: ${t}"
        docker exec hermes_db_server mariadb -u root \
            -e "CREATE TABLE hermes.\`${t}\` LIKE hermes_ref.\`${t}\`;" >> "$LOG_FILE" 2>&1
    done

    # 2) Add columns present in the baseline but missing from the restored tables.
    #    Single-quoted heredoc so bash leaves the SQL backticks/quotes untouched.
    local alters col_count
    alters=$(docker exec -i hermes_db_server mariadb -u root -N hermes_ref <<'GENSQL'
SELECT CONCAT(
  'ALTER TABLE `', r.table_name, '` ADD COLUMN IF NOT EXISTS `', r.column_name, '` ',
  r.column_type,
  IF(r.is_nullable='NO',' NOT NULL',' NULL'),
  IF(r.column_default IS NOT NULL, CONCAT(' DEFAULT ', r.column_default), ''),
  IF(r.extra<>'' AND r.extra NOT LIKE '%VIRTUAL%' AND r.extra NOT LIKE '%STORED%', CONCAT(' ', r.extra), ''),
  ';')
FROM information_schema.columns r
WHERE r.table_schema='hermes_ref'
AND NOT EXISTS (
  SELECT 1 FROM information_schema.columns h
  WHERE h.table_schema='hermes' AND h.table_name=r.table_name AND h.column_name=r.column_name)
ORDER BY r.table_name, r.ordinal_position;
GENSQL
    )
    col_count=$(printf '%s\n' "$alters" | grep -c 'ALTER TABLE' || true)
    if [[ "$col_count" -gt 0 ]]; then
        log "  + adding ${col_count} missing column(s) to match current schema"
        printf '%s\n' "$alters" | docker exec -i hermes_db_server mariadb -u root hermes >> "$LOG_FILE" 2>&1
    fi

    # 3) Backfill values DERIVED from existing data.
    #    Adding a column only creates it NULL. Any column whose value is derived
    #    from data the legacy DB already has must be populated explicitly --
    #    schema-forward alone leaves it empty and the app reads nothing.
    #
    #    parameters.parent_name: legacy linked a child row to its parent via
    #    parameters.parent (the PARENT ROW'S id). Current code joins on
    #    parent_name (the parent's `parameter` string), e.g.
    #    inc/generate_postfix_configuration.cfm:
    #        select parameter from parameters
    #        where child='1' and parent_name = '<directive>' and enabled='1'
    #    Left NULL that matches nothing for EVERY postfix directive, so the
    #    generated postconf script emits a bare `message_size_limit =` and
    #    postfix aborts with "bad numerical configuration". Symptom: Save &
    #    Apply Settings fails on the SPF, DKIM and DMARC pages alike, since all
    #    three regenerate the postfix config.
    log "  + backfilling parameters.parent_name from parameters.parent"
    # Join and every guard go through CAST(... AS CHAR) so this works whatever
    # type `parent` has: the legacy dump defines it int(11), the current
    # baseline varchar(255), and schema-forward is additive so it keeps the
    # legacy type. Two traps this avoids:
    #   - CAST(parent AS UNSIGNED) throws "Truncated incorrect DECIMAL value"
    #     under strict sql_mode (MariaDB 11.4) on any non-numeric/empty parent,
    #     and the JOIN evaluates it across ALL rows before WHERE filters to
    #     child=1 -- so a child=2 row's empty parent aborts the whole statement.
    #   - `parent <> ''` compares an int column to a string literal, which also
    #     trips the same strict-mode error on a write.
    # CAST-to-CHAR never truncates, so both are sidestepped. Empty/0/NULL
    # parents simply fail to match a real id and are left alone -- no separate
    # guard needed.
    # NOT wrapped in `if` on purpose: this MUST NOT silently abort the whole
    # migration via set -e and leave a half-restored system. On failure we want
    # a clear error at this step, so capture status and call error().
    local backfill_rc=0
    docker exec -i hermes_db_server mariadb -u root hermes >> "$LOG_FILE" 2>&1 <<'BACKFILL_SQL' || backfill_rc=$?
UPDATE parameters c
JOIN parameters p ON CAST(p.id AS CHAR) = CAST(c.parent AS CHAR)
SET c.parent_name = p.parameter
WHERE c.child = 1
  AND c.parent IS NOT NULL
  AND (c.parent_name IS NULL OR c.parent_name = '');
BACKFILL_SQL
    if [[ "$backfill_rc" -ne 0 ]]; then
        error "parameters.parent_name backfill failed (mariadb exit ${backfill_rc}). See ${LOG_FILE}. The databases are restored but configs/LDAP/rehost/archive have NOT run; fix the cause and re-run -- the DB restore and schema-forward are idempotent."
    fi

    # Count only rows the backfill SHOULD have fixed, i.e. those that HAVE a
    # numeric parent. The current baseline also ships child rows with parent
    # NULL and parent_name pre-set (added after parent_name became the canonical
    # link, e.g. tls_server_sni_maps); those are unbackfillable by definition and
    # must not be reported as failures.
    # CAST(parent AS CHAR) NOT IN ('','0') is the type-agnostic "has a real
    # parent" test (see the backfill note); a bare `parent <> ''` would hit the
    # same strict-mode error on the int column.
    local orphan_children
    orphan_children=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT COUNT(*) FROM hermes.parameters WHERE child=1 AND (parent_name IS NULL OR parent_name='') AND parent IS NOT NULL AND CAST(parent AS CHAR) NOT IN ('','0');" 2>/dev/null)
    if [[ "${orphan_children:-0}" != "0" ]]; then
        warn "  ${orphan_children} parameters child row(s) still have no parent_name."
        warn "  Postfix directive generation may emit empty values; check ${LOG_FILE}."
    else
        log "  + parent_name backfill verified (0 child rows unlinked)"
    fi

    # 4) Merge in baseline seed ROWS the legacy DB never had.
    #    Steps 1-3 reconcile structure; they never add rows. A legacy DB is
    #    missing every `parameters` directive added since its build, so those
    #    features are silently unconfigured (not broken-loudly) -- e.g.
    #    tls_server_sni_maps and the discard-recipients access check.
    #
    #    Identity is the natural key (module, child, parameter, parent_name),
    #    NOT the id: baseline ids and legacy ids are unrelated numbering, so
    #    inserting with explicit ids would collide. New rows are inserted with
    #    id auto-assigned and parent NULL -- the baseline's `parent` holds
    #    BASELINE row ids, meaningless here; parent_name is the link the app
    #    actually uses.
    #
    #    Strictly additive: rows that already exist are left exactly as they
    #    are, so operator customisations to existing directives survive. Runs
    #    AFTER the parent_name backfill so legacy child rows already carry
    #    their parent_name and are matched, not duplicated.
    local before_rows after_rows max_id_before
    before_rows=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT COUNT(*) FROM hermes.parameters;" 2>/dev/null)
    max_id_before=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT COALESCE(MAX(id),0) FROM hermes.parameters;" 2>/dev/null)
    docker exec -i hermes_db_server mariadb -u root >> "$LOG_FILE" 2>&1 <<'SEED_SQL'
INSERT INTO hermes.parameters
  (parameter, whitelist, blacklist, weight, smtpd_recipient_restrictions, name,
   module, priority, default_value, editable, conf_file, description, parent,
   parent_name, child, order1, enabled, applied, action, network_entry, note)
SELECT r.parameter, r.whitelist, r.blacklist, r.weight, r.smtpd_recipient_restrictions,
       r.name, r.module, r.priority, r.default_value, r.editable, r.conf_file,
       r.description, NULL, r.parent_name, r.child, r.order1, r.enabled, r.applied,
       r.action, r.network_entry, r.note
FROM hermes_ref.parameters r
WHERE
  -- (a) child=2: a DIRECTIVE row. Its identity is the directive name.
  (
    r.child = 2
    AND NOT EXISTS (
      SELECT 1 FROM hermes.parameters h
      WHERE h.module <=> r.module AND h.child = 2 AND h.parameter <=> r.parameter)
  )
  -- (b) child=1 under a SINGLE-valued directive: `parameter` holds the VALUE,
  --     which the operator may legitimately have changed (e.g. a different
  --     message_size_limit). Identity is therefore the parent link ALONE --
  --     matching on the value too would treat an edited row as missing and
  --     insert a second value for the same directive.
  OR (
    r.child = 1
    AND (SELECT COUNT(*) FROM hermes_ref.parameters r2
         WHERE r2.child = 1 AND r2.module <=> r.module
           AND r2.parent_name <=> r.parent_name) = 1
    AND NOT EXISTS (
      SELECT 1 FROM hermes.parameters h
      WHERE h.module <=> r.module AND h.child = 1
        AND h.parent_name <=> r.parent_name)
  )
  -- (c) child=1 under a MULTI-valued directive (an ordered list such as
  --     smtpd_recipient_restrictions): each distinct value IS its own row, so
  --     the value belongs in the identity.
  OR (
    r.child = 1
    AND (SELECT COUNT(*) FROM hermes_ref.parameters r2
         WHERE r2.child = 1 AND r2.module <=> r.module
           AND r2.parent_name <=> r.parent_name) > 1
    AND NOT EXISTS (
      SELECT 1 FROM hermes.parameters h
      WHERE h.module <=> r.module AND h.child = 1
        AND h.parent_name <=> r.parent_name
        AND h.parameter <=> r.parameter)
  );
SEED_SQL
    after_rows=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT COUNT(*) FROM hermes.parameters;" 2>/dev/null)
    if [[ "${after_rows:-0}" -gt "${before_rows:-0}" ]]; then
        log "  + seeded $(( after_rows - before_rows )) new parameters row(s) absent from the legacy DB"
        docker exec hermes_db_server mariadb -u root -N \
            -e "SELECT CONCAT('      + ', COALESCE(parent_name, parameter), IF(child=1, CONCAT(' = ', parameter), '')) FROM hermes.parameters WHERE id > ${max_id_before};" 2>/dev/null | tee -a "$LOG_FILE"
    else
        log "  + parameters seed rows already complete (nothing to add)"
    fi

    # Other seeded tables are REPORTED, not merged. Their natural keys differ
    # per table and a wrong guess would duplicate operator-edited rows, so this
    # surfaces the delta for a human instead of silently writing.
    # Exact COUNT(*) per table -- information_schema.table_rows is only an
    # estimate for InnoDB and would give misleading numbers here.
    log "  Seed-row delta in other config tables (informational -- NOT modified):"
    local seed_delta_found=0
    for t in parameters2 system_settings spam_settings ofelia_jobs encryption_settings \
             remoteauth_settings policy file_types malware_feeds dns_forwarders message_rules; do
        local ref_n cur_n
        ref_n=$(docker exec hermes_db_server mariadb -u root -N -e "SELECT COUNT(*) FROM hermes_ref.\`${t}\`;" 2>/dev/null || echo "")
        cur_n=$(docker exec hermes_db_server mariadb -u root -N -e "SELECT COUNT(*) FROM hermes.\`${t}\`;" 2>/dev/null || echo "")
        [[ -z "$ref_n" || -z "$cur_n" ]] && continue
        if [[ "$cur_n" -lt "$ref_n" ]]; then
            warn "      ${t}: baseline has ${ref_n} row(s), restored DB has ${cur_n}"
            seed_delta_found=1
        fi
    done
    if [[ "$seed_delta_found" == "0" ]]; then
        log "      no shortfall detected in the reported tables"
    else
        warn "  ^ these tables have fewer rows than the current baseline. Features"
        warn "    relying on the missing rows will be unconfigured until added by hand."
    fi

    # 5) Generic unpopulated-column check.
    #    Adding a column creates it NULL. If its correct value must be DERIVED
    #    from data the legacy DB already holds, schema-forward leaves it empty
    #    and the app silently reads nothing. parameters.parent_name was exactly
    #    this and it broke every postfix directive; it is explicitly backfilled
    #    in step 3, so it will not appear here any more.
    #
    #    Rather than enumerate such columns by name -- which only catches the
    #    ones someone thought of -- flag the whole CLASS: any column that the
    #    baseline populates but which is 100% NULL in the restored DB.
    #
    #    Scoped to tables the baseline actually seeds (read from the shipped
    #    SQL), so this never runs COUNT(*) over huge runtime tables like msgs.
    #    Report only -- backfilling requires knowing each column's derivation,
    #    which is a per-column judgement call, not something to guess at.
    local seeded_tables table_in_list
    seeded_tables=$(grep -oE '^INSERT (IGNORE )?INTO `[a-z_0-9]+`' "$install_sql" \
        | sed 's/.*`\(.*\)`/\1/' | sort -u)
    table_in_list=$(printf "'%s'," $seeded_tables | sed 's/,$//')

    if [[ -n "$table_in_list" ]]; then
        local null_checks null_hits
        # Pass 1: generate one probe per candidate column.
        null_checks=$(docker exec -i hermes_db_server mariadb -u root -N 2>/dev/null <<GEN_NULL_SQL
SELECT CONCAT(
  'SELECT CONCAT(''      ', c.TABLE_NAME, '.', c.COLUMN_NAME,
  ' (', LOWER(c.DATA_TYPE), ')'') FROM DUAL',
  ' WHERE (SELECT COUNT(*) FROM \`hermes\`.\`', c.TABLE_NAME, '\`) > 0',
  '   AND (SELECT COUNT(*) FROM \`hermes\`.\`', c.TABLE_NAME, '\` WHERE \`', c.COLUMN_NAME, '\` IS NOT NULL) = 0',
  '   AND (SELECT COUNT(*) FROM \`hermes_ref\`.\`', c.TABLE_NAME, '\` WHERE \`', c.COLUMN_NAME, '\` IS NOT NULL) > 0;')
FROM information_schema.COLUMNS c
WHERE c.TABLE_SCHEMA = 'hermes_ref'
  AND c.TABLE_NAME IN (${table_in_list})
  AND c.COLUMN_NAME <> 'id'
  AND EXISTS (SELECT 1 FROM information_schema.TABLES t
              WHERE t.TABLE_SCHEMA='hermes' AND t.TABLE_NAME=c.TABLE_NAME);
GEN_NULL_SQL
        )
        # Pass 2: run them.
        if [[ -n "$null_checks" ]]; then
            null_hits=$(printf '%s\n' "$null_checks" \
                | docker exec -i hermes_db_server mariadb -u root -N 2>/dev/null | grep -v '^$' || true)
            if [[ -n "$null_hits" ]]; then
                warn "  Columns the baseline populates but which are EMPTY in the restored DB:"
                printf '%s\n' "$null_hits" | tee -a "$LOG_FILE"
                warn "  ^ each is a column whose value could not simply be defaulted."
                warn "    Most are harmless (display-only). Any column the app FILTERS or"
                warn "    JOINS on must be populated or the query silently returns nothing."
            else
                log "  + no unpopulated baseline-derived columns detected"
            fi
        fi
    fi

    # 6) Verify no baseline columns remain missing.
    local remaining
    remaining=$(docker exec hermes_db_server mariadb -u root -N \
        -e "SELECT COUNT(*) FROM information_schema.columns r WHERE r.table_schema='hermes_ref' AND NOT EXISTS (SELECT 1 FROM information_schema.columns h WHERE h.table_schema='hermes' AND h.table_name=r.table_name AND h.column_name=r.column_name);" 2>/dev/null)
    docker exec hermes_db_server mariadb -u root -e "DROP DATABASE IF EXISTS hermes_ref;" >> "$LOG_FILE" 2>&1

    if [[ "${remaining:-1}" == "0" ]]; then
        log "Schema-forward complete: restored DB matches current baseline (0 missing columns)."
    else
        warn "Schema-forward incomplete: ${remaining} baseline column(s) still missing (see ${LOG_FILE})."
    fi
}

# ============================================================================
# PARSE ARGUMENTS
# ============================================================================

MODE=""            # system | archive | all  (empty -> derive from files / prompt)
ARCHIVE_FILE=""    # path to hermes-archive-<build>-...tar.gz (archive/all modes)

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Restores a legacy (build ${REQUIRED_BUILD:-240815}) Hermes SEG backup onto this
Docker host. The legacy backup comes in two files: a SYSTEM backup (databases +
configs) and an ARCHIVE backup (the email quarantine files).

Modes:
  --mode system         Restore the system backup only (default when only -B given)
  --mode archive        Restore the email archive only (no DB/config changes)
  --mode all            Restore system, then archive
  --archive-only        Shorthand for --mode archive
  (no mode + no backup)  Prompts interactively for what to restore

Files:
  -B <file>             System backup  (hermes-system-<build>-...tar.gz)
  --archive <file>      Archive backup (hermes-archive-<build>-...tar.gz)

Other:
  -R <pass>             MySQL root password (accepted for compatibility; root
                        auth to the Docker DB is via unix_socket)
  -D <dir>              Hermes Docker install root (default: auto/${HERMES_ROOT})
  -M <dir>              Data mount    (default: ${DATA_MOUNT})
  -A <dir>              Archive mount (default: ${ARCHIVE_MOUNT})
  -V <dir>              Vmail mount   (default: ${VMAIL_MOUNT})
  -h, --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -B)             BACKUP_FILE="$2";      shift 2 ;;
        -B*)            BACKUP_FILE="${1#-B}"; shift ;;
        --archive)      ARCHIVE_FILE="$2";     shift 2 ;;
        --archive=*)    ARCHIVE_FILE="${1#*=}"; shift ;;
        --archive-only) MODE="archive";        shift ;;
        --mode)         MODE="$2";             shift 2 ;;
        --mode=*)       MODE="${1#*=}";        shift ;;
        -R)             MYSQL_ROOT_PASS="$2";  shift 2 ;;
        -R*)            MYSQL_ROOT_PASS="${1#-R}"; shift ;;
        -D)             HERMES_ROOT="$2";      HERMES_ROOT_AUTODETECTED=0; shift 2 ;;
        -D*)            HERMES_ROOT="${1#-D}"; HERMES_ROOT_AUTODETECTED=0; shift ;;
        -M)             DATA_MOUNT="$2";       shift 2 ;;
        -A)             ARCHIVE_MOUNT="$2";    shift 2 ;;
        -V)             VMAIL_MOUNT="$2";      shift 2 ;;
        -h|--help)      usage; exit 0 ;;
        *)              echo "Unknown option: $1" >&2; usage; exit 1 ;;
    esac
done

# ============================================================================
# VALIDATE INPUTS
# ============================================================================

header "Hermes SEG Legacy to Docker Migration"

# Check root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root"
fi

# ----------------------------------------------------------------------------
# Validate a backup filename and enforce the supported source build + type.
# Legacy system_backup.sh names files: hermes-<type>-<build>-<MM-DD-YYYY>-<HHMM>.tar.gz
# This migration path is validated ONLY for build 240815 (the final legacy
# build): the schema-forward delta is calibrated to it, so other builds are
# rejected up front rather than silently producing a broken system.
# ----------------------------------------------------------------------------
REQUIRED_BUILD="240815"

check_backup_file() {  # <path> <expected-type: system|archive>
    local path="$1" want="$2" base type build
    [[ -f "$path" ]] || error "Backup file not found: ${path}"
    base=$(basename "$path")
    if [[ "$base" =~ ^hermes-(system|archive)-([0-9]{6})-([0-9]{2}-[0-9]{2}-[0-9]{4})-([0-9]{4})\.tar\.gz$ ]]; then
        type="${BASH_REMATCH[1]}"; build="${BASH_REMATCH[2]}"
    else
        error "Unrecognized backup filename: ${base}
       Expected: hermes-<system|archive>-<build>-<MM-DD-YYYY>-<HHMM>.tar.gz"
    fi
    [[ "$build" == "$REQUIRED_BUILD" ]] || error "Unsupported source build '${build}'. This migration supports ONLY build ${REQUIRED_BUILD}."
    [[ "$type" == "$want" ]] || error "Expected a '${want}' backup but '${base}' is a '${type}' backup."
}

# ---- Determine restore MODE (explicit flag / derived from files / prompt) ----
if [[ -n "$MODE" ]]; then
    case "$MODE" in
        system|archive|all) ;;
        *) error "Invalid --mode '${MODE}'. Use system, archive, or all." ;;
    esac
elif [[ -n "$BACKUP_FILE" && -n "$ARCHIVE_FILE" ]]; then
    MODE="all"
elif [[ -n "$BACKUP_FILE" ]]; then
    MODE="system"
elif [[ -n "$ARCHIVE_FILE" ]]; then
    MODE="archive"
else
    echo ""
    echo "What do you want to restore?"
    echo "  1) System   (databases + configs; brings the gateway up)"
    echo "  2) Archive  (email quarantine files only; no DB/config changes)"
    echo "  3) Both     (system, then archive)"
    echo ""
    read -p "Select [1/2/3]: " _sel
    case "$_sel" in
        1) MODE="system" ;;
        2) MODE="archive" ;;
        3) MODE="all" ;;
        *) error "Invalid selection." ;;
    esac
fi

# ---- Resolve + validate the file(s) the chosen mode needs ----
if [[ "$MODE" == "system" || "$MODE" == "all" ]]; then
    [[ -z "$BACKUP_FILE" ]] && read -p "Path to SYSTEM backup (hermes-system-...tar.gz): " BACKUP_FILE
    check_backup_file "$BACKUP_FILE" system
fi
if [[ "$MODE" == "archive" || "$MODE" == "all" ]]; then
    [[ -z "$ARCHIVE_FILE" ]] && read -p "Path to ARCHIVE backup (hermes-archive-...tar.gz): " ARCHIVE_FILE
    check_backup_file "$ARCHIVE_FILE" archive
fi

# No MySQL root password prompt: root auth to the Docker MariaDB is via
# unix_socket (docker exec hermes_db_server mariadb -u root, no -p), so the
# script never needs one. -R is still accepted for backward compatibility with
# existing runbooks, but its value is unused and deliberately never written
# anywhere. Prompting for it asked the operator to type a real credential that
# was then discarded.

# Validate Hermes root
if [[ -z "${HERMES_ROOT}" ]]; then
    error "Could not auto-detect the Hermes Docker install root: no docker-compose.yml found walking up from ${_SCRIPT_DIR}. Run this script from inside the install tree, or pass -D /path/to/install/root."
fi

if [[ ! -d "${HERMES_ROOT}" ]]; then
    if [[ "${HERMES_ROOT_AUTODETECTED}" == "0" ]]; then
        error "Hermes Docker root not found: ${HERMES_ROOT} (from -D)"
    fi
    error "Hermes Docker root not found: ${HERMES_ROOT}"
fi

if [[ ! -f "${HERMES_ROOT}/docker-compose.yml" ]]; then
    error "docker-compose.yml not found in ${HERMES_ROOT}"
fi

log "Restore mode:   ${MODE}"
[[ -n "$BACKUP_FILE"  ]] && log "System backup:  ${BACKUP_FILE}"
[[ -n "$ARCHIVE_FILE" ]] && log "Archive backup: ${ARCHIVE_FILE}"
log "Hermes root:    ${HERMES_ROOT}"
log "Archive mount:  ${ARCHIVE_MOUNT}"
log "Log file:       ${LOG_FILE}"

# ============================================================================
# ARCHIVE-ONLY MODE: lay down quarantine files, then exit (no DB/config touched)
# ============================================================================
if [[ "$MODE" == "archive" ]]; then
    echo ""
    echo -e "${YELLOW}Archive-only restore:${NC} extracts the email quarantine to"
    echo "  ${ARCHIVE_MOUNT}/amavis. It does NOT change any database or config,"
    echo "  so it is safe to run days after the system restore (minimum downtime)."
    echo ""
    read -p "Continue? (y/N): " CONFIRM
    [[ "$CONFIRM" =~ ^[Yy]$ ]] || { log "Cancelled by user"; exit 0; }
    restore_email_archive "$ARCHIVE_FILE"
    header "Archive Restore Complete"
    echo -e "${GREEN}Quarantine files restored to ${ARCHIVE_MOUNT}/amavis.${NC}"
    echo "Message bodies are now available in Message History (the metadata came"
    echo "in with the system restore). Log file: ${LOG_FILE}"
    exit 0
fi

# ============================================================================
# CONFIRM MIGRATION (system / all)
# ============================================================================

echo ""
echo -e "${YELLOW}WARNING: This ${MODE} restore will:${NC}"
echo "  1. Restore databases (hermes/djigzo/opendmarc/Syslog) + schema-forward"
echo "  2. Copy portable data (hermes.key, TLS certs, DKIM keys)"
echo "  3. Migrate Authelia users to LDAP (one-factor)"
echo "  4. Rewire host identity + re-render configs via system_rehost.sh"
[[ "$MODE" == "all" ]] && echo "  5. Restore the email archive (quarantine files)"
echo ""
echo -e "${YELLOW}This assumes Docker containers are RUNNING.${NC}"
echo ""
read -p "Continue with the ${MODE} restore? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    log "Migration cancelled by user"
    exit 0
fi

# ============================================================================
# CHECK DOCKER CONTAINERS
# ============================================================================

header "Checking Docker Containers"

# Check if MariaDB container is running
if ! docker ps --format '{{.Names}}' | grep -q "^hermes_db_server$"; then
    error "hermes_db_server container is not running. Start Docker stack first: docker compose up -d"
fi

# Check if we can connect to MariaDB.
# On Docker, root@localhost authenticates via unix_socket (as the container's
# OS root), NOT a password, so we run mariadb without -p. Passing -p makes it
# attempt password auth for root@localhost and fail with ERROR 1045. Note that
# `mysqladmin ping` reports "alive" even on auth failure, so it is NOT a valid
# auth check -- run a real query instead.
log "Testing MariaDB connection..."
if ! docker exec hermes_db_server mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; then
    error "Cannot connect to MariaDB as root via docker exec (unix_socket)."
fi
log "MariaDB connection successful"

# ============================================================================
# EXTRACT BACKUP
# ============================================================================

header "Extracting Legacy Backup"

mkdir -p "$TEMP_DIR"
log "Extracting to: ${TEMP_DIR}"

tar -xzf "${BACKUP_FILE}" -C "${TEMP_DIR}" >> "$LOG_FILE" 2>&1

# Verify extraction
if [[ ! -d "${TEMP_DIR}/opt/hermes" ]]; then
    error "Backup extraction failed - /opt/hermes not found in backup"
fi

log "Backup extracted successfully"

# List what was extracted
log "Contents extracted:"
ls -la "${TEMP_DIR}/" >> "$LOG_FILE" 2>&1

# ============================================================================
# RESTORE DATABASES
# ============================================================================

header "Restoring Legacy Databases"

# Database files should be in the root of the extracted archive (from dbbkup)
DB_DIR="${TEMP_DIR}"

# Find database dumps - they might be in root or in a dbbkup subdirectory
if [[ -f "${TEMP_DIR}/hermes.sql" ]]; then
    DB_DIR="${TEMP_DIR}"
elif [[ -f "${TEMP_DIR}/dbbkup/hermes.sql" ]]; then
    DB_DIR="${TEMP_DIR}/dbbkup"
else
    # Search for the SQL files
    HERMES_SQL=$(find "${TEMP_DIR}" -name "hermes.sql" -type f 2>/dev/null | head -1)
    if [[ -n "$HERMES_SQL" ]]; then
        DB_DIR=$(dirname "$HERMES_SQL")
    else
        error "Could not locate database dumps in backup"
    fi
fi

log "Database dumps found in: ${DB_DIR}"

# Restore Hermes database
if [[ -f "${DB_DIR}/hermes.sql" ]]; then
    log "Restoring hermes database..."
    docker exec -i hermes_db_server mariadb -u root < "${DB_DIR}/hermes.sql" >> "$LOG_FILE" 2>&1
    log "hermes database restored"
else
    warn "hermes.sql not found - skipping"
fi

# Restore Ciphermail database (djigzo)
if [[ -f "${DB_DIR}/djigzo.sql" ]]; then
    log "Restoring djigzo (Ciphermail) database..."
    docker exec -i hermes_db_server mariadb -u root < "${DB_DIR}/djigzo.sql" >> "$LOG_FILE" 2>&1
    log "djigzo database restored"
else
    warn "djigzo.sql not found - skipping"
fi

# Restore OpenDMARC database
if [[ -f "${DB_DIR}/opendmarc.sql" ]]; then
    log "Restoring opendmarc database..."
    docker exec -i hermes_db_server mariadb -u root < "${DB_DIR}/opendmarc.sql" >> "$LOG_FILE" 2>&1
    log "opendmarc database restored"
else
    warn "opendmarc.sql not found - skipping"
fi

# Restore Syslog database
if [[ -f "${DB_DIR}/Syslog.sql" ]]; then
    log "Restoring Syslog database..."
    docker exec -i hermes_db_server mariadb -u root < "${DB_DIR}/Syslog.sql" >> "$LOG_FILE" 2>&1
    log "Syslog database restored"
else
    warn "Syslog.sql not found - skipping"
fi

# ============================================================================
# SCHEMA FORWARD-MIGRATION
# ============================================================================
# Restoring the legacy hermes.sql reverts the `hermes` schema to the source
# build (240815), which lacks columns/tables the current Docker app expects
# (e.g. parameters.parent_name, recipients.auth_type). Bridge the schema forward
# to the current baseline. See apply_schema_forward() for details.
apply_schema_forward

# ============================================================================
# CREATE NEW DATABASES (Docker-only services)
# ============================================================================

header "Creating New Databases for Docker Services"

# Read credentials from secrets directory
SECRETS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/keys"
CREDS_DIR="${HERMES_ROOT}/config/hermes/opt/hermes/creds"

# Create Authelia database
log "Creating Authelia database..."
AUTHELIA_USER="authelia"
if [[ -f "${SECRETS_DIR}/authelia_username" ]]; then
    AUTHELIA_USER=$(cat "${SECRETS_DIR}/authelia_username")
fi

AUTHELIA_PASS=""
if [[ -f "${SECRETS_DIR}/authelia_password" ]]; then
    AUTHELIA_PASS=$(cat "${SECRETS_DIR}/authelia_password")
else
    # Generate a new password
    AUTHELIA_PASS=$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)
    echo -n "$AUTHELIA_PASS" > "${SECRETS_DIR}/authelia_password"
    chmod 600 "${SECRETS_DIR}/authelia_password"
    log "Generated new Authelia database password"
fi

docker exec hermes_db_server mariadb -u root -e "
    CREATE DATABASE IF NOT EXISTS authelia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
    CREATE USER IF NOT EXISTS '${AUTHELIA_USER}'@'%' IDENTIFIED BY '${AUTHELIA_PASS}';
    GRANT ALL PRIVILEGES ON authelia.* TO '${AUTHELIA_USER}'@'%';
" >> "$LOG_FILE" 2>&1
log "Authelia database created"

# Create Nextcloud database
log "Creating Nextcloud database..."
NEXTCLOUD_USER="nextcloud"
if [[ -f "${CREDS_DIR}/nextcloud_mysql_username" ]]; then
    NEXTCLOUD_USER=$(cat "${CREDS_DIR}/nextcloud_mysql_username")
fi

NEXTCLOUD_PASS=""
if [[ -f "${CREDS_DIR}/nextcloud_mysql_password" ]]; then
    NEXTCLOUD_PASS=$(cat "${CREDS_DIR}/nextcloud_mysql_password")
else
    # Generate a new password
    NEXTCLOUD_PASS=$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)
    echo -n "$NEXTCLOUD_PASS" > "${CREDS_DIR}/nextcloud_mysql_password"
    chmod 600 "${CREDS_DIR}/nextcloud_mysql_password"
    log "Generated new Nextcloud database password"
fi

docker exec hermes_db_server mariadb -u root -e "
    CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${NEXTCLOUD_USER}'@'%' IDENTIFIED BY '${NEXTCLOUD_PASS}';
    GRANT ALL PRIVILEGES ON nextcloud.* TO '${NEXTCLOUD_USER}'@'%';
" >> "$LOG_FILE" 2>&1
log "Nextcloud database created"

# Flush privileges
docker exec hermes_db_server mariadb -u root -e "FLUSH PRIVILEGES;" >> "$LOG_FILE" 2>&1

# ============================================================================
# COPY CONFIGURATION FILES
# ============================================================================

header "Copying Configuration Files"

# Map legacy paths to Docker paths
# /opt/hermes/ -> ./config/hermes/opt/hermes/
if [[ -d "${TEMP_DIR}/opt/hermes" ]]; then
    log "Copying /opt/hermes..."

    # Keys directory -- REQUIRED. This carries hermes.key, the symmetric key
    # Hermes uses to encrypt/decrypt secrets stored in the DB (relay-host
    # passwords, etc.). The restored `hermes` DB holds values encrypted with the
    # LEGACY key, so the legacy hermes.key MUST replace the fresh-install one or
    # those values become undecryptable. On a fresh install there is nothing yet
    # encrypted with the Docker key, so overwriting it is safe. Legacy relay
    # boxes have no LDAP/Authelia key files here, so Docker's own key files
    # (ldap_*_password_file, authelia_*) are not touched.
    if [[ -d "${TEMP_DIR}/opt/hermes/keys" ]]; then
        if [[ -d "${HERMES_ROOT}/config/hermes/opt/hermes/keys" ]]; then
            cp -a "${HERMES_ROOT}/config/hermes/opt/hermes/keys" "${HERMES_ROOT}/config/hermes/opt/hermes/keys.docker-backup"
        fi
        cp -a "${TEMP_DIR}/opt/hermes/keys/"* "${HERMES_ROOT}/config/hermes/opt/hermes/keys/" 2>/dev/null || true
        log "  keys copied (incl. hermes.key encryption key)"
    fi

    # Creds directory -- DELIBERATELY NOT copied. On a legacy box this holds only
    # the DB service credentials (hermes/ciphermail/opendmarc/syslog _username &
    # _password). The Docker stack generates its OWN randomized DB usernames and
    # passwords at install time; overwriting them with the legacy values breaks
    # every service's DB connection (the CFML app fails to log in, etc.). The
    # Docker credentials are the source of truth and must remain untouched.
    log "  skipping creds/ (Docker-managed DB credentials; legacy values would break DB auth)"

    # SSL certificates (portable)
    if [[ -d "${TEMP_DIR}/opt/hermes/ssl" ]]; then
        mkdir -p "${HERMES_ROOT}/config/hermes/opt/hermes/ssl"
        cp -a "${TEMP_DIR}/opt/hermes/ssl/"* "${HERMES_ROOT}/config/hermes/opt/hermes/ssl/" 2>/dev/null || true
        log "  ssl copied"
    fi

    # DKIM signing keys (portable) -- copy the private keys so outbound DKIM
    # keeps validating against the domains' published DNS records. We copy only
    # the key material, NOT the Docker-managed OpenDKIM tables (KeyTable /
    # SigningTable / TrustedHosts / ExemptDomains), which are regenerated from
    # the restored domains and must keep the Docker subnet in TrustedHosts.
    if [[ -d "${TEMP_DIR}/opt/hermes/dkim/keys" ]]; then
        mkdir -p "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/keys"
        cp -a "${TEMP_DIR}/opt/hermes/dkim/keys/"* "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/keys/" 2>/dev/null || true
        log "  dkim signing keys copied (OpenDKIM tables left Docker-managed)"
    elif [[ -d "${TEMP_DIR}/opt/hermes/dkim" ]]; then
        # Older layouts keep the key files directly under dkim/. Copy just the
        # key files (*.private / *.txt / *.pem), never the OpenDKIM table files.
        mkdir -p "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/keys"
        find "${TEMP_DIR}/opt/hermes/dkim" -maxdepth 1 -type f \
            \( -name '*.private' -o -name '*.key' -o -name '*.pem' -o -name '*.txt' \) \
            -exec cp -a {} "${HERMES_ROOT}/config/hermes/opt/hermes/dkim/keys/" \; 2>/dev/null || true
        log "  dkim key files copied from legacy dkim/ (OpenDKIM tables left Docker-managed)"
    fi

    log "/opt/hermes copied"
fi

# NOTE: legacy /etc/postfix and /etc/amavis are DELIBERATELY NOT copied.
# These are Docker-managed: the container's main.cf/master.cf/mysql-*.cf carry
# Docker-specific values (DB host = hermes_db_server, container-generated DB
# password, Docker paths, the Docker IPv4 subnet in mynetworks/@inet_acl). The
# legacy bare-metal versions use 127.0.0.1, the legacy DB password, and legacy
# paths -- copying them over the Docker configs breaks mail flow (Postfix could
# not reach the DB after the first test run). The operational settings the admin
# actually configured (domains, relay hosts, message size, TLS, spam policy)
# live in the restored `hermes` DB and are re-rendered into these config files
# by the app's config-regeneration flow (Console/Antispam "Save & Apply"), which
# should be run once after migration. See the post-migration steps below.
log "Skipping legacy /etc/postfix and /etc/amavis (Docker-managed; regenerated from the restored DB)"

# /etc/letsencrypt/ -> ./config/certbot/conf/
if [[ -d "${TEMP_DIR}/etc/letsencrypt" ]]; then
    log "Copying /etc/letsencrypt..."
    mkdir -p "${HERMES_ROOT}/config/certbot/conf"
    cp -a "${TEMP_DIR}/etc/letsencrypt/"* "${HERMES_ROOT}/config/certbot/conf/" 2>/dev/null || true
    log "/etc/letsencrypt copied"
fi

# /var/www/html/ -> ./config/hermes/var/www/html/
# Note: We DON'T copy the web files - Docker has its own version
# Only copy custom files if they exist
if [[ -d "${TEMP_DIR}/var/www/html/custom" ]]; then
    log "Copying custom web files..."
    mkdir -p "${HERMES_ROOT}/config/hermes/var/www/html/custom"
    cp -a "${TEMP_DIR}/var/www/html/custom/"* "${HERMES_ROOT}/config/hermes/var/www/html/custom/" 2>/dev/null || true
fi

# NOTE: legacy /etc/spamassassin and /etc/clamav are DELIBERATELY NOT copied.
# ClamAV signatures are downloaded/managed inside the Docker image (freshclam);
# SpamAssassin rules are Docker-managed and updated via sa-update. Copying the
# legacy bare-metal versions provides no benefit and risks path/version skew.
log "Skipping legacy /etc/spamassassin and /etc/clamav (Docker-managed)"

# ============================================================================
# MIGRATE AUTHELIA USERS TO LDAP
# ============================================================================

header "Migrating Authelia Users to LDAP"

echo ""
echo -e "${YELLOW}IMPORTANT - Two-Factor Authentication Devices:${NC}"
echo ""
echo "  The legacy system used SQLite for Authelia storage."
echo "  Docker uses MySQL. Migrating storage backends affects 2FA devices:"
echo ""
echo "  | 2FA Method  | Storage Location  | Preserved? |"
echo "  |-------------|-------------------|------------|"
echo "  | Duo Push    | Duo cloud servers | YES        |"
echo "  | TOTP        | Authelia database | NO         |"
echo "  | WebAuthn    | Authelia database | NO         |"
echo ""
echo "  Users with TOTP (Google Authenticator, etc.) or WebAuthn (hardware keys)"
echo "  will need to re-register their devices after migration."
echo ""
echo "  Duo Push users are not affected - their enrollment is stored on Duo's servers."
echo ""

AUTHELIA_USERS_FILE="${TEMP_DIR}/etc/authelia/users_database.yml"

# Legacy Authelia users_database.yml entries are the admin-console users. Each
# one is recreated as an inetOrgPerson under ou=users and placed in cn=admins +
# cn=one_factor. Their argon2id password hash is reused directly (OpenLDAP's
# argon2 overlay accepts it with a {ARGON2} prefix), so passwords keep working.
#
# NOTE: every migrated account is placed in ONE-FACTOR by design (see the
# prominent warning at the end) -- the operator reconfigures 2FA afterwards.
if [[ ! -f "$AUTHELIA_USERS_FILE" ]]; then
    log "No Authelia users file found in backup - skipping user migration"
elif ! docker ps --format '{{.Names}}' | grep -q "^hermes_ldap$"; then
    warn "hermes_ldap container is not running - skipping Authelia user migration"
elif ! command -v python3 &>/dev/null; then
    warn "python3 not available - cannot parse users_database.yml; skipping user migration"
else
    log "Found Authelia users file: ${AUTHELIA_USERS_FILE}"

    # LDAP connection params from .env / Docker secret.
    LDAP_BASE_DN=$(grep -E '^LDAP_BASE_DN=' "${HERMES_ROOT}/.env" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '"' || true)
    LDAP_BASE_DN=${LDAP_BASE_DN:-dc=hermes,dc=local}
    LDAP_ADMIN_USERNAME=$(grep -E '^LDAP_ADMIN_USERNAME=' "${HERMES_ROOT}/.env" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '"' || true)
    LDAP_ADMIN_USERNAME=${LDAP_ADMIN_USERNAME:-hermes-ldap-admin}
    LDAP_ADMIN_DN="cn=${LDAP_ADMIN_USERNAME},${LDAP_BASE_DN}"
    LDAP_ADMIN_PW=$(cat "${HERMES_ROOT}/config/hermes/opt/hermes/keys/ldap_admin_password_file" 2>/dev/null || true)

    if [[ -z "$LDAP_ADMIN_PW" ]]; then
        warn "Could not read LDAP admin password (keys/ldap_admin_password_file); skipping user migration"
    elif ! docker exec hermes_ldap ldapsearch -x -H ldap://localhost:389 -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PW" -b "$LDAP_BASE_DN" -s base dn >/dev/null 2>&1; then
        warn "LDAP admin bind failed as ${LDAP_ADMIN_DN}; skipping user migration"
    else
        au_created=0; au_skipped=0; au_failed=0
        while IFS=$'\t' read -r au_uid au_dname au_email au_hash; do
            [[ -z "$au_uid" ]] && continue
            au_user_dn="cn=${au_uid},ou=users,${LDAP_BASE_DN}"

            # Skip if the user already exists (idempotent re-runs).
            if docker exec hermes_ldap ldapsearch -x -H ldap://localhost:389 -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PW" -b "$au_user_dn" -s base dn >/dev/null 2>&1; then
                warn "  user already exists, skipping: ${au_uid}"
                au_skipped=$((au_skipped+1)); continue
            fi

            # inetOrgPerson requires sn; derive it from the display name.
            [[ -z "$au_dname" ]] && au_dname="$au_uid"
            [[ -z "$au_email" ]] && au_email="${au_uid}@localhost"
            au_sn=$(printf '%s' "$au_dname" | awk '{print $NF}'); [[ -z "$au_sn" ]] && au_sn="$au_uid"

            if printf 'dn: %s\nobjectClass: inetOrgPerson\ncn: %s\nsn: %s\nuid: %s\ndisplayName: %s\nmail: %s\nuserPassword: {ARGON2}%s\n' \
                    "$au_user_dn" "$au_uid" "$au_sn" "$au_uid" "$au_dname" "$au_email" "$au_hash" \
                | docker exec -i hermes_ldap ldapadd -x -H ldap://localhost:389 -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PW" >>"$LOG_FILE" 2>&1; then
                for au_grp in admins one_factor; do
                    printf 'dn: cn=%s,ou=groups,%s\nchangetype: modify\nadd: member\nmember: %s\n' \
                            "$au_grp" "$LDAP_BASE_DN" "$au_user_dn" \
                        | docker exec -i hermes_ldap ldapmodify -x -H ldap://localhost:389 -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PW" >>"$LOG_FILE" 2>&1 || true
                done
                log "  migrated user: ${au_uid}  (cn=admins, cn=one_factor)"
                au_created=$((au_created+1))
            else
                warn "  FAILED to create LDAP entry for: ${au_uid} (see ${LOG_FILE})"
                au_failed=$((au_failed+1))
            fi
        done < <(python3 - "$AUTHELIA_USERS_FILE" <<'PYEOF'
import sys, yaml
try:
    with open(sys.argv[1]) as f:
        data = yaml.safe_load(f) or {}
    for username, info in (data.get('users') or {}).items():
        info = info or {}
        dn = (info.get('displayname') or '').replace('\t', ' ').strip()
        email = (info.get('email') or '').replace('\t', ' ').strip()
        pw = (info.get('password') or '').replace('\t', ' ').strip()
        print(f"{username}\t{dn}\t{email}\t{pw}")
except Exception as e:
    sys.stderr.write(f"parse error: {e}\n")
PYEOF
        )
        log "Authelia -> LDAP migration: ${au_created} created, ${au_skipped} skipped, ${au_failed} failed"

        echo ""
        echo -e "${YELLOW}============================================================${NC}"
        echo -e "${YELLOW}  IMPORTANT: ALL MIGRATED ACCOUNTS ARE ONE-FACTOR${NC}"
        echo -e "${YELLOW}============================================================${NC}"
        echo -e "${YELLOW}  Every migrated admin was placed in cn=one_factor, so login${NC}"
        echo -e "${YELLOW}  currently requires ONLY a password. Legacy TOTP / WebAuthn${NC}"
        echo -e "${YELLOW}  devices were NOT carried over (Authelia SQLite -> MySQL).${NC}"
        echo ""
        echo -e "${YELLOW}  Re-enable 2FA for each admin after migration:${NC}"
        echo -e "${YELLOW}    - move the account from cn=one_factor to cn=two_factor${NC}"
        echo -e "${YELLOW}    - have them re-enroll an authenticator on next login${NC}"
        echo -e "${YELLOW}============================================================${NC}"
        echo ""
    fi
fi

# ============================================================================
# SET PERMISSIONS
# ============================================================================

header "Setting Permissions"

# Set ownership for config directories
chown -R root:root "${HERMES_ROOT}/config/postfix-dkim/etc/postfix/" 2>/dev/null || true
chown -R root:root "${HERMES_ROOT}/config/mail_filter/etc/amavis/" 2>/dev/null || true
chmod 600 "${HERMES_ROOT}/config/hermes/opt/hermes/keys/"* 2>/dev/null || true
chmod 600 "${HERMES_ROOT}/config/hermes/opt/hermes/creds/"* 2>/dev/null || true

log "Permissions set"

# NOTE: we deliberately do NOT write ${MYSQL_ROOT_PASS} to
# creds/mysql_root_password. Root authenticates to the Docker MariaDB via
# unix_socket (docker exec), so the file is not needed for auth, and the Docker
# install already generated it -- overwriting it with the operator-supplied -R
# value would clobber a Docker-managed credential (same class of bug as the
# creds/ copy above).

# ============================================================================
# REWIRE HOST IDENTITY (system_rehost.sh)
# ============================================================================
# The restored database carries the LEGACY host's identity (server_ip,
# console.host, Postfix myhostname/myorigin, nginx server_name, Authelia cookie
# domain). system_rehost.sh rewrites those to THIS Docker host and re-renders
# the postfix/amavis/authelia/nginx/mailname configs from the DB, then restarts
# the affected containers -- the same tool the cross-host DR restore uses.
#
# --force is required: after a cross-host restore the DB holds the source
# identity while .env may already be correct, which rehost's normal no-op check
# would otherwise skip. It runs interactively so the operator confirms (or
# overrides) the detected target IP / hostname / console address.
REHOST="${HERMES_ROOT}/scripts/system_rehost.sh"
if [[ -x "$REHOST" ]]; then
    header "Rewiring Host Identity"
    echo "The restored database still carries the legacy host's identity."
    echo "system_rehost.sh will rewrite it to THIS Docker host and re-render the"
    echo "postfix / amavis / authelia / nginx configs, then restart those services."
    echo ""
    read -p "Run host rewiring now (recommended)? (Y/n): " DO_REHOST
    if [[ ! "$DO_REHOST" =~ ^[Nn]$ ]]; then
        "$REHOST" --force || warn "system_rehost.sh reported errors -- review its log and re-run if needed."
    else
        warn "Skipped host rewiring. Run '${REHOST} --force' before using the system."
    fi
else
    warn "system_rehost.sh not found at ${REHOST} -- rewire host identity manually (see checklist)."
fi

# ============================================================================
# REBUILD POSTFIX LOOKUP TABLES (postmap the .db hashmaps)
# ============================================================================
# Postfix hash: maps need a compiled .db built by postmap. The install script
# only touches EMPTY source stubs; the .db is built lazily the first time an
# admin saves the matching UI page (which regenerates the source from the DB
# and runs postmap). A migrated admin skips those saves -- the config is
# already in the restored DB -- so any hash: map used in smtpd_*_restrictions
# has no .db and smtpd 451-rejects every message with e.g.:
#     open database /etc/postfix/amavis_senderbypass.db: No such file or directory
# The container entrypoint does not postmap either, so a restart won't fix it.
# Build every lookup table's .db now, from whatever source exists (empty source
# -> empty .db, which matches nothing and is the correct default). This is the
# same map list the install script stubs. Runs AFTER rehost so it postmaps the
# final rendered sources.
header "Rebuilding Postfix Lookup Tables"
# Discover EXACTLY the hash: maps the live config references, rather than
# hardcoding a list. Only these need a compiled .db; postmapping unrelated
# files is wrong -- e.g. relay_domains is a bare-domain list (not hash:) and
# aliases is sendmail-format (needs postalias, not postmap). The rendered set
# also varies by topology (relay / mailbox / hybrid), so read it from the
# actual main.cf + master.cf in the container.
if docker exec hermes_postfix_dkim true 2>/dev/null; then
    hash_maps=""
    hash_maps=$(docker exec hermes_postfix_dkim sh -c \
        'cat /etc/postfix/main.cf /etc/postfix/master.cf 2>/dev/null' 2>/dev/null \
        | grep -oE 'hash:/etc/postfix/[a-zA-Z0-9_]+' \
        | sed 's#hash:/etc/postfix/##' | sort -u)
    if [[ -z "$hash_maps" ]]; then
        warn "  no hash: maps found in the live postfix config -- nothing to postmap"
    else
        built=0 total=0
        for m in $hash_maps; do
            total=$((total+1))
            # aliases uses sendmail 'name: value' format -> postalias, not postmap.
            # Ensure the source exists first so smtpd never hits a missing map.
            tool="postmap"
            [[ "$m" == "aliases" ]] && tool="postalias"
            if docker exec hermes_postfix_dkim sh -c \
                 "touch /etc/postfix/${m} && /usr/sbin/${tool} /etc/postfix/${m}" >> "$LOG_FILE" 2>&1; then
                built=$((built+1))
            else
                warn "  ${tool} failed for ${m} (see ${LOG_FILE})"
            fi
        done
        docker exec hermes_postfix_dkim /usr/sbin/postfix reload >> "$LOG_FILE" 2>&1 || \
            warn "  postfix reload reported errors (see ${LOG_FILE})"
        log "  + built ${built}/${total} live lookup-table .db file(s) [${hash_maps//$'\n'/ }] and reloaded postfix"
    fi
else
    warn "hermes_postfix_dkim not reachable -- skipped postmap. If mail is rejected with"
    warn "  'open database /etc/postfix/<map>.db: No such file', run postmap by hand."
fi

# ============================================================================
# SUMMARY
# ============================================================================

header "Migration Complete"

echo ""
echo -e "${GREEN}Migration completed successfully!${NC}"
echo ""
echo "Summary:"
echo "  - Databases restored: hermes (+ schema-forwarded), djigzo, opendmarc, Syslog"
echo "  - New databases created: authelia, nextcloud"
echo "  - Portable data copied: hermes.key, TLS certs, DKIM signing keys"
echo "  - Authelia users migrated to LDAP (one-factor)"
echo "  - Docker-managed configs (postfix/amavis/creds) intentionally NOT copied"
echo "  - Host identity rewired + postfix/amavis/authelia/nginx re-rendered by"
echo "    system_rehost.sh (unless you skipped that step above)"
echo ""
echo -e "${YELLOW}REQUIRED post-migration steps -- the system is NOT fully configured yet.${NC}"
echo "Follow the checklist -- online (no repo access needed):"
echo "  https://docs.deeztek.com/books/installation-reference/page/post-migration-checklist-legacy-docker"
echo "Offline copy: ${HERMES_ROOT}/docs/install/legacy-to-docker-post-migration.md"
echo ""
echo "  1. Regenerate mail auth. In the admin console, under Content Checks:"
echo "       Content Checks -> SPF Settings    -> Save & Apply Settings"
echo "       Content Checks -> DKIM Settings   -> Save & Apply Settings"
echo "       Content Checks -> DMARC Settings  -> Save & Apply Settings"
echo "  2. Reconfigure admin 2FA (all migrated admins are ONE-FACTOR; see warning above)"
echo "  3. Reactivate the Pro license (UUID changed on the new host -- contact support"
echo "     with the serial to deactivate/reactivate)"
echo "  4. Verify Relay Networks (mynetworks) + TLS cert selection; then send a"
echo "     test message inbound and outbound (check delivery, DKIM, spam, TLS)"
if [[ "$MODE" == "all" ]]; then
    echo "  5. Email archive -- restoring automatically once this checklist prints."
    echo "     You do NOT have to wait for it; see the notice below."
else
    echo "  5. (Deferred) Restore the email archive: run this script with the"
    echo "     hermes-archive-<build>-...tar.gz backup, or answer the prompt below"
fi
echo ""
echo -e "${YELLOW}NOTE:${NC} if you SKIPPED host rewiring, also run:"
echo "  ${HERMES_ROOT}/scripts/system_rehost.sh --force"
echo "  (or do Console Settings + Perimeter Checks + Antispam Save & Apply manually)"
echo ""
echo "Log file: ${LOG_FILE}"
echo ""

# ============================================================================
# ARCHIVE RESTORE (only in 'all' mode -- 'archive' mode exited earlier)
# ============================================================================
# In 'all' mode the archive backup was validated up front, so restore it now
# after the system is up. For 'system' mode we skip it; the operator restores
# the archive later with:  migrate_legacy_to_docker.sh --archive-only --archive <file>
if [[ "$MODE" == "all" ]]; then
    # The system half is finished and the stack is serving. The archive restore
    # is a bulk file extract onto the Archive tier -- it touches NO database and
    # NO config, so the operator can work through the checklist in parallel
    # instead of watching a multi-hour tar run. Say so explicitly: without this
    # the script just goes quiet and looks hung.
    echo ""
    echo -e "${GREEN}============================================================${NC}"
    echo -e "${GREEN}  SYSTEM MIGRATION DONE -- SAFE TO LOG IN NOW${NC}"
    echo -e "${GREEN}============================================================${NC}"
    echo ""
    echo "The gateway is up and serving. Start the checklist above NOW in a"
    echo "browser / second SSH session -- do not wait for the archive."
    echo ""
    echo "The archive restore below only lays down quarantine FILES on the"
    echo "Archive tier. It touches no database and no configuration, so it"
    echo "cannot conflict with the settings changes you make while it runs."
    echo ""
    echo "While it runs:"
    echo "  - Mail flow, admin console and user portal all work normally."
    echo "  - Quarantine entries already appear in the UI (their metadata came"
    echo "    in with the system restore), but older messages are not openable"
    echo "    until their files land. This resolves as the restore progresses."
    echo "  - Leave this script running to completion. It can take hours on a"
    echo "    large quarantine; interrupting it leaves the archive incomplete"
    echo "    (re-runnable later with --archive-only)."
    echo ""
    restore_email_archive "$ARCHIVE_FILE"
else
    echo ""
    echo "Email archive NOT restored (system-only). To restore it later:"
    echo "  ${HERMES_ROOT}/scripts/migrate_legacy_to_docker.sh --archive-only \\"
    echo "      --archive /path/to/hermes-archive-${REQUIRED_BUILD}-...tar.gz"
fi

echo ""
log "Migration script completed"
