<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Transactional Emails</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m") AND session.m NEQ "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>

<cfif NOT StructKeyExists(session, "transactionalEmailCsrf") OR session.transactionalEmailCsrf EQ "">
  <cfset session.transactionalEmailCsrf = hash(createUUID() & now())>
</cfif>

<cfscript>
queryExecute(
    "INSERT INTO parameters2 (parameter, value2, module, active, applied) " &
    "SELECT 'enabled', '0', 'transactional_email', 1, 1 " &
    "WHERE NOT EXISTS (SELECT 1 FROM (SELECT * FROM parameters2) p WHERE p.parameter='enabled' AND p.module='transactional_email')",
    {},
    {datasource: "hermes"}
);
queryExecute(
    "INSERT INTO parameters2 (parameter, value2, module, active, applied) " &
    "SELECT 'messages_per_minute', '60', 'transactional_email', 1, 1 " &
    "WHERE NOT EXISTS (SELECT 1 FROM (SELECT * FROM parameters2) p WHERE p.parameter='messages_per_minute' AND p.module='transactional_email')",
    {},
    {datasource: "hermes"}
);
queryExecute(
    "INSERT INTO parameters2 (parameter, value2, module, active, applied) " &
    "SELECT 'messages_per_hour', '5000', 'transactional_email', 1, 1 " &
    "WHERE NOT EXISTS (SELECT 1 FROM (SELECT * FROM parameters2) p WHERE p.parameter='messages_per_hour' AND p.module='transactional_email')",
    {},
    {datasource: "hermes"}
);
queryExecute(
    "INSERT INTO parameters2 (parameter, value2, module, active, applied) " &
    "SELECT 'messages_per_day', '50000', 'transactional_email', 1, 1 " &
    "WHERE NOT EXISTS (SELECT 1 FROM (SELECT * FROM parameters2) p WHERE p.parameter='messages_per_day' AND p.module='transactional_email')",
    {},
    {datasource: "hermes"}
);
</cfscript>

