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
    Settings saved and Dovecot configuration regenerated.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    One or more settings failed to save:
    <cfif StructKeyExists(session, "saveErrors") AND IsArray(session.saveErrors) AND ArrayLen(session.saveErrors) GT 0>
      <ul class="mb-0 mt-2">
        <cfloop array="#session.saveErrors#" index="errMsg">
          <cfoutput><li><code>#encodeForHTML(errMsg)#</code></li></cfoutput>
        </cfloop>
      </ul>
      <cfset session.saveErrors = ArrayNew(1)>
    </cfif>
  </div>
</cfif>

<!--- LOAD CURRENT SETTINGS FROM DATABASE --->

<!--- Nextcloud settings --->
<cfquery name="getNcAutoRedirect" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'oidc.auto_redirect'
</cfquery>
<cfset ncAutoRedirect = "false">
<cfif getNcAutoRedirect.recordcount GTE 1>
    <cfset ncAutoRedirect = getNcAutoRedirect.value2>
</cfif>

<cfquery name="getNcHideLoginForm" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'nextcloud' AND parameter = 'hide.login.form'
</cfquery>
<cfset ncHideLoginForm = "false">
<cfif getNcHideLoginForm.recordcount GTE 1>
    <cfset ncHideLoginForm = getNcHideLoginForm.value2>
</cfif>

<!--- Dovecot settings --->
<cfquery name="getDovecotSettings" datasource="hermes">
    SELECT parameter, value2 FROM parameters2
    WHERE module = 'dovecot'
</cfquery>
<cfset dov = StructNew()>
<cfloop query="getDovecotSettings">
    <cfset dov[getDovecotSettings.parameter] = getDovecotSettings.value2>
</cfloop>

<!--- Defaults for fresh installs before schema_updates has run --->
<cfparam name="dov['mail.compression']" default="yes">
<cfparam name="dov['mail.compression_algorithm']" default="lz4">
<cfparam name="dov['mail.compression_level']" default="3">
<cfparam name="dov['mail.encryption']" default="no">
<cfparam name="dov['mail.encryption_curve']" default="prime256v1">
<cfparam name="dov['protocol.imap']" default="yes">
<cfparam name="dov['protocol.pop3']" default="yes">
<cfparam name="dov['ssl.min_protocol']" default="TLSv1.2">
<cfparam name="dov['ssl.cipher_list']" default="ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH">
<cfparam name="dov['quota.warning_critical']" default="99">
<cfparam name="dov['quota.warning_high']" default="95">
<cfparam name="dov['quota.warning_medium']" default="80">
<cfparam name="dov['quota.trash_percentage']" default="110">
<cfparam name="dov['connection.client_limit']" default="1000">
<cfparam name="dov['connection.max_userip']" default="20">
<cfparam name="dov['logging.debug']" default="no">

<!--- TLS Certificate --->
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

<form method="post" action="view_email_server_settings.cfm">
<input type="hidden" name="action" value="save_settings">

<!-- ================================================================== -->
<!-- NEXTCLOUD WEBMAIL SETTINGS CARD                                     -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox"></i> Nextcloud Webmail Settings</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-12">
        <div class="mb-3">
          <label class="form-label"><strong>Auto-Redirect to Hermes SSO</strong></label>
          <select class="form-select" name="nc_auto_redirect" id="nc_auto_redirect">
            <option value="false" <cfif ncAutoRedirect EQ "false">selected</cfif>>Disabled (maintenance mode)</option>
            <option value="true" <cfif ncAutoRedirect EQ "true">selected</cfif>>Enabled (true SSO)</option>
          </select>
          <small class="form-text text-muted">
            <strong>Enabled:</strong> Users clicking "Login to Webmail" are silently redirected through Authelia OIDC and land in Nextcloud already logged in. This is the normal operating mode. To bypass for local admin login, append <code>?direct=1</code> to the Nextcloud login URL.<br>
            <strong>Disabled:</strong> Users see the Nextcloud login page with a username/password form and an SSO button. Use this temporarily when you need to log in as a local Nextcloud admin user for maintenance (e.g., app management, troubleshooting), then re-enable.
          </small>
        </div>
      </div>
      <div class="col-md-12">
        <div class="mb-3">
          <label class="form-label"><strong>Hide Nextcloud Login Form</strong></label>
          <select class="form-select" name="nc_hide_login_form" id="nc_hide_login_form">
            <option value="false" <cfif ncHideLoginForm EQ "false">selected</cfif>>Disabled (show username/password form + SSO button)</option>
            <option value="true" <cfif ncHideLoginForm EQ "true">selected</cfif>>Enabled (show SSO button only)</option>
          </select>
          <small class="form-text text-muted">
            <strong>Enabled:</strong> Users only see the SSO login button on the Nextcloud login page. The username/password form is hidden, preventing users from logging in with local credentials. Administrators can still access the form by appending <code>?direct=1</code> to the login URL (the <strong>Nextcloud Admin</strong> link in the sidebar already does this).<br>
            <strong>Disabled:</strong> Both the SSO button and the username/password form are visible on the login page.
          </small>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ================================================================== -->
