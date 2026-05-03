<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | Edit Disclaimer</title>
<cfinclude template="./inc/html_head.cfm" />

<!--- Quill 2.x WYSIWYG editor for the HTML disclaimer body. Loaded from
     jsdelivr (same CDN pattern Hermes uses for qrcode-generator on the
     My App Passwords page). MIT-licensed, no API key, no self-host. --->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.min.js"></script>

<style>
    /* Match Quill editor height and surface it on white so it stands out
       against the bg-body-tertiary page background. */
    .ql-container { min-height: 220px; background: ##fff; }
    .ql-toolbar   { background: ##f8f9fa; }
</style>

<script>
$(document).ready(function() {
    // ─── Scope dropdown drives which scope_key select is visible ────────
    function syncScopeKeyVisibility() {
        var scope = $('#scope').val();
        ['domain', 'relay'].forEach(function(k) {
            var $wrap = $('#scopeKeyWrap_' + k);
            var $sel  = $('#scope_key_' + k);
            if (k === scope) { $wrap.show(); $sel.prop('disabled', false); }
            else             { $wrap.hide(); $sel.prop('disabled', true); }
        });
    }
    $('#scope').on('change', syncScopeKeyVisibility);
    syncScopeKeyVisibility();

    // ─── Quill editor ───────────────────────────────────────────────────
    var quill = new Quill('#quill_editor', {
        theme: 'snow',
        placeholder: 'Type your disclaimer here…',
        modules: {
            toolbar: [
                [{ 'header': [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                ['blockquote', 'link'],
                ['clean']
            ]
        }
    });
    // Pre-populate from the hidden textarea (its value is the stored HTML).
    var existingHtml = $('#body_html').val();
    if (existingHtml) { quill.root.innerHTML = existingHtml; }

    // HTML -> plain text helper. Preserves block-level newlines, drops tags,
    // collapses 3+ newlines to 2. Good enough for the auto-derived
    // text/plain part of multipart mail; "edit separately" toggle below
    // lets admins override for fine-grained control.
    function htmlToText(html) {
        var div = document.createElement('div');
        div.innerHTML = html;
        div.querySelectorAll('br').forEach(function(br) { br.replaceWith('\n'); });
        div.querySelectorAll('p, div, h1, h2, h3, h4, h5, h6, li').forEach(function(el) { el.append('\n'); });
        return (div.textContent || div.innerText || '').replace(/\n{3,}/g, '\n\n').trim();
    }
    function quillIsEmpty() {
        var h = quill.root.innerHTML;
        return (h === '' || h === '<p><br></p>');
    }

    // ─── Auto-detect "edit text separately" on load ─────────────────────
    // If the stored plain-text version differs from what auto-derive would
    // produce, the admin intentionally customized it — surface the toggle
    // ON so they don't lose that customization on save.
    var existingText = ($('#body_text').val() || '').trim();
    var derivedText  = existingHtml ? htmlToText(existingHtml).trim() : '';
    if (existingText && existingText !== derivedText) {
        $('#editTextSeparately').prop('checked', true);
        $('#textBodyWrap').show();
    }

    // ─── Toggle behavior ────────────────────────────────────────────────
    $('#editTextSeparately').on('change', function() {
        if ($(this).is(':checked')) {
            // Reveal the textarea. If it's empty, seed it with the current
            // auto-derived text so the admin has a starting point to edit.
            if (!$('#body_text').val().trim() && !quillIsEmpty()) {
                $('#body_text').val(htmlToText(quill.root.innerHTML));
            }
            $('#textBodyWrap').show();
        } else {
            $('#textBodyWrap').hide();
        }
    });

    // ─── On submit: sync Quill -> hidden textarea + auto-derive text ───
    $('form[name="edit_disclaimer"]').on('submit', function() {
        var html  = quill.root.innerHTML;
        var empty = quillIsEmpty();
        $('#body_html').val(empty ? '' : html);
        if (!$('#editTextSeparately').is(':checked')) {
            $('#body_text').val(empty ? '' : htmlToText(html));
        }
    });

    // ─── Preview ────────────────────────────────────────────────────────
    $('#previewBtn').on('click', function() {
        var html  = quill.root.innerHTML;
        var empty = quillIsEmpty();
        var bodyHtml = empty ? '' : html;
        var bodyText = $('#editTextSeparately').is(':checked')
            ? ($('#body_text').val() || '')
            : (empty ? '' : htmlToText(html));
        var position = $('#position').val();
        var sample = '<p>This is the original email body that the user composed. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>';
        var disclaimerHtml;
        if (bodyHtml.trim().length > 0) {
            disclaimerHtml = '<div style="margin-top:1em;padding-top:0.5em;border-top:1px solid ##ccc;font-size:0.9em;color:##555;">' + bodyHtml + '</div>';
        } else if (bodyText.trim().length > 0) {
            disclaimerHtml = '<pre style="margin-top:1em;padding-top:0.5em;border-top:1px solid ##ccc;font-size:0.85em;color:##555;white-space:pre-wrap;">' + $('<div>').text(bodyText).html() + '</pre>';
        } else {
            disclaimerHtml = '<em class="text-muted">(disclaimer is empty)</em>';
        }
        var combined = (position === 'prepend') ? disclaimerHtml + sample : sample + disclaimerHtml;
        $('#previewPanelBody').html(combined);
        $('#previewPanel').show();
    });
    $('#previewCloseBtn').on('click', function() { $('#previewPanel').hide(); });
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
                <h1 class="m-0">Edit Disclaimer</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item"><a href="view_disclaimers.cfm">Disclaimers</a></li>
                    <li class="breadcrumb-item active">Edit</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<!--- PRO EDITION LICENSE CHECK (##214). license_check.cfm handles
     specialized states first; license_pro_required.cfm fires only if
     the license is healthy but edition is Community. --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "Email Policies > Disclaimers">
    <cfinclude template="./inc/license_pro_required.cfm">
    <cfabort>
</cfif>

<!--- LOAD EXISTING ROW IF EDIT MODE.
     Pattern: ?id=N -> edit mode (row must exist), no id -> create mode.
     Scope is locked after create so a row can't shape-shift between
     scope types (would invalidate scope_key under the unique key
     constraint). --->
<cfparam name="url.id" default="0">
<cfset isEdit = (IsNumeric(url.id) AND Val(url.id) GT 0)>

<cfset existingScope    = "">
<cfset existingScopeKey = "">
<cfset existingEnabled  = 1>
<cfset existingPosition = "append">
<cfset existingText     = "">
<cfset existingHtml     = "">

<cfif isEdit>
    <cfquery name="getDisclaimer" datasource="hermes">
        SELECT id, scope, scope_key, enabled, position, body_text, body_html
        FROM disclaimers
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getDisclaimer.recordcount LT 1>
        <cfset session.disclaimer_msg = "<strong>Not found.</strong> Disclaimer ID ##" & url.id & " no longer exists.">
        <cfset session.disclaimer_msg_type = "warning">
        <cflocation url="view_disclaimers.cfm" addtoken="no">
    </cfif>
    <cfset existingScope    = getDisclaimer.scope>
    <cfset existingScopeKey = getDisclaimer.scope_key>
    <cfset existingEnabled  = Val(getDisclaimer.enabled)>
    <cfset existingPosition = getDisclaimer.position>
    <cfset existingText     = getDisclaimer.body_text>
    <cfset existingHtml     = getDisclaimer.body_html>
</cfif>

<!--- POPULATE SCOPE_KEY DROPDOWN OPTIONS. Three queries, one per scope.
     All loaded at render time so the JS scope-swap is pure show/hide.
     Disabled rows are still listed (admin may want to maintain a
     disclaimer for a temporarily-disabled mailbox); the dropdown is
     not the place to enforce that. --->
<cfquery name="getScopeKeyDomains" datasource="hermes">
    SELECT domain FROM domains ORDER BY domain ASC
</cfquery>
<!--- Relay recipients only. Exclude:
       - rows in the mailboxes table (covers legacy installs where some
         mailbox rows have recipient_type=NULL — without this clause the
         dropdown leaks mailbox addresses)
       - domain-level rows (recipients.domain IS NOT NULL marks them) --->
<cfquery name="getScopeKeyRelays" datasource="hermes">
    SELECT r.recipient
    FROM recipients r
    LEFT JOIN mailboxes m ON m.username = r.recipient
    WHERE (r.recipient_type = 'relay' OR r.recipient_type IS NULL)
      AND r.domain IS NULL
      AND m.id IS NULL
    ORDER BY r.recipient ASC
</cfquery>

<div class="row">
<div class="col-12 col-lg-9 col-xl-8">

<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-file-signature me-2"></i>
            <cfif isEdit>Edit Disclaimer<cfelse>New Disclaimer</cfif>
        </h3>
    </div>
    <div class="card-body">

    <form name="edit_disclaimer" id="disclaimerForm" method="post" action="save_disclaimer_action.cfm">
        <cfoutput>
        <input type="hidden" name="id" value="#isEdit ? Val(url.id) : 0#">
        </cfoutput>

        <!-- Scope -->
        <div class="form-group mb-3">
            <label class="form-label"><strong>Scope</strong></label>
            <cfoutput>
            <select class="form-select" id="scope" name="scope" <cfif isEdit>disabled</cfif>>
                <option value="domain"  <cfif existingScope EQ "domain"> selected</cfif>>Domain</option>
                <option value="relay"   <cfif existingScope EQ "relay">  selected</cfif>>Relay Recipient</option>
            </select>
            <cfif isEdit>
                <!--- A disabled select doesn't post; mirror as hidden input. --->
                <input type="hidden" name="scope" value="#existingScope#">
            </cfif>
            </cfoutput>
            <small class="form-text text-muted">
                <cfif isEdit>
                    <i class="fas fa-lock me-1"></i> Scope is locked after creation. Delete and re-create to change scope.
                <cfelse>
                    Domain disclaimers apply to all addresses in the domain. Relay-recipient disclaimers override the domain default for one specific upstream sender. Most-specific wins at send time. Per-mailbox personalization is handled by user signatures, not disclaimers.
                </cfif>
            </small>
        </div>

        <!-- Scope Key -->
        <div id="scopeKeyWrap_domain" class="form-group mb-3">
            <label class="form-label"><strong>Domain</strong></label>
            <select class="form-select" id="scope_key_domain" name="scope_key_domain">
                <option value="">&mdash; Select a domain &mdash;</option>
                <cfoutput query="getScopeKeyDomains">
                    <option value="#HTMLEditFormat(domain)#"<cfif existingScope EQ "domain" AND existingScopeKey EQ domain> selected</cfif>>#HTMLEditFormat(domain)#</option>
                </cfoutput>
            </select>
        </div>

        <div id="scopeKeyWrap_relay" class="form-group mb-3" style="display:none;">
            <label class="form-label"><strong>Relay Recipient Address</strong></label>
            <select class="form-select" id="scope_key_relay" name="scope_key_relay">
                <option value="">&mdash; Select a relay recipient &mdash;</option>
                <cfoutput query="getScopeKeyRelays">
                    <option value="#HTMLEditFormat(recipient)#"<cfif existingScope EQ "relay" AND existingScopeKey EQ recipient> selected</cfif>>#HTMLEditFormat(recipient)#</option>
                </cfoutput>
            </select>
        </div>

        <!-- Enabled toggle -->
        <div class="form-group mb-3">
            <div class="form-check form-switch">
                <cfoutput>
                <input class="form-check-input" type="checkbox" name="enabled" id="enabled" value="1"<cfif existingEnabled EQ 1> checked</cfif>>
                </cfoutput>
                <label class="form-check-label" for="enabled"><strong>Enabled</strong></label>
            </div>
            <small class="form-text text-muted">If unchecked, this row is skipped at send time even if the scope key matches. An empty body is also treated as disabled.</small>
        </div>

        <!-- Position -->
        <div class="form-group mb-3">
            <label class="form-label"><strong>Position</strong></label>
            <cfoutput>
            <select class="form-select" id="position" name="position">
                <option value="append" <cfif existingPosition EQ "append"> selected</cfif>>Append &mdash; add after the user's body</option>
                <option value="prepend"<cfif existingPosition EQ "prepend">selected</cfif>>Prepend &mdash; add before the user's body</option>
            </select>
            </cfoutput>
            <small class="form-text text-muted">Append is the standard pattern (footer-style). Prepend is unusual but supported for legal/regulatory headers.</small>
        </div>

        <!-- Body (Quill WYSIWYG editor for HTML; plain-text auto-derived) -->
        <div class="form-group mb-3">
            <label class="form-label"><strong>Body</strong></label>
            <div id="quill_editor"></div>
            <!-- Hidden textarea — Quill writes its HTML here on form submit. -->
            <cfoutput>
            <textarea id="body_html" name="body_html" style="display:none;">#HTMLEditFormat(existingHtml)#</textarea>
            </cfoutput>
            <small class="form-text text-muted mt-2">Format your disclaimer using the toolbar. The HTML version is used on the <code>text/html</code> part of multipart messages; the plain-text version (auto-derived from this HTML by default) is used on the <code>text/plain</code> part.</small>
        </div>

        <!-- "Edit text separately" toggle. Hidden by default — only visible
             on edit if the stored text differs from the auto-derived version. -->
        <div class="form-check form-switch mb-3">
            <input class="form-check-input" type="checkbox" id="editTextSeparately">
            <label class="form-check-label" for="editTextSeparately">
                <strong>Edit plain-text version separately</strong>
                <small class="text-muted ms-1">(advanced &mdash; auto-derived from HTML by default)</small>
            </label>
        </div>

        <!-- Plain-text body, hidden by default; revealed by the toggle above. -->
        <div class="form-group mb-3" id="textBodyWrap" style="display:none;">
            <label class="form-label"><strong>Plain-Text Body</strong></label>
            <cfoutput>
            <textarea class="form-control font-monospace" id="body_text" name="body_text" rows="6" placeholder="-- &##10;CONFIDENTIAL: This message and any attachments are confidential...">#HTMLEditFormat(existingText)#</textarea>
            </cfoutput>
            <small class="form-text text-muted">Use this when the plain-text version needs different formatting than the auto-derived version (specific line wraps, ASCII separators, exact wording variations for compliance/regulatory text).</small>
        </div>

        <!-- Buttons -->
        <div class="d-flex gap-2 mt-4">
            <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i> Save</button>
            <button type="button" class="btn btn-outline-secondary" id="previewBtn"><i class="fas fa-eye me-1"></i> Preview</button>
            <a href="view_disclaimers.cfm" class="btn btn-outline-secondary"><i class="fas fa-times me-1"></i> Cancel</a>
        </div>
    </form>

    </div>
</div>

<!-- Preview panel (hidden until Preview button clicked) -->
<div class="card card-outline card-secondary mb-4" id="previewPanel" style="display:none;">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h3 class="card-title m-0"><i class="fas fa-eye me-2"></i>Preview</h3>
        <button type="button" class="btn-close" id="previewCloseBtn" aria-label="Close"></button>
    </div>
    <div class="card-body">
        <p class="text-muted small mb-2"><i class="fas fa-info-circle me-1"></i> This is a client-side approximation. The actual disclaimer is rendered by altermime when the message goes out through Amavis.</p>
        <div id="previewPanelBody" style="border:1px dashed ##aaa;padding:1em;background:##fff;"></div>
    </div>
</div>

</div>
</div>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
</body>
</html>
