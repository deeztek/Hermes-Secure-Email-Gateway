#!/usr/bin/env python3
"""
Build config/database/hermes_install.sql from a DEV full dump + a sanitization
manifest. Single-file output: schema + sanitized seed data combined.

Apply order at install time:
    1) config/database/hermes_install.sql                 (this file)
    2) config/database/opendmarc_schema.sql               (empty schema)
    3) config/database/syslog_schema.sql                  (empty schema)
    4) updates/hermes-260119/sql/schema_updates.sql       (idempotent deltas)

Usage:
    scripts/build_hermes_install.py \\
        archive/dev_hermes_full.sql \\
        scripts/hermes_install_manifest.yaml \\
        > config/database/hermes_install.sql

Linked: GitHub issue #179
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    import yaml  # PyYAML
except ImportError:
    print("error: PyYAML required. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# Tuple parsing — same state machine as before, handles ; and ( ) inside
# string literals (e.g. postfix RBL codes like '127.0.0.[18;19;20]*-2').
# ---------------------------------------------------------------------------

def split_value_tuples(values: str) -> list[str]:
    tuples, depth, in_str, esc, start = [], 0, False, False, 0
    for i, ch in enumerate(values):
        if in_str:
            if esc: esc = False
            elif ch == "\\": esc = True
            elif ch == "'": in_str = False
        else:
            if ch == "'": in_str = True
            elif ch == "(":
                if depth == 0: start = i
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0: tuples.append(values[start:i + 1])
    return tuples


def tuple_cols(tup: str) -> list[str]:
    """Parse '(a, b, c)' -> ['a','b','c'] respecting string literals."""
    body = tup[1:-1]  # strip parens
    out, cur, in_str, esc = [], [], False, False
    for ch in body:
        if in_str:
            cur.append(ch)
            if esc: esc = False
            elif ch == "\\": esc = True
            elif ch == "'": in_str = False
        else:
            if ch == "'":
                in_str = True
                cur.append(ch)
            elif ch == ",":
                out.append("".join(cur).strip())
                cur = []
            else:
                cur.append(ch)
    if cur:
        out.append("".join(cur).strip())
    return out


def cols_tuple(cols: list[str]) -> str:
    return "(" + ", ".join(cols) + ")"


def sql_quote(val) -> str:
    """Render a Python value as a MySQL literal."""
    if val is None:
        return "NULL"
    if isinstance(val, bool):
        return "'1'" if val else "'0'"
    if isinstance(val, (int, float)):
        return str(val)
    s = str(val).replace("\\", "\\\\").replace("'", "\\'")
    return f"'{s}'"


def unquote(lit: str) -> str | None:
    """'\\'foo\\'' -> 'foo'; 'NULL' -> None; '123' -> '123' (left as-is)."""
    lit = lit.strip()
    if lit.upper() == "NULL":
        return None
    if lit.startswith("'") and lit.endswith("'"):
        s = lit[1:-1]
        # Unescape: \' -> ', \\ -> \
        out, esc = [], False
        for ch in s:
            if esc:
                out.append(ch)
                esc = False
            elif ch == "\\":
                esc = True
            else:
                out.append(ch)
        return "".join(out)
    return lit


# ---------------------------------------------------------------------------
# Dump section parsing
# ---------------------------------------------------------------------------

SECTION_RE = re.compile(
    # Both mysqldump dialects:
    #   DEV-style:    -- Table structure for table `name`
    #   Legacy-style: -- Table structure for `name`
    # Decoration line above the marker can be empty (`--\n`) or dashed
    # (`-- -----------\n`); accept either with [^\n]*.
    r"--[^\n]*\n--[^\n]*Table structure for(?:\s+table)?\s+`(\w+)`[^\n]*\n",
    re.IGNORECASE,
)


def split_sections(sql: str) -> list[tuple[str, str]]:
    """
    Return [(table_name, section_text), ...] in order encountered.
    The first chunk (preamble before any table) is paired with name ''.
    """
    parts = SECTION_RE.split(sql)
    out: list[tuple[str, str]] = [("", parts[0])]
    for i in range(1, len(parts), 2):
        out.append((parts[i], parts[i + 1]))
    return out


CREATE_RE = re.compile(r"^(CREATE TABLE.*?\n\) ENGINE.*?;)", re.DOTALL | re.MULTILINE)


def extract_create(section: str) -> tuple[str | None, list[str]]:
    """
    Return (create_statement, column_names) from a section body.
    column_names extracted from `colname` at start of body lines.
    """
    m = CREATE_RE.search(section)
    if not m:
        return None, []
    create_stmt = m.group(1)
    # Pull column names from definition body
    body = create_stmt
    cols = re.findall(r"^\s*`(\w+)`\s+", body, re.MULTILINE)
    return create_stmt, cols


INSERT_HEAD_RE = re.compile(
    r"INSERT\s+(?:IGNORE\s+)?INTO\s+`(\w+)`(?:\s*\([^)]*\))?\s+VALUES\s+",
    re.IGNORECASE,
)


def extract_inserts(section: str) -> list[str]:
    """Return all VALUE-tuple strings from INSERT statements in this section."""
    tuples = []
    i = 0
    while True:
        m = INSERT_HEAD_RE.search(section, i)
        if not m:
            break
        j = m.end()
        in_str = esc = False
        while j < len(section):
            ch = section[j]
            if in_str:
                if esc: esc = False
                elif ch == "\\": esc = True
                elif ch == "'": in_str = False
            else:
                if ch == "'": in_str = True
                elif ch == ";": break
            j += 1
        tuples.extend(split_value_tuples(section[m.end():j]))
        i = j + 1
    return tuples


# ---------------------------------------------------------------------------
# Transformation per manifest class
# ---------------------------------------------------------------------------

def emit_seed(table: str, create_stmt: str, tuples: list[str]) -> str:
    """Class: seed — keep CREATE + all DEV rows verbatim (INSERT IGNORE)."""
    out = [_table_banner(table, "seed"), create_stmt, ""]
    if tuples:
        out.append(f"-- {len(tuples)} row(s) for `{table}`")
        for t in tuples:
            out.append(f"INSERT IGNORE INTO `{table}` VALUES {t};")
        out.append("")
    return "\n".join(out)


def emit_seed_from_legacy(
    table: str,
    create_stmt: str,
    legacy_sql: str,
    drop_rows_with_parameter: list[str] | None,
    legacy_cols_map: dict[str, list[str]],
) -> str:
    """
    Class: seed_from_legacy — keep DEV CREATE, replace rows with legacy INSERTs
    (already pre-sanitized). drop_rows_with_parameter strips rows whose
    `parameter` column matches (used to exclude version_no/build_no).
    """
    out = [_table_banner(table, "seed_from_legacy"), create_stmt, ""]
    legacy_section = _find_legacy_section(legacy_sql, table)
    if legacy_section is None:
        out.append(f"-- WARNING: legacy hermes.sql has no `{table}` section")
        return "\n".join(out) + "\n"

    legacy_tuples = extract_inserts(legacy_section)
    legacy_cols = legacy_cols_map.get(table, [])
    drop_set = set(drop_rows_with_parameter or [])

    kept = []
    if drop_set:
        # Find the index of the `parameter` column in legacy table
        try:
            param_idx = legacy_cols.index("parameter")
        except ValueError:
            param_idx = None
        for t in legacy_tuples:
            if param_idx is not None:
                vals = tuple_cols(t)
                if param_idx < len(vals) and unquote(vals[param_idx]) in drop_set:
                    continue
            kept.append(t)
    else:
        kept = legacy_tuples

    if not legacy_cols:
        out.append(f"-- WARNING: could not resolve legacy column list for `{table}`")
        return "\n".join(out) + "\n"

    col_list = ", ".join(f"`{c}`" for c in legacy_cols)
    out.append(f"-- {len(kept)} legacy row(s) for `{table}` (column-named for ALTER-safety)")
    for t in kept:
        out.append(f"INSERT IGNORE INTO `{table}` ({col_list}) VALUES {t};")
    out.append("")
    return "\n".join(out)


def emit_truncate(table: str, create_stmt: str) -> str:
    out = [_table_banner(table, "truncate"), create_stmt, ""]
    return "\n".join(out)


def emit_scrub(
    table: str,
    create_stmt: str,
    cols: list[str],
    tuples: list[str],
    scrub_rules: list[dict],
    drop_rows_by_id: list[int] | None,
) -> str:
    """
    Class: scrub — keep rows, rewrite specific values per scrub_rules.
    Supported rule forms:
      - match_id (int) + set_col (int idx) + value (any)  -> rewrites col by 0-indexed position
      - match: {col: value, ...} + set_value (str)        -> rewrites the 'value' column (by name)
      - match: {col: value, ...} + set_value2 (str)       -> rewrites the 'value2' column (by name)
    """
    drop_ids = set(drop_rows_by_id or [])
    out = [_table_banner(table, "scrub"), create_stmt, ""]
    kept = []
    # Index `id` column if present
    try:
        id_idx = cols.index("id")
    except ValueError:
        id_idx = None

    name_to_idx = {c: i for i, c in enumerate(cols)}

    for tup in tuples:
        vals = tuple_cols(tup)
        # Drop by id?
        if id_idx is not None and id_idx < len(vals):
            try:
                row_id = int(unquote(vals[id_idx]) or "-1")
            except (ValueError, TypeError):
                row_id = -1
            if row_id in drop_ids:
                continue

        # Apply scrub rules
        for rule in scrub_rules:
            # Form A: match_id + set_col
            if "match_id" in rule:
                if id_idx is None:
                    continue
                try:
                    row_id = int(unquote(vals[id_idx]) or "-1")
                except (ValueError, TypeError):
                    row_id = -1
                if row_id != rule["match_id"]:
                    continue
                col_pos = rule["set_col"]
                if col_pos < len(vals):
                    vals[col_pos] = sql_quote(rule.get("value"))
            # Form B: match: {col: val, ...} + set_value / set_value2
            elif "match" in rule:
                ok = True
                for k, expected in rule["match"].items():
                    if k not in name_to_idx:
                        ok = False; break
                    actual = unquote(vals[name_to_idx[k]])
                    if actual != expected:
                        ok = False; break
                if not ok:
                    continue
                if "set_value" in rule and "value" in name_to_idx:
                    vals[name_to_idx["value"]] = sql_quote(rule["set_value"])
                if "set_value2" in rule and "value2" in name_to_idx:
                    vals[name_to_idx["value2"]] = sql_quote(rule["set_value2"])

        kept.append(cols_tuple(vals))

    if kept:
        out.append(f"-- {len(kept)} row(s) for `{table}` (scrubbed)")
        for t in kept:
            out.append(f"INSERT IGNORE INTO `{table}` VALUES {t};")
        out.append("")
    return "\n".join(out)


def emit_drop(table: str) -> str:
    return f"-- {table}: classified `drop` (omitted entirely; schema_updates.sql may also DROP IF EXISTS)\n"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _table_banner(table: str, klass: str) -> str:
    return f"-- -------- {table:<36} [{klass}] --------"


def _find_legacy_section(legacy_sql: str, table: str) -> str | None:
    """Return the section text for `table` in legacy hermes.sql, or None."""
    # Same dialect tolerance as SECTION_RE (both DEV and legacy formats).
    pat = re.compile(
        rf"--[^\n]*\n--[^\n]*Table structure for(?:\s+table)?\s+`{re.escape(table)}`[^\n]*\n",
        re.IGNORECASE,
    )
    m = pat.search(legacy_sql)
    if not m:
        return None
    # Section runs until next "Table structure for" or EOF
    next_m = SECTION_RE.search(legacy_sql, m.end())
    return legacy_sql[m.end():next_m.start() if next_m else len(legacy_sql)]


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    if len(sys.argv) != 3:
        print("usage: build_hermes_install.py <dev_dump.sql> <manifest.yaml>",
              file=sys.stderr)
        return 2

    dump_path = Path(sys.argv[1])
    manifest_path = Path(sys.argv[2])

    dump_sql = dump_path.read_text(encoding="utf-8", errors="replace")
    manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))

    tables_cfg = manifest.get("tables", {})
    legacy_path = manifest.get("legacy_path")
    legacy_sql = (
        Path(legacy_path).read_text(encoding="utf-8", errors="replace")
        if legacy_path else ""
    )

    # Build column map for legacy tables (needed for seed_from_legacy)
    legacy_cols_map: dict[str, list[str]] = {}
    for m in re.finditer(
        r"CREATE TABLE\s+`(\w+)`\s*\((.*?)\)\s*ENGINE",
        legacy_sql, re.DOTALL | re.IGNORECASE,
    ):
        name = m.group(1)
        cols = re.findall(r"^\s*`(\w+)`\s+", m.group(2), re.MULTILINE)
        if cols:
            legacy_cols_map[name] = cols

    sections = split_sections(dump_sql)
    preamble = sections[0][1]

    # Header
    sys.stdout.write(
        "-- ============================================================================\n"
        "-- Hermes SEG fresh-install combined schema + seed data.\n"
        "--\n"
        "-- Generated by scripts/build_hermes_install.py from:\n"
        f"--   dump     : {dump_path.name}\n"
        f"--   manifest : {manifest_path.name}\n"
        "--\n"
        "-- Apply ORDER at install time:\n"
        "--   1) this file (hermes_install.sql)\n"
        "--   2) config/database/opendmarc_schema.sql\n"
        "--   3) config/database/syslog_schema.sql\n"
        "--   4) updates/hermes-260119/sql/schema_updates.sql\n"
        "--\n"
        "-- Regenerate:\n"
        "--   scripts/build_hermes_install.py archive/dev_hermes_full.sql \\\n"
        "--     scripts/hermes_install_manifest.yaml > config/database/hermes_install.sql\n"
        "--\n"
        "-- Linked: GitHub issue #179\n"
        "-- ============================================================================\n\n"
    )

    # Preserve mysqldump SET preamble (charset/sql_mode setup) but skip its
    # version banner / host comments.
    for line in preamble.splitlines():
        stripped = line.strip()
        if stripped.startswith("/*!") or stripped.startswith("SET "):
            sys.stdout.write(line + "\n")
    sys.stdout.write("\n")

    seen_tables = set()
    warnings: list[str] = []

    for table, section in sections[1:]:
        seen_tables.add(table)
        cfg = tables_cfg.get(table)
        if cfg is None:
            warnings.append(f"table `{table}` in dump but not classified in manifest — treating as TRUNCATE")
            klass = "truncate"
            cfg = {}
        else:
            klass = cfg.get("class", "truncate")

        create_stmt, cols = extract_create(section)
        tuples = extract_inserts(section)

        if klass == "drop":
            sys.stdout.write(emit_drop(table))
            continue

        if not create_stmt:
            warnings.append(f"table `{table}` missing CREATE TABLE in dump — skipping")
            continue

        # Inject IF NOT EXISTS for idempotency
        create_stmt_safe = re.sub(
            r"^CREATE TABLE\s+`",
            "CREATE TABLE IF NOT EXISTS `",
            create_stmt,
            count=1,
            flags=re.IGNORECASE,
        )
        # Strip AUTO_INCREMENT=N at table level (don't leak DEV row counts)
        create_stmt_safe = re.sub(r"\s+AUTO_INCREMENT=\d+", "", create_stmt_safe)

        if klass == "seed":
            sys.stdout.write(emit_seed(table, create_stmt_safe, tuples))
        elif klass == "seed_from_legacy":
            sys.stdout.write(emit_seed_from_legacy(
                table, create_stmt_safe, legacy_sql,
                cfg.get("drop_rows_with_parameter"),
                legacy_cols_map,
            ))
        elif klass == "truncate":
            sys.stdout.write(emit_truncate(table, create_stmt_safe))
        elif klass == "scrub":
            sys.stdout.write(emit_scrub(
                table, create_stmt_safe, cols, tuples,
                cfg.get("scrub_rules", []),
                cfg.get("drop_rows_by_id"),
            ))
        else:
            warnings.append(f"table `{table}` has unknown class `{klass}` — skipping")
        sys.stdout.write("\n")

    # Footer
    sys.stdout.write(
        "\n-- ============================================================================\n"
        "-- End of hermes_install.sql\n"
        "-- ============================================================================\n"
    )

    # Manifest entries with no matching table in dump
    for tbl in tables_cfg:
        if tbl not in seen_tables:
            warnings.append(f"manifest entry for `{tbl}` not found in dump")

    if warnings:
        sys.stderr.write("\n--- Warnings ---\n")
        for w in warnings:
            sys.stderr.write(f"  {w}\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