<cfif StructKeyExists(form, "action")>
  <cfif NOT StructKeyExists(form, "csrf_token") OR form.csrf_token NEQ session.transactionalEmailCsrf>
    <cfset m = 98>
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>

  <cfif form.action EQ "save_settings">
    <cfparam name="form.enabled" default="0">
    <cfparam name="form.messages_per_minute" default="60">
    <cfparam name="form.messages_per_hour" default="5000">
    <cfparam name="form.messages_per_day" default="50000">

    <cfset saveEnabled = (form.enabled EQ "1") ? "1" : "0">
    <cfset rpm = max(1, min(100000, val(form.messages_per_minute)))>
    <cfset rph = max(1, min(1000000, val(form.messages_per_hour)))>
    <cfset rpd = max(1, min(10000000, val(form.messages_per_day)))>

    <cfquery datasource="hermes">
      UPDATE parameters2 SET value2 = <cfqueryparam value="#saveEnabled#" cfsqltype="cf_sql_varchar">, applied=2
      WHERE module='transactional_email' AND parameter='enabled'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE parameters2 SET value2 = <cfqueryparam value="#rpm#" cfsqltype="cf_sql_varchar">, applied=2
      WHERE module='transactional_email' AND parameter='messages_per_minute'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE parameters2 SET value2 = <cfqueryparam value="#rph#" cfsqltype="cf_sql_varchar">, applied=2
      WHERE module='transactional_email' AND parameter='messages_per_hour'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE parameters2 SET value2 = <cfqueryparam value="#rpd#" cfsqltype="cf_sql_varchar">, applied=2
      WHERE module='transactional_email' AND parameter='messages_per_day'
    </cfquery>

    <cfset session.m = 1>
    <cflocation url="view_transactional_emails.cfm" addtoken="no">
  </cfif>

  <cfif form.action EQ "create_api_token">
    <cfparam name="form.token_name" default="">
    <cfparam name="form.allowed_sender" default="">
    <cfparam name="form.allowed_domain" default="">
    <cfparam name="form.any_ip" default="1">
    <cfparam name="form.ip_allowlist" default="">

    <cfset tokenName = Left(Trim(form.token_name), 100)>
    <cfset allowedSender = LCase(Left(Trim(form.allowed_sender), 255))>
    <cfset allowedDomain = LCase(Left(Trim(form.allowed_domain), 255))>
    <cfset anyIp = (form.any_ip EQ "1") ? 1 : 0>
    <cfset ipAllowlist = Left(Trim(form.ip_allowlist), 1000)>

    <cfif tokenName EQ "">
      <cfset session.m = 11>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>
    <cfif allowedSender NEQ "" AND NOT IsValid("email", allowedSender)>
      <cfset session.m = 13>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>
    <cfif anyIp EQ 0 AND ipAllowlist EQ "">
      <cfset session.m = 14>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>
    <cfif allowedSender NEQ "" AND allowedDomain NEQ "" AND listLast(allowedSender, "@") NEQ allowedDomain>
      <cfset session.m = 15>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>

    <cfif allowedSender NEQ "">
      <cfset senderDomain = listLast(allowedSender, "@")>
      <cfquery name="getAllowedSenderDomain" datasource="hermes">
        SELECT id FROM domains
        WHERE LOWER(domain) = <cfqueryparam value="#senderDomain#" cfsqltype="cf_sql_varchar">
        LIMIT 1
      </cfquery>
      <cfif getAllowedSenderDomain.recordcount EQ 0>
        <cfset session.m = 16>
        <cflocation url="view_transactional_emails.cfm" addtoken="no">
      </cfif>
    </cfif>

    <cfif allowedDomain NEQ "">
      <cfquery name="getAllowedTokenDomain" datasource="hermes">
        SELECT id FROM domains
        WHERE LOWER(domain) = <cfqueryparam value="#allowedDomain#" cfsqltype="cf_sql_varchar">
        LIMIT 1
      </cfquery>
      <cfif getAllowedTokenDomain.recordcount EQ 0>
        <cfset session.m = 17>
        <cflocation url="view_transactional_emails.cfm" addtoken="no">
      </cfif>
    </cfif>

    <cfset _transLength = 32>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset tokenPlain = "hermes_tx_" & customtrans3>
    <cfset tokenSalt = hash(createUUID() & now())>
    <cfset tokenHash = hash(tokenPlain & ":" & tokenSalt, "SHA-256", "UTF-8")>
    <cfset tokenPrefix = Mid(tokenPlain, 11, 24)>

    <cfquery datasource="hermes">
      INSERT INTO transactional_api_tokens
      (name, token_hash, token_salt, token_prefix, allowed_senders, allowed_domains, any_ip, ip_allowlist, active, created_at)
      VALUES (
        <cfqueryparam value="#tokenName#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#tokenHash#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#tokenSalt#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#tokenPrefix#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#allowedSender#" cfsqltype="cf_sql_varchar" null="#allowedSender EQ ''#">,
        <cfqueryparam value="#allowedDomain#" cfsqltype="cf_sql_varchar" null="#allowedDomain EQ ''#">,
        <cfqueryparam value="#anyIp#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#ipAllowlist#" cfsqltype="cf_sql_varchar" null="#ipAllowlist EQ ''#">,
        1,
        NOW()
      )
    </cfquery>

    <cfset session.newTransactionalApiToken = tokenPlain>
    <cfset session.newTransactionalApiTokenName = tokenName>
    <cfset session.m = 2>
    <cflocation url="view_transactional_emails.cfm" addtoken="no">
  </cfif>

  <cfif form.action EQ "revoke_api_token">
    <cfparam name="form.id" default="">
    <cfif IsNumeric(form.id)>
      <cfquery datasource="hermes">
        UPDATE transactional_api_tokens
        SET active = 0, revoked_at = NOW()
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 3>
    </cfif>
    <cflocation url="view_transactional_emails.cfm" addtoken="no">
  </cfif>

  <cfif form.action EQ "create_smtp_credential">
    <cfparam name="form.credential_name" default="">
    <cfparam name="form.smtp_allowed_sender" default="">
    <cfparam name="form.smtp_allowed_domain" default="">

    <cfset credName = Left(Trim(form.credential_name), 100)>
    <cfset smtpAllowedSender = LCase(Left(Trim(form.smtp_allowed_sender), 255))>
    <cfset smtpAllowedDomain = LCase(Left(Trim(form.smtp_allowed_domain), 255))>

    <cfif credName EQ "">
      <cfset session.m = 12>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>
    <cfif smtpAllowedSender NEQ "" AND NOT IsValid("email", smtpAllowedSender)>
      <cfset session.m = 18>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>
    <cfif smtpAllowedSender NEQ "" AND smtpAllowedDomain NEQ "" AND listLast(smtpAllowedSender, "@") NEQ smtpAllowedDomain>
      <cfset session.m = 19>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfif>

    <cfif smtpAllowedSender NEQ "">
      <cfset smtpSenderDomain = listLast(smtpAllowedSender, "@")>
      <cfquery name="getAllowedSmtpSenderDomain" datasource="hermes">
        SELECT id FROM domains
        WHERE LOWER(domain) = <cfqueryparam value="#smtpSenderDomain#" cfsqltype="cf_sql_varchar">
        LIMIT 1
      </cfquery>
      <cfif getAllowedSmtpSenderDomain.recordcount EQ 0>
        <cfset session.m = 20>
        <cflocation url="view_transactional_emails.cfm" addtoken="no">
      </cfif>
    </cfif>

    <cfif smtpAllowedDomain NEQ "">
      <cfquery name="getAllowedSmtpDomain" datasource="hermes">
        SELECT id FROM domains
        WHERE LOWER(domain) = <cfqueryparam value="#smtpAllowedDomain#" cfsqltype="cf_sql_varchar">
        LIMIT 1
      </cfquery>
      <cfif getAllowedSmtpDomain.recordcount EQ 0>
        <cfset session.m = 21>
        <cflocation url="view_transactional_emails.cfm" addtoken="no">
      </cfif>
    </cfif>

    <cfset _transLength = 16>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset smtpUsername = "smtp_" & customtrans3>
    <cfset _transLength = 32>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cfset smtpPasswordPlain = customtrans3>

    <cftry>
      <cfexecute name="/usr/local/bin/docker"
        arguments='exec -i hermes_dovecot /bin/sh -lc "IFS= read -r pw || [ -n \"$pw\" ]; exec doveadm pw -s ARGON2ID -p \"$pw\""'
        variable="smtpPasswordHash"
        timeout="60">#smtpPasswordPlain#</cfexecute>
      <cfset smtpPasswordHash = Trim(smtpPasswordHash)>
      <cfif smtpPasswordHash EQ "" OR NOT FindNoCase("{ARGON2ID}", smtpPasswordHash)>
        <cfthrow message="Credential hash generation failed">
      </cfif>
    <cfcatch type="any">
      <cfset session.m = 30>
      <cflocation url="view_transactional_emails.cfm" addtoken="no">
    </cfcatch>
    </cftry>

    <cfquery datasource="hermes">
      INSERT INTO transactional_smtp_credentials
      (name, username, password_hash, allowed_senders, allowed_domains, active, created_at)
      VALUES (
        <cfqueryparam value="#credName#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#smtpUsername#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#smtpPasswordHash#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#smtpAllowedSender#" cfsqltype="cf_sql_varchar" null="#smtpAllowedSender EQ ''#">,
        <cfqueryparam value="#smtpAllowedDomain#" cfsqltype="cf_sql_varchar" null="#smtpAllowedDomain EQ ''#">,
        1,
        NOW()
      )
    </cfquery>

    <cfset session.newTransactionalSmtpUsername = smtpUsername>
    <cfset session.newTransactionalSmtpPassword = smtpPasswordPlain>
    <cfset session.newTransactionalSmtpName = credName>
    <cfset session.m = 4>
    <cflocation url="view_transactional_emails.cfm" addtoken="no">
  </cfif>

  <cfif form.action EQ "revoke_smtp_credential">
    <cfparam name="form.id" default="">
    <cfif IsNumeric(form.id)>
      <cfquery datasource="hermes">
        UPDATE transactional_smtp_credentials
        SET active = 0, revoked_at = NOW()
        WHERE id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset session.m = 5>
    </cfif>
    <cflocation url="view_transactional_emails.cfm" addtoken="no">
  </cfif>
