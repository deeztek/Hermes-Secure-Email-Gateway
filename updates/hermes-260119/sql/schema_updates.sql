-- Hermes SEG Schema Updates - 2026-01-19
-- LDAP User Management Integration & Parameters Table Updates
--
-- Run this script against the hermes database:
-- docker exec -i hermes_db_server mysql -u root hermes < /path/to/schema_updates.sql

-- ============================================================================
-- SYSTEM_USERS TABLE: Add ldap_synced column
-- This tracks whether a user has been synchronized to LDAP
-- 0 = not synced, 1 = synced to LDAP
-- ============================================================================

ALTER TABLE system_users ADD COLUMN IF NOT EXISTS ldap_synced TINYINT(1) NOT NULL DEFAULT 0;

-- Mark all existing users as not synced (they will need to be synced to LDAP)
UPDATE system_users SET ldap_synced = 0 WHERE ldap_synced IS NULL;

-- ============================================================================
-- SYSTEM_USERS TABLE: Add auth_type and remoteauth_domain columns
-- auth_type: 'local' for local authentication, 'remote' for RemoteAuth (Pro only)
-- remoteauth_domain: The domain name for remote authentication (references remoteauth_mappings)
-- ============================================================================

ALTER TABLE system_users ADD COLUMN IF NOT EXISTS auth_type VARCHAR(10) NOT NULL DEFAULT 'local';
ALTER TABLE system_users ADD COLUMN IF NOT EXISTS remoteauth_domain VARCHAR(255) NULL;

-- Set existing users to local authentication
UPDATE system_users SET auth_type = 'local' WHERE auth_type IS NULL OR auth_type = '';

-- ============================================================================
-- PARAMETERS TABLE: Schema modifications and data updates
-- ============================================================================

-- 1) Add new parent_name column (text)
ALTER TABLE parameters
  ADD COLUMN IF NOT EXISTS parent_name VARCHAR(255) NULL AFTER parent;

-- 2) Change parent from INT to TEXT
ALTER TABLE parameters
  MODIFY parent VARCHAR(255) NULL;

-- 3) Change order1 from INT to DECIMAL (allows values like 1.1)
ALTER TABLE parameters
  MODIFY order1 DECIMAL(7,3) NULL;

-- 4) Insert the new permit_sasl_authenticated row (if not exists)
--    Let MySQL auto-assign id; parent is '6' (now text)
INSERT INTO parameters (
    parameter, whitelist, blacklist, weight,
    smtpd_recipient_restrictions,
    name, module, priority, default_value, editable, conf_file,
    description, parent, child, order1, enabled, applied, action,
    network_entry, note
)
SELECT
    'permit_sasl_authenticated',
    NULL, NULL, NULL,
    NULL,
    'Allow SASL Authenticated Users', 'postfix', NULL, NULL, 1, 'main.cf',
    NULL, '6', 1, 1.1, 1, 1, NULL,
    NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'permit_sasl_authenticated'
);

-- 5) Remove all rows that belong to the 'network' module
DELETE FROM parameters
WHERE module = 'network';

-- 6) For child rows, fill parent_name from the parent's parameter
UPDATE parameters AS c
JOIN parameters AS p
  ON CAST(c.parent AS UNSIGNED) = p.id
SET c.parent_name = p.parameter
WHERE c.child = 1
  AND c.parent IS NOT NULL;

-- ============================================================================
-- REMOTEAUTH TABLES: Remote Authentication Configuration
-- Allows pass-through authentication to external AD/LDAP servers
-- ============================================================================

