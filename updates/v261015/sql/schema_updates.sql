-- =====================================================================
-- Hermes SEG schema updates -- v261015
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: drop the legacy user_settings.id column (#362), version stamp.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Drop the legacy user_settings.id column (#362)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  user_settings DDL has no id column
--
-- Legacy defined user_settings.id as varchar(255) NOT NULL PRIMARY KEY and
-- filled it itself. The Docker table has no id, no code reads it, and the
-- inserts that add a relay recipient or provision a mailbox do not supply
-- it. A legacy migration kept the column (its schema bridge only adds
-- columns), so on migrated installs those inserts failed with "Field 'id'
-- doesn't have a default value". Dropping it also drops the primary key,
-- matching the baseline. A no-op where the column does not exist.
-- ---------------------------------------------------------------------
ALTER TABLE user_settings DROP COLUMN IF EXISTS id;

-- ---------------------------------------------------------------------
-- 2. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261015' WHERE parameter = 'build_no';
