<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Create External Recipient</title>
  <cfinclude template="./inc/html_head.cfm" />
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
            <h1 class="m-0">Create External Recipient</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">External Recipients</a></li>
              <li class="breadcrumb-item active">Create</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m_extcreate") AND session.m_extcreate is not "">
  <cfset m = session.m_extcreate>
  <cfset session.m_extcreate = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ===================== --->
<!--- ACTION: CREATE       --->
<!--- ===================== --->
<cfif action is "create">
  <cfparam name="form.ext_email" default="">
  <cfparam name="form.encryption_mode" default="">
  <cfparam name="form.pdf_mode" default="">
  <cfparam name="form.pdf_password" default="">
  <cfparam name="form.pdf_password2" default="">
  <cfparam name="form.pdf_password_age" default="60">
  <cfparam name="form.pdf_password_length" default="20">

  <cfset ext_email = trim(form.ext_email)>

  <!--- Validate email --->
  <cfif ext_email is "">
    <cfset session.m_extcreate = 1>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsValid("email", ext_email)>
    <cfset session.m_extcreate = 2>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- Check if domain is managed by system (can't encrypt to internal domains) --->
  <cfset emailDomain = ListLast(ext_email, "@")>
  <cfquery name="checkDomain" datasource="hermes">
    SELECT COUNT(*) as cnt FROM domains WHERE domain = <cfqueryparam value="#emailDomain#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDomain.cnt GT 0>
    <cfset session.m_extcreate = 5>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate --->
  <cfquery name="checkExtRec" datasource="hermes">
    SELECT COUNT(*) as cnt FROM external_recipients WHERE email = <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfquery name="checkDjigzo" datasource="djigzo">
    SELECT COUNT(*) as cnt FROM cm_properties WHERE cm_category LIKE <cfqueryparam value="user:#ext_email#%" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkExtRec.cnt GT 0 OR checkDjigzo.cnt GT 0>
    <cfset session.m_extcreate = 3>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- Validate encryption mode --->
  <cfset ext_encryption_mode = trim(form.encryption_mode)>
  <cfif NOT ListFindNoCase("pdf_mandatory,pdf_by_subject,smime_mandatory,smime_by_subject,pgp_mandatory,pgp_by_subject", ext_encryption_mode)>
    <cfset session.m_extcreate = 4>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- PDF-specific validation --->
  <cfset ext_pdf_mode = "">
  <cfset ext_pdf_password = "">
  <cfset ext_pdf_password_age = "60">
  <cfset ext_pdf_password_length = "20">

  <cfif Left(ext_encryption_mode, 3) is "pdf">
    <cfset ext_pdf_mode = trim(form.pdf_mode)>
    <cfif NOT ListFindNoCase("static,random,backtosender", ext_pdf_mode)>
      <cfset session.m_extcreate = 6>
      <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
    </cfif>

    <cfif ext_pdf_mode is "static">
      <cfset ext_pdf_password = form.pdf_password>
      <cfif Len(ext_pdf_password) LT 12>
        <cfset session.m_extcreate = 7>
        <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
      </cfif>
      <cfif ext_pdf_password NEQ form.pdf_password2>
        <cfset session.m_extcreate = 8>
        <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
      </cfif>
    </cfif>

    <cfif ext_pdf_mode is "backtosender">
      <cfset ext_pdf_password_age = trim(form.pdf_password_age)>
      <cfset ext_pdf_password_length = trim(form.pdf_password_length)>
      <cfif NOT IsNumeric(ext_pdf_password_age) OR ext_pdf_password_age LT 15 OR ext_pdf_password_age GT 240>
        <cfset session.m_extcreate = 9>
        <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
      </cfif>
    </cfif>
  </cfif>

  <!--- Create the recipient --->
  <cfset ext_is_edit = false>
  <cftry>
    <cfinclude template="./inc/create_ext_recipient.cfm">
    <cfcatch type="any">
      <cfset session.m_extcreate = 10>
      <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <cfset session.m_extenc = 1>
  <cflocation url="view_ext_rec_encryption.cfm?action=add" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK CREATE   --->
<!--- ===================== --->
<cfif action is "bulk_create">
  <cfparam name="form.ext_emails" default="">
  <cfparam name="form.encryption_mode" default="">
  <cfparam name="form.pdf_mode" default="">
  <cfparam name="form.pdf_password" default="">
  <cfparam name="form.pdf_password2" default="">
  <cfparam name="form.pdf_password_age" default="60">
  <cfparam name="form.pdf_password_length" default="20">

  <!--- Parse email list --->
  <cfset emailLines = ListToArray(Replace(Replace(trim(form.ext_emails), chr(13), chr(10), "ALL"), chr(10) & chr(10), chr(10), "ALL"), chr(10))>
  <cfif ArrayLen(emailLines) LT 1>
    <cfset session.m_extcreate = 1>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- Validate encryption mode (bulk only supports PDF) --->
  <cfset ext_encryption_mode = trim(form.encryption_mode)>
  <cfif NOT ListFindNoCase("pdf_mandatory,pdf_by_subject", ext_encryption_mode)>
    <cfset session.m_extcreate = 4>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>

  <!--- PDF password validation --->
  <cfset ext_pdf_mode = trim(form.pdf_mode)>
  <cfset ext_pdf_password = "">
  <cfset ext_pdf_password_age = "60">
  <cfset ext_pdf_password_length = "20">

  <cfif NOT ListFindNoCase("static,random,backtosender", ext_pdf_mode)>
    <cfset session.m_extcreate = 6>
    <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
  </cfif>
  <cfif ext_pdf_mode is "static">
    <cfset ext_pdf_password = form.pdf_password>
    <cfif Len(ext_pdf_password) LT 12>
      <cfset session.m_extcreate = 7>
      <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
    </cfif>
    <cfif ext_pdf_password NEQ form.pdf_password2>
      <cfset session.m_extcreate = 8>
      <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
    </cfif>
  </cfif>
  <cfif ext_pdf_mode is "backtosender">
    <cfset ext_pdf_password_age = trim(form.pdf_password_age)>
    <cfset ext_pdf_password_length = trim(form.pdf_password_length)>
    <cfif NOT IsNumeric(ext_pdf_password_age) OR ext_pdf_password_age LT 15 OR ext_pdf_password_age GT 240>
      <cfset session.m_extcreate = 9>
      <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Process each email --->
  <cfset created_count = 0>
  <cfset skipped_list = "">
  <cfset failed_list = "">
  <cfset ext_is_edit = false>

  <cfloop array="#emailLines#" index="emailLine">
    <cfset ext_email = trim(emailLine)>
    <cfif ext_email is ""><cfcontinue></cfif>

    <!--- Validate email format --->
    <cfif NOT IsValid("email", ext_email)>
      <cfset skipped_list = ListAppend(skipped_list, ext_email & " (invalid format)")>
      <cfcontinue>
    </cfif>

    <!--- Check internal domain --->
    <cfset emailDomain = ListLast(ext_email, "@")>
    <cfquery name="checkDomain" datasource="hermes">
      SELECT COUNT(*) as cnt FROM domains WHERE domain = <cfqueryparam value="#emailDomain#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkDomain.cnt GT 0>
      <cfset skipped_list = ListAppend(skipped_list, ext_email & " (internal domain)")>
      <cfcontinue>
    </cfif>

    <!--- Check duplicate --->
    <cfquery name="checkExtRec" datasource="hermes">
      SELECT COUNT(*) as cnt FROM external_recipients WHERE email = <cfqueryparam value="#ext_email#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkExtRec.cnt GT 0>
      <cfset skipped_list = ListAppend(skipped_list, ext_email & " (already exists)")>
      <cfcontinue>
    </cfif>

    <!--- Create recipient --->
    <cftry>
      <cfinclude template="./inc/create_ext_recipient.cfm">
      <cfset created_count = created_count + 1>
      <cfcatch type="any">
        <cfset failed_list = ListAppend(failed_list, ext_email)>
      </cfcatch>
    </cftry>
  </cfloop>

  <!--- Store results in session for display --->
  <cfset session.bulk_created = created_count>
  <cfset session.bulk_skipped = skipped_list>
  <cfset session.bulk_failed = failed_list>
  <cfset session.m_extcreate = 11>
  <cflocation url="view_create_ext_recipient.cfm" addtoken="no">
</cfif>

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Email address cannot be empty.</p></div>
</cfif>
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Invalid email address format.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate</h4><p>An external recipient with that email address already exists.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select an encryption mode.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Cannot create an external recipient for a domain managed by this system.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a PDF password mode.</p></div>
</cfif>
<cfif m is 7>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>PDF password must be at least 12 characters.</p></div>
</cfif>
<cfif m is 8>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>PDF passwords do not match.</p></div>
</cfif>
<cfif m is 9>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Password age must be between 15 and 240 minutes.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>An error occurred while creating the external recipient. Please check the logs.</p></div>
</cfif>
<cfif m is 11>
  <cfparam name="session.bulk_created" default="0">
  <cfparam name="session.bulk_skipped" default="">
  <cfparam name="session.bulk_failed" default="">
  <cfoutput>
  <cfif session.bulk_created GT 0 AND session.bulk_skipped is "" AND session.bulk_failed is "">
    <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-check"></i> Success</h4>
      <p>Created <strong>#session.bulk_created#</strong> external recipient(s).</p></div>
  <cfelseif session.bulk_created GT 0>
    <div class="alert alert-warning alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Partial Success</h4>
      <p>Created <strong>#session.bulk_created#</strong> recipient(s).</p>
      <cfif session.bulk_skipped is not "">
        <p class="mb-1"><strong>Skipped:</strong></p>
        <ul class="mb-1"><cfloop list="#session.bulk_skipped#" index="s"><li>#encodeForHTML(s)#</li></cfloop></ul>
      </cfif>
      <cfif session.bulk_failed is not "">
        <p class="mb-1"><strong>Failed:</strong></p>
        <ul class="mb-0"><cfloop list="#session.bulk_failed#" index="f"><li>#encodeForHTML(f)#</li></cfloop></ul>
      </cfif>
    </div>
  <cfelse>
    <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Error</h4>
      <p>No recipients were created.</p>
      <cfif session.bulk_skipped is not "">
        <p class="mb-1"><strong>Skipped:</strong></p>
        <ul class="mb-1"><cfloop list="#session.bulk_skipped#" index="s"><li>#encodeForHTML(s)#</li></cfloop></ul>
      </cfif>
      <cfif session.bulk_failed is not "">
        <p class="mb-1"><strong>Failed:</strong></p>
        <ul class="mb-0"><cfloop list="#session.bulk_failed#" index="f"><li>#encodeForHTML(f)#</li></cfloop></ul>
      </cfif>
    </div>
  </cfif>
  </cfoutput>
  <cfset session.bulk_created = "">
  <cfset session.bulk_skipped = "">
  <cfset session.bulk_failed = "">
</cfif>

<!--- CREATE FORM --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-user-plus"></i> Create External Recipient</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off" id="createForm">
      <input type="hidden" name="action" value="create" id="formAction">

      <!--- Mode Toggle --->
      <div class="mb-3">
        <div class="btn-group" role="group">
          <input type="radio" class="btn-check" name="create_mode" id="modeSingle" value="single" checked>
          <label class="btn btn-outline-primary" for="modeSingle"><i class="fas fa-user"></i> Single</label>
          <input type="radio" class="btn-check" name="create_mode" id="modeBulk" value="bulk">
          <label class="btn btn-outline-primary" for="modeBulk"><i class="fas fa-users"></i> Bulk</label>
        </div>
      </div>

      <!--- Single Email --->
      <div id="singleEmailField" class="row mb-3">
        <div class="col-md-6">
          <label for="ext_email" class="form-label">Recipient Email Address</label>
          <input type="email" class="form-control" id="ext_email" name="ext_email" maxlength="255"
            placeholder="user@external-domain.com">
          <small class="text-muted">Must be an external email address (not a domain managed by this system)</small>
        </div>
      </div>

      <!--- Bulk Emails --->
      <div id="bulkEmailField" class="row mb-3" style="display:none;">
        <div class="col-md-6">
          <label for="ext_emails" class="form-label">Recipient Email Addresses</label>
          <textarea class="form-control" id="ext_emails" name="ext_emails" rows="8"
            placeholder="user1@external-domain.com&#10;user2@another-domain.com&#10;user3@example.com"></textarea>
          <small class="text-muted">One email address per line. Invalid, duplicate, and internal domain addresses will be skipped.</small>
        </div>
      </div>

      <!--- Encryption Mode --->
      <h6 class="mb-3"><strong>Encryption Mode</strong></h6>
      <p class="text-muted mb-2"><strong>Mandatory</strong> encrypts all messages to this recipient. <strong>By Subject</strong> only encrypts when the subject trigger keyword is present.</p>

      <div class="row mb-3">
        <div class="col-md-4">
          <div class="card">
            <div class="card-header bg-warning text-dark"><strong><i class="fas fa-file-pdf"></i> PDF Encryption</strong></div>
            <div class="card-body">
              <div class="form-check mb-2">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="pdf_mandatory" id="enc_pdf_m">
                <label class="form-check-label" for="enc_pdf_m">Mandatory</label>
              </div>
              <div class="form-check">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="pdf_by_subject" id="enc_pdf_s">
                <label class="form-check-label" for="enc_pdf_s">By Subject</label>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4 single-only-enc">
          <div class="card">
            <div class="card-header bg-success text-white"><strong><i class="fas fa-certificate"></i> S/MIME Encryption</strong></div>
            <div class="card-body">
              <div class="form-check mb-2">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="smime_mandatory" id="enc_smime_m">
                <label class="form-check-label" for="enc_smime_m">Mandatory</label>
              </div>
              <div class="form-check">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="smime_by_subject" id="enc_smime_s">
                <label class="form-check-label" for="enc_smime_s">By Subject</label>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4 single-only-enc">
          <div class="card">
            <div class="card-header bg-info text-white"><strong><i class="fas fa-key"></i> PGP Encryption</strong></div>
            <div class="card-body">
              <div class="form-check mb-2">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="pgp_mandatory" id="enc_pgp_m">
                <label class="form-check-label" for="enc_pgp_m">Mandatory</label>
              </div>
              <div class="form-check">
                <input class="form-check-input enc-mode-radio" type="radio" name="encryption_mode" value="pgp_by_subject" id="enc_pgp_s">
                <label class="form-check-label" for="enc_pgp_s">By Subject</label>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!--- PDF Options (shown only when PDF mode selected) --->
      <div id="pdfOptions" style="display:none;">
        <hr>
        <h6 class="mb-3"><strong>PDF Password Settings</strong></h6>
        <p class="text-muted mb-2">Choose how the PDF encryption password is handled for this recipient.</p>

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="form-check mb-2">
              <input class="form-check-input pdf-mode-radio" type="radio" name="pdf_mode" value="random" id="pdf_random" checked>
              <label class="form-check-label" for="pdf_random"><strong>Random Password</strong></label>
              <small class="d-block text-muted">One-time password sent to recipient via portal</small>
            </div>
          </div>
          <div class="col-md-4">
            <div class="form-check mb-2">
              <input class="form-check-input pdf-mode-radio" type="radio" name="pdf_mode" value="static" id="pdf_static">
              <label class="form-check-label" for="pdf_static"><strong>Static Password</strong></label>
              <small class="d-block text-muted">Fixed password you set below</small>
            </div>
          </div>
          <div class="col-md-4">
            <div class="form-check mb-2">
              <input class="form-check-input pdf-mode-radio" type="radio" name="pdf_mode" value="backtosender" id="pdf_bts">
              <label class="form-check-label" for="pdf_bts"><strong>Back to Sender</strong></label>
              <small class="d-block text-muted">Password sent back to the original sender</small>
            </div>
          </div>
        </div>

        <!--- Static password fields --->
        <div id="staticPasswordFields" style="display:none;">
          <div class="row mb-3">
            <div class="col-md-4">
              <label for="pdf_password" class="form-label">PDF Password</label>
              <input type="password" class="form-control" id="pdf_password" name="pdf_password" maxlength="255"
                placeholder="Minimum 12 characters">
              <small class="text-muted">Min 8 chars with uppercase, lowercase, numbers, and special characters</small>
            </div>
            <div class="col-md-4">
              <label for="pdf_password2" class="form-label">Confirm Password</label>
              <input type="password" class="form-control" id="pdf_password2" name="pdf_password2" maxlength="255">
            </div>
          </div>
        </div>

        <!--- Back to sender fields --->
        <div id="btsFields" style="display:none;">
          <div class="row mb-3">
            <div class="col-md-3">
              <label for="pdf_password_age" class="form-label">Password Age (minutes)</label>
              <input type="number" class="form-control" id="pdf_password_age" name="pdf_password_age" min="15" max="240" value="60">
              <small class="text-muted">15-240 minutes</small>
            </div>
            <div class="col-md-3">
              <label class="form-label">Password Length</label>
              <select class="form-select" name="pdf_password_length">
                <option value="20" selected>20-bit (Recommended)</option>
                <option value="16">16-bit</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <hr>

      <div class="row">
        <div class="col-12">
          <a href="view_ext_rec_encryption.cfm" class="btn btn-secondary me-2">
            <i class="fas fa-arrow-left"></i> Back
          </a>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating...';this.form.submit();">
            <i class="fas fa-plus"></i> Create Recipient
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


<script>
$(document).ready(function() {
  // Mode toggle: Single vs Bulk
  $('input[name="create_mode"]').on('change', function() {
    if (this.value === 'bulk') {
      $('#singleEmailField').hide();
      $('#bulkEmailField').show();
      $('#formAction').val('bulk_create');
      $('#ext_email').removeAttr('required');
      // Hide S/MIME and PGP options, auto-select PDF Mandatory
      $('.single-only-enc').hide();
      // Uncheck any S/MIME or PGP selection
      $('input[name="encryption_mode"]').filter('[value^="smime_"],[value^="pgp_"]').prop('checked', false);
      // Auto-select PDF Mandatory if nothing selected
      if (!$('input[name="encryption_mode"]:checked').length) {
        $('#enc_pdf_m').prop('checked', true).trigger('change');
      }
    } else {
      $('#singleEmailField').show();
      $('#bulkEmailField').hide();
      $('#formAction').val('create');
      $('.single-only-enc').show();
    }
  });

  // Show/hide PDF options based on encryption mode
  $('.enc-mode-radio').on('change', function() {
    if (this.value.startsWith('pdf_')) {
      $('#pdfOptions').slideDown();
    } else {
      $('#pdfOptions').slideUp();
    }
  });

  // Show/hide PDF sub-options based on PDF mode
  $('.pdf-mode-radio').on('change', function() {
    if (this.value === 'static') {
      $('#staticPasswordFields').slideDown();
      $('#btsFields').slideUp();
    } else if (this.value === 'backtosender') {
      $('#staticPasswordFields').slideUp();
      $('#btsFields').slideDown();
    } else {
      $('#staticPasswordFields').slideUp();
      $('#btsFields').slideUp();
    }
  });
});
</script>

</body>
</html>
