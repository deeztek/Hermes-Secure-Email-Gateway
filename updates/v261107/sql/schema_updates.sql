-- =====================================================================
-- Hermes SEG v261107 schema updates
-- =====================================================================

-- ---------------------------------------------------------------------
-- Relay host credential rows. The baseline has seeded them since v260612,
-- but nothing added them to older installs, and the console stores the
-- credentials with UPDATE, so on those installs the password was silently
-- dropped and Postfix's sasl_passwd stayed empty.
-- FRESH-INSTALL: n/a  hermes_install.sql seeds both rows
-- ---------------------------------------------------------------------
INSERT INTO system_settings (parameter, value)
SELECT 'relay_host_username', ''
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'relay_host_username');

INSERT INTO system_settings (parameter, value)
SELECT 'relay_host_password', ''
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'relay_host_password');

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261107' WHERE parameter = 'build_no';
