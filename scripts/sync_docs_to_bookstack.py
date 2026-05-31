#!/usr/bin/env python3
"""
Sync docs/admin/ and docs/users/ into the "Hermes SEG Docker" BookStack shelf.

Idempotent — safe to re-run after each Hermes release. Books, chapters, and
pages are matched by name within their parent; existing entries are updated
in place via PUT; new entries are created via POST.

Credentials are read from docs/.env-bookstack (which is .gitignored). Format:

    TOKEN-ID: <token id>
    TOKEN-SECRET: <token secret>
    BOOKSTACK-URL: <https url, no trailing slash>

Run with --dry-run to preview what would change without writing.

Tracking: #259
"""

import json
import pathlib
import re
import sys
import urllib.error
import urllib.request

# --- Config -----------------------------------------------------------------

REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
ENV_PATH = REPO_ROOT / "docs" / ".env-bookstack"
SHELF_ID = 202   # "Hermes SEG Docker"
DRY_RUN = "--dry-run" in sys.argv

ADMIN_CHAPTERS = [
    ("01-system",          "System"),
    ("02-email-relay",     "Email Relay"),
    ("03-email-server",    "Email Server"),
    ("04-content-checks",  "Content Checks"),
    ("05-encryption",      "Encryption"),
    ("authentication",     "Authentication"),
    ("email-policies",     "Email Policies"),
]

BOOKS = [
    {
        "name": "Administrator Guide",
        "description": "Hermes SEG Docker administrator documentation. Auto-synced from the repository under docs/admin/.",
        "source_root": REPO_ROOT / "docs" / "admin",
        "chapters": ADMIN_CHAPTERS,
    },
    {
        "name": "User Guide",
        "description": "Hermes SEG user-portal documentation. Auto-synced from the repository under docs/users/.",
        "source_root": REPO_ROOT / "docs" / "users",
        "chapters": [],   # flat — pages directly under the book
    },
    {
        "name": "Installation & Reference",
        "description": "Hermes SEG Docker installation, upgrade, and technical reference material. Auto-synced from docs/install/ + docs/general/.",
        # Explicit file list (instead of source_root/chapters) so we can
        # pull pages from multiple source directories and skip stubs.
        "files": [
            REPO_ROOT / "docs" / "install" / "get-started-docker.md",
            REPO_ROOT / "docs" / "install" / "release-and-update-methodology.md",
            REPO_ROOT / "docs" / "install" / "storage-topology.md",
            REPO_ROOT / "docs" / "general" / "email-flow.md",
            # Intentionally NOT syncing:
            #   docs/general/introduction.md  -- still a "_Placeholder_" stub
            #   docs/api/                     -- empty placeholder for #222
            #   docs/images/                  -- image assets, not markdown
            #   docs/{README,BOOKSTACK-STRUCTURE,DOVECOT-*,handoff-*,URL-SAFE-*}.md
            #                                 -- dev-internal docs, not operator-facing
        ],
    },
]

# --- Credentials ------------------------------------------------------------

def _load_env(path):
    env = {}
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        k, v = line.split(":", 1)
        env[k.strip()] = v.strip()
    return env

_env = _load_env(ENV_PATH)
TOKEN_ID     = _env["TOKEN-ID"]
TOKEN_SECRET = _env["TOKEN-SECRET"]
BASE_URL     = _env["BOOKSTACK-URL"].rstrip("/")
AUTH_HEADER  = f"Token {TOKEN_ID}:{TOKEN_SECRET}"

# --- API helper -------------------------------------------------------------

def api(method, path, data=None):
    url = BASE_URL + path
    headers = {"Authorization": AUTH_HEADER, "Accept": "application/json"}
    body = None
    if data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=body, method=method, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            txt = resp.read().decode()
            return json.loads(txt) if txt else None
    except urllib.error.HTTPError as e:
        raise RuntimeError(f"{method} {path} -> HTTP {e.code}: {e.read().decode()[:500]}") from e

# --- Helpers ----------------------------------------------------------------

def page_title(md_path):
    """Use first '# Heading' from the file as the page title, or filename fallback."""
    for line in md_path.read_text().splitlines():
        m = re.match(r"^#\s+(.+)$", line)
        if m:
            return m.group(1).strip()
    return md_path.stem.replace("-", " ").title()

# --- Sync primitives --------------------------------------------------------

def find_book_on_shelf(name):
    shelf = api("GET", f"/api/shelves/{SHELF_ID}")
    for b in shelf.get("books", []):
        if b["name"] == name:
            return b["id"]
    return None

