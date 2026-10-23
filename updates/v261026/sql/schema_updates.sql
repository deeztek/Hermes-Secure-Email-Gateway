-- =====================================================================
-- Hermes SEG v261026 schema updates
-- Idempotent. The certificate binding for existing hybrid domains (#371) is
-- created by schedule/post_upgrade.cfm (block hybrid-domain-cert-binding-v1).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. URLhaus: abuse.ch retired the keyless downloads (HTTP 410). The ClamAV
-- feed (Fangfrisch) now needs an Auth-Key in the URL path. Give the feed its
-- key slot (Key 1 = auth_key), the new export URL saved under the old file
-- name, and no integrity check (URLhaus publishes wrong checksums).
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
UPDATE malware_feeds_config
   SET api_key_1_name = 'auth_key'
 WHERE section_name = 'urlhaus' AND (api_key_1_name IS NULL OR api_key_1_name = '');
-- The keyed export is about 9 MB and growing; the shipped 10MB limit would
-- soon reject it. Raise only the shipped default, keep an admin's own value.
UPDATE malware_feeds_config
   SET max_size = '20MB'
 WHERE section_name = 'urlhaus' AND (max_size IS NULL OR max_size IN ('', '10MB'));
UPDATE malware_feeds_config
   SET integrity_check = 'disabled',
       description = 'URLhaus malicious URL signatures. Needs a free abuse.ch Auth-Key as Key 1 (auth_key): sign up at https://auth.abuse.ch/ with an X, Google, LinkedIn or GitHub account.'
 WHERE section_name = 'urlhaus';
INSERT IGNORE INTO malware_feed_urls (feed_id, url_key, url_value, enabled, filename_override, sort_order)
  SELECT id, 'urlhaus', CONCAT('https://urlhaus-api.abuse.ch/v2/files/exports/$', '{auth_key}/urlhaus_clamav.ndb'), 1, 'urlhaus.ndb', 10
    FROM malware_feeds_config WHERE section_name = 'urlhaus';

-- ---------------------------------------------------------------------
-- 2. URLhaus for Link Guard (Pro): its own Auth-Key setting.
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO parameters2 (parameter, value2, module, active, applied)
  SELECT 'urlhaus_auth_key', '', 'linkguard', 1, 1
  WHERE NOT EXISTS (SELECT 1 FROM parameters2 WHERE module = 'linkguard' AND parameter = 'urlhaus_auth_key');

-- ---------------------------------------------------------------------
-- 3. Link Guard: remote-access tool hosts in the abused-host list, with the
-- reason users see in the warning. INSERT IGNORE keeps an existing row.
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT IGNORE INTO linkguard_abused_hosts (host, note) VALUES
  ('screenconnect.com','Remote-access tool (abused to take over PCs)'),
  ('anydesk.com','Remote-access tool (abused to take over PCs)'),
  ('teamviewer.com','Remote-access tool (abused to take over PCs)'),
  ('splashtop.com','Remote-access tool (abused to take over PCs)'),
  ('atera.com','Remote-access tool (abused to take over PCs)'),
  ('rustdesk.com','Remote-access tool (abused to take over PCs)'),
  ('supremocontrol.com','Remote-access tool (abused to take over PCs)'),
  ('remoteutilities.com','Remote-access tool (abused to take over PCs)'),
  ('netsupportsoftware.com','Remote-access tool (abused to take over PCs)');

-- ---------------------------------------------------------------------
-- 4. Hybrid domains (#371): a domain converted from relay has no mailbox
-- default quota, which broke Email Server > Domains and new mailboxes on it.
-- Give it 5 GB, the Add Mailbox Domain default; conversion now sets the
-- quota chosen at conversion time.
-- FRESH-INSTALL: n/a  repairs data only a pre-existing install can have (converted domains)
-- ---------------------------------------------------------------------
UPDATE domains
   SET default_quota_mb = 5120
 WHERE type = 'hybrid' AND (default_quota_mb IS NULL OR default_quota_mb = 0);

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261026' WHERE parameter = 'build_no';