<!-- TLS / SSL SETTINGS CARD                                             -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fab fa-expeditedssl"></i> TLS / SSL Settings</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-info">
      <p class="mb-0"><i class="icon fas fa-info-circle"></i> These settings control the TLS certificate and encryption parameters used by the mail server (Dovecot) for IMAP, POP3, and Submission connections. The certificate should match the hostname your users configure in their mail clients (e.g., <code>mail.example.com</code>).</p>
    </div>

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

    <hr>

    <!--- Determine current TLS profile for preset selection --->
    <cfset currentCipherList = dov['ssl.cipher_list']>
    <cfset currentMinProtocol = dov['ssl.min_protocol']>
    <cfset cipherModern = "">
    <cfset cipherIntermediate = "ECDHE+AESGCM:ECDHE+CHACHA20:DHE+AESGCM:DHE+CHACHA20:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4">
    <cfset cipherLegacy = "ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH">

    <!--- Detect which preset matches the current config --->
    <cfset currentPreset = "custom">
    <cfif currentMinProtocol EQ "TLSv1.3" AND (currentCipherList EQ "" OR currentCipherList EQ cipherModern)>
      <cfset currentPreset = "modern">
    <cfelseif currentMinProtocol EQ "TLSv1.2" AND currentCipherList EQ cipherIntermediate>
      <cfset currentPreset = "intermediate">
    <cfelseif currentMinProtocol EQ "TLSv1.2" AND currentCipherList EQ cipherLegacy>
      <cfset currentPreset = "legacy">
    </cfif>

    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>TLS Security Profile</strong></label>
          <select class="form-select" name="ssl_profile" id="ssl_profile">
            <option value="modern" <cfif currentPreset EQ "modern">selected</cfif>>Modern (TLS 1.3 only)</option>
            <option value="intermediate" <cfif currentPreset EQ "intermediate">selected</cfif>>Intermediate (TLS 1.2+, recommended)</option>
            <option value="legacy" <cfif currentPreset EQ "legacy">selected</cfif>>Legacy (TLS 1.2+, broad compatibility)</option>
            <option value="custom" <cfif currentPreset EQ "custom">selected</cfif>>Custom</option>
          </select>
          <small class="form-text text-muted">Based on <a href="https://ssl-config.mozilla.org/" target="_blank">Mozilla Server Side TLS</a> guidelines. Intermediate is recommended for most deployments.</small>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3" id="ssl_min_protocol_group">
          <label class="form-label"><strong>Minimum TLS Version</strong></label>
          <select class="form-select" name="ssl_min_protocol" id="ssl_min_protocol">
            <option value="TLSv1.2" <cfif currentMinProtocol EQ "TLSv1.2">selected</cfif>>TLS 1.2</option>
            <option value="TLSv1.3" <cfif currentMinProtocol EQ "TLSv1.3">selected</cfif>>TLS 1.3</option>
          </select>
          <small class="form-text text-muted">Auto-set by profile. Editable in Custom mode.</small>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3" id="ssl_cipher_group">
          <label class="form-label"><strong>SSL Cipher List</strong></label>
          <input type="text" class="form-control" name="ssl_cipher_list" id="ssl_cipher_list" value="#encodeForHTMLAttribute(currentCipherList)#">
          <small class="form-text text-muted">Auto-set by profile. Editable in Custom mode.</small>
        </div>
      </div>
    </div>

    <div id="ssl_profile_info" class="mb-0"></div>

    </cfoutput>
  </div>
</div>

