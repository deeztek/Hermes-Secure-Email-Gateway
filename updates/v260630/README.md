# Hermes SEG v260630

> ## ⚠️ ACTION REQUIRED AFTER UPGRADING
>
> This release adds a **public landing page** at the console root (`/`) and moves
> the login portal to `/auth`. These changes live in the nginx **templates**, so
> **existing installs must regenerate their nginx configuration to activate them.**
>
> **➜ After upgrading, an administrator must open
> `System → Console Settings` and click _Save & Apply Settings_ once.**
> No fields need to change — saving re-renders both nginx configs from the updated
> templates and reloads nginx.
>
> **Nothing breaks if you skip it** — the console keeps its current behavior — **but
> the new landing page and login routing will not appear until you do.**
>
> **Behavioral change once regenerated:** visiting the bare console URL
> (`https://<your-host>/`) now shows a **landing page** with links to the User and
> Admin consoles, instead of going straight to the Authelia login. The login screen
> moves to `/auth`. Direct links to `/admin`, `/users`, `/nc/`, `/ciphermail`, etc.
> are unchanged and continue to work exactly as before.

This release follows [v260628](../v260628/README.md).

## What's new

### Public landing page at the console root (#283)

Browsing the bare console hostname now lands on a clean splash page instead of an
immediate login prompt:

- **User Console** is the prominent call-to-action — for **mailbox and relay users**
  to review quarantined mail, manage their account & security, and (mailbox users)
  access webmail.
- **Admin Console** is a deliberately secondary link for administrators.

Login is functionally unchanged — it simply moves to `/auth` so the root URL can host
the landing page. Every existing entry point (`/admin`, `/users`, `/nc/`, `/ciphermail`)
behaves exactly as before.

### Friendlier direct `/nc/` (webmail) access

Typing the Nextcloud URL (`/nc/`) directly while logged out previously dead-ended on a
Nextcloud "Page not found" (a known OIDC URL-mangling quirk when the session cookie
isn't primed first). Cold `/nc/` visits are now routed to the User Console, where the
**Webmail** link opens Nextcloud cleanly via the normal primed flow.

## Upgrading

This release ships **no schema changes** and **no new containers** — but it **does**
require the nginx regeneration step from the top of this document.

1. **Update the code.** Git-based (e.g. Test): `git fetch && git reset --hard <tag>`,
   or run the standard orchestrator (`scripts/system_update_docker.sh`).
2. **Regenerate nginx (required):** `System → Console Settings → Save & Apply
   Settings`. This re-renders `hermes-ssl.conf` + `auth.conf` from the updated
   templates and reloads nginx.
3. **Verify:** `https://<host>/` → landing page · `/admin` + `/users` → `/auth` login ·
   `/nc/` (logged out) → User Console.

> **Why a manual step?** Hermes renders its live nginx config from templates via the
> Console Settings / host-configuration flow; routine upgrades do not currently
> re-render it automatically. A future release will fold this into the post-upgrade
> hook (`schedule/post_upgrade.cfm`) so the step becomes automatic.

---

*Issue: [#283](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/283). For how Hermes is released and upgraded, see
[`docs/install/release-and-update-methodology.md`](../../docs/install/release-and-update-methodology.md).*
