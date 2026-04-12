-- Hermes SEG Schema Updates - 2026-01-19
-- LDAP User Management Integration & Parameters Table Updates
--
-- Run this script against the hermes database:
-- docker exec -i hermes_db_server mysql -u root hermes < /path/to/schema_updates.sql
--
-- DBeaver: Set delimiter to "//" before running (Edit > Preferences > SQL Editor > Statement Delimiter)
-- or run each section individually.

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

-- 5b) Clean up legacy network module in parameters2 (keep server_ip, server_name, server_domain)
DELETE FROM parameters2
WHERE module = 'network' AND parameter NOT IN ('server_ip', 'server_name', 'server_domain');

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
DELIMITER //
SET @col_size = (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'system_settings' AND COLUMN_NAME = 'value');
SET @sql = IF(@col_size < 1024, 'ALTER TABLE system_settings MODIFY value VARCHAR(1024)', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
//
DELIMITER ;

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

-- Per-user IANA timezone (e.g. America/New_York). Used by vacation auto-reply,
-- dashboard timestamps, and notification scheduling so per-user times stay
-- correct in multi-tenant deployments where users may be in different zones.
ALTER TABLE user_settings ADD COLUMN IF NOT EXISTS timezone VARCHAR(64) NULL;

-- ============================================================================
-- Authelia Remember Me Duration parameter
-- ============================================================================
-- Adds an admin-configurable session.remember_me row to parameters2 so the
-- value can be set from the Authentication Settings page instead of being
-- hardcoded in the configuration.yml template. Default is 43200 seconds
-- (12 hours), matching NIST 800-63B AAL2 extended-session reauth ceiling.
--
-- Important security context: Authelia bypasses the Inactivity check entirely
-- for sessions where "Remember Me" is ticked at login (verified in v4.39
-- source at internal/handlers/handler_authz_authn.go line 495). The value
-- below is therefore a hard absolute lifetime with NO inactivity protection.
-- Set to -1 to disable the "Remember Me" checkbox in the login form entirely.
INSERT INTO parameters2 (module, parameter, value2, applied)
SELECT 'authelia', 'session.remember_me', '43200', '2'
WHERE NOT EXISTS (
    SELECT 1 FROM parameters2
    WHERE module = 'authelia' AND parameter = 'session.remember_me'
);

-- ============================================================================
-- Nextcloud OIDC auto-redirect parameter
-- ============================================================================
-- Controls the oidc_login_auto_redirect setting in Nextcloud's config.php.
-- When 'true', users hitting /nc/ are silently bounced through Authelia OIDC
-- and land in Nextcloud already logged in (one-click SSO from Hermes user
-- portal). When 'false', users see Nextcloud's native login page with the
-- "Click to Login to Webmail" button (two-click SSO, but the local-user
-- password form is reachable for any non-LDAP Nextcloud accounts).
--
-- Default 'false' on upgrade preserves existing behavior. Admin can flip to
-- 'true' from Authentication Settings if seamless SSO is preferred over
-- local-user support.
INSERT INTO parameters2 (module, parameter, value2, applied)
SELECT 'nextcloud', 'oidc.auto_redirect', 'false', '2'
WHERE NOT EXISTS (
    SELECT 1 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'oidc.auto_redirect'
);

-- Backfill: existing rows get the system timezone configured by the admin
-- in System Settings (system_settings.parameter='timezone'), which is the
-- canonical IANA name (e.g. America/New_York). Falls back to MariaDB's
-- session timezone, then UTC, if for some reason the system_settings row
-- is missing or empty. Idempotent - only touches NULLs.
--
-- Note: we don't use @@session.time_zone as the primary source because
-- MariaDB returns 'SYSTEM' by default unless mysql_tzinfo_to_sql has been
-- run to load the timezone tables, even when the container TZ env var is
-- set correctly. system_settings is the reliable source.
UPDATE user_settings us
LEFT JOIN system_settings ss ON ss.parameter = 'timezone'
SET us.timezone = COALESCE(
    NULLIF(TRIM(ss.value), ''),
    CASE
        WHEN @@session.time_zone = 'SYSTEM' THEN 'UTC'
        WHEN @@session.time_zone REGEXP '^[+-][0-9]{2}:[0-9]{2}$' THEN 'UTC'
        ELSE @@session.time_zone
    END
)
WHERE us.timezone IS NULL OR us.timezone = '';

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
DELIMITER //
SET @authelia_user_exists = (SELECT COUNT(*) FROM mysql.user WHERE user = 'authelia' AND host = '%');
SET @sql = IF(@authelia_user_exists = 0,
    "CREATE USER 'authelia'@'%' IDENTIFIED BY 'CHANGE_ME_AUTHELIA_DB_PASSWORD'",
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
//
DELIMITER ;

-- Grant privileges only if not already granted
-- This avoids the "Access denied" error when root@% tries to re-grant on existing database
DELIMITER //
SET @authelia_grant_exists = (SELECT COUNT(*) FROM mysql.db WHERE User = 'authelia' AND Host = '%' AND Db = 'authelia');
SET @sql = IF(@authelia_grant_exists = 0,
    "GRANT ALL PRIVILEGES ON authelia.* TO 'authelia'@'%'",
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
//
DELIMITER ;
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
SELECT '[job-exec "hermes-dmarc-report"]', '0 30 02 * * *', '/opt/hermes/schedule/dmarc_report_script.sh', 'hermes_dmarc', '2', 'dmarc'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-dmarc-report"]'
);

-- Fix DMARC report job container (was hermes_commandbox, needs hermes_dmarc for opendmarc binaries)
UPDATE ofelia_jobs SET container = 'hermes_dmarc'
WHERE job_name = '[job-exec "hermes-dmarc-report"]' AND container = 'hermes_commandbox';

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

-- ============================================================================
-- FIX: Ensure core Postfix parameters are always enabled
-- myorigin and myhostname must be enabled for generate_postfix_configuration.cfm
-- to include them in the postconf script. If disabled, the template defaults
-- (domain.tld / hermes.domain.tld) persist in main.cf after config regeneration.
-- ============================================================================

UPDATE parameters SET enabled = '1'
WHERE parameter IN ('myorigin', 'myhostname')
  AND child = '2' AND module = 'postfix' AND enabled = '2';

-- ============================================================================
-- FIX: Consolidate SASL password maps to use sasl_passwd instead of relay_passwd
-- Both relay host and per-domain transport credentials are now written to
-- /etc/postfix/sasl_passwd by generate_sasl_password_transport.cfm
-- ============================================================================

UPDATE parameters SET parameter = 'hash:/etc/postfix/sasl_passwd'
WHERE parent_name = 'smtp_sasl_password_maps' AND child = '1'
  AND parameter = 'hash:/etc/postfix/relay_passwd';

-- Enable smtp_sasl_password_maps and smtp_sasl_auth_enable if any domain uses auth
-- (relay host page disables these when relay auth is off, but per-domain auth still needs them)
UPDATE parameters p
  JOIN (SELECT COUNT(*) AS cnt FROM transport WHERE authentication = 'YES') t ON t.cnt > 0
SET p.enabled = '1', p.applied = '2', p.action = 'APPLY'
WHERE p.parameter = 'smtp_sasl_password_maps' AND p.child = '2';

UPDATE parameters p
  JOIN (SELECT COUNT(*) AS cnt FROM transport WHERE authentication = 'YES') t ON t.cnt > 0
SET p.enabled = '1', p.applied = '2', p.action = 'APPLY'
WHERE p.parameter = 'smtp_sasl_auth_enable' AND p.child = '2';

-- Fix parent_name for smtp_sasl children (may be incorrectly set to 'postfix')
UPDATE parameters SET parent_name = 'smtp_sasl_auth_enable'
WHERE parent = (SELECT id FROM (SELECT id FROM parameters WHERE parameter = 'smtp_sasl_auth_enable' AND child = '2') tmp)
  AND child = '1' AND parent_name <> 'smtp_sasl_auth_enable';

UPDATE parameters SET parent_name = 'smtp_sasl_password_maps'
WHERE parent = (SELECT id FROM (SELECT id FROM parameters WHERE parameter = 'smtp_sasl_password_maps' AND child = '2') tmp)
  AND child = '1' AND parent_name <> 'smtp_sasl_password_maps';

UPDATE parameters p
  JOIN (SELECT COUNT(*) AS cnt FROM transport WHERE authentication = 'YES') t ON t.cnt > 0
SET p.parameter = 'yes', p.enabled = '1', p.applied = '2', p.action = 'APPLY'
WHERE p.parent_name = 'smtp_sasl_auth_enable' AND p.child = '1';

UPDATE parameters p
  JOIN (SELECT COUNT(*) AS cnt FROM transport WHERE authentication = 'YES') t ON t.cnt > 0
SET p.enabled = '1', p.applied = '2', p.action = 'APPLY'
WHERE p.parent_name = 'smtp_sasl_password_maps' AND p.child = '1';

-- ============================================================================
-- SYSTEM_SETTINGS: Encrypted relay host credentials
-- Migrates plaintext relay host credentials from parameters.name to
-- encrypted system_settings entries. Credentials encrypted with AES
-- using /opt/hermes/keys/hermes.key (same as per-domain transport auth).
-- ============================================================================

INSERT INTO system_settings (parameter, value)
SELECT 'relay_host_username', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'relay_host_username');

INSERT INTO system_settings (parameter, value)
SELECT 'relay_host_password', '' WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE parameter = 'relay_host_password');

