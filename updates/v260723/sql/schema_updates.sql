-- =====================================================================
-- Hermes SEG schema updates -- v260723
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- This release (#287) is a CODE-ONLY fix to schedule/quarantine_notify.cfm
-- (a 7-day recency guard) plus a backfill inside the legacy->Docker
-- migration script. Neither touches the shipped schema, so there is NO
-- structural change here -- only the version stamp below.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so the
-- update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260723' WHERE parameter = 'build_no';
