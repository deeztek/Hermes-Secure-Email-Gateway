-- =====================================================================
-- Hermes SEG schema updates -- v260815
--
-- Idempotent (safe to re-run). Applied by apply_schema_updates() /
-- system_update_docker.sh for installs upgrading from an earlier build;
-- NOT run on fresh installs (those get the current schema from
-- hermes_install.sql). DBeaver-friendly: plain SQL, no PREPARE/DELIMITER.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Let an alias deliver to more than one destination
--
-- A distribution list is an alias with several destinations. Relay
-- domains could already express that, because virtual_recipients has no
-- constraint stopping the same address appearing more than once, and
-- Postfix concatenates multiple result rows into one recipient list.
-- Mailbox domains could not: uq_alias_address pinned mailbox_aliases to
-- exactly one row, and therefore one destination, per address.
--
-- Dropping that key is what makes the two topologies behave the same.
-- ---------------------------------------------------------------------
ALTER TABLE mailbox_aliases DROP INDEX IF EXISTS uq_alias_address;

-- uq_alias_address was ALSO the index Postfix used for every lookup:
-- mysql-virtual.cf queries `WHERE alias_address = '%s'` on each message.
-- Dropping it without a replacement would turn every alias lookup into a
-- full table scan, so put a plain index back in its place.
CREATE INDEX IF NOT EXISTS idx_alias_address
    ON mailbox_aliases (alias_address);

-- The rule that replaces "one row per address" is "no exact duplicate
-- pair". The console already refuses a repeat of the same address AND
-- destination; this makes the database enforce it rather than trusting
-- the UI to be the only guard. Existing data satisfies it by
-- construction, since alias_address was unique until a moment ago.
CREATE UNIQUE INDEX IF NOT EXISTS uq_alias_dest
    ON mailbox_aliases (alias_address, delivers_to);

-- ---------------------------------------------------------------------
-- 2. Index virtual_recipients.virtual_address
--
-- Unrelated to the constraint change above, and a pre-existing problem:
-- this table has only a PRIMARY KEY on id, so the per-message lookup
-- `WHERE virtual_address = '%s'` has always been a full table scan. It
-- goes unnoticed while a relay domain has a handful of rows and starts
-- to matter as soon as operators build distribution lists here, since a
-- twenty-member list is twenty rows.
--
-- Deliberately NOT adding a unique key on (virtual_address, maps) to
-- match mailbox_aliases. Existing installs may already hold exact
-- duplicates, and ADD UNIQUE would abort the whole upgrade on the first
-- one it met. The console guard covers it; the index is the part worth
-- having.
-- ---------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_virtual_address
    ON virtual_recipients (virtual_address);

-- ---------------------------------------------------------------------
-- 3. Internal-only flag
--
-- Controls who may SEND TO an address, which is a different question from
-- where that address delivers. An internal alias accepts mail only from
-- your own domains and rejects everything from outside.
--
-- This is what makes external destinations safe. Without it, an alias that
-- fans out to twenty external addresses is reachable by anyone on the
-- internet, so one message in becomes twenty out with this gateway doing
-- the relaying. With it, only your own users can post to the list.
--
-- Defaults to 0, permissive, because that is the behaviour every existing
-- alias has today. Turning it on is an admin decision, and flipping live
-- aliases to restrictive during an unattended upgrade would start
-- rejecting mail that currently gets delivered.
-- ---------------------------------------------------------------------
-- Mailbox domains only. Deliberately NOT added to virtual_recipients: a relay
-- domain exists so the internet can send to it, and the customer's own users
-- never traverse this gateway for same-domain mail, since their server is
-- authoritative for the domain and resolves it locally. Restricting a relay
-- address to internal senders would reject the only traffic that reaches it
-- while permitting traffic that never arrives.
ALTER TABLE mailbox_aliases
  ADD COLUMN IF NOT EXISTS internal_only TINYINT(3) NOT NULL DEFAULT 0 AFTER alias_type;