-- ============================================================================
-- SYSTEM_CERTIFICATES TABLE: Add AUTO_INCREMENT to id column
-- The id column was missing AUTO_INCREMENT, requiring manual MAX(id)+1 logic
-- which is error-prone (NULL ids on insert without explicit id value).
-- Safe to run multiple times: MODIFY with AUTO_INCREMENT is idempotent.
-- ============================================================================

-- Clean up any rows with NULL id (from prior inserts without explicit id)
DELETE FROM system_certificates WHERE id IS NULL;

-- Add primary key if not already set (required for AUTO_INCREMENT)
DELIMITER //
SET @pk_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'system_certificates' AND CONSTRAINT_TYPE = 'PRIMARY KEY');
SET @sql = IF(@pk_exists = 0,
    'ALTER TABLE system_certificates ADD PRIMARY KEY (id)',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
//
DELIMITER ;

ALTER TABLE system_certificates MODIFY id INT NOT NULL AUTO_INCREMENT;

-- ============================================================================
-- PARAMETERS2: Authelia log retention (days)
-- Controls how many days of rotated Authelia logs to keep.
-- Used by rotate_authelia_logs.sh scheduled via Ofelia.
-- ============================================================================

INSERT INTO parameters2 (parameter, module, value2)
SELECT 'log.retention_days', 'authelia', '30'
WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE parameter = 'log.retention_days' AND module = 'authelia');

