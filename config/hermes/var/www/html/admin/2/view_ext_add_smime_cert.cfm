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
  <title>Hermes SEG | Add S/MIME Certificate</title>
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
            <h1 class="m-0">Add S/MIME Certificate</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">External Recipients</a></li>
              <li class="breadcrumb-item active">Add S/MIME Certificate</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Validate parameters --->
<cfif NOT IsDefined("url.email") OR url.email is "">
  <cfset m="Add S/MIME Certificate: email parameter missing">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="action" default="">
<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_addsmime") AND session.m_addsmime is not "">
  <cfset m = session.m_addsmime>
  <cfset session.m_addsmime = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Get recipient --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, email FROM external_recipients WHERE email = <cfqueryparam value="#url.email#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif getrecipient.recordcount LT 1>
  <cfset m="Add S/MIME Certificate: recipient not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- Get available CAs --->
<cfquery name="getCAs" datasource="hermes">
  SELECT id, ca_commonname, ca_directory, default2 FROM ca_settings ORDER BY ca_commonname ASC
</cfquery>

<!--- Get default CA --->
<cfquery name="getDefaultCA" datasource="hermes">
  SELECT id, ca_commonname, ca_directory FROM ca_settings WHERE default2 = '1' LIMIT 1
</cfquery>

<!--- ACTION: CREATE CERTIFICATE --->
<cfif action is "create_cert">
  <cfparam name="form.validity" default="1825">
  <cfparam name="form.encryption" default="4096">
  <cfparam name="form.algorithm" default="sha512">
  <cfparam name="form.password1" default="">
  <cfparam name="form.password2" default="">
  <cfparam name="form.ca" default="">
  <cfparam name="form.recipient_id" default="">

  <!--- Validate --->
  <cfif form.ca is "" OR NOT IsNumeric(form.ca)>
    <cfset session.m_addsmime = 1>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>
  <cfif form.password1 is "">
    <cfset session.m_addsmime = 2>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>
  <cfif Len(form.password1) LT 12>
    <cfset session.m_addsmime = 3>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>

  <!--- Get CA details --->
  <cfset ca = form.ca>
  <cfset validity = form.validity>
  <cfset encryption = form.encryption>
  <cfset algorithm = form.algorithm>
  <cfset password1 = form.password1>
  <cfset recipient = getrecipient.email>

  <cfquery name="getcadetails" datasource="hermes">
    SELECT * FROM ca_settings WHERE id = <cfqueryparam value="#ca#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif getcadetails.recordcount LT 1>
    <cfset session.m_addsmime = 5>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>

  <!--- Set url.type for the include --->
  <cfset url.type = "2">

  <cftry>
    <cfinclude template="./inc/create_certificate.cfm">
    <cfset session.m_smime = 5>
    <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
    <cfcatch type="any">
      <cfset session.m_addsmime = 6>
      <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
    </cfcatch>
  </cftry>
</cfif>

<!--- ACTION: IMPORT CERTIFICATE --->
<cfif action is "import_cert">
  <cfparam name="form.import_password" default="">
  <cfparam name="form.recipient_id" default="">

  <cfif form.import_password is "">
    <cfset session.m_addsmime = 7>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>
  <cfif NOT StructKeyExists(form, "pfx") OR form.pfx is "">
    <cfset session.m_addsmime = 8>
    <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
  </cfif>

  <cfset recipient = getrecipient.email>
  <cfset url.type = "2">

  <cftry>
    <cfinclude template="./inc/import_certificate.cfm">
    <cfset session.m_smime = 6>
    <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
    <cfcatch type="any">
      <cfset session.m_addsmime = 9>
      <cflocation url="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(url.email)#" addtoken="no">
    </cfcatch>
  </cftry>
</cfif>

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a Certificate Authority.</p></div>
</cfif>
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Certificate password cannot be empty.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Certificate password must be at least 12 characters.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Passwords do not match.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Selected Certificate Authority not found.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to create S/MIME certificate. Please check the logs.</p></div>
</cfif>
<cfif m is 7>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>PFX password cannot be empty.</p></div>
</cfif>
<cfif m is 8>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a PFX file to upload.</p></div>
</cfif>
<cfif m is 9>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to import S/MIME certificate. Please check the logs.</p></div>
</cfif>

<!--- TOOLBAR --->
<div class="mb-3">
  <cfoutput>
  <a href="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(url.email)#" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Back to Certificates
  </a>
  </cfoutput>
</div>

