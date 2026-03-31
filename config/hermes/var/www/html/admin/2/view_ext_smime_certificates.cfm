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
  <title>Hermes SEG | S/MIME Certificates</title>
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
            <h1 class="m-0">S/MIME Certificates</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">External Recipients</a></li>
              <li class="breadcrumb-item active">S/MIME Certificates</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfset datasource = "hermes">

<!--- Validate email parameter --->
<cfif NOT IsDefined("url.email") OR url.email is "">
  <cfset m="View S/MIME Certificates: email parameter missing">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="action" default="">
<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_smime") AND session.m_smime is not "">
  <cfset m = session.m_smime>
  <cfset session.m_smime = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Get recipient details from external_recipients --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, email FROM external_recipients WHERE email = <cfqueryparam value="#url.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getrecipient.recordcount LT 1>
  <cfset m="View S/MIME Certificates: recipient not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfset recipientId = getrecipient.id>
<cfset recipientEmail = getrecipient.email>

<!--- ACTION: DELETE CERTIFICATE --->
<cfif action is "delete_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/delete_smime_certificate.cfm">
        <cfset session.m_smime = 3>
        <cfcatch type="any">
          <cfset session.m_smime = 10>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(recipientEmail)#" addtoken="no">
</cfif>

<!--- ACTION: DOWNLOAD CERTIFICATE --->
<cfif action is "download_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cfinclude template="./inc/download_smime_certificate.cfm">
    </cfif>
  </cfif>
</cfif>

<!--- ACTION: SEND CERTIFICATE --->
<cfif action is "send_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/send_ext_smime_certificate.cfm">
        <cfset session.m_smime = 4>
        <cfcatch type="any">
          <cfset session.m_smime = 11>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(recipientEmail)#" addtoken="no">
</cfif>

<!--- Get certificates for this recipient --->
<cfquery name="getcertificates" datasource="hermes">
  SELECT * FROM recipient_certificates WHERE user_id = <cfqueryparam value="#recipientId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- ALERTS --->
<cfif m is 3>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate deleted.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate sent to recipient.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate created successfully.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate imported successfully.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to delete S/MIME certificate.</p></div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to send S/MIME certificate.</p></div>
</cfif>

<!--- TOOLBAR --->
<div class="mb-3">
  <cfoutput>
  <a href="view_ext_rec_encryption.cfm" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Back to Recipients
  </a>
  <a href="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(recipientEmail)#" class="btn btn-primary">
    <i class="fas fa-plus-circle"></i> Add S/MIME Certificate
  </a>
  </cfoutput>
</div>

<!--- CERTIFICATES TABLE --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-certificate"></i> S/MIME Certificates for <cfoutput>#encodeForHTML(recipientEmail)#</cfoutput></h3>
  </div>
  <div class="card-body">
    <cfif getcertificates.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No S/MIME certificates found for this recipient.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th>CA</th>
            <th>Expires</th>
            <th>Key Length</th>
            <th>Algorithm</th>
            <th>Type</th>
            <th style="width: 200px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getcertificates">
            <tr>
              <td>
                <cfif external_ca is "1">
                  #encodeForHTML(external_ca_name)#
                <cfelse>
                  <cfquery name="getca" datasource="hermes">
                    SELECT ca_commonname FROM ca_settings WHERE id = <cfqueryparam value="#ca_id#" cfsqltype="cf_sql_integer">
                  </cfquery>
                  <cfif getca.recordcount GTE 1>#encodeForHTML(getca.ca_commonname)#<cfelse>Unknown</cfif>
                </cfif>
              </td>
              <td>#DateFormat(smime_certificate_expiration, "yyyy-mm-dd")#</td>
              <td><cfif external_ca is "1">N/A<cfelse>#encodeForHTML(encryption)# bits</cfif></td>
              <td><cfif external_ca is "1">N/A<cfelse>#encodeForHTML(algorithm)#</cfif></td>
              <td><cfif external_ca is "1"><span class="badge bg-info">Imported</span><cfelse><span class="badge bg-primary">Internal</span></cfif></td>
              <td>
                <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
                <cfset decryptedPwd = decrypt(smime_certificate_password, theKey, "AES", "Base64")>
                <div class="d-flex gap-1 flex-nowrap justify-content-center align-items-center">
                  <button type="button" class="btn btn-sm btn-outline-primary" title="Download PFX"
                    onclick="document.getElementById('downloadForm_#id#').submit(); setTimeout(function(){ window.location.reload(); }, 2000);">
                    <i class="fas fa-download"></i>
                  </button>
                  <button type="button" class="btn btn-sm btn-outline-success" title="Send to Recipient"
                    onclick="openSendCertModal('#id#', '#encodeForJavaScript(recipientEmail)#', '#encodeForJavaScript(decryptedPwd)#')">
                    <i class="fas fa-envelope"></i>
                  </button>
                  <button type="button" class="btn btn-sm btn-outline-danger" title="Delete Certificate"
                    onclick="if(confirm('Delete this S/MIME certificate? This cannot be undone.')) { document.getElementById('deleteForm_#id#').submit(); }">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </div>
                <form method="post" id="downloadForm_#id#" target="downloadFrame" style="display:none;">
                  <input type="hidden" name="certificate_id" value="#id#">
                  <input type="hidden" name="action" value="download_cert">
                </form>
                <form method="post" id="deleteForm_#id#" style="display:none;">
                  <input type="hidden" name="certificate_id" value="#id#">
                  <input type="hidden" name="action" value="delete_cert">
                </form>
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