</cfif>

<cfquery name="getTxnSettings" datasource="hermes">
  SELECT parameter, value2 FROM parameters2 WHERE module='transactional_email'
</cfquery>
<cfquery name="getTxnDomains" datasource="hermes">
  SELECT domain FROM domains WHERE domain IS NOT NULL AND domain <> '' ORDER BY domain
</cfquery>
<cfquery name="getSmtpCreds" datasource="hermes">
  SELECT id, name, username, allowed_senders, allowed_domains, active, created_at
  FROM transactional_smtp_credentials
  ORDER BY created_at DESC
</cfquery>
<cfquery name="getApiTokens" datasource="hermes">
  SELECT id, name, allowed_senders, allowed_domains, any_ip, ip_allowlist, active, created_at, last_used_at
  FROM transactional_api_tokens
  ORDER BY created_at DESC
</cfquery>

<cfset txnSettings = StructNew()>
<cfloop query="getTxnSettings"><cfset txnSettings[parameter] = value2></cfloop>
<cfset txEnabled = StructKeyExists(txnSettings, "enabled") ? txnSettings["enabled"] : "0">
<cfset txRpm = StructKeyExists(txnSettings, "messages_per_minute") ? txnSettings["messages_per_minute"] : "60">
<cfset txRph = StructKeyExists(txnSettings, "messages_per_hour") ? txnSettings["messages_per_hour"] : "5000">
<cfset txRpd = StructKeyExists(txnSettings, "messages_per_day") ? txnSettings["messages_per_day"] : "50000">

    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-8"><h1 class="m-0">E-mail Server - Transactional Emails</h1></div>
          <div class="col-sm-4">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">E-mail Server</li>
              <li class="breadcrumb-item active">Transactional Emails</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfif m EQ 1><div class="alert alert-success"><h5><i class="icon fas fa-check"></i> Success</h5>Transactional email settings updated.</div></cfif>
