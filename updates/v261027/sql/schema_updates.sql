-- =====================================================================
-- Hermes SEG v261027 schema updates
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Mailboxes added with Add Mailbox on a hybrid domain had no route of
-- their own, so their mail went to the domain default (the provider). In
-- v261026 they were delivered only because the hybrid domain was wrongly
-- treated as mailbox-only, which v261027 undoes (#376). Route them to the
-- built-in server as a conversion does. Mailboxes with any route (built-in
-- or a deliberate custom one) are left alone.
-- FRESH-INSTALL: n/a  repairs data only a pre-existing install can have (hybrid domains)
-- ---------------------------------------------------------------------
UPDATE recipients r
  JOIN domains d ON d.domain = SUBSTRING_INDEX(r.recipient, '@', -1)
   SET r.backend_transport = 'lmtp',
       r.backend_server    = 'hermes_dovecot',
       r.backend_port      = 24,
       r.backend_tls       = NULL
 WHERE d.type = 'hybrid'
   AND r.recipient_type = 'mailbox'
   AND (r.backend_server IS NULL OR r.backend_server = '');

-- ---------------------------------------------------------------------
-- 2. A domain catch-all rewrites an address before Postfix picks its route,
-- so a mailbox on a hybrid domain with a catch-all also needs an entry
-- pointing at itself, as a conversion creates (system = 3). Only for
-- mailboxes routed here with no entry of their own; the catch-all's table
-- decides where the entry goes.
-- FRESH-INSTALL: n/a  repairs data only a pre-existing install can have (hybrid domains)
-- ---------------------------------------------------------------------
INSERT INTO virtual_recipients (virtual_address, maps, system)
SELECT r.recipient, r.recipient, 3
  FROM recipients r
  JOIN domains d ON d.domain = SUBSTRING_INDEX(r.recipient, '@', -1)
 WHERE d.type = 'hybrid'
   AND r.recipient_type = 'mailbox'
   AND r.backend_server = 'hermes_dovecot'
   AND EXISTS (SELECT 1 FROM virtual_recipients c WHERE LOWER(c.virtual_address) = CONCAT('@', LOWER(d.domain)))
   AND NOT EXISTS (SELECT 1 FROM virtual_recipients v WHERE LOWER(v.virtual_address) = LOWER(r.recipient))
   AND NOT EXISTS (SELECT 1 FROM mailbox_aliases a WHERE LOWER(a.alias_address) = LOWER(r.recipient));

INSERT INTO mailbox_aliases (alias_address, delivers_to, domain_id)
SELECT r.recipient, r.recipient, d.id
  FROM recipients r
  JOIN domains d ON d.domain = SUBSTRING_INDEX(r.recipient, '@', -1)
 WHERE d.type = 'hybrid'
   AND r.recipient_type = 'mailbox'
   AND r.backend_server = 'hermes_dovecot'
   AND NOT EXISTS (SELECT 1 FROM virtual_recipients c WHERE LOWER(c.virtual_address) = CONCAT('@', LOWER(d.domain)))
   AND EXISTS (SELECT 1 FROM mailbox_aliases c WHERE LOWER(c.alias_address) = CONCAT('@', LOWER(d.domain)) AND c.delivers_to <> 'discard:silently')
   AND NOT EXISTS (SELECT 1 FROM virtual_recipients v WHERE LOWER(v.virtual_address) = LOWER(r.recipient))
   AND NOT EXISTS (SELECT 1 FROM mailbox_aliases a WHERE LOWER(a.alias_address) = LOWER(r.recipient));

-- ---------------------------------------------------------------------
-- 3. Intrusion Prevention jail for SMTP logins. Failed SASL logins on
-- 587/465/25 were watched by nothing (a test server: 635, none banned). Marked not
-- synced; post_upgrade.cfm regenerates jail.local, which clears the flag.
-- FRESH-INSTALL: covered-by config/database/hermes_install.sql
-- ---------------------------------------------------------------------
INSERT INTO intrusion_prevention_jails
  (jail_name, display_name, description, filter_name, action_name, logpath, port, maxretry, findtime, bantime, enabled, config_synced)
SELECT 'postfix', 'Mail Server (Postfix SMTP)', 'Protects against brute force attacks on SMTP authentication',
       'postfix[mode=auth]', 'hermes-iptables-postfix', '/remotelogs/postfix_dkim/mail.log tail', NULL, 5, 86400, 1800, 1, 0
 WHERE NOT EXISTS (SELECT 1 FROM intrusion_prevention_jails WHERE jail_name = 'postfix');

-- ---------------------------------------------------------------------
-- Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- FRESH-INSTALL: n/a  the installer sets build_no directly for a fresh install
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v261027' WHERE parameter = 'build_no';