-- Domain-to-server mappings for remote authentication
CREATE TABLE IF NOT EXISTS remoteauth_mappings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    domain_name VARCHAR(255) NOT NULL,         -- Domain name (e.g., 'deeztek')
    server_address VARCHAR(255) NOT NULL,      -- Server hostname/IP (e.g., 'homedc01.deeztek.com')
    server_port INT DEFAULT 389,               -- LDAP port (389 or 636)
    remote_dn_pattern VARCHAR(500) NULL,       -- Remote DN pattern (e.g., 'cn={firstname} {lastname},ou=Users,dc=deeztek,dc=com')
    tls_starttls VARCHAR(10) DEFAULT 'no',     -- Use STARTTLS (yes/no)
    tls_reqcert VARCHAR(20) DEFAULT 'never',   -- TLS cert requirement (never/allow/try/demand)
    ca_cert_file VARCHAR(255) NULL,            -- CA certificate filename (stored in /opt/hermes/certs/remoteauth/)
    retry_count INT DEFAULT 3,                 -- Number of auth retry attempts
    description VARCHAR(500) NULL,             -- Optional description
    enabled TINYINT(1) DEFAULT 1,              -- Enable/disable this mapping
    ldap_synced TINYINT(1) DEFAULT 0,          -- 0=not synced, 1=synced to LDAP
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_domain (domain_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add remote_dn_pattern column if table already exists (for upgrades)
ALTER TABLE remoteauth_mappings ADD COLUMN IF NOT EXISTS remote_dn_pattern VARCHAR(500) NULL AFTER server_port;

-- Add ca_cert_file column for TLS certificate path (for upgrades)
ALTER TABLE remoteauth_mappings ADD COLUMN IF NOT EXISTS ca_cert_file VARCHAR(255) NULL AFTER tls_reqcert;

-- Global settings for RemoteAuth overlay
CREATE TABLE IF NOT EXISTS remoteauth_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_name VARCHAR(100) NOT NULL UNIQUE,
    setting_value VARCHAR(500) NOT NULL,
    description VARCHAR(500) NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default settings (only if table is empty)
-- Note: OpenLDAP remoteauth is a SINGLETON overlay - only ONE overlay allowed per database
-- TLS settings are GLOBAL for all domain mappings (olcRemoteAuthTLS is SINGLE-VALUE)
-- Domain mappings are added as multi-valued olcRemoteAuthMapping attributes on the single overlay
INSERT INTO remoteauth_settings (setting_name, setting_value, description)
SELECT * FROM (
    SELECT 'enabled' AS setting_name, '0' AS setting_value, 'Master enable/disable for RemoteAuth overlay' AS description
    UNION ALL SELECT 'ldap_synced', '0', 'Whether settings have been synced to LDAP'
    UNION ALL SELECT 'tls_starttls', 'no', 'Global STARTTLS setting (yes/no) - applies to all domain mappings'
    UNION ALL SELECT 'tls_reqcert', 'never', 'Global TLS certificate requirement (never/allow/try/demand)'
    UNION ALL SELECT 'ca_cert_file', '', 'Global CA certificate filename (stored in /opt/hermes/certs/remoteauth/)'
    UNION ALL SELECT 'retry_count', '3', 'Global retry count for authentication attempts'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM remoteauth_settings LIMIT 1);

-- Add global TLS settings for existing installations (migration)
INSERT IGNORE INTO remoteauth_settings (setting_name, setting_value, description) VALUES
    ('tls_starttls', 'no', 'Global STARTTLS setting (yes/no) - applies to all domain mappings'),
    ('tls_reqcert', 'never', 'Global TLS certificate requirement (never/allow/try/demand)'),
    ('ca_cert_file', '', 'Global CA certificate filename (stored in /opt/hermes/certs/remoteauth/)'),
    ('retry_count', '3', 'Global retry count for authentication attempts');

-- ============================================================================
-- MSGS TABLE: Add index on time_iso for improved query performance
-- The time_iso column is heavily used in:
--   - Message history queries (WHERE time_iso BETWEEN ... AND ...)
--   - Quarantine reports (date range filtering)
--   - Message cleanup jobs (WHERE time_iso < ...)
--   - ORDER BY time_iso DESC (sorting by date)
-- ============================================================================

-- Create index on time_iso (will fail silently if index already exists)
-- Note: Run this manually if it fails: CREATE INDEX idx_msgs_time_iso ON msgs(time_iso);
CREATE INDEX IF NOT EXISTS idx_msgs_time_iso ON msgs(time_iso);

-- ============================================================================
-- INTRUSION PREVENTION TABLES: Fail2ban Management GUI
-- Allows administrators to manage fail2ban settings via web interface
-- ============================================================================

-- Global settings for Intrusion Prevention
CREATE TABLE IF NOT EXISTS intrusion_prevention_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_name VARCHAR(100) NOT NULL UNIQUE,
    setting_value VARCHAR(500) NOT NULL,
    description VARCHAR(500) NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default settings (only if table is empty)
INSERT INTO intrusion_prevention_settings (setting_name, setting_value, description)
SELECT * FROM (
    SELECT 'enabled' AS setting_name, '1' AS setting_value, 'Master enable/disable for Intrusion Prevention' AS description
    UNION ALL SELECT 'config_synced', '1', 'Whether jail config has been synced to fail2ban'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM intrusion_prevention_settings LIMIT 1);

-- Jail configurations (pre-populated with existing jails)
CREATE TABLE IF NOT EXISTS intrusion_prevention_jails (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jail_name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description VARCHAR(500) NULL,
    filter_name VARCHAR(100) NOT NULL,
    action_name VARCHAR(100) NOT NULL,
    logpath VARCHAR(500) NOT NULL,
    port VARCHAR(100) NULL,
    maxretry INT DEFAULT 5,
    findtime INT DEFAULT 86400,
    bantime INT DEFAULT 1800,
    enabled TINYINT(1) DEFAULT 1,
    config_synced TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pre-populate with existing jails (Option A - edit only, no add/delete)
-- Actions use iptables for blocking + API call for database logging
INSERT INTO intrusion_prevention_jails (jail_name, display_name, description, filter_name, action_name, logpath, port, maxretry, findtime, bantime, enabled)
SELECT * FROM (
    SELECT 'dovecot' AS jail_name, 'Mail Server (Dovecot)' AS display_name, 'Protects against brute force attacks on mail server authentication' AS description, 'dovecot' AS filter_name, 'hermes-iptables-dovecot' AS action_name, '/remotelogs/dovecot/dovecot-info.log' AS logpath, NULL AS port, 5 AS maxretry, 86400 AS findtime, 1800 AS bantime, 1 AS enabled
    UNION ALL SELECT 'authelia', 'SSO Portal (Authelia)', 'Protects against brute force attacks on Single Sign-On portal', 'authelia-auth', 'hermes-iptables-authelia', '/remotelogs/authelia/authelia.log', 'http,https,9091', 5, 86400, 1800, 1
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM intrusion_prevention_jails LIMIT 1);

-- Update action names for existing installations (migration from UFW to iptables)
UPDATE intrusion_prevention_jails SET action_name = 'hermes-iptables-dovecot' WHERE jail_name = 'dovecot' AND action_name = 'hermes-dovecot-action';
UPDATE intrusion_prevention_jails SET action_name = 'hermes-iptables-authelia' WHERE jail_name = 'authelia' AND action_name = 'hermes-authelia-action';

-- IP Whitelist (ignoreip entries)
CREATE TABLE IF NOT EXISTS intrusion_prevention_whitelist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip_cidr VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(500) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pre-populate with default whitelist from jail.local
INSERT INTO intrusion_prevention_whitelist (ip_cidr, description)
SELECT * FROM (
    SELECT '127.0.0.1/8' AS ip_cidr, 'Localhost IPv4' AS description
    UNION ALL SELECT '::1', 'Localhost IPv6'
    UNION ALL SELECT '172.16.0.0/12', 'Docker internal network'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM intrusion_prevention_whitelist LIMIT 1);

-- ============================================================================
-- FAIL2BAN_IPS TABLE: Add jail column for tracking which jail banned the IP
-- ============================================================================

ALTER TABLE fail2ban_ips ADD COLUMN IF NOT EXISTS jail VARCHAR(100) NULL AFTER ban_source;

-- ============================================================================
-- API_TOKENS TABLE: Update Fail2ban token IP for network_mode: host
-- With fail2ban using network_mode: host, API calls come from Docker gateway IP
-- ============================================================================

UPDATE api_tokens SET ip = '172.16.32.1' WHERE name = 'Fail2ban' AND ip = '172.16.32.102';

-- ============================================================================
-- SMTP SNI PARAMETER: tls_server_sni_maps for Postfix SNI support
-- This parameter is dynamically enabled/disabled based on validated certificates
-- ============================================================================

-- Insert parent parameter for tls_server_sni_maps (disabled by default)
INSERT INTO parameters (
    parameter, whitelist, blacklist, weight,
    smtpd_recipient_restrictions,
    name, module, priority, default_value, editable, conf_file,
    description, parent, child, order1, enabled, applied, action,
    network_entry, note
)
SELECT
    'tls_server_sni_maps',
    NULL, NULL, NULL,
    NULL,
    'TLS Server SNI Maps', 'postfix', NULL, NULL, 0, 'main.cf',
    'Server Name Indication certificate mappings', NULL, 2, NULL, 0, 1, NULL,
    NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'tls_server_sni_maps' AND child = 2
);

-- Insert child parameter using parent_name (new schema pattern)
INSERT INTO parameters (
    parameter, whitelist, blacklist, weight,
    smtpd_recipient_restrictions,
    name, module, priority, default_value, editable, conf_file,
    description, parent, parent_name, child, order1, enabled, applied, action,
    network_entry, note
)
SELECT
    'hash:/etc/postfix/sni_maps',
    NULL, NULL, NULL,
    NULL,
    'SNI Maps File', 'postfix', NULL, NULL, 0, 'main.cf',
    NULL,
    NULL,
    'tls_server_sni_maps',
    1, 1, 0, 1, NULL,
    NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'hash:/etc/postfix/sni_maps' AND child = 1
);