<cfif m EQ 2><div class="alert alert-success"><h5><i class="icon fas fa-check"></i> Success</h5>API token generated.</div></cfif>
<cfif m EQ 3><div class="alert alert-success"><h5><i class="icon fas fa-check"></i> Success</h5>API token revoked.</div></cfif>
<cfif m EQ 4><div class="alert alert-success"><h5><i class="icon fas fa-check"></i> Success</h5>SMTP credential generated.</div></cfif>
<cfif m EQ 5><div class="alert alert-success"><h5><i class="icon fas fa-check"></i> Success</h5>SMTP credential revoked.</div></cfif>
<cfif m EQ 11><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>API token name is required.</div></cfif>
<cfif m EQ 12><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>SMTP credential name is required.</div></cfif>
<cfif m EQ 13><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>API allowed sender must be a valid email address.</div></cfif>
<cfif m EQ 14><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>Restricted API tokens require at least one IP/CIDR entry.</div></cfif>
<cfif m EQ 15><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>API sender and domain restrictions must match the same domain.</div></cfif>
<cfif m EQ 16><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>API sender domain is not configured in Hermes.</div></cfif>
<cfif m EQ 17><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>API allowed domain is not configured in Hermes.</div></cfif>
<cfif m EQ 18><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>SMTP allowed sender must be a valid email address.</div></cfif>
<cfif m EQ 19><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>SMTP sender and domain restrictions must match the same domain.</div></cfif>
<cfif m EQ 20><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>SMTP sender domain is not configured in Hermes.</div></cfif>
<cfif m EQ 21><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>SMTP allowed domain is not configured in Hermes.</div></cfif>
<cfif m EQ 30><div class="alert alert-danger"><h5><i class="icon fas fa-ban"></i> Error</h5>Could not generate SMTP credential hash.</div></cfif>

<cfif StructKeyExists(session, "newTransactionalApiToken") AND session.newTransactionalApiToken NEQ "">
  <div class="callout callout-warning">
    <h4><i class="fa fa-key"></i>&nbsp;&nbsp;New API token: <cfoutput>#encodeForHTML(session.newTransactionalApiTokenName)#</cfoutput></h4>
    <p>Copy this API token now. It will not be shown again.</p>
    <div class="input-group" style="max-width: 720px;">
      <input type="text" class="form-control font-monospace" id="txApiTokenField" readonly value="<cfoutput>#encodeForHTMLAttribute(session.newTransactionalApiToken)#</cfoutput>">
      <button class="btn btn-primary" type="button" onclick="copyTxApiToken()"><i class="fa fa-copy"></i>&nbsp;Copy</button>
    </div>
  </div>
  <cfset session.newTransactionalApiToken = "">
  <cfset session.newTransactionalApiTokenName = "">
</cfif>