<iframe name="downloadFrame" style="display:none;"></iframe>

<!--- SEND CERTIFICATE MODAL --->
<div class="modal fade" id="sendCertModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="sendCertForm">
        <input type="hidden" name="action" value="send_cert">
        <input type="hidden" name="certificate_id" id="sendCertId" value="">
        <div class="modal-header bg-success text-white">
          <h5 class="modal-title"><i class="fas fa-envelope"></i> Send Certificate</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Send the PFX certificate to <strong id="sendCertEmail"></strong>.</p>
          <div class="mb-3">
            <label class="form-label">Certificate Password</label>
            <div class="input-group">
              <input type="password" class="form-control" id="sendCertPassword" readonly>
              <button class="btn btn-outline-secondary" type="button" id="toggleSendCertPassword" title="Show/Hide Password">
                <i class="fas fa-eye" id="sendCertPasswordIcon"></i>
              </button>
              <button class="btn btn-outline-primary" type="button" id="copySendCertPassword" title="Copy to Clipboard">
                <i class="fas fa-copy"></i>
              </button>
            </div>
            <small class="text-muted">Share this password with the recipient via secure means so they can import the PFX file.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-success"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Sending...';this.form.submit();">
            <i class="fas fa-envelope"></i> Send Certificate
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function openSendCertModal(certId, email, password) {
  document.getElementById('sendCertId').value = certId;
  document.getElementById('sendCertEmail').textContent = email;
  document.getElementById('sendCertPassword').value = password;
  document.getElementById('sendCertPassword').type = 'password';
  document.getElementById('sendCertPasswordIcon').className = 'fas fa-eye';
  new bootstrap.Modal(document.getElementById('sendCertModal')).show();
}

$(document).ready(function() {
  // Show/hide password toggle
  $('#toggleSendCertPassword').on('click', function() {
    var pwd = document.getElementById('sendCertPassword');
    var icon = document.getElementById('sendCertPasswordIcon');
    if (pwd.type === 'password') {
      pwd.type = 'text';
      icon.className = 'fas fa-eye-slash';
    } else {
      pwd.type = 'password';
      icon.className = 'fas fa-eye';
    }
  });

  // Copy to clipboard
  $('#copySendCertPassword').on('click', function() {
    var pwd = document.getElementById('sendCertPassword');
    navigator.clipboard.writeText(pwd.value).then(function() {
      var btn = document.getElementById('copySendCertPassword');
      btn.innerHTML = '<i class="fas fa-check text-success"></i>';
      setTimeout(function() { btn.innerHTML = '<i class="fas fa-copy"></i>'; }, 2000);
    });
  });
});
</script>

</body>
</html>
