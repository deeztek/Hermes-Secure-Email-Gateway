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

-- No description for hermes-authelia-log-rotate: section 3 below retires that
-- job, so setting one here would be dead work.

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
-- 2b. Directory sync: a description, and fifteen minutes instead of six hours
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
-- 3. One task that bounds every log volume in the stack
--
-- Eight volumes, and nothing rotated six of them. One had reached 20 GB and a
-- Dovecot debug log 1.5 GB.
--
-- The cause is shared rather than per-service, which is why this is one task
-- and not eight: no Hermes image runs cron or systemd, so the
-- /etc/logrotate.d/* files Ubuntu's own packages install inside them are
-- present and never execute. Rotation only ever happened where something
-- scheduled it explicitly, which was Authelia alone.
--
-- Replaces hermes-authelia-log-rotate and hermes-dovecot-log-rotate. Both
-- rotated one volume each with near-identical logic; the Dovecot one had to
-- hardcode 30 days because it ran in a container with no MySQL client, and the
-- Authelia one never compressed. docker-compose.yml now mounts all eight
-- volumes into hermes_commandbox under /servicelogs, so one task reaches every
-- one of them and can read the retention setting from the database.
--
-- Retention comes from parameters2.system_log_retention, the setting behind
-- System > System Logs that already governs how long rows survive in the Syslog
-- database, so one control covers the rows and the files they came from.
-- Authelia keeps its own value, because it has a separate retention control on
-- the Authentication Settings page that would otherwise stop doing anything.
--
-- WHERE NOT EXISTS rather than INSERT IGNORE: ofelia_jobs has no unique key on
-- job_name, so IGNORE would not dedupe and a re-run would add a second copy.
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs`
  (`job_name`, `description`, `schedule`, `command`, `container`, `type`, `active`, `no_overlap`)
SELECT '[job-exec \"hermes-service-log-rotate\"]',
       'Rotates and compresses every service log volume in the stack: Authelia, Dovecot, Postfix, the mail filter, DMARC, OpenARC, LDAP and Nginx. No Hermes image runs cron or systemd, so the logrotate configuration Ubuntu''s packages install inside them never executes and these grew without limit. Honours the System Log Retention setting, and Authelia''s own retention setting for its log. Leave enabled: a full data volume defers all mail.',
       '0 0 02 * * *', '/opt/hermes/schedule/rotate_service_logs.sh', 'hermes_commandbox', 'system', 1, 1
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM `ofelia_jobs` WHERE `job_name` LIKE '%hermes-service-log-rotate%'
 );

-- Retire the task the above replaces. Only hermes-authelia-log-rotate can
-- actually be present on an existing install; hermes-dovecot-log-rotate was
-- added earlier in this same release and never shipped, so the delete is there
-- for anyone who applied an interim copy of this file by hand.
--
-- The scripts are gone from the image, so leaving these rows would give Ofelia
-- two jobs pointing at files that no longer exist.
DELETE FROM `ofelia_jobs`
 WHERE `job_name` LIKE '%hermes-authelia-log-rotate%'
    OR `job_name` LIKE '%hermes-dovecot-log-rotate%';

-- ---------------------------------------------------------------------
-- 3c. Run Nextcloud's background job queue (#346)
--
-- Nothing ran Nextcloud's cron: no scheduler entry, no cron in the image, and
-- background_jobs mode unset. Nextcloud therefore fell back to AJAX mode, where
-- one queued job fires per page load, so on a gateway whose Nextcloud UI is
-- rarely opened the queue barely turns over.
--
-- Found because log rotation is one of those jobs and so gives a measurable
-- read on it: one install had a 580 MB live log beside a six month old 496 MB
-- archive. The log itself is handled by section 3 above, which takes it off this
-- queue entirely. This is the rest of the queue: trash and file version expiry,
-- previews, notification delivery, token and session cleanup, app repair.
--
-- Five minutes is what Nextcloud documents for cron mode. no_overlap because a
-- backlogged first run can take far longer than the interval.
--
-- user = www-data is required rather than cosmetic: Ofelia's job-exec runs as
-- root by default, and Nextcloud's cron run as root leaves root-owned files in
-- the data directory that www-data then cannot read. This is the first job to
-- use that column, so ofelia_generate_config.cfm and
-- scripts/check_ofelia_seed_drift.sh were both taught to render it.
--
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs`
  (`job_name`, `description`, `schedule`, `command`, `container`, `user`, `type`, `active`, `no_overlap`)
SELECT '[job-exec \"hermes-nextcloud-cron\"]',
       'Runs Nextcloud''s background job queue every five minutes. Without it Nextcloud falls back to AJAX mode, where one job runs per page load, so on a gateway whose Nextcloud is rarely opened the queue barely turns over: trash and file version expiry, previews, notifications and token cleanup all stall. Runs as www-data; running it as root would leave root-owned files in the data directory.',
       '@every 5m', 'php -f /var/www/html/cron.php', 'hermes_nextcloud', 'www-data', 'system', 1, 1
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM `ofelia_jobs` WHERE `job_name` LIKE '%hermes-nextcloud-cron%'
 );

-- ---------------------------------------------------------------------
-- 4. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260929' WHERE parameter = 'build_no';
