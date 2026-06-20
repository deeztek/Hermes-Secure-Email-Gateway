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
EDIT EXTERNAL SENDER BANNER (#228) - template gallery + dynamic form.

Mirrors edit_org_signature.cfm's UX: admin picks one of N bundled
templates from a thumbnail gallery, fills in the form fields, and the
server renders pixel-perfect HTML server-side at save time. Avoids
Quill 2.x's HTML-normalization issues that strip inline styles in
Gmail / Outlook (we hit this same wall on #226 Phase 2 and pivoted
the same way).

URL forms:
    edit_external_banner.cfm           - Add new
    edit_external_banner.cfm?id=N      - Edit existing row N

Both Community + Pro - no license gate.

Three persistent fields are admin-supplied regardless of template:
    - recipient_domain  (NULL = system default; non-NULL = per-domain)
    - position          (prepend / append, default prepend)
    - enabled           (TINYINT 0/1)

The rest of the form is template-specific. Preview is server-side
rendered via inc/render_external_banner_preview.cfm so the iframe
always shows exactly what save_external_banner_action.cfm will store.
--->

<cfinclude template="./inc/setsession.cfm" />

<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | External Sender Banner | Edit</title>

<cfinclude template="./inc/html_head.cfm" />

<style>
.template-card {
    cursor: pointer;
    transition: transform 120ms ease, box-shadow 120ms ease, border-color 120ms ease;
    border: 2px solid #e5e7eb;
}
.template-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
.template-card.is-selected { border-color: #0d6efd; box-shadow: 0 0 0 3px rgba(13,110,253,0.15); }
.template-card .thumb-wrap {
    background: #f8f9fa; border-bottom: 1px solid #e5e7eb;
    padding: 12px; text-align: center; min-height: 110px;
    display: flex; align-items: center; justify-content: center;
}
.template-card .thumb-wrap img { max-width: 100%; height: auto; }
.template-card .thumb-wrap .placeholder {
    color: #9ca3af; font-size: 12px; font-style: italic;
}
/* Bulletproof title/description block layout: explicit display + spacing
   so neither AdminLTE nor Bootstrap utility classes can collapse them
   inline in narrow column widths. */
.template-card .card-body {
    text-align: left;
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
}
.template-card .card-body .card-title,
.template-card .card-body .card-text {
    display: block;
    margin: 0;
}
.field-help { color: #6b7280; font-size: 12px; }
#previewFrame {
    width: 100%; height: 280px; border: 1px solid #e5e7eb; border-radius: 4px; background: #fff;
}
.preview-stale { opacity: 0.6; }
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
                <h1 class="m-0" id="pageTitle">Add External Sender Banner</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item"><a href="view_external_banners.cfm">External Sender Banner</a></li>
                    <li class="breadcrumb-item active" id="crumbMode">Add</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<cfif structKeyExists(session, "ext_banner_msg") AND session.ext_banner_msg NEQ "">
    <cfset flashMsg = session.ext_banner_msg>
    <cfset flashType = session.ext_banner_msg_type>
    <cfset session.ext_banner_msg = "">
    <cfset session.ext_banner_msg_type = "">
<cfelse>
    <cfset flashMsg = "">
    <cfset flashType = "">
</cfif>

<cfparam name="url.id" default="0">
<cfset isEdit = IsNumeric(url.id) AND Val(url.id) GT 0>

<!--- One-shot form-restore on save validation failure. --->
<cfset restoreFromForm = false>
<cfset restoreData = {}>
<cfif structKeyExists(session, "ext_banner_form_restore") AND IsStruct(session.ext_banner_form_restore) AND structKeyExists(session.ext_banner_form_restore, "template_key") AND Len(session.ext_banner_form_restore.template_key)>
    <cfset restoreData = session.ext_banner_form_restore>
    <cfset restoreFromForm = true>
</cfif>
<cfif structKeyExists(session, "ext_banner_form_restore")>
    <cfset session.ext_banner_form_restore = {}>
</cfif>

<!--- Pre-load existing row when editing. --->
<cfset existingRow = {}>
<cfset existingFields = {}>
<cfif isEdit>
    <cfquery name="loadRow" datasource="hermes">
        SELECT id, recipient_domain, template_key, fields_json,
               position, enabled
        FROM external_banners
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif loadRow.recordcount LT 1>
        <cfset session.ext_banner_msg = "<strong>Not found.</strong> Banner ID ##" & url.id & " no longer exists.">
        <cfset session.ext_banner_msg_type = "warning">
        <cflocation url="view_external_banners.cfm" addtoken="no">
    </cfif>
    <cfset existingRow = {
        id:               loadRow.id,
        recipient_domain: loadRow.recipient_domain,
        template_key:     loadRow.template_key,
        position:         loadRow.position,
        enabled:          Val(loadRow.enabled)
    }>
    <cftry>
        <cfset existingFields = DeserializeJSON(loadRow.fields_json)>
        <cfcatch type="any">
            <cfset existingFields = {}>
        </cfcatch>
    </cftry>
</cfif>

<!--- Restore-data overrides existingRow when admin is bouncing back from a
     save-time validation failure. --->
<cfif restoreFromForm>
    <cfset existingRow = {
        id:               Val(restoreData.id ?: 0),
        recipient_domain: restoreData.recipient_domain ?: "",
        template_key:     restoreData.template_key,
        position:         restoreData.position ?: "prepend",
        enabled:          ((restoreData.enabled ?: "0") EQ "1") ? 1 : 0
    }>
    <cfset isEdit = (restoreData.mode ?: "add") EQ "edit">

    <cfset restoreTmplPath = variables.externalBannerTemplateDir & restoreData.template_key & ".cfm">
    <cfif FileExists(restoreTmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/external_banner_templates/#restoreData.template_key#.cfm" />
        <cfset existingFields = {}>
        <cfloop array="#template.fields#" index="rf">
            <cfset rk = "field_" & rf.name>
            <cfif rf.type EQ "checkbox">
                <cfset existingFields[rf.name] = StructKeyExists(restoreData, rk) AND Trim(restoreData[rk]) EQ "1">
            <cfelseif StructKeyExists(restoreData, rk)>
                <cfset existingFields[rf.name] = restoreData[rk]>
            </cfif>
        </cfloop>
    </cfif>
</cfif>

<!--- Mailbox-hosting domains for the recipient_domain dropdown. --->
<cfquery name="getRecipientDomains" datasource="hermes">
    SELECT domain
    FROM domains
    WHERE type = 'mailbox'
    ORDER BY domain ASC
</cfquery>

<cfinclude template="./inc/external_banner_template_loader.cfm" />

<!--- Load every available template's metadata for the gallery + form
     generator. --->
<cfset allTemplates = []>
<cfloop array="#variables.externalBannerTemplateRegistry#" index="tmplKey">
    <cfset tmplPath = variables.externalBannerTemplateDir & tmplKey & ".cfm">
    <cfif FileExists(tmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/external_banner_templates/#tmplKey#.cfm" />
        <cfif StructKeyExists(template, "key")>
            <cfset thumbPath = variables.externalBannerTemplateDir & "thumbnails/" & template.thumbnail>
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

<form id="bannerForm" method="post" action="inc/save_external_banner_action.cfm" novalidate>
    <input type="hidden" name="mode"         id="form_mode"         value="<cfoutput>#(isEdit ? 'edit' : 'add')#</cfoutput>">
    <input type="hidden" name="id"           id="form_id"           value="<cfoutput>#(isEdit ? existingRow.id : 0)#</cfoutput>">
    <input type="hidden" name="template_key" id="form_template_key" value="<cfoutput>#(isEdit ? HTMLEditFormat(existingRow.template_key) : '')#</cfoutput>">

    <!--- SCOPE CARD: who does this banner apply to? --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-globe me-2"></i>Scope</h3>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Recipient Domain</strong></label>
                    <cfset existingDomain = StructKeyExists(existingRow, "recipient_domain") ? Trim(existingRow.recipient_domain) : "">
                    <cfset existingDomainNull = (Len(existingDomain) EQ 0)>
                    <select class="form-select" name="recipient_domain" id="form_recipient_domain" <cfif isEdit>disabled</cfif>>
                        <option value="" <cfif existingDomainNull>selected</cfif>>&mdash; System default (all recipient domains) &mdash;</option>
                        <cfoutput query="getRecipientDomains">
                            <option value="#HTMLEditFormat(domain)#" <cfif NOT existingDomainNull AND existingDomain EQ domain>selected</cfif>>#HTMLEditFormat(domain)#</option>
                        </cfoutput>
                    </select>
                    <cfif isEdit>
                        <input type="hidden" name="recipient_domain" value="<cfoutput>#HTMLEditFormat(existingDomain)#</cfoutput>">
                    </cfif>
                    <p class="field-help mt-1 mb-0">
                        <cfif isEdit>
                            <i class="fas fa-lock me-1"></i> Recipient domain is locked after creation. Delete and re-create to change scope.
                        <cfelse>
                            The system default applies to all recipient domains. Add per-domain overrides only when a specific domain needs different copy.
                        </cfif>
                    </p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Position</strong></label>
                    <cfset existingPosition = StructKeyExists(existingRow, "position") ? existingRow.position : "prepend">
                    <select class="form-select" name="position" id="form_position">
                        <option value="prepend" <cfif existingPosition EQ "prepend">selected</cfif>>Top &mdash; banner appears at the top of the message (recommended)</option>
                        <option value="append"  <cfif existingPosition EQ "append">selected</cfif>>Bottom &mdash; banner appears at the bottom of the message</option>
                    </select>
                    <p class="field-help mt-1 mb-0">Industry-standard placement is the top so users see the warning immediately.</p>
                </div>
            </div>

            <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" name="enabled" id="form_enabled" value="1"
                       <cfif (NOT isEdit) OR (StructKeyExists(existingRow, "enabled") AND existingRow.enabled EQ 1)>checked</cfif>>
                <label class="form-check-label" for="form_enabled"><strong>Enabled</strong></label>
                <p class="field-help mt-1 mb-0">When unchecked the banner is skipped at message time. Useful for staging copy changes before going live.</p>
            </div>
        </div>
    </div>

    <!--- TEMPLATE GALLERY CARD --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-th-large me-2"></i>Template</h3>
        </div>
        <div class="card-body">
            <p class="text-muted mb-3">Pick a banner style. Each template uses table-based HTML with <code>bgcolor=</code> attributes for cross-MUA compatibility (Outlook honors them even when CSS is stripped).</p>
            <div class="row g-3" id="templateGallery">
                <cfloop array="#allTemplates#" index="t">
                    <cfoutput>
                    <div class="col-12 col-sm-6 col-lg-3">
                        <div class="card template-card h-100" data-template-key="#HTMLEditFormat(t.key)#">
                            <div class="thumb-wrap">
                                <cfif t.thumbnailExists>
                                    <img src="inc/external_banner_templates/thumbnails/#HTMLEditFormat(t.thumbnail)#" alt="#HTMLEditFormat(t.name)# preview">
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
            <h3 class="card-title m-0"><i class="fas fa-list-ul me-2"></i>Banner Content</h3>
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
                Preview shows the banner exactly as the body milter will inject it
                into inbound mail. Banners are emitted as table-based HTML with
                <code>bgcolor=</code> attributes to survive CSS sanitization in
                Outlook / Gmail / Apple Mail.
            </div>
            <iframe id="previewFrame" sandbox="allow-same-origin"></iframe>
        </div>
    </div>

    <!--- ACTION BAR --->
    <div class="d-flex justify-content-end gap-2 mb-4">
        <a href="view_external_banners.cfm" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary" id="btnSave" disabled>
            <i class="fas fa-save me-1"></i> Save Banner
        </button>
    </div>
</form>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

<script>
// Server-side bootstrap: every available template + the existing row's
// stored fields when editing.
//
// Lucee's SerializeJSON uppercases struct keys by default; normalizeKeys()
// recursively lowercases so JS sees the original casing the templates
// declared.
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
const INITIAL_TEMPLATE_KEY = <cfoutput>"#(structKeyExists(existingRow, 'template_key') ? JSStringFormat(existingRow.template_key) : '')#"</cfoutput>;

// Cache of admin's typed values per template_key, so switching templates
// preserves what they typed in case they switch back.
const fieldsByTemplate = {};

let activeTemplateKey = '';
let previewDebounceTimer = null;

function findTemplate(key) {
    return TEMPLATES.find(function (t) { return t.key === key; });
}

function selectTemplate(key) {
    if (!key) return;
    if (activeTemplateKey === key) return;

    if (activeTemplateKey) {
        captureCurrentFields();
    }
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
        } else {
            input = document.createElement('input');
            input.type = (field.type === 'url' ? 'url' : 'text');
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
    document.querySelectorAll('#dynamicFormFields input').forEach(function (el) {
        if (el.type === 'checkbox') {
            if (el.checked) fd.append(el.name, el.value);
        } else {
            fd.append(el.name, el.value);
        }
    });

    fetch('inc/render_external_banner_preview.cfm', { method: 'POST', body: fd, credentials: 'same-origin' })
        .then(function (r) { return r.text(); })
        .then(function (html) {
            const iframe = document.getElementById('previewFrame');
            // srcdoc inside an iframe: use base href to resolve relative
            // assets, body styling for the inner page.
            iframe.srcdoc =
                '<!doctype html><html><head><base href="' + location.origin + '/">' +
                '<style>body{margin:12px;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;color:#333;}</style>' +
                '</head><body>' + html + '</body></html>';
            iframe.classList.remove('preview-stale');
        })
        .catch(function () {
            const iframe = document.getElementById('previewFrame');
            iframe.srcdoc = '<p style="color:#b91c1c;padding:1em;">Preview render failed.</p>';
            iframe.classList.remove('preview-stale');
        });
}

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.template-card').forEach(function (card) {
        card.addEventListener('click', function () {
            selectTemplate(card.dataset.templateKey);
        });
    });

    if (INITIAL_TEMPLATE_KEY) {
        selectTemplate(INITIAL_TEMPLATE_KEY);
    }

    // Dynamic form input/change -> showIf gating + preview refresh.
    document.getElementById('dynamicFormFields').addEventListener('input', function () {
        applyShowIfGating();
        schedulePreviewRefresh();
    });
    document.getElementById('dynamicFormFields').addEventListener('change', function () {
        applyShowIfGating();
        schedulePreviewRefresh();
    });

    document.getElementById('btnRefreshPreview').addEventListener('click', refreshPreview);

    // Submit guard: skip strict url validation when value contains a
    // placeholder (banners don't have placeholders today, but keep the
    // guard symmetric with the org-sig form).
    document.getElementById('bannerForm').addEventListener('submit', function (ev) {
        if (!activeTemplateKey) {
            ev.preventDefault();
            alert('Pick a template first.');
            return;
        }
        let firstBad = null;
        document.querySelectorAll('#dynamicFormFields input').forEach(function (el) {
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
            // html_head.cfm preloader doesn't auto-hide on preventDefault.
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
                preloader.style.opacity = '0';
            }
            const row = firstBad.closest('.field-row');
            if (row) row.style.display = '';
            firstBad.focus();
        }
    });

    // Page title swap when in edit mode.
    if (IS_EDIT) {
        document.getElementById('pageTitle').textContent = 'Edit External Sender Banner';
        document.getElementById('crumbMode').textContent = 'Edit';
    }
});
</script>

</div>
</body>
</html>
