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
  <title>Hermes SEG | Server Setup</title>
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
            <h1 class="m-0">Server Setup</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Server Setup</li>
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

<!--- ACTION HANDLER --->
<cfif action is "save_settings">
  <cfinclude template="./inc/save_server_identity.cfm">
</cfif>

<!--- Get current values from parameters table --->
<cfquery name="getMyOrigin" datasource="hermes">
  SELECT parameter FROM parameters
  WHERE parent_name = 'myorigin' AND child = '1' AND module = 'postfix' AND conf_file = 'main.cf'
</cfquery>

<cfquery name="getMyHostname" datasource="hermes">
  SELECT parameter FROM parameters
  WHERE parent_name = 'myhostname' AND child = '1' AND module = 'postfix' AND conf_file = 'main.cf'
</cfquery>

<cfquery name="getHostIP" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'server_ip' AND module = 'network'
</cfquery>

<cfset currentDomain = getMyOrigin.parameter>
<cfset currentHostname = getMyHostname.parameter>
<cfset currentHostIP = getHostIP.value2>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Server setup settings saved successfully. Postfix reloaded and Nextcloud configuration updated.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Mail Server Domain field cannot be empty.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Mail Server Hostname field cannot be empty.
  </div>
</cfif>
<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Mail Server Domain is not a valid domain name.
  </div>
</cfif>
<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Mail Server Hostname is not a valid fully qualified domain name (FQDN).
  </div>
</cfif>
<cfif m is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Host IP Address is not a valid IP address.
  </div>
</cfif>

<!-- SERVER IDENTITY CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-id-card"></i> Server Setup</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info mb-3">
      <p class="mb-1"><i class="icon fas fa-info-circle"></i>
        These are foundational settings typically configured during initial setup and rarely changed afterward.</p>
      <p class="mb-1">The <strong>Mail Server Domain</strong> is the origin domain appended to unqualified sender addresses in outgoing mail (Postfix <code>myorigin</code>).</p>
      <p class="mb-1">The <strong>Mail Server Hostname</strong> is the FQDN used in SMTP banners and HELO/EHLO greetings when communicating with other mail servers (Postfix <code>myhostname</code>). Ensure a matching TLS certificate is assigned on the <a href="view_smtp_tls_settings.cfm">SMTP TLS Settings</a> page.</p>
      <p class="mb-0">The <strong>Host IP Address</strong> is the server's IP address, included alongside the console hostname in the Nextcloud trusted domains configuration. Changing this value does <strong>not</strong> update the Console Address on the <a href="view_console_settings.cfm">Console Settings</a> page. If the Console Address is set to an IP address instead of a FQDN, update each one independently when the server IP changes.</p>
    </div>

    <div class="callout callout-warning mb-3">
      <p class="mb-1"><i class="icon fas fa-exclamation-triangle"></i>
        Changing the mail server settings will immediately update the Postfix configuration and reload the mail service. Changing the Host IP will regenerate the Nextcloud configuration.
        Ensure the hostname has a valid DNS A record and matching reverse DNS (PTR) record, or outgoing mail may be rejected by other servers.
      </p>
      <p class="mb-0"><strong>Changing the Mail Server Hostname will break existing email client configurations</strong> that connect via the old FQDN. This includes:</p>
      <ul class="mb-0">
        <li>All external email clients (Thunderbird, Outlook, iOS Mail, etc.) &mdash; users will need to reconfigure IMAP/SMTP hostnames</li>
        <li>CalDAV/CardDAV calendar/contact clients &mdash; need new server URLs</li>
        <li>Nextcloud Mail profiles for <strong>remote-auth</strong> mailbox users (auto-discovered via external FQDN) &mdash; users will be re-prompted for their AD password and hostnames auto-update</li>
        <li>Nextcloud Mail profiles for <strong>local-auth</strong> users are <strong>not</strong> affected (they use internal Docker hostnames)</li>
      </ul>
      <p class="mb-0 mt-2"><small>Only change this if necessary (e.g. migrating to a new domain). Plan to notify users and provide updated client setup instructions.</small></p>
    </div>

    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Mail Server Domain</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="server_domain" value="#encodeForHTMLAttribute(currentDomain)#" placeholder="example.com">
            </cfoutput>
            <div class="form-text">Origin domain for outgoing mail (e.g., <code>example.com</code>)</div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Mail Server Hostname (FQDN)</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="server_hostname" value="#encodeForHTMLAttribute(currentHostname)#" placeholder="mail.example.com">
            </cfoutput>
            <div class="form-text">FQDN used in SMTP banners and HELO/EHLO (e.g., <code>mail.example.com</code>)</div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Host IP Address</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="host_ip" value="#encodeForHTMLAttribute(currentHostIP)#" placeholder="192.168.1.100">
            </cfoutput>
            <div class="form-text">Server IP address for Nextcloud trusted domains (set during install)</div>
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

</body>
</html>
