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
  <title>Hermes SEG | External Recipient Encryption</title>
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
            <h1 class="m-0">External Recipient Encryption</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">External Recipients</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_extenc") AND session.m_extenc is not "">
  <cfset m = session.m_extenc>
  <cfset session.m_extenc = "">
</cfif>
<cfif StructKeyExists(url, "action") AND url.action is not "">
  <cfset urlAction = url.action>
<cfelse>
  <cfset urlAction = "">
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION: RESET PDF PASSWORD --->
<cfif action is "reset_pdf_password">
  <cfparam name="form.pdf_email" default="">
  <cfparam name="form.pdf_password1" default="">
  <cfparam name="form.pdf_password2" default="">
  <cfset pdf_email = trim(form.pdf_email)>
  <cfset pdf_pass1 = form.pdf_password1>
  <cfset pdf_pass2 = form.pdf_password2>

  <!--- Validate --->
  <cfif pdf_email is "" OR pdf_pass1 is "">
    <cfset session.m_extenc = 30>
  <cfelseif Len(pdf_pass1) LT 12>
    <cfset session.m_extenc = 31>
  <cfelseif pdf_pass1 NEQ pdf_pass2>
    <cfset session.m_extenc = 33>
  <cfelse>
    <cftry>
      <cfinclude template="./inc/reset_pdf_password.cfm">
      <cfset session.m_extenc = 34>
      <cfcatch type="any">
        <cfset session.m_extenc = 35>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_ext_rec_encryption.cfm" addtoken="no">
</cfif>

<!--- ACTION: RESET PORTAL PASSWORD --->
<cfif action is "reset_portal_password">
  <cfparam name="form.portal_email" default="">
  <cfparam name="form.portal_password1" default="">
  <cfparam name="form.portal_password2" default="">
  <cfset portal_email = trim(form.portal_email)>
  <cfset portal_pass1 = form.portal_password1>
  <cfset portal_pass2 = form.portal_password2>

  <!--- Validate (Ciphermail does not enforce complexity for admin-set portal passwords) --->
  <cfif portal_email is "" OR portal_pass1 is "">
    <cfset session.m_extenc = 40>
  <cfelseif Len(portal_pass1) LT 12>
    <cfset session.m_extenc = 41>
  <cfelseif portal_pass1 NEQ portal_pass2>
    <cfset session.m_extenc = 43>
  <cfelse>
    <cftry>
      <cfinclude template="./inc/reset_portal_password.cfm">
      <cfset session.m_extenc = 44>
      <cfcatch type="any">
        <cfset session.m_extenc = 45>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_ext_rec_encryption.cfm" addtoken="no">
</cfif>

<!--- ACTION: DELETE RECIPIENT --->
<cfif action is "delete_recipient">
  <cfif StructKeyExists(form, "delete_email") AND form.delete_email is not "">
    <cfset delete_email = trim(form.delete_email)>
    <cftry>
      <cfinclude template="./inc/delete_ext_recipient.cfm">
      <cfset session.m_extenc = 3>
      <cfcatch type="any">
        <cfset session.m_extenc = 20>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_ext_rec_encryption.cfm" addtoken="no">
</cfif>

<!--- ============================== --->
<!--- DATA QUERIES (batch, no N+1)   --->
<!--- ============================== --->

<!--- All Ciphermail users --->
<cfquery name="getextrecipients" datasource="djigzo">
  SELECT cm_email FROM cm_users ORDER BY cm_email ASC
</cfquery>

<!--- Admin-configured recipients from hermes DB --->
<cfquery name="getAdminRecipients" datasource="hermes">
  SELECT email, encryption_mode, pdf, smime, pgp, pdf_mode FROM external_recipients
</cfquery>

<!--- Build lookup struct for admin recipients --->
<cfset adminLookup = StructNew()>
<cfloop query="getAdminRecipients">
  <cfset adminLookup[getAdminRecipients.email] = {
    encryption_mode = getAdminRecipients.encryption_mode,
    pdf = getAdminRecipients.pdf,
    smime = getAdminRecipients.smime,
    pgp = getAdminRecipients.pgp,
    pdf_mode = getAdminRecipients.pdf_mode
  }>
</cfloop>

<!--- Batch S/MIME certificate counts + earliest expiration --->
<cfquery name="getSmimeCounts" datasource="djigzo">
  SELECT ce.cm_email, COUNT(*) as cnt, MIN(c.cm_not_after) as earliest_expiry
  FROM cm_certificates_email ce
  INNER JOIN cm_certificates c ON ce.cm_certificates_id = c.cm_id
  GROUP BY ce.cm_email