<!-- ================================================================== -->
<!-- MAIL STORAGE CARD (Compression + Encryption)                        -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-hdd"></i> Mail Storage</h3>
  </div>
  <div class="card-body">

    <!--- COMPRESSION SECTION --->
    <h5><i class="fas fa-compress-arrows-alt"></i> Compression</h5>
    <p class="text-muted">Mail compression reduces disk usage by compressing messages before writing to disk. Only newly delivered or saved messages are affected. Existing messages are not retroactively re-compressed when changing algorithms, and remain fully readable when compression is disabled. Dovecot auto-detects the compression format per-message on read, so a mailbox can safely contain a mix of uncompressed, LZ4, and Zstandard messages.</p>

    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Mail Compression</strong></label>
          <select class="form-select" name="mail_compression" id="mail_compression">
            <option value="yes" <cfif dov['mail.compression'] EQ "yes">selected</cfif>>Enabled</option>
            <option value="no" <cfif dov['mail.compression'] NEQ "yes">selected</cfif>>Disabled</option>
          </select>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Algorithm</strong></label>
          <select class="form-select" name="compression_algorithm" id="compression_algorithm">
            <option value="lz4" <cfif dov['mail.compression_algorithm'] EQ "lz4">selected</cfif>>LZ4 (fastest, good compression)</option>
            <option value="zstd" <cfif dov['mail.compression_algorithm'] EQ "zstd">selected</cfif>>Zstandard (balanced speed/ratio)</option>
            <option value="zlib" <cfif dov['mail.compression_algorithm'] EQ "zlib">selected</cfif>>Zlib/Deflate (best ratio, slowest)</option>
          </select>
          <small class="form-text text-muted">LZ4 is recommended for most deployments. Zstandard offers better compression with slightly higher CPU usage. Zlib has the best ratio but highest CPU overhead.</small>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3" id="compression_level_group">
          <label class="form-label"><strong>Compression Level</strong></label>
          <cfoutput>
          <input type="number" class="form-control" name="compression_level" id="compression_level" value="#encodeForHTMLAttribute(dov['mail.compression_level'])#" min="1" max="22">
          </cfoutput>
          <small class="form-text text-muted" id="compression_level_help">Zstandard: 1-22 (default 3). Zlib: 1-9 (default 6). Higher = better compression, more CPU. Not applicable to LZ4.</small>
        </div>
      </div>
    </div>

    <hr>

    <!--- ENCRYPTION AT REST SECTION --->
    <h5><i class="fas fa-lock"></i> Encryption at Rest</h5>

    <!--- Check if encryption keys exist --->
    <cfset privKeyPath = "/opt/hermes/keys/ecprivkey.pem">
    <cfset pubKeyPath = "/opt/hermes/keys/ecpubkey.pem">
    <cfset keysExist = false>
    <cfset keysEmpty = false>
    <cfif FileExists(privKeyPath) AND FileExists(pubKeyPath)>
        <cfif FileInfo(privKeyPath).size GT 0 AND FileInfo(pubKeyPath).size GT 0>
            <cfset keysExist = true>
        <cfelse>
            <cfset keysEmpty = true>
        </cfif>
    </cfif>

    <div class="alert alert-warning">
      <i class="icon fas fa-exclamation-triangle"></i> <strong>Important:</strong> When enabled, only <strong>newly delivered</strong> mail is encrypted. Existing messages remain unencrypted but fully readable. Disabling encryption later does not affect existing encrypted mail -- it remains readable as long as the keys are present. Once keys are generated, they cannot be regenerated from this page.<br><br><strong>Back up your encryption keys.</strong> The key pair is stored on the Docker host at <code>/opt/hermes/keys/ecprivkey.pem</code> and <code>ecpubkey.pem</code>. If these files are lost, all encrypted mail becomes <strong>permanently unreadable</strong>. There is no recovery mechanism. Include these files in your system backup.
    </div>

    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Encryption at Rest</strong></label>
          <cfif keysExist>
          <select class="form-select" name="mail_encryption" id="mail_encryption">
            <option value="no" <cfif dov['mail.encryption'] NEQ "yes">selected</cfif>>Disabled (default)</option>
            <option value="yes" <cfif dov['mail.encryption'] EQ "yes">selected</cfif>>Enabled</option>
          </select>
          <cfelse>
          <select class="form-select" name="mail_encryption" id="mail_encryption">
            <option value="no" selected>Disabled (default)</option>
            <option value="yes">Enabled (will generate keys on save)</option>
          </select>
          </cfif>
        </div>
      </div>
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Elliptic Curve</strong></label>
          <cfif keysExist>
          <!--- Keys exist: show current curve as read-only to prevent mismatch --->
          <cfoutput>
          <input type="hidden" name="encryption_curve" value="#encodeForHTMLAttribute(dov['mail.encryption_curve'])#">
          <input type="text" class="form-control" value="#encodeForHTMLAttribute(dov['mail.encryption_curve'])#" readonly>
          </cfoutput>
          <small class="form-text text-muted">Curve is locked once keys are generated. Changing it would require new keys and make existing encrypted mail unreadable.</small>
          <cfelse>
          <!--- No keys yet: allow curve selection --->
          <select class="form-select" name="encryption_curve" id="encryption_curve">
            <option value="prime256v1" <cfif dov['mail.encryption_curve'] EQ "prime256v1">selected</cfif>>P-256 / prime256v1 (recommended)</option>
            <option value="secp384r1" <cfif dov['mail.encryption_curve'] EQ "secp384r1">selected</cfif>>P-384 / secp384r1</option>
            <option value="secp521r1" <cfif dov['mail.encryption_curve'] EQ "secp521r1">selected</cfif>>P-521 / secp521r1</option>
          </select>
          <small class="form-text text-muted">Select the elliptic curve before enabling encryption. P-256 is widely supported and performant. This cannot be changed after keys are generated.</small>
          </cfif>
        </div>
      </div>
      <div class="col-md-2">
        <div class="mb-3">
          <label class="form-label"><strong>Algorithm</strong></label>
          <div class="form-control-plaintext">
            <code>AES-256-GCM</code>
          </div>
          <small class="form-text text-muted">Industry standard. Hardware-accelerated on modern CPUs.</small>
        </div>
      </div>
      <div class="col-md-2">
        <div class="mb-3">
          <label class="form-label"><strong>Key Status</strong></label>
          <cfif keysExist>
          <div class="form-control-plaintext">
            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Keys Present</span>
          </div>
          <cfelseif keysEmpty>
          <div class="form-control-plaintext">
            <span class="badge bg-danger"><i class="fas fa-exclamation-circle"></i> Keys Empty</span>
            <small class="d-block text-danger mt-1">Key files exist but are empty. Delete from Docker host and re-enable to regenerate.</small>
          </div>
          <cfelse>
          <div class="form-control-plaintext">
            <span class="badge bg-secondary"><i class="fas fa-minus-circle"></i> No Keys</span>
            <small class="d-block text-muted mt-1">Auto-generated on enable.</small>
          </div>
          </cfif>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- ================================================================== -->
