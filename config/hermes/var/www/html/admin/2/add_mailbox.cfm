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
  <title>Hermes SEG | Add Mailbox</title>
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
            <h1 class="m-0">Add Mailbox</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item"><a href="view_mailboxes.cfm">Mailboxes</a></li>
              <li class="breadcrumb-item active">Add Mailbox</li>
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
<cfif action is "add_mailbox">
  <cfinclude template="./inc/add_mailbox_action.cfm">
</cfif>

<!--- Edition check --->
<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<!--- CHECK IF REMOTEAUTH IS AVAILABLE (Pro edition + enabled + has compatible mappings) --->
<cfset remoteauthAvailable = false>
<cfset remoteauthDomains = []>
<cfset remoteauthDisabledReason = "">

<cfif isPro>
    <cfquery name="getRemoteauthStatus" datasource="hermes">
        SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'enabled'
    </cfquery>
    <!--- All enabled remoteauth mappings are now supported. Patterns using
         {firstname}/{lastname} cause the form to reveal First/Last Name
         fields so the admin can supply the real AD values. --->
    <cfquery name="getRemoteauthDomains" datasource="hermes">
        SELECT domain_name, server_address, remote_dn_pattern FROM remoteauth_mappings
        WHERE enabled = 1
        ORDER BY domain_name
    </cfquery>
    <cfif getRemoteauthStatus.recordcount EQ 0 OR getRemoteauthStatus.setting_value NEQ "1">
        <cfset remoteauthDisabledReason = "RemoteAuth is not enabled. Enable it in <a href='view_remoteauth.cfm'>Remote Authentication</a> settings.">
    <cfelseif getRemoteauthDomains.recordcount EQ 0>
        <cfset remoteauthDisabledReason = "No enabled domain mappings found. Add one in <a href='view_remoteauth.cfm'>Remote Authentication</a>.">
    <cfelse>
        <cfset remoteauthAvailable = true>
        <cfloop query="getRemoteauthDomains">
            <cfset arrayAppend(remoteauthDomains, {domain: getRemoteauthDomains.domain_name, server: getRemoteauthDomains.server_address, pattern: getRemoteauthDomains.remote_dn_pattern})>
        </cfloop>
    </cfif>
</cfif>

<!--- GET MAILBOX DOMAINS --->
<cfquery name="getMailboxDomains" datasource="hermes">
    SELECT id, domain, default_quota_mb, nextcloud_enabled FROM domains WHERE type = 'mailbox' ORDER BY domain ASC
</cfquery>

<!--- CHECK IF ANY MAILBOX DOMAINS EXIST --->
<cfif getMailboxDomains.recordcount LT 1>
  <div class="alert alert-warning">
    <h4><i class="icon fas fa-exclamation-triangle"></i> No Mailbox Domains</h4>
    <p>You must add at least one mailbox domain before creating mailboxes. <a href="view_mailbox_domains.cfm">Go to Email Server &gt; Domains</a>.</p>
  </div>
<cfelse>

<!--- ERROR / SUCCESS MESSAGES --->
<cfif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Username cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid domain selection.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Username contains invalid characters. Use only lowercase letters, numbers, dots, hyphens, and underscores.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Selected domain is not a valid mailbox domain.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    A mailbox or recipient with this email address already exists.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Quota must be a positive number.
  </div>
<cfelseif m EQ 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Password is required for local authentication mailbox users.
  </div>
<cfelseif m EQ 17>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    First Name is required for this RemoteAuth domain (DN pattern uses <code>{firstname}</code>).
  </div>
<cfelseif m EQ 18>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Last Name is required for this RemoteAuth domain (DN pattern uses <code>{lastname}</code>).
  </div>
<cfelseif m EQ 99>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Compromised Password</h4>
    This password has been found in a data breach and cannot be used. Please choose a different password.
  </div>
<cfelseif m EQ 100>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fas fa-exclamation-triangle"></i> Password Check Unavailable</h4>
    Unable to verify password against breach database. Please try again later.
  </div>
</cfif>

<!--- BACK BUTTON --->
<p>
  <a href="view_mailboxes.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Mailboxes</a>
