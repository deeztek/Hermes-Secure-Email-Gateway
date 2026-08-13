-- =====================================================================
-- Hermes SEG schema updates -- v260807
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
--
-- This release (#292) repairs first-run provisioning defects found on a
-- clean install by an outside reporter. Almost all of the work is in the
-- installer, in schedule/post_upgrade.cfm, and in the rebuilt mail_filter
-- image rather than in the schema, so this file is deliberately small.
--
-- DELIBERATELY ABSENT, and both would be actively wrong here:
--
--   1. The spam_settings default flips. hermes_install.sql now seeds
--      use_dcc / use_pyzor / use_razor2 / bayes_auto_learn to 0 so new
--      installs do not silently transmit message digests to third parties
--      or auto-train Bayes. Existing installs keep whatever their admin
--      chose. Flipping a live gateway's spam configuration during an
--      unattended upgrade would change filtering behaviour without
--      consent, which is not ours to do.
--
--   2. Pre-seeding the two v260807 migrations. hermes_install.sql seeds
--      them as already complete so a FRESH install never runs them.
--      Existing installs are exactly the population that needs them, so
--      they must stay unseeded here and let post_upgrade.cfm do the work.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. DNSBL return-code filters (#293)
--
-- Four seeded postscreen entries shipped with no =returncode filter, so
-- postscreen counted ANY answer in 127.0.0.0/8 as a hit. That range
-- includes the 127.255.255.0/24 codes lists use for "refused" and "over
-- quota", so a gateway whose resolver is being refused scores those
-- refusals as listings. Two of these four answering with error codes
-- reach postscreen_dnsbl_threshold = 3 by themselves and reject
-- legitimate mail.
--
-- This is applied to existing installs, unlike the spam_settings flips
-- below, because it is a correctness fix rather than a preference: it
-- removes no list the admin chose and changes no weight. The weight is
-- carried over from whatever the row already had, so an admin who
-- retuned one keeps their value.
--
-- Idempotent: after the update the row contains '=', which the
-- NOT LIKE '%=%' guard excludes on any re-run.
-- ---------------------------------------------------------------------
UPDATE parameters
   SET parameter = CONCAT('bl.spamcop.net=127.0.0.[2..11]',
                          SUBSTRING(parameter, LENGTH('bl.spamcop.net') + 1))
 WHERE parent_name = 'postscreen_dnsbl_sites' AND child = 1
   AND parameter LIKE 'bl.spamcop.net*%' AND parameter NOT LIKE '%=%';

UPDATE parameters
   SET parameter = CONCAT('bl.suomispam.net=127.0.0.[2..11]',
                          SUBSTRING(parameter, LENGTH('bl.suomispam.net') + 1))
 WHERE parent_name = 'postscreen_dnsbl_sites' AND child = 1
   AND parameter LIKE 'bl.suomispam.net*%' AND parameter NOT LIKE '%=%';

UPDATE parameters
   SET parameter = CONCAT('bl.spameatingmonkey.net=127.0.0.[2..11]',
                          SUBSTRING(parameter, LENGTH('bl.spameatingmonkey.net') + 1))
 WHERE parent_name = 'postscreen_dnsbl_sites' AND child = 1
   AND parameter LIKE 'bl.spameatingmonkey.net*%' AND parameter NOT LIKE '%=%';

UPDATE parameters
   SET parameter = CONCAT('backscatter.spameatingmonkey.net=127.0.0.[2..11]',
                          SUBSTRING(parameter, LENGTH('backscatter.spameatingmonkey.net') + 1))
 WHERE parent_name = 'postscreen_dnsbl_sites' AND child = 1
   AND parameter LIKE 'backscatter.spameatingmonkey.net*%' AND parameter NOT LIKE '%=%';

-- ALSO DELIBERATELY ABSENT: b.barracudacentral.org is no longer seeded for
-- fresh installs (it needs the querying IP registered before it answers, and
-- its weight of 7 exceeds the threshold of 3), but it is NOT deleted here.
-- An existing operator may have registered, and silently removing a block
-- list from a live gateway is the same class of act as flipping their spam
-- settings. The upgrade README tells them how to remove it if they want to.
--
-- NOTE: these UPDATEs change the database only. main.cf still holds the old
-- directive until generate_postfix_configuration.cfm re-renders it, which
-- happens on the next save of any Postfix-backed settings page or on Apply
-- under System / RBL Configuration. The upgrade README makes that a step.

-- ---------------------------------------------------------------------
-- 2. URLhaus feed size limit (#302)
--
-- The urlhaus feed shipped with max_size = 2MB. The feed has since grown
-- past that (observed 3169229 bytes), so fangfrisch refuses it on every
-- run with "size exceeds defined limit" and the ClamAV third-party
-- signatures silently stop updating. fangfrisch still exits 0, so Ofelia
-- records the job as successful and nothing surfaces.
--
-- Raised to 10MB, matching the headroom already given to sanesecurity.
-- Only touches the row still carrying the old default, so an operator who
-- has tuned this value in the Malware Feeds UI keeps their setting.
-- ---------------------------------------------------------------------
UPDATE malware_feeds_config
   SET max_size = '10MB'
 WHERE section_name = 'urlhaus'
   AND max_size = '2MB';

-- NOTE: this changes the database only. /etc/fangfrisch/fangfrisch.conf
-- still holds the old limit until generate_malware_feeds_configuration.cfm
-- re-renders it, which happens on the next save under System / Malware
-- Feeds. The upgrade README makes that a step.

-- ---------------------------------------------------------------------
-- 3. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260807' WHERE parameter = 'build_no';
