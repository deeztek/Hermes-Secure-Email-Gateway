#!/usr/bin/env bash
# ============================================================================
# check_ofelia_seed_drift.sh — keep the shipped Ofelia schedule honest
# ============================================================================
#
# config/ofelia/config.ini is a GENERATED artifact that is nonetheless tracked
# in this repository, because docker-compose bind-mounts ./config/ofelia onto
# /etc/ofelia and hermes_ofelia needs a valid file at first container start --
# before the database and CFML app exist to render one from.
#
# Shipping that file was never the problem. Nothing keeping it in sync WAS:
# it was committed at v260612 as a snapshot from one machine and then never
# updated, so every install ran a job list that predated four of the ten
# seeded jobs (including the ClamAV third-party malware-feed refresh) and
# still pointed the update check at a script removed at #218. See #288.
#
# This check renders what admin/2/inc/ofelia_generate_config.cfm WOULD produce
# from the ofelia_jobs seed rows in config/database/hermes_install.sql, and
# diffs it against the shipped file. The tracked copy stops being a source of
# truth and becomes a verified artifact.
#
# Layered with, not instead of:
#   - runtime correctness  -> orchestrator phase 4 renders from the live DB
#   - runtime detection    -> hermes_smoke_test.sh fails on divergence
#   - commit-time          -> this
#
# Usage:  ./scripts/check_ofelia_seed_drift.sh
# Exit:   0 = in sync, 1 = drift (diff printed), 2 = could not run
# ============================================================================

set -euo pipefail

# Self-locating: walk up from this script until docker-compose.yml is found.
# Depth-independent, survives the script moving in the tree.
find_repo_root() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/docker-compose.yml" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

REPO_ROOT="$(find_repo_root)" || { echo "ERROR: could not locate repo root (no docker-compose.yml above this script)" >&2; exit 2; }

SEED_SQL="${REPO_ROOT}/config/database/hermes_install.sql"
SHIPPED_INI="${REPO_ROOT}/config/ofelia/config.ini"

[[ -f "$SEED_SQL" ]]    || { echo "ERROR: missing $SEED_SQL" >&2; exit 2; }
[[ -f "$SHIPPED_INI" ]] || { echo "ERROR: missing $SHIPPED_INI" >&2; exit 2; }
command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 required" >&2; exit 2; }

EXPECTED="$(mktemp)"
ACTUAL="$(mktemp)"
trap 'rm -f "$EXPECTED" "$ACTUAL"' EXIT

# Render the expected job blocks from the seed rows, mirroring the field order
# and spacing that ofelia_generate_config.cfm emits:
#
#   [job-exec "name"]
#   schedule = <schedule>
#   container = <container>
#   command = <command>
#   no-overlap = true        (only when no_overlap = 1, and it comes LAST)
#
python3 - "$SEED_SQL" > "$EXPECTED" <<'PY'
import sys

src = open(sys.argv[1], encoding='utf-8').read()
for line in src.splitlines():
    if not line.startswith("INSERT IGNORE INTO `ofelia_jobs` VALUES ("):
        continue
    body = line[line.index('(') + 1:line.rindex(')')]
    # Split on commas outside single quotes; \" is a SQL escape for a literal ".
    fields, cur, inq, i = [], '', False, 0
    while i < len(body):
        c = body[i]
        if c == '\\':
            cur += body[i + 1]; i += 2; continue
        if c == "'":
            inq = not inq; i += 1; continue
        if c == ',' and not inq:
            fields.append(cur); cur = ''; i += 1; continue
        cur += c; i += 1
    fields.append(cur)
    # id, job_name, schedule, command, container, image, user, volume,
    # network, type, active, no_overlap
    if len(fields) < 12:
        sys.exit("malformed ofelia_jobs row: %s" % line[:80])
    name, sched, cmd, cont = fields[1], fields[2], fields[3], fields[4]
    active, no_overlap = fields[10].strip(), fields[11].strip()
    if active != '1':
        continue                     # generator selects WHERE active = '1'
    print()
    print(name)
    print("schedule = %s" % sched)
    print("container = %s" % cont)
    print("command = %s" % cmd)
    if no_overlap == '1':
        print("no-overlap = true")
PY

# Compare job blocks only. The [global] header carries install-specific
# notification addresses that the generator substitutes at render time, so it
# legitimately differs from the seed and is not ours to police here.
python3 - "$SHIPPED_INI" > "$ACTUAL" <<'PY'
import sys
lines = open(sys.argv[1], encoding='utf-8').read().splitlines()
start = next((i for i, l in enumerate(lines) if l.startswith('[job-exec')), None)
if start is None:
    print()          # no jobs at all -- will diff loudly against the seed
    sys.exit(0)
body = lines[start:]
while body and not body[-1].strip():
    body.pop()
print()
print("\n".join(body))
PY

if diff -u "$EXPECTED" "$ACTUAL" > /dev/null 2>&1; then
    jobs=$(grep -c '^\[job-exec' "$EXPECTED" || true)
    echo "OK: config/ofelia/config.ini matches the ofelia_jobs seed (${jobs} job(s))"
    exit 0
fi

echo "DRIFT: config/ofelia/config.ini does not match the ofelia_jobs seed rows"
echo "       in config/database/hermes_install.sql."
echo ""
echo "  - lines = expected (rendered from the seed)"
echo "  + lines = what config/ofelia/config.ini actually ships"
echo ""
diff -u "$EXPECTED" "$ACTUAL" | sed 's/^/  /' || true
echo ""
echo "Fix: update config/ofelia/config.ini to match, or correct the seed rows."
echo "     Both must agree -- the shipped file is what every fresh install runs"
echo "     until the first render, and what an upgrade restores over the live"
echo "     schedule before phase 4 re-renders it."
exit 1
