-- =====================================================================
-- Hermes SEG schema updates -- v260731
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- This release (#288) repairs the scheduler on EXISTING installs.
--
-- `config/ofelia/config.ini` is a GENERATED artifact that was nonetheless
-- committed to the repo, frozen at the v260612 release, and bind-mounted
-- straight onto /etc/ofelia. Nothing regenerated it at install or upgrade,
-- so installs have been running that stale snapshot: four seeded jobs
-- missing outright and hermes-update-check still pointed at the pre-#218
-- update_check.sh wrapper (hence a permanent "UPDATE CHECK PENDING" on the
-- dashboard).
--
-- The render itself is not a schema concern -- system_update_docker.sh
-- phase 4 now re-renders config.ini from `ofelia_jobs` on every upgrade.
-- What this file does is make sure the TABLE it renders from is complete
-- and correct first, since an install seeded before a given job existed
-- would otherwise render a config that is still missing it.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Backfill any missing scheduled jobs.
--
-- Keyed on job_name. `id` is deliberately omitted so AUTO_INCREMENT
-- assigns it -- the baseline's explicit ids are historical and must not
-- be reused here (they may already be taken by an admin-added job).
-- ---------------------------------------------------------------------
INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "renew-acme-certificate"]', ' 0 05 12 * * *',
       '/opt/hermes/schedule/renew_acme_certificate.sh', 'hermes_commandbox', 'certbot', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "renew-acme-certificate"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-message-cleanup"]', ' 0 30 01 * * *',
       '/usr/bin/curl --silent http://localhost:8888/schedule/message_cleanup.cfm', 'hermes_commandbox', 'hermes', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-message-cleanup"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-update-check"]', ' 0 30 04 * * *',
       '/usr/bin/curl --silent http://localhost:8888/schedule/check_for_update.cfm', 'hermes_commandbox', 'hermes', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-update-check"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "acme-validate-ip"]', '@every 30m',
       '/usr/bin/curl --silent http://localhost:8888/schedule/acme_validate_ip.cfm', 'hermes_commandbox', 'certbot', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "acme-validate-ip"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-health-check-mailqueue"]', '@every 15m',
       '/usr/bin/curl --silent http://localhost:8888/schedule/health_check_mailqueue.cfm', 'hermes_commandbox', 'pushover', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-health-check-mailqueue"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-dmarc-report"]', '0 30 02 * * *',
       '/opt/hermes/schedule/dmarc_report_script.sh', 'hermes_dmarc', 'dmarc', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-dmarc-report"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-authelia-log-rotate"]', '0 0 02 * * *',
       '/opt/hermes/schedule/rotate_authelia_logs.sh', 'hermes_commandbox', 'system', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-authelia-log-rotate"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-quarantine-notify"]', '@every 60s',
       '/usr/bin/curl --silent http://localhost:8888/schedule/quarantine_notify.cfm', 'hermes_commandbox', 'system', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-quarantine-notify"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-process-cert-queue"]', '@every 60s',
       '/usr/bin/curl --silent http://localhost:8888/schedule/process_cert_queue.cfm', 'hermes_commandbox', 'system', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-process-cert-queue"]');

INSERT INTO `ofelia_jobs` (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "hermes-fangfrisch-refresh"]', '@every 10m',
       '/usr/bin/fangfrisch --conf /etc/fangfrisch/fangfrisch.conf refresh', 'hermes_mail_filter', 'malware_feeds', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `ofelia_jobs` WHERE job_name = '[job-exec "hermes-fangfrisch-refresh"]');

-- ---------------------------------------------------------------------
-- 2. Retire the pre-#218 update-check wrapper.
--
-- /opt/hermes/schedule/update_check.sh shells out for an api_tokens row
-- and POSTs through the since-removed /hermes-api/ endpoint, so it can
-- never write /opt/hermes/updates/check_system_update.txt -- the file the
-- dashboard widget reads. Installs carrying that command in the DB would
-- keep rendering it into config.ini even after the render is fixed.
--
-- Job commands are not admin-editable (view_scheduled_tasks.cfm is
-- read-only by design), so correcting this cannot clobber an operator
-- preference. Scoped to the exact legacy value; a row already holding the
-- curl command is untouched.
-- ---------------------------------------------------------------------
UPDATE `ofelia_jobs`
   SET command = '/usr/bin/curl --silent http://localhost:8888/schedule/check_for_update.cfm'
 WHERE job_name = '[job-exec "hermes-update-check"]'
   AND command  = '/opt/hermes/schedule/update_check.sh';

-- ---------------------------------------------------------------------
-- 3. Version stamp -- MUST be the last statement (advances build_no so the
-- update orchestrator records this release as applied).
--
-- NOTE for boxes reporting an older build than they actually run: fresh
-- installs of v260628 / v260630 / v260722 / v260723 all stamped v260612,
-- because the baseline's build_no literal was the only value a fresh
-- install ever got (#288). Such a box will replay every intervening
-- release directory on its first upgrade -- all of them are idempotent,
-- so that is safe, and it lands here with the correct stamp.
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260731' WHERE parameter = 'build_no';
