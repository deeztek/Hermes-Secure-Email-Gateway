-- =====================================================================
-- Hermes SEG schema updates -- v261012
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: msgs.from_addr / msgs.subject to utf8mb4 (#353), version stamp.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Store emoji in Message History (#353)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  msgs DDL uses utf8mb4 for from_addr/subject
--
-- utf8mb3 cannot hold 4-byte characters, so amavis failed to record any
-- message with an emoji in its subject or sender name ("Incorrect string
-- value ... info not saved"): delivered, but missing from Message History.
-- Neither column is indexed. ALGORITHM=COPY, LOCK=NONE is MariaDB 11.2+
-- online copy: the table is rebuilt while amavis keeps writing. Verified on
-- a 1.58M-row / 761 MB msgs table. Re-running rebuilds the table again
-- without error.
-- ---------------------------------------------------------------------
ALTER TABLE msgs
  MODIFY from_addr varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  MODIFY subject   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  ALGORITHM=COPY, LOCK=NONE;

-- ---------------------------------------------------------------------
-- 2. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261012' WHERE parameter = 'build_no';