-- ============================================================================
-- SYSTEM_SETTINGS TABLE: Increase value column size for encrypted data storage
-- The signed_fingerprint parameter stores AES-encrypted fingerprint+signature
-- which can exceed 500 characters after encryption and Base64 encoding
-- ============================================================================

-- Only modify if column is smaller than 1024 characters
SET @col_size = (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'system_settings' AND COLUMN_NAME = 'value');
SET @sql = IF(@col_size < 1024, 'ALTER TABLE system_settings MODIFY value VARCHAR(1024)', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================================================
-- SYSTEM_SETTINGS TABLE: Add cleanup_threshold for retention policy storage
-- This stores encrypted configuration data for message cleanup policies
-- ============================================================================

INSERT INTO system_settings (parameter, value)
SELECT 'cleanup_threshold', ''
WHERE NOT EXISTS (
    SELECT 1 FROM system_settings WHERE parameter = 'cleanup_threshold'
);

-- Note: Template fingerprint data is stored in 'signed_fingerprint' parameter
-- (populated by storeSignedFingerprint() in manifest_verify.cfm)

-- ============================================================================
-- PARAMETERS TABLE: Add smtp_tls_security_level for outbound relay TLS
-- Controls TLS behavior when connecting to relay host (outbound connections)
-- Values: may (opportunistic), encrypt (mandatory), none (disabled)
-- ============================================================================

-- Parent parameter for smtp_tls_security_level (disabled by default)
INSERT INTO parameters (
    parameter, whitelist, blacklist, weight,
    smtpd_recipient_restrictions,
    name, module, priority, default_value, editable, conf_file,
    description, parent, child, order1, enabled, applied, action,
    network_entry, note
)
SELECT
    'smtp_tls_security_level',
    NULL, NULL, NULL,
    NULL,
    'Outbound TLS Security Level', 'postfix', NULL, NULL, 0, 'main.cf',
    'TLS security level for outbound SMTP connections to relay host', NULL, 2, NULL, 0, 1, NULL,
    NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parameter = 'smtp_tls_security_level' AND child = 2
);