-- ---------------------------------------------------------------------
-- 4. Clean up SAN rows orphaned by the certificate-delete bug
--
-- delete_system_certificate.cfm removed the row from system_certificates
-- and then tried to remove the matching SAN rows from a table called
-- mailbox_domains_sans, which has never existed in this schema. The second
-- statement threw every time, but only AFTER the first had committed, so
-- every certificate deletion on every install to date left its SAN rows
-- behind pointing at a certificate id that is gone.
--
-- The code fix (correct table `mailbox_sans`, correct column `certificate`,
-- and child deleted before parent) stops new orphans. It cannot remove the
-- ones already stranded, which is what this does.
--
-- Idempotent: a second run matches nothing, because the first removed
-- everything that qualified.
--
-- NULL `certificate` means the SAN row is not attached to a certificate yet,
-- which is a legitimate state rather than an orphan, so those are excluded
-- explicitly. NOT EXISTS rather than NOT IN for the same reason: NOT IN
-- yields NULL rather than TRUE when the compared value is NULL, which would
-- silently skip rows for a different reason than the one intended.
-- ---------------------------------------------------------------------
DELETE ms FROM mailbox_sans ms
WHERE ms.certificate IS NOT NULL
  AND NOT EXISTS (
        SELECT 1 FROM system_certificates sc
        WHERE sc.id = ms.certificate
      );

-- ---------------------------------------------------------------------
-- 5. Register the internal-only map as a recipient restriction
--
-- Reachable By is enforced by a check_recipient_access map named in
-- smtpd_recipient_restrictions. That directive is NOT copied from
-- main.cf.HERMES on a running system: generate_postfix_configuration.cfm
-- rebuilds it from this table, taking every child='1' row whose parent_name
-- is 'smtpd_recipient_restrictions' and ordering by order1.
--
-- Without a row here the map is rendered, the column exists and the console
-- stores the setting, but Postfix is never told to consult it. Saving Postfix
-- settings actively removes the line the template put there, because the
-- regenerated directive is assembled purely from these rows.
--
-- order1 = 1.150 places it AFTER permit_mynetworks (1.000), the discard map
-- (1.050) and permit_sasl_authenticated (1.100), and before
-- reject_unauth_destination (2.000). That ordering is the whole design:
-- senders on your own networks and authenticated submission users
-- short-circuit before the check, so anything that reaches the map arrived
-- from outside and a plain REJECT is correct.
--
-- parent is left NULL, matching the discard map row. The Perimeter Checks
-- page lists rows by numeric parent, so a NULL keeps this out of a UI where
-- an admin could disable it independently of the per-alias setting that
-- drives it. The generator matches on parent_name, so it still emits.
-- ---------------------------------------------------------------------
INSERT INTO parameters
    (parameter, name, module, editable, conf_file, description,
     parent, parent_name, child, order1, enabled, applied, action)
SELECT
    'check_recipient_access mysql:/etc/postfix/mysql-internal-only-recipients.cf',
    'Internal Only Recipients Access Check',
    'postfix',
    0,
    'main.cf',
    'Rejects mail from outside your own domains to aliases marked Reachable By: internal only',
    NULL,
    'smtpd_recipient_restrictions',
    1,
    1.150,
    1,
    1,
    'NONE'
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT * FROM parameters) AS p
    WHERE p.parameter = 'check_recipient_access mysql:/etc/postfix/mysql-internal-only-recipients.cf'
      AND p.parent_name = 'smtpd_recipient_restrictions'
      AND p.child = 1
);

-- ---------------------------------------------------------------------
-- 6. Version stamp -- MUST be the last statement (advances build_no so
-- the update orchestrator records this release as applied).
-- ---------------------------------------------------------------------
UPDATE system_settings SET value = 'v260815' WHERE parameter = 'build_no';
