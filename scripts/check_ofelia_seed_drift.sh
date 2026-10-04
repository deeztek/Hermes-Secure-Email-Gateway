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

import re

src = open(sys.argv[1], encoding='utf-8').read()

# Legacy positional order, used only when a row does not name its columns.
LEGACY = ['id', 'job_name', 'schedule', 'command', 'container', 'image',
          'user', 'volume', 'network', 'type', 'active', 'no_overlap']

def split_values(body):
    """Split on commas outside single quotes. Backslash is a SQL escape.

    Whitespace OUTSIDE the quotes is dropped and whitespace inside is kept
    exactly. Both matter: the multi-line INSERT..SELECT form indents its values
    across several lines, while at least one schedule is stored with a leading
    space inside its quotes that the generator emits verbatim. Stripping the
    field afterwards would lose the second; not stripping would keep the
    first."""
    fields, cur, inq, i = [], '', False, 0
    while i < len(body):
        c = body[i]
        if c == '\\' and inq:
            cur += body[i + 1]; i += 2; continue
        if c == "'":
            inq = not inq; i += 1; continue
        if c == ',' and not inq:
            fields.append(cur); cur = ''; i += 1; continue
        if not inq and c in ' \t\r\n':
            i += 1; continue
        cur += c; i += 1
    fields.append(cur)
    return fields

# Statement-based, not line-based, and comment-aware.
#
# A row seeded with
#   INSERT INTO `ofelia_jobs` (cols) SELECT vals WHERE NOT EXISTS (...)
# spans several lines and is the form used when there is no unique key to
# dedupe on. The previous parser read a line at a time and matched only the
# single-line INSERT IGNORE ... VALUES form, so it could not see those at all.
# hermes-directory-sync was seeded that way, missing from the shipped
# config.ini, and reported as no drift for an entire release. That is precisely
# the failure this check exists to prevent, so both forms are read now and a
# shape it does not recognise is a hard error rather than a silent skip.
def split_statements(sql):
    """Split on semicolons OUTSIDE quoted strings and outside -- comments.

    A naive split(';') breaks any statement whose values contain a semicolon,
    and at least one job description does. mysql itself parses this correctly
    when the file is piped in, so the SQL is valid and only this check was
    wrong."""
    out, cur, i, inq, incomment = [], '', 0, False, False
    while i < len(sql):
        c = sql[i]
        if incomment:
            cur += c
            if c == '\n': incomment = False
            i += 1; continue
        if not inq and c == '-' and sql[i:i + 2] == '--':
            incomment = True; cur += c; i += 1; continue
        if c == '\\' and inq:
            cur += sql[i:i + 2]; i += 2; continue
        if c == "'":
            if inq and sql[i:i + 2] == "''":
                cur += "''"; i += 2; continue
            inq = not inq; cur += c; i += 1; continue
        if c == ';' and not inq:
            out.append(cur); cur = ''; i += 1; continue
        cur += c; i += 1
    out.append(cur)
    return out

for stmt in split_statements(src):
    stmt = "\n".join(l for l in stmt.split("\n")
                      if not l.strip().startswith('--')).strip()
    low = stmt.lower()
    if not low.startswith('insert ') or '`ofelia_jobs`' not in low:
        continue

    rest = stmt[stmt.index('`ofelia_jobs`') + len('`ofelia_jobs`'):].strip()

    if rest.startswith('('):
        depth, i = 0, 0
        while i < len(rest):
            if rest[i] == '(': depth += 1
            elif rest[i] == ')':
                depth -= 1
                if depth == 0: break
            i += 1
        cols = [c.strip().strip('`') for c in rest[1:i].split(',')]
        rest = rest[i + 1:].strip()
    else:
        cols = LEGACY

    if rest.lower().startswith('values'):
        vals = rest[len('values'):].strip()
        body = vals[vals.index('(') + 1:vals.rindex(')')]
    elif rest.lower().startswith('select'):
        body = rest[len('select'):]
        cut = re.search(r'\s+FROM\s+DUAL\b|\s+WHERE\s+NOT\s+EXISTS\b',
                        body, re.IGNORECASE)
        if not cut:
            sys.exit("ofelia_jobs INSERT..SELECT with no WHERE NOT EXISTS: %s"
                     % stmt[:80])
        body = body[:cut.start()].strip()
    else:
        sys.exit("unrecognised ofelia_jobs insert: %s" % stmt[:80])

    fields = split_values(body)
    if len(fields) != len(cols):
        sys.exit("ofelia_jobs row has %d values for %d columns: %s"
                 % (len(fields), len(cols), stmt[:80]))
    row = dict(zip(cols, fields))
    for required in ('job_name', 'schedule', 'command', 'container',
                     'active', 'no_overlap'):
        if required not in row:
            sys.exit("ofelia_jobs row omits %s: %s" % (required, stmt[:80]))

    # Not stripped: the generator emits these verbatim, and one schedule is
    # stored with a leading space inside its quotes.
    name, sched = row['job_name'], row['schedule']
    cmd, cont = row['command'], row['container']
    active, no_overlap = row['active'], row['no_overlap']
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