<cfoutput>
<p class="text-muted mb-3">Recipient: <strong>#encodeForHTML(getrecipient.email)#</strong></p>
</cfoutput>

<!--- CREATE CERTIFICATE --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Create S/MIME Certificate</h3>
  </div>
  <div class="card-body">
    <cfif getCAs.recordcount LT 1>
      <div class="alert alert-warning">
        <i class="icon fa fa-exclamation-triangle"></i> No Certificate Authorities found. <a href="view_internal_ca.cfm">Create one first</a>.
      </div>
    <cfelse>
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="create_cert">
        <cfoutput><input type="hidden" name="recipient_id" value="#getrecipient.id#"></cfoutput>
        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label">Certificate Authority</label>
            <select class="form-select" name="ca" required>
              <cfoutput query="getCAs">
                <option value="#id#" <cfif default2 is "1">selected</cfif>>#encodeForHTML(ca_commonname)#<cfif default2 is "1"> (Default)</cfif></option>
              </cfoutput>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label">Validity</label>
            <select class="form-select" name="validity">
              <option value="1825" selected>5 Years</option>
              <option value="1460">4 Years</option>
              <option value="1095">3 Years</option>
              <option value="730">2 Years</option>
              <option value="365">1 Year</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label">Key Length</label>
            <select class="form-select" name="encryption">
              <option value="4096" selected>4096-bit</option>
              <option value="2048">2048-bit</option>
            </select>
          </div>
          <div class="col-md-2">
            <label class="form-label">Algorithm</label>
            <select class="form-select" name="algorithm">
              <option value="sha512" selected>SHA-512</option>
              <option value="sha256">SHA-256</option>
            </select>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-4">
            <label class="form-label">Certificate Password</label>
            <div class="input-group">
              <input type="password" class="form-control" name="password1" id="certPassword" maxlength="255" required minlength="12">
              <input type="hidden" name="password2" id="certPassword2">
              <button class="btn btn-outline-secondary" type="button" id="toggleCertPassword" title="Show/Hide Password">
                <i class="fas fa-eye" id="certPasswordIcon"></i>
              </button>
              <button class="btn btn-outline-primary" type="button" id="regenerateCertPassword" title="Generate New Password">
                <i class="fas fa-sync-alt"></i>
              </button>
            </div>
            <small class="text-muted">Auto-generated (min 12 characters). Click <i class="fas fa-eye"></i> to reveal, <i class="fas fa-sync-alt"></i> to regenerate.</small>
          </div>
        </div>
        <button type="submit" class="btn btn-primary"
          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating...';this.form.submit();">
          <i class="fas fa-plus"></i> Create Certificate
        </button>
      </form>
    </cfif>
  </div>
</div>

<!--- IMPORT CERTIFICATE --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-upload"></i> Import PFX Certificate</h3>
  </div>
  <div class="card-body">
    <form method="post" enctype="multipart/form-data" autocomplete="off">
      <input type="hidden" name="action" value="import_cert">
      <cfoutput><input type="hidden" name="recipient_id" value="#getrecipient.id#"></cfoutput>
      <div class="row mb-3">
        <div class="col-md-4">
          <label class="form-label">PFX File</label>
          <input type="file" class="form-control" name="pfx" accept=".pfx,.p12" required>
          <small class="text-muted">PKCS#12 file (.pfx, .p12)</small>
        </div>
        <div class="col-md-3">
          <label class="form-label">PFX Password</label>
          <input type="password" class="form-control" name="import_password" maxlength="255" required>
        </div>
      </div>
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Importing...';this.form.submit();">
        <i class="fas fa-upload"></i> Import Certificate
      </button>
    </form>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

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

$(document).ready(function() {
  var certPwd = document.getElementById('certPassword');
  var certPwd2 = document.getElementById('certPassword2');

  // Auto-generate on page load
  var initial = generatePassword(16);
  certPwd.value = initial;
  certPwd2.value = initial;

  // Sync password2 whenever password1 changes
  certPwd.addEventListener('input', function() {
    certPwd2.value = certPwd.value;
  });

  // Show/hide toggle
  $('#toggleCertPassword').on('click', function() {
    var icon = $('#certPasswordIcon');
    if (certPwd.type === 'password') {
      certPwd.type = 'text';
      icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
      certPwd.type = 'password';
      icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
  });

  // Regenerate button
  $('#regenerateCertPassword').on('click', function() {
    var newPwd = generatePassword(16);
    certPwd.value = newPwd;
    certPwd2.value = newPwd;
  });
});
</script>

</body>
</html>