-- ============================================================================
-- OFELIA_JOBS TABLE: Add Authelia log rotation scheduled job
-- Runs daily at 2:00 AM to rotate Authelia logs with date-stamped filenames.
-- Requires Authelia 4.39+ for SIGHUP log file reopening.
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-authelia-log-rotate"]', '0 0 02 * * *', '/opt/hermes/schedule/rotate_authelia_logs.sh', 'hermes_commandbox', '1', 'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-authelia-log-rotate"]'
);

-- ============================================================================
-- MSGRCPT TABLE: Add notification_sent column for near real-time quarantine
-- notifications. Tracks whether a quarantine notification email has been sent
-- for each quarantined message. (0=pending, 1=sent, 2=user opted out)
-- See GitHub issue #180
-- ============================================================================

ALTER TABLE msgrcpt ADD COLUMN IF NOT EXISTS notification_sent TINYINT(3) NOT NULL DEFAULT 0;

-- Composite index for quarantine notification polling query
-- Covers: WHERE ds IN ('B','D') AND notification_sent = 0
CREATE INDEX IF NOT EXISTS idx_msgrcpt_notify ON msgrcpt(ds, notification_sent);

-- ============================================================================
-- OFELIA_JOBS TABLE: Add near real-time quarantine notification job
-- Runs every 60s to send individual notification emails for newly quarantined
-- messages. Replaces the batch quarantine digest reports.
-- See GitHub issue #180
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-quarantine-notify"]',
       '@every 60s',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_notify.cfm',
       'hermes_commandbox',
       '1',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-quarantine-notify"]'
);

-- ============================================================================
-- USER_SETTINGS: Migrate 'ALL' report_enabled to 'YES' for near real-time
-- notifications. The 'ALL' option (send report even if no quarantined messages)
-- is no longer relevant since notifications are per-message.
-- See GitHub issue #180
-- ============================================================================

UPDATE user_settings SET report_enabled = 'YES' WHERE report_enabled = 'ALL';

-- Drop obsolete report_frequency column (no longer used with per-message notifications)
ALTER TABLE user_settings DROP COLUMN IF EXISTS report_frequency;

-- ============================================================================
-- OFELIA_JOBS TABLE: Add no_overlap column for jobs that should not run
-- concurrently (e.g., quarantine notifications every 60s).
-- See GitHub issue #180
-- ============================================================================

ALTER TABLE ofelia_jobs ADD COLUMN IF NOT EXISTS no_overlap TINYINT(3) NOT NULL DEFAULT 0;

UPDATE ofelia_jobs SET no_overlap = 1
WHERE job_name = '[job-exec "hermes-quarantine-notify"]' AND no_overlap = 0;

-- ============================================================================
-- OFELIA_JOBS TABLE: Ensure cert queue processor exists and set no_overlap
-- Processes S/MIME certificate and PGP keyring generation queue every 60s.
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type, no_overlap)
SELECT '[job-exec "hermes-process-cert-queue"]',
       '@every 60s',
       '/usr/bin/curl --silent http://localhost:8888/schedule/process_cert_queue.cfm',
       'hermes_commandbox',
       '1',
       'system',
       1
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-process-cert-queue"]'
);

UPDATE ofelia_jobs SET no_overlap = 1
WHERE job_name = '[job-exec "hermes-process-cert-queue"]' AND no_overlap = 0;

-- ============================================================================
-- OFELIA_JOBS TABLE: Ensure remaining core jobs exist (safety net for new installs)
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "renew-acme-certificate"]',
       '0 05 12 * * *',
       '/opt/hermes/schedule/renew_acme_certificate.sh',
       'hermes_commandbox',
       '1',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "renew-acme-certificate"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-message-cleanup"]',
       '0 30 01 * * *',
       '/usr/bin/curl --silent http://localhost:8888/schedule/message_cleanup.cfm',
       'hermes_commandbox',
       '1',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-message-cleanup"]'
);

-- ============================================================================
-- OFELIA_JOBS TABLE: Disable legacy quarantine report jobs
-- (replaced by hermes-quarantine-notify, see GitHub issue #180)
-- Inserts are for new installs that may not have these rows yet.
-- ============================================================================
INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-quarantine-report-2-hours"]',
       '@every 2h',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=2',
       'hermes_commandbox',
       '2',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-quarantine-report-2-hours"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-quarantine-report-4-hours"]',
       '@every 4h',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=4',
       'hermes_commandbox',
       '2',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-quarantine-report-4-hours"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-quarantine-report-8-hours"]',
       '@every 8h',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report.cfm?frequency=8',
       'hermes_commandbox',
       '2',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-quarantine-report-8-hours"]'
);

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-quarantine-report-daily"]',
       '0 30 12 * * *',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_report_daily.cfm',
       'hermes_commandbox',
       '2',
       'system'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-quarantine-report-daily"]'
);

-- Disable legacy quarantine report jobs for existing installs that may have them active
UPDATE ofelia_jobs SET active = '2'
WHERE job_name IN (
    '[job-exec "hermes-quarantine-report-2-hours"]',
    '[job-exec "hermes-quarantine-report-4-hours"]',
    '[job-exec "hermes-quarantine-report-8-hours"]',
    '[job-exec "hermes-quarantine-report-daily"]'
) AND active = '1';


