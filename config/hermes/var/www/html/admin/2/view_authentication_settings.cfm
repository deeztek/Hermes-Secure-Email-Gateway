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
  <title>Hermes SEG | Authentication Settings</title>
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
            <h1 class="m-0">Authentication Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Authentication Settings</li>
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
<cfinclude template="./inc/get_authelia_settings.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "edit">
  <cfinclude template="./inc/edit_authelia_settings.cfm">
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
<cfelseif action contains "generate">
  <cfinclude template="./inc/auth_generate_secret.cfm">
</cfif>

<!--- Re-load after actions --->
<cfinclude template="./inc/get_authelia_settings.cfm">

<cfset session.m = "">

<!--- Data-driven error/success messages --->
<cfset _alerts = {
  "1":{type:"danger", msg:"The JWT Secret field cannot be blank."},
  "2":{type:"danger", msg:"Invalid JWT Secret. Only letters (A-Z, a-z) and numbers (0-9) allowed."},
  "3":{type:"danger", msg:"The JWT Secret should be at least 24 characters for best security."},
  "4":{type:"danger", msg:"The Session Name field cannot be blank."},
  "5":{type:"danger", msg:"Invalid Session Name. Only letters, numbers, underscores and dashes allowed."},
  "6":{type:"danger", msg:"The Session Secret field cannot be blank."},
  "7":{type:"danger", msg:"Invalid Session Secret. Only letters (A-Z, a-z) and numbers (0-9) allowed."},
  "8":{type:"danger", msg:"The Session Secret should be at least 24 characters for best security."},
  "9":{type:"danger", msg:"The Session Expiration field cannot be blank."},
  "10":{type:"danger", msg:"Invalid Session Expiration. Only numbers (0-9) allowed."},
  "11":{type:"danger", msg:"The Session Inactivity field cannot be blank."},
  "12":{type:"danger", msg:"Invalid Session Inactivity. Only numbers (0-9) allowed."},
  "13":{type:"danger", msg:"The SMTP Host field cannot be blank."},
  "14":{type:"danger", msg:"Invalid SMTP Host. Only letters, numbers, underscores, dashes, brackets and periods allowed."},
  "15":{type:"danger", msg:"The SMTP Port field cannot be blank."},
  "16":{type:"danger", msg:"Invalid SMTP Port. Only numbers (0-9) allowed."},
  "17":{type:"danger", msg:"The SMTP From Address field cannot be blank."},
  "18":{type:"danger", msg:"The SMTP From Address must be a valid e-mail address."},
  "19":{type:"danger", msg:"The SMTP E-mail Subject field cannot be blank."},
  "20":{type:"danger", msg:"Invalid SMTP E-mail Subject. Only letters, numbers, underscores, dashes, brackets and curly brackets allowed."},
  "21":{type:"danger", msg:"The Login Failures field cannot be blank."},
  "22":{type:"danger", msg:"Invalid Login Failures. Only numbers (0-9) allowed."},
  "23":{type:"danger", msg:"The Time Between Failed Logins field cannot be blank."},
  "24":{type:"danger", msg:"Invalid Time Between Failed Logins. Only numbers (0-9) allowed."},
  "25":{type:"danger", msg:"The Banned Time field cannot be blank."},
  "26":{type:"danger", msg:"Invalid Banned Time. Only numbers (0-9) allowed."},
  "27":{type:"success", msg:"Authentication settings saved successfully."},
  "28":{type:"success", msg:"Password Reset JWT Secret generated successfully."},
  "29":{type:"success", msg:"Session Secret generated successfully."},
  "30":{type:"success", msg:"Storage Encryption Key generated successfully."},
  "31":{type:"danger", msg:"The Duo Hostname field cannot be blank when Duo is enabled."},
  "32":{type:"danger", msg:"Invalid Duo Hostname."},
  "33":{type:"danger", msg:"The Duo Integration Key field cannot be blank when Duo is enabled."},
  "34":{type:"danger", msg:"Invalid Duo Integration Key."},
  "35":{type:"danger", msg:"The Duo Secret Key field cannot be blank when Duo is enabled."},
  "36":{type:"danger", msg:"Invalid Duo Secret Key."},
  "37":{type:"danger", msg:"The Storage Encryption Key field cannot be blank."},
  "38":{type:"danger", msg:"Invalid Storage Encryption Key."},
  "39":{type:"danger", msg:"The Storage Encryption Key should be at least 24 characters."},
  "40":{type:"success", msg:"Webmail OIDC Key generated successfully."},
  "41":{type:"success", msg:"Session Provider Password generated successfully."},
  "42":{type:"success", msg:"Webmail OIDC Secret generated successfully."},
  "43":{type:"success", msg:"Webmail OIDC Client Secret generated successfully."},
  "44":{type:"danger", msg:"The Remember Me Duration field cannot be blank. Use a positive number of seconds, or -1 to disable the Remember Me checkbox."},
  "45":{type:"danger", msg:"Invalid Remember Me Duration. Only digits (0-9) or the literal value -1 are allowed."},
  "46":{type:"danger", msg:"Invalid Nextcloud Auto-Redirect to SSO value. Only true or false are allowed."}
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

<form name="edit_authentication" method="post" autocomplete="off">
<input type="hidden" name="action" value="edit">

<!-- GENERAL SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> General Settings</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Password Reset JWT Secret</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#jwt_secret#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generatejwtsecret', 'Password Reset JWT Secret');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Reset Password Function</strong></label>
          <select class="form-select" name="authentication_backend_disable_reset_password">
            <option value="false" <cfif authentication_backend_disable_reset_password.value2 is "false">selected</cfif>>Enable</option>
            <option value="true" <cfif authentication_backend_disable_reset_password.value2 is "true">selected</cfif>>Disable</option>
          </select>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Storage Encryption Key</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#storage_encryption_key#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generatestorageencryptionkey', 'Storage Encryption Key');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
          <div class="callout callout-danger mt-2">
            <p class="mb-0"><small><i class="icon fas fa-exclamation-triangle"></i> <strong>DO NOT</strong> generate a new Storage Encryption Key unless compromised. This will break authentication and remove all user 2FA devices. See <a href="#" onclick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/admin-authentication#bkmrk-storage-encryption-k', '_blank')">documentation</a>.</small></p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- SESSION SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-clock"></i> Session Settings</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-info">
      <h5 class="mb-2"><i class="fas fa-info-circle me-1"></i> Session Termination Compliance Reference</h5>
      <p class="mb-2">The two timeout values below affect your compliance posture under <strong>NIST SP 800-53 rev 5 AC-12</strong> (Session Termination) and <strong>NIST SP 800-63B</strong> (Digital Identity Guidelines). Both fields below are in <strong>seconds</strong>.</p>
      <ul class="mb-2">
        <li><strong>Session Expiration</strong>: absolute session lifetime from login, regardless of activity. NIST 800-63B requires reauthentication at least every <strong>12 hours</strong> for both AAL2 and AAL3 extended sessions. Recommended value: <strong>43200</strong> seconds (12h).</li>
        <li><strong>Session Inactivity</strong>: idle timeout before the session is destroyed. NIST 800-63B requires reauthentication after <strong>30 minutes</strong> of inactivity at AAL2 (typical for email services), or <strong>15 minutes</strong> at AAL3 (high-assurance environments). Recommended value: <strong>1800</strong> seconds (30 min) for AAL2, or <strong>900</strong> seconds (15 min) for AAL3.</li>
      </ul>
      <p class="mb-2"><small>NIST SP 800-53 rev 5 AC-12 itself does not mandate specific durations - it defers to organization-defined values. The numbers above come from NIST SP 800-63B which AC-12 references.</small></p>

      <div class="alert alert-warning mb-0 mt-3">
        <h6 class="mb-2"><i class="fas fa-exclamation-triangle me-1"></i> Important: "Remember Me" interaction</h6>
        <p class="mb-2"><small>When a user ticks <strong>"Remember Me"</strong> at login, Authelia replaces <strong>Session Expiration</strong> with the <strong>Remember Me Duration</strong> setting AND completely <strong>bypasses the Session Inactivity check</strong>. A remembered session lives for the full Remember Me Duration as a hard ceiling regardless of user activity (verified in Authelia v4.39 source code at <code>internal/handlers/handler_authz_authn.go</code> line 495).</small></p>
        <p class="mb-2"><small><strong>Implications for compliance:</strong></small></p>
        <ul class="mb-2"><small>
          <li>If you allow "Remember Me", the inactivity values above only apply to users who do NOT tick the box.</li>
          <li>Set <strong>Remember Me Duration</strong> to a short, bounded value (recommended: <strong>43200</strong> seconds / 12 hours, matching the Session Expiration ceiling) to stay within NIST 800-63B AAL2.</li>
          <li>To <strong>fully disable</strong> the "Remember Me" checkbox and force every user through the Session Expiration + Inactivity path, set Remember Me Duration to <code>-1</code>. This is the only way to guarantee inactivity enforcement for all sessions.</li>
        </small></ul>
        <p class="mb-0"><small>The <strong>Remember Me Duration</strong> field below this card is the configurable value. Set it conservatively (<code>43200</code> for 12h matching the AAL2 ceiling) or set it to <code>-1</code> to disable the Remember Me checkbox entirely.</small></p>
      </div>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Session Name</strong></label>
          <cfoutput><input type="text" class="form-control" name="session_name" value="#encodeForHTMLAttribute(session_name.value2)#" placeholder="Session Name"></cfoutput>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Session Secret</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#session_secret#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generatesessionsecret', 'Session Secret');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Session Provider Password (Redis)</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#redis_password#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generateredispassword', 'Session Provider Password');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Session Expiration</strong> (seconds)</label>
          <cfoutput><input type="text" class="form-control" name="session_expiration" value="#encodeForHTMLAttribute(session_expiration.value2)#" placeholder="Seconds"></cfoutput>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>Session Inactivity</strong> (seconds)</label>
          <cfoutput><input type="text" class="form-control" name="session_inactivity" value="#encodeForHTMLAttribute(session_inactivity.value2)#" placeholder="Seconds"></cfoutput>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div class="mb-3">
          <label class="form-label"><strong>Remember Me Duration</strong> (seconds)</label>
          <cfoutput><input type="text" class="form-control" name="session_remember_me" value="#encodeForHTMLAttribute(session_remember_me.value2)#" placeholder="Seconds, or -1 to disable"></cfoutput>
          <small class="form-text text-muted">When a user ticks "Remember Me" at login, this absolute lifetime replaces Session Expiration AND <strong>bypasses Session Inactivity entirely</strong>. Recommended: <code>43200</code> (12h, NIST 800-63B AAL2 ceiling). Set to <code>-1</code> to remove the "Remember Me" checkbox from the login form and force every user through Session Expiration + Inactivity.</small>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- NEXTCLOUD WEBMAIL SSO CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox"></i> Nextcloud Webmail SSO</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-12">
        <div class="mb-3">
          <label class="form-label"><strong>Auto-Redirect to Hermes SSO</strong></label>
          <cfoutput>
          <select class="form-select" name="nextcloud_oidc_auto_redirect">
            <option value="false" <cfif nextcloud_oidc_auto_redirect.value2 is "false">selected</cfif>>Disabled (show Nextcloud login page)</option>
            <option value="true" <cfif nextcloud_oidc_auto_redirect.value2 is "true">selected</cfif>>Enabled (silent SSO via Authelia)</option>
          </select>
          </cfoutput>
          <small class="form-text text-muted">
            Controls Nextcloud's <code>oidc_login_auto_redirect</code> setting.
            <ul class="mb-0 mt-1">
              <li><strong>Disabled</strong> (default): users clicking "Login to Webmail" land on the Nextcloud login page where they must click the "Click to Login to Webmail" button to complete SSO. Local Nextcloud users (created via <code>occ user:add</code>) can also log in here with their username/password. Two clicks for SSO users.</li>
              <li><strong>Enabled</strong>: users clicking "Login to Webmail" are silently bounced through Authelia OIDC and land in Nextcloud already logged in. One-click SSO. Local Nextcloud users <strong>cannot log in</strong> in this mode because the auto-redirect hijacks the login page before the local password form is reachable.</li>
            </ul>
          </small>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- SMTP NOTIFICATION SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-envelope"></i> SMTP Notification Settings</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>SMTP From Address</strong></label>
          <cfoutput><input type="text" class="form-control" name="notifier_smtp_sender" value="#encodeForHTMLAttribute(notifier_smtp_sender.value2)#" placeholder="noreply@example.com"></cfoutput>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>SMTP E-mail Subject</strong></label>
          <cfoutput><input type="text" class="form-control" name="notifier_smtp_subject" value="#encodeForHTMLAttribute(notifier_smtp_subject.value2)#" placeholder="E-mail Subject"></cfoutput>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- LOGIN REGULATION CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-user-lock"></i> Login Regulation</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Login Failures Before Ban</strong></label>
          <cfoutput><input type="text" class="form-control" name="regulation_max_retries" value="#encodeForHTMLAttribute(regulation_max_retries.value2)#"></cfoutput>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Time Between Failed Logins</strong> (seconds)</label>
          <cfoutput><input type="text" class="form-control" name="regulation_find_time" value="#encodeForHTMLAttribute(regulation_find_time.value2)#"></cfoutput>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Banned Time</strong> (seconds)</label>
          <cfoutput><input type="text" class="form-control" name="regulation_ban_time" value="#encodeForHTMLAttribute(regulation_ban_time.value2)#"></cfoutput>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- LOGGING CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-alt"></i> Logging</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Log Level</strong></label>
          <select class="form-select" name="log_level">
            <cfloop list="trace,debug,info,warn,error" index="lvl">
              <cfoutput><option value="#lvl#" <cfif log_level.value2 is lvl>selected</cfif>>#UCase(Left(lvl,1))##Mid(lvl,2,Len(lvl))#</option></cfoutput>
            </cfloop>
          </select>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Log Format</strong></label>
          <select class="form-select" name="log_format">
            <option value="json" <cfif log_format.value2 is "json">selected</cfif>>JSON</option>
            <option value="text" <cfif log_format.value2 is "text">selected</cfif>>Text</option>
          </select>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Log Retention (Days)</strong></label>
          <cfoutput>
          <select class="form-select" name="log_retention_days">
            <cfloop list="7,15,30,60,90,120,180" index="d">
              <option value="#d#" <cfif logRetentionDays is d>selected</cfif>>#d# Days</option>
            </cfloop>
          </select>
          </cfoutput>
          <small class="form-text text-muted">Number of days to keep rotated Authelia log files.</small>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- DUO SECURITY CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-mobile-alt"></i> Duo Security</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-warning mb-3">
      <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Enabling Duo Security makes <strong>Duo Push available to ALL users</strong>. Ensure you have sufficient Duo licenses before enabling.</p>
    </div>
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Duo Security</strong></label>
          <select class="form-select" name="duo_disable" id="duo_toggle">
            <option value="true" <cfif duo_disable.value2 is "true">selected</cfif>>Disable</option>
            <option value="false" <cfif duo_disable.value2 is "false">selected</cfif>>Enable</option>
          </select>
        </div>
      </div>
    </div>
    <div id="duoFields" <cfif duo_disable.value2 is "true">style="display:none;"</cfif>>
      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Duo Hostname</strong></label>
            <cfoutput><input type="text" class="form-control" name="duo_hostname" value="#encodeForHTMLAttribute(duo_hostname.value2)#" placeholder="api-xxxxxxxx.duosecurity.com" maxlength="64"></cfoutput>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Duo Integration Key</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="duo_integration_key" value="" placeholder="Leave blank to keep current" maxlength="64">
            <small class="text-muted">Current: #encodeForHTML(duo_integration_key)#</small>
            </cfoutput>
          </div>
        </div>
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Duo Secret Key</strong></label>
            <cfoutput>
            <input type="text" class="form-control" name="duo_secret_key" value="" placeholder="Leave blank to keep current" maxlength="64">
            <small class="text-muted">Current: #encodeForHTML(duo_secret_key)#</small>
            </cfoutput>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Duo Self Enrollment</strong></label>
            <select class="form-select" name="duo_self_enrollment">
              <option value="false" <cfif duo_self_enrollment.value2 is "false">selected</cfif>>Disable</option>
              <option value="true" <cfif duo_self_enrollment.value2 is "true">selected</cfif>>Enable</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- WEBMAIL OIDC CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-key"></i> Webmail OIDC (Nextcloud)</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>OIDC HMAC Secret</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#oidc_hmac_secret#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generateoidchmacsecret', 'Webmail OIDC HMAC Secret');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label"><strong>OIDC Client Secret</strong></label>
          <div class="input-group">
            <cfoutput><input type="text" class="form-control" value="#oidc_client_secret#" disabled></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generateoidcclientsecret', 'Webmail OIDC Client Secret');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>OIDC Key</strong></label>
          <div class="input-group">
            <cfoutput><textarea class="form-control" rows="4" disabled>#oidc_key#</textarea></cfoutput>
            <button type="button" class="btn btn-secondary" onclick="showGenerateModal('generateoidckey', 'Webmail OIDC Key');">
              <i class="fas fa-sync"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<button type="submit" class="btn btn-primary mb-4"
  onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
  <i class="fas fa-save"></i> Save &amp; Apply Settings
</button>

</form>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- GENERATE SECRET MODAL (reusable) -->
<div class="modal fade" id="generateModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" id="generateAction" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="generateTitle">Generate Secret</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to generate a new <strong id="generateLabel"></strong>?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger"
            onclick="this.disabled=true;this.innerHTML='Generating...';this.form.submit();">Yes, Generate</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
// Duo toggle
$('#duo_toggle').on('change', function() {
  if ($(this).val() === 'false') {
    $('#duoFields').slideDown();
  } else {
    $('#duoFields').slideUp();
  }
});

// Reusable generate modal
function showGenerateModal(action, label) {
  document.getElementById('generateAction').value = action;
  document.getElementById('generateTitle').textContent = 'Generate ' + label;
  document.getElementById('generateLabel').textContent = label;
  new bootstrap.Modal(document.getElementById('generateModal')).show();
}
</script>

</body>
</html>
