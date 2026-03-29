# Hermes SEG - URL Link Guard Implementation Plan

**GitHub Issue**: deeztek/Hermes-Secure-Email-Gateway#186
**Approach**: Python milter (pymilter) as a standalone Docker container
**Status**: Planning

---

## Overview

Rewrite URLs in inbound emails to route through a Hermes link-guard proxy endpoint. At click time, check the URL against threat intelligence services before redirecting to the destination. Strip rewritten URLs from outbound emails to prevent internal URLs from leaking externally.

---

## Architecture

```
Inbound Mail Flow:
  External Sender
    → Postfix (port 25)
    → hermes_url_rewriter milter (rewrites URLs)
    → Amavis (spam/virus scan)
    → Ciphermail (encryption)
    → Delivery (relay or Dovecot)

Click-Time Flow:
  User clicks rewritten link in email client
    → Browser hits https://console/link-guard?url=<encoded>&sig=<HMAC>
    → Hermes validates HMAC
    → Checks URL against threat intelligence (cached)
    → Safe: redirect to original URL
    → Malicious: show warning page
    → Service unavailable: configurable (allow with warning / block)

Outbound Mail Flow:
  Internal Sender
    → Postfix (submission port 587)
    → hermes_url_rewriter milter (strips rewritten URLs, restores originals)
    → Amavis (scan)
    → Delivery to external recipient
```

---

## Components

### 1. Python Milter Container (`hermes_url_rewriter`)

**Docker Image**: Python 3.12 slim + pymilter + BeautifulSoup4 + email module

**Dockerfile**:
```dockerfile
FROM python:3.12-slim
RUN apt-get update && apt-get install -y libmilter-dev gcc && \
    pip install pymilter beautifulsoup4 lxml && \
    apt-get purge -y gcc && apt-get autoremove -y
COPY url_rewriter_milter.py /app/
COPY config.py /app/
WORKDIR /app
CMD ["python", "url_rewriter_milter.py"]
```

**docker-compose.yml addition**:
```yaml
hermes_url_rewriter:
  build:
    context: ./Docker/url_rewriter
    dockerfile: Dockerfile
  container_name: hermes_url_rewriter
  restart: unless-stopped
  volumes:
    - ./config/url_rewriter:/etc/url_rewriter
    - /opt/hermes/keys/url_rewriter_hmac_key:/keys/hmac_key:ro
  environment:
    - TZ=${TIMEZONE}
  networks:
    hermes_net_ext:
      ipv4_address: ${IPV4SUBNET}.115
```

**Postfix integration** (main.cf):
```
smtpd_milters = inet:hermes_url_rewriter:8899, ... (existing milters)
non_smtpd_milters = inet:hermes_url_rewriter:8899, ...
milter_default_action = accept
```

### 2. Milter Logic (`url_rewriter_milter.py`)

```
Phase 1: Collect message body chunks via body() callback
Phase 2: At eom() callback:
  a. Parse email using Python email module
  b. Determine direction (inbound vs outbound) from headers/connection info
  c. For inbound:
     - Walk MIME parts
     - For text/html parts: parse with BeautifulSoup, find all <a href="...">
     - For text/plain parts: find URLs with regex
     - Rewrite each URL to link-guard format with HMAC signature
     - Reassemble MIME message
     - Call replacebody() with modified content
  d. For outbound:
     - Walk MIME parts
     - Find Hermes link-guard URLs
     - Extract and restore original URLs
     - Reassemble and replacebody()
```

**Inbound/Outbound Detection**:
- Check `Received` headers or connection IP
- If connecting IP is in `login_trusted_networks` (Docker subnet) → outbound (strip URLs)
- If connecting IP is external → inbound (rewrite URLs)

**URL Rewriting Format**:
```
Original:  https://example.com/page?id=123
Rewritten: https://{console_host}/link-guard?url={base64url(original)}&exp={expiry}&sig={HMAC-SHA256}
```

- `url`: Base64URL-encoded original URL
- `exp`: Unix timestamp expiry (configurable, default 30 days)
- `sig`: HMAC-SHA256 of `url|exp` using shared secret key
- Expiry prevents indefinite proxy abuse

**Whitelist (skip rewriting)**:
- Internal domains (configured in admin)
- URLs matching whitelist patterns (e.g., company intranet)
- Unsubscribe links (List-Unsubscribe header URLs)
- mailto: links

### 3. Safe-Link Click Endpoint

**Location**: `/user-auth/link_guard.cfm` (public, no Authelia — same as quarantine release)