<cfif StructKeyExists(session, "newTransactionalSmtpPassword") AND session.newTransactionalSmtpPassword NEQ "">
  <div class="callout callout-warning">
    <h4><i class="fa fa-key"></i>&nbsp;&nbsp;New SMTP credential: <cfoutput>#encodeForHTML(session.newTransactionalSmtpName)#</cfoutput></h4>
    <p>Copy these credentials now. The password will not be shown again.</p>
    <p class="mb-1"><strong>Username:</strong> <code><cfoutput>#encodeForHTML(session.newTransactionalSmtpUsername)#</cfoutput></code></p>
    <div class="input-group" style="max-width: 720px;">
      <input type="text" class="form-control font-monospace" id="txSmtpPasswordField" readonly value="<cfoutput>#encodeForHTMLAttribute(session.newTransactionalSmtpPassword)#</cfoutput>">
      <button class="btn btn-primary" type="button" onclick="copyTxSmtpPassword()"><i class="fa fa-copy"></i>&nbsp;Copy Password</button>
    </div>
  </div>
  <cfset session.newTransactionalSmtpName = "">
  <cfset session.newTransactionalSmtpUsername = "">
  <cfset session.newTransactionalSmtpPassword = "">
</cfif>

<div class="card card-primary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-paper-plane me-2"></i>Transactional Emails</h3></div>
  <div class="card-body">
    <p class="mb-3">Transactional Emails allows applications and services to send email through Hermes using authenticated SMTP or the Hermes REST API.</p>
    <form method="post" action="view_transactional_emails.cfm" class="row g-3">
      <input type="hidden" name="action" value="save_settings">
      <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.transactionalEmailCsrf)#"></cfoutput>

      <div class="col-md-3">
        <label class="form-label"><strong>Enable Transactional Email</strong></label>
        <select class="form-select" name="enabled">
          <option value="1" <cfif txEnabled EQ "1">selected</cfif>>ON</option>
          <option value="0" <cfif txEnabled NEQ "1">selected</cfif>>OFF</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label"><strong>Messages / minute</strong></label>
        <input type="number" class="form-control" name="messages_per_minute" min="1" value="<cfoutput>#encodeForHTMLAttribute(txRpm)#</cfoutput>">
      </div>
      <div class="col-md-3">
        <label class="form-label"><strong>Messages / hour</strong></label>
        <input type="number" class="form-control" name="messages_per_hour" min="1" value="<cfoutput>#encodeForHTMLAttribute(txRph)#</cfoutput>">
      </div>
      <div class="col-md-3">
        <label class="form-label"><strong>Messages / day</strong></label>
        <input type="number" class="form-control" name="messages_per_day" min="1" value="<cfoutput>#encodeForHTMLAttribute(txRpd)#</cfoutput>">
      </div>
      <div class="col-12"><button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i>Save</button></div>
    </form>
  </div>
</div>

<div class="card card-secondary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-server me-2"></i>SMTP Connection</h3></div>
  <div class="card-body p-0">
    <table class="table table-striped mb-0">
      <tbody>
        <tr><th style="width:220px;">SMTP Host</th><td><cfoutput>#encodeForHTML(cgi.server_name)#</cfoutput></td></tr>
        <tr><th>Submission Port</th><td>587 (STARTTLS)</td></tr>
        <tr><th>SSL/TLS Port</th><td>465 (Implicit TLS)</td></tr>
        <tr><th>Authentication</th><td>Username / Password (required)</td></tr>
      </tbody>
    </table>
  </div>
</div>

