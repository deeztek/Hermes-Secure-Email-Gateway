#!/usr/bin/env bash
#
# audit_legacy_migration.sh -- READ-ONLY check of a legacy -> Docker migration
#
# Compares the legacy system backup that was migrated against this Docker
# install and reports what did not come across:
#
#   1. Files   legacy /opt/hermes, /etc/postfix, /etc/amavis,
#              /etc/spamassassin, /etc/opendmarc and /etc/letsencrypt
#              against their Docker locations under config/
#   2. Cron    legacy /etc/cron.d jobs, for review (nothing replaces them
#              automatically)
#   3. Tables  tables in the legacy hermes / djigzo / opendmarc dumps that the
#              live database lacks
#   4. Rows    tables whose live row count is below the legacy dump's
#              (mail log tables skipped: they are pruned by design)
#   5. Columns live NOT NULL columns without a default that the Docker
#              baseline does not define; inserts that omit them fail
#              (the user_settings.id case, #362)
#
# It writes nothing: the backup is read with tar -O (streamed, never
# extracted), the database only with SELECT. Temporary lists go to a
# private directory under /tmp that is removed on exit.
#
# Usage (from anywhere; the install directory is found automatically):
#   sudo scripts/audit_legacy_migration.sh -B /path/to/hermes-system-<build>-<date>.tar.gz
#
# Each pass reads the whole backup, so a large backup takes a few minutes.

set -uo pipefail
export LC_ALL=C

usage() {
    echo "Usage: $0 -B <legacy hermes-system-*.tar.gz> [-R <MariaDB root password>]"
    echo "  -R is only needed if 'docker exec hermes_db_server mariadb -u root' does not work as is."
    exit 2
}

BACKUP=""
ROOTPW=""
while getopts "B:R:h" opt; do
    case "$opt" in
        B) BACKUP="$OPTARG" ;;
        R) ROOTPW="$OPTARG" ;;
        *) usage ;;
    esac
done
[[ -n "$BACKUP" ]] || usage
[[ -f "$BACKUP" ]] || { echo "ERROR: backup not found: $BACKUP" >&2; exit 2; }

# Self-locate the install root (walk up to docker-compose.yml).
HERMES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while [[ "$HERMES_ROOT" != "/" && ! -f "$HERMES_ROOT/docker-compose.yml" ]]; do
    HERMES_ROOT="$(dirname "$HERMES_ROOT")"
done
[[ -f "$HERMES_ROOT/docker-compose.yml" ]] || { echo "ERROR: could not find the install directory" >&2; exit 2; }

BASELINE="$HERMES_ROOT/config/database/hermes_install.sql"
WORK="$(mktemp -d /tmp/hermes-audit.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

FINDINGS=0
section() { echo; echo "=== $1 ==="; }
finding() { FINDINGS=$((FINDINGS + 1)); echo "  [!] $*"; }
info()    { echo "      $*"; }

sql() {
    # $1 = database, $2 = query. Tab-separated, no header.
    if [[ -n "$ROOTPW" ]]; then
        docker exec -i hermes_db_server mariadb -u root -p"$ROOTPW" -N -B "$1" -e "$2"
    else
        docker exec -i hermes_db_server mariadb -u root -N -B "$1" -e "$2"
    fi
}

echo "Hermes legacy migration audit (read-only)"
echo "Install directory: $HERMES_ROOT"
echo "Legacy backup:     $BACKUP"

# ---------------------------------------------------------------- listing
echo
echo "Listing the backup (one pass over the whole file)..."
tar -tzf "$BACKUP" > "$WORK/list" 2>/dev/null || { echo "ERROR: cannot read $BACKUP" >&2; exit 2; }
sed -i 's#^\./##' "$WORK/list"

# ---------------------------------------------------------------- 1. files
section "1. Files present in the legacy backup but missing here"
info "Folders Docker ships or regenerates itself (tmp, scripts, updates, schedule,"
info "conf_files, templates) and backup/editor leftovers are not compared."

