# Dovecot Mailbox Implementation Plan

## Overview

This document outlines the architectural decisions for implementing local Dovecot mailboxes in Hermes SEG, enabling hybrid configurations where domains can have both relay recipients (forwarded to backend servers) and local mailboxes (stored on Hermes via Dovecot).

**Feature Type:** Community Edition

---

## 1. Menu Structure Changes

### Current Structure
```
Email Relay
├── Domains
├── Relay Recipients
└── ...
```

### New Structure
```
System
├── Domains          ← MOVED from Email Relay (shared resource)
├── Certificates
└── ...

Email Relay
├── Relay Recipients ← Stays here
├── Transport Maps
└── ...

Email Server         ← NEW section
├── Mailboxes        ← NEW page
└── (future pages)
```

**Rationale:** Domains are now infrastructure shared by both relay and mailbox features, so they belong at the System level.

---

## 2. Database Schema Changes

### 2.1 Domains Table

Add columns to support mailbox functionality:

```sql
ALTER TABLE domains ADD COLUMN mailbox_enabled TINYINT(1) DEFAULT 0
    COMMENT 'UX toggle - shows/hides mailbox quota fields in domain edit';

ALTER TABLE domains ADD COLUMN domain_quota BIGINT DEFAULT 0
    COMMENT 'Total storage quota for all mailboxes in domain (bytes, 0=unlimited)';

ALTER TABLE domains ADD COLUMN default_mailbox_quota BIGINT DEFAULT 1073741824
    COMMENT 'Default quota for new mailboxes (bytes, default 1GB)';

ALTER TABLE domains ADD COLUMN max_mailboxes INT DEFAULT 0
    COMMENT 'Maximum number of mailboxes allowed (0=unlimited)';
```

**Note:** `mailbox_enabled` is a UX convenience, not a hard constraint. It controls whether mailbox-related fields are shown in the domain edit form.

### 2.2 Recipients Table

Add columns to support per-recipient backend override:

```sql
ALTER TABLE recipients ADD COLUMN backend_server VARCHAR(255) NULL
    COMMENT 'Override backend server (NULL = use domain default)';

ALTER TABLE recipients ADD COLUMN backend_port INT NULL
    COMMENT 'Override backend port (NULL = use domain default)';

ALTER TABLE recipients ADD COLUMN backend_tls ENUM('none','may','encrypt') NULL
    COMMENT 'Override TLS setting (NULL = use domain default)';
```

**Rationale:** Keeps domain-level backend as default, allows per-recipient exceptions without complicating bulk add operations.

### 2.3 Mailboxes Table

Existing table used by Dovecot (already exists):

```sql
-- Key columns for reference:
-- username VARCHAR(255) - email address (primary key for lookups)
-- quota BIGINT - mailbox quota in bytes
-- active TINYINT(1) - enabled/disabled
-- name VARCHAR(255) - display name
-- domain - FK to domains table
```

---

## 3. Postfix Transport Configuration

### 3.1 Transport Maps Query

Configure `transport_maps` to route per-recipient:

**main.cf:**
```
transport_maps = mysql:/etc/postfix/mysql_transport_maps.cf
```

**mysql_transport_maps.cf:**
```sql
query = SELECT transport FROM (
    -- Check mailboxes first (LMTP to Dovecot)
    SELECT 'lmtp:unix:private/dovecot-lmtp' AS transport, 1 AS priority
    FROM mailboxes
    WHERE username = '%s' AND active = 1

    UNION

    -- Then check relay recipients (SMTP to backend)
    SELECT CONCAT('smtp:[',
        COALESCE(r.backend_server, d.backend_server),
        ']:',
        COALESCE(r.backend_port, d.backend_port)
    ) AS transport, 2 AS priority
    FROM recipients r
    JOIN domains d ON r.domain_id = d.id
    WHERE r.email = '%s' AND r.active = 1
) combined
ORDER BY priority
LIMIT 1
```

**Routing Logic:**
- If email exists in `mailboxes` table → deliver via LMTP to Dovecot
- If email exists in `recipients` table → relay to backend server
- `COALESCE` uses recipient override if set, otherwise domain default

---

## 4. UI Changes

### 4.1 Domain Edit Page

Add "Mailbox Settings" section to domain edit form:

