-- =====================================================================
-- Hermes SEG schema updates -- v260722
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the rows from hermes_install.sql).
-- DBeaver-friendly: plain INSERT/UPDATE, no PREPARE/DELIMITER blocks.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Outbound delivery pause control (defer_transports)
--
-- Adds the parameters directive + value rows that back the Mail Queue
-- "Pause/Resume Outbound Delivery" control and the legacy->Docker
-- migration safe-cutover hold. enabled=0 => normal delivery (default);
-- flipping enabled to 1 holds all outbound in the queue (renders
-- defer_transports = smtp relay via generate_postfix_configuration.cfm).
-- Rows are linked by parent_name (not parent id), matching how
-- generate_postfix_configuration.cfm resolves child values.
-- ---------------------------------------------------------------------
INSERT INTO parameters
  (parameter, name, module, editable, conf_file, description, parent, parent_name, child, order1, enabled, applied, action)
SELECT 'defer_transports', 'Pause Outbound Delivery', 'postfix', 0, 'main.cf',
       'When enabled, holds all outbound mail in the queue (renders defer_transports = smtp relay). Toggled by the Mail Queue Pause/Resume control; set to paused automatically during legacy-to-Docker migration. enabled=0 = normal delivery.',
       NULL, NULL, 2, NULL, 0, 1, 'NONE'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'defer_transports' AND child = 2 AND module = 'postfix'
);

INSERT INTO parameters
  (parameter, name, module, editable, conf_file, parent, parent_name, child, order1, enabled, applied, action)
SELECT 'smtp relay', 'Deferred Transports', 'postfix', 0, 'main.cf',
       NULL, 'defer_transports', 1, 1.000, 0, 1, 'NONE'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'smtp relay' AND parent_name = 'defer_transports' AND child = 1
);

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so the
-- update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260722' WHERE parameter = 'build_no';