<div class="card card-secondary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-user-lock me-2"></i>SMTP Credentials</h3></div>
  <div class="card-body">
    <form method="post" action="view_transactional_emails.cfm" class="row g-3 mb-3">
      <input type="hidden" name="action" value="create_smtp_credential">
      <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.transactionalEmailCsrf)#"></cfoutput>
      <div class="col-md-4"><input class="form-control" name="credential_name" placeholder="Credential name (e.g. Website)"></div>
      <div class="col-md-3"><input class="form-control" name="smtp_allowed_sender" placeholder="Allowed sender (optional)"></div>
      <div class="col-md-3"><input class="form-control" name="smtp_allowed_domain" placeholder="Allowed domain (optional)"></div>
      <div class="col-md-2"><button type="submit" class="btn btn-primary w-100"><i class="fa fa-plus"></i>&nbsp;Generate</button></div>
    </form>
    <div class="table-responsive">
      <table class="table table-hover mb-0">
        <thead><tr><th>Name</th><th>Username</th><th>Sending Identity</th><th>Status</th><th class="text-end">Action</th></tr></thead>
        <tbody>
        <cfif getSmtpCreds.recordcount EQ 0><tr><td colspan="5" class="text-muted">No SMTP credentials created yet.</td></tr></cfif>
        <cfoutput query="getSmtpCreds">
          <tr>
            <td>#encodeForHTML(name)#</td>
            <td><code>#encodeForHTML(username)#</code></td>
            <td>
              <cfif Len(Trim(allowed_senders))>#encodeForHTML(allowed_senders)#<cfelseif Len(Trim(allowed_domains))>#encodeForHTML(allowed_domains)#<cfelse><span class="text-muted">Any authorized domain</span></cfif>
            </td>
            <td><cfif Val(active) EQ 1><span class="badge text-bg-success">Active</span><cfelse><span class="badge text-bg-secondary">Revoked</span></cfif></td>
            <td class="text-end">
              <cfif Val(active) EQ 1>
              <form method="post" action="view_transactional_emails.cfm" style="display:inline;">
                <input type="hidden" name="action" value="revoke_smtp_credential"><input type="hidden" name="id" value="#id#">
                <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.transactionalEmailCsrf)#"></cfoutput>
                <button type="submit" class="btn btn-sm btn-outline-danger">Revoke</button>
              </form>
              </cfif>
            </td>
          </tr>
        </cfoutput>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="card card-secondary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-code me-2"></i>REST API</h3></div>
  <div class="card-body">
    <p class="mb-2"><strong>Endpoint:</strong> <code><cfoutput>https://#encodeForHTML(cgi.server_name)#/api/v1/transactional/send</cfoutput></code></p>
    <p class="mb-1"><strong>Authentication:</strong> Use Bearer-token authentication in the Authorization header.</p>
    <p class="mb-3"><small class="text-muted">Query-string API tokens are rejected.</small></p>

    <form method="post" action="view_transactional_emails.cfm" class="row g-3 mb-3">
      <input type="hidden" name="action" value="create_api_token">
      <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.transactionalEmailCsrf)#"></cfoutput>
      <div class="col-md-3"><input class="form-control" name="token_name" placeholder="Token name (e.g. API Worker)"></div>
      <div class="col-md-3"><input class="form-control" name="allowed_sender" placeholder="Allowed sender (optional)"></div>
      <div class="col-md-2"><input class="form-control" name="allowed_domain" placeholder="Allowed domain (optional)"></div>
      <div class="col-md-2">
        <select class="form-select" name="any_ip"><option value="1">Any IP</option><option value="0">Restricted</option></select>
      </div>
      <div class="col-md-2"><input class="form-control" name="ip_allowlist" placeholder="IP/CIDR list"></div>
      <div class="col-md-12"><button type="submit" class="btn btn-primary"><i class="fa fa-plus"></i>&nbsp;Generate API Token</button></div>
    </form>

    <div class="table-responsive">
      <table class="table table-hover mb-0">
        <thead><tr><th>Token</th><th>Sender</th><th>IP Restrictions</th><th>Last Accessed</th><th>Status</th><th class="text-end">Action</th></tr></thead>
        <tbody>
        <cfif getApiTokens.recordcount EQ 0><tr><td colspan="6" class="text-muted">No API tokens created yet.</td></tr></cfif>
        <cfoutput query="getApiTokens">
          <tr>
            <td><strong>#encodeForHTML(name)#</strong><br><small class="text-muted">Hidden after creation</small></td>
            <td>
              <cfif Len(Trim(allowed_senders))>#encodeForHTML(allowed_senders)#<cfelseif Len(Trim(allowed_domains))>#encodeForHTML(allowed_domains)#<cfelse><span class="text-muted">Any authorized domain</span></cfif>
            </td>
            <td>
              <cfif Val(any_ip) EQ 1><strong>Any IP</strong><br><small class="text-muted">Requests may originate from any source address.</small>
              <cfelse><strong>Restricted</strong><br><small class="text-muted">Allowed ranges: #encodeForHTML(ip_allowlist)#</small></cfif>
            </td>
            <td><cfif IsDate(last_used_at)>#DateFormat(last_used_at,"yyyy-mm-dd")# #TimeFormat(last_used_at,"HH:mm:ss")#<cfelse><span class="text-muted">Never</span></cfif></td>
            <td><cfif Val(active) EQ 1><span class="badge text-bg-success">Active</span><cfelse><span class="badge text-bg-secondary">Revoked</span></cfif></td>
            <td class="text-end">
              <cfif Val(active) EQ 1>
              <form method="post" action="view_transactional_emails.cfm" style="display:inline;">
                <input type="hidden" name="action" value="revoke_api_token"><input type="hidden" name="id" value="#id#">
                <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.transactionalEmailCsrf)#"></cfoutput>
                <button type="submit" class="btn btn-sm btn-outline-danger">Revoke</button>
              </form>
              </cfif>
            </td>
          </tr>
        </cfoutput>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="card card-secondary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-book me-2"></i>API / SMTP Documentation</h3></div>
  <div class="card-body">
