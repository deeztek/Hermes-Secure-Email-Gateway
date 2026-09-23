# Nextcloud Talk and the High-Performance Backend

Operator guide. Turns the Nextcloud that ships with Hermes SEG into a self-hosted
team chat, calls, and meetings platform by enabling **Nextcloud Talk** and
deploying the **high-performance backend (HPB)**.

The signaling stack is a **separate project maintained by Deeztek**, shipped in its own
repository rather than bundled with Hermes SEG, because it runs on its own host:
<https://github.com/deeztek/deeztek-docker/tree/master/Linux/nextcloud-spreed-signaling>.

## Scope and decisions

- **Talk without the HPB is unreliable.** The built-in peer-to-peer mode often fails
  to connect even one-to-one calls, and group calls degrade fast. **Treat the HPB as
  effectively required, not optional** for dependable calls and meetings; the built-in
  mode is a preview. This guide assumes you are deploying the HPB.
- **The signaling stack runs on a separate host with a public IP** (a different
  machine from Hermes, not necessarily one reserved exclusively for signaling), under
  its own hostname (for example `signal.yourdomain.com`), and terminates its own TLS.
  Keep it off the Hermes host on purpose: **real-time media (Janus, coturn) is CPU-,
  memory-, and bandwidth-heavy, and must not compete with mail filtering and delivery**
  on the box whose primary job is email. The host needs a **public IP** so the media
  relay can connect calls reliably, and the media components need their own ports.
  Co-hosting it behind Hermes's existing ingress is possible but requires reworking its
  nginx/TLS so it does not claim 80/443, and it still leaves the two workloads fighting
  for CPU and bandwidth; that is an advanced path and not covered here.

## What gets deployed

Six containers, via the repo's install script:

| Container | Role |
|---|---|
| `nextcloud_spreed_nginx` | reverse proxy + TLS termination for the signaling FQDN |
| `nextcloud_spreed_backend` | the signaling server (coordinates calls) |
| `nextcloud_spreed_janus` | WebRTC media server (SFU) that redistributes streams |
| `nextcloud_spreed_coturn` | STUN/TURN relay for NAT/firewall traversal |
| `nextcloud_spreed_nats` | message broker between signaling and media |
| `nextcloud_spreed_cron` | Ofelia scheduler for certificate renewal |

## Prerequisites

Gather before you start:

- **Signaling FQDN**, e.g. `signal.yourdomain.com`
- **Your Hermes Nextcloud URL**, with scheme. In Hermes the Nextcloud is served at a
  **path on the console host**, not a separate subdomain: `https://<console-host>/nc/`
  (for example `https://mail.yourdomain.com/nc/`). This is the value the installer's
  "Nextcloud URL" prompt expects. The Nextcloud runs in the `hermes_nextcloud` container
  behind `hermes_nginx`.
- **Public IP** of the signaling host (advertised to clients)
- **Bind IP** (optional; only if the host has multiple interfaces or is behind 1:1 NAT)

The host needs `git`, `curl`, `openssl`, and Docker with the compose plugin.

**One note on `occ`.** Setup is done entirely in the Nextcloud web UI. The only place
this guide reaches for the CLI is the optional *verification* step at the end, and even
that is only needed if a client refuses to use the backend. `occ` is not on your PATH;
it runs inside the `hermes_nextcloud` container as the `www-data` user:

```
docker exec -u www-data hermes_nextcloud php occ <args>
```

The `-u www-data` is required; running `occ` as root is refused.

## Firewall ports (on the signaling host)

| Port | Protocol | Purpose |
|---|---|---|
| 80 | tcp | Let's Encrypt challenge + HTTPS redirect |
| 443 | tcp | signaling websocket + API |
| 3478 | tcp + udp | STUN / TURN |
| 5349 | tcp + udp | TURN over TLS |
| 20000-20099 | udp | Janus media (RTP/RTCP) |
| 49160-49200 | udp | coturn relay |

The two UDP ranges are configurable in `/opt/nextcloud-spreed-signaling/.env`
(`JANUS_RTP_MIN`/`JANUS_RTP_MAX`, `TURN_RELAY_MIN`/`TURN_RELAY_MAX`). The signaling
host needs a public IP; media relaying through a heavily NATed host is where calls most
often fail to connect.

## DNS

Point the FQDN at the signaling host before installing, and confirm the listener
matches:

```
dig +short signal.yourdomain.com
ss -lntp | grep ':80'
```

Both should reflect the same host.

## Install

Run these on the **signaling host**, not on Hermes. The installer and the compose stack
it deploys are maintained by Deeztek alongside Hermes SEG, so they track the same
Nextcloud versions Hermes ships.

```
sudo git clone https://github.com/deeztek/deeztek-docker.git
cd deeztek-docker/Linux/nextcloud-spreed-signaling
sudo bash install_nextcloud_signal.sh
```

The script creates `/opt/nextcloud-spreed-signaling/`, brings up the six containers,
and **generates and records the secrets** you will need in the Nextcloud step:
Static Secret, Hash Key, Block Key, Shared Secret, Api Key, Internal Shared Secret.
Keep the install output; two of these values are pasted into Nextcloud below.

## TLS certificate

The stack starts with a self-signed cert. Move to Let's Encrypt by testing staging
first, then production (staging avoids burning rate limits on a misconfiguration):

```
sudo bash certbot_certificate_staging.sh
# if staging succeeds:
sudo bash certbot_certificate_production.sh
```

Both read the FQDN from `.env` and set up renewal via the scheduler container.

## Connect the Hermes Nextcloud to the backend