-- ============================================================
-- SYSLOG DATABASE INDEXES (GitHub #184)
-- ============================================================

USE Syslog;

-- Index on ReceivedAt for date range filtering, sorting, and cleanup deletions
CREATE INDEX IF NOT EXISTS idx_systemevents_receivedat ON SystemEvents(ReceivedAt);

-- Composite index on SysLogTag + ReceivedAt for facility-filtered queries
CREATE INDEX IF NOT EXISTS idx_systemevents_tag_receivedat ON SystemEvents(SysLogTag, ReceivedAt);

-- Switch back to hermes for any subsequent statements
USE hermes;

-- ============================================================================
-- MALWARE FEEDS: Tables for managing Fangfrisch malware signature feeds
-- ============================================================================

CREATE TABLE IF NOT EXISTS malware_feeds_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_name VARCHAR(100) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    enabled TINYINT(3) NOT NULL DEFAULT 0,
    is_builtin TINYINT(3) NOT NULL DEFAULT 0,
    prefix VARCHAR(500) NULL,
    interval_value VARCHAR(20) NULL,
    max_size VARCHAR(20) NULL,
    integrity_check VARCHAR(20) NULL,
    api_key_1_name VARCHAR(50) NULL,
    api_key_1_value VARCHAR(500) NULL,
    api_key_2_name VARCHAR(50) NULL,
    api_key_2_value VARCHAR(500) NULL,
    description TEXT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    UNIQUE KEY uq_section_name (section_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS malware_feed_urls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    feed_id INT NOT NULL,
    url_key VARCHAR(255) NOT NULL,
    url_value VARCHAR(1000) NOT NULL,
    enabled TINYINT(3) NOT NULL DEFAULT 1,
    filename_override VARCHAR(255) NULL,
    sort_order INT NOT NULL DEFAULT 100,
    UNIQUE KEY uq_feed_url (feed_id, url_key),
    FOREIGN KEY (feed_id) REFERENCES malware_feeds_config(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Global DEFAULT settings for malware feeds
INSERT INTO parameters2 (parameter, value2, module, active)
SELECT 'log_level', 'info', 'malware_feeds', '1'
WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE parameter = 'log_level' AND module = 'malware_feeds');

INSERT INTO parameters2 (parameter, value2, module, active)
SELECT 'max_size', '5MB', 'malware_feeds', '1'
WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE parameter = 'max_size' AND module = 'malware_feeds');

INSERT INTO parameters2 (parameter, value2, module, active)
SELECT 'on_update_timeout', '42', 'malware_feeds', '1'
WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE parameter = 'on_update_timeout' AND module = 'malware_feeds');

-- ============================================================================
-- MALWARE FEEDS: Seed data from default fangfrisch.conf
-- ============================================================================

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'sanesecurity', 'SaneSecurity', 1, 1, 'https://ftp.swin.edu.au/sanesecurity/', '1h', '10M', NULL, NULL, NULL, 'SaneSecurity ClamAV signatures (built-in feed)', 10
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'sanesecurity');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'urlhaus', 'URLhaus', 1, 1, NULL, NULL, '2MB', NULL, NULL, NULL, 'URLhaus malicious URL signatures (built-in feed)', 20
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'urlhaus');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'malwarepatrol', 'MalwarePatrol', 0, 1, NULL, NULL, NULL, NULL, 'receipt', 'product', 'MalwarePatrol commercial feed (requires receipt and product ID)', 30
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'malwarepatrol');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'malwareexpert', 'MalwareExpert', 0, 1, 'https://signatures.malware.expert', '1d', '20M', NULL, 'serial_key', NULL, 'MalwareExpert commercial feed (requires serial key)', 40
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'malwareexpert');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'securiteinfo', 'SecuriteInfo', 0, 1, NULL, NULL, NULL, NULL, 'customer_id', NULL, 'SecuriteInfo commercial feed (requires customer ID)', 50
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'securiteinfo');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'twinwave', 'TwinWave', 1, 1, 'https://raw.githubusercontent.com/twinwave-security/twinclams/master/', '1h', '2M', 'disabled', NULL, NULL, 'TwinWave Security ClamAV signatures', 60
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'twinwave');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'clampunch', 'ClamPunch', 1, 1, 'https://raw.githubusercontent.com/wmetcalf/clam-punch/master/', '24h', '2M', 'disabled', NULL, NULL, 'ClamPunch malware signatures', 70
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'clampunch');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'rfxn', 'RFXN', 1, 1, 'https://www.rfxn.com/downloads/', '4h', '10M', 'disabled', NULL, NULL, 'R-fx Networks Linux Malware Detect signatures', 80
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'rfxn');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'interserver', 'InterServer', 1, 1, 'https://sigs.interserver.net/', '1d', NULL, 'disabled', NULL, NULL, 'InterServer ClamAV signatures', 90
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'interserver');

INSERT INTO malware_feeds_config (section_name, display_name, enabled, is_builtin, prefix, interval_value, max_size, integrity_check, api_key_1_name, api_key_2_name, description, sort_order)
SELECT 'ditekshen', 'Ditekshen', 1, 1, 'https://raw.githubusercontent.com/ditekshen/detection/master/clamav/', '1d', NULL, 'disabled', NULL, NULL, 'Ditekshen YARA/ClamAV detection rules', 100
WHERE NOT EXISTS (SELECT 1 FROM malware_feeds_config WHERE section_name = 'ditekshen');

