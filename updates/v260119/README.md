# `updates/v260119/`

Per-release update artifacts for **v260119** (the first Docker release).

## Convention

Each Hermes release ships a directory at `updates/v<VERSION>/` containing whatever artifacts that release introduces. The directory IS the unit of work for the update orchestrator (`system_update_docker.sh`, #221).

```
updates/
├── v260119/                    <-- this directory
│   ├── README.md               <-- describes what's in this release
│   ├── sql/
│   │   └── schema_updates.sql  <-- schema deltas this release introduces
│   ├── cfml/                   <-- optional: one-shot CFML migrations
│   │   └── *.cfm
│   └── scripts/                <-- optional: one-shot bash scripts
│       └── *.sh
├── v260120/                    <-- next release (when cut)
│   └── sql/
│       └── schema_updates.sql  <-- ONLY contains deltas v260119 -> v260120
└── ...
```

## Apply order within a release directory

When the orchestrator applies a release directory, it runs:

1. **`sql/*.sql`** — all SQL files in alphabetical order (typically just `schema_updates.sql`)
2. **`cfml/*.cfm`** — one-shot CFML migrations (e.g., re-encrypt rows, file moves that need Lucee's API)
3. **`scripts/*.sh`** — one-shot bash scripts

Each artifact must be **idempotent**:

- SQL: use `IF NOT EXISTS`, `INSERT IGNORE`, value-gated `WHERE` clauses
- CFML: check whether the data transform has already been applied before doing it
- Bash: check preconditions before mutating

Re-running an already-applied artifact must be a no-op, not an error.

## Cross-release ordering (orchestrator's job)

The orchestrator looks at `system_settings.build_no` (current install version) and finds all release directories with version greater than current. It applies each in order:

```
current build_no = v260119
target build_no  = v260121

# Orchestrator applies:
updates/v260120/   (sql/, cfml/, scripts/)
updates/v260121/   (sql/, cfml/, scripts/)

# Final step:
UPDATE system_settings SET value='v260121' WHERE parameter='build_no';
```

Each release's `schema_updates.sql` ends with its own version stamp (`UPDATE system_settings SET value='v<VERSION>' ...`). This is what advances `build_no` to mark the release as applied.

## What's in v260119

The first Docker release's `sql/schema_updates.sql` is the **catch-up file** that brings pre-Docker / pre-v260119 installs (DEV, Test, etc.) up to the v260119 baseline. It contains:

- `mailbox_domains` extensions (org_name, org_phone, etc.) for #226
- `disclaimer_templates` table for #214
- `user_signatures` table for #226
- `additional_sans.system` column for system-managed SANs
- `system_certificates.system` column for #252
- Postfix TLS path migration to bootstrap paths for #254
- `ofelia_jobs` row update for the `hermes-update-check` command (#218)
- Release stamp: `version_no='Docker'`, `build_no='v260119'`

Fresh installs get all of this from `config/database/hermes_install.sql` (the baseline) plus this file appended at the end.

## Why per-release directories instead of one cumulative file?

Originally a single growing `updates/hermes-260119/sql/schema_updates.sql` would have collected every delta from every future release. That works for SQL alone but:

- Reasoning about "what changed in v260120?" required diffing the file across git tags
- The directory name `hermes-260119` lied after the second release (it wasn't just v260119's deltas anymore)
- No place for non-SQL artifacts (CFML migrations, bash one-shots)
- File grew unboundedly

Per-release directories scope each release's deltas, allow mixed artifact types, and stay close to the GitHub Release model (one tag → one release directory).
