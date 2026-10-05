# Release testing methodology (Test box)

Companion to [release-and-update-methodology.md](release-and-update-methodology.md).
That document says *when* to test, at step 10 of the release cut. This one says
*how*, and records the constraints of the Test box so they are not rediscovered
every release.

Everything here is for maintainers. None of it is needed to run Hermes.

## What the Test box is, and is not

| | |
| --- | --- |
| **Is** | a full git checkout at the install root, so `git reset --hard <tag>` is the deploy step |
| **Is** | the only host that exercises a release end to end: fresh install, upgrade, and legacy migration |
| **Is not** | reachable by inbound mail from the Internet |
| **Is not** | guaranteed outbound Internet access |
| **Is not** | DEV. DEV never takes a release and is deployed file by file |

Both "is not" lines have bitten. They are the reason for the two sections below.

### No outbound Internet: anything that calls out must be skippable

Set **Check Password Against haveibeenpwned.com** to **NO** on any form that
offers it. Without it, `check_hibp.cfm` fails closed and the form refuses the
password with "Password Check Unavailable".

Forms that offer the choice: System Users, Password Reset Requests, Add
Mailbox, Edit Mailbox. The mailbox ones only gained it in v260929, after the
Test box could not create a mailbox at all.

**If a new feature calls an external service in a path a user has to complete,
it needs an opt-out before it ships.** Fails-closed on a third party is a
defect, not caution.

### No inbound mail: inject locally instead

You do not need inbound mail to test delivery, routing, or the content filter.
Inject from inside the gateway and read the transport decision out of the log,
which is what most mail-path assertions actually depend on.

```bash
printf 'From: sender@domain.tld\nTo: RECIPIENT\nSubject: local test\n\nbody\n' \
  | docker exec -i hermes_postfix_dkim sendmail -f sender@domain.tld RECIPIENT

sleep 15
docker exec hermes_postfix_dkim grep 'RECIPIENT' /var/log/mail.log | tail -3
```

This traverses Postfix cleanup, the Amavis content filter, the re-injection
port, `transport_maps`, and final delivery. The only thing it does not exercise
is inbound `smtpd` from a remote host, which is a connection-level concern
rather than a routing one.

Read the `relay=` field, because that is the routing decision:

| `relay=` shows | Means |
| --- | --- |
| `hermes_dovecot[...]` | delivered to a local mailbox |
| a backend hostname | routed out to that server |
| `none` with a reject | refused before delivery; read the reason |

A `Connection refused` against a backend host is often a **pass**: it proves
the transport lookup resolved to that host, which is what was under test.
Nothing requires the backend to accept the message.

## The per-release checks

### 1. The asserting script

Prefer assertions over output you have to read. A check that prints a value
someone has to judge gets judged wrongly at the end of a long day. The
v260929 script is the model: one line per claim, each `PASS`/`FAIL` with the
expected value, and a count at the end.

Cover at minimum: the release stamp, every column and seed row the release
adds, the rendered generated artifacts, and the state of anything the release
retired.

### 2. Both install paths, fresh first

```bash
# fresh: --image-version is REQUIRED. .env.template ships `latest`, and
# `latest` is still the PREVIOUS release until the very end of the cut.
sudo ./scripts/install_hermes_docker.sh \
    --registry=<staging registry> --image-version=v<DATE>

# upgrade: --remote=gitlab because GitHub has no tag yet
sudo ./scripts/system_update_docker.sh --remote=gitlab v<DATE>
```

Fresh install first. It is the defect class that has shipped undetected most
often, because DEV is never installed from scratch and so cannot catch it.
v260929 found two that way: a root-owned Nextcloud data directory that stopped
Nextcloud installing, and the HIBP dead end.

### 3. Run things twice

Three of the four defects found in v260929's log rotation only appeared on a
second invocation, or on inspecting what the first had left behind. A clean
first run is weak evidence.

```bash
docker exec hermes_commandbox /opt/hermes/schedule/rotate_service_logs.sh
docker exec hermes_commandbox /opt/hermes/schedule/rotate_service_logs.sh
```

The second run should be near-silent. If it does substantial work again, it is
reprocessing rather than appending.

### 4. Test against real data, not fixtures

Fixture testing passed every time while four real defects went unnoticed, and
all four were about **magnitude**: a 10.4 GB log, a 700 MB archive, forty
unexpected files in a directory, and a 10.4 GB file whose name happened not to
match a glob.

Where a feature touches files, disks or queues, point it at something the size
of what a real install holds.

### 5. Verify the artifact, not the source

A Dockerfile change is not evidence the image has it:

```bash
docker run --rm --entrypoint sh <registry>/hermes-<svc>:v<DATE> -c '<check>'
```

Compare against the previous release's image so a negative result is
meaningful rather than ambiguous.

## Things that need contrived setup to be reachable

Some code only runs under conditions a normal test does not produce. Each of
these needs deliberate arrangement or it silently is not tested.

| Behaviour | Why a normal run misses it | Arrangement |
| --- | --- | --- |
| Image pruning on upgrade | keeps the newest two releases, and Test has exactly two | pull a third, older release's images first |
| Nextcloud multi-major refusal | short-circuits when live and declared versions match, which they do on any normal upgrade | not practically reachable; accept unit-level verification, and note that it only ever *refuses*, so a false positive is loud and harmless |
| Legacy migration guard | needs a migration run | run the script from the current checkout and expect it to refuse |
| Retention deletion | archives must be older than the retention period | `touch -d '40 days ago'` on an archive, then re-run |

Where something cannot be reached, say so in the release notes rather than
implying it was tested.

## What Test cannot tell you

Test cannot validate anything that depends on the public registry, the GitHub
Release, or `:latest`, because none of those exist yet at step 10. That is
deliberate: holding them back is what keeps the tag movable. Those are verified
at step 14, after publication.