</cfquery>
<cfset smimeLookup = StructNew()>
<cfloop query="getSmimeCounts">
  <cfset smimeLookup[getSmimeCounts.cm_email] = {
    cnt = getSmimeCounts.cnt,
    expires = getSmimeCounts.earliest_expiry
  }>
</cfloop>

<!--- Batch PGP keyring counts --->
<cfquery name="getPgpCounts" datasource="djigzo">
  SELECT cm_email, COUNT(*) as cnt FROM cm_keyring_email GROUP BY cm_email
</cfquery>
<cfset pgpLookup = StructNew()>
<cfloop query="getPgpCounts">
  <cfset pgpLookup[getPgpCounts.cm_email] = getPgpCounts.cnt>
</cfloop>

<!--- ALERTS --->
<cfif urlAction is "add">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient created successfully.</p></div>
</cfif>
<cfif urlAction is "edit">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient encryption options updated.</p></div>
</cfif>
<cfif urlAction is "deletedcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate deleted.</p></div>
</cfif>
<cfif urlAction is "addedcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate created.</p></div>
</cfif>
<cfif urlAction is "sentcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate sent.</p></div>
</cfif>
<cfif urlAction is "portalpassword">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient portal password reset.</p></div>
</cfif>
<cfif urlAction is "pdfpassword">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient PDF password reset.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient deleted.</p>
    <p class="text-warning"><i class="fas fa-exclamation-triangle"></i> If you had a Sender Checks Bypass mapping for this recipient, you must re-create it under the Sender Checks Bypass section.</p></div>
</cfif>
<cfif m is 20>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to delete external recipient.</p></div>
</cfif>

<!--- PDF Password Reset Alerts --->
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Email and password are required.</p></div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Password must be at least 12 characters.</p></div>
</cfif>
<cfif m is 33>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Passwords do not match.</p></div>
</cfif>
<cfif m is 34>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PDF password reset successfully.</p></div>
</cfif>
<cfif m is 35>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to reset PDF password.</p></div>
</cfif>

<!--- Portal Password Reset Alerts --->
<cfif m is 40>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Email and password are required.</p></div>
</cfif>
<cfif m is 41>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Portal password must be at least 12 characters.</p></div>
</cfif>
<cfif m is 43>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Passwords do not match.</p></div>
</cfif>
<cfif m is 44>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Portal password reset successfully.</p></div>
</cfif>
<cfif m is 45>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to reset portal password.</p></div>
</cfif>

<!--- PAGE GUIDE --->
<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">Manage encryption settings for external recipients. <strong>Admin-Configured</strong> recipients are explicitly created by administrators with specific encryption settings, while <strong>Auto-Discovered</strong> recipients are automatically created by Ciphermail during email processing and use global defaults.</p>
  <p class="mb-0">Each recipient can be configured with S/MIME certificates, PGP keyrings, PDF encryption passwords, and portal access credentials. Use the action buttons to manage encryption options for each recipient.</p>
</div>