<!-- PROTOCOLS & CONNECTIONS CARD                                        -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired"></i> Protocols & Connections</h3>
  </div>
  <div class="card-body">

    <h5><i class="fas fa-plug"></i> Protocols</h5>
    <p class="text-muted">Control which mail protocols are available to end users. Submission (SMTP auth on port 587), Sieve (mail filtering), and LMTP (local delivery from Postfix) are always enabled as they are required for core mail operations.</p>

    <div class="row">
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>IMAP</strong> <small class="text-muted">(993/143)</small></label>
          <select class="form-select" name="protocol_imap">
            <option value="yes" <cfif dov['protocol.imap'] EQ "yes">selected</cfif>>Enabled</option>
            <option value="no" <cfif dov['protocol.imap'] NEQ "yes">selected</cfif>>Disabled</option>
          </select>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>POP3</strong> <small class="text-muted">(995/110)</small></label>
          <select class="form-select" name="protocol_pop3">
            <option value="yes" <cfif dov['protocol.pop3'] EQ "yes">selected</cfif>>Enabled</option>
            <option value="no" <cfif dov['protocol.pop3'] NEQ "yes">selected</cfif>>Disabled</option>
          </select>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Submission</strong> <small class="text-muted">(587)</small></label>
          <input type="text" class="form-control" value="Always Enabled" readonly>
          <small class="form-text text-muted">Required for authenticated mail sending and vacation auto-replies.</small>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Sieve / LMTP</strong> <small class="text-muted">(4190/24)</small></label>
          <input type="text" class="form-control" value="Always Enabled" readonly>
          <small class="form-text text-muted">Required for mail filtering, delivery from Postfix, and ManageSieve.</small>
        </div>
      </div>
    </div>

    <hr>

    <h5><i class="fas fa-tachometer-alt"></i> Connection Limits</h5>

    <div class="row">
      <cfoutput>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Login Service Client Limit</strong></label>
          <input type="number" class="form-control" name="connection_client_limit" value="#encodeForHTMLAttribute(dov['connection.client_limit'])#" min="100" max="10000">
          <small class="form-text text-muted">Maximum number of concurrent connections per login service (IMAP, POP3, Submission, ManageSieve). Default: 1000. Increase for large deployments with many simultaneous users.</small>
        </div>
      </div>
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label"><strong>Max Connections per User per IP</strong></label>
          <input type="number" class="form-control" name="connection_max_userip" value="#encodeForHTMLAttribute(dov['connection.max_userip'])#" min="1" max="1000">
          <small class="form-text text-muted">Limits connections from a single user from a single IP address. Prevents runaway email clients from consuming excessive resources. Default: 20. Set higher if users have many devices or folders open simultaneously.</small>
        </div>
      </div>
      </cfoutput>
    </div>

  </div>
