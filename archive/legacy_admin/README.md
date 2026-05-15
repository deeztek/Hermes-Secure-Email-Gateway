# Legacy /admin/ Asset Archive

This directory holds files moved out of `config/hermes/var/www/html/admin/`
during the legacy-admin cleanup audit (#227 follow-up, 2026-05-15).

**Contents:** 306 files — 164 legacy NetObjects-era `.cfm` admin pages,
141 PNG/GIF/CSS/JS assets, 1 stray "dads logo.png", and 1
`top_navbar.cfm.adminlte3` backup that was sitting in
`config/hermes/var/www/html/admin/2/inc/`.

> **First pass (commit `cbc2251`)** moved 290 files. **Second pass** moved
> 16 additional files after a corrected audit revealed the first pass's
> "reference checks" were too loose — substring matches whose resolved
> relative paths actually pointed to same-named files in `/admin/2/inc/`
> or `/admin/2/`, not to the legacy `/admin/` root. The second-pass
> orphans:
> `change_password.cfm`, `delete_smime_certificate.cfm`,
> `download_csr.cfm`, `download_message.cfm`, `edit_system_user.cfm`,
> `error.cfm`, `license_invalid.cfm`, `reset_pdf_password.cfm`,
> `reset_portal_password.cfm`, `send_smime_certificate.cfm`,
> `set_crontab.cfm`, `system_update.cfm`, `test.cfm`, `favicon.ico`,
> `assign_icon.png`, `view_icon.png`. All have working same-named
> equivalents in the modern `/admin/2/` tree.

## Why archived rather than deleted

These files are **not deleted** because:

1. They preserved the legacy NetObjects/AdminLTE 3 admin UI prior to
   the active `/admin/2/` AdminLTE 4 migration. Some functionality may
   still be referenced from undocumented bookmarks, training material,
   or documentation outside this repo.
2. If a customer reports a missing feature that we thought was migrated
   but actually wasn't, the original page is here for reference.
3. The disk savings from deletion vs archiving are negligible (the
   files are still in the repo); the win is removing them from the
   webroot so Lucee doesn't serve them.

## What stays in `config/hermes/var/www/html/admin/`

After both passes, only these files remain at the legacy `/admin/` root
(plus the active `/admin/2/` directory):

- `Application.cfc` — Lucee's Application.cfc cascades up; `/admin/2/`
  has no Application.cfc of its own, so requests to `/admin/2/*` use
  this one as their application config. **Required.**
- `index.cfm` — single-line `<cflocation url="/admin/2/index.cfm">`.
  Redirector for `/admin/` URL bookmarks to the active admin app.
- `logout.cfm` — referenced via absolute path `/admin/logout.cfm` from
  active `/admin/2/inc/top_navbar.cfm:86`.

## Audit methodology

The orphan list was built by enumerating every `.cfm` and asset at
`/admin/` root, then grepping the modern `/admin/2/` and `/users/2/`
trees for any reference (string match on the filename in href / src /
cflocation / cfinclude / etc.).

**Important caveat learned in the second pass:** a bare substring
match on the filename is not enough. Many references like
`<cfinclude template="./inc/error.cfm">` from `/admin/2/some_page.cfm`
match the substring `error.cfm` but resolve via the relative path to
`/admin/2/inc/error.cfm` — a same-named file in the modern tree, NOT
the legacy `/admin/error.cfm`. The first pass kept 13 .cfm files based
on these false-positive matches; the second pass removed them after
checking that each "kept" filename had a working same-named copy in
`/admin/2/inc/` or `/admin/2/`.

For future audits, the proper test is:
1. Find each reference to the filename
2. Resolve its relative path from the calling file's directory
3. Check whether that resolved path is `/admin/<file>` (real ref) or
   `/admin/2/...<file>` (false positive — same-named copy elsewhere)

Reference: `/tmp/admin_cleanup/orphan_cfm.txt` and
`/tmp/admin_cleanup/orphan_assets.txt` were the working manifests
generated during the first pass.

## Restoration recipe

If a file in this archive turns out to be needed, restore it with:

```bash
# Move back to /admin/ root
git mv archive/legacy_admin/<filename> config/hermes/var/www/html/admin/<filename>
git commit -m "Restore <filename> from legacy archive: <reason>"
```

Or for a bulk restore (e.g. to roll back the entire archive operation):

```bash
git revert <archive-commit-sha>
```

## Next-pass candidates

After the second pass, the only remaining migration debt at `/admin/`
root is structural: `Application.cfc` and `logout.cfm` are still being
served from the legacy path. Future work could:

1. Migrate `Application.cfc` into `/admin/2/Application.cfc` so the
   legacy root can be eliminated entirely
2. Update the active `top_navbar.cfm:86` to reference
   `/admin/2/logout.cfm` (with a same-named file created there), then
   archive `/admin/logout.cfm`
3. Once 1 and 2 are done, `/admin/index.cfm` could redirect from the
   `/admin/` virtual path via nginx instead of a Lucee CFML page,
   collapsing the legacy root entirely

None of this is blocking the v260119-beta release (`#231`) — it's
post-beta cleanup velocity work.
