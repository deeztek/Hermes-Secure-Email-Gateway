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
<cfquery name="getNcFilesSharing" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'files_sharing_enabled'
</cfquery>
<cfset ncFilesSharingEnabled = "no">
<cfif getNcFilesSharing.recordcount GTE 1>
    <cfset ncFilesSharingEnabled = getNcFilesSharing.value2>
</cfif>

<cfquery name="getNcPublicLinks" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'public_links_enabled'
</cfquery>
<cfset ncPublicLinksEnabled = "no">
<cfif getNcPublicLinks.recordcount GTE 1>
    <cfset ncPublicLinksEnabled = getNcPublicLinks.value2>
</cfif>

<form method="post" action="view_email_server_settings.cfm">
<input type="hidden" name="action" value="save_settings">

<!-- NEXTCLOUD FILES & SHARING CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-folder-open"></i> Nextcloud Files & Sharing</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <h5><i class="icon fas fa-info-circle"></i> About Files & Sharing</h5>
      <p class="mb-1">These settings control whether Nextcloud users can share files and create public share links. The Nextcloud Files app itself is always available (it is a core Nextcloud component), but sharing can be disabled independently.</p>
      <p class="mb-0"><small>When file sharing is disabled, users can still upload and manage their own files but cannot share them with other users or create public links. This is the recommended setting for deployments that use Nextcloud primarily as a webmail client.</small></p>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>File Sharing Between Users</strong></label>
          <select class="form-select" name="nc_files_sharing">
            <option value="yes" <cfif ncFilesSharingEnabled EQ "yes">selected</cfif>>Enabled</option>
            <option value="no" <cfif ncFilesSharingEnabled NEQ "yes">selected</cfif>>Disabled</option>
          </select>
          <small class="form-text text-muted">Allow users to share files and folders with other Nextcloud users on this server.</small>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Public Share Links</strong></label>
          <select class="form-select" name="nc_public_links">
            <option value="yes" <cfif ncPublicLinksEnabled EQ "yes">selected</cfif>>Enabled</option>
            <option value="no" <cfif ncPublicLinksEnabled NEQ "yes">selected</cfif>>Disabled</option>
          </select>
          <small class="form-text text-muted">Allow users to create shareable links that external users can access without a Nextcloud account. Requires file sharing to also be enabled.</small>
        </div>
      </div>
    </div>
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
      <p class="mb-0">The following Dovecot mail server settings are currently configured. Changes to these settings require editing the Dovecot configuration file directly and are planned for a future release.</p>
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
              <td><span class="badge bg-success">Enabled (EC prime256v1)</span></td>
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

</body>
</html>