# legacy prefix | Docker host path (relative to the install directory)
MAPS="opt/hermes/|config/hermes/opt/hermes/
etc/postfix/|config/postfix-dkim/etc/postfix/
etc/amavis/|config/mail_filter/etc/amavis/
etc/spamassassin/|config/mail_filter/etc/spamassassin/
etc/opendmarc/|config/opendmarc/etc/opendmarc/
etc/letsencrypt/|config/certbot/conf/"

SKIP_RE='^opt/hermes/(tmp|scripts|updates|schedule|conf_files|templates)/|(\.BACKUP|\.bak|\.old|\.orig|~|\.swp|\.pre-[^/]*)$'

any_files=0
while IFS='|' read -r legacy docker_rel; do
    [[ -n "$legacy" ]] || continue
    grep "^${legacy}" "$WORK/list" | grep -v '/$' | grep -Ev "$SKIP_RE" > "$WORK/f_legacy" || true
    [[ -s "$WORK/f_legacy" ]] || continue
    : > "$WORK/f_missing"
    while IFS= read -r f; do
        rel="${f#"$legacy"}"
        [[ -e "$HERMES_ROOT/$docker_rel$rel" ]] || echo "$rel" >> "$WORK/f_missing"
    done < "$WORK/f_legacy"
    if [[ -s "$WORK/f_missing" ]]; then
        any_files=1
        n=$(wc -l < "$WORK/f_missing")
        finding "/$legacy -> $docker_rel: $n of $(wc -l < "$WORK/f_legacy") legacy file(s) missing"
        # Group by first folder so one missing tree reads as one line.
        awk -F/ '{ k = (NF > 1) ? $1 "/" : $1; c[k]++; if (!(k in ex)) ex[k] = $0 }
                 END { for (k in c) printf "%6d  %-40s e.g. %s\n", c[k], k, ex[k] }' "$WORK/f_missing" \
            | sort -rn | head -25 | sed 's/^/      /'
    fi
done <<< "$MAPS"
[[ $any_files -eq 1 ]] || info "None."
info "Not every missing file matters: Docker generates some of these itself"
info "(for example Postfix .db maps and default configs). Review the folders."

# ---------------------------------------------------------------- 2. cron
section "2. Legacy cron jobs (/etc/cron.d)"
grep '^etc/cron.d/.' "$WORK/list" | grep -v '/$' > "$WORK/cron" || true
if [[ -s "$WORK/cron" ]]; then
    while IFS= read -r f; do
        info "--- /$f"
        tar -xzOf "$BACKUP" "$f" "./$f" 2>/dev/null | grep -Ev '^\s*(#|$)' | sed 's/^/        /' | head -10
    done < "$WORK/cron"
    info "Docker runs scheduled work through Ofelia and host cron; check each job"
    info "above has an equivalent or is no longer needed."
else
    info "None in the backup."
fi

# ---------------------------------------------------------------- dumps
# Stream one dump and record, per table: legacy row count (tuples in its
# INSERT statements) and whether it was created. Strings containing "),("
# can overcount slightly; the comparison only flags shortfalls.
parse_dump() {
    local member="$1" out="$2"
    tar -xzOf "$BACKUP" "$member" "./$member" 2>/dev/null | awk '
        /^CREATE TABLE `/ { split($0, a, "`"); t = a[2]; created[t] = 1; if (!(t in rows)) rows[t] = 0 }
        /^INSERT INTO `/  { split($0, a, "`"); t = a[2]; n = gsub(/\),\(/, "&"); rows[t] += n + 1 }
        END { for (t in created) print t "\t" rows[t] }' > "$out"
}