```
┌─────────────────────────────────────────────────────┐
│ Edit Domain: example.com                            │
├─────────────────────────────────────────────────────┤
│ General Settings                                    │
│ ├─ Domain Name: example.com                         │
│ ├─ Active: [✓]                                      │
│ └─ ...                                              │
├─────────────────────────────────────────────────────┤
│ Relay Settings (existing)                           │
│ ├─ Backend Server: exchange.example.com             │
│ ├─ Port: 25                                         │
│ └─ TLS: May                                         │
├─────────────────────────────────────────────────────┤
│ Mailbox Settings                    [Enable: ON/OFF]│
│ (shown when toggle is ON)                           │
│ ├─ Domain Quota: [____] GB (0 = unlimited)          │
│ ├─ Default Mailbox Quota: [1] GB                    │
│ └─ Max Mailboxes: [____] (0 = unlimited)            │
└─────────────────────────────────────────────────────┘
```

### 4.2 Relay Recipients List Page (view_internal_recipients.cfm)

Add **"Edit Backend" button** and **Backend column** to the recipients listing:

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│ Relay Recipients                                                    [Add]        │
├──────────────────────────────────────────────────────────────────────────────────┤
│ [Select All] [Delete Selected] [Edit Options] [Edit Backend]                    │
├──────────────────────────────────────────────────────────────────────────────────┤
│ [✓] │ Email              │ Name      │ Domain       │ Backend Server   │ Actions │
│ [✓] │ user@example.com   │ John Doe  │ example.com  │ (domain default) │ [Edit]  │
│ [ ] │ admin@example.com  │ Admin     │ example.com  │ other-server.com │ [Edit]  │
└──────────────────────────────────────────────────────────────────────────────────┘
```

**Backend Column Display:**
- If `backend_server` is NULL → show "(domain default)" in muted text
- If `backend_server` is set → show the custom server hostname

**Edit Backend Button Behavior:**
- Only enabled when one or more recipients are selected
- Available for ALL relay recipients (no hybrid domain restriction)
- Opens edit_internal_recipient_backend.cfm for bulk/single backend editing

### 4.3 Edit Backend Page (NEW: edit_internal_recipient_backend.cfm)

Separate page for backend server editing:

```
┌─────────────────────────────────────────────────────┐
│ Edit Backend Server                                 │
├─────────────────────────────────────────────────────┤
│ Selected Recipients: 3                              │
│ ├─ user1@example.com                                │
│ ├─ user2@example.com                                │
│ └─ user3@example.com                                │
├─────────────────────────────────────────────────────┤
│ Backend: ○ Use domain default (exchange.example.com)│
│          ● Custom                                   │
│                                                     │
│ Server: [other-server.example.com]  ← shown when    │
│ Port:   [25                      ]    "Custom"      │
│ TLS:    [May ▼                   ]    selected      │
│                                                     │
│               [Save Changes] [Cancel]               │
└─────────────────────────────────────────────────────┘
```

### 4.4 Edit Relay Recipient Page (edit_internal_recipient.cfm)

Existing edit page remains unchanged - handles name, active status, etc. Backend fields are NOT added here to keep concerns separated.

### 4.5 Add Relay Recipients Page

**No changes required.** Bulk add continues to use domain default backend. Exceptions are handled via Edit Backend.

### 4.6 Mailboxes Page (NEW)

New page under Email Server → Mailboxes:

```
┌─────────────────────────────────────────────────────┐
│ Mailboxes                          [Add Mailboxes]  │
├─────────────────────────────────────────────────────┤
│ Filter by domain: [All domains ▼]                   │
├─────────────────────────────────────────────────────┤
│ Email              │ Name      │ Quota    │ Actions │
│ user@example.com   │ John Doe  │ 1GB/2GB  │ [Edit]  │
│ admin@example.com  │ Admin     │ 0.5GB/1GB│ [Edit]  │
└─────────────────────────────────────────────────────┘
```

---

## 5. Validation Rules

### 5.1 Cross-Table Uniqueness

An email address cannot exist in both `recipients` and `mailboxes` tables.

**When adding relay recipient:**
```cfml
<!--- Check if already exists as a mailbox --->
<cfquery name="checkMailbox" datasource="hermes">
    SELECT username FROM mailboxes
    WHERE username = <cfqueryparam value="#email#">
