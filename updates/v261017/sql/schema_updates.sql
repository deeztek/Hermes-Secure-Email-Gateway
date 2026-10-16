-- =====================================================================
-- Hermes SEG schema updates -- v261017
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: drop legacy user_settings password/reset/digest columns, drop
-- the dead crontab_entries table, version stamp.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Drop legacy user_settings columns
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  user_settings DDL has none of these columns
--
-- Only installs migrated from legacy have them; no code reads them. The
-- legacy portal stored each user's password here as a salted SHA-512 hash,
-- plus password-reset codes and the requesting IP. Portal sign-in is LDAP +
-- Authelia now, so these are stale credential material sitting in the
-- database and every backup of it. report_frequency was read only by the
-- quarantine digest pages, removed in this release (replaced by real-time
-- notifications, #180). A no-op where the columns do not exist.
-- ---------------------------------------------------------------------
ALTER TABLE user_settings
  DROP COLUMN IF EXISTS password,
  DROP COLUMN IF EXISTS password_set,
  DROP COLUMN IF EXISTS report_frequency,
  DROP COLUMN IF EXISTS reset_password_code,
  DROP COLUMN IF EXISTS reset_password_ip,
  DROP COLUMN IF EXISTS reset_password_datetime;

-- ---------------------------------------------------------------------
-- 2. Drop crontab_entries
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  table removed from the baseline
--
-- Held the quarantine digest's frequency choices ("Every 2 Hours", ...). No
-- page reads it since the digest was replaced (#180).
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS crontab_entries;

-- ---------------------------------------------------------------------
-- 3. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261017' WHERE parameter = 'build_no';
