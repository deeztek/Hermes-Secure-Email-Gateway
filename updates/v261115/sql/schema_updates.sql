-- =====================================================================
-- Hermes SEG v261115 schema updates
-- =====================================================================

-- ---------------------------------------------------------------------
-- User console Forwarding (#411): one row per mailbox user. forward_to is
-- another mailbox on the user's own domain; keep_copy = 1 keeps a copy in
-- the user's own mailbox (Sieve redirect :copy).
-- FRESH-INSTALL: n/a  hermes_install.sql creates the table
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_forwarding` (
  `username` varchar(255) NOT NULL,
  `enabled` tinyint(3) NOT NULL DEFAULT 0,
  `forward_to` varchar(255) DEFAULT NULL,
  `keep_copy` tinyint(3) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `modified_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`username`),
  KEY `idx_forward_to` (`forward_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- SpamAssassin rule updates (#412). Debian's cron.daily job never runs in
-- the mail_filter container; hermes-sa-update replaces it.
-- FRESH-INSTALL: n/a  hermes_install.sql seeds the row
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs`
  (`job_name`, `description`, `schedule`, `command`, `container`, `image`, `user`, `volume`, `network`, `type`, `active`, `no_overlap`)
SELECT '[job-exec "hermes-sa-update"]',
       'Downloads SpamAssassin rule updates and reloads Amavis when there are new rules.',
       '0 15 04 * * *',
       '/usr/local/bin/hermes-sa-update',
       'hermes_mail_filter', NULL, NULL, NULL, NULL, 'antispam', 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM `ofelia_jobs` WHERE `job_name` = '[job-exec "hermes-sa-update"]'
);

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261115' WHERE parameter = 'build_no';