-- Child parameter with default value 'may' (opportunistic TLS)
INSERT INTO parameters (
    parameter, whitelist, blacklist, weight,
    smtpd_recipient_restrictions,
    name, module, priority, default_value, editable, conf_file,
    description, parent, parent_name, child, order1, enabled, applied, action,
    network_entry, note
)
SELECT
    'may',
    NULL, NULL, NULL,
    NULL,
    'Opportunistic TLS', 'postfix', NULL, NULL, 0, 'main.cf',
    NULL,
    NULL,
    'smtp_tls_security_level',
    1, 1, 0, 1, NULL,
    NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM parameters WHERE parent_name = 'smtp_tls_security_level' AND child = 1
);

-- ============================================================================
-- PASSWORD RESET REQUESTS TABLE: LDAP Password Reset Flow
-- Stores password reset requests for all user types (relay, mailbox, admin)
-- ============================================================================

CREATE TABLE IF NOT EXISTS password_reset_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    ldap_username VARCHAR(255) NOT NULL,
    user_type ENUM('relay', 'mailbox', 'admin') NOT NULL,
    token VARCHAR(64) NULL,
    notification_method ENUM('email', 'pushover', 'admin') NOT NULL,
    status ENUM('pending', 'completed', 'expired', 'cancelled') DEFAULT 'pending',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    completed_by VARCHAR(255) NULL,
    INDEX idx_prr_email (email),
    INDEX idx_prr_token (token),
    INDEX idx_prr_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- USER_SETTINGS TABLE: Add columns for LDAP integration and password recovery
