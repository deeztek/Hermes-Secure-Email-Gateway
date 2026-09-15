-- =====================================================================
-- Hermes SEG schema updates -- v260816
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Seed quarantine digest settings
-- ---------------------------------------------------------------------
INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'enabled', '0', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'enabled' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'frequency', 'daily', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'frequency' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'template', 'modern', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'template' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'subject', '[Hermes SEG] Quarantine Digest', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'subject' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'intro', 'Review quarantined messages below. Secure links let recipients view, release, or block senders without signing in.', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'intro' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'disable_individual', '1', 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'disable_individual' AND p.module = 'quarantine_digest'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'last_run', NULL, 'quarantine_digest', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'last_run' AND p.module = 'quarantine_digest'
);

-- ---------------------------------------------------------------------
-- 2. Track digest deliveries per recipient/message
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `quarantine_digest_deliveries` (
  `rid` bigint(20) unsigned NOT NULL,
  `mail_id` varchar(255) NOT NULL,
  `status` char(1) NOT NULL DEFAULT 'P',
  `last_attempt_at` datetime DEFAULT current_timestamp(),
  `delivered_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`rid`,`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

ALTER TABLE `quarantine_digest_deliveries`
  ADD COLUMN IF NOT EXISTS `status` char(1) NOT NULL DEFAULT 'P' AFTER `mail_id`,
  ADD COLUMN IF NOT EXISTS `last_attempt_at` datetime DEFAULT current_timestamp() AFTER `status`;

-- ---------------------------------------------------------------------
-- 3. Seed the Ofelia quarantine digest job
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-quarantine-digest"]', '@every 60s',
       '/usr/bin/curl --silent http://localhost:8888/schedule/digestQuarantine.cfm',
       'hermes_commandbox', 'system', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-quarantine-digest"]'
);

-- ---------------------------------------------------------------------
-- 4. Version stamp -- MUST be the last statement.
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260816' WHERE parameter = 'build_no';
