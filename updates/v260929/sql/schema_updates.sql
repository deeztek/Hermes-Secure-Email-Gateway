-- =====================================================================
-- Hermes SEG schema updates -- v260929
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- Contents: recipients.backend_transport, and ofelia_jobs.description plus
-- a description for every job that ships.
--
-- The three backend_* columns have existed since the Docker rewrite and this
-- release makes them route (#157). Routing to an EXTERNAL server needs nothing
-- new, since smtp is the only transport involved. Routing to the built-in mail
-- server needs lmtp, which is a different transport entirely rather than a
-- different host, so the transport cannot be inferred from the address.
--
-- NULL means smtp, so every existing override keeps behaving exactly as it did.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Per-recipient transport (#157)
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql  (the same
-- column is declared on the recipients table in the baseline)
-- ---------------------------------------------------------------------
ALTER TABLE `recipients`
  ADD COLUMN IF NOT EXISTS `backend_transport` varchar(10) DEFAULT NULL AFTER `backend_tls`;

-- ---------------------------------------------------------------------
-- 2. What each scheduled task is for
--
-- The Scheduled Tasks page listed a job's name, schedule, container and
-- command and nothing about its purpose. Deciding whether a job is safe to
-- disable meant reading the command, finding the script or endpoint it calls,
-- and reading that. Two of them must never be disabled and nothing on screen
-- said so.
--
-- Console metadata only. ofelia_generate_config.cfm names the columns it
-- selects, so this never reaches the generated Ofelia INI.
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
ALTER TABLE `ofelia_jobs`
  ADD COLUMN IF NOT EXISTS `description` varchar(500) DEFAULT NULL AFTER `job_name`;

-- Matched on job_name, so a renamed or operator-added job is left alone.
-- Re-running simply rewrites the same text.
UPDATE `ofelia_jobs` SET `description` =
  'Renews the Let''s Encrypt certificate for the console and mail hostnames before it expires, then reloads the services that present it. Leave enabled: an expired certificate breaks the console and TLS on SMTP.'
  WHERE `job_name` LIKE '%renew-acme-certificate%';

UPDATE `ofelia_jobs` SET `description` =
  'Enforces the message retention policy by deleting quarantined and archived mail past its retention period. Leave enabled: its real job is stopping the disk filling up, and a full disk defers all mail.'
  WHERE `job_name` LIKE '%hermes-message-cleanup%';

UPDATE `ofelia_jobs` SET `description` =
  'Asks GitHub once a day whether a newer Hermes release exists and caches the answer to a file, which the dashboard reads on every page load. Disabling it means the dashboard stops telling you about updates; nothing else is affected.'
  WHERE `job_name` LIKE '%hermes-update-check%';

UPDATE `ofelia_jobs` SET `description` =
  'Checks that the public DNS for this host still points at this server, so a failed certificate renewal is reported before the certificate actually expires rather than after.'
  WHERE `job_name` LIKE '%acme-validate-ip%';

UPDATE `ofelia_jobs` SET `description` =
  'Watches the outbound mail queue and alerts when it grows past its threshold, which is the earliest sign that delivery has stalled.'
  WHERE `job_name` LIKE '%hermes-health-check-mailqueue%';

UPDATE `ofelia_jobs` SET `description` =
  'Builds the daily DMARC aggregate reports from received mail and sends them to the reporting addresses the sending domains publish.'
  WHERE `job_name` LIKE '%hermes-dmarc-report%';

UPDATE `ofelia_jobs` SET `description` =
  'Rotates and compresses the Authelia authentication logs so they cannot grow without limit.'
  WHERE `job_name` LIKE '%hermes-authelia-log-rotate%';

UPDATE `ofelia_jobs` SET `description` =
  'Emails each recipient about their own newly quarantined messages, within about a minute of arrival. This is how quarantine notification works: there is no periodic digest. Disabling it means recipients are never told.'
  WHERE `job_name` LIKE '%hermes-quarantine-notify%';

UPDATE `ofelia_jobs` SET `description` =
  'Generates the S/MIME certificates and PGP keyrings queued when a mailbox or recipient is created, five at a time. Disabling it leaves new users waiting for keys that never arrive.'
  WHERE `job_name` LIKE '%hermes-process-cert-queue%';

UPDATE `ofelia_jobs` SET `description` =
  'Refreshes the third-party malware signature feeds that supplement the ClamAV database.'
  WHERE `job_name` LIKE '%hermes-fangfrisch-refresh%';

UPDATE `ofelia_jobs` SET `description` =
  'Re-resolves network aliases defined from an SPF record and records what changed. Advisory only: it writes to the alias table and never touches a config file or reloads a service, so a change is not applied until you apply it.'
  WHERE `job_name` LIKE '%hermes-refresh-network-aliases%';

-- ---------------------------------------------------------------------
-- 2b. Directory sync: a description, and an hour instead of six
--
-- The job was seeded by v260918 with INSERT .. SELECT .. WHERE NOT EXISTS
-- rather than INSERT IGNORE, which is why it had no description after section
-- 2 above: that section matches on job_name and the row was there, but the
-- sweep that wrote the descriptions into the baseline missed this form.
--
-- Six hours was too long. Connections with auto-apply enabled create their
-- recipients during the sync, so the interval is how long a new account at the
-- provider waits before it can receive mail here.
--
-- Fifteen minutes is safe rather than merely responsive: no_overlap means a
-- slow run skips the next tick instead of stacking, and the auto-apply budget
-- of 25 per run caps the write side whatever the interval. The only real cost
-- is that every run is a full enumeration, which on a large Microsoft 365
-- tenant is a lot of Graph calls. That same budget means a big onboarding
-- batch takes several runs anyway, which argues for the shorter interval.
--
-- Run Now still covers the impatient case.
--
-- Only the shipped schedule is changed. An operator who has set their own is
-- left alone.
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
UPDATE `ofelia_jobs` SET `description` =
  'Enumerates every enabled directory connection and stages the addresses it finds. Connections with auto-apply switched on also get their recipients created here, so this interval is how long a new account at the provider waits before it can receive mail through Hermes. Run Now forces it.'
  WHERE `job_name` LIKE '%hermes-directory-sync%';

UPDATE `ofelia_jobs` SET `schedule` = '@every 15m'
  WHERE `job_name` LIKE '%hermes-directory-sync%'
    AND `schedule` = '@every 6h';

-- ---------------------------------------------------------------------
-- 3. Bound Dovecot's log files
--
-- Dovecot writes dovecot.log, dovecot-info.log and dovecot-debug.log and grew
-- all three forever. Nothing anywhere rotated them. On a host that had debug
-- logging switched on at some point the debug file reached 1.5 GB. A full data
-- volume defers all mail, which makes this the same class as #339 and #341.
--
-- Runs inside hermes_dovecot, not hermes_commandbox, because the log volume is
-- only mounted there. no_overlap because the first run on a host that has
-- never rotated may be compressing more than a gigabyte.
--
-- WHERE NOT EXISTS rather than INSERT IGNORE: ofelia_jobs has no unique key on
-- job_name, so IGNORE would not dedupe and a re-run would add a second copy.
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs`
  (`job_name`, `description`, `schedule`, `command`, `container`, `type`, `active`, `no_overlap`)
SELECT '[job-exec \"hermes-dovecot-log-rotate\"]',
       'Rotates and compresses Dovecot''s three log files and deletes archives older than 30 days. Nothing bounded them before, so on a host that had debug logging on they grew without limit. Leave enabled: a full data volume defers all mail.',
       '0 15 02 * * *', '/scripts/rotate_dovecot_logs.sh', 'hermes_dovecot', 'system', 1, 1
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM `ofelia_jobs` WHERE `job_name` LIKE '%hermes-dovecot-log-rotate%'
 );

-- ---------------------------------------------------------------------
-- 4. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260929' WHERE parameter = 'build_no';