</cfquery>

<cfif checkMailbox.recordcount GTE 1>
    <cfset errorMsg = "This address already exists as a local mailbox.
        Delete the mailbox first if you want to relay instead.">
</cfif>
```

**When adding mailbox:**
```cfml
<!--- Check if already exists as relay recipient --->
<cfquery name="checkRecipient" datasource="hermes">
    SELECT email FROM recipients
    WHERE email = <cfqueryparam value="#email#">
</cfquery>

<cfif checkRecipient.recordcount GTE 1>
    <cfset errorMsg = "This address already exists as a relay recipient.
        Delete the relay recipient first if you want a local mailbox.">
</cfif>
```

### 5.2 Domain Validation for Mailboxes

When adding a mailbox, verify domain has `mailbox_enabled = 1`:

```cfml
<cfquery name="checkDomain" datasource="hermes">
    SELECT mailbox_enabled FROM domains
    WHERE domain = <cfqueryparam value="#emailDomain#">
</cfquery>

<cfif checkDomain.mailbox_enabled NEQ 1>
    <cfset errorMsg = "Mailboxes are not enabled for this domain.
        Enable mailboxes in the domain settings first.">
</cfif>
```

---

## 6. Files to Create/Modify

### 6.1 New Files

| File | Purpose |
|------|---------|
| `admin/2/view_mailboxes.cfm` | List mailboxes |
| `admin/2/add_mailboxes.cfm` | Add mailbox form |
| `admin/2/edit_mailbox.cfm` | Edit mailbox form |
| `admin/2/inc/mailbox_*.cfm` | Include files for mailbox operations |
| `admin/2/edit_internal_recipient_backend.cfm` | Edit backend server for relay recipients |
| `admin/2/inc/edit_internal_recipient_backend_save.cfm` | Save backend server settings |

### 6.2 Modified Files

| File | Changes |
|------|---------|
| `admin/2/edit_domain.cfm` | Add Mailbox Settings section |
| `admin/2/view_internal_recipients.cfm` | Add "Edit Backend" button and Backend column |
| `admin/2/inc/add_internal_recipients.cfm` | Add cross-table validation (check mailboxes table) |
| `admin/2/inc/main_sidebar.cfm` | Move Domains to System, add Email Server section |
| `updates/.../schema_updates.sql` | Add new columns |

---

## 7. Implementation Phases

### Phase 1: Schema & Infrastructure
- [ ] Add domain columns (mailbox_enabled, quotas)
- [ ] Add recipient columns (backend override)
- [ ] Update Postfix transport_maps query
- [ ] Test transport routing with manual SQL entries

### Phase 2: Domain UI
- [ ] Move Domains to System menu
- [ ] Add Mailbox Settings section to domain edit page
- [ ] Update domain save logic

### Phase 3: Relay Recipients UI
- [ ] Add Backend column to view_internal_recipients.cfm
- [ ] Add "Edit Backend" button to view_internal_recipients.cfm
- [ ] Create edit_internal_recipient_backend.cfm
- [ ] Create save logic with COALESCE handling for backend override
- [ ] Add cross-table validation (check mailboxes)

### Phase 4: Mailboxes UI
- [ ] Create Email Server menu section
- [ ] Create view_mailboxes.cfm
- [ ] Create add_mailboxes.cfm with validation
- [ ] Create edit_mailbox.cfm
- [ ] Add cross-table validation (check recipients)

### Phase 5: Testing & Documentation
- [ ] Test hybrid domain scenarios
- [ ] Test transport routing
- [ ] Test quota enforcement
- [ ] Update user documentation

---

## 8. Related Issues

- GitHub Issue: [#151 - Implement Dovecot Mailbox Support with Hybrid Domains](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/151)

---

## 9. Revision History

| Date | Author | Changes |
|------|--------|---------|
| 2026-02-21 | Claude/Dino | Initial architecture decisions |
| 2026-02-21 | Claude/Dino | Added separate "Edit Backend" button design (not embedded in Edit Options) |
| 2026-02-21 | Claude/Dino | Removed hybrid domain validation - backend override available for all relay recipients |
| 2026-02-21 | Claude/Dino | Added Backend column to recipients listing |
| 2026-02-21 | Claude/Dino | Linked GitHub Issue #151 |
