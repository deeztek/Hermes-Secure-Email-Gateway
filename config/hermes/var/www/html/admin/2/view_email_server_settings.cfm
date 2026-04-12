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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Email Server - Settings</title>
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
            <h1 class="m-0">Email Server - Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLER --->
<cfif action EQ "save_settings">
  <cfinclude template="./inc/email_server_settings_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Settings saved.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    An error occurred saving settings. Check the system log for details.
  </div>
</cfif>

<!--- LOAD CURRENT SETTINGS FROM DATABASE --->
<cfquery name="getNcFilesApp" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'files_app_visible'
</cfquery>
<cfset ncFilesAppVisible = "yes">
<cfif getNcFilesApp.recordcount GTE 1>
    <cfset ncFilesAppVisible = getNcFilesApp.value2>
</cfif>

<cfquery name="getNcPasswordForm" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'show_password_form'
</cfquery>
<cfset ncShowPasswordForm = "no">
<cfif getNcPasswordForm.recordcount GTE 1>
    <cfset ncShowPasswordForm = getNcPasswordForm.value2>
</cfif>

<form method="post" action="view_email_server_settings.cfm">
<input type="hidden" name="action" value="save_settings">

<!-- NEXTCLOUD WEBMAIL SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox"></i> Nextcloud Webmail Settings</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Files App</strong></label>
          <select class="form-select" name="nc_files_app">
            <option value="yes" <cfif ncFilesAppVisible EQ "yes">selected</cfif>>Visible</option>
            <option value="no" <cfif ncFilesAppVisible NEQ "yes">selected</cfif>>Hidden</option>
          </select>
          <small class="form-text text-muted">Controls whether the Files app is visible to Nextcloud users. When hidden, Nextcloud functions as a webmail-only client (Mail, Calendar, Contacts). When visible, users can upload, manage, and share files. File sharing settings (permissions, public links, expiration) can be configured in the Nextcloud admin panel directly.</small>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Nextcloud Login Form</strong></label>
          <select class="form-select" name="nc_password_form">
            <option value="no" <cfif ncShowPasswordForm NEQ "yes">selected</cfif>>Hidden (SSO button only)</option>
            <option value="yes" <cfif ncShowPasswordForm EQ "yes">selected</cfif>>Visible (SSO button + username/password)</option>
          </select>
          <small class="form-text text-muted">Controls whether the username/password login form is visible on the Nextcloud login page alongside the SSO button. Set to <strong>Visible</strong> temporarily when you need to log into Nextcloud as a local admin user for maintenance (app management, troubleshooting, etc.), then set it back to <strong>Hidden</strong> to keep the login page clean. Only applies when "Auto-Redirect to Hermes SSO" is disabled in Authentication Settings.</small>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- MAIL SERVER TLS CERTIFICATE CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fab fa-expeditedssl"></i> Mail Server TLS Certificate</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <p class="mb-0"><i class="icon fas fa-info-circle"></i> Select the TLS certificate used by the mail server (Dovecot) for IMAP, POP3, and Submission connections. This is the certificate your email clients see when connecting over TLS. It should match the hostname your users configure in their mail clients (e.g., <code>mail.example.com</code>).</p>
    </div>

    <!--- Load current Dovecot certificate from parameters2 --->
    <cfquery name="dovecotCertParam" datasource="hermes">
        SELECT value2 FROM parameters2
        WHERE module = 'certificates' AND parameter = 'mail.certificate'
    </cfquery>
    <cfset dovecotCertId = "">
    <cfif dovecotCertParam.recordcount GTE 1>
        <cfset dovecotCertId = dovecotCertParam.value2>
    </cfif>

    <cfset dovecotCertName = "">
    <cfset dovecotCertSubject = "">
    <cfset dovecotCertIssuer = "">
    <cfset dovecotCertSerial = "">
    <cfif dovecotCertId NEQ "">
        <cfquery name="getDovecotCert" datasource="hermes">
            SELECT id, subject, issuer, serial, type, friendly_name
            FROM system_certificates
            WHERE id = <cfqueryparam value="#dovecotCertId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif getDovecotCert.recordcount GTE 1>
            <cfset dovecotCertName = getDovecotCert.friendly_name>
            <cfset dovecotCertSubject = getDovecotCert.subject>
            <cfset dovecotCertIssuer = getDovecotCert.issuer>
            <cfset dovecotCertSerial = getDovecotCert.serial>
        </cfif>
    </cfif>

    <cfoutput>
    <input type="hidden" name="dovecot_cert_id" id="dovecot_cert_id" value="#dovecotCertId#">

    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Mail Server Certificate</strong></label>
          <input type="text" name="dovecot_cert_name" class="certificate form-control" id="dovecot_cert_name" placeholder="Start typing to search..." value="#encodeForHTMLAttribute(dovecotCertName)#" autocomplete="off">
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Certificate Subject</strong></label>
          <input type="text" class="form-control" id="dovecot_cert_subject" value="#encodeForHTMLAttribute(dovecotCertSubject)#" readonly>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Certificate Issuer</strong></label>
          <input type="text" class="form-control" id="dovecot_cert_issuer" value="#encodeForHTMLAttribute(dovecotCertIssuer)#" readonly>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Certificate Serial</strong></label>
          <input type="text" class="form-control" id="dovecot_cert_serial" value="#encodeForHTMLAttribute(dovecotCertSerial)#" readonly>
        </div>
      </div>
    </div>
    </cfoutput>
  </div>