In the Hermes Nextcloud, as an administrator:

1. **Enable the Nextcloud Talk app.** It is not enabled by default in the Hermes SEG
   Nextcloud, and the Talk admin settings in the following steps do not appear until
   it is on. This needs the **local Nextcloud admin**, which takes one extra step in
   Hermes: see [Enabling Talk requires the local Nextcloud admin](#enabling-talk-requires-the-local-nextcloud-admin)
   immediately below.
2. Go to **Settings &rarr; Administration &rarr; Talk**.
3. **STUN servers:** add `signal.yourdomain.com:3478`.
4. **TURN servers:** choose `turns:` only, host `signal.yourdomain.com:5349`, and in
   the secret field paste the **Static Secret** from the install output.
5. **High-performance backend:** click **+**, enter
   `https://signal.yourdomain.com/standalone-signaling/`, and in the shared-secret
   field paste the **Shared Secret** from the install output.

Which secret goes where matters: **Static Secret &rarr; TURN**, **Shared Secret &rarr; HPB**.

### Enabling Talk requires the local Nextcloud admin

Installing or enabling an app under **Apps** is an administrator action in Nextcloud
itself. In Hermes, Nextcloud sign-in normally goes through Authelia OIDC, and an
OIDC-federated mailbox user is an ordinary Nextcloud user, not a Nextcloud
administrator. So the **Apps** page is not reachable while OIDC is in the way, no
matter which Hermes account you use.

Hermes ships a supported way to get in, so do not disable anything by hand:

**Email Server Settings &rarr; Nextcloud Maintenance Mode**

| # | |
|---|---|
| 1 | Click **Enter Maintenance Mode**. This disables the `user_oidc` app |
| 2 | Open `https://<console-host>/nc/` **in an incognito or private window** and sign in with the **local admin credentials shown on that card**. The incognito window matters: an existing SSO session in your normal browser will keep you signed in as the wrong user |
| 3 | In Nextcloud, go to **Apps**, find **Talk**, and enable it |
| 4 | Return to the Hermes console and click **Exit Maintenance Mode** to re-enable OIDC |

> **Mailbox-user SSO into Nextcloud is offline for as long as maintenance mode is on.**
> Users cannot sign in to Nextcloud during that window, so keep it short and do it
> outside business hours if that matters to you. Exiting maintenance mode restores SSO
> immediately.

The local admin username is displayed on the Maintenance Mode card. Both values are
generated at install time and stored on the Hermes host under the install root:

```
<install-root>/config/hermes/opt/hermes/creds/nextcloud_admin_username
<install-root>/config/hermes/opt/hermes/creds/nextcloud_admin_password
```

That directory is mounted into the containers as `/opt/hermes/creds/`.

Note that the **Auto-redirect to SSO** setting on the same page does *not* do this
job. Turning auto-redirect off still leaves `user_oidc` active, so the local login
form is still not usable. Maintenance Mode is the only toggle that gets you in.

Once Talk is enabled it stays enabled. This is a one-time step per installation, not
something you repeat when configuring the backend.

## Verify

Confirm Nextcloud is actually using the external backend, not the built-in path:

```
docker exec -u www-data hermes_nextcloud php occ config:app:get spreed signaling_mode
```

If it still returns `internal` after configuring the HPB, clear the override:

```
docker exec -u www-data hermes_nextcloud php occ config:app:delete spreed signaling_mode
```

During a live test call, confirm media is reaching the backend:

```
docker exec nextcloud_spreed_backend wget -qO- http://127.0.0.1:8080/api/v1/stats
```

Non-zero `rooms` and `sessions` mean clients are connected through the HPB.

## Media connectivity notes

Two `.env` values decide whether calls connect:

- **`PUBLIC_IP`** is advertised to clients and used by Janus and coturn.
- **`BIND_IP`** is the local interface the published ports listen on (optional).

On a host with a direct public IP the two match. Behind 1:1 NAT, `PUBLIC_IP` is the
public address and `BIND_IP` is the local interface.

## Client sign-in

End users install the Talk apps (Windows, macOS, Linux, iOS, Android) and point them
at the Hermes Nextcloud, `https://<console-host>/nc/`, or use it in the browser.

**Hermes accepts either the user's normal Hermes credentials or an app password** to
sign in to Talk. Users can log in with the username and password they already use, or
with a per-device **app password** (the same per-device credential mechanism Hermes
offers for the mail and DAV clients). Both work for the desktop apps, the mobile apps,
and the browser.

## Upgrading

```
sudo bash upgrade_nextcloud_signal.sh
```

Prompts for the release version, stops the stack, updates the Janus image, pulls new
images, and restarts while preserving local configuration.

## What you get, and what you do not

Talk is a **Community Edition** capability. Nextcloud ships with Hermes, Talk is a
free Nextcloud app, and the HPB is optional infrastructure you host yourself. There
is no paid tier involved at any point.

| Capability | Available |
|---|---|
| Team chat | yes |
| Voice and video calls | yes, with the HPB deployed |
| Meetings with multiple participants | yes, with the HPB deployed |
| Screen sharing | yes |
| Screen **control** (taking over a remote desktop) | no |
| Desktop clients | Windows, macOS, Linux |
| Mobile clients | iOS, Android |
| Browser | yes, no client install needed |
| Real-time document co-authoring | **no**. That is Nextcloud Office (Collabora), a separate app, out of scope here |

Calls and meetings without the HPB are a preview rather than a feature. The built-in
peer-to-peer mode frequently fails to connect even one-to-one, so treat the HPB as
required if anyone is going to rely on this.
