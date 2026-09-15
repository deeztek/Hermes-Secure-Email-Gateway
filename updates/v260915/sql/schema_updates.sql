-- =====================================================================
-- Hermes SEG schema updates -- v260915
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Seed relay-network SPF sync settings
-- ---------------------------------------------------------------------
INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'spf_sync_enabled', '0', 'relay_networks', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'spf_sync_enabled'
      AND p.module = 'relay_networks'
);

INSERT INTO parameters2 (parameter, value2, module, active, applied)
SELECT 'spf_sync_server', '_spf.google.com', 'relay_networks', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters2) AS p
    WHERE p.parameter = 'spf_sync_server'
      AND p.module = 'relay_networks'
);

-- ---------------------------------------------------------------------
-- 2. Seed Ofelia relay-network SPF sync job
-- ---------------------------------------------------------------------
INSERT INTO ofelia_jobs (job_name, schedule, command, container, type, active, no_overlap)
SELECT '[job-exec "google-relay-networks"]',
       '@every 30m',
       '/usr/bin/curl --silent http://localhost:8888/schedule/update_google_relay_networks.cfm',
       'hermes_commandbox',
       'hermes',
       1,
       0
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM ofelia_jobs) AS o
    WHERE o.job_name = '[job-exec "google-relay-networks"]'
);
