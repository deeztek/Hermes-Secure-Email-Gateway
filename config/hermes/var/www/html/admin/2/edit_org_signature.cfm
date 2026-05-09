<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
EDIT ORGANIZATIONAL SIGNATURE (#226 Phase 2A).

Pro-only admin page that drives the gallery + dynamic form + iframe
preview UX for org_signatures rows.

URL forms:
  edit_org_signature.cfm           - Add new
  edit_org_signature.cfm?id=N      - Edit existing row N

Three persistent fields are admin-supplied regardless of template:
  - domain_id      (FK to domains.id, required)
  - department_label (NULL = domain default; non-NULL = per-dept variant)
  - enabled        (TINYINT 0/1)

The rest of the form is template-specific. The active template's
fields array drives form generation in JS, including show/hide gating
via showIf. Preview is server-side rendered via
inc/render_org_signature_preview.cfm so the iframe always shows
exactly what save_org_signature_action.cfm will store.
--->

<cfinclude template="./inc/setsession.cfm" />

<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | Organizational Signatures | Edit</title>

<cfinclude template="./inc/html_head.cfm" />

<style>
.template-card {
    cursor: pointer;
    transition: transform 120ms ease, box-shadow 120ms ease, border-color 120ms ease;
    border: 2px solid #e5e7eb;
}
.template-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
.template-card.is-selected { border-color: #d97706; box-shadow: 0 0 0 3px rgba(217,119,6,0.15); }
.template-card .thumb-wrap {
    background: #f8f9fa; border-bottom: 1px solid #e5e7eb;
    padding: 12px; text-align: center; min-height: 160px;
    display: flex; align-items: center; justify-content: center;
}
.template-card .thumb-wrap img { max-width: 100%; height: auto; }
.template-card .thumb-wrap .placeholder {
    color: #9ca3af; font-size: 12px; font-style: italic;
}
.field-help { color: #6b7280; font-size: 12px; }
#previewFrame {
    width: 100%; height: 320px; border: 1px solid #e5e7eb; border-radius: 4px; background: #fff;
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
                <h1 class="m-0" id="pageTitle">Add Organizational Signature</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item"><a href="view_org_signatures.cfm">Organizational Signatures</a></li>
                    <li class="breadcrumb-item active" id="crumbMode">Add</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "Email Policies > Organizational Signatures">
    <cfinclude template="./inc/license_pro_required.cfm">
    <cfabort>
</cfif>

<!--- Flash messages from save_org_signature_action.cfm. The save action
     redirects back here on validation failures (duplicate slot,
     invalid domain, etc.). view_org_signatures.cfm reads the same
     session vars - whichever page renders first consumes the flash. --->
<cfif structKeyExists(session, "org_sig_msg") AND session.org_sig_msg NEQ "">
    <cfset flashMsg = session.org_sig_msg>
    <cfset flashType = session.org_sig_msg_type>
    <cfset session.org_sig_msg = "">
    <cfset session.org_sig_msg_type = "">
<cfelse>
    <cfset flashMsg = "">
    <cfset flashType = "">
</cfif>

<cfparam name="url.id" default="0">
<cfset isEdit = IsNumeric(url.id) AND Val(url.id) GT 0>

<!--- One-shot form-restore. After save_org_signature_action.cfm hits a
     validation failure (e.g. duplicate slot), it stashes the in-flight
     form scope in session and redirects back here. This block consumes
     the stash and uses it to repopulate the form so the admin doesn't
     lose what they just typed. --->
<cfset restoreFromForm = false>
<cfset restoreData = {}>
<cfif structKeyExists(session, "org_sig_form_restore") AND IsStruct(session.org_sig_form_restore) AND structKeyExists(session.org_sig_form_restore, "template_key") AND Len(session.org_sig_form_restore.template_key)>
    <cfset restoreData = session.org_sig_form_restore>
    <cfset restoreFromForm = true>
</cfif>
<cfif structKeyExists(session, "org_sig_form_restore")>
    <cfset session.org_sig_form_restore = {}>
</cfif>

<!--- Pre-load existing row when editing. --->
<cfset existingRow = {}>
<cfset existingFields = {}>
<cfif isEdit>
    <cfquery name="loadRow" datasource="hermes">
        SELECT id, domain_id, department_label, template_key, fields_json,
               enabled
        FROM org_signatures
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif loadRow.recordcount LT 1>
        <cfset session.org_sig_msg = "<strong>Not found.</strong> Organizational Signature ID ##" & url.id & " no longer exists.">
        <cfset session.org_sig_msg_type = "warning">
        <cflocation url="view_org_signatures.cfm" addtoken="no">
    </cfif>
    <cfset existingRow = {
        id:               loadRow.id,
        domain_id:        loadRow.domain_id,
        department_label: loadRow.department_label,
        template_key:     loadRow.template_key,
        enabled:          Val(loadRow.enabled)
    }>
    <cftry>
        <cfset existingFields = DeserializeJSON(loadRow.fields_json)>
        <cfcatch type="any">
            <!--- Defensive: row got corrupted somehow. Treat as empty
                 so admin can re-fill rather than seeing a crash. --->
            <cfset existingFields = {}>
        </cfcatch>
    </cftry>
</cfif>

<!--- Domain dropdown source. Limit to mailbox-hosting domains since
     org signatures only make sense for mailboxes you control. --->
<cfquery name="getDomains" datasource="hermes">
    SELECT id, domain
    FROM domains
    WHERE type = 'mailbox'
    ORDER BY domain ASC
</cfquery>

<!--- Load every available template's metadata so the gallery + form
     generator have it client-side without round-tripping. --->
<cfinclude template="./inc/org_signature_template_loader.cfm" />
<cfset allTemplates = []>
<cfloop array="#variables.orgSignatureTemplateRegistry#" index="tmplKey">
    <cfset tmplPath = variables.orgSignatureTemplateDir & tmplKey & ".cfm">
    <cfif FileExists(tmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/org_signature_templates/#tmplKey#.cfm" />
        <cfif StructKeyExists(template, "key")>
            <cfset thumbPath = variables.orgSignatureTemplateDir & "thumbnails/" & template.thumbnail>
            <cfset template.thumbnailExists = FileExists(thumbPath)>
            <cfset ArrayAppend(allTemplates, template)>
        </cfif>
    </cfif>
</cfloop>

<!--- Apply form-restore on top of (or instead of) DB-loaded values.
     Loops the active template's metadata so we know which fields are
     checkboxes vs strings - mirrors the same logic the save action
     uses to build the fields struct. --->
<cfif restoreFromForm>
    <cfset existingRow = {
        id:               Val(restoreData.id ?: 0),
        domain_id:        Val(restoreData.domain_id ?: 0),
        department_label: restoreData.department_label ?: "",
        template_key:     restoreData.template_key,
        enabled:          ((restoreData.enabled ?: "0") EQ "1") ? 1 : 0
    }>
    <cfset isEdit = (restoreData.mode ?: "add") EQ "edit">
    <!--- Find the matching template's metadata to know field types. --->
    <cfset restoreTmplPath = variables.orgSignatureTemplateDir & restoreData.template_key & ".cfm">
    <cfif FileExists(restoreTmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/org_signature_templates/#restoreData.template_key#.cfm" />
        <cfset existingFields = {}>
        <cfloop array="#template.fields#" index="rf">
            <cfset rk = "field_" & rf.name>
            <cfif rf.type EQ "checkbox">
                <!--- Form scope only contains the checkbox key when
                     it was checked at submit time, so absence = false. --->
                <cfset existingFields[rf.name] = StructKeyExists(restoreData, rk) AND Trim(restoreData[rk]) EQ "1">
            <cfelseif StructKeyExists(restoreData, rk)>
                <cfset existingFields[rf.name] = restoreData[rk]>
            </cfif>
        </cfloop>
    </cfif>
</cfif>

<cfif Len(flashMsg)>
    <div class="alert alert-<cfoutput>#flashType#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput>#flashMsg#</cfoutput>
    </div>
</cfif>

<form id="orgSigForm" method="post" action="inc/save_org_signature_action.cfm" novalidate>
    <input type="hidden" name="mode"         id="form_mode"         value="<cfoutput>#(isEdit ? 'edit' : 'add')#</cfoutput>">
    <input type="hidden" name="id"           id="form_id"           value="<cfoutput>#(isEdit ? existingRow.id : 0)#</cfoutput>">
    <input type="hidden" name="template_key" id="form_template_key" value="<cfoutput>#(isEdit ? HTMLEditFormat(existingRow.template_key) : '')#</cfoutput>">

    <!--- SCOPE CARD: who does this signature apply to? --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-globe me-2"></i>Scope</h3>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Domain <span class="text-danger">*</span></strong></label>
                    <select class="form-select" name="domain_id" id="form_domain_id" required>
                        <option value="">Select a domain...</option>
                        <cfoutput query="getDomains">
                            <option value="#id#" <cfif isEdit AND Val(existingRow.domain_id) EQ Val(id)>selected</cfif>>#HTMLEditFormat(domain)#</option>
                        </cfoutput>
                    </select>
                    <p class="field-help mt-1 mb-0">Mailbox-hosting domain this signature applies to.</p>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label"><strong>Department</strong> <small class="text-muted">(optional)</small></label>
                    <input type="text" class="form-control" name="department_label" id="form_department_label" maxlength="64"
                           placeholder="e.g. Sales, Support, HR"
                           value="<cfoutput>#(isEdit ? HTMLEditFormat(existingRow.department_label) : '')#</cfoutput>">
                    <p class="field-help mt-1 mb-0">Leave blank for the domain default. Non-blank values match <code>mailboxes.department</code> exactly at send time.</p>
                </div>
            </div>

            <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" name="enabled" id="form_enabled" value="1"
                       <cfif (NOT isEdit) OR (isEdit AND Val(existingRow.enabled) EQ 1)>checked</cfif>>
                <label class="form-check-label" for="form_enabled">
                    <strong>Enabled</strong>
                </label>
                <p class="field-help mt-1 mb-0">When off, the body milter ignores this row at send time. Useful for staging changes without breaking mail.</p>
            </div>
        </div>
    </div>

    <!--- TEMPLATE GALLERY CARD: pick one of the bundled designs. --->
    <div class="card card-primary card-outline mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h3 class="card-title m-0"><i class="fas fa-th-large me-2"></i>Template</h3>
            <span class="text-muted small" id="templateSelectedLabel"></span>
        </div>
        <div class="card-body">
            <div class="row g-3" id="templateGallery">
                <cfoutput>
                <cfloop array="#allTemplates#" index="t">
                    <div class="col-md-4 col-lg-3">
                        <div class="card template-card h-100" data-template-key="#HTMLEditFormat(t.key)#">
                            <div class="thumb-wrap">
                                <cfif t.thumbnailExists>
                                    <img src="inc/org_signature_templates/thumbnails/#HTMLEditFormat(t.thumbnail)#" alt="#HTMLEditFormat(t.name)# thumbnail">
                                <cfelse>
                                    <div class="placeholder">
                                        <i class="fas fa-image fa-2x mb-2 d-block"></i>
                                        Thumbnail<br>coming soon
                                    </div>
                                </cfif>
                            </div>
                            <div class="card-body p-2 text-center">
                                <strong class="d-block">#HTMLEditFormat(t.name)#</strong>
                                <small class="text-muted">#HTMLEditFormat(t.description)#</small>
                            </div>
                        </div>
                    </div>
                </cfloop>
                </cfoutput>
            </div>
        </div>
    </div>

    <!--- DYNAMIC FORM CARD: rendered from the active template's fields. --->
    <div class="card card-primary card-outline mb-4" id="dynamicFormCard" style="display:none;">
        <div class="card-header">
            <h3 class="card-title m-0"><i class="fas fa-edit me-2"></i>Content</h3>
        </div>
        <div class="card-body">
            <div id="dynamicFormFields"></div>
        </div>
    </div>

    <!--- PREVIEW CARD: sandboxed iframe. Refresh button forces a re-render. --->
    <div class="card card-primary card-outline mb-4" id="previewCard" style="display:none;">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h3 class="card-title m-0"><i class="fas fa-eye me-2"></i>Preview</h3>
            <button type="button" class="btn btn-sm btn-outline-secondary" id="btnRefreshPreview">
                <i class="fas fa-sync-alt me-1"></i> Refresh
            </button>
        </div>
        <div class="card-body">
            <iframe id="previewFrame" sandbox="allow-same-origin"></iframe>
            <p class="field-help mt-2 mb-0"><i class="fas fa-info-circle me-1"></i> Preview shows the rendered HTML with placeholder text where <code>{{user.*}}</code>, <code>{{org.*}}</code>, and <code>{{dept.*}}</code> will be substituted at send time.</p>
        </div>
    </div>

    <!--- ACTION BAR --->
    <div class="d-flex justify-content-end gap-2 mb-4">
        <a href="view_org_signatures.cfm" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary" id="btnSave" disabled>
            <i class="fas fa-save me-1"></i> Save Signature
        </button>
    </div>
</form>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
// Server-side bootstrap data: every available template's metadata + the
// existing row's stored fields when editing. Used by the form generator
// to render fields and pre-fill values.
//
// Lucee's SerializeJSON uppercases struct keys by default (KEY, NAME,
// FIELDS, etc.), which would silently break every `tmpl.fields.forEach`
// and `field.name` access below. normalizeKeys() walks the parsed
// structure and lowercases keys recursively so JS sees the original
// casing the templates declared.
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
// Set whenever existingRow has a template_key - covers both DB-loaded
// edit mode and form-restore-after-save-failure (where original mode
// could have been Add or Edit). The auto-select / field pre-fill below
// keys off this, not IS_EDIT.
const INITIAL_TEMPLATE_KEY = <cfoutput>"#(structKeyExists(existingRow, 'template_key') ? JSStringFormat(existingRow.template_key) : '')#"</cfoutput>;

// In-memory map of template_key -> field values, so switching templates
// preserves what the admin typed in case they switch back.
const fieldsByTemplate = {};

let activeTemplateKey = '';
let previewDebounceTimer = null;

function findTemplate(key) {
    return TEMPLATES.find(function (t) { return t.key === key; });
}

function selectTemplate(key) {
    if (!key) return;
    const tmpl = findTemplate(key);
    if (!tmpl) return;

    activeTemplateKey = key;
    document.getElementById('form_template_key').value = key;
    document.getElementById('templateSelectedLabel').textContent = 'Selected: ' + tmpl.name;

    document.querySelectorAll('.template-card').forEach(function (card) {
        card.classList.toggle('is-selected', card.dataset.templateKey === key);
    });

    renderFields(tmpl);
    document.getElementById('dynamicFormCard').style.display = '';
    document.getElementById('previewCard').style.display = '';
    document.getElementById('btnSave').disabled = false;

    schedulePreviewRefresh();
}

function renderFields(tmpl) {
    const container = document.getElementById('dynamicFormFields');
    container.innerHTML = '';

    // Resolve initial values: prefer EXISTING_FIELDS (when this template
    // matches the one we landed on - either DB-loaded for edit or
    // restored from a failed-save round-trip), then fieldsByTemplate
    // cache (when admin switched templates and came back), then the
    // field's own default.
    const stored = (tmpl.key === INITIAL_TEMPLATE_KEY) ? EXISTING_FIELDS : (fieldsByTemplate[tmpl.key] || {});

    tmpl.fields.forEach(function (field) {
        const wrap = document.createElement('div');
        wrap.className = 'mb-3 field-row';
        wrap.dataset.fieldName = field.name;
        if (field.showIf) wrap.dataset.showIf = field.showIf;

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
        } else if (field.type === 'color') {
            input = document.createElement('input');
            input.type = 'color';
            input.className = 'form-control form-control-color';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.value = value || '#d97706';
            wrap.appendChild(label);
            wrap.appendChild(input);
        } else if (field.type === 'image') {
            // File input + thumbnail + clear. The hidden input carries
            // the data: URI as the actual form value; the file input is
            // for selection only and is read client-side via FileReader.
            // Stored data: URI passes through to fields_json + rendered_html;
            // Phase 2B body milter will extract data: -> cid: at write time.
            wrap.appendChild(label);

            const previewRow = document.createElement('div');
            previewRow.className = 'd-flex align-items-center gap-2 mb-2';

            const thumb = document.createElement('img');
            thumb.className = 'org-sig-image-thumb';
            thumb.style.maxWidth = '120px';
            thumb.style.maxHeight = '60px';
            thumb.style.border = '1px solid #d1d5db';
            thumb.style.borderRadius = '4px';
            thumb.style.padding = '4px';
            thumb.style.background = '#fff';
            thumb.style.display = value ? 'inline-block' : 'none';
            if (value) thumb.src = value;

            const noneLabel = document.createElement('span');
            noneLabel.className = 'text-muted small org-sig-image-none';
            noneLabel.textContent = 'No image selected';
            noneLabel.style.display = value ? 'none' : 'inline';

            const clearBtn = document.createElement('button');
            clearBtn.type = 'button';
            clearBtn.className = 'btn btn-sm btn-outline-secondary org-sig-image-clear';
            clearBtn.dataset.fieldName = field.name;
            clearBtn.textContent = 'Clear';
            clearBtn.style.display = value ? 'inline-block' : 'none';

            previewRow.appendChild(thumb);
            previewRow.appendChild(noneLabel);
            previewRow.appendChild(clearBtn);
            wrap.appendChild(previewRow);

            const fileInput = document.createElement('input');
            fileInput.type = 'file';
            fileInput.accept = 'image/png,image/jpeg,image/gif,image/svg+xml';
            fileInput.className = 'form-control form-control-sm org-sig-image-file';
            fileInput.dataset.fieldName = field.name;
            wrap.appendChild(fileInput);

            const errMsg = document.createElement('div');
            errMsg.className = 'text-danger small mt-1 org-sig-image-error';
            errMsg.style.display = 'none';
            wrap.appendChild(errMsg);

            // Hidden input is the actual form value and what JS reads.
            input = document.createElement('input');
            input.type = 'hidden';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.value = value || '';
            wrap.appendChild(input);
        } else {
            input = document.createElement('input');
            input.type = (field.type === 'email' ? 'email' : field.type === 'url' ? 'url' : 'text');
            input.className = 'form-control';
            input.id = 'fld_' + field.name;
            input.name = 'field_' + field.name;
            input.value = value || '';
            if (field.placeholder) input.placeholder = field.placeholder;
            wrap.appendChild(label);
            wrap.appendChild(input);

            // Inline validation feedback for url/email fields. Bootstrap
            // shows .invalid-feedback when the sibling input has the
            // .is-invalid class. Submit handler toggles that class.
            if (field.type === 'url' || field.type === 'email') {
                const fb = document.createElement('div');
                fb.className = 'invalid-feedback';
                fb.textContent = field.type === 'url'
                    ? 'Must be a full URL starting with https:// or http://'
                    : 'Must be a valid email address (e.g. name@example.com).';
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
        if (!row.dataset.showIf) return;
        const target = document.querySelector('#fld_' + row.dataset.showIf);
        const visible = target && target.checked;
        row.style.display = visible ? '' : 'none';
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
    previewDebounceTimer = setTimeout(refreshPreview, 350);
}

function refreshPreview() {
    if (!activeTemplateKey) return;
    const formData = new FormData();
    formData.append('template_key', activeTemplateKey);
    const tmpl = findTemplate(activeTemplateKey);
    if (!tmpl) return;
    tmpl.fields.forEach(function (f) {
        const el = document.getElementById('fld_' + f.name);
        if (!el) return;
        if (f.type === 'checkbox') {
            if (el.checked) formData.append('field_' + f.name, '1');
        } else {
            formData.append('field_' + f.name, el.value);
        }
    });

    fetch('inc/render_org_signature_preview.cfm', {
        method: 'POST',
        body: formData
    })
    .then(function (r) { return r.text(); })
    .then(function (html) {
        const iframe = document.getElementById('previewFrame');
        const baseHref = window.location.protocol + '//' + window.location.host + '/';
        iframe.srcdoc =
            '<!DOCTYPE html><html><head><meta charset="utf-8">' +
            '<base href="' + baseHref + '">' +
            '<style>body{font-family:Arial,Helvetica,sans-serif;padding:24px;margin:0;}</style>' +
            '</head><body>' + html + '</body></html>';
        iframe.classList.remove('preview-stale');
    })
    .catch(function () {
        iframe.classList.remove('preview-stale');
    });
}

document.addEventListener('DOMContentLoaded', function () {
    if (IS_EDIT) {
        document.getElementById('pageTitle').textContent = 'Edit Organizational Signature';
        document.getElementById('crumbMode').textContent = 'Edit';
    }

    // Template gallery clicks.
    document.getElementById('templateGallery').addEventListener('click', function (ev) {
        const card = ev.target.closest('.template-card');
        if (!card) return;
        captureCurrentFields();
        selectTemplate(card.dataset.templateKey);
    });

    // Dynamic form input/change -> capture + refresh preview + showIf gating.
    document.getElementById('dynamicFormFields').addEventListener('input', function (ev) {
        applyShowIfGating();
        schedulePreviewRefresh();
    });
    document.getElementById('dynamicFormFields').addEventListener('change', function (ev) {
        applyShowIfGating();
        schedulePreviewRefresh();
    });

    // Manual refresh.
    document.getElementById('btnRefreshPreview').addEventListener('click', refreshPreview);

    // Image-field upload: read selected file as data: URI, stuff into
    // hidden value-holder, show thumbnail, refresh preview. Limited to
    // 1 MB raw per file. Phase 2B body milter extracts data: -> cid:
    // at signature-file write time.
    const IMG_MAX_BYTES = 1 * 1024 * 1024;
    document.addEventListener('change', function (ev) {
        const fileInput = ev.target.closest('.org-sig-image-file');
        if (!fileInput) return;
        const fieldName = fileInput.dataset.fieldName;
        const wrap = fileInput.closest('.field-row');
        const hidden = document.getElementById('fld_' + fieldName);
        const thumb = wrap.querySelector('.org-sig-image-thumb');
        const noneLabel = wrap.querySelector('.org-sig-image-none');
        const clearBtn = wrap.querySelector('.org-sig-image-clear');
        const errMsg = wrap.querySelector('.org-sig-image-error');
        errMsg.style.display = 'none';
        errMsg.textContent = '';

        const file = fileInput.files && fileInput.files[0];
        if (!file) return;

        if (!file.type.startsWith('image/')) {
            errMsg.textContent = 'Selected file is not an image.';
            errMsg.style.display = '';
            fileInput.value = '';
            return;
        }
        if (file.size > IMG_MAX_BYTES) {
            errMsg.textContent = 'File is too large (max 1 MB).';
            errMsg.style.display = '';
            fileInput.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = function () {
            hidden.value = reader.result;
            thumb.src = reader.result;
            thumb.style.display = 'inline-block';
            noneLabel.style.display = 'none';
            clearBtn.style.display = 'inline-block';
            schedulePreviewRefresh();
        };
        reader.readAsDataURL(file);
    });

    // Clear button on image fields: blank the hidden value, hide
    // thumbnail, refresh preview.
    document.addEventListener('click', function (ev) {
        const btn = ev.target.closest('.org-sig-image-clear');
        if (!btn) return;
        const fieldName = btn.dataset.fieldName;
        const wrap = btn.closest('.field-row');
        const hidden = document.getElementById('fld_' + fieldName);
        const thumb = wrap.querySelector('.org-sig-image-thumb');
        const noneLabel = wrap.querySelector('.org-sig-image-none');
        const fileInput = wrap.querySelector('.org-sig-image-file');
        hidden.value = '';
        thumb.removeAttribute('src');
        thumb.style.display = 'none';
        noneLabel.style.display = 'inline';
        btn.style.display = 'none';
        if (fileInput) fileInput.value = '';
        schedulePreviewRefresh();
    });

    // Submit-time validation. Native browser validation is unreliable
    // for type=url (some browsers accept "asdf" silently); this ensures
    // both URL and email fields fail loudly with inline red feedback
    // and a scroll to the first bad input. Empty values are allowed
    // because optional fields stay blank to hide their respective row.
    document.getElementById('orgSigForm').addEventListener('submit', function (ev) {
        let firstBad = null;
        // Clear any previous invalid markers.
        document.querySelectorAll('#dynamicFormFields .is-invalid').forEach(function (el) {
            el.classList.remove('is-invalid');
        });
        document.querySelectorAll('#dynamicFormFields input').forEach(function (el) {
            const v = (el.value || '').trim();
            if (!v) return; // empty is fine for optional fields
            let bad = false;
            if (el.type === 'url') {
                if (!/^https?:\/\/[^\s]+$/i.test(v)) bad = true;
            } else if (el.type === 'email') {
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v)) bad = true;
            }
            if (bad) {
                el.classList.add('is-invalid');
                if (!firstBad) firstBad = el;
            }
        });
        if (firstBad) {
            ev.preventDefault();
            ev.stopPropagation();
            // The framework's preloader (html_head.cfm:436) shows on
            // every form submit, with no hide-on-cancel hook. Since
            // we're cancelling the submission, hide it here so the
            // page doesn't appear to hang.
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
                preloader.style.opacity = '0';
            }
            // Make sure the section is visible (showIf may have hidden
            // the row's parent if a checkbox was unchecked - in that
            // case the validation isn't applicable).
            const row = firstBad.closest('.field-row');
            if (row && row.style.display !== 'none') {
                firstBad.scrollIntoView({behavior: 'smooth', block: 'center'});
                firstBad.focus({preventScroll: true});
            }
        }
    });

    // Strip is-invalid as the user edits a field so the red marker
    // disappears as soon as they fix it (no need to re-submit first).
    document.getElementById('dynamicFormFields').addEventListener('input', function (ev) {
        if (ev.target.classList && ev.target.classList.contains('is-invalid')) {
            ev.target.classList.remove('is-invalid');
        }
    });

    // Auto-select the initial template (set whenever existingRow has a
    // template_key - covers both edit mode AND form-restore-after-failed-save).
    // Otherwise wait for the admin to click a thumbnail.
    if (INITIAL_TEMPLATE_KEY) {
        selectTemplate(INITIAL_TEMPLATE_KEY);
    }
});
</script>

</body>
</html>
