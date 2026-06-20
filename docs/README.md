# Hermes SEG Documentation

This directory holds the human-facing documentation for Hermes Secure Email Gateway. It is the **source of truth** for the BookStack documentation site. Each markdown file here is destined to become a BookStack Page; folders become Chapters; top-level sections become Books.

## Layout

| Folder | BookStack Book | Audience |
|---|---|---|
| `admin/` | Admin Guide | System administrators running a Hermes deployment |
| `users/` | User Guide | End users (mailbox owners) using the system |
| `install/` | Installation | Operators standing up a fresh Hermes install |
| `api/` | API Reference | Developers integrating with the Hermes Internal API (#222) |

Sub-folders inside each Book correspond to BookStack Chapters. Files inside a Chapter folder are Pages, ordered by their numeric prefix (`01-…`, `02-…`).

## Conventions

- **Filename prefixes** drive sort order on BookStack import. Always prefix with two digits.
- **Single H1 per file** — that becomes the BookStack page title. No YAML frontmatter (BookStack ignores it).
- **Internal links** use repo-relative paths so they work on GitLab/GitHub during preview. They will need to be re-pointed once on first BookStack import.
- **Images** live in `docs/images/`. ASCII diagrams travel best — prefer them over rendered diagrams when feasible.
- **No emojis** in technical documentation.
- **Mermaid blocks** render on GitLab but BookStack does not. They are tolerated for now; will be re-rendered as drawio on import.

## Internal notes

Developer-only notes (implementation plans, migration trackers, release/license internals) live under `docs/internal/`, which is **gitignored** and never published to BookStack. Keep anything not operator- or end-user-facing there.

## Cross-cutting reference

- [`install/release-and-update-methodology.md`](install/release-and-update-methodology.md) — canonical reference for how Hermes is released, distributed, and upgraded. Covers both developer side (cutting a release) and admin side (applying an update). Read before adding any schema change, migration, or release-engineering work.
