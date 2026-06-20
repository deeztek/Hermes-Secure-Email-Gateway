<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
EXTERNAL SENDER BANNER LIST PAGE (#228).

Both Community + Pro - phishing protection is a baseline security feature.
Lists all rows in the external_banners table; admin can add a system-wide
default (recipient_domain IS NULL) plus optional per-recipient-domain
overrides.

Resolution at message time (in the body milter ExternalBannerModifier):
look up the recipient's domain in /etc/hermes/body_milter/banners/banner_by_recipient_domain;
fall back to the system-wide default (option 'banner_default') if no
domain-specific row matches; no banner if neither exists.
--->

<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | External Sender Banner</title>

<cfinclude template="./inc/html_head.cfm" />

<script>
$(document).ready(function() {
    $('#bannersTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[0, "asc"]]
    });
});
</script>

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

<cfinclude template="./inc/top_navbar.cfm" />
<cfinclude template="./inc/main_sidebar.cfm" />

<main class="app-main">

<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">External Sender Banner</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item active">External Sender Banner</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<cfquery name="getBanners" datasource="hermes">
    SELECT id, recipient_domain, enabled, position, body_text, body_html, updated_at
    FROM external_banners
    ORDER BY (recipient_domain IS NULL) DESC, recipient_domain ASC
</cfquery>

<cfif structKeyExists(session, "ext_banner_msg") AND session.ext_banner_msg NEQ "">
    <div class="alert alert-<cfoutput>#session.ext_banner_msg_type#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput>#session.ext_banner_msg#</cfoutput>
    </div>
    <cfset session.ext_banner_msg = "">
    <cfset session.ext_banner_msg_type = "">
</cfif>

<div class="alert alert-info">
    <i class="fas fa-info-circle me-2"></i>
    <strong>What this does:</strong> prepends a warning banner to inbound mail
    that arrives from external senders (any sender NOT on one of your local
    mailbox domains) destined for one of your local recipients. Helps users
    spot phishing and spoofing. The banner is rendered in every MUA &mdash; webmail,
    Outlook, Apple Mail, mobile clients &mdash; because it's injected into the
    message body itself, not relying on the recipient's MUA to add a tag.
    <br><br>
    <strong>Resolution order:</strong> if a row exists for the recipient's
    domain, it wins; otherwise the system-wide default applies; otherwise no
    banner. DKIM-signed inbound mail is intentionally still modified (the
    OpenDKIM verdict is captured in <code>Authentication-Results</code> headers
    before our modification, and recipients overwhelmingly read mail through
    Dovecot/IMAP which doesn't re-verify).
</div>

<div class="alert alert-warning">
    <i class="fas fa-shield-alt me-2"></i>
    <strong>Architectural note (#229):</strong> banner injection modifies the
    message body, which invalidates the original sender's <code>DKIM-Signature</code>
    body hash AND any upstream <code>ARC-Message-Signature</code> body hash for
    messages that arrived through an ARC-sealing gateway (M365, Google Workspace,
    Mimecast, Proofpoint, Exclaimer, etc.). Hermes's own ARC seal at <code>:10026</code>
    is mathematically valid (computed over the modified body) but honestly records
    <code>cv=fail</code> for the upstream chain it can no longer validate.
    <br><br>
    <strong>This is by design.</strong> Hermes is the authoritative auth /
    security boundary for relay domains it serves. Customers' downstream mail
    servers must be configured to trust Hermes (allowlist Hermes IP, accept
    forwarded mail without re-running DKIM / SPF / DMARC / ARC checks). If a
    customer's downstream MX is doing redundant auth checks on mail Hermes
    forwards, that's a misconfiguration on the customer's side, not a Hermes
    issue.
</div>

<div class="card card-primary card-outline mb-4">
    <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-shield-alt me-2"></i>External Sender Banners</h3>
    </div>
    <div class="card-body">

        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
            <a href="edit_external_banner.cfm" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i> Add Banner
            </a>
            <small class="text-muted">
                <cfoutput>#getBanners.recordcount#</cfoutput> banner<cfif getBanners.recordcount NEQ 1>s</cfif> configured
            </small>
        </div>

        <cfif getBanners.recordcount LT 1>
            <div class="alert alert-warning mb-0">
                <i class="fas fa-exclamation-triangle me-2"></i>
                No external sender banners configured. Click <strong>Add Banner</strong> above
                to create a system-wide default (recommended). You can add per-recipient-domain
                overrides afterward if specific domains need different copy or compliance language.
            </div>
        <cfelse>
            <div class="table-responsive">
            <table id="bannersTable" class="table table-bordered table-hover table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th style="width: 25%">Recipient Domain</th>
                        <th style="width: 10%">Enabled</th>
                        <th style="width: 10%">Position</th>
                        <th>Preview</th>
                        <th style="width: 16%">Updated</th>
                        <th style="width: 14%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getBanners">
                        <tr>
                            <td>
                                <cfif Len(Trim(recipient_domain)) EQ 0>
                                    <span class="badge bg-primary"><i class="fas fa-globe me-1"></i>System default</span>
                                    <small class="text-muted ms-1">(applies to all recipient domains without an override)</small>
                                <cfelse>
                                    <code>#HTMLEditFormat(recipient_domain)#</code>
                                </cfif>
                            </td>
                            <td>
                                <cfif Val(enabled) EQ 1>
                                    <span class="badge bg-success">Enabled</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Disabled</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif position EQ "prepend">
                                    <span class="badge bg-info">Top</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Bottom</span>
                                </cfif>
                            </td>
                            <td>
                                <small class="text-muted">
                                    <cfset previewText = body_text>
                                    <cfif Len(Trim(previewText)) EQ 0>
                                        <cfset previewText = ReReplaceNoCase(body_html, "<[^>]+>", " ", "all")>
                                        <cfset previewText = ReReplaceNoCase(previewText, "\s+", " ", "all")>
                                    </cfif>
                                    <cfset previewText = Trim(previewText)>
                                    <cfif Len(previewText) GT 80>
                                        #HTMLEditFormat(Left(previewText, 80))#&hellip;
                                    <cfelse>
                                        #HTMLEditFormat(previewText)#
                                    </cfif>
                                </small>
                            </td>
                            <td>#DateTimeFormat(updated_at, "yyyy-mm-dd HH:nn")#</td>
                            <td>
                                <a href="edit_external_banner.cfm?id=#id#" class="btn btn-sm btn-primary" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-sm btn-danger"
                                    onclick="if(confirm('Delete this external sender banner?')) { window.location='external_banner_delete.cfm?id=#id#'; }"
                                    title="Delete">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
            </div>
        </cfif>
    </div>
</div>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
</body>
</html>
