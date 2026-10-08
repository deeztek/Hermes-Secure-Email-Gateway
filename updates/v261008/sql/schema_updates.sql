-- =====================================================================
-- Hermes SEG schema updates -- v261008
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: version stamp only.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261008' WHERE parameter = 'build_no';
