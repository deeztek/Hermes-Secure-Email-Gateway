-- =====================================================================
-- Hermes SEG v261102 schema updates
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Recipient Delivery VERIFY (#393). Adds the recipient restriction that
-- asks the destination server whether a recipient exists, for domains set
-- to VERIFY. Nothing is set to VERIFY by the upgrade, so the lookup matches
-- nothing until an admin switches a domain. The map file it points at is
-- placed by scripts/10-render-verify-recipients-map.sh, and main.cf picks
-- up the restriction when post_upgrade.cfm regenerates the Postfix config.
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO parameters (parameter, name, module, editable, conf_file, description, parent, parent_name, child, order1, enabled, applied, action)
SELECT 'check_recipient_access mysql:/etc/postfix/mysql-verify-recipients.cf', 'Verify Recipients Access Check', 'postfix', 0, 'main.cf',
       'Recipient Delivery VERIFY: asks the destination server whether a recipient exists before accepting mail (#393)',
       NULL, 'smtpd_recipient_restrictions', 1, 2.500, 1, 1, 'NONE'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM parameters WHERE parameter = 'check_recipient_access mysql:/etc/postfix/mysql-verify-recipients.cf');

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261102' WHERE parameter = 'build_no';