</div>

<!-- ================================================================== -->
<!-- QUOTA SETTINGS CARD                                                 -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-chart-pie"></i> Quota Settings</h3>
  </div>
  <div class="card-body">

    <h5><i class="fas fa-bell"></i> Warning Thresholds</h5>
    <p class="text-muted">When a user's mailbox reaches these thresholds, an email notification is automatically sent. A "back under quota" notification is always sent when usage drops below 100% (not configurable). Per-mailbox quota sizes are set on each mailbox individually.</p>

    <div class="row">
      <cfoutput>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Critical Warning</strong></label>
          <div class="input-group">
            <input type="number" class="form-control" name="quota_warning_critical" value="#encodeForHTMLAttribute(dov['quota.warning_critical'])#" min="1" max="100">
            <span class="input-group-text">%</span>
          </div>
          <small class="form-text text-muted">Triggers "Mailbox Full" notification. Default: 99%</small>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>High Warning</strong></label>
          <div class="input-group">
            <input type="number" class="form-control" name="quota_warning_high" value="#encodeForHTMLAttribute(dov['quota.warning_high'])#" min="1" max="100">
            <span class="input-group-text">%</span>
          </div>
          <small class="form-text text-muted">Triggers "Nearly Full" notification. Default: 95%</small>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Medium Warning</strong></label>
          <div class="input-group">
            <input type="number" class="form-control" name="quota_warning_medium" value="#encodeForHTMLAttribute(dov['quota.warning_medium'])#" min="1" max="100">
            <span class="input-group-text">%</span>
          </div>
          <small class="form-text text-muted">Triggers first warning notification. Default: 80%</small>
        </div>
      </div>
      <div class="col-md-3">
        <div class="mb-3">
          <label class="form-label"><strong>Trash Quota Overage</strong></label>
          <div class="input-group">
            <input type="number" class="form-control" name="quota_trash_percentage" value="#encodeForHTMLAttribute(dov['quota.trash_percentage'])#" min="100" max="200">
            <span class="input-group-text">%</span>
          </div>
          <small class="form-text text-muted">The Trash folder is allowed this percentage of the user's quota, giving headroom to delete messages even when at 100%. Default: 110% (10% overage).</small>
        </div>
      </div>
      </cfoutput>
    </div>

  </div>
</div>

