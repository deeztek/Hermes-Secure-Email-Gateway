# Ciphermail build inputs

The `hermes-ciphermail` image packages the **CipherMail Community Gateway**.

## Upstream source

CipherMail Community Gateway is a separate project with its own source and license:

- **Source:** https://gitlab.com/ciphermail/ciphermail-community-gateway/

The `.deb` packages here are builds of that upstream project, not Hermes code.

## Version pin (important)

Hermes is currently pinned to **CipherMail 5.5.3** under the **legacy `djigzo*`
package names** (`djigzo_…`, `djigzo-web_…`). Upstream has since **renamed** the
packages and moved to **6.x**:

| Hermes vendors (5.5.3) | Upstream now (6.x) |
|---|---|
| `djigzo_…_all.deb` | `ciphermail-gateway-backend_…_all.deb` |
| `djigzo-web_…_all.deb` | `ciphermail-admin-ui_…_all.deb` |
| (none) | `ciphermail-cli_…_all.deb` (new) |
| bundled `apache-tomcat-…tar.gz` | no separate tomcat asset (web layer reworked) |

So the **current** [releases page](https://gitlab.com/ciphermail/ciphermail-community-gateway/-/releases)
shows only 6.x — the 5.5.3 `djigzo` originals we build from live in upstream's
**older/pre-6.x releases** (or the maintainer's archive), not the latest page.

Upgrading to 6.x is a major-version effort (renamed packages, config + DB-schema
changes, web/serving rework) tracked in **issue #280** — not a drop-in swap.

## What's tracked vs. not (and why)

| File | Tracked? | Notes |
|------|----------|-------|
| `*-nosystemd.deb` | **yes** | What the `Dockerfile` actually `COPY`s. Produced from the vendor originals by `repack-debs-nosystemd.sh` (strips the systemd dependency so the package installs in a container). Tracked so contributors can `docker build` without re-running repack. |
| `apache-tomcat-*.tar.gz` | yes | Servlet container the gateway runs on. |
| `*_all.deb` (vendor originals) | **no** (gitignored) | Only `repack-debs-nosystemd.sh` consumes these. Download from the [upstream project](https://gitlab.com/ciphermail/ciphermail-community-gateway/) (or your CipherMail source) and place them here if you need to regenerate the `-nosystemd` packages. |
| `data.tar.xz` | no (gitignored) | Extraction artifact. |

## Regenerating the `-nosystemd` packages (maintainers)

1. Obtain the vendor original `*_all.deb` packages (upstream link above) and put them in this directory.
2. Run `./repack-debs-nosystemd.sh` — it produces the `*-nosystemd.deb` files.
3. Commit the updated `*-nosystemd.deb` (the originals stay gitignored).