<!--- MAIN CARD --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-users"></i> External Recipients</h3>
  </div>
  <div class="card-body">

    <!--- TOOLBAR --->
    <div class="row mb-3 align-items-end">
      <div class="col-auto">
        <a href="view_create_ext_recipient.cfm" class="btn btn-primary">
          <i class="fas fa-plus-circle"></i> Create External Recipient
        </a>
      </div>
      <div class="col-auto">
        <label for="filterSource" class="form-label mb-1"><small>Source</small></label>
        <select id="filterSource" class="form-select form-select-sm" style="width: 180px;">
          <option value="">All Recipients</option>
          <option value="admin" selected>Admin-Configured</option>
          <option value="auto">Auto-Discovered</option>
        </select>
      </div>
      <div class="col-auto">
        <label for="filterEncryption" class="form-label mb-1"><small>Encryption</small></label>
        <select id="filterEncryption" class="form-select form-select-sm" style="width: 160px;">
          <option value="">All Types</option>
          <option value="pdf">PDF</option>
          <option value="smime">S/MIME</option>
          <option value="pgp">PGP</option>
          <option value="none">None / Default</option>
        </select>
      </div>
      <div class="col-auto">
        <label class="form-label mb-1 d-block">&nbsp;</label>
        <button id="clearFilters" class="btn btn-sm btn-outline-secondary">
          <i class="fas fa-times"></i> Clear Filters
        </button>
      </div>
    </div>

    <cfif getextrecipients.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No external recipients found.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table id="extRecTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th>Recipient</th>
            <th style="width: 200px">Encryption Mode</th>
            <th style="width: 80px">S/MIME</th>
            <th style="width: 80px">PGP</th>
            <th style="width: 110px">Cert Expiry</th>
            <th style="width: 80px">Source</th>
            <th style="width: 150px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getextrecipients">
            <!--- Determine source and encryption details --->
            <cfset isAdmin = StructKeyExists(adminLookup, cm_email)>
            <cfset hasSmime = StructKeyExists(smimeLookup, cm_email)>
            <cfset smimeCount = IIF(hasSmime, "smimeLookup[cm_email].cnt", "0")>
            <cfset pgpCount = IIF(StructKeyExists(pgpLookup, cm_email), "pgpLookup[cm_email]", "0")>
            <cfset smimeExpiry = IIF(hasSmime AND IsDate(smimeLookup[cm_email].expires), "smimeLookup[cm_email].expires", DE(""))>

            <!--- Determine encryption type for filtering --->
            <cfif isAdmin>
              <cfset recInfo = adminLookup[cm_email]>
              <cfif recInfo.pdf is "1">
                <cfset encType = "pdf">
              <cfelseif recInfo.smime is "1">
                <cfset encType = "smime">
              <cfelseif recInfo.pgp is "1">
                <cfset encType = "pgp">
              <cfelse>
                <cfset encType = "none">
              </cfif>
            <cfelse>
              <!--- Auto-discovered: derive from actual certs/keys --->
              <cfif smimeCount GT 0>
                <cfset encType = "smime">
              <cfelseif pgpCount GT 0>
                <cfset encType = "pgp">
              <cfelse>
                <cfset encType = "none">
              </cfif>
            </cfif>

            <tr data-source="#IIF(isAdmin, DE('admin'), DE('auto'))#" data-encryption="#encType#">
              <td>#encodeForHTML(cm_email)#</td>
              <td class="text-center">
                <cfif isAdmin>
                  <cfset recInfo = adminLookup[cm_email]>
                  <cfif recInfo.pdf is "1">
                    <span class="badge bg-warning text-dark">PDF</span>
                    <cfif recInfo.encryption_mode is "pdf_mandatory">
                      <small class="text-muted">Mandatory<cfif recInfo.pdf_mode is not ""> (#encodeForHTML(recInfo.pdf_mode)#)</cfif></small>
                    <cfelse>
                      <small class="text-muted">By Subject<cfif recInfo.pdf_mode is not ""> (#encodeForHTML(recInfo.pdf_mode)#)</cfif></small>
                    </cfif>
                  <cfelseif recInfo.smime is "1">
                    <span class="badge bg-success">S/MIME</span>
                    <cfif recInfo.encryption_mode is "smime_mandatory">
                      <small class="text-muted">Mandatory</small>
                    <cfelse>
                      <small class="text-muted">By Subject</small>
                    </cfif>
                  <cfelseif recInfo.pgp is "1">
                    <span class="badge bg-info">PGP</span>
                    <cfif recInfo.encryption_mode is "pgp_mandatory">
                      <small class="text-muted">Mandatory</small>
                    <cfelse>
                      <small class="text-muted">By Subject</small>
                    </cfif>
                  <cfelse>
                    <span class="badge bg-secondary">None</span>
                  </cfif>
                <cfelse>
                  <!--- Auto-discovered: show what we can detect --->
                  <cfif smimeCount GT 0>
                    <span class="badge bg-success">S/MIME</span>
                    <small class="text-muted">Default</small>
                  <cfelseif pgpCount GT 0>
                    <span class="badge bg-info">PGP</span>
                    <small class="text-muted">Default</small>
                  <cfelse>
                    <span class="badge bg-light text-dark">Default</span>
                  </cfif>
                </cfif>
              </td>
              <td class="text-center">
                <cfif smimeCount GT 0>
                  <cfif isAdmin>
                    <a href="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(cm_email)#" class="badge bg-success text-white" title="View S/MIME Certificates">
                      #smimeCount# cert(s)
                    </a>
                  <cfelse>
                    <span class="badge bg-success">#smimeCount# cert(s)</span>
                  </cfif>
                <cfelse>
                  <span class="badge bg-secondary">None</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif pgpCount GT 0>
                  <cfif isAdmin>
                    <a href="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(cm_email)#" class="badge bg-success text-white" title="View PGP Keyrings">
                      #pgpCount# key(s)
                    </a>
                  <cfelse>
                    <span class="badge bg-success">#pgpCount# key(s)</span>
                  </cfif>
                <cfelse>
                  <span class="badge bg-secondary">None</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif smimeExpiry is not "">
                  <span class="<cfif DateCompare(smimeExpiry, Now()) LT 0>text-danger fw-bold<cfelseif DateDiff('d', Now(), smimeExpiry) LTE 30>text-warning fw-bold<cfelse>text-muted</cfif>">
                    #DateFormat(smimeExpiry, "yyyy-mm-dd")#
                  </span>
                <cfelse>
                  <span class="text-muted">&mdash;</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif isAdmin>
                  <span class="badge bg-primary">Admin</span>
                <cfelse>
                  <span class="badge bg-light text-dark">Auto</span>
                </cfif>
              </td>
              <td class="text-center">
                <div class="d-flex gap-1 flex-nowrap justify-content-center align-items-center">
                <cfif isAdmin>
                  <cfset recInfo = adminLookup[cm_email]>
                  <cfif recInfo.smime is "1">
                    <a href="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(cm_email)#" class="btn btn-sm btn-outline-success" title="S/MIME Certificates">
                      <i class="fas fa-certificate"></i>
                    </a>
                  </cfif>
                  <cfif recInfo.pgp is "1">
                    <a href="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(cm_email)#" class="btn btn-sm btn-outline-info" title="PGP Keyrings">
                      <i class="fas fa-key"></i>
                    </a>
                  </cfif>
                  <cfif recInfo.pdf is "1" AND recInfo.pdf_mode is "static">
                    <button type="button" class="btn btn-sm btn-outline-warning" title="Reset PDF Password"
                      onclick="openPdfPasswordModal('#encodeForJavaScript(cm_email)#')">
                      <i class="fas fa-file-pdf"></i>
                    </button>
                  </cfif>
                  <cfif recInfo.pdf is "1" AND recInfo.pdf_mode is "random">
                    <button type="button" class="btn btn-sm btn-outline-secondary" title="Reset Portal Password"
                      onclick="openPortalPasswordModal('#encodeForJavaScript(cm_email)#')">
                      <i class="fas fa-lock"></i>
                    </button>
                  </cfif>
                </cfif>
                  <button type="button" class="btn btn-sm btn-outline-danger" title="Delete Recipient"
                    onclick="deleteRecipient('#encodeForJavaScript(cm_email)#')">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </div>
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
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!--- HIDDEN DELETE FORM --->
<form method="post" id="deleteRecipientForm" style="display:none;">
  <input type="hidden" name="action" value="delete_recipient">
  <input type="hidden" name="delete_email" id="deleteEmail" value="">
</form>

<!--- PDF PASSWORD RESET MODAL --->
<div class="modal fade" id="pdfPasswordModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="reset_pdf_password">
        <input type="hidden" name="pdf_email" id="pdfEmail" value="">
        <div class="modal-header bg-warning text-dark">
          <h5 class="modal-title"><i class="fas fa-file-pdf"></i> Reset PDF Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Reset the static PDF encryption password for <strong id="pdfEmailDisplay"></strong>.</p>
          <p class="text-muted small">Auto-generated (min 12 characters). The new password should be given to the recipient via secure means.</p>
          <div class="mb-3">
            <label for="pdf_password1" class="form-label">New Password</label>
            <div class="input-group">
              <input type="password" class="form-control" id="pdf_password1" name="pdf_password1" minlength="12" maxlength="255" required>
              <input type="hidden" name="pdf_password2" id="pdf_password2">
              <button class="btn btn-outline-secondary" type="button" id="togglePdfPassword" title="Show/Hide Password">
                <i class="fas fa-eye" id="pdfPasswordIcon"></i>
              </button>
              <button class="btn btn-outline-primary" type="button" id="regeneratePdfPassword" title="Generate New Password">
                <i class="fas fa-sync-alt"></i>
              </button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-warning"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Resetting...';this.form.submit();">
            <i class="fas fa-key"></i> Reset Password
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- PORTAL PASSWORD RESET MODAL --->
<div class="modal fade" id="portalPasswordModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="reset_portal_password">
        <input type="hidden" name="portal_email" id="portalEmail" value="">
        <div class="modal-header bg-secondary text-white">
          <h5 class="modal-title"><i class="fas fa-lock"></i> Reset Portal Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Reset the Secure Email Portal password for <strong id="portalEmailDisplay"></strong>.</p>
          <p class="text-muted small">Auto-generated (min 12 characters). The new password should be given to the recipient via secure means. <strong>Unencrypted voice calls and texts are NOT considered secure.</strong></p>
          <div class="mb-3">
            <label for="portal_password1" class="form-label">New Password</label>
            <div class="input-group">
              <input type="password" class="form-control" id="portal_password1" name="portal_password1" minlength="12" maxlength="255" required>
              <input type="hidden" name="portal_password2" id="portal_password2">
              <button class="btn btn-outline-secondary" type="button" id="togglePortalPassword" title="Show/Hide Password">
                <i class="fas fa-eye" id="portalPasswordIcon"></i>
              </button>
              <button class="btn btn-outline-primary" type="button" id="regeneratePortalPassword" title="Generate New Password">
                <i class="fas fa-sync-alt"></i>
              </button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Resetting...';this.form.submit();">
            <i class="fas fa-key"></i> Reset Password
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function generatePassword(length) {
  var upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var lower = 'abcdefghijklmnopqrstuvwxyz';
  var digits = '0123456789';
  var all = upper + lower + digits;
  var password = upper.charAt(Math.floor(Math.random() * upper.length))
               + lower.charAt(Math.floor(Math.random() * lower.length))
               + digits.charAt(Math.floor(Math.random() * digits.length));
  for (var i = 3; i < length; i++) {
    password += all.charAt(Math.floor(Math.random() * all.length));
  }
  return password.split('').sort(function() { return 0.5 - Math.random(); }).join('');
}

function setupPasswordField(pwdId, pwd2Id, toggleId, iconId, regenId) {
  var pwd = document.getElementById(pwdId);
  var pwd2 = document.getElementById(pwd2Id);
  pwd.addEventListener('input', function() { pwd2.value = pwd.value; });
  document.getElementById(toggleId).addEventListener('click', function() {
    var icon = document.getElementById(iconId);
    if (pwd.type === 'password') { pwd.type = 'text'; icon.className = 'fas fa-eye-slash'; }
    else { pwd.type = 'password'; icon.className = 'fas fa-eye'; }
  });
  document.getElementById(regenId).addEventListener('click', function() {
    var p = generatePassword(16); pwd.value = p; pwd2.value = p;
  });
}

function deleteRecipient(email) {
  if (confirm('Delete external recipient ' + email + '? This will remove all certificates and keyrings.')) {
    document.getElementById('deleteEmail').value = email;
    document.getElementById('deleteRecipientForm').submit();
  }
}

function openPdfPasswordModal(email) {
  document.getElementById('pdfEmail').value = email;
  document.getElementById('pdfEmailDisplay').textContent = email;
  var p = generatePassword(16);
  document.getElementById('pdf_password1').value = p;
  document.getElementById('pdf_password1').type = 'password';
  document.getElementById('pdfPasswordIcon').className = 'fas fa-eye';
  document.getElementById('pdf_password2').value = p;
  new bootstrap.Modal(document.getElementById('pdfPasswordModal')).show();
}

function openPortalPasswordModal(email) {
  document.getElementById('portalEmail').value = email;
  document.getElementById('portalEmailDisplay').textContent = email;
  var p = generatePassword(16);
  document.getElementById('portal_password1').value = p;
  document.getElementById('portal_password1').type = 'password';
  document.getElementById('portalPasswordIcon').className = 'fas fa-eye';
  document.getElementById('portal_password2').value = p;
  new bootstrap.Modal(document.getElementById('portalPasswordModal')).show();
}

$(document).ready(function() {
  setupPasswordField('pdf_password1', 'pdf_password2', 'togglePdfPassword', 'pdfPasswordIcon', 'regeneratePdfPassword');
  setupPasswordField('portal_password1', 'portal_password2', 'togglePortalPassword', 'portalPasswordIcon', 'regeneratePortalPassword');

  if ($('#extRecTable').length) {
    var table = $('#extRecTable').DataTable({
      dom: 'Blfrtip',
      buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
      stateSave: true,
      lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
      order: [[0, 'asc']],
      columnDefs: [
        { orderable: false, targets: [6] },
        { searchable: false, targets: [6] }
      ]
    });

    // Custom filtering for Source dropdown
    $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
      var sourceFilter = $('#filterSource').val();
      var encFilter = $('#filterEncryption').val();
      var row = table.row(dataIndex).node();
      var rowSource = $(row).attr('data-source');
      var rowEnc = $(row).attr('data-encryption');

      if (sourceFilter && rowSource !== sourceFilter) return false;
      if (encFilter && rowEnc !== encFilter) return false;
      return true;
    });

    // Apply default filter on page load
    table.draw();

    // Bind filter change events
    $('#filterSource, #filterEncryption').on('change', function() {
      table.draw();
    });

    // Clear filters button
    $('#clearFilters').on('click', function() {
      $('#filterSource').val('');
      $('#filterEncryption').val('');
      table.draw();
    });
  }
});
</script>

</body>
</html>
