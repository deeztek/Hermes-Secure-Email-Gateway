-- ===========================================================================
-- v260609 schema updates
-- ===========================================================================
-- Hermes SEG Docker release v260609.
--
-- Major changes in this release (none affecting DB schema):
--   * Backup/restore/rehost CLI tools (#219, #220) -- new functionality,
--     no schema impact
--   * Authelia DB credentials moved from keys/ to creds/ (architectural
--     cleanup) -- handled by pre-scripts/01-migrate-authelia-creds.sh
--   * docker-compose.yml gains AUTHELIA_STORAGE_USERNAME +
--     AUTHELIA_STORAGE_PASSWORD secrets sourced from creds/
--   * Slim config + data tier backup format -- handled at backup time
--
-- This file's only DB-level action is the version stamp at the end. All
-- statements MUST be idempotent (per CLAUDE.md guidance).
-- ===========================================================================

-- (No DB schema deltas in v260609.)

-- ---------------------------------------------------------------------------
-- Version stamp -- MUST come last. The update orchestrator
-- (scripts/system_update_docker.sh Phase 3) re-reads build_no after
-- applying this file and warns if it didn't advance to v260609.
-- ---------------------------------------------------------------------------
UPDATE system_settings
   SET value = 'v260609'
 WHERE parameter = 'build_no'
   AND value <> 'v260609';