<!-- ================================================================== -->
<!-- LOGGING CARD                                                        -->
<!-- ================================================================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-alt"></i> Logging</h3>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label"><strong>Debug Logging</strong></label>
          <select class="form-select" name="logging_debug">
            <option value="no" <cfif dov['logging.debug'] NEQ "yes">selected</cfif>>Disabled (production)</option>
            <option value="yes" <cfif dov['logging.debug'] EQ "yes">selected</cfif>>Enabled (troubleshooting)</option>
          </select>
          <small class="form-text text-muted">Enables verbose debug logging for mail and auth categories. Useful for troubleshooting delivery or authentication issues. <strong>Disable in production</strong> as it generates significant log volume. Logs are written to <code>/logs/dovecot-debug.log</code> inside the Dovecot container.</small>
        </div>
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

  // Compression level visibility — hide for LZ4 (no configurable level)
  function updateCompressionUI() {
    var algo = $('#compression_algorithm').val();
    var compressionEnabled = $('#mail_compression').val() === 'yes';

    if (!compressionEnabled) {
      $('#compression_algorithm').prop('disabled', true);
      $('#compression_level').prop('disabled', true);
      $('#compression_level_group').hide();
    } else {
      $('#compression_algorithm').prop('disabled', false);

      if (algo === 'lz4') {
        $('#compression_level_group').hide();
        $('#compression_level').prop('disabled', true);
      } else {
        $('#compression_level_group').show();
        $('#compression_level').prop('disabled', false);

        if (algo === 'zstd') {
          $('#compression_level').attr('max', 22);
          $('#compression_level_help').text('Zstandard level: 1-22 (default 3). Higher = better compression, more CPU.');
        } else if (algo === 'zlib') {
          $('#compression_level').attr('max', 9);
          if (parseInt($('#compression_level').val()) > 9) {
            $('#compression_level').val(6);
          }
          $('#compression_level_help').text('Zlib level: 1-9 (default 6). Higher = better compression, more CPU.');
        }
      }
    }
  }

  // Encryption curve visibility — disable when encryption is off
  function updateEncryptionUI() {
    var encryptionEnabled = $('#mail_encryption').val() === 'yes';
    $('#encryption_curve').prop('disabled', !encryptionEnabled);
  }

  // TLS profile presets (Mozilla Server Side TLS guidelines)
  var sslProfiles = {
    modern: {
      min_protocol: 'TLSv1.3',
      cipher_list: '',
      info: '<div class="alert alert-info mb-0"><small><strong>Modern:</strong> TLS 1.3 only. No cipher list needed (OpenSSL selects TLS 1.3 ciphers automatically). Only for environments where all mail clients support TLS 1.3. Excludes Outlook 2016 and older, Thunderbird < 78, iOS < 12.2, Android < 10.</small></div>'
    },
    intermediate: {
      min_protocol: 'TLSv1.2',
      cipher_list: 'ECDHE+AESGCM:ECDHE+CHACHA20:DHE+AESGCM:DHE+CHACHA20:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4',
      info: '<div class="alert alert-success mb-0"><small><strong>Intermediate (recommended):</strong> TLS 1.2+ with strong AEAD ciphers (AES-GCM, ChaCha20-Poly1305) and forward secrecy (ECDHE/DHE). Compatible with Outlook 2013+, Thunderbird 27+, iOS 9+, Android 4.4+.</small></div>'
    },
    legacy: {
      min_protocol: 'TLSv1.2',
      cipher_list: 'ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH',
      info: '<div class="alert alert-warning mb-0"><small><strong>Legacy:</strong> TLS 1.2+ with broad cipher support. Allows older cipher suites for maximum compatibility with legacy mail clients. Not recommended for new deployments.</small></div>'
    },
    custom: {
      info: '<div class="alert alert-secondary mb-0"><small><strong>Custom:</strong> Manually configure the minimum TLS version and cipher list. Only use if you have specific requirements not covered by the presets.</small></div>'
    }
  };

  function updateSslProfileUI() {
    var profile = $('#ssl_profile').val();
    var p = sslProfiles[profile];

    $('#ssl_profile_info').html(p.info);

    if (profile === 'custom') {
      $('#ssl_min_protocol').prop('disabled', false);
      $('#ssl_cipher_list').prop('readonly', false);
    } else {
      $('#ssl_min_protocol').val(p.min_protocol).prop('disabled', true);
      $('#ssl_cipher_list').val(p.cipher_list).prop('readonly', true);
    }
  }

  $(document).ready(function() {
    updateCompressionUI();
    updateEncryptionUI();
    updateSslProfileUI();

    $('#mail_compression, #compression_algorithm').on('change', updateCompressionUI);
    $('#mail_encryption').on('change', updateEncryptionUI);
    $('#ssl_profile').on('change', updateSslProfileUI);

    // Re-enable disabled fields before form submission so their values are sent
    $('form').on('submit', function() {
      $(this).find(':disabled').prop('disabled', false);
    });
  });
</script>

</body>
</html>
