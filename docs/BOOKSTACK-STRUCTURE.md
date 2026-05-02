# BookStack Documentation Structure

This `docs/` tree mirrors the three Hermes SEG BookStack books, with chapters and pages aligned to the **current admin and user portal sidebars** (not the legacy BookStack TOC):

- [Hermes SEG General Documentation](https://docs.deeztek.com/books/hermes-seg-general-documentation) → `docs/general/`
- [Hermes SEG Administrator Guide](https://docs.deeztek.com/books/hermes-seg-administrator-guide) → `docs/admin/`
- [Hermes SEG User Guide](https://docs.deeztek.com/books/hermes-seg-user-guide) → `docs/users/`

## Layout

```
docs/
├── BOOKSTACK-STRUCTURE.md            ← this file
├── README.md                         ← repo-level docs README (existing)
├── general/                          ← General Documentation book
│   └── introduction.md               ← intro / cross-cutting standalone content
├── admin/                            ← Administrator Guide
│   ├── 01-system/                    ← chapters mirror admin sidebar groups
│   ├── 02-email-relay/
│   ├── 03-email-server/
│   ├── 04-content-checks/
│   ├── 05-encryption/
│   └── authentication/               ← (#197 supplementary docs, pre-existing)
├── users/                            ← User Guide (flat)
│   ├── *.md                          ← one file per portal sidebar item
│   └── app-passwords/                ← (#197 supplementary docs, pre-existing)
├── api/, images/, install/           ← repo-level dev docs (pre-existing)
└── DOVECOT-*.md, URL-SAFE-*.md       ← internal migration notes (pre-existing)
```

## Chapter mapping — Administrator Guide

Each chapter mirrors a top-level group in the [admin sidebar](../config/hermes/var/www/html/admin/2/inc/main_sidebar.cfm). Each page maps 1:1 to a sidebar item.

| Chapter | Sidebar group | Page count |
|---|---|---|
| `01-system/` | **System** | 19 |
| `02-email-relay/` | **Email Relay** | 5 |
| `03-email-server/` | **Email Server** | 7 |
| `04-content-checks/` | **Content Checks** | 19 |
| `05-encryption/` | **Encryption** | 4 |

Numeric prefixes preserve sidebar order when sorted alphabetically.

## Page mapping — User Guide

Pages mirror the [user sidebar](../config/hermes/var/www/html/users/2/inc/main_sidebar.cfm) (flat, no chapters). 9 pages total.

## Skipped: external-link sidebar items

Sidebar entries that link to external apps (not pages we author) are intentionally not scaffolded:

- **Nextcloud Admin** under _Email Server_ → links to `/nc-admin-login`
- **Advanced Settings** under _Encryption_ → links to `/ciphermail/`
- **Webmail & Apps** under user portal → links to `/users/2/preload_nc_login.cfm`

If any of these need a Hermes-side companion page (e.g., "How to use Nextcloud Admin in the Hermes context"), scaffold it as a new file under the appropriate chapter at that time.

## Status convention

Each placeholder starts as `_Placeholder._`. Mark progress at the top as content is written:

- `_Placeholder._` — empty stub
- `_Draft._` — first pass written, not reviewed
- `_Reviewed._` — content reviewed, ready to publish
- `_Published <YYYY-MM-DD>._` — pushed to BookStack on this date

The local Markdown remains the source of truth; the BookStack page is regenerated from it.