**Flow**:
1. Validate HMAC signature
2. Check expiry
3. Decode original URL
4. Check URL cache table first
5. If not cached or cache expired:
   a. Query threat intelligence API(s)
   b. Cache result with TTL
6. If safe: HTTP 302 redirect to original URL
7. If malicious: render warning page with:
   - Threat details (source, category)
   - "Go back" button
   - "Proceed anyway" button (optional, configurable)
8. If API unavailable: configurable behavior

**Warning Page**: Standalone HTML (similar to quarantine_release.cfm styling)

### 4. Threat Intelligence Integration

**Primary (free, no API key)**:
- **URLhaus** (abuse.ch): `https://urlhaus-api.abuse.ch/v1/url/`
  - POST with `url` parameter
  - Returns threat status, tags, reporter
  - No rate limits, no API key
  - Best for known malware distribution URLs

**Secondary (API key required)**:
- **Google Safe Browsing API v4**: 10,000 lookups/day free
  - Checks URLs against phishing, malware, unwanted software lists
  - Batch API supports up to 500 URLs per request
- **VirusTotal API v3**: 4 requests/min, 500/day free
  - Comprehensive multi-engine scanning
  - Slower but most thorough

**Cache Table** (`url_check_cache`):
```sql
CREATE TABLE IF NOT EXISTS url_check_cache (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url_hash VARCHAR(64) NOT NULL UNIQUE,
    url TEXT NOT NULL,
    status ENUM('safe', 'malicious', 'suspicious', 'unknown') NOT NULL,
    provider VARCHAR(50),
    details TEXT,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    INDEX idx_url_hash (url_hash),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

- `url_hash`: SHA-256 of the URL for fast lookups
- TTL: configurable (default 24 hours for safe, 1 hour for unknown)
- Cleanup: scheduled job to purge expired entries

### 5. Admin Settings UI

**Location**: New page `view_url_protection.cfm` under Content Checks

**Settings** (stored in `system_settings` or new `url_protection_settings` table):

| Setting | Default | Description |
|---------|---------|-------------|
| `url_protection_enabled` | `0` | Master enable/disable |
| `url_rewrite_inbound` | `1` | Rewrite inbound URLs |
| `url_strip_outbound` | `1` | Strip rewritten URLs from outbound |
| `threat_provider` | `urlhaus` | Primary threat intelligence provider |
| `virustotal_api_key` | `` | VirusTotal API key (optional) |
| `google_safebrowsing_key` | `` | Google Safe Browsing API key (optional) |
| `cache_ttl_safe` | `86400` | Cache TTL for safe URLs (seconds) |
| `cache_ttl_malicious` | `3600` | Cache TTL for malicious URLs (seconds) |
| `link_expiry_days` | `30` | How long rewritten links remain valid |
| `action_on_unavailable` | `allow_warn` | Action when API unavailable: allow_warn, allow, block |
| `allow_proceed` | `1` | Show "proceed anyway" button on warning page |
| `whitelist_domains` | `` | Domains to skip rewriting (one per line) |

### 6. Milter Configuration

**Config file**: `/etc/url_rewriter/config.ini` (generated from admin UI)

```ini
[milter]
socket = inet:8899@0.0.0.0
timeout = 300

[rewriting]
enabled = true
console_host = console.example.com
hmac_key_file = /keys/hmac_key
link_expiry_days = 30

[whitelist]
domains = example.com,internal.corp
skip_unsubscribe = true

