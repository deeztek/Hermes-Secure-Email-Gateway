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
PERSONAL SIGNATURE EDITOR (#226)

Tier-neutral - works for both Community and Pro users. Pro adds
{{user.*}}/{{org.*}} placeholder substitution at milter render time;
Community simply renders whatever the user typed.

Page is gated on the user's domain.allow_user_signatures flag - if the
admin disabled user-managed signatures for the domain, the link is
hidden in the sidebar AND a direct URL hit lands on the locked-out
screen below.

Save flow:
  POST -> inc/save_signature_action.cfm
       -> validates image limits (mirrors #230 disclaimer pipeline)
       -> UPSERTs into user_signatures (uniq_username key)
       -> inc/signature_write_and_reload.cfm regenerates per-user
          files under /etc/hermes/body_milter/signatures/<sanitized_user>/
       -> body_milter mtime-watches and picks up on the next message
--->

<cfif NOT StructKeyExists(session, "email") OR session.email EQ "">
    <cflocation url="/admin/2/logout.cfm" addtoken="no">
</cfif>

<!--- Look up the user's domain settings --->
<cfquery name="getDomain" datasource="hermes">
    SELECT d.id AS domain_id, d.domain, d.allow_user_signatures
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id
    WHERE m.username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset signaturesAllowed = (getDomain.recordcount GTE 1 AND Val(getDomain.allow_user_signatures) EQ 1)>

<!--- Pull existing signature row (may be empty) --->
<cfquery name="getSignature" datasource="hermes">
    SELECT enabled, body_text, body_html
    FROM user_signatures
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getSignature.recordcount GTE 1>
    <cfset existingEnabled = Val(getSignature.enabled)>
    <cfset existingBodyText = getSignature.body_text>
    <cfset existingBodyHtml = getSignature.body_html>
<cfelse>
    <cfset existingEnabled = 1>
    <cfset existingBodyText = "">
    <cfset existingBodyHtml = "">
</cfif>

<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Personal Signature</title>
<cfinclude template="./inc/html_head.cfm" />

<!--- Quill 2.x WYSIWYG editor (same CDN/version as edit_disclaimer.cfm) --->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.min.js"></script>

<style>
    .ql-container { min-height: 220px; background: ##fff; }
    .ql-toolbar   { background: ##f8f9fa; }
    /* Visual cue: clicked image gets a thick blue ring + glow + a
       checkmark badge so it's unambiguously highlighted. Quill's own
       click handling can be subtle, so we make the selection state
       very obvious. Drives which image the width-picker buttons
       resize. */
    .ql-editor img.quill-image-selected {
        outline: 3px solid ##0d6efd;
        outline-offset: 3px;
        box-shadow: 0 0 0 1px ##fff, 0 4px 16px rgba(13,110,253,0.45);
    }
</style>

<cfif signaturesAllowed>
<script>
$(document).ready(function() {
    var quill = new Quill('#quill_editor', {
        theme: 'snow',
        placeholder: 'Type your signature here...',
        modules: {
            toolbar: [
                [{ 'header': [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                [{ 'align': [] }],
                ['blockquote', 'link', 'image'],
                ['clean']
            ]
        }
    });
    var existingHtml = $('#body_html').val();
    if (existingHtml) { quill.root.innerHTML = existingHtml; }

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

    // Image width picker. Quill 2.x has no native resize handles; this
    // is the lightweight alternative (Outlook-style "click image, pick
    // a size"). Bind on both 'click' and 'mousedown' (capture phase)
    // so we catch the image hit before any internal Quill handling
    // re-renders the DOM. Use closest('img') so a click on a child
    // element of the image still resolves correctly.
    var lastClickedImage = null;
    function clearImageSelection() {
        quill.root.querySelectorAll('img.quill-image-selected')
            .forEach(function(img) { img.classList.remove('quill-image-selected'); });
        lastClickedImage = null;
        updateSelectionStatus();
    }
    function updateSelectionStatus() {
        var $s = $('#imageSelectionStatus');
        if (!$s.length) return;
        if (lastClickedImage) {
            var cur = lastClickedImage.style.width || 'auto';
            $s.removeClass('text-muted').addClass('text-primary fw-semibold')
              .html('<i class="fas fa-check-circle me-1"></i>Image selected (current width: ' + cur + ')');
        } else {
            $s.removeClass('text-primary fw-semibold').addClass('text-muted')
              .html('<i class="fas fa-info-circle me-1"></i>No image selected &mdash; click an image in the editor first');
        }
    }
    function selectImage(img) {
        clearImageSelection();
        img.classList.add('quill-image-selected');
        lastClickedImage = img;
        updateSelectionStatus();
    }
    function imageFromEvent(e) {
        var t = e.target;
        if (!t) return null;
        if (t.tagName === 'IMG') return t;
        return (t.closest && t.closest('img')) || null;
    }
    function editorClickHandler(e) {
        var img = imageFromEvent(e);
        if (img && quill.root.contains(img)) {
            selectImage(img);
        } else if (quill.root.contains(e.target)) {
            clearImageSelection();
        }
    }
    quill.root.addEventListener('mousedown', editorClickHandler, true);
    quill.root.addEventListener('click',     editorClickHandler, true);
    updateSelectionStatus();

    function applyWidth(w) {
        if (!lastClickedImage) {
            alert('Click on an image in the editor first to resize it.');
            return;
        }
        if (w === 'auto' || w === '') {
            lastClickedImage.style.width = '';
            lastClickedImage.style.height = '';
        } else {
            lastClickedImage.style.width = w;
            lastClickedImage.style.height = 'auto';
        }
        updateSelectionStatus();
    }
    $('.quill-image-width').on('click', function() {
        applyWidth($(this).data('width'));
    });
    $('#customImageWidthBtn').on('click', function() {
        if (!lastClickedImage) {
            alert('Click on an image in the editor first to resize it.');
            return;
        }
        var v = parseInt($('#customImageWidth').val(), 10);
        if (isNaN(v) || v < 10 || v > 2000) {
            alert('Enter a width between 10 and 2000 pixels.');
            return;
        }
        applyWidth(v + 'px');
    });
    $('#customImageWidth').on('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            $('#customImageWidthBtn').click();
        }
    });

    // Preview: render the current signature inline below a fake message
    // body so the user sees the final composed look (signature is ~10%
    // smaller and grey-toned, mirroring the disclaimer preview pattern).
    $('#previewBtn').on('click', function() {
        var html  = quill.root.innerHTML;
        var empty = quillIsEmpty();
        var sigHtml = empty ? '' : html;
        var sample = '<p>Hi,</p><p>Thanks for getting back to me. I will follow up with the details shortly.</p>';
        var combined;
        if (sigHtml.trim().length > 0) {
            combined = sample + '<div style="margin-top:1em;padding-top:0.5em;border-top:1px solid ##ccc;font-size:0.9em;color:##555;">' + sigHtml + '</div>';
        } else {
            combined = sample + '<em class="text-muted">(signature is empty)</em>';
        }
        $('#previewPanelBody').html(combined);
        $('#previewPanel').show();
    });
    $('#previewCloseBtn').on('click', function() { $('#previewPanel').hide(); });

    $('form[name="save_signature"]').on('submit', function() {
        // Strip selection-cue class from images before saving so it
        // doesn't leak into outbound mail or the on-disk html.
        clearImageSelection();
        var html  = quill.root.innerHTML;
        var empty = quillIsEmpty();
        $('#body_html').val(empty ? '' : html);
        $('#body_text').val(empty ? '' : htmlToText(html));
    });
});
</script>
</cfif>
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
            <h1 class="m-0">Personal Signature</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Personal Signature</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfif NOT session.theGroups CONTAINS "mailboxes">
  <div class="alert alert-warning">
    <h4><i class="icon fas fa-exclamation-triangle"></i> Not Available</h4>
    <p class="mb-0">Personal signatures are only available for mailbox users.</p>
  </div>
<cfelse>

<!--- 2FA enforce-mfa restriction gate (#225 Phase 1.5) --->
<cfinclude template="./inc/check_enforce_mfa_restriction.cfm">
<cfif enforceMfaRestricted>
  <cfinclude template="./inc/restricted_access_panel.cfm">
<cfelseif NOT signaturesAllowed>

  <!--- Locked-out screen: domain admin disabled user-managed signatures --->
  <div class="alert alert-secondary">
    <h4><i class="icon fas fa-lock"></i> Personal Signatures Disabled</h4>
    <p class="mb-0">
      Your administrator has disabled user-managed signatures for your domain.
      If your organization uses signatures, they are applied automatically by the
      mail server based on your administrator's policy.
    </p>
  </div>

<cfelse>

<!--- Status messages --->
<cfif StructKeyExists(session, "signature_msg") AND session.signature_msg NEQ "">
  <div class="alert alert-<cfoutput>#session.signature_msg_type#</cfoutput>">
    <cfoutput>#session.signature_msg#</cfoutput>
  </div>
  <cfset session.signature_msg = "">
  <cfset session.signature_msg_type = "">
</cfif>

<form method="post" action="inc/save_signature_action.cfm" name="save_signature">

  <div class="card card-primary card-outline">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-signature me-1"></i> Personal Signature</h3>
    </div>
    <div class="card-body">

      <p class="text-muted">
        This signature is automatically appended to the messages you send. It applies on top of
        any organizational signature your administrator has configured. Disable the toggle below if
        you want to use only the organizational signature.
      </p>

      <div class="form-check form-switch mb-3">
        <input class="form-check-input" type="checkbox" name="enabled" id="enabled" value="1"
               <cfif existingEnabled EQ 1>checked</cfif>>
        <label class="form-check-label" for="enabled">
          <strong>Append my personal signature to outbound messages</strong>
        </label>
      </div>

      <label class="form-label"><strong>Signature</strong></label>
      <div id="quill_editor"></div>

      <!--- Image width picker. Click an image in the editor to select
           it (a blue ring + glow appears), then pick a preset width or
           type a custom value. Stored as inline style="width:..." on
           the img tag and preserved through the cid: rewrite at save
           time. --->
      <div class="mt-2 mb-2">
        <small class="d-block mb-1 text-muted" id="imageSelectionStatus">
          <i class="fas fa-info-circle me-1"></i>No image selected &mdash; click an image in the editor first
        </small>
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <small class="text-muted me-1"><i class="fas fa-image me-1"></i> Width:</small>
          <button type="button" class="btn btn-sm btn-outline-secondary quill-image-width" data-width="100px">100 px</button>
          <button type="button" class="btn btn-sm btn-outline-secondary quill-image-width" data-width="150px">150 px</button>
          <button type="button" class="btn btn-sm btn-outline-secondary quill-image-width" data-width="200px">200 px</button>
          <button type="button" class="btn btn-sm btn-outline-secondary quill-image-width" data-width="300px">300 px</button>
          <div class="input-group input-group-sm" style="width:170px;">
            <input type="number" class="form-control" id="customImageWidth" min="10" max="2000" placeholder="Custom" aria-label="Custom width in pixels">
            <span class="input-group-text">px</span>
            <button type="button" class="btn btn-outline-secondary" id="customImageWidthBtn">Apply</button>
          </div>
          <button type="button" class="btn btn-sm btn-outline-secondary quill-image-width" data-width="auto">Reset</button>
        </div>
      </div>

      <!--- Hidden textareas - Quill writes to these on submit --->
      <textarea id="body_html" name="body_html" style="display:none;"><cfoutput>#existingBodyHtml#</cfoutput></textarea>
      <textarea id="body_text" name="body_text" style="display:none;"><cfoutput>#existingBodyText#</cfoutput></textarea>

      <p class="form-text text-muted mt-2">
        <i class="fas fa-image me-1"></i><strong>Inline images:</strong>
        paste or upload PNG, JPEG, or GIF images directly into the editor. They are embedded
        inline in outbound mail. Limits: <strong>5 images max</strong>, <strong>200 KB per image</strong>,
        <strong>1 MB total</strong>. SVG and WebP are not supported.
      </p>

    </div>
    <div class="card-footer text-end">
      <button type="button" class="btn btn-secondary me-2" id="previewBtn"><i class="fas fa-eye me-1"></i> Preview</button>
      <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i> Save Signature</button>
    </div>
  </div>

  <!--- Preview panel (toggled by the Preview button). Renders the
       current signature inline below a sample message body so the user
       sees the final composed look without sending a real message. --->
  <div id="previewPanel" class="card mt-3" style="display:none;">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h5 class="card-title mb-0"><i class="fas fa-eye me-1"></i> Preview</h5>
      <button type="button" class="btn-close" id="previewCloseBtn" aria-label="Close"></button>
    </div>
    <div class="card-body">
      <p class="text-muted small">This is how your signature appears at the bottom of an outbound message.</p>
      <div id="previewPanelBody" class="border rounded p-3 bg-light"></div>
    </div>
  </div>

</form>

</cfif>
</cfif>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
