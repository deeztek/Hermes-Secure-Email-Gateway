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

<style>
    /* Template gallery card styling. Mirrors edit_external_banner.cfm
       and edit_org_signature.cfm so all three modifier admin pages
       share the same visual language. */
    .template-card {
        cursor: pointer;
        transition: border-color 0.15s ease, box-shadow 0.15s ease;
        border: 2px solid transparent;
    }
    .template-card:hover {
        border-color: #adb5bd;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .template-card.is-selected {
        border-color: #0d6efd;
        box-shadow: 0 0 0 1px #0d6efd, 0 4px 16px rgba(13,110,253,0.25);
    }
    .template-card .thumb-wrap {
        background: #f8f9fa;
        border-bottom: 1px solid #dee2e6;
        height: 100px;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    .template-card .thumb-wrap img {
        max-width: 100%;
        max-height: 100%;
        object-fit: contain;
    }
    .template-card .thumb-wrap .placeholder {
        color: #6c757d;
        font-family: monospace;
        font-size: 0.85em;
    }
    .field-help { font-size: 0.85em; color: #6c757d; }

    #previewFrame {
        width: 100%;
        min-height: 240px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        background: #fff;
        transition: opacity 0.15s ease;
    }
    #previewFrame.preview-stale { opacity: 0.55; }
</style>
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
                <h1 class="m-0" id="pageTitle">New Disclaimer</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item"><a href="view_disclaimers.cfm">Disclaimers</a></li>
                    <li class="breadcrumb-item active" id="crumbMode">Add</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<!--- PRO EDITION LICENSE CHECK (#214 / #235). --->
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

<cfset existingRow = {
    id:            0,
    scope:         "",
    scope_key:     "",
    enabled:       1,
    position:      "append",
    template_key:  "",
    fields_json:   ""
}>
<cfset existingFields = {}>

<cfif isEdit>
    <cfquery name="getDisclaimer" datasource="hermes">
        SELECT id, scope, scope_key, enabled, position, template_key, fields_json
        FROM disclaimers
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getDisclaimer.recordcount LT 1>
        <cfset session.disclaimer_msg = "<strong>Not found.</strong> Disclaimer ID ##" & url.id & " no longer exists.">
        <cfset session.disclaimer_msg_type = "warning">
        <cflocation url="view_disclaimers.cfm" addtoken="no">
    </cfif>
    <cfset existingRow = {
        id:            getDisclaimer.id,
        scope:         getDisclaimer.scope,
        scope_key:     getDisclaimer.scope_key,
        enabled:       Val(getDisclaimer.enabled),
        position:      getDisclaimer.position,
        template_key:  getDisclaimer.template_key,
        fields_json:   getDisclaimer.fields_json
    }>
    <cfif Len(Trim(existingRow.fields_json))>
        <cftry>
            <cfset existingFields = DeserializeJSON(existingRow.fields_json)>
            <cfcatch type="any">
                <cfset existingFields = {}>
            </cfcatch>
        </cftry>
    </cfif>
</cfif>

<!--- Restore form data after a server-side validation redirect. --->
<cfif structKeyExists(session, "disclaimer_form_restore") AND IsStruct(session.disclaimer_form_restore) AND structKeyExists(session.disclaimer_form_restore, "template_key") AND Len(session.disclaimer_form_restore.template_key)>
    <cfset restoreData = session.disclaimer_form_restore>
    <cfset existingRow.template_key = restoreData.template_key>
    <cfset restoreTmplPath = "">
    <cfinclude template="./inc/disclaimer_template_loader.cfm" />
    <cfif ArrayContains(variables.disclaimerTemplateRegistry, restoreData.template_key)>
        <cfset restoreTmplPath = variables.disclaimerTemplateDir & restoreData.template_key & ".cfm">
    </cfif>
    <cfif Len(restoreTmplPath) AND FileExists(restoreTmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/disclaimer_templates/#restoreData.template_key#.cfm" />
        <cfloop array="#template.fields#" index="rf">
            <cfset rk = "field_" & rf.name>
            <cfif structKeyExists(restoreData, rk)>
                <cfif rf.type EQ "checkbox">
                    <cfset existingFields[rf.name] = (restoreData[rk] EQ "1")>
                <cfelse>
                    <cfset existingFields[rf.name] = restoreData[rk]>
                </cfif>
            </cfif>
        </cfloop>
    </cfif>
    <cfset StructDelete(session, "disclaimer_form_restore")>
</cfif>

<!--- Flash message from prior save attempt. --->
<cfset flashMsg = "">
<cfset flashType = "danger">
<cfif structKeyExists(session, "disclaimer_msg") AND Len(session.disclaimer_msg)>
    <cfset flashMsg = session.disclaimer_msg>
    <cfset flashType = structKeyExists(session, "disclaimer_msg_type") ? session.disclaimer_msg_type : "danger">
    <cfset StructDelete(session, "disclaimer_msg")>
    <cfset StructDelete(session, "disclaimer_msg_type")>
</cfif>

<!--- POPULATE SCOPE_KEY DROPDOWN OPTIONS. Same queries the prior Quill
     UI used. Domain-scope = disclaimer for all addresses in a mailbox
     domain; relay-scope = override for a specific relay-recipient
     address. --->
<cfquery name="getScopeKeyDomains" datasource="hermes">
    SELECT domain FROM domains ORDER BY domain ASC
</cfquery>
<cfquery name="getScopeKeyRelays" datasource="hermes">
    SELECT r.recipient
    FROM recipients r
    LEFT JOIN mailboxes m ON m.username = r.recipient
    WHERE (r.recipient_type = 'relay' OR r.recipient_type IS NULL)
      AND r.domain IS NULL
      AND m.id IS NULL
    ORDER BY r.recipient ASC
</cfquery>

<!--- Load every template's metadata for the gallery + JS bootstrap. --->
<cfinclude template="./inc/disclaimer_template_loader.cfm" />

<cfset allTemplates = []>
<cfloop array="#variables.disclaimerTemplateRegistry#" index="tmplKey">
    <cfset tmplPath = variables.disclaimerTemplateDir & tmplKey & ".cfm">
    <cfif FileExists(tmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/disclaimer_templates/#tmplKey#.cfm" />
        <cfif StructKeyExists(template, "key")>
            <cfset thumbPath = variables.disclaimerTemplateDir & "thumbnails/" & template.thumbnail>
            <cfset template.thumbnailExists = FileExists(thumbPath)>
            <cfset ArrayAppend(allTemplates, template)>
        </cfif>
    </cfif>
</cfloop>

<cfif flashMsg NEQ "">
    <div class="alert alert-<cfoutput>#flashType#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput>#flashMsg#</cfoutput>
    </div>
</cfif>

<form id="disclaimerForm" method="post" action="save_disclaimer_action.cfm" novalidate>
    <input type="hidden" name="mode"         id="form_mode"         value="<cfoutput>#(isEdit ? 'edit' : 'add')#</cfoutput>">
    <input type="hidden" name="id"           id="form_id"           value="<cfoutput>#existingRow.id#</cfoutput>">
    <input type="hidden" name="template_key" id="form_template_key" value="<cfoutput>#HTMLEditFormat(existingRow.template_key)#</cfoutput>">

    <!--- SCOPE CARD --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-globe me-2"></i>Scope</h3>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Scope</strong></label>
                    <cfoutput>
                    <select class="form-select" id="scope" name="scope" <cfif isEdit>disabled</cfif>>
                        <option value="domain" <cfif existingRow.scope EQ "domain">selected</cfif>>Domain</option>
                        <option value="relay"  <cfif existingRow.scope EQ "relay">selected</cfif>>Relay Recipient</option>
                    </select>
                    <cfif isEdit>
                        <input type="hidden" name="scope" value="#existingRow.scope#">
                    </cfif>
                    </cfoutput>
                    <p class="field-help mt-1 mb-0">
                        <cfif isEdit>
                            <i class="fas fa-lock me-1"></i> Scope is locked after creation. Delete and re-create to change scope.
                        <cfelse>
                            Domain disclaimers apply to all addresses in the domain. Relay-recipient disclaimers override the domain default for one specific upstream sender. Most-specific wins at send time.
                        </cfif>
                    </p>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Position</strong></label>
                    <cfoutput>
                    <select class="form-select" id="position" name="position">
                        <option value="append" <cfif existingRow.position EQ "append">selected</cfif>>Bottom &mdash; append after the user's body (recommended)</option>
                        <option value="prepend"<cfif existingRow.position EQ "prepend">selected</cfif>>Top &mdash; prepend before the user's body</option>
                    </select>
                    </cfoutput>
                    <p class="field-help mt-1 mb-0">Append is the standard footer-style placement.</p>
                </div>
            </div>

            <!--- Scope-key dropdowns (mutually exclusive; JS toggles). --->
            <div id="scopeKeyWrap_domain" class="mb-3">
                <label class="form-label"><strong>Domain</strong></label>
                <select class="form-select" id="scope_key_domain" name="scope_key_domain" <cfif isEdit>disabled</cfif>>
                    <option value="">&mdash; Select a domain &mdash;</option>
                    <cfoutput query="getScopeKeyDomains">
                        <option value="#HTMLEditFormat(domain)#"<cfif existingRow.scope EQ "domain" AND existingRow.scope_key EQ domain> selected</cfif>>#HTMLEditFormat(domain)#</option>
                    </cfoutput>
                </select>
                <cfif isEdit AND existingRow.scope EQ "domain">
                    <cfoutput><input type="hidden" name="scope_key_domain" value="#HTMLEditFormat(existingRow.scope_key)#"></cfoutput>
                </cfif>
            </div>

            <div id="scopeKeyWrap_relay" class="mb-3" style="display:none;">
                <label class="form-label"><strong>Relay Recipient Address</strong></label>
                <select class="form-select" id="scope_key_relay" name="scope_key_relay" <cfif isEdit>disabled</cfif>>
                    <option value="">&mdash; Select a relay recipient &mdash;</option>
                    <cfoutput query="getScopeKeyRelays">
                        <option value="#HTMLEditFormat(recipient)#"<cfif existingRow.scope EQ "relay" AND existingRow.scope_key EQ recipient> selected</cfif>>#HTMLEditFormat(recipient)#</option>
                    </cfoutput>
                </select>
                <cfif isEdit AND existingRow.scope EQ "relay">
                    <cfoutput><input type="hidden" name="scope_key_relay" value="#HTMLEditFormat(existingRow.scope_key)#"></cfoutput>
                </cfif>
            </div>

            <div class="form-check form-switch">
                <cfoutput>
                <input class="form-check-input" type="checkbox" name="enabled" id="form_enabled" value="1"<cfif existingRow.enabled EQ 1> checked</cfif>>
                </cfoutput>
                <label class="form-check-label" for="form_enabled"><strong>Enabled</strong></label>
                <p class="field-help mt-1 mb-0">When unchecked the disclaimer is skipped at send time even if scope matches.</p>
            </div>
        </div>
    </div>

    <!--- TEMPLATE GALLERY CARD --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-th-large me-2"></i>Template</h3>
        </div>
        <div class="card-body">
            <p class="text-muted mb-3">Pick a disclaimer style. All templates use table-based HTML with inline styles for Gmail / Outlook / Apple Mail compatibility.</p>
            <div class="row g-3" id="templateGallery">
                <cfloop array="#allTemplates#" index="t">
                    <cfoutput>
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="card template-card h-100" data-template-key="#HTMLEditFormat(t.key)#">
                            <div class="thumb-wrap">
                                <cfif t.thumbnailExists>
                                    <img src="inc/disclaimer_templates/thumbnails/#HTMLEditFormat(t.thumbnail)#" alt="#HTMLEditFormat(t.name)# preview">
                                <cfelse>
                                    <span class="placeholder">[#HTMLEditFormat(t.key)#]</span>
                                </cfif>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title fs-6 mb-1">#HTMLEditFormat(t.name)#</h5>
                                <p class="card-text small text-muted mb-0">#HTMLEditFormat(t.description)#</p>
                            </div>
                        </div>
                    </div>
                    </cfoutput>
                </cfloop>
            </div>
        </div>
    </div>

    <!--- DYNAMIC FORM CARD: rendered from the active template's fields. --->
    <div class="card card-primary card-outline mb-4" id="dynamicFormCard" style="display:none;">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-list-ul me-2"></i>Disclaimer Content</h3>
        </div>
        <div class="card-body">
            <div id="dynamicFormFields"></div>
        </div>
    </div>

    <!--- PREVIEW CARD --->
    <div class="card card-primary card-outline mb-4" id="previewCard" style="display:none;">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h3 class="card-title m-0"><i class="fas fa-eye me-2"></i>Preview</h3>
            <button type="button" class="btn btn-sm btn-outline-secondary" id="btnRefreshPreview">
                <i class="fas fa-sync-alt me-1"></i> Refresh
            </button>
        </div>
        <div class="card-body">
            <div class="alert alert-info mb-3">
                <i class="fas fa-info-circle me-2"></i>
                Preview shows the disclaimer as the body milter will inject it on outbound mail. Position (append or prepend) is applied at send time and not reflected here.
            </div>
            <iframe id="previewFrame" sandbox="allow-same-origin"></iframe>
        </div>
    </div>

    <!--- ACTION BAR --->
    <div class="d-flex justify-content-end gap-2 mb-4">
        <a href="view_disclaimers.cfm" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary" id="btnSave" disabled>
            <i class="fas fa-save me-1"></i> Save Disclaimer
        </button>
    </div>
</form>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

<script>
// Server-side bootstrap: every available template + the existing row's
// stored fields when editing. Lucee uppercases struct keys; normalize.
function normalizeKeys(v) {
    if (Array.isArray(v)) return v.map(normalizeKeys);
    if (v && typeof v === 'object') {
        const out = {};
        for (const k in v) out[k.toLowerCase()] = normalizeKeys(v[k]);
        return out;
    }
    return v;
}
const TEMPLATES = normalizeKeys(<cfoutput>#SerializeJSON(allTemplates)#</cfoutput>);
const EXISTING_FIELDS = normalizeKeys(<cfoutput>#SerializeJSON(existingFields)#</cfoutput>);
const IS_EDIT = <cfoutput>#(isEdit ? 'true' : 'false')#</cfoutput>;
const INITIAL_TEMPLATE_KEY = <cfoutput>"#JSStringFormat(existingRow.template_key)#"</cfoutput>;

const fieldsByTemplate = {};
let activeTemplateKey = '';
let previewDebounceTimer = null;

function findTemplate(key) {
    return TEMPLATES.find(function (t) { return t.key === key; });
}

function selectTemplate(key) {
    if (!key) return;
    if (activeTemplateKey === key) return;
    if (activeTemplateKey) captureCurrentFields();
    activeTemplateKey = key;

    document.querySelectorAll('.template-card').forEach(function (card) {
        card.classList.toggle('is-selected', card.dataset.templateKey === key);
    });
    document.getElementById('form_template_key').value = key;

    const tmpl = findTemplate(key);
    if (!tmpl) return;

    renderFields(tmpl);
    document.getElementById('dynamicFormCard').style.display = '';
    document.getElementById('previewCard').style.display = '';
    document.getElementById('btnSave').disabled = false;
    schedulePreviewRefresh();
}

function renderFields(tmpl) {
    const container = document.getElementById('dynamicFormFields');
    container.innerHTML = '';

    const stored = (tmpl.key === INITIAL_TEMPLATE_KEY) ? EXISTING_FIELDS : (fieldsByTemplate[tmpl.key] || {});

    tmpl.fields.forEach(function (field) {
        const wrap = document.createElement('div');
        wrap.className = 'mb-3 field-row';
        wrap.dataset.fieldName = field.name;
        if (field.showif) wrap.dataset.showIf = field.showif;

        const label = document.createElement('label');
        label.className = 'form-label';
        label.setAttribute('for', 'fld_' + field.name);
        const labelStrong = document.createElement('strong');
        labelStrong.textContent = field.label;
        label.appendChild(labelStrong);

        let input;
        const value = (field.name in stored) ? stored[field.name] : field.default;

        if (field.type === 'checkbox') {
            wrap.classList.remove('mb-3');
            wrap.classList.add('mb-3', 'form-check', 'form-switch');
            input = document.createElement('input');
            input.type = 'checkbox';
            input.className = 'form-check-input';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.value = '1';
            input.checked = !!value;
            label.className = 'form-check-label';
            wrap.appendChild(input);
            wrap.appendChild(label);
        } else if (field.type === 'textarea') {
            input = document.createElement('textarea');
            input.className = 'form-control';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.rows = 4;
            input.value = value || '';
            if (field.placeholder) input.placeholder = field.placeholder;
            wrap.appendChild(label);
            wrap.appendChild(input);
        } else {
            input = document.createElement('input');
            input.type = (field.type === 'url' ? 'url' : (field.type === 'email' ? 'email' : 'text'));
            input.className = 'form-control';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.value = value || '';
            if (field.placeholder) input.placeholder = field.placeholder;
            wrap.appendChild(label);
            wrap.appendChild(input);

            if (field.type === 'url') {
                const fb = document.createElement('div');
                fb.className = 'invalid-feedback';
                fb.textContent = 'Must be a full URL starting with https:// or http://.';
                wrap.appendChild(fb);
            }
        }

        if (field.help) {
            const help = document.createElement('p');
            help.className = 'field-help mt-1 mb-0';
            help.textContent = field.help;
            wrap.appendChild(help);
        }

        container.appendChild(wrap);
    });

    applyShowIfGating();
}

function applyShowIfGating() {
    document.querySelectorAll('.field-row').forEach(function (row) {
        if (!row.dataset.showIf) {
            row.style.display = '';
            return;
        }
        const target = document.querySelector('#fld_' + row.dataset.showIf);
        row.style.display = (target && target.checked) ? '' : 'none';
    });
}

function captureCurrentFields() {
    if (!activeTemplateKey) return;
    const tmpl = findTemplate(activeTemplateKey);
    if (!tmpl) return;
    const captured = {};
    tmpl.fields.forEach(function (f) {
        const el = document.getElementById('fld_' + f.name);
        if (!el) return;
        if (f.type === 'checkbox') captured[f.name] = el.checked;
        else captured[f.name] = el.value;
    });
    fieldsByTemplate[activeTemplateKey] = captured;
}

function schedulePreviewRefresh() {
    if (previewDebounceTimer) clearTimeout(previewDebounceTimer);
    document.getElementById('previewFrame').classList.add('preview-stale');
    previewDebounceTimer = setTimeout(refreshPreview, 250);
}

function refreshPreview() {
    if (!activeTemplateKey) return;
    const fd = new FormData();
    fd.append('template_key', activeTemplateKey);
    document.querySelectorAll('#dynamicFormFields input, #dynamicFormFields textarea').forEach(function (el) {
        if (el.type === 'checkbox') {
            if (el.checked) fd.append(el.name, el.value);
        } else {
            fd.append(el.name, el.value);
        }
    });

    fetch('inc/render_disclaimer_preview.cfm', { method: 'POST', body: fd, credentials: 'same-origin' })
        .then(function (r) { return r.text(); })
        .then(function (html) {
            const iframe = document.getElementById('previewFrame');
            const sampleBody = '<p style="margin:0 0 16px 0;color:##333;">[The user\'s email body would appear here. The disclaimer renders below.]</p>';
            iframe.srcdoc =
                '<!doctype html><html><head><base href="' + location.origin + '/">' +
                '<style>body{margin:12px;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;color:##333;}</style>' +
                '</head><body>' + sampleBody + html + '</body></html>';
            iframe.classList.remove('preview-stale');
        })
        .catch(function () {
            const iframe = document.getElementById('previewFrame');
            iframe.srcdoc = '<p style="color:##b91c1c;padding:1em;">Preview render failed.</p>';
            iframe.classList.remove('preview-stale');
        });
}

// Scope dropdown -> show/hide scope_key dropdowns (mutually exclusive).
function syncScopeKeyVisibility() {
    const scope = document.getElementById('scope').value;
    ['domain', 'relay'].forEach(function (k) {
        const wrap = document.getElementById('scopeKeyWrap_' + k);
        const sel  = document.getElementById('scope_key_' + k);
        if (k === scope) {
            wrap.style.display = '';
            sel.disabled = false;
        } else {
            wrap.style.display = 'none';
            // Don't change disabled on edit-mode hidden mirrors; just hide visually.
            if (!IS_EDIT) sel.disabled = true;
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    syncScopeKeyVisibility();
    document.getElementById('scope').addEventListener('change', syncScopeKeyVisibility);

    document.querySelectorAll('.template-card').forEach(function (card) {
        card.addEventListener('click', function () {
            selectTemplate(card.dataset.templateKey);
        });
    });

    if (INITIAL_TEMPLATE_KEY) {
        selectTemplate(INITIAL_TEMPLATE_KEY);
    }

    document.getElementById('dynamicFormFields').addEventListener('input', function () {
        applyShowIfGating();
        schedulePreviewRefresh();
    });
    document.getElementById('dynamicFormFields').addEventListener('change', function () {
        applyShowIfGating();
        schedulePreviewRefresh();
    });

    document.getElementById('btnRefreshPreview').addEventListener('click', refreshPreview);

    document.getElementById('disclaimerForm').addEventListener('submit', function (ev) {
        if (!activeTemplateKey) {
            ev.preventDefault();
            alert('Pick a template first.');
            return;
        }
        // Scope-key required.
        const scope = document.getElementById('scope').value;
        const scopeKeyEl = document.getElementById('scope_key_' + scope);
        if (scopeKeyEl && !scopeKeyEl.value) {
            ev.preventDefault();
            const preloader = document.querySelector('.preloader');
            if (preloader) { preloader.style.display = 'none'; preloader.style.opacity = '0'; }
            alert('Please select a ' + scope + '.');
            scopeKeyEl.focus();
            return;
        }
        // URL validation on dynamic fields.
        let firstBad = null;
        document.querySelectorAll('#dynamicFormFields input, #dynamicFormFields textarea').forEach(function (el) {
            el.classList.remove('is-invalid');
        });
        document.querySelectorAll('#dynamicFormFields input').forEach(function (el) {
            const v = (el.value || '').trim();
            if (!v) return;
            let bad = false;
            if (el.type === 'url') {
                if (!/^https?:\/\/[^\s]+$/i.test(v)) bad = true;
            }
            if (bad) {
                el.classList.add('is-invalid');
                if (!firstBad) firstBad = el;
            }
        });
        if (firstBad) {
            ev.preventDefault();
            ev.stopPropagation();
            const preloader = document.querySelector('.preloader');
            if (preloader) { preloader.style.display = 'none'; preloader.style.opacity = '0'; }
            const row = firstBad.closest('.field-row');
            if (row) row.style.display = '';
            firstBad.focus();
        }
    });

    if (IS_EDIT) {
        document.getElementById('pageTitle').textContent = 'Edit Disclaimer';
        document.getElementById('crumbMode').textContent = 'Edit';
    }
});
</script>

</div>
</body>
</html>