-- Fix is_builtin for existing installations that already ran the seed with is_builtin=0
UPDATE malware_feeds_config SET is_builtin = 1
WHERE section_name IN ('malwarepatrol', 'malwareexpert', 'securiteinfo', 'twinwave', 'clampunch', 'rfxn', 'interserver', 'ditekshen')
AND is_builtin = 0;

-- ============================================================================
-- MALWARE FEEDS: Seed URL entries for each feed
-- NOTE: CONCAT used to avoid DBeaver interpreting ${} as bind parameters
-- ============================================================================

-- SaneSecurity: disable malwareexpert URLs that overlap
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malwareexpert_fp', 'disabled', 0, 10
FROM malware_feeds_config f WHERE f.section_name = 'sanesecurity'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malwareexpert_fp');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malwareexpert_hdb', 'disabled', 0, 20
FROM malware_feeds_config f WHERE f.section_name = 'sanesecurity'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malwareexpert_hdb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malwareexpert_ldb', 'disabled', 0, 30
FROM malware_feeds_config f WHERE f.section_name = 'sanesecurity'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malwareexpert_ldb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malwareexpert_ndb', 'disabled', 0, 40
FROM malware_feeds_config f WHERE f.section_name = 'sanesecurity'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malwareexpert_ndb');

-- SecuriteInfo URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, '0hour', CONCAT('$','{prefix}securiteinfo0hour.hdb'), 0, 10
FROM malware_feeds_config f WHERE f.section_name = 'securiteinfo'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = '0hour');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'securiteinfo_mdb', CONCAT('$','{prefix}securiteinfo.mdb'), 0, 20
FROM malware_feeds_config f WHERE f.section_name = 'securiteinfo'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'securiteinfo_mdb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'old', CONCAT('$','{prefix}securiteinfoold.hdb'), 1, 30
FROM malware_feeds_config f WHERE f.section_name = 'securiteinfo'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'old');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'spam_marketing', CONCAT('$','{prefix}spam_marketing.ndb'), 1, 40
FROM malware_feeds_config f WHERE f.section_name = 'securiteinfo'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'spam_marketing');

-- MalwareExpert URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malware.expert_fp', CONCAT('$','{prefix}/$','{serial_key}/malware.expert.fp'), 1, 10
FROM malware_feeds_config f WHERE f.section_name = 'malwareexpert'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malware.expert_fp');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malware.expert_hdb', CONCAT('$','{prefix}/$','{serial_key}/malware.expert.hdb'), 1, 20
FROM malware_feeds_config f WHERE f.section_name = 'malwareexpert'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malware.expert_hdb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malware.expert_ldb', CONCAT('$','{prefix}/$','{serial_key}/malware.expert.ldb'), 1, 30
FROM malware_feeds_config f WHERE f.section_name = 'malwareexpert'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malware.expert_ldb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'malware.expert.ndb', CONCAT('$','{prefix}/$','{serial_key}/malware.expert.ndb'), 1, 40
FROM malware_feeds_config f WHERE f.section_name = 'malwareexpert'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'malware.expert.ndb');

-- TwinWave URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'twinclams', CONCAT('$','{prefix}twinclams.ldb'), 1, 10
FROM malware_feeds_config f WHERE f.section_name = 'twinwave'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'twinclams');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'twinwave_ign2', CONCAT('$','{prefix}twinwave.ign2'), 1, 20
FROM malware_feeds_config f WHERE f.section_name = 'twinwave'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'twinwave_ign2');

-- ClamPunch URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'miscreantpunch099low', CONCAT('$','{prefix}MiscreantPunch099-Low.ldb'), 1, 10
FROM malware_feeds_config f WHERE f.section_name = 'clampunch'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'miscreantpunch099low');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'exexor99', CONCAT('$','{prefix}exexor99.ldb'), 1, 20
FROM malware_feeds_config f WHERE f.section_name = 'clampunch'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'exexor99');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'miscreantpuchhdb', CONCAT('$','{prefix}miscreantpunch.hdb'), 1, 30
FROM malware_feeds_config f WHERE f.section_name = 'clampunch'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'miscreantpuchhdb');

-- RFXN URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'rfxn_ndb', CONCAT('$','{prefix}rfxn.ndb'), 1, 10
FROM malware_feeds_config f WHERE f.section_name = 'rfxn'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'rfxn_ndb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'rfxn_hdb', CONCAT('$','{prefix}rfxn.hdb'), 1, 20
FROM malware_feeds_config f WHERE f.section_name = 'rfxn'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'rfxn_hdb');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'rfxn_yara', CONCAT('$','{prefix}rfxn.yara'), 1, 30
FROM malware_feeds_config f WHERE f.section_name = 'rfxn'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'rfxn_yara');

-- InterServer URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'interserver_sha256', CONCAT('$','{prefix}interserver256.hdb'), 1, 10
FROM malware_feeds_config f WHERE f.section_name = 'interserver'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'interserver_sha256');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'interserver_topline', CONCAT('$','{prefix}interservertopline.db'), 1, 20
FROM malware_feeds_config f WHERE f.section_name = 'interserver'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'interserver_topline');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'interserver_shell', CONCAT('$','{prefix}shell.ldb'), 1, 30
FROM malware_feeds_config f WHERE f.section_name = 'interserver'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'interserver_shell');

INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, sort_order)
SELECT f.id, 'interserver_whitelist', CONCAT('$','{prefix}whitelist.fp'), 1, 40
FROM malware_feeds_config f WHERE f.section_name = 'interserver'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'interserver_whitelist');

-- Ditekshen URLs
INSERT INTO malware_feed_urls (feed_id, url_key, url_value, enabled, filename_override, sort_order)
SELECT f.id, 'ditekshen_ldb', CONCAT('$','{prefix}clamav.ldb'), 1, 'ditekshen.ldb', 10
FROM malware_feeds_config f WHERE f.section_name = 'ditekshen'
AND NOT EXISTS (SELECT 1 FROM malware_feed_urls u WHERE u.feed_id = f.id AND u.url_key = 'ditekshen_ldb');

-- ============================================================================
-- MALWARE FEEDS: Ofelia scheduled job for Fangfrisch refresh
-- Replaces cron.d job inside hermes_mail_filter container
-- ============================================================================

INSERT INTO ofelia_jobs (job_name, schedule, command, container, active, type)
SELECT '[job-exec "hermes-fangfrisch-refresh"]', '@every 10m', '/usr/bin/fangfrisch --conf /etc/fangfrisch/fangfrisch.conf refresh', 'hermes_mail_filter', '1', 'malware_feeds'
WHERE NOT EXISTS (
    SELECT 1 FROM ofelia_jobs WHERE job_name = '[job-exec "hermes-fangfrisch-refresh"]'
);

-- Global setting for Fangfrisch refresh interval
INSERT INTO parameters2 (parameter, value2, module, active)
SELECT 'refresh_interval', '10m', 'malware_feeds', '1'
WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE parameter = 'refresh_interval' AND module = 'malware_feeds');


