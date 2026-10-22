-- =====================================================================
-- Hermes SEG v261022 schema updates
-- Idempotent. No schema changes in this release: Nextcloud security update
-- (PHP) and Nextcloud secret file permissions, both handled by pre-scripts.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261022' WHERE parameter = 'build_no';
