-- =====================================================================
-- Hermes SEG schema updates -- v260912
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: the network alias tables from #324, an entry_type column on each
-- of the two consumers that needed one, and the fresh-install milter repair.
-- The rest of the release needs no schema support -- the legacy-to-Docker
-- migration work on #322 lives entirely in
-- scripts/migrate_legacy_to_docker.sh and ships with the tag rather than as a
-- per-release artifact, and the sidebar fix on #309 is a CFML change.
--
-- The version stamp is here regardless. That is not
-- ceremony: the update orchestrator reads build_no to decide which
-- release directories are still pending, and warns if a release finishes
-- without stamping. A release with no schema work still has to stamp.
-- Without this directory, find_pending_releases() would find nothing
-- newer than v260815, report "nothing to apply", and leave build_no
-- stale, which is the exact defect #322 was opened to fix on the
-- migration path.
--
-- The alias feature ships whole in this release: the tables and seeds here,
-- the console page (view_network_aliases.cfm), the SPF resolver
-- (schedule/refresh_network_aliases.cfm) on the Ofelia job seeded in section
-- 2, and three consumers that expand an alias at render time -- Relay
-- Networks, Network Block/Allow, and the fail2ban whitelist. An alias is
-- never seen by Postfix, Amavis or fail2ban as a name; it is expanded to its
-- current ranges when the config file is written.
--
-- DELIBERATELY ABSENT:
--
--   #323. It gets its own release.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Network aliases (#324)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  same two tables and the same two disabled seed rows
--
-- A named set of CIDR ranges with a source. `static` is a hand-entered list;
-- `spf` is resolved from a DNS TXT record. Consumers reference the alias
-- instead of pasting ranges into their own list.
--
-- Seeded DISABLED, so a gateway gains two discoverable examples and no
-- behaviour until an operator turns one on.
--
-- network_alias_entries stores IPv6 ranges as well as IPv4 and marks them with
-- `family`. The mail containers set net.ipv6.conf.all.disable_ipv6=1 so v6 is
-- unusable today and gets filtered at render, but storing it keeps the data
-- correct if that ever changes.
--
-- `origin` separates hand-entered rows from resolved ones, so a re-resolve
-- never discards what an operator typed. first_seen/last_seen give change
-- detection: an entry whose last_seen predates the alias's last_resolved has
-- dropped out of the published record.
--
-- It has no seed rows, so scripts/check_fresh_install_parity.sh does not
-- require it in SEED_MERGE_KEYS. If it ever gains any, it is a join table
-- keyed on alias_id and belongs in merge_join_table_rows(), resolved through
-- network_aliases.name, not carried by id.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `network_alias_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias_id` int(11) NOT NULL,
  `cidr` varchar(64) NOT NULL,
  `family` varchar(4) NOT NULL DEFAULT 'ip4',
  `origin` varchar(16) NOT NULL DEFAULT 'manual',
  `first_seen` datetime DEFAULT current_timestamp(),
  `last_seen` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_alias_cidr` (`alias_id`,`cidr`),
  KEY `idx_alias_id` (`alias_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `network_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `source_type` varchar(16) NOT NULL DEFAULT 'static',
  `source_value` varchar(255) DEFAULT NULL,
  `enabled` tinyint(3) NOT NULL DEFAULT 1,
  `last_resolved` datetime DEFAULT NULL,
  `last_status` varchar(32) DEFAULT NULL,
  `last_message` varchar(512) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_alias_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `network_aliases` (`name`, `description`, `source_type`, `source_value`, `enabled`) VALUES
  ('Google Workspace', 'Google outbound mail servers, resolved from Google published SPF record', 'spf', '_spf.google.com', 0);
INSERT IGNORE INTO `network_aliases` (`name`, `description`, `source_type`, `source_value`, `enabled`) VALUES
  ('Microsoft 365', 'Microsoft 365 outbound mail servers, resolved from the Exchange Online SPF record', 'spf', 'spf.protection.outlook.com', 0);

-- ---------------------------------------------------------------------
-- 2. Scheduled resolver job (#324)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  same seed row, id 15
--
-- Runs schedule/refresh_network_aliases.cfm daily at 03:30. Advisory only: it
-- writes network_alias_entries and nothing else, renders no config file and
-- reloads no service, so it cannot affect mail flow.
--
-- Seeded active with both shipped aliases disabled, so it runs and finds nothing
-- to do until an operator enables one. That is deliberate: the job being ready
-- means enabling an alias is a single action rather than two.
--
-- The explicit id is required rather than preferred. scripts/check_ofelia_seed_drift.sh
-- parses these rows positionally, expecting twelve fields starting with the id,
-- and diffs the result against the shipped config/ofelia/config.ini. A
-- column-list INSERT would not parse. config/ofelia/config.ini carries the
-- matching block, in the same order, or that check fails the commit.
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `ofelia_jobs` VALUES (15,'[job-exec \"hermes-refresh-network-aliases\"]',' 0 30 03 * * *','/usr/bin/curl --silent http://localhost:8888/schedule/refresh_network_aliases.cfm','hermes_commandbox',NULL,NULL,NULL,NULL,'hermes',1,0);

-- ---------------------------------------------------------------------
-- 3. Restore the body milter in smtpd_milters on fresh v260815 installs
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  the auto-id row was moved below every explicit id, so the collision cannot recur
--
-- v260815's baseline inserted the #311 internal-only recipients row with a
-- column-list INSERT and no id, positioned ABOVE ids 474-477. The
-- AUTO_INCREMENT counter was at 474, that row took 474, and the next line's
-- explicit VALUES (474, 'inet:hermes_body_milter:8893', ...) then collided on
-- the primary key. INSERT IGNORE discards a duplicate without erroring, so the
-- import reported success and nothing was logged.
--
-- Result on EVERY fresh install of v260815: hermes_body_milter is absent from
-- smtpd_milters. Postfix never calls the body milter for inbound mail, so Link
-- Guard, disclaimers, organizational signatures and external banners are all
-- silently inert. milter_default_action = accept means Postfix does not
-- complain either. The row survived in non_smtpd_milters (id 475), which is
-- locally submitted mail only, so the feature looks half-present if anyone
-- checks the wrong directive.
--
-- Upgraded installs are NOT affected: they receive that row from
-- updates/v260815/sql/schema_updates.sql and never re-run the baseline.
--
-- The id is auto-assigned deliberately. 474 is legitimately occupied by the
-- internal-only recipients row on an affected gateway, and forcing it would
-- collide all over again. Identity here is (parent_name, parameter), not the id.
--
-- The NOT EXISTS reads the target through a derived table because MySQL
-- rejects naming the insert target directly (error 1093).
--
-- Idempotent: a gateway that already has the row, whether from a repair by hand
-- or from having been upgraded rather than freshly installed, is left alone.
-- ---------------------------------------------------------------------
INSERT INTO parameters
  (parameter, name, module, editable, conf_file,
   parent, parent_name, child, order1, enabled, applied, action)
SELECT 'inet:hermes_body_milter:8893', 'Hermes Body Milter', 'postfix', 1, 'main.cf',
       (SELECT id FROM (SELECT id FROM parameters
          WHERE parameter='smtpd_milters' AND child=2 AND module='postfix') p),
       'smtpd_milters', 1, 3.100, 1, 1, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM (SELECT * FROM parameters) x
  WHERE x.parent_name='smtpd_milters'
    AND x.parameter='inet:hermes_body_milter:8893');

-- The same row under non_smtpd_milters, for completeness. It normally survives
-- (id 475 did not collide), so this is a no-op on every gateway seen so far.
INSERT INTO parameters
  (parameter, name, module, editable, conf_file,
   parent, parent_name, child, order1, enabled, applied, action)
SELECT 'inet:hermes_body_milter:8893', 'Hermes Body Milter', 'postfix', 1, 'main.cf',
       (SELECT id FROM (SELECT id FROM parameters
          WHERE parameter='non_smtpd_milters' AND child=2 AND module='postfix') p),
       'non_smtpd_milters', 1, 3.100, 1, 1, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM (SELECT * FROM parameters) x
  WHERE x.parent_name='non_smtpd_milters'
    AND x.parameter='inet:hermes_body_milter:8893');

-- ---------------------------------------------------------------------
-- 4. Network aliases in the postscreen access list (#324)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  same column on the postscreen_access DDL
--
-- A postscreen_access row with entry_type = 'alias' holds a network alias NAME in
-- `sender` instead of a literal address, and renders as that alias's current IPv4
-- ranges when the .cidr file is written.
--
-- This is the consumer with the clearest case. config/postfix-dkim/etc/postfix/
-- postscreen_access.cidr ships with 129 hand-pasted Microsoft ranges and nothing
-- keeps them current, and Microsoft moves theirs far more often than Google does.
--
-- NULL means a literal address, which is every existing row, so nothing changes for
-- an install that never adds an alias.
-- ---------------------------------------------------------------------
ALTER TABLE `postscreen_access`
  ADD COLUMN IF NOT EXISTS `entry_type` varchar(16) DEFAULT NULL;

-- ---------------------------------------------------------------------
-- 5. Network aliases in the intrusion-prevention whitelist (#324)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  same column on the intrusion_prevention_whitelist DDL
--
-- A whitelist row with entry_type = 'alias' holds a network alias NAME in
-- `ip_cidr` and renders as that alias's current IPv4 ranges in fail2ban's
-- ignoreip.
--
-- The case: a gateway relaying for a cloud provider has that provider's ranges in
-- mynetworks. If fail2ban bans one of them for any reason, legitimate mail stops
-- arriving and the cause is not obvious. ignoreip is space separated, so an
-- expanded alias needs no splitting.
--
-- NULL means a literal address, which is every existing row.
-- ---------------------------------------------------------------------
ALTER TABLE `intrusion_prevention_whitelist`
  ADD COLUMN IF NOT EXISTS `entry_type` varchar(16) DEFAULT NULL;

-- ip_cidr holds an alias NAME on an alias row, and network_aliases.name is
-- varchar(128) while this column was varchar(50). sql_mode includes
-- STRICT_TRANS_TABLES, so a longer name would be rejected outright rather than
-- truncated. Widening is unconditional and safe to re-run: MODIFY to the size it
-- already is, is a no-op, and no existing literal address is anywhere near 50.
ALTER TABLE `intrusion_prevention_whitelist`
  MODIFY `ip_cidr` varchar(128) NOT NULL;

-- ---------------------------------------------------------------------
-- 6. Version stamp -- MUST be the last statement (advances build_no so
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- the update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260912' WHERE parameter = 'build_no';