def find_or_create_book(name, description):
    bid = find_book_on_shelf(name)
    if bid:
        print(f"  book exists: {name!r} (id={bid})")
        return bid
    if DRY_RUN:
        print(f"  [DRY] would create book: {name!r}")
        return -1
    res = api("POST", "/api/books", {"name": name, "description": description})
    bid = res["id"]
    # Attach to shelf 202
    shelf = api("GET", f"/api/shelves/{SHELF_ID}")
    book_ids = [b["id"] for b in shelf.get("books", [])]
    if bid not in book_ids:
        book_ids.append(bid)
        api("PUT", f"/api/shelves/{SHELF_ID}", {"books": book_ids})
    print(f"  created book: {name!r} (id={bid})")
    return bid

def find_chapter(book_id, name):
    res = api("GET", f"/api/books/{book_id}")
    for c in res.get("contents", []):
        if c.get("type") == "chapter" and c["name"] == name:
            return c["id"]
    return None

def find_or_create_chapter(book_id, name, priority):
    if book_id == -1:
        if DRY_RUN:
            print(f"    [DRY] would create chapter: {name!r}")
        return -1
    cid = find_chapter(book_id, name)
    if cid:
        print(f"    chapter exists: {name!r} (id={cid})")
        return cid
    if DRY_RUN:
        print(f"    [DRY] would create chapter: {name!r}")
        return -1
    res = api("POST", "/api/chapters", {
        "book_id": book_id,
        "name": name,
        "priority": priority,
    })
    cid = res["id"]
    print(f"    created chapter: {name!r} (id={cid})")
    return cid

def find_page(book_id=None, chapter_id=None, name=None):
    if chapter_id and chapter_id != -1:
        res = api("GET", f"/api/chapters/{chapter_id}")
        for p in res.get("pages", []):
            if p["name"] == name:
                return p["id"]
    elif book_id and book_id != -1:
        res = api("GET", f"/api/books/{book_id}")
        for item in res.get("contents", []):
            if item.get("type") == "page" and item["name"] == name:
                return item["id"]
    return None

def upsert_page(book_id, chapter_id, name, markdown, priority):
    if book_id == -1 or chapter_id == -1:
        if DRY_RUN:
            print(f"      [DRY] would upsert page: {name!r}")
        return -1
    pid = find_page(book_id=book_id, chapter_id=chapter_id, name=name)
    payload = {"name": name, "markdown": markdown, "priority": priority}
    if chapter_id:
        payload["chapter_id"] = chapter_id
    else:
        payload["book_id"] = book_id

    if pid:
        if DRY_RUN:
            print(f"      [DRY] would update page: {name!r} (id={pid})")
            return pid
        api("PUT", f"/api/pages/{pid}", payload)
        print(f"      updated:  {name!r} (id={pid})")
        return pid

    if DRY_RUN:
        print(f"      [DRY] would create page: {name!r}")
        return -1
    res = api("POST", "/api/pages", payload)
    print(f"      created:  {name!r} (id={res['id']})")
    return res["id"]

# --- Sync orchestrator ------------------------------------------------------

def sync_book(spec):
    # Spec accepts either {source_root + chapters} OR {files} (explicit ordered list).
    if "files" in spec:
        print(f"\n=== Book: {spec['name']!r} (explicit file list, {len(spec['files'])} pages) ===")
    else:
        print(f"\n=== Book: {spec['name']!r} (from {spec['source_root'].relative_to(REPO_ROOT)}/) ===")
    book_id = find_or_create_book(spec["name"], spec["description"])

    if "files" in spec:
        for p_idx, md in enumerate(spec["files"]):
            if not md.is_file():
                print(f"      SKIP: {md.relative_to(REPO_ROOT)} (file not found)")
                continue
            upsert_page(book_id, None, page_title(md), md.read_text(), priority=p_idx)
    elif spec.get("chapters"):
        for idx, (subdir, chapter_name) in enumerate(spec["chapters"]):
            chap_path = spec["source_root"] / subdir
            if not chap_path.is_dir():
                print(f"    SKIP: {subdir} (not a directory)")
                continue
            cid = find_or_create_chapter(book_id, chapter_name, priority=idx)
            md_files = sorted(chap_path.glob("*.md"))
            for p_idx, md in enumerate(md_files):
                upsert_page(book_id, cid, page_title(md), md.read_text(), priority=p_idx)
    else:
        md_files = sorted(spec["source_root"].glob("*.md"))
        for p_idx, md in enumerate(md_files):
            upsert_page(book_id, None, page_title(md), md.read_text(), priority=p_idx)

def main():
    print(f"BookStack: {BASE_URL}")
    print(f"Shelf id:  {SHELF_ID}")
    print(f"Mode:      {'DRY-RUN (no writes)' if DRY_RUN else 'LIVE'}")
    for spec in BOOKS:
        sync_book(spec)
    print("\nDone.")

if __name__ == "__main__":
    main()
