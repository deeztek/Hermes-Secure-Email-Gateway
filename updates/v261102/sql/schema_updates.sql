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
-- 2. Link Guard: Google Web Risk provider (#385). Off until an admin adds a
-- key, like the other reputation providers.
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO `parameters2` (`parameter`,`value2`,`module`,`active`,`applied`)
SELECT 'webrisk_enabled','0','linkguard',1,1
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM `parameters2` WHERE `module`='linkguard' AND `parameter`='webrisk_enabled');

INSERT INTO `parameters2` (`parameter`,`value2`,`module`,`active`,`applied`)
SELECT 'webrisk_api_key','','linkguard',1,1
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM `parameters2` WHERE `module`='linkguard' AND `parameter`='webrisk_api_key');

-- ---------------------------------------------------------------------
-- 3. Attachment Hash Blocklist (#386).
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `attachment_hash_blocklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sha256` char(64) NOT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `source` varchar(32) NOT NULL DEFAULT 'admin',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_attachment_hash_sha256` (`sha256`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- 4. Mail Import (#356).
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mail_import_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailbox_id` int(11) NOT NULL,
  `source_host` varchar(255) NOT NULL,
  `source_port` int(11) NOT NULL DEFAULT 993,
  `source_ssl` varchar(16) NOT NULL DEFAULT 'imaps',
  `verify_cert` tinyint(3) NOT NULL DEFAULT 1,
  `source_username` varchar(255) NOT NULL,
  `source_password` text DEFAULT NULL,
  `exclude_folders` text DEFAULT NULL,
  `folder_prefix` varchar(100) DEFAULT NULL,
  `imapc_features` varchar(255) DEFAULT NULL,
  `since_days` int(11) NOT NULL DEFAULT 0,
  `max_message_mb` int(11) NOT NULL DEFAULT 0,
  `io_timeout` int(11) NOT NULL DEFAULT 600,
  `mode` varchar(16) NOT NULL DEFAULT 'once',
  `interval_minutes` int(11) NOT NULL DEFAULT 60,
  `status` varchar(16) NOT NULL DEFAULT 'queued',
  `next_run_at` datetime DEFAULT NULL,
  `last_error` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_mail_import_jobs_status` (`status`,`next_run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `mail_import_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(11) NOT NULL,
  `token` char(32) NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `exit_code` int(11) DEFAULT NULL,
  `messages_before` bigint(20) DEFAULT NULL,
  `messages_after` bigint(20) DEFAULT NULL,
  `error_text` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mail_import_runs_job` (`job_id`),
  KEY `idx_mail_import_runs_open` (`ended_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `ofelia_jobs`
  (`job_name`, `description`, `schedule`, `command`, `container`, `image`, `user`, `volume`, `network`, `type`, `active`, `no_overlap`)
SELECT '[job-exec "hermes-mail-import"]',
       'Starts due Mail Import jobs and records the result of finished ones.',
       '@every 1m',
       '/usr/bin/curl --silent http://localhost:8888/schedule/mail_import.cfm',
       'hermes_commandbox', NULL, NULL, NULL, NULL, 'hermes', 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM `ofelia_jobs` WHERE `job_name` = '[job-exec "hermes-mail-import"]'
);

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261102' WHERE parameter = 'build_no';