<pre class="bg-light p-3">SMTP Host: smtp.example.com
Port: 587
Security: STARTTLS
Username: smtp_xxxxxxxxx
Password: ********</pre>
<pre class="bg-light p-3">import smtplib
from email.message import EmailMessage

msg = EmailMessage()
msg["From"] = "demo@example.com"
msg["To"] = "customer@example.net"
msg["Subject"] = "Test Email"
msg.set_content("This is a transactional email.")

with smtplib.SMTP("smtp.example.com", 587) as smtp:
    smtp.starttls()
    smtp.login("smtp_xxxxxxxxx", "YOUR_PASSWORD")
    smtp.send_message(msg)</pre>
<pre class="bg-light p-3"># Python implicit TLS (port 465)
with smtplib.SMTP_SSL("smtp.example.com", 465) as smtp:
    smtp.login("smtp_xxxxxxxxx", "YOUR_PASSWORD")
    smtp.send_message(msg)</pre>

<pre class="bg-light p-3">curl -X POST \\
  "https://mail.example.com/api/v1/transactional/send" \\
  -H "Authorization: B&#101;arer YOUR_API_TOKEN" \\
  -H "Content-Type: application/json" \\
  -d '{
    "from": "demo@example.com",
    "to": ["customer@example.net"],
    "subject": "Welcome",
    "text": "Welcome to our service!",
    "html": "&lt;h1&gt;Welcome!&lt;/h1&gt;&lt;p&gt;Welcome to our service!&lt;/p&gt;"
  }'</pre>
<p><small class="text-muted">In all examples, the Authorization header value must start with B&#101;arer YOUR_API_TOKEN.</small></p>
<pre class="bg-light p-3"># Python
import requests
requests.post(
  "https://mail.example.com/api/v1/transactional/send",
  headers={"Authorization": "B" + "earer YOUR_API_TOKEN"},
  json={"from":"demo@example.com","to":["customer@example.net"],"subject":"Welcome","text":"Hello"}
)</pre>

<pre class="bg-light p-3"># PHP
$ch = curl_init("https://mail.example.com/api/v1/transactional/send");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
  "Authorization: B" . "earer YOUR_API_TOKEN",
  "Content-Type: application/json"
]);</pre>

<pre class="bg-light p-3">// Node.js / JavaScript
await fetch("https://mail.example.com/api/v1/transactional/send", {
  method: "POST",
  headers: {
    "Authorization": "B" + "earer YOUR_API_TOKEN",
    "Content-Type": "application/json"
  },
  body: JSON.stringify({
    from: "demo@example.com",
    to: ["customer@example.net"],
    subject: "Welcome",
    text: "Welcome to our service!"
  })
});</pre>

    <p class="mb-0"><strong>Sender and domain authorization:</strong> sender addresses must belong to domains configured in Hermes. Unauthorized domains and sender identities are rejected by both SMTP credential policy and API token policy.</p>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>

<script>
function copyTxApiToken(){
  var f=document.getElementById('txApiTokenField');
  if(!f){return;} f.select(); f.setSelectionRange(0,99999); document.execCommand('copy');
}
function copyTxSmtpPassword(){
  var f=document.getElementById('txSmtpPasswordField');
  if(!f){return;} f.select(); f.setSelectionRange(0,99999); document.execCommand('copy');
}
</script>

</body>
</html>