# ---------------------------------------------------------------- 3 + 4
section "3. Tables in the legacy dumps missing from the live databases"
for db in hermes djigzo opendmarc; do
    if ! grep -qx "${db}.sql" "$WORK/list"; then
        info "$db: no ${db}.sql in the backup, skipped."
        continue
    fi
    echo "  Reading ${db}.sql from the backup..."
    parse_dump "${db}.sql" "$WORK/dump_$db"
    if ! sql "$db" "SELECT table_name FROM information_schema.tables WHERE table_schema='$db'" > "$WORK/live_$db" 2>"$WORK/err"; then
        finding "$db: cannot query the live database ($(head -1 "$WORK/err"))"
        continue
    fi
    missing=$(cut -f1 "$WORK/dump_$db" | sort | comm -23 - <(sort "$WORK/live_$db"))
    if [[ -n "$missing" ]]; then
        while IFS= read -r t; do finding "$db.$t exists in the legacy dump but not here"; done <<< "$missing"
    else
        info "$db: every legacy table is present."
    fi
done

section "4. Tables with fewer rows here than in the legacy dump"
info "Mail logs (msgs, msgrcpt, maddr, quarantine) and the Syslog database are"
info "skipped: they are pruned by retention. A shortfall elsewhere means data"
info "was not restored or was replaced by install defaults."
SKIP_TABLES=" msgs msgrcpt maddr quarantine "
any_rows=0
for db in hermes djigzo opendmarc; do
    [[ -s "$WORK/dump_$db" ]] || continue
    while IFS=$'\t' read -r t legacy_rows; do
        [[ "$legacy_rows" -gt 0 ]] || continue
        [[ "$db" == "hermes" && "$SKIP_TABLES" == *" $t "* ]] && continue
        grep -qx "$t" "$WORK/live_$db" || continue   # reported in section 3
        live_rows=$(sql "$db" "SELECT COUNT(*) FROM \`$t\`" 2>/dev/null) || continue
        if [[ "$live_rows" -lt "$legacy_rows" ]]; then
            any_rows=1
            finding "$db.$t: legacy $legacy_rows row(s), here $live_rows"
        fi
    done < "$WORK/dump_$db"
done
[[ $any_rows -eq 1 ]] || info "None."

# ---------------------------------------------------------------- 5. columns
section "5. Live columns that block inserts and are not in the Docker baseline"
if [[ -f "$BASELINE" ]]; then
    awk '
        /^CREATE TABLE (IF NOT EXISTS )?`/ { split($0, a, "`"); t = a[2]; next }
        t != "" && /^\) / { t = ""; next }
        t != "" && /^  `/ { split($0, a, "`"); print t "." a[2] }' "$BASELINE" | sort -u > "$WORK/baseline_cols"
    sql hermes "SELECT CONCAT(table_name, '.', column_name) FROM information_schema.columns
                WHERE table_schema='hermes' AND is_nullable='NO' AND column_default IS NULL
                AND extra NOT LIKE '%auto_increment%'" 2>/dev/null | sort -u > "$WORK/strict_cols"
    # Only tables the baseline defines: tables it does not (unused legacy
    # leftovers, views) are not written by Docker code.
    cut -d. -f1 "$WORK/baseline_cols" | sort -u > "$WORK/baseline_tables"
    leftovers=$(comm -23 "$WORK/strict_cols" "$WORK/baseline_cols" \
        | awk -F. 'NR==FNR { bt[$1] = 1; next } ($1 in bt)' "$WORK/baseline_tables" -)
    if [[ -n "$leftovers" ]]; then
        while IFS= read -r c; do finding "hermes.$c is NOT NULL without a default and unknown to Docker; inserts that omit it fail"; done <<< "$leftovers"
    else
        info "None."
    fi
else
    info "Baseline $BASELINE not found, skipped."
fi

# ---------------------------------------------------------------- summary
echo
if [[ $FINDINGS -eq 0 ]]; then
    echo "Done: nothing found."
else
    echo "Done: $FINDINGS finding(s) marked [!] above. Nothing was changed."
fi