[detection]
trusted_networks = 172.16.32.0/24
```

Generated by `generate_url_rewriter_config.cfm` (same pattern as other config generators).

---

## Implementation Phases

### Phase 1: Foundation (1-2 sessions)
- [ ] Create Docker container with pymilter
- [ ] Implement basic milter that passes through without modification
- [ ] Integrate with Postfix (smtpd_milters)
- [ ] Verify mail flow is unaffected
- [ ] Add to docker-compose.yml

### Phase 2: URL Rewriting (2-3 sessions)
- [ ] Implement MIME message parsing (text/plain + text/html)
- [ ] URL detection in plain text (regex)
- [ ] URL detection in HTML (BeautifulSoup, href/src attributes)
- [ ] HMAC-signed URL generation
- [ ] URL rewriting with replacebody()
- [ ] Whitelist handling (skip internal domains, unsubscribe links)
- [ ] Inbound/outbound detection
- [ ] Outbound URL stripping (restore originals)
- [ ] Test with various email formats (plain, HTML, multipart, nested MIME)

### Phase 3: Safe-Link Endpoint (1 session)
- [ ] Create `/user-auth/link_guard.cfm`
- [ ] HMAC validation and expiry check
- [ ] URL decoding and redirect
- [ ] Warning page HTML/CSS
- [ ] "Proceed anyway" functionality

### Phase 4: Threat Intelligence (1-2 sessions)
- [ ] URLhaus API integration
- [ ] Cache table and lookup logic
- [ ] Google Safe Browsing integration (optional)
- [ ] VirusTotal integration (optional)
- [ ] Fallback behavior when APIs unavailable
- [ ] Cache cleanup scheduled job

### Phase 5: Admin UI (1 session)
- [ ] `view_url_protection.cfm` settings page
- [ ] Config file generation from database settings
- [ ] Milter restart from admin console
- [ ] URL check cache statistics display
- [ ] Whitelist domain management

### Phase 6: Testing & Hardening (1-2 sessions)
- [ ] Test with real-world emails (newsletters, transactional, spam)
- [ ] Test recursive URL unwrapping (anti-abuse)
- [ ] Test with encoded URLs (percent-encoding, punycode)
- [ ] Test multipart/alternative (both plain text and HTML parts)
- [ ] Test with DKIM-signed emails (rewriting invalidates DKIM — verify acceptable)
- [ ] Test outbound stripping
- [ ] Performance testing (latency impact per message)
- [ ] Rate limiting on link-guard endpoint

---

## Security Considerations

1. **DKIM Invalidation**: URL rewriting modifies the message body, which invalidates any existing DKIM signature. This is by design (same as Microsoft Link Guard). The message will show DKIM=fail for the original sender's signature, but Hermes adds its own DKIM signature after rewriting.

2. **Recursive URL Unwrapping**: Attackers chain multiple vendor link-guard URLs together. The link-guard endpoint must recursively unwrap URLs up to a configurable depth limit (default 3) and flag excessive redirects.

3. **HMAC Key Management**: The signing key must be persistent across container restarts. Store at `/opt/hermes/keys/url_rewriter_hmac_key`, auto-generated on first use (same pattern as quarantine release key).

4. **Open Redirect Prevention**: The link-guard endpoint must validate that the decoded URL is a proper HTTP/HTTPS URL, not a javascript: or data: URI.

5. **Rate Limiting**: The link-guard endpoint should be rate-limited to prevent abuse as a URL proxy.

6. **Privacy**: URL check results are cached locally. Original URLs are not sent to third parties unless the user actually clicks them (click-time checking, not scan-time).

---

## Database Schema

```sql
-- URL protection settings
CREATE TABLE IF NOT EXISTS url_protection_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_name VARCHAR(100) NOT NULL UNIQUE,
    setting_value VARCHAR(500) NOT NULL,
    description VARCHAR(500) NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- URL check cache
CREATE TABLE IF NOT EXISTS url_check_cache (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url_hash VARCHAR(64) NOT NULL UNIQUE,
    url TEXT NOT NULL,
    status ENUM('safe', 'malicious', 'suspicious', 'unknown') NOT NULL,
    provider VARCHAR(50),
    details TEXT,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    INDEX idx_url_hash (url_hash),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Whitelisted domains (skip URL rewriting)
CREATE TABLE IF NOT EXISTS url_whitelist_domains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    domain VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## Estimated Effort

| Phase | Sessions | Description |
|-------|----------|-------------|
| Phase 1: Foundation | 1-2 | Docker container, milter passthrough, Postfix integration |
| Phase 2: URL Rewriting | 2-3 | MIME parsing, URL detection, rewriting, stripping |
| Phase 3: Safe-Link Endpoint | 1 | Click-time validation, redirect, warning page |
| Phase 4: Threat Intelligence | 1-2 | API integration, caching, fallbacks |
| Phase 5: Admin UI | 1 | Settings page, config generation |
| Phase 6: Testing | 1-2 | Real-world email testing, edge cases, hardening |
| **Total** | **7-12** | |

---

## Files to Create

| File | Purpose |
|------|---------|
| `Docker/url_rewriter/Dockerfile` | Python milter container image |
| `Docker/url_rewriter/url_rewriter_milter.py` | Main milter logic |
| `Docker/url_rewriter/config.py` | Configuration loader |
| `config/url_rewriter/config.ini` | Runtime config (generated) |
| `config/hermes/var/www/html/user-auth/link_guard.cfm` | Click-time check endpoint |
| `config/hermes/var/www/html/admin/2/view_url_protection.cfm` | Admin settings page |
| `config/hermes/var/www/html/admin/2/inc/generate_url_rewriter_config.cfm` | Config generator |
| `config/hermes/var/www/html/admin/2/inc/restart_url_rewriter.cfm` | Container restart |
| `updates/hermes-260119/sql/schema_updates.sql` | Database tables |
