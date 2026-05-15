# Legacy /admin/ Asset Archive

This directory holds files moved out of `config/hermes/var/www/html/admin/`
during the legacy-admin cleanup audit (#227 follow-up, 2026-05-15).

**Contents:** 290 files — 151 legacy NetObjects-era `.cfm` admin pages,
138 PNG/GIF/etc. assets, 1 stray "dads logo.png", and 1
`top_navbar.cfm.adminlte3` backup that was sitting in
`config/hermes/var/www/html/admin/2/inc/`.

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

After the move, only these files remain at the legacy `/admin/` root
(plus the active `/admin/2/` directory):

### Required infrastructure (3)

- `Application.cfc` — CFML framework requirement
- `index.cfm` — entry point at `/admin/` URL
- `logout.cfm` — referenced from active `/admin/2/inc/top_navbar.cfm`

### Still actively referenced from `/admin/2/` (13 .cfm)

These have known active references from the modern `/admin/2/` app and
must remain until those references are migrated to `/admin/2/`
equivalents:

- `change_password.cfm`
- `delete_smime_certificate.cfm`
- `download_csr.cfm`
- `download_message.cfm`
- `edit_system_user.cfm`
- `error.cfm` (139 active refs — heavily used error display include)
- `license_invalid.cfm`
- `reset_pdf_password.cfm`
- `reset_portal_password.cfm`
- `send_smime_certificate.cfm`
- `set_crontab.cfm`
- `system_update.cfm`
- `test.cfm`

### Still actively referenced assets (3)

- `favicon.ico`
- `assign_icon.png`
- `view_icon.png`

## Audit methodology

The orphan list was built by enumerating every `.cfm` and asset at
`/admin/` root, then grepping the modern `/admin/2/` and `/users/2/`
trees for any reference (string match on the filename in href / src /
cflocation / cfinclude / etc.). Files with zero matches in active code
were classified as orphan.

Reference: `/tmp/admin_cleanup/orphan_cfm.txt` and
`/tmp/admin_cleanup/orphan_assets.txt` were the working manifests
generated during the audit.

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

## Next-pass candidates (deferred)

The 13 `.cfm` files that remain at `/admin/` root are migration debt.
Each represents a legacy admin tool whose `/admin/2/` migration is
incomplete (or whose function was rolled into another `/admin/2/`
page but with a code path still pointing at the legacy file). Future
work should:

1. Identify which `/admin/2/` file references each remaining legacy
   `.cfm` and what for
2. Either fully migrate the call site to a `/admin/2/`-native
   equivalent or document why the legacy page is still authoritative
3. Once no active references remain, archive these 13 too

This is **not blocking the v260119-beta release** (`#231`) — it's
post-beta cleanup velocity work.
