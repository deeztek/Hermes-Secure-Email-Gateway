-- =====================================================================
-- Hermes SEG schema updates -- v260917
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Transactional SMTP credentials
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `transactional_smtp_credentials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `allowed_senders` varchar(1000) DEFAULT NULL,
  `allowed_domains` varchar(1000) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `revoked_at` datetime DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tx_smtp_username` (`username`),
  KEY `idx_tx_smtp_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- 2. Transactional API tokens
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `transactional_api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `token_salt` varchar(255) NOT NULL,
  `token_prefix` varchar(32) NOT NULL,
  `allowed_senders` varchar(1000) DEFAULT NULL,
  `allowed_domains` varchar(1000) DEFAULT NULL,
  `any_ip` tinyint(1) NOT NULL DEFAULT 1,
  `ip_allowlist` varchar(1000) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `revoked_at` datetime DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tx_api_token_hash` (`token_hash`),
  KEY `idx_tx_api_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- 3. Transactional submission audit log
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `transactional_email_audit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `auth_method` varchar(32) NOT NULL,
  `auth_identifier` varchar(255) NOT NULL,
  `source_ip` varchar(128) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `recipient` varchar(1000) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message_id` varchar(255) DEFAULT NULL,
  `result` varchar(32) NOT NULL,
  `rejection_reason` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tx_audit_created_at` (`created_at`),
  KEY `idx_tx_audit_identifier` (`auth_method`,`auth_identifier`,`created_at`),
  KEY `idx_tx_audit_result` (`result`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- 4. Transactional settings defaults
-- ---------------------------------------------------------------------
INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'enabled', '0', 'transactional_email', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) p
    WHERE p.parameter = 'enabled'
      AND p.module = 'transactional_email'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'messages_per_minute', '60', 'transactional_email', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) p
    WHERE p.parameter = 'messages_per_minute'
      AND p.module = 'transactional_email'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'messages_per_hour', '5000', 'transactional_email', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) p
    WHERE p.parameter = 'messages_per_hour'
      AND p.module = 'transactional_email'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'messages_per_day', '50000', 'transactional_email', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) p
    WHERE p.parameter = 'messages_per_day'
      AND p.module = 'transactional_email'
);
