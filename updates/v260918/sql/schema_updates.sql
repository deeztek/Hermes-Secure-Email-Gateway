-- =====================================================================
-- Hermes SEG schema updates -- v260918
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: the two directory enumeration tables from #332, plus the shared
-- Ofelia job that drains them. The quarantine release token key rotation in
-- this release is a host shell artifact
-- (scripts/10-rotate-quarantine-token-key.sh), not SQL.
--
-- The version stamp at the end is required even when a release has no schema
-- work: the update orchestrator reads build_no to decide which release
-- directories are still pending.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Directory enumeration (#332)
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  (both tables
-- are in the baseline, so a fresh install creates them at install time)
--
-- Relay recipients have always been hand-entered or CSV-pasted, including for
-- domains where a RemoteAuth mapping already points at the customer's
-- directory. These two tables let a scheduled job read that directory and
-- stage what it finds for admin review.
--
-- Mail flow is not affected either way. A relay domain set to ANY carries a
-- wildcard '@domain' row in `recipients` with status 'OK', so enumerated rows
-- are purely additive: they exist to light up per-recipient features
-- (encryption, /users portal login, block-allow lists), not to gate delivery.
-- ---------------------------------------------------------------------
-- -------- directory_connections (#332 directory enumeration) --------
-- One row per directory Hermes enumerates relay recipients from.
-- `provider` names the source: 'ldap' is the only connector wired today (it
-- shells out to ldapsearch inside hermes_ldap, not cfldap, so it shares slapd's
-- trust store and gets real paging); 'graph' and 'google' are reserved for the
-- REST connectors.
-- `remoteauth_mapping_id` says where the recipients this directory creates will
-- AUTHENTICATE. It supplies recipients.remoteauth_domain and nothing else: the
-- server fields above are the read source, and the two are commonly the same
-- host but need not be. Bind credentials live here because remoteauth_mappings
-- deliberately has none, RemoteAuth binding as the end user via
-- remote_dn_pattern rather than a service account.
-- `bind_password` is AES/Base64 under /opt/hermes/keys/hermes.key, never
-- written to a file under the web root (that was the legacy AD sync's mistake).
-- Scheduling is one shared ofelia_jobs row, not a schedule per connection.
CREATE TABLE IF NOT EXISTS `directory_connections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_name` varchar(255) NOT NULL,
  `provider` varchar(20) NOT NULL DEFAULT 'ldap',
  `remoteauth_mapping_id` int(11) DEFAULT NULL,
  `server_address` varchar(255) DEFAULT NULL,
  -- Defaults to LDAPS on 636, but Plain is selectable. Enumeration binds with a
  -- service account password, and unlike a user login that credential is
  -- standing and re-sent on every sync, so plain LDAP puts a reusable password
  -- on the wire repeatedly. The console warns about that rather than forbidding
  -- it: a directory with no TLS listener at all would otherwise be impossible
  -- to enumerate, which is a worse outcome than an informed choice.
  --
  -- Independent of remoteauth_mappings.use_ldaps. Enumeration and login are
  -- separate connections and need not use the same transport, or even the same
  -- directory.
  `server_port` int(11) DEFAULT 636,
  `tls_mode` varchar(10) NOT NULL DEFAULT 'ldaps',
  `base_dn` varchar(500) DEFAULT NULL,
  `bind_dn` varchar(500) DEFAULT NULL,
  `bind_password` varchar(1024) DEFAULT NULL,
  `object_class` varchar(64) NOT NULL DEFAULT 'user',
  `mail_attribute` varchar(64) NOT NULL DEFAULT 'mail',
  `extra_filter` varchar(500) DEFAULT NULL,
  -- Mutual TLS for THIS directory, independent of RemoteAuth's own client
  -- certificate (#335). Google Secure LDAP is an ordinary LDAPS endpoint that
  -- insists the client prove who it is, so enumerating Google needs a pair
  -- here. Kept per directory rather than shared with RemoteAuth for two
  -- reasons: Auto-Provisioning is Community while the RemoteAuth page is Pro,
  -- so sharing would gate enumeration behind a licence it does not need; and
  -- the directory read from is not necessarily the one authenticated against,
  -- so a certificate for one should never be offered to the other.
  `client_cert_file` varchar(255) DEFAULT NULL,
  `client_key_file` varchar(255) DEFAULT NULL,
  -- CA bundle for verifying THIS directory, for the same reasons the client
  -- certificate is per directory: the RemoteAuth page is Pro while
  -- Auto-Provisioning is Community, and the directory read from is not
  -- necessarily the one authenticated against.
  `ca_cert_file` varchar(255) DEFAULT NULL,
  -- Google Admin SDK (#336). The service account JSON key, AES/Base64 under
  -- /opt/hermes/keys/hermes.key like every other credential here. TEXT because
  -- the key file is a couple of kilobytes before encryption.
  --
  -- google_subject is the super administrator the service account impersonates.
  -- Domain-wide delegation authorises the service account to act as a user, and
  -- the Directory API will not answer without one.
  `google_sa_json` text DEFAULT NULL,
  `google_subject` varchar(255) DEFAULT NULL,
  -- Provisioning defaults, applied to every recipient this connection creates.
  -- auth_type is independent of `provider`: the directory Hermes enumerates is
  -- not necessarily the one it authenticates against. A tenant synced from
  -- on-prem AD is enumerated from Google or M365 and authenticated against that
  -- AD over ordinary LDAP, which is the common hybrid shape.
  -- 'remote' requires remoteauth_mapping_id; import refuses without it.
  `auth_type` varchar(10) NOT NULL DEFAULT 'local',
  `policy_id` int(11) DEFAULT NULL,
  `report_enabled` varchar(3) NOT NULL DEFAULT 'YES',
  -- TINYINT(3), not (1): Lucee maps TINYINT(1) to a boolean, and these values
  -- are passed straight through to the recipients / user_settings inserts,
  -- which expect 0 and 1.
  `train_bayes` tinyint(3) NOT NULL DEFAULT 0,
  `download_msg` tinyint(3) NOT NULL DEFAULT 0,
  `enforce_mfa` tinyint(3) NOT NULL DEFAULT 0,
  -- Off for a first bulk import of people who already have mail flowing and
  -- have never heard of Hermes. On for steady state, when a new hire appears.
  `send_welcome` tinyint(3) NOT NULL DEFAULT 1,
  -- 0 stages for review, 1 provisions unattended from the scheduled job.
  -- New connections start at 0 so the first run is inspectable. Deletions are
  -- never auto-applied at any setting.
  `auto_apply` tinyint(3) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `last_run_at` datetime DEFAULT NULL,
  `last_run_status` varchar(32) DEFAULT NULL,
  `last_run_message` text DEFAULT NULL,
  `last_found_count` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_entry_name` (`entry_name`),
  KEY `idx_directory_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- -------- directory_import_staging (#332 directory enumeration) --------
-- The result of one enumeration run, staged for admin review. Nothing reaches
-- `recipients` until an admin applies it.
-- `action` values:
--   insert   = present upstream, no matching recipient yet (candidate to add)
--   existing = present in both, nothing to do
--   vanished = a recipient this connection created is gone upstream
-- 'vanished' is REPORT ONLY. Recipients are never deleted automatically: a
-- relay domain set to ANY still delivers their mail, so a bad or partial sync
-- must not be able to strip portal access and encryption from live users.
CREATE TABLE IF NOT EXISTS `directory_import_staging` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connection_id` int(11) NOT NULL,
  `run_id` varchar(32) NOT NULL,
  `email` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(128) DEFAULT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `source_dn` varchar(500) DEFAULT NULL,
  `action` enum('insert','existing','vanished') NOT NULL,
  `status` enum('pending','applied','skipped','failed') NOT NULL DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `applied_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dis_run` (`run_id`),
  KEY `idx_dis_conn_status` (`connection_id`,`status`),
  KEY `idx_dis_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- 2. Shared scheduler row (#332)
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  (the same
-- WHERE NOT EXISTS insert is in the baseline's ofelia_jobs seed)
--
-- One job drains every enabled connection. The legacy AD sync wrote a cron
-- file and a generated .cfm per connection; under Docker that collapses to a
-- single ofelia_jobs row driving one parameterised page.
--
-- ofelia_jobs has no UNIQUE KEY on job_name, so INSERT IGNORE would insert a
-- duplicate on every re-run. WHERE NOT EXISTS is the idempotent form here.
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs`
  (`job_name`, `schedule`, `command`, `container`, `image`, `user`, `volume`, `network`, `type`, `active`, `no_overlap`)
SELECT '[job-exec "hermes-directory-sync"]', '@every 6h',
       '/usr/bin/curl --silent http://localhost:8888/schedule/directory_sync.cfm',
       'hermes_commandbox', NULL, NULL, NULL, NULL, 'hermes', 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM `ofelia_jobs` WHERE `job_name` = '[job-exec "hermes-directory-sync"]'
);

-- ---------------------------------------------------------------------
-- 3. RemoteAuth gains a per-mapping transport (#335)
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  (remoteauth_mappings
-- carries use_ldaps in the baseline, and the three dropped columns were removed
-- from the baseline definition, so a fresh install never creates them)
--
-- Google Secure LDAP is LDAPS-only on 636. Until now
-- ldap_remoteauth_sync_all.cfm hardcoded ldap:// when building every mapping
-- URI, so LDAPS was unreachable and Google could not be configured at all.
--
-- The overlay writes one olcRemoteAuthMapping line per domain, each with its
-- own URI, so the scheme varies per mapping. Only starttls and tls_reqcert in
-- remoteauth_settings are global, and a plain ldap:// mapping negotiates no
-- TLS at all, so tls_reqcert is never consulted for it. Mixed transports
-- therefore coexist: an existing AD mapping keeps working untouched while a
-- new Google mapping alongside it gets the full certificate check.
--
-- NOT BREAKING, deliberately. use_ldaps defaults to 0, which emits exactly the
-- ldap:// URI every existing mapping already used, and no global setting is
-- rewritten. Console administrators can authenticate through RemoteAuth
-- (system_users.auth_type), so a transport change that fails locks the
-- administrator out of the console, and there is no CLI recovery tool yet
-- (#173). Changing transport is therefore opt-in, per mapping.
--
-- The three dropped columns were never written by any code path and could not
-- have worked: TLS negotiation is global to the overlay, not per mapping.
-- ---------------------------------------------------------------------
ALTER TABLE `remoteauth_mappings`
  ADD COLUMN IF NOT EXISTS `use_ldaps` tinyint(3) NOT NULL DEFAULT 0 AFTER `remote_dn_pattern`;

ALTER TABLE `remoteauth_mappings`
  DROP COLUMN IF EXISTS `tls_starttls`,
  DROP COLUMN IF EXISTS `tls_reqcert`,
  DROP COLUMN IF EXISTS `ca_cert_file`;

UPDATE `remoteauth_settings`
   SET `description` = 'Derived, not console-editable. Forced to no whenever any mapping uses LDAPS, which is already encrypted and cannot be upgraded again'
 WHERE `setting_name` = 'tls_starttls';

UPDATE `remoteauth_settings`
   SET `description` = 'Derived, not console-editable. Forced to demand whenever any mapping uses LDAPS; irrelevant for plain mappings, which negotiate no TLS'
 WHERE `setting_name` = 'tls_reqcert';

-- ---------------------------------------------------------------------
-- 4. RemoteAuth client certificate (#335)
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  (the same two
-- seed rows are in the baseline's remoteauth_settings block)
--
-- Google Secure LDAP requires mutual TLS: the client must present a
-- certificate, not merely verify the server's. olcRemoteAuthTLS is a single
-- line for the whole overlay, so this is global rather than per mapping. That
-- is harmless in practice, because a client certificate is only sent when the
-- server asks for one and a typical AD does not.
--
-- Both default to empty, which emits no tls_cert/tls_key at all, so an
-- existing overlay is unchanged.
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `remoteauth_settings` (`setting_name`, `setting_value`, `description`) VALUES
    ('client_cert_file', '', 'Client certificate filename in /opt/hermes/certs/remoteauth/ (mutual TLS; required by Google Secure LDAP)'),
    ('client_key_file',  '', 'Client private key filename in /opt/hermes/certs/remoteauth/ (paired with client_cert_file)');

-- ---------------------------------------------------------------------
-- 5. Version stamp -- MUST be the last statement (advances build_no so
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- the update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260918' WHERE parameter = 'build_no';
