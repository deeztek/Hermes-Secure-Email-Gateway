-- =====================================================================
-- Hermes SEG v261123 schema updates
-- =====================================================================
-- Images-only security release: no schema changes.

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261123' WHERE parameter = 'build_no';
