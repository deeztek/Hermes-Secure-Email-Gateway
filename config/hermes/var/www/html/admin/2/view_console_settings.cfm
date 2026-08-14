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
  <title>Hermes SEG | Console Settings</title>
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
            <h1 class="m-0">Console Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Console Settings</li>
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
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Load settings --->
<cfinclude template="./inc/get_console_settings.cfm">

<cfset consoleCertificate = console_certificate.value2>
<cfset dhparam = console_dhparam.value2>
<cfset hsts = console_hsts.value2>
<cfset sslstapling = console_ssl_stapling.value2>
<cfset sslstaplingverify = console_ssl_stapling_verify.value2>

<cfquery name="getcertdetails" datasource="hermes">
  SELECT id, subject, issuer, serial, type, friendly_name, file_name, system
  FROM system_certificates
  WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consoleCertificate#">
</cfquery>

<!--- ACTION HANDLERS --->
<cfif action is "edit">

  <!--- Captured before the handler overwrites it. get_console_settings.cfm ran
       above, so this is the address the console is reachable at right now. --->
  <cfset previousConsoleHost = Trim(console_host.value2)>

  <cfinclude template="./inc/edit_console_settings.cfm">

  <!--- Re-read what actually landed in the database rather than trusting
       form.console_host: one validation path (IPv6) accepts the input without
       writing it, so the form value can differ from the stored value. --->
  <cfinclude template="./inc/get_console_settings.cfm">
  <cfset newConsoleHost = Trim(console_host.value2)>
  <cfset consoleHostChanged = (newConsoleHost IS NOT previousConsoleHost)>

  <cfinclude template="./inc/restart_authelia.cfm">
  <cfinclude template="./inc/restart_ciphermail.cfm">
  <cfset session.m = 27>

  <cfif consoleHostChanged>
    <!--- The console has just changed identity. Authelia's session cookie is
         scoped to a single domain, so it no longer has any configuration for
         the address this browser is on, and every further request to /admin/2/
         here will fail with "unable to determine user state". That is why the
         Nginx restart cannot be deferred to preload_restart_nginx.cfm, which is
         itself auth-protected: it would never load, Nginx would keep serving
         the old portal URL, and the operator would be locked out with no way
         back except restarting hermes_nginx from the Docker host.

         So this fires the restart from this request, the last authenticated
         one, and renders a holding page that waits out the restart before
         moving the operator to the new address. It aborts, so nothing below
         runs. --->
    <cfinclude template="./inc/console_host_change_apply.cfm">
  <cfelse>
    <!--- Certificate, HSTS, OCSP and DH changes leave the address, and
         therefore the session, intact, so the normal spinner-and-poll restart
         path still applies. --->
    <cflocation url="preload_restart_nginx.cfm?returnUrl=/admin/2/view_console_settings.cfm" addtoken="no">
  </cfif>

</cfif>

<!--- Re-load settings after actions --->
<cfinclude template="./inc/get_console_settings.cfm">
<cfset consoleCertificate = console_certificate.value2>
<cfset dhparam = console_dhparam.value2>
<cfset hsts = console_hsts.value2>
<cfset sslstapling = console_ssl_stapling.value2>
<cfset sslstaplingverify = console_ssl_stapling_verify.value2>

<cfquery name="getcertdetails" datasource="hermes">
  SELECT id, subject, issuer, serial, type, friendly_name, file_name, system
  FROM system_certificates
  WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consoleCertificate#">
</cfquery>

<!--- Is the certificate bound to this console one a browser will refuse?
      A self-signed certificate has subject = issuer; the install-time
      bootstrap certificate is additionally CN=localhost, so it fails name
      matching as well.

      This gates the HSTS control below. Enabling HSTS against an untrusted
      certificate pins every browser that has visited this address to refuse
      it for a year with no click-through, locking the administrator out of
      the console they are in the middle of configuring. Recovery means
      clearing the HSTS entry in each browser individually, which is not
      something an operator can be expected to discover. --->
<cfset consoleCertUntrusted = false>
<cfif getcertdetails.recordcount GTE 1>
  <cfif Trim(getcertdetails.file_name) is "bootstrap"
        OR (Len(Trim(getcertdetails.subject)) GT 0
            AND Trim(getcertdetails.subject) is Trim(getcertdetails.issuer))>
    <cfset consoleCertUntrusted = true>
  </cfif>
</cfif>

<cfset session.m = "">

<!--- ALERTS --->
<cfset _alerts = {
  "2":{type:"danger", msg:"You must select a valid Console Certificate."},
  "3":{type:"danger", msg:"The Console Address must be a valid FQDN or IP Address."},
  "27":{type:"success", msg:"Console Settings saved successfully. Nginx restarted."},
  "28":{type:"danger", msg:"HSTS was not enabled, and nothing was saved. The console is still using the self-signed bootstrap certificate (CN=localhost), which no browser trusts and which cannot match your console address. Enabling HSTS against it tells browsers to refuse this address for a year with no way to continue, locking you out of the console. Bind a publicly trusted certificate first, confirm the console loads with no warning, then enable HSTS."}
}>

