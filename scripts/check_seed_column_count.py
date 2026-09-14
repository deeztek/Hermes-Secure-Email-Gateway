#!/usr/bin/env python3
"""Positional seed INSERTs must match their table's column count.

A positional `INSERT INTO t VALUES (...)` list is bound to the column count of
the CREATE TABLE above it. Add a column to a seeded table and every positional
seed for it is now one value short, which is MySQL error 1136 and aborts the
whole baseline import. Column-list INSERTs are immune, so they are not checked.

Prints one line per offending table; exits 0 either way (caller counts lines).
"""
import re
import sys


def split_top(text, opens="([", closes=")]"):
    parts, cur, depth, q = [], [], 0, None
    j = 0
    while j < len(text):
        c = text[j]
        if q:
            if c == '\\':
                cur.append(text[j:j + 2]); j += 2; continue
            if c == q:
                q = None
        elif c in "'\"`":
            q = c
        elif c in opens:
            depth += 1
        elif c in closes:
            depth -= 1
        elif c == ',' and depth == 0:
            parts.append(''.join(cur)); cur = []; j += 1; continue
        cur.append(c); j += 1
    parts.append(''.join(cur))
    return parts


def column_counts(s):
    """table -> number of real column definitions in its CREATE TABLE."""
    out = {}
    for m in re.finditer(r'CREATE TABLE (?:IF NOT EXISTS )?`(\w+)` \(', s):
        i, depth, q, start = m.end(), 1, None, m.end()
        while i < len(s) and depth:
            c = s[i]
            if q:
                if c == '\\':
                    i += 2; continue
                if c == q:
                    q = None
            elif c in "'\"`":
                q = c
            elif c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
            i += 1
        n = 0
        for p in split_top(s[start:i - 1]):
            p = re.sub(r'--[^\n]*', '', p).strip()
            if p.startswith('`'):
                n += 1
        out[m.group(1)] = n
    return out


def value_tuples(vals):
    out, cur, depth, q = [], [], 0, None
    j = 0
    while j < len(vals):
        c = vals[j]
        if q:
            if c == '\\':
                cur.append(vals[j:j + 2]); j += 2; continue
            if c == q:
                q = None
        elif c in "'\"":
            q = c
        elif c == '(':
            depth += 1
            if depth == 1:
                cur = []; j += 1; continue
        elif c == ')':
            depth -= 1
            if depth == 0:
                out.append(''.join(cur)); j += 1; continue
        if depth:
            cur.append(c)
        j += 1
    return out


def main(path):
    s = open(path, encoding='utf-8').read()
    cols = column_counts(s)
    seen = set()
    for m in re.finditer(r'INSERT (?:IGNORE )?INTO `(\w+)` VALUES', s):
        t = m.group(1)
        if t in seen or t not in cols:
            continue
        end = s.find(';\n', m.end())
        if end < 0:
            end = len(s)
        for tup in value_tuples(s[m.end():end]):
            n = len(split_top(tup))
            if n != cols[t]:
                line = s[:m.start()].count('\n') + 1
                print("%s|%d|%d|%d" % (t, line, n, cols[t]))
                seen.add(t)
                break
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