-- - ldap_username: Links to LDAP cn for this user
-- - secondary_email: Backup email for password recovery (mailbox users)
-- ============================================================================

ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS ldap_username VARCHAR(255) NULL;
ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS secondary_email VARCHAR(255) NULL;
ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS secondary_email_verified TINYINT(1) DEFAULT 0;
ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS secondary_email_token VARCHAR(64) NULL;
ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS secondary_email_token_expires TIMESTAMP NULL;

-- ============================================================================
-- SYSTEM_SETTINGS: Pushover configuration for admin notifications
-- System-wide config for critical alerts (mail queue issues, security events)
-- where email delivery may fail. Uses Pushover group key to notify all admins.
-- ============================================================================

INSERT INTO system_settings (parameter, value)
SELECT 'pushover_enabled', '0' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'pushover_enabled');

INSERT INTO system_settings (parameter, value)
SELECT 'pushover_api_token', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'pushover_api_token');

INSERT INTO system_settings (parameter, value)
SELECT 'pushover_user_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'pushover_user_key');

-- ============================================================================
-- SYSTEM_SETTINGS: CAPTCHA configuration for bot protection
-- Used on public-facing forms (forgot password, etc.) to prevent abuse
-- Supports multiple providers: builtin (math), recaptcha, hcaptcha, turnstile
-- ============================================================================

-- CAPTCHA Provider: 'builtin' (default), 'recaptcha', 'hcaptcha', 'turnstile'
INSERT INTO system_settings (parameter, value)
SELECT 'captcha_provider', 'builtin' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'captcha_provider');

-- Migration: Convert old recaptcha_enabled to captcha_provider
UPDATE system_settings SET value = 'recaptcha'
WHERE parameter = 'captcha_provider' AND value = 'builtin'
AND EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'recaptcha_enabled' AND value = '1');

-- Clean up old recaptcha_enabled parameter after migration
DELETE FROM system_settings WHERE parameter = 'recaptcha_enabled';

-- Google reCAPTCHA v2 keys
INSERT INTO system_settings (parameter, value)
SELECT 'recaptcha_site_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'recaptcha_site_key');

INSERT INTO system_settings (parameter, value)
SELECT 'recaptcha_secret_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'recaptcha_secret_key');

-- hCaptcha keys
INSERT INTO system_settings (parameter, value)
SELECT 'hcaptcha_site_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'hcaptcha_site_key');

INSERT INTO system_settings (parameter, value)
SELECT 'hcaptcha_secret_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'hcaptcha_secret_key');

-- Cloudflare Turnstile keys
INSERT INTO system_settings (parameter, value)
SELECT 'turnstile_site_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'turnstile_site_key');

INSERT INTO system_settings (parameter, value)
SELECT 'turnstile_secret_key', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'turnstile_secret_key');

-- ============================================================================
-- USER_SETTINGS TABLE: Remove obsolete columns from legacy authentication
-- These columns are no longer used since password management moved to LDAP:
-- - id: Legacy random string used for old password reset URLs
-- - password: Legacy stored password (now managed in LDAP)
-- - password_set: Legacy flag for tracking password status
-- - reset_password_code: Legacy password reset token
-- - reset_password_datetime: Legacy reset token timestamp
-- - reset_password_ip: Legacy IP address tracking
-- ============================================================================