<cfif StructKeyExists(_alerts, toString(m))>
  <cfset _a = _alerts[toString(m)]>
  <cfoutput>
  <div class="alert alert-#_a.type# alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <cfif _a.type is "success">
      <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfelse>
      <h4><i class="icon fa fa-ban"></i> Error</h4>
    </cfif>
    #_a.msg#
  </div>
  </cfoutput>
</cfif>

<!-- CONSOLE SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cog"></i> Console Settings</h3>
  </div>
  <div class="card-body">

    <form name="EditConsoleSettings" method="post" autocomplete="off">
      <input type="hidden" name="action" value="edit">
      <cfoutput>
      <input type="hidden" name="certificateno_1" id="certificateno_1" value="#consoleCertificate#">
      </cfoutput>

      <div class="callout callout-warning mb-3">
        <p class="mb-1"><i class="icon fas fa-exclamation-triangle"></i> If you modify the <strong>Console Address</strong>, adjust your browser URL to match. This also sets the Ciphermail Portal and User Console addresses.</p>
        <p class="mb-0">If you set the Console Address to an IP address and later change the server IP, you must also update the Host IP Address on the <a href="view_server_setup.cfm">Server Setup</a> page to keep Nextcloud trusted domains in sync.</p>
      </div>

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Console Address (IP or FQDN)</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="console_host" value="#encodeForHTMLAttribute(consoleHost)#" placeholder="Enter IP or FQDN" maxlength="255">
            </cfoutput>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Console Certificate</strong></label>
            <cfoutput>
            <input type="text" name="certificate_1" class="certificate form-control" id="certificate_1" placeholder="Start typing to search..." value="#getcertdetails.friendly_name#" autocomplete="off">
            </cfoutput>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Certificate Subject</strong></label>
            <cfoutput><input type="text" class="form-control" id="subject_1" value="#getcertdetails.subject#" readonly></cfoutput>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Certificate Issuer</strong></label>
            <cfoutput><input type="text" class="form-control" id="issuer_1" value="#getcertdetails.issuer#" readonly></cfoutput>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Certificate Serial</strong></label>
            <cfoutput><input type="text" class="form-control" id="serial_1" value="#getcertdetails.serial#" readonly></cfoutput>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Certificate Type</strong></label>
            <cfoutput><input type="text" class="form-control" id="type_1" value="#getcertdetails.type#" readonly></cfoutput>
          </div>
        </div>

        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>HTTP Strict Transport Security (HSTS)</strong></label>
            <select class="form-select" name="hsts">
              <option value="enable" <cfif hsts is "enable">selected</cfif>>Enable<cfif NOT consoleCertUntrusted> (Recommended)</cfif></option>
              <option value="disable" <cfif hsts is "disable">selected</cfif>>Disable</option>
            </select>
            <cfif consoleCertUntrusted>
              <div class="alert alert-warning py-2 px-3 mt-2 mb-0" role="alert">
                <strong>Do not enable HSTS yet.</strong> The certificate bound to this console is
                self-signed, so browsers do not trust it. Enabling HSTS tells every browser that
                has visited this address to refuse an untrusted certificate here for one year,
                with no option to continue anyway. You would lose access to this console, and
                recovery means clearing the HSTS entry in each browser individually.
                <br>
                Bind a publicly trusted certificate first, confirm the console loads with no
                warning, then come back and enable HSTS.
              </div>
            </cfif>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>OCSP Stapling</strong></label>
            <select class="form-select" name="ocsp">
              <option value="enable" <cfif sslstapling is "enable">selected</cfif>>Enable (Recommended)</option>
              <option value="disable" <cfif sslstapling is "disable">selected</cfif>>Disable</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>OCSP Stapling Verify</strong></label>
            <select class="form-select" name="ocspverify">
              <option value="enable" <cfif sslstaplingverify is "enable">selected</cfif>>Enable (Recommended)</option>
              <option value="disable" <cfif sslstaplingverify is "disable">selected</cfif>>Disable</option>
            </select>
          </div>
        </div>
      </div>

      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
        <i class="fas fa-save"></i> Save &amp; Apply Settings
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
// Certificate autocomplete
$(document).ready(function() {
  $(document).on('keydown', '.certificate', function() {
    var id = this.id;
    var splitid = id.split('_');
    var index = splitid[1];

    $('#'+id).autocomplete({
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
        $(this).val(ui.item.label);
        var certId = ui.item.value;

        $.ajax({
          url: './inc/getcertificates.cfm',
          type: 'post',
          data: { id: certId, request: 2 },
          dataType: 'json',
          success: function(response) {
            if (response.length > 0) {
              document.getElementById('certificateno_'+index).value = response[0]['id'];
              document.getElementById('type_'+index).value = response[0]['type'];
              document.getElementById('subject_'+index).value = response[0]['subject'];
              document.getElementById('issuer_'+index).value = response[0]['issuer'];
              document.getElementById('serial_'+index).value = response[0]['serial'];
            }
          }
        });
        return false;
      }
    });
  });
});
</script>

</body>
</html>
