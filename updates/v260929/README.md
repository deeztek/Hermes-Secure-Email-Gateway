# Hermes SEG v260929

**A per-recipient setting that never did anything now does.** Small release: one
fix, and the documentation that described the broken behaviour as working.

No schema change. No image rebuild.

## Read this first

Nothing in this release changes how your gateway currently routes mail, unless
you had already set a per-recipient backend override. If you did, that override
starts being honoured, which is what you asked for when you set it but may not be
what your mail has been doing since. See below.

## Per-recipient backend overrides now route

Relay Recipients has an **Edit Backend** page for sending one address to a
different server than the rest of its domain. It has been there since early 2026.
It stored the value, displayed it in the Backend column, and had no effect on
delivery whatsoever.

The mail went wherever the domain's transport said, and nothing indicated
otherwise.

**What changes.** Any recipient with an override set now actually goes to that
server, on that port, with that TLS mode.

**Check your existing overrides before upgrading.** If someone set one months ago
and mail kept flowing to the domain default, that is what everyone has come to
expect. After this upgrade it goes where the setting says. Review them under
**Email Relay > Relay Recipients**, where the Backend column shows each override,
and clear any that are stale.

Recipients with no override, which is almost certainly all of them, are
unaffected.

### Why it never worked

The override was designed against a database-backed `transport_maps` lookup that
was never switched on. Postfix was reading a static file instead, and that file
only ever contained one entry per domain.

Every other Postfix lookup in Hermes had already moved from a static file to the
database. Transport was the one left behind, so the query this feature needed had
nowhere to live.

### TLS on an override

The TLS mode on an override now applies too. One detail worth knowing: TLS policy
in Postfix attaches to the **destination server**, not to the recipient. Two
recipients pointed at the same backend therefore share one policy, and if they
disagree the stricter of the two is used for both. If that matters to you, send
them to different backends or give them the same setting.

## Also in this release

**The Getting Started guide now starts with first-login security.** Logging in,
pointing the admin account at a mailbox someone reads, enabling MFA, and changing
the CipherMail console password. That last one ships as `admin` / `admin` and is
the only stock credential in Hermes; it used to be documented under "optional".

The guide also gained sections on backups, on how you would notice a full disk,
and on the fact that fail2ban protects every edition.

**The Relay Recipients documentation** described the backend override as working.
Corrected, and now accurate either way.

## Upgrading

Standard procedure. No manual steps.

```bash
cd /opt/hermes-seg
sudo ./scripts/system_update_docker.sh v260929
```

Take a backup or a snapshot first, as always.

One file is rewritten in place during the upgrade: the Postfix transport lookup,
so that it consults recipient overrides. Your database credentials are read out
of the existing file and carried across, and a timestamped copy is kept beside
it. If the upgrade cannot read those credentials it leaves the file alone and
says so, in which case overrides stay inert and nothing else is affected.