-- Drop obsolete columns (will fail silently if columns don't exist)
ALTER TABLE user_settings DROP COLUMN IF EXISTS id;
ALTER TABLE user_settings DROP COLUMN IF EXISTS password;
ALTER TABLE user_settings DROP COLUMN IF EXISTS password_set;
ALTER TABLE user_settings DROP COLUMN IF EXISTS reset_password_code;
ALTER TABLE user_settings DROP COLUMN IF EXISTS reset_password_datetime;
ALTER TABLE user_settings DROP COLUMN IF EXISTS reset_password_ip;

-- ============================================================================
-- AUTHELIA DATABASE: MySQL Setup for 2FA Device Storage
-- Migrates Authelia from SQLite to MySQL for better scalability
--
-- IMPORTANT: Authelia auto-creates its schema tables on first startup with MySQL:
--   - authentication_logs, duo_devices, encryption, identity_verification
--   - migrations, totp_configurations, u2f_devices, user_preferences, webauthn_devices
--
-- WARNING: Migrating from SQLite to MySQL will LOSE ALL EXISTING 2FA DEVICES!
-- Users will need to re-register their TOTP/WebAuthn devices after migration.
-- There is no clean migration path for 2FA device data between storage backends.
-- ============================================================================

-- Create Authelia database (separate from hermes)
CREATE DATABASE IF NOT EXISTS authelia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;

-- Create Authelia user only if it doesn't exist
-- Note: Password should be changed immediately after initial setup via:
--   ALTER USER 'authelia'@'%' IDENTIFIED BY 'your_secure_password';
SET @authelia_user_exists = (SELECT COUNT(*) FROM mysql.user WHERE user = 'authelia' AND host = '%');
SET @sql = IF(@authelia_user_exists = 0,
    "CREATE USER 'authelia'@'%' IDENTIFIED BY 'CHANGE_ME_AUTHELIA_DB_PASSWORD'",
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Grant privileges only if not already granted
-- This avoids the "Access denied" error when root@% tries to re-grant on existing database
SET @authelia_grant_exists = (SELECT COUNT(*) FROM mysql.db WHERE User = 'authelia' AND Host = '%' AND Db = 'authelia');
SET @sql = IF(@authelia_grant_exists = 0,
    "GRANT ALL PRIVILEGES ON authelia.* TO 'authelia'@'%'",
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
FLUSH PRIVILEGES;

-- ============================================================================
-- AUTHELIA CONFIGURATION NOTE:
-- After running this script, update Authelia's configuration.yml:
--
-- storage:
--   mysql:
--     address: 'tcp://hermes_db_server:3306'
--     database: 'authelia'
--     username: 'authelia'
--     password: '<use secret file or env var>'
--     timeout: '5s'
--
-- Remove the SQLite configuration:
-- storage:
--   local:
--     path: /db/db.sqlite3  <-- DELETE THIS SECTION
-- ============================================================================

-- ============================================================================
-- RECIPIENTS TABLE: Add auth_type and remoteauth_domain columns
-- auth_type: 'local' for local authentication, 'remote' for RemoteAuth (Pro only)
-- remoteauth_domain: The domain name for remote authentication (references remoteauth_mappings)
-- ============================================================================

ALTER TABLE recipients ADD COLUMN IF NOT EXISTS auth_type VARCHAR(10) NOT NULL DEFAULT 'local';
ALTER TABLE recipients ADD COLUMN IF NOT EXISTS remoteauth_domain VARCHAR(255) NULL;

-- Set existing recipients to local authentication
UPDATE recipients SET auth_type = 'local' WHERE auth_type IS NULL OR auth_type = '';

-- ============================================================================
-- RECIPIENTS TABLE: Per-Recipient Backend Override
-- Allows relay recipients to use a different backend server than their domain default
-- NULL values = use domain default (via COALESCE in transport_maps query)
-- ============================================================================

ALTER TABLE recipients ADD COLUMN IF NOT EXISTS backend_server VARCHAR(255) NULL
    COMMENT 'Override backend server (NULL = use domain default)';

ALTER TABLE recipients ADD COLUMN IF NOT EXISTS backend_port INT NULL
    COMMENT 'Override backend port (NULL = use domain default)';

ALTER TABLE recipients ADD COLUMN IF NOT EXISTS backend_tls ENUM('none', 'may', 'encrypt') NULL
    COMMENT 'Override TLS setting (NULL = use domain default)';

-- ============================================================================
-- CERT_GENERATION_QUEUE TABLE: Background S/MIME & PGP Generation
-- Queues certificate/keyring generation jobs for bulk relay recipient creation
-- Processed by scheduled task (process_cert_queue.cfm) in batches of 5
-- ============================================================================

CREATE TABLE IF NOT EXISTS cert_generation_queue (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_id INT NOT NULL,
    recipient_email VARCHAR(255) NOT NULL,
    job_type ENUM('smime', 'pgp') NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed') NOT NULL DEFAULT 'pending',
    -- S/MIME fields
    ca_id INT NULL,
    validity INT NULL,
    encryption INT NULL,
    algorithm VARCHAR(10) NULL,
    -- PGP fields
    pgp_key_length INT NULL,
    pgp_name_real VARCHAR(255) NULL,
    -- Common
    password VARCHAR(255) NULL COMMENT 'Plaintext password (temporary, cleared after processing)',
    error_message TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at DATETIME NULL,
    completed_at DATETIME NULL,
    INDEX idx_queue_status (status),
    INDEX idx_queue_recipient (recipient_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- DROP rbl_override TABLE (legacy, never activated)
-- The rbl_override table was intended for a MySQL-based check_client_access
-- override at the smtpd level. This was superseded by postscreen_access.cidr
-- (managed via Network Block/Allow) which handles the same function at the
-- postscreen level. The check_client_access directive was never enabled in
-- main.cf and the table is no longer referenced by any active code.
-- ============================================================================
DROP TABLE IF EXISTS rbl_override;

-- ============================================================================
-- DROP AD Integration tables (feature removed)
-- The Active Directory integration feature (scheduled LDAP sync to import
-- recipients from AD) has been removed. The scheduled task infrastructure
-- used legacy direct daemon calls incompatible with Docker, relied on a
-- deprecated license count model, and the users table rebuild pattern
-- (stop services, DROP users, CREATE LIKE recipients, INSERT SELECT, ALTER
-- RENAME column, restart services) was disruptive and unnecessary.
-- The users table was a derived copy of recipients with 'recipient' renamed
-- to 'email' for Amavis compatibility; Amavis now queries recipients directly.
-- ============================================================================
DROP TABLE IF EXISTS ad_integration;
DROP TABLE IF EXISTS ad_import_temp;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS mailaddr_temp;

-- ============================================================================
-- CLEANUP orphaned mailaddr entries
-- mailaddr stores sender addresses for wblist (block/allow) rules. Over time,
-- entries accumulate that are no longer referenced by any wblist row (e.g. after
-- rules are deleted). This removes those orphans. Going forward, the delete
-- action handler cleans up orphans automatically after each deletion.
-- ============================================================================
DELETE FROM mailaddr
WHERE id NOT IN (SELECT DISTINCT sid FROM wblist);

-- ============================================================================
-- OFELIA_JOBS TABLE: Add DMARC report and update check scheduled jobs
-- These were previously managed via /etc/cron.d/ (set_crontab.cfm) which
-- doesn't work in Docker. Now managed through Ofelia like all other jobs.
-- active: 1 = enabled, 2 = disabled
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-dmarc-report"]', '0 30 02 * * *', '/opt/hermes/schedule/dmarc_report_script.sh', 'hermes_commandbox', '2', 'dmarc'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-dmarc-report"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-update-check"]', '0 30 04 * * *', '/opt/hermes/schedule/update_check.sh', 'hermes_commandbox', '1', 'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-update-check"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-health-check-mailqueue"]', '@every 15m', '/usr/bin/curl --silent http://localhost:8888/schedule/health_check_mailqueue.cfm', 'hermes_commandbox', '2', 'pushover'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-health-check-mailqueue"]'
);

-- ============================================================================
-- PUSHOVER_NOTIFICATIONS TABLE: Registry of available Pushover notifications
-- Each notification links to an ofelia_jobs entry for scheduling.
-- enabled: 1 = on, 2 = off
-- category: grouping for UI display (health, security, reports, etc.)
-- ============================================================================

CREATE TABLE IF NOT EXISTS pushover_notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    ofelia_job_name VARCHAR(255),
    enabled TINYINT(3) NOT NULL DEFAULT 2,
    category VARCHAR(50) NOT NULL DEFAULT 'health'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed initial notification: Mail Queue Health Check
INSERT INTO pushover_notifications (name, display_name, description, ofelia_job_name, enabled, category)
SELECT 'mailqueue_check', 'Mail Queue Health Check', 'Monitors the Postfix mail queue and sends a Pushover alert when the queue size exceeds the configured threshold. Runs every 15 minutes.', '[job-exec "hermes-health-check-mailqueue"]', '2', 'health'
WHERE NOT EXISTS (
    SELECT 1 FROM pushover_notifications WHERE name = 'mailqueue_check'
);