-- ============================================================================
-- EMAIL SERVER: Mailbox Domains support (Issue #196)
-- Makes the `domains` table the single source of truth for both relay
-- domains (type='relay') and mailbox-hosting domains (type='mailbox'),
-- with mailbox-specific metadata columns. The `mailbox_domains` table
-- remains as cert SAN binding metadata only (its original purpose).
-- ============================================================================

-- Migrate existing domains to type='relay' (mailbox domains didn't exist before)
UPDATE domains SET type = 'relay'
WHERE type IS NULL OR type = '';

-- Add mailbox-hosting metadata columns to `domains` table
-- NULL/defaults for relay rows; populated for type='mailbox' rows
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS default_quota_mb INT NULL DEFAULT NULL AFTER type;
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS catchall_mailbox VARCHAR(255) NULL AFTER default_quota_mb;
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS nextcloud_enabled TINYINT(1) NOT NULL DEFAULT 0 AFTER catchall_mailbox;
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS nextcloud_group VARCHAR(255) NULL AFTER nextcloud_enabled;
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS created_at DATETIME NULL AFTER nextcloud_group;
ALTER TABLE domains
  ADD COLUMN IF NOT EXISTS updated_at DATETIME NULL AFTER created_at;

-- Clean up columns that were briefly added to mailbox_domains by an
-- earlier iteration of this migration (they belong on `domains` now).
-- IF EXISTS makes these no-ops on fresh installs.
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS active;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS default_quota_mb;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS catchall_mailbox;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS nextcloud_enabled;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS nextcloud_group;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS created_at;
ALTER TABLE mailbox_domains DROP COLUMN IF EXISTS updated_at;

-- Drop `active` column from domains. Active/inactive semantics live at
-- the mailbox level (per-user), not the domain level. Delete is the
-- canonical off-switch for domains.
ALTER TABLE domains DROP COLUMN IF EXISTS active;

-- additional_sans is already seeded with system prefixes (autoconfig,
-- autodiscover). sync_mailbox_sans.cfm cross-joins these with
-- domains.type='mailbox' to produce one mailbox_sans row per
-- (prefix, domain) combination.

-- ============================================================================
-- Email Server > Mailboxes (#199)
-- ============================================================================

-- Add recipient_type to distinguish relay vs mailbox recipients
ALTER TABLE recipients
  ADD COLUMN IF NOT EXISTS recipient_type VARCHAR(20) NOT NULL DEFAULT 'relay' AFTER remoteauth_domain;

-- Set existing non-domain recipients to 'relay' (skip domain entries where domain='1')
UPDATE recipients SET recipient_type = 'relay' WHERE (recipient_type IS NULL OR recipient_type = '') AND (domain IS NULL OR domain <> '1');

-- Set recipient_type='mailbox' for any recipients that exist in the mailboxes table
UPDATE recipients r
INNER JOIN mailboxes m ON r.recipient = m.username
SET r.recipient_type = 'mailbox'
WHERE r.recipient_type <> 'mailbox';

-- Backfill default policy_id on domain-level recipients entries (@domain with domain='1')
-- that have no policy set. Without this, Amavis skips SVF filtering for unmatched addresses.
UPDATE recipients
SET policy_id = (SELECT policy_id FROM spam_policies WHERE default_policy = '1' LIMIT 1)
WHERE domain = '1' AND (policy_id IS NULL OR policy_id = 0);

-- Drop vestigial password column from mailboxes (auth is handled by LDAP)
ALTER TABLE mailboxes DROP COLUMN IF EXISTS password;

-- Add per-mailbox Nextcloud toggle (defaults to domain setting on creation)
ALTER TABLE mailboxes
  ADD COLUMN IF NOT EXISTS nextcloud_enabled TINYINT(3) NOT NULL DEFAULT 0 AFTER active;

-- ============================================================================
-- Email Server > Aliases (#200)
-- ============================================================================

-- Mailbox aliases (separate from virtual_recipients which is for relay domains)
CREATE TABLE IF NOT EXISTS mailbox_aliases (
  id INT AUTO_INCREMENT PRIMARY KEY,
  alias_address VARCHAR(255) NOT NULL,
  delivers_to VARCHAR(255) NOT NULL,
  alias_type VARCHAR(20) NOT NULL DEFAULT 'forward',
  send_as TINYINT(3) NOT NULL DEFAULT 0,
  domain_id INT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_alias_address (alias_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sender login maps: controls which authenticated users can send as which addresses
-- Used by Postfix smtpd_sender_login_maps to enforce send-as permissions
CREATE TABLE IF NOT EXISTS sender_login_maps (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender VARCHAR(255) NOT NULL,
  login_user VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_sender_login (sender, login_user)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Every mailbox user can send as themselves (seed from existing mailboxes)
INSERT IGNORE INTO sender_login_maps (sender, login_user)
SELECT username, username FROM mailboxes;

-- Migrate any existing virtual_recipients entries for mailbox domains to mailbox_aliases
INSERT IGNORE INTO mailbox_aliases (alias_address, delivers_to, alias_type, domain_id)
SELECT vr.virtual_address, vr.maps, 'forward', d.id
FROM virtual_recipients vr
INNER JOIN domains d ON d.domain = SUBSTRING_INDEX(vr.virtual_address, '@', -1) AND d.type = 'mailbox'
WHERE vr.system = '2';

-- Remove migrated entries from virtual_recipients (only mailbox domain entries)
DELETE vr FROM virtual_recipients vr
INNER JOIN domains d ON d.domain = SUBSTRING_INDEX(vr.virtual_address, '@', -1) AND d.type = 'mailbox'
WHERE vr.system = '2';

-- ============================================================================
-- Gateway > BCC Maps
-- ============================================================================

CREATE TABLE IF NOT EXISTS bcc_maps (
  id INT AUTO_INCREMENT PRIMARY KEY,
  address VARCHAR(255) NOT NULL,
  bcc_to VARCHAR(255) NOT NULL,
  bcc_type VARCHAR(10) NOT NULL DEFAULT 'sender',
  enabled TINYINT(3) NOT NULL DEFAULT 1,
  description VARCHAR(255) NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_bcc_address_type (address, bcc_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- Sieve Rules (admin global + user personal)
-- ============================================================================

CREATE TABLE IF NOT EXISTS sieve_rules (
  id INT AUTO_INCREMENT PRIMARY KEY,
  scope VARCHAR(10) NOT NULL DEFAULT 'global',
  username VARCHAR(255) NULL,
  rule_name VARCHAR(255) NOT NULL,
  rule_order INT NOT NULL DEFAULT 0,
  enabled TINYINT(3) NOT NULL DEFAULT 1,
  is_system TINYINT(3) NOT NULL DEFAULT 0,
  condition_field VARCHAR(50) NULL,
  condition_type VARCHAR(50) NULL,
  condition_value VARCHAR(500) NULL,
  action_type VARCHAR(50) NULL,
  action_value VARCHAR(255) NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add match_type for AND/OR logic across multiple conditions
ALTER TABLE sieve_rules
  ADD COLUMN IF NOT EXISTS match_type VARCHAR(10) NOT NULL DEFAULT 'all' AFTER is_system;

-- Relax legacy single-condition/single-action columns to nullable.
-- The new schema stores conditions/actions in sieve_rule_conditions and
-- sieve_rule_actions; these legacy columns are only kept for the migration
-- backfill below and are no longer written by the application.
ALTER TABLE sieve_rules MODIFY COLUMN condition_field VARCHAR(50) NULL;
ALTER TABLE sieve_rules MODIFY COLUMN condition_type  VARCHAR(50) NULL;
ALTER TABLE sieve_rules MODIFY COLUMN condition_value VARCHAR(500) NULL;
ALTER TABLE sieve_rules MODIFY COLUMN action_type     VARCHAR(50) NULL;
ALTER TABLE sieve_rules MODIFY COLUMN action_value    VARCHAR(255) NULL;

-- Multi-condition support (each rule can have 1+ conditions)
CREATE TABLE IF NOT EXISTS sieve_rule_conditions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rule_id INT NOT NULL,
  condition_field VARCHAR(50) NOT NULL,
  condition_type VARCHAR(50) NOT NULL,
  condition_value VARCHAR(500) NOT NULL,
  condition_order INT NOT NULL DEFAULT 0,
  KEY idx_rule (rule_id),
  CONSTRAINT fk_sieve_cond_rule FOREIGN KEY (rule_id) REFERENCES sieve_rules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Multi-action support (each rule can have 1+ actions)
CREATE TABLE IF NOT EXISTS sieve_rule_actions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rule_id INT NOT NULL,
  action_type VARCHAR(50) NOT NULL,
  action_value VARCHAR(255) NULL,
  action_order INT NOT NULL DEFAULT 0,
  KEY idx_rule (rule_id),
  CONSTRAINT fk_sieve_act_rule FOREIGN KEY (rule_id) REFERENCES sieve_rules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- System rule: move spam to Spam folder (global, cannot be deleted)
-- Note: uses :matches with "Yes,*" to anchor at start - :contains "Yes" would
-- match "BAYES_60" in tests= array (sieve :contains is case-insensitive substring)
-- Idempotent: WHERE NOT EXISTS instead of INSERT IGNORE because there's no
-- unique constraint on rule_name (system rules are identified by is_system=1).
INSERT INTO sieve_rules
(scope, username, rule_name, rule_order, enabled, is_system, match_type, condition_field, condition_type, condition_value, action_type, action_value)
SELECT 'global', NULL, 'Move spam to Spam folder', 1, 1, 1, 'all', 'header', 'matches', 'X-Spam-Status: Yes,*', 'fileinto', 'Spam'
WHERE NOT EXISTS (
    SELECT 1 FROM sieve_rules
    WHERE scope = 'global' AND is_system = 1 AND rule_name = 'Move spam to Spam folder'
);

-- ============================================================================
-- User Vacation / Auto-Reply (one row per mailbox user)
-- ============================================================================
-- Stores per-user out-of-office configuration. The user_vacation row is
-- consumed by generate_sieve_user.cfm which prepends a sieve "vacation"
-- block to the user's personal sieve script when active.
--
-- Active = enabled = 1 AND (start_date IS NULL OR start_date <= CURDATE())
--                  AND (end_date   IS NULL OR end_date   >= CURDATE())
CREATE TABLE IF NOT EXISTS user_vacation (
  username VARCHAR(255) NOT NULL PRIMARY KEY,
  enabled TINYINT(3) NOT NULL DEFAULT 0,
  subject VARCHAR(255) NULL,
  body TEXT NULL,
  start_date DATE NULL,
  end_date DATE NULL,
  reply_interval_days INT NOT NULL DEFAULT 7,
  reply_external TINYINT(3) NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add reply_external if upgrading from an earlier version where it didn't exist.
ALTER TABLE user_vacation
  ADD COLUMN IF NOT EXISTS reply_external TINYINT(3) NOT NULL DEFAULT 0 AFTER reply_interval_days;

-- Restrict auto-reply to messages addressed to one of these addresses
-- (comma-separated). Empty = reply to any address that reaches the mailbox.
-- Used for users with multiple aliases who only want vacation to fire for
-- mail addressed to a specific identity (e.g. only for sales@... but not for
-- their personal alias).
ALTER TABLE user_vacation
  ADD COLUMN IF NOT EXISTS reply_addresses TEXT NULL AFTER reply_external;

-- Discard incoming mail while vacation is active. The auto-reply is still
-- sent, but the message itself is dropped (not delivered to the inbox).
-- Niche - mostly used by people who don't want to come back to thousands of
-- messages. Carries the same warnings as the sieve discard action.
ALTER TABLE user_vacation
  ADD COLUMN IF NOT EXISTS discard_incoming TINYINT(3) NOT NULL DEFAULT 0 AFTER reply_addresses;

-- Upgrade start_date / end_date from DATE to DATETIME so users can specify
-- precise start/end times (e.g. "leave at 5pm Friday, return at 8am Monday").
-- DATE -> DATETIME conversion is lossless: existing 2026-04-15 becomes
-- 2026-04-15 00:00:00. Idempotent because MODIFY is a no-op if the column
-- type already matches.
ALTER TABLE user_vacation MODIFY COLUMN start_date DATETIME NULL;
ALTER TABLE user_vacation MODIFY COLUMN end_date   DATETIME NULL;

-- ============================================================================
-- Sieve Compile Log (records sievec compilation failures for diagnostics)
-- ============================================================================
-- When a sieve script fails to compile after a rule save, the rule lives
-- in the database but the previous compiled .svbin remains in place. This
-- log lets admins see why a save "succeeded but the rule isn't running".
CREATE TABLE IF NOT EXISTS sieve_compile_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  scope VARCHAR(10) NOT NULL,
  username VARCHAR(255) NULL,
  rule_id INT NULL,
  error_text TEXT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_scope_user (scope, username),
  KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- User Login History (per-user current + previous login timestamp)
-- ============================================================================
-- Stores the timestamp of each user's most recent login plus the one before it,
-- so the dashboard can display "Last login: <previous>". Updated on the first
-- request of each new session by record_login.cfm.
CREATE TABLE IF NOT EXISTS user_login_history (
  username VARCHAR(255) NOT NULL PRIMARY KEY,
  current_login DATETIME NULL,
  previous_login DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Migrate existing single-condition/single-action rows into the new tables
-- (idempotent: only inserts if no condition/action row already exists for that rule)
INSERT INTO sieve_rule_conditions (rule_id, condition_field, condition_type, condition_value, condition_order)
SELECT r.id, r.condition_field, r.condition_type, COALESCE(r.condition_value, ''), 0
FROM sieve_rules r
LEFT JOIN sieve_rule_conditions c ON c.rule_id = r.id
WHERE r.condition_field IS NOT NULL
  AND c.id IS NULL;

INSERT INTO sieve_rule_actions (rule_id, action_type, action_value, action_order)
SELECT r.id, r.action_type, r.action_value, 0
FROM sieve_rules r
LEFT JOIN sieve_rule_actions a ON a.rule_id = r.id
WHERE r.action_type IS NOT NULL
  AND a.id IS NULL;
