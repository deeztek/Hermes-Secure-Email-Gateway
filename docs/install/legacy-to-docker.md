# Legacy to Docker: the whole path

Moving a bare-metal Hermes SEG installation onto Docker, start to finish.

> ## Install **v260912**, not the latest release
>
> **v260912 is the final release that supports this migration.** Later releases
> do not carry the migration script at all, so installing the newest version
> and then trying to migrate will not work.
>
> The route is: install v260912, migrate into it, then upgrade forward. A
> migrated gateway is an ordinary v260912 install and takes the normal upgrade
> path from there, so you end up on the current release either way.

## What this covers

| Stage | Where |
| --- | --- |
| 1. Back up the legacy gateway | this page |
| 2. Provision the Docker host | this page |
| 3. Install v260912 | this page |
| 4. Run the migration | this page |
| 5. Verify it | this page |
| 6. Post-migration configuration | [checklist](legacy-to-docker-post-migration.md) |
| 7. Upgrade to the current release | [checklist](legacy-to-docker-post-migration.md), step 12 |

Read the [post-migration checklist](legacy-to-docker-post-migration.md) before
you start, not after. It explains why outbound mail is deliberately held for
the whole process, which is the single most surprising thing about the
migration if you meet it unprepared.

## Scope

Validated for legacy build **240815** in a relay topology. The migration script
rejects any other source build rather than guessing.

If your legacy gateway is on an older build, update it to 240815 on bare metal
first, using the legacy update process.

---

## 1. Back up the legacy gateway

On the **legacy** machine, run its own backup script:

```bash
sudo /opt/hermes/scripts/system_backup.sh
```

It produces two files:

| File | Contents |
| --- | --- |
| `hermes-system-<build>-<date>.tar.gz` | Databases, configuration, keys, certificates |
| `hermes-archive-<build>-<date>.tar.gz` | Quarantined message bodies |

Only the **system** backup is needed to migrate. The archive is restored later,
separately, and needs no downtime.

Copy both somewhere the new host can reach.

## 2. Provision the Docker host

A new machine or VM. The legacy one stays untouched, which is your fallback.

| | |
| --- | --- |
| OS | Ubuntu 24.04 Server is the tested reference |
| vCPU | 4 minimum |
| RAM | 8 GB minimum, 16 GB or more for production |
| Disk | 120 GB for the OS and images, plus the four storage tiers |
| Network | Outbound to the container registry, and outbound UDP/TCP 53 to the root servers |

Install Docker Engine 24.0 or later and Compose v2.

See [Storage topology](storage-topology.md) for sizing the four data tiers. For
a small gateway they can share one disk.

## 3. Install v260912

```bash
sudo -i
git clone https://github.com/deeztek/Hermes-Secure-Email-Gateway.git /opt/hermes-seg
cd /opt/hermes-seg
git checkout v260912
./scripts/install_hermes_docker.sh
```

The `git checkout v260912` is the important line. Without it you get the latest
release, which cannot migrate.

Answer the installer's prompts as though this were a new gateway. Hostname,
storage paths and so on are all rewritten from the restored data afterwards, so
do not agonise over them, but the storage paths do need to be real.

Let the install finish and confirm the containers are healthy:

```bash
docker compose ps
```

The migration restores **into** a running stack, so this step is not optional.

## 4. Run the migration

Copy the system backup onto the host, then:

```bash
cd /opt/hermes-seg
./scripts/migrate_legacy_to_docker.sh
```

It asks what to restore. Choose **system** now; the archive comes later.

What it does, roughly in order:

1. Holds all outbound delivery, so the restored quarantine cannot mail real
   recipients before you have reviewed it
2. Restores the `hermes`, `djigzo`, `opendmarc` and `Syslog` databases
3. Brings the schema forward from the legacy build to the current baseline,
   adding missing columns and carrying seeded rows the legacy database never had
4. Copies portable data: the encryption key, TLS certificates, DKIM signing keys
5. Migrates Authelia admins into LDAP as one-factor accounts
6. Rewires host identity and re-renders the service configs for this machine

It will ask whether to run host rewiring. Say yes.

> **Outbound mail is held from this point on.** That is deliberate, not a fault.
> You release it as the final step of the checklist, after reviewing the queue.

## 5. Verify it

```bash
sudo ./scripts/verify_legacy_migration.sh
```

Read-only, seconds, and it answers what the migration log cannot: whether the
schema bridge landed what it claimed. It exits non-zero on failure.

Do this **before** restoring the archive. There is no reason to sit through a
long archive restore only to find the database half did not work.

A `NOTE` is for your judgement rather than a failure. Duplicate natural keys,
for example, are usually rows the legacy gateway already had; the migration is
additive and never rewrites operator data.

## 6. Post-migration configuration

Work through the [post-migration checklist](legacy-to-docker-post-migration.md).
It covers regenerating mail authentication, two-factor for migrated admins,
the Pro licence, certificates, the archive restore, and releasing outbound
delivery last.

## 7. Upgrade to the current release

Step 12 of the checklist. Once mail is flowing on v260912, bring the gateway
forward with the normal update process. From here on it is an ordinary
installation with no migration-specific handling at all.

---

## If something goes wrong

The legacy gateway is untouched and still able to run. Nothing in this process
modifies it, which is why cutting over is safe to attempt more than once.

The migration is re-runnable against the same backup on a rebuilt Docker host.
That is usually faster and more predictable than repairing a half-migrated one.
