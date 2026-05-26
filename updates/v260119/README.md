# `updates/v260119/`

Per-release update artifacts for **v260119** (the first Docker release).

## v260119 is the baseline release — no deltas

v260119 is the **baseline** for the Docker era: every fresh install starts from `config/database/hermes_install.sql` (a self-contained snapshot at v260119). This directory therefore has no `sql/`, `cfml/`, or `scripts/` subdirectories — there's nothing to apply on top of the baseline because the baseline IS v260119.

The first real per-release directory will be cut whenever the **next** release ships. Versions follow calendar versioning `v<YYMMDD>`, so the next directory could be `v260601`, `v260615`, `v270315`, etc. — whatever date that release is tagged. **Do not assume `v260120`** as the next version; that example was used loosely in earlier docs and is misleading.

## Convention (for future releases)

Each Hermes release ships a directory at `updates/v<DATE>/` containing whatever artifacts that release introduces. The directory IS the unit of work for the update orchestrator (`system_update_docker.sh`, #221).

```
updates/
├── v260119/                    <-- baseline release (this directory, empty by design)
│   └── README.md
├── v<DATE>/                    <-- next release (when cut; date TBD)
│   ├── README.md
│   ├── sql/
│   │   └── schema_updates.sql  <-- ONLY contains deltas v260119 -> v<DATE>
│   ├── cfml/                   <-- optional: one-shot CFML migrations
│   │   └── *.cfm
│   └── scripts/                <-- optional: one-shot bash scripts
│       └── *.sh
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
target build_no  = v<later-date>

# Orchestrator applies each release directory between current and target
# in chronological (filename-sort) order:
updates/v<intermediate-date>/   (sql/, cfml/, scripts/)
updates/v<later-date>/          (sql/, cfml/, scripts/)

# Final step:
UPDATE system_settings SET value='v<later-date>' WHERE parameter='build_no';
```

Each release's `schema_updates.sql` ends with its own version stamp (`UPDATE system_settings SET value='v<DATE>' ...`). This is what advances `build_no` to mark the release as applied.

## History — what used to be in v260119/sql/

Earlier sessions in #218 cleanup had a `sql/schema_updates.sql` here (2,706 lines). It served two purposes:

1. **DEV catch-up**: brought drifted DEV/Test schemas up to v260119 baseline.
2. **Fresh-install gap fill**: `install_hermes_docker.sh --init-db` applied it after `hermes_install.sql` to cover 22 missing seed rows and one value correction the baseline didn't yet have.

After the audit on 2026-05-26, those 22 seeds + 1 correction were moved into `hermes_install.sql`, making the baseline self-contained. The delta file was then deleted because (a) all of its remaining statements were no-ops against the now-complete baseline, and (b) v260119 is the START of the per-release `updates/` convention — there's no v260118 baseline to delta from.

A reference copy of the deleted file lives at `~/dev_catchup_v260119.sql` outside the repo, and the full history is in git (last present at commit `5c45a8d`).
