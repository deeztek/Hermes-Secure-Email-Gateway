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

<script>
$(document).ready(function() {
    // Scope dropdown drives which scope_key select is visible.
    // Three selects are rendered server-side (one per source table)
    // and we toggle them based on the chosen scope. The non-visible
    // ones get their `disabled` attr set so they don't post values.
    function syncScopeKeyVisibility() {
        var scope = $('#scope').val();
        var allKeys = ['domain', 'relay'];
        allKeys.forEach(function(k) {
            var $wrap = $('#scopeKeyWrap_' + k);
            var $sel  = $('#scope_key_' + k);
            if (k === scope) {
                $wrap.show();
                $sel.prop('disabled', false);
            } else {
                $wrap.hide();
                $sel.prop('disabled', true);
            }
        });
    }
    $('#scope').on('change', syncScopeKeyVisibility);
    syncScopeKeyVisibility();

    // Preview: render an example email with the disclaimer applied.
    // Pure client-side, no server roundtrip. Demonstrates the
    // append/prepend position. Uses body_html if provided, otherwise
    // body_text rendered as <pre>.
    $('#previewBtn').on('click', function() {
        var bodyText = $('#body_text').val() || '';
        var bodyHtml = $('#body_html').val() || '';
        var position = $('#position').val();
        var sample = '<p>This is the original email body that the user composed. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>';
        var disclaimerHtml;
        if (bodyHtml.trim().length > 0) {
            disclaimerHtml = '<div style="margin-top:1em;padding-top:0.5em;border-top:1px solid #ccc;font-size:0.9em;color:##555;">' + bodyHtml + '</div>';
        } else if (bodyText.trim().length > 0) {
            disclaimerHtml = '<pre style="margin-top:1em;padding-top:0.5em;border-top:1px solid #ccc;font-size:0.85em;color:##555;white-space:pre-wrap;">' + $('<div>').text(bodyText).html() + '</pre>';
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
<cfquery name="getScopeKeyRelays" datasource="hermes">
    SELECT recipient FROM recipients
    WHERE recipient_type = 'relay' OR recipient_type IS NULL
    ORDER BY recipient ASC
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

    <form method="post" action="save_disclaimer_action.cfm">
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

        <!-- Plain text body -->
        <div class="form-group mb-3">
            <label class="form-label"><strong>Plain-Text Body</strong></label>
            <cfoutput>
            <textarea class="form-control font-monospace" id="body_text" name="body_text" rows="6" placeholder="-- &##10;CONFIDENTIAL: This message and any attachments are confidential...">#HTMLEditFormat(existingText)#</textarea>
            </cfoutput>
            <small class="form-text text-muted">Used on plain-text-only messages and as the fallback for the text part of multipart messages.</small>
        </div>

        <!-- HTML body -->
        <div class="form-group mb-3">
            <label class="form-label"><strong>HTML Body <span class="text-muted fw-normal">(optional)</span></strong></label>
            <cfoutput>
            <textarea class="form-control font-monospace" id="body_html" name="body_html" rows="6" placeholder="&lt;hr&gt;&##10;&lt;p style=&quot;font-size:0.9em;color:##555&quot;&gt;CONFIDENTIAL: This message and any attachments...&lt;/p&gt;">#HTMLEditFormat(existingHtml)#</textarea>
            </cfoutput>
            <small class="form-text text-muted">Used on the HTML part of multipart messages. Leave blank to use the plain-text body for both parts.</small>
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
