-- =====================================================================
-- Hermes SEG schema updates -- v260912
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: the network alias tables from #324. The rest of the release
-- needs no schema support -- the legacy-to-Docker migration work on #322
-- lives entirely in scripts/migrate_legacy_to_docker.sh and ships with the
-- tag rather than as a per-release artifact, and the sidebar fix on #309 is
-- a CFML change.
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
-- DELIBERATELY ABSENT:
--
--   Anything that reads the alias tables. The resolver, the console page
--   and the first consumer (#323) all land later. Shipping the tables and
--   seeds first means none of those is also a migration.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Network aliases (#324)
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  same two tables and the same two disabled seed rows
--
-- A named set of CIDR ranges with a source. `static` is a hand-entered list;
-- `spf` is resolved from a DNS TXT record. Consumers reference the alias
-- instead of pasting ranges into their own list.
--
-- Nothing reads these yet. The tables and the seeds land first so the resolver
-- and the first consumer (#323) are not also a migration.
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
-- 3. Version stamp -- MUST be the last statement (advances build_no so
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- the update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260912' WHERE parameter = 'build_no';