</div>

<!-- DOVECOT MAIL SERVER INFO CARD (read-only for now) -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-server"></i> Mail Server Configuration</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-secondary">
      <h5><i class="icon fas fa-info-circle"></i> Current Configuration</h5>
      <p class="mb-0">The following Dovecot mail server settings are currently configured. Admin-configurable controls for these settings are planned for a future release.</p>
    </div>

    <div class="row">
      <div class="col-md-6">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <th>Mail Compression</th>
              <td><span class="badge bg-success">Enabled (LZ4)</span></td>
            </tr>
            <tr>
              <th>Mail Encryption at Rest</th>
              <td><span class="badge bg-secondary">Disabled (default)</span></td>
            </tr>
            <tr>
              <th>Protocols</th>
              <td>IMAP, POP3, Submission, Sieve, LMTP</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-md-6">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <th>Quota Warnings</th>
              <td>80%, 95%, 99%, 100% (back under)</td>
            </tr>
            <tr>
              <th>Vacation Auto-Reply</th>
              <td><span class="badge bg-success">Enabled</span> (via Pigeonhole Sieve)</td>
            </tr>
            <tr>
              <th>ManageSieve</th>
              <td><span class="badge bg-success">Enabled</span> (port 4190)</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<button type="submit" class="btn btn-primary mb-4"><i class="fa fa-save"></i>&nbsp;&nbsp;Save Settings</button>

</form>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
  // Certificate autocomplete for the Mail Server TLS Certificate field
  $(document).on('keydown', '.certificate', function() {
    var $input = $(this);
    $input.autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "./inc/getcertificates.cfm",
          type: 'post',
          dataType: "json",
          data: { search: request.term, request: 1 },
          success: function(data) { response(data); }
        });
      },
      select: function(event, ui) {
        $input.val(ui.item.label);
        var certId = ui.item.value;

        $.ajax({
          url: './inc/getcertificates.cfm',
          type: 'post',
          data: { id: certId, request: 2 },
          dataType: 'json',
          success: function(response) {
            if (response.length > 0) {
              $('#dovecot_cert_id').val(response[0]['id']);
              $('#dovecot_cert_subject').val(response[0]['subject']);
              $('#dovecot_cert_issuer').val(response[0]['issuer']);
              $('#dovecot_cert_serial').val(response[0]['serial']);
            }
          }
        });
        return false;
      }
    });
  });
</script>

</body>
</html>