</p>

<!--- ADD MAILBOX FORM --->
<form name="add_mailbox" method="post" action="">
  <input type="hidden" name="action" value="add_mailbox">
  <div class="box-body">
    <cfoutput>
    <div class="form-horizontal">

      <!--- LOGIN PREVIEW — updates live as the admin fills in the form so
           they know exactly what the mailbox user will type to log in. --->
      <div class="alert alert-primary mb-3" id="loginPreview">
        <h5 class="mb-2"><i class="icon fas fa-sign-in-alt"></i> Login Information (for this mailbox user)</h5>
        <div class="row">
          <div class="col-md-4"><strong>URL</strong></div>
          <div class="col-md-8"><code id="lpUrl">https://#cgi.http_host#/users/</code> <small class="text-muted">(and <code>/nc/</code> for webmail)</small></div>
        </div>
        <div class="row">
          <div class="col-md-4"><strong>Username</strong></div>
          <div class="col-md-8"><code id="lpUsername">username@domain</code> <small class="text-muted">&mdash; the full email address</small></div>
        </div>
        <div class="row">
          <div class="col-md-4"><strong>Password</strong></div>
          <div class="col-md-8" id="lpPassword">The password you set below</div>
        </div>
      </div>

      <!--- HOW MAILBOX CREDENTIALS WORK — auth-agnostic. Brief tactical
           reminder so admins onboarding their first mailbox understand
           what the user will and won't be able to do with the password
           shown above, without having to read the credential model doc. --->
      <div class="alert alert-secondary mb-3">
        <h5 class="mb-2"><i class="icon fas fa-key"></i> How mailbox credentials work</h5>
        <ul class="mb-0" style="padding-left: 1.2em;">
          <li>The password above is for <strong>web logins only</strong> &mdash; <code>/users</code> portal and <code>/nc</code> webmail.</li>
          <li><strong>Mail clients</strong> (Thunderbird, Apple Mail, Outlook, iOS, etc.) and <strong>DAV clients</strong> (CalDAV/CardDAV) need an <strong>app password</strong>. The user generates one per device from <code>/users &rarr; My App Passwords</code>; the same plaintext authenticates IMAP, SMTP, CalDAV, and CardDAV. The login password is rejected by all four protocols by design.</li>
          <li><strong>Auto-discovery</strong> works for IMAP/SMTP/CalDAV/CardDAV when the per-domain DNS records are in place (see Email Server &rarr; Domains &rarr; DNS Guide).</li>
          <li><strong>Nextcloud Mail webmail</strong> is provisioned automatically at mailbox creation &mdash; the user does not need to enter IMAP/SMTP server settings manually.</li>
        </ul>
      </div>

      <!--- AUTHENTICATION TYPE (top of form — fields below adapt to selection) --->
      <cfif remoteauthAvailable>
        <div class="form-group mb-3">
          <label><strong>Authentication Type</strong></label>
          <div class="alert alert-info">
            <h5><i class="icon fas fa-info-circle"></i> Remote Authentication</h5>
            <p class="mb-0">Select <strong>Remote</strong> to authenticate this mailbox user against an external AD/LDAP server. The user will use their existing organization credentials &mdash; no local password will be created.</p>
          </div>
          <select class="form-control" name="auth_type" id="authType" style="width: 100%;">
            <option value="local" selected>Local</option>
            <option value="remote">Remote</option>
          </select>
        </div>

        <!--- RemoteAuth Domain Selection --->
        <div class="form-group mb-3" id="remoteauthDomainGroup" style="display:none;">
          <label><strong>RemoteAuth Domain</strong></label>
          <select class="form-control" name="remoteauth_domain" id="remoteauthDomain" style="width: 100%;">
            <option value="">-- Select Domain --</option>
            <cfloop array="#remoteauthDomains#" index="domainItem">
              <option value="#domainItem.domain#" data-pattern="#HTMLEditFormat(domainItem.pattern)#">#domainItem.domain# (#domainItem.server#)</option>
            </cfloop>
          </select>
          <small class="text-muted">Select the domain this user will authenticate against</small>
        </div>

        <!--- DN Pattern Guidance --->
        <div class="form-group mb-3" id="dnPatternGuidance" style="display:none;">
          <div class="alert alert-secondary">
            <h5><i class="icon fas fa-sitemap"></i> DN Pattern</h5>
            <p>This user will be authenticated against the remote server using this DN pattern:</p>
            <p><code id="dnPatternDisplay"></code></p>
            <p class="mb-0"><small><strong>How placeholders are resolved:</strong><br>
            <code>{username}</code> &rarr; local part of email (e.g., <em>jsmith</em>)<br>
            <code>{email}</code> &rarr; full email address (e.g., <em>jsmith@example.com</em>)<br>
            <code>{firstname}</code> / <code>{lastname}</code> &rarr; the First Name / Last Name fields below</small></p>
          </div>
        </div>

        <!--- REMOTE-AUTH NOTICE — under the unified credential model
             (#197 Phase 1 + 1b) the remote-auth user experience is
             functionally identical to local-auth. The only practical
             difference is where the web-login password lives. This
             notice exists to flag that delegation so admins know what
             they can/can't help the user with. --->
        <div class="form-group mb-3" id="remoteAuthDavNotice" style="display:none;">
          <div class="alert alert-info">
            <h5 class="mb-2"><i class="icon fas fa-info-circle"></i> What's different about Remote-Auth</h5>
            <p class="mb-2">Remote-auth users sign in to <code>/users</code> and <code>/nc</code> with their <strong>organization (AD/LDAP) password via SSO/OIDC</strong>. Hermes never sees that password &mdash; it lives entirely in your AD/LDAP. Everything else (NC Mail, app passwords, auto-discovery) works the same as local-auth.</p>
            <p class="mb-0"><small><strong>Practical implication for admins:</strong> you cannot recover or reset the user's web-login password from Hermes &mdash; that's owned by your AD/LDAP. You <em>can</em> still revoke per-device app passwords and rotate the NC internal password from the Actions menu on this page.</small></p>
          </div>
        </div>

        <!--- First / Last Name (revealed when pattern needs them) --->
        <div class="form-group mb-3" id="remoteFirstNameGroup" style="display:none;">
          <label><strong>First Name</strong> <span class="text-danger">*</span></label>
          <input type="text" class="form-control" name="remote_first_name" id="remoteFirstName" placeholder="e.g. John">
          <small class="text-muted">Must match the user's <code>givenName</code> spelling in your AD/LDAP. Active Directory matches case-insensitively; some OpenLDAP servers are case-sensitive.</small>
        </div>
        <div class="form-group mb-3" id="remoteLastNameGroup" style="display:none;">
          <label><strong>Last Name</strong> <span class="text-danger">*</span></label>
          <input type="text" class="form-control" name="remote_last_name" id="remoteLastName" placeholder="e.g. Smith">
          <small class="text-muted">Must match the user's <code>sn</code> / <code>surname</code> spelling in your AD/LDAP. Active Directory matches case-insensitively; some OpenLDAP servers are case-sensitive.</small>
        </div>

      <cfelseif isPro>
        <!--- Pro Edition but RemoteAuth not fully configured --->
        <div class="form-group mb-3">
          <label><strong>Authentication Type</strong></label>
          <select class="form-control" name="auth_type" id="authType" style="width: 100%;" disabled>
            <option value="local" selected>Local</option>
            <option value="remote">Remote</option>
          </select>
          <small class="text-muted">#remoteauthDisabledReason#</small>
        </div>
      <cfelse>
        <!--- Community Edition - show locked with upsell --->
        <input type="hidden" name="auth_type" value="local">
        <div class="form-group mb-3">
          <label><strong>Authentication Type</strong></label>
          <select class="form-control" style="width: 100%;" disabled>
            <option selected>Local</option>
            <option disabled>Remote (Pro License Required)</option>
          </select>
          <small class="text-muted"><i class="fas fa-crown text-warning"></i> Remote Authentication requires a <strong>Pro License</strong>.</small>
        </div>
      </cfif>

      <!--- EMAIL ADDRESS (username + domain) --->
      <div class="form-group mb-3">
        <label><strong>Email Address</strong></label>
        <div class="input-group">
          <input type="text" class="form-control" name="username" placeholder="username" required
                 pattern="[a-zA-Z0-9._-]+" title="Use only letters, numbers, dots, hyphens, and underscores">
          <span class="input-group-text">@</span>
          <select class="form-control" name="domain_id" id="domainSelect" required>
            <cfloop query="getMailboxDomains">
              <option value="#id#" data-quota="#default_quota_mb#" data-nextcloud="#nextcloud_enabled#">#domain#</option>
            </cfloop>
          </select>
        </div>
      </div>

      <!--- DISPLAY NAME --->
      <div class="form-group mb-3">
        <label><strong>Display Name</strong></label>
        <input type="text" class="form-control" name="display_name" placeholder="John Smith (optional)">
      </div>

      <!--- PASSWORD (required for local auth, hidden for remote) --->
      <div class="form-group mb-3" id="passwordGroup">
        <label><strong>Password</strong></label>
        <div class="input-group">
          <input type="password" class="form-control" name="password" id="passwordInput" minlength="12" required
                 placeholder="Minimum 12 characters">
          <button class="btn btn-outline-secondary" type="button" id="togglePassword" title="Show/Hide Password">
            <i class="fas fa-eye" id="togglePasswordIcon"></i>
          </button>
          <button class="btn btn-outline-primary" type="button" id="generatePassword" title="Generate Password">
            <i class="fas fa-random"></i> Generate
          </button>
        </div>
        <small class="text-muted">Minimum 12 characters. No special characters. Password will be checked against known data breaches.</small>
      </div>

      <!--- QUOTA --->
      <div class="form-group mb-3">
        <label><strong>Mailbox Quota (GB)</strong></label>
        <input type="number" class="form-control" name="quota_gb" id="quotaInput" step="0.01" min="0.01" required
               value="<cfif getMailboxDomains.default_quota_mb GT 0>#NumberFormat(getMailboxDomains.default_quota_mb / 1024, '0.0')#<cfelse>5.0</cfif>">
        <small class="text-muted">Default from domain: <span id="domainQuotaHint"><cfif getMailboxDomains.default_quota_mb GT 0>#NumberFormat(getMailboxDomains.default_quota_mb / 1024, '0.0')# GB<cfelse>5.0 GB</cfif></span></small>
      </div>

      <!--- SVF POLICY --->
      <cfquery name="getDefaultPolicy" datasource="hermes">
        SELECT policy_id, policy_name, default_policy FROM spam_policies WHERE default_policy = '1'
      </cfquery>
      <cfquery name="getUserPolicies" datasource="hermes">
        SELECT policy_id, policy_name FROM spam_policies
        WHERE custom = '1' AND system <> '1' AND policy_id <> '#getDefaultPolicy.policy_id#'
        ORDER BY policy_name ASC
      </cfquery>

      <div class="form-group mb-3">
        <label><strong>SVF Policy to Assign</strong></label>
        <select class="form-control" name="policy" style="width: 100%;">
          <option value="#getDefaultPolicy.policy_id#" selected="selected">#getDefaultPolicy.policy_name#</option>
          <cfloop query="getUserPolicies">
            <option value="#policy_id#">#policy_name#</option>
          </cfloop>
        </select>
      </div>

      <!--- TIMEZONE - defaults to System Settings > Timezone --->
      <cfinclude template="./inc/get_user_timezone.cfm">
      <cfset defaultTz = getSystemTimezone()>
      <cfset zoneIdClass = createObject("java", "java.time.ZoneId")>
      <cfset availableZones = zoneIdClass.getAvailableZoneIds().toArray()>
      <cfset tzList = []>
      <cfloop array="#availableZones#" index="z">
          <cfset ArrayAppend(tzList, z)>
      </cfloop>
      <cfset ArraySort(tzList, "textnocase")>
      <div class="form-group mb-3">
        <label><strong>Timezone</strong></label>
        <p class="help-block">Defaults to the system timezone (<code><cfoutput>#defaultTz#</cfoutput></code> from System Settings). The user can change their own timezone later from Account Settings in the user portal. Used for vacation auto-reply scheduling and dashboard timestamps.</p>
        <select class="form-control" name="timezone" id="addMailboxTimezone" style="width:100%;">
          <cfloop array="#tzList#" index="z">
            <option value="#z#"<cfif z EQ defaultTz> selected</cfif>>#z#</option>
          </cfloop>
        </select>
      </div>

      <!--- QUARANTINE NOTIFICATIONS --->
      <div class="form-group mb-3">
        <label><strong>Quarantine Notifications</strong></label>
        <p class="help-block">When enabled, users receive an email notification each time a message is quarantined, with a one-click release button.</p>
        <select class="form-control" name="reports" style="width: 100%">
          <option value="YES" selected="selected">Enabled</option>
          <option value="NO">Disabled</option>
        </select>
      </div>

      <!--- TRAIN BAYES --->
      <div class="form-group mb-3">
        <label><strong>Train Bayes Filter from User Portal</strong></label>
        <div class="alert alert-danger">
          <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
          <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
        </div>
        <select class="form-control" name="train_bayes" style="width: 100%">
          <option value="0" selected="selected">Disable</option>
          <option value="1">Enable</option>
        </select>
      </div>

      <!--- DOWNLOAD MESSAGES --->
      <div class="form-group mb-3">
        <label><strong>Download Messages from User Portal</strong></label>
        <div class="alert alert-danger">
          <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
          <p>Enabling can expose recipients to malware</p>
        </div>
        <select class="form-control" name="download_msg" style="width: 100%">
          <option value="0" selected="selected">Disable</option>
          <option value="1">Enable</option>
        </select>
      </div>

      <!--- NEXTCLOUD TOGGLE --->
      <div class="form-group mb-3">
        <label><strong>Nextcloud Webmail</strong></label>
        <div class="alert alert-info">
          <i class="icon fas fa-info-circle"></i>
          When enabled, this mailbox user will be provisioned in Nextcloud for webmail access. Default is inherited from the domain setting.
        </div>
        <select class="form-control" name="nextcloud_enabled" id="nextcloudEnabled" style="width: 100%">
          <option value="0">Disable</option>
          <option value="1"<cfif getMailboxDomains.nextcloud_enabled EQ 1> selected</cfif>>Enable</option>
        </select>
      </div>

      <!--- ENCRYPTION SECTION --->
      <div class="alert alert-info mb-3">
        <h5><i class="icon fas fa-info-circle"></i> Please Note!</h5>
        When S/MIME or PGP Encryption is enabled, certificates and keyrings will be generated in the background after the mailbox is created. You can monitor progress from the Mailboxes page.
      </div>

      <!--- PDF ENCRYPTION --->
      <div class="form-group mb-3">
        <label><strong>PDF Encryption</strong></label>
        <select class="form-control" name="pdf_enabled" style="width: 100%">
          <option value="2" selected="selected">Disable</option>
          <option value="1">Enable</option>
        </select>
      </div>

      <!--- S/MIME ENCRYPTION --->
      <div class="form-group mb-3">
        <label><strong>S/MIME Encryption</strong></label>
        <select class="form-control" name="smime_enabled" id="smime_enabled" style="width: 100%">
          <option value="2" selected="selected">Disable</option>
          <option value="1">Enable</option>
        </select>
      </div>

      <!--- S/MIME OPTIONS --->
      <cfquery name="getDefaultCA" datasource="hermes">
        SELECT id, ca_commonname FROM ca_settings WHERE default2='1'
      </cfquery>
      <cfquery name="getOtherCA" datasource="hermes">
        SELECT id, ca_commonname FROM ca_settings WHERE id <> '#getDefaultCA.id#' ORDER BY ca_commonname ASC
      </cfquery>

      <div id="smime_options" style="display:none;">
        <div class="form-group mb-3">
          <label><strong>Certificate Authority</strong></label>
          <select class="form-control" name="ca" style="width: 100%;">
            <option value="#getDefaultCA.id#" selected="selected">#getDefaultCA.ca_commonname#</option>
            <cfloop query="getOtherCA">
              <option value="#id#">#ca_commonname#</option>
            </cfloop>
          </select>
        </div>
        <div class="form-group mb-3">
          <label><strong>Certificate Validity Period</strong></label>
          <select class="form-control" name="validity" style="width: 100%;">
            <option value="1825" selected="selected">5 Years</option>
            <option value="1460">4 Years</option>
            <option value="1095">3 Years</option>
            <option value="730">2 Years</option>
            <option value="365">1 Year</option>
          </select>
        </div>
        <div class="form-group mb-3">
          <label><strong>Certificate Key Length</strong></label>
          <select class="form-control" name="cert_encryption" style="width: 100%;">
            <option value="2048" selected="selected">2048-bit (Recommended)</option>
            <option value="4096">4096-bit (High Security)</option>
          </select>
        </div>
        <div class="form-group mb-3">
          <label><strong>Certificate Hash Algorithm</strong></label>
          <select class="form-control" name="cert_algorithm" style="width: 100%;">
            <option value="sha256" selected="selected">SHA-256 (Recommended)</option>
            <option value="sha512">SHA-512 (High Security)</option>
          </select>
        </div>
      </div>

      <!--- S/MIME SIGNATURE --->
      <div class="form-group mb-3">
        <label><strong>S/MIME Signature</strong></label>
        <p class="help-block">Effective only when S/MIME Certificate present</p>
        <select class="form-control" name="sign" style="width: 100%">
          <option value="2" selected="selected">Sign Encrypted Messages Only</option>
          <option value="1">Sign all messages</option>
        </select>
      </div>

      <!--- PGP ENCRYPTION --->
      <div class="form-group mb-3">
        <label><strong>PGP Encryption</strong></label>
        <select class="form-control" name="pgp_enabled" id="pgp_enabled" style="width: 100%">
          <option value="2" selected="selected">Disable</option>
          <option value="1">Enable</option>
        </select>
      </div>

      <!--- PGP OPTIONS --->
      <div id="pgp_options" style="display:none;">
        <div class="form-group mb-3">
          <label><strong>PGP Key Size</strong></label>
          <select class="form-control" name="pgp_encryption" style="width: 100%;">
            <option value="2048" selected="selected">2048-bit (Recommended)</option>
            <option value="4096">4096-bit (High Security)</option>
          </select>
        </div>
        <div class="alert alert-info">
          <i class="icon fas fa-info-circle"></i>
          The local part of the email address will be automatically used as the PGP key Real Name (e.g., "jsmith" from "jsmith@example.com").
        </div>
      </div>

      <!--- SUBMIT --->
      <div class="box-footer">
        <input type="submit" class="btn btn-primary" value="Create Mailbox" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
      </div>

    </div>
    </cfoutput>
  </div>
</form>

<div>&nbsp;</div>

<!--- /CFIF getMailboxDomains.recordcount --->
</cfif>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>

<script>

  $(document).ready(function() {
    if (typeof TomSelect !== 'undefined') {
      new TomSelect('#addMailboxTimezone', {
        create: false,
        sortField: { field: 'text', direction: 'asc' },
        maxOptions: 1000
      });
    }
  });

  // Update quota default and Nextcloud toggle when domain changes
  $('#domainSelect').on('change', function() {
    var selected = $(this).find(':selected');
    var quotaMb = selected.data('quota');
    if (quotaMb && quotaMb > 0) {
      var quotaGb = (quotaMb / 1024).toFixed(1);
      $('#quotaInput').val(quotaGb);
      $('#domainQuotaHint').text(quotaGb + ' GB');
    }
    var nc = selected.data('nextcloud');
    $('#nextcloudEnabled').val(nc == 1 ? '1' : '0');
  });

  // Generate random password (16 chars, alphanumeric only)
  function generatePassword(length) {
    var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var password = '';
    var array = new Uint32Array(length);
    window.crypto.getRandomValues(array);
    for (var i = 0; i < length; i++) {
      password += chars[array[i] % chars.length];
    }
    return password;
  }

  // Generate password button
  $('#generatePassword').on('click', function() {
    var pwd = generatePassword(16);
    $('#passwordInput').val(pwd).attr('type', 'text');
    $('#togglePasswordIcon').removeClass('fa-eye').addClass('fa-eye-slash');
  });

  // Password show/hide toggle
  $('#togglePassword').on('click', function() {
    var input = $('#passwordInput');
    var icon = $('#togglePasswordIcon');
    if (input.attr('type') === 'password') {
      input.attr('type', 'text');
      icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
      input.attr('type', 'password');
      icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
  });

  // Show/hide S/MIME options
  $('#smime_enabled').on('change', function() {
    if ($(this).val() === '1') {
      $('#smime_options').show();
    } else {
      $('#smime_options').hide();
    }
  });

  // Show/hide PGP options
  $('#pgp_enabled').on('change', function() {
    if ($(this).val() === '1') {
      $('#pgp_options').show();
    } else {
      $('#pgp_options').hide();
    }
  });

  // Show/hide RemoteAuth options and password field
  $('#authType').on('change', function() {
    if ($(this).val() === 'remote') {
      $('#remoteauthDomainGroup').show();
      $('#remoteAuthDavNotice').show();
      $('#passwordGroup').hide();
      $('#passwordInput').prop('required', false);
    } else {
      $('#remoteauthDomainGroup').hide();
      $('#dnPatternGuidance').hide();
      $('#remoteAuthDavNotice').hide();
      $('#remoteauthDomain').val('');
      $('#passwordGroup').show();
      $('#passwordInput').prop('required', true);
      hideRemoteNameFields();
    }
  });

  // Reveal First/Last Name fields only when the selected pattern references them.
  // Requiring real AD values keeps the seeAlso DN resolvable for remoteauth.
  function updateRemoteNameFields(pattern) {
    var needsFirst = /\{firstname\}/i.test(pattern || '');
    var needsLast  = /\{lastname\}/i.test(pattern || '');
    $('#remoteFirstNameGroup').toggle(needsFirst);
    $('#remoteLastNameGroup').toggle(needsLast);
    $('#remoteFirstName').prop('required', needsFirst);
    $('#remoteLastName').prop('required', needsLast);
    if (!needsFirst) $('#remoteFirstName').val('');
    if (!needsLast)  $('#remoteLastName').val('');
  }
  function hideRemoteNameFields() {
    updateRemoteNameFields('');
  }

  // Show DN pattern guidance and First/Last Name fields when a domain is selected
  $('#remoteauthDomain').on('change', function() {
    var selected = $(this).find(':selected');
    var pattern = selected.data('pattern');
    if (pattern) {
      $('#dnPatternDisplay').text(pattern);
      $('#dnPatternGuidance').show();
      updateRemoteNameFields(pattern);
    } else {
      $('#dnPatternGuidance').hide();
      hideRemoteNameFields();
    }
    updateLoginPreview();
  });

  // ================================================================
  // LOGIN PREVIEW — keep in sync with form inputs so admin sees the
  // exact username/URL/password-source the mailbox user will need.
  // ================================================================
  function updateLoginPreview() {
    var usernameField = $('input[name="username"]').val() || '';
    var domainText = $('#domainSelect option:selected').text() || '';
    var fullEmail = usernameField && domainText ? (usernameField + '@' + domainText) : 'username@domain';
    $('#lpUsername').text(fullEmail);

    var authType = $('#authType').val() || 'local';
    if (authType === 'remote') {
      var rdomain = $('#remoteauthDomain option:selected').text() || 'the selected RemoteAuth domain';
      // Strip the "(server)" suffix for readability
      rdomain = rdomain.replace(/\s*\(.+\)\s*$/, '');
      if (rdomain === '-- Select Domain --') rdomain = 'the selected RemoteAuth domain';
      $('#lpPassword').html('The <strong>remote password</strong> from <code>' + rdomain + '</code> (their AD/LDAP account password).');
    } else {
      $('#lpPassword').html('The <strong>local password</strong> you set in the Password field below.');
    }
  }
  $('input[name="username"]').on('input', updateLoginPreview);
  $('#domainSelect').on('change', updateLoginPreview);
  $('#authType').on('change', updateLoginPreview);
  $(document).ready(updateLoginPreview);

</script>

</html>
