-- =====================================================================
-- Hermes SEG v261026 schema updates
-- Idempotent. No schema changes in this release; the certificate binding
-- for existing hybrid domains (#371) is created by schedule/post_upgrade.cfm
-- (block hybrid-domain-cert-binding-v1).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261026' WHERE parameter = 'build_no';
