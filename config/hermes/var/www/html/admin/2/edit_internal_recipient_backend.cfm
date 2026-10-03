<!DOCTYPE html>
<!--- Where Save and Cancel go back to. The same editor now serves two lists:
     Relay Recipients, and Mailboxes, where it is the only way to send a
     mailbox user's mail somewhere other than the local store.

     Matched against a fixed set rather than used as given. A return path
     taken from the query string and handed to cflocation is an open redirect
     if it is ever trusted verbatim. --->
<cfparam name="returnTo" default="">
<cfif StructKeyExists(url, "returnTo")>
    <cfset returnTo = url.returnTo>
<cfelseif StructKeyExists(form, "returnTo")>
    <cfset returnTo = form.returnTo>
</cfif>
<cfset backUrl   = (returnTo EQ "mailboxes") ? "view_mailboxes.cfm" : "view_internal_recipients.cfm">
<cfset backLabel = (returnTo EQ "mailboxes") ? "Back to Mailboxes"  : "Back to Recipients">

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
  <title>Hermes SEG | Edit Backend Server</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Edit Backend Server</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><cfoutput><a href="#backUrl#"><cfif returnTo EQ "mailboxes">Mailboxes<cfelse>Relay Recipients</cfif></a></cfoutput></li>
              <li class="breadcrumb-item active">Edit Backend</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!--- PARAMETER VALIDATION --->
<cfparam name="m" default="0">
<cfif StructKeyExists(session, "backendMessage")>
    <cfset m = session.backendMessage>
    <cfset StructDelete(session, "backendMessage")>
</cfif>


<cfparam name="ids" default="">
<cfif StructKeyExists(url, "ids")>
    <cfset ids = url.ids>
<cfelseif StructKeyExists(form, "ids")>
    <cfset ids = form.ids>
</cfif>

<!--- Validate IDs --->
<cfif ids EQ "">
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">No recipients selected. Please select at least one recipient.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- Split IDs into array and validate each is integer --->
<cfset idArray = ListToArray(ids)>
<cfset validIds = []>
<cfloop array="#idArray#" item="thisId">
    <cfif IsValid("integer", thisId)>
        <cfset ArrayAppend(validIds, thisId)>
    </cfif>
</cfloop>

<cfif ArrayLen(validIds) EQ 0>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Invalid recipient IDs provided.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- Get selected recipients --->
<cfquery name="getSelectedRecipients" datasource="hermes">
    SELECT id, recipient, backend_server, backend_port, backend_tls
    FROM recipients
    WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
    ORDER BY recipient
</cfquery>

<!--- Prefill the form from what the selected recipients already have.

     The page previously rendered the fields blank and pre-checked "Use Domain
     Default" regardless, so editing an existing override meant retyping the
     server and port from scratch while the header displayed the very values
     being asked for. Worse, the port silently showed 25 rather than the one in
     force, so a careless save would quietly move the recipient to a different
     port.

     Bulk edit is why it was built this way: several recipients can be selected
     at once and they need not agree. So prefill only when they DO agree, and
     say plainly when they do not rather than showing one recipient's values as
     if they applied to all.

     A unit separator joins the three columns because none of them can contain
     it, unlike any character a hostname or TLS mode might legitimately use. --->
<cfset prefillServer = "">
<cfset prefillPort   = 25>
<cfset prefillTls    = "may">
<cfset prefillCustom = false>
<cfset prefillMixed  = false>

<cfset backendSigs = []>
<cfloop query="getSelectedRecipients">
    <cfif Len(Trim(getSelectedRecipients.backend_server))>
        <cfset ArrayAppend(backendSigs, Trim(getSelectedRecipients.backend_server) & Chr(31)
                                      & val(getSelectedRecipients.backend_port)    & Chr(31)
                                      & Trim(getSelectedRecipients.backend_tls))>
    <cfelse>
        <cfset ArrayAppend(backendSigs, "")>
    </cfif>
</cfloop>

<cfset backendAllSame = true>
<cfloop from="2" to="#ArrayLen(backendSigs)#" index="sigIdx">
    <cfif backendSigs[sigIdx] NEQ backendSigs[1]>
        <cfset backendAllSame = false>
        <cfbreak>
    </cfif>
</cfloop>

<cfif backendAllSame AND Len(backendSigs[1])>
    <!--- includeEmptyFields, because an empty TLS mode would otherwise shift
         the port into its place. --->
    <cfset sigParts = ListToArray(backendSigs[1], Chr(31), true)>
    <cfset prefillServer = sigParts[1]>
    <cfset prefillPort   = sigParts[2]>
    <cfset prefillTls    = ArrayLen(sigParts) GTE 3 AND Len(sigParts[3]) ? sigParts[3] : "may">
    <cfset prefillCustom = true>
<cfelseif NOT backendAllSame>
    <cfset prefillMixed = true>
</cfif>

<!--- A failed save redisplays what was typed, not what is stored. --->
<cfif StructKeyExists(form, "backend_type")>
    <cfset prefillCustom = (form.backend_type EQ "custom")>
    <cfset prefillMixed  = false>
</cfif>
<cfif StructKeyExists(form, "custom_server")><cfset prefillServer = form.custom_server></cfif>
<cfif StructKeyExists(form, "custom_port") AND Len(Trim(form.custom_port))><cfset prefillPort = form.custom_port></cfif>
<cfif StructKeyExists(form, "custom_tls") AND Len(Trim(form.custom_tls))><cfset prefillTls = form.custom_tls></cfif>

<cfif getSelectedRecipients.recordcount LT 1>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Selected recipients not found.</p>
    </div>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
    <cfabort>
</cfif>

<!--- PROCESS FORM SUBMISSION --->
<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
    <cfset action = form.action>
</cfif>

<cfif action EQ "save">
    <cfparam name="backend_type" default="default">
    <cfif StructKeyExists(form, "backend_type")>
        <cfset backend_type = form.backend_type>
    </cfif>

    <cfif backend_type EQ "default">
        <!--- Clear backend override (set to NULL) --->
        <cfquery datasource="hermes">
            UPDATE recipients
            SET backend_server = NULL,
                backend_port = NULL,
                backend_tls = NULL,
                backend_transport = NULL
            WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
        </cfquery>
        <!--- Regenerate the per-destination TLS policy map (#157).

             transport_maps is a live MySQL lookup, so routing needs nothing
             here. smtp_tls_policy_maps is a hash file, so a changed or
             cleared backend_tls only takes effect once this rewrites it and
             runs postmap.

             datasource is set first because generate_tls_policy.cfm reads it
             and does not default it, the same as every other caller. --->
        <cfset datasource = "hermes">
        <cfinclude template="inc/generate_tls_policy.cfm">
        <cfset session.backendMessage = "success_default">
        <cflocation url="#backUrl#" addtoken="no">

    <cfelseif backend_type EQ "custom">
        <!--- Validate custom backend fields --->
        <cfparam name="custom_server" default="">
        <cfparam name="custom_port" default="25">
        <cfparam name="custom_tls" default="may">

        <cfif StructKeyExists(form, "custom_server")>
            <cfset custom_server = Trim(form.custom_server)>
        </cfif>
        <cfif StructKeyExists(form, "custom_port")>
            <cfset custom_port = form.custom_port>
        </cfif>
        <cfif StructKeyExists(form, "custom_tls")>
            <cfset custom_tls = form.custom_tls>
        </cfif>

        <!--- Validate server --->
        <cfif custom_server EQ "">
            <cfset m = "error_server_empty">
        <cfelseif NOT IsValid("integer", custom_port) OR custom_port LT 1 OR custom_port GT 65535>
            <cfset m = "error_port_invalid">
        <cfelseif NOT ListFindNoCase("none,may,encrypt", custom_tls)>
            <cfset m = "error_tls_invalid">
        <cfelse>
            <!--- Save custom backend override --->
            <cfquery datasource="hermes">
                UPDATE recipients
                SET backend_server = <cfqueryparam value="#custom_server#" cfsqltype="cf_sql_varchar">,
                    backend_port = <cfqueryparam value="#custom_port#" cfsqltype="cf_sql_integer">,
                    backend_tls = <cfqueryparam value="#custom_tls#" cfsqltype="cf_sql_varchar">,
                    <!--- Explicit, not left as it was. A recipient switched
                         here from the built-in server still carries
                         backend_transport = 'lmtp', and lmtp spoken at an
                         ordinary SMTP backend does not work. --->
                    backend_transport = 'smtp'
                WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
            </cfquery>
            <!--- Regenerate the per-destination TLS policy map (#157).

                 transport_maps is a live MySQL lookup, so routing needs nothing
                 here. smtp_tls_policy_maps is a hash file, so a changed or
                 cleared backend_tls only takes effect once this rewrites it and
                 runs postmap.

                 datasource is set first because generate_tls_policy.cfm reads
                 it and does not default it, the same as every other caller. --->
            <cfset datasource = "hermes">
            <cfinclude template="inc/generate_tls_policy.cfm">
            <cfset session.backendMessage = "success_custom">
            <cflocation url="#backUrl#" addtoken="no">
        </cfif>

    <cfelseif backend_type EQ "builtin">
        <!--- #290. Host these recipients here instead of sending their mail on.

             Two halves. The mailbox has to exist before the routing points at
             it, or mail arrives at a userdb that does not know the address and
             Dovecot refuses it, so provisioning runs first and routing is
             written after the loop.

             The provisioning itself is not written here. It runs
             inc/mailbox_provision_core.cfm, the same file Add Mailbox runs,
             with provisionMode = "convert". A second implementation of those
             steps would have started out identical and drifted the first time
             only one was updated. --->
        <cfparam name="builtin_quota_gb" default="5">
        <cfparam name="builtin_nextcloud" default="0">
        <cfparam name="builtin_reports" default="YES">
        <cfparam name="builtin_train_bayes" default="0">
        <cfparam name="builtin_download_msg" default="0">
        <cfloop list="builtin_quota_gb,builtin_nextcloud,builtin_reports,builtin_train_bayes,builtin_download_msg" index="bfld">
            <cfif StructKeyExists(form, bfld)><cfset variables[bfld] = Trim(form[bfld])></cfif>
        </cfloop>

        <cfif NOT IsNumeric(builtin_quota_gb) OR builtin_quota_gb LTE 0>
            <cfset m = "error_builtin_quota">
        <cfelse>

            <!--- An address that is already a mailbox has nothing to convert,
                 and running the provisioning again would try to insert a
                 second mailboxes row for it. Reject the whole batch rather
                 than silently skipping part of it, so the admin knows what
                 they selected. --->
            <cfquery name="alreadyMailbox" datasource="hermes">
                SELECT recipient FROM recipients
                 WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                   AND recipient_type = 'mailbox'
            </cfquery>

            <cfif alreadyMailbox.recordcount GTE 1>
                <cfset m = "error_builtin_already">
                <cfset session.builtinAlready = ValueList(alreadyMailbox.recipient)>
            <cfelse>

                <cfquery name="toConvert" datasource="hermes">
                    SELECT id, recipient, policy_id, pdf_enabled, smime_enabled, pgp_enabled,
                           digital_sign, auth_type, remoteauth_domain, enforce_mfa,
                           SUBSTRING_INDEX(recipient, '@', -1) AS recipient_domain
                      FROM recipients
                     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                     ORDER BY recipient ASC
                </cfquery>

                <cfset convertedCount = 0>
                <cfset convertSkipped  = "">

                <cfloop query="toConvert">

                    <!--- The domain must be a row in domains, which it is for
                         any relay recipient, and it is looked up WITHOUT a
                         type filter: this is the one place that deliberately
                         accepts a relay domain as a mailbox host. --->
                    <cfquery name="getDomain" datasource="hermes">
                        SELECT id, domain, default_quota_mb
                          FROM domains
                         WHERE domain = <cfqueryparam value="#toConvert.recipient_domain#" cfsqltype="cf_sql_varchar">
                         LIMIT 1
                    </cfquery>

                    <cfif getDomain.recordcount LT 1>
                        <cfset convertSkipped = ListAppend(convertSkipped, toConvert.recipient)>
                        <cfcontinue>
                    </cfif>

                    <cfset recipientEmail = toConvert.recipient>

                    <!--- Name from what the directory already gave us. --->
                    <cfinclude template="inc/resolve_recipient_display_name.cfm">
                    <cfset displayName = resolvedDisplayName>

                    <cfset quotaBytes = Round(builtin_quota_gb * 1024 * 1024 * 1024)>

                    <!--- Carried over from the recipient, not asked for. --->
                    <cfset form.policy            = toConvert.policy_id>
                    <cfset form.pdf_enabled       = toConvert.pdf_enabled>
                    <cfset form.smime_enabled     = toConvert.smime_enabled>
                    <cfset form.pgp_enabled       = toConvert.pgp_enabled>
                    <cfset form.sign              = toConvert.digital_sign>
                    <cfset form.auth_type         = toConvert.auth_type>
                    <cfset form.remoteauth_domain = Len(Trim(toConvert.remoteauth_domain)) ? toConvert.remoteauth_domain : "">
                    <cfset form.enforce_mfa       = Val(toConvert.enforce_mfa)>

                    <!--- From the form, one value for the whole batch. --->
                    <cfset form.quota_gb          = builtin_quota_gb>
                    <cfset form.nextcloud_enabled = builtin_nextcloud>
                    <cfset form.reports           = builtin_reports>
                    <cfset form.train_bayes       = builtin_train_bayes>
                    <cfset form.download_msg      = builtin_download_msg>
                    <cfset form.timezone          = "">

                    <!--- Empty on purpose. Step 7 of the core is guarded on
                         form.ca being non-empty, so no certificate is minted
                         by a conversion. An existing one is untouched and a
                         new one can be issued afterwards as usual. --->
                    <cfset form.ca = "">

                    <!--- enforce_mfa drives which Authelia group the account
                         joins, the same as Add Mailbox. --->
                    <cfset ldapAccessControl = (Val(toConvert.enforce_mfa) EQ 1) ? "two_factor" : "one_factor">

                    <cfset provisionMode = "convert">
                    <cfinclude template="inc/mailbox_provision_core.cfm">

                    <cfset convertedCount = convertedCount + 1>
                </cfloop>

                <!--- Routing, after the mailboxes exist. lmtp to the built-in
                     server, which beats the domain's own transport because the
                     transport lookup asks for the recipient first. backend_tls
                     is NULL: this is a container-to-container hop inside the
                     Docker network and never leaves the host. --->
                <cfquery datasource="hermes">
                    UPDATE recipients
                       SET backend_transport = 'lmtp',
                           backend_server    = 'hermes_dovecot',
                           backend_port      = 24,
                           backend_tls       = NULL
                     WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                </cfquery>

                <!--- Mark every domain involved as hybrid, so the console stops
                     treating it as relay-only and its new mailboxes become
                     visible and manageable. Relay domains stay in Postfix's
                     relay_domains either way, because that lookup excludes
                     type='mailbox' only, so the recipients left on the
                     provider are unaffected. A domain that is already
                     type='mailbox' is left alone. --->
                <cfquery datasource="hermes">
                    UPDATE domains
                       SET type = 'hybrid'
                     WHERE domain IN (
                             SELECT DISTINCT SUBSTRING_INDEX(recipient, '@', -1)
                               FROM recipients
                              WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
                           )
                       AND (type IS NULL OR type NOT IN ('mailbox', 'hybrid'))
                </cfquery>

                <!--- The TLS policy map is keyed by destination, and clearing
                     backend_tls above has to be reflected in it. --->
                <cfset datasource = "hermes">
                <cfinclude template="inc/generate_tls_policy.cfm">

                <cfset session.backendMessage = "success_builtin">
                <cfset session.builtinCount   = convertedCount>
                <cfset session.builtinSkipped = convertSkipped>
                <cflocation url="#backUrl#" addtoken="no">
            </cfif>
        </cfif>
    </cfif>
</cfif>

<!--- ERROR/SUCCESS MESSAGES --->
<cfif m EQ "error_builtin_quota">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The mailbox quota must be a number greater than zero.
    </div>
<cfelseif m EQ "error_builtin_already">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Nothing to convert</h5>
        <p class="mb-1">These already have a mailbox on this server, so there is nothing to create for them:</p>
        <p class="mb-0"><strong><cfoutput>#HTMLEditFormat(StructKeyExists(session, "builtinAlready") ? session.builtinAlready : "")#</cfoutput></strong></p>
        <p class="mb-0 mt-2"><small>Nothing was changed. Deselect them and try again. To change where an existing
        mailbox's mail goes, use <strong>Edit Mail Delivery</strong> on the Mailboxes page.</small></p>
    </div>
    <cfset StructDelete(session, "builtinAlready")>
<cfelseif m EQ "error_server_empty">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Backend Server field cannot be empty when using custom backend.
    </div>
</cfif>

<cfif m EQ "error_port_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Port must be a valid number between 1 and 65535.
    </div>
</cfif>

<cfif m EQ "error_tls_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        Invalid TLS setting selected.
    </div>
</cfif>

<!--- BACK BUTTON --->
<p>
    <cfoutput><a href="#backUrl#" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>#backLabel#</a></cfoutput>
</p>

<!--- SELECTED RECIPIENTS CARD --->
<div class="card card-outline card-info mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-users me-2"></i>Selected Recipients (<cfoutput>#getSelectedRecipients.recordcount#</cfoutput>)</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <cfoutput query="getSelectedRecipients">
                <div class="col-md-4 col-sm-6 mb-2">
                    <span class="badge bg-secondary me-1"><i class="fas fa-envelope me-1"></i>#recipient#</span>
                    <cfif Len(Trim(backend_server)) GT 0>
                        <small class="text-primary">(#backend_server#:#backend_port#)</small>
                    <cfelse>
                        <small class="text-muted">(domain default)</small>
                    </cfif>
                </div>
            </cfoutput>
        </div>
    </div>
</div>

<!--- BACKEND SETTINGS FORM --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-server me-2"></i>Backend Server Settings</h3>
    </div>
    <div class="card-body">
        <form method="post" action="">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="ids" value="<cfoutput>#ArrayToList(validIds)#</cfoutput>">
            <input type="hidden" name="returnTo" value="<cfoutput>#EncodeForHTMLAttribute(returnTo)#</cfoutput>">

            <div class="mb-3">
                <label class="form-label"><strong>Backend Server</strong></label>

                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_default" value="default"<cfoutput><cfif NOT prefillCustom> checked</cfif></cfoutput>>
                    <label class="form-check-label" for="backend_default">
                        <strong>Use Domain Default</strong>
                        <br><small class="text-muted">Route to the backend server configured in the recipient's domain settings</small>
                    </label>
                </div>

                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_custom" value="custom"<cfoutput><cfif prefillCustom> checked</cfif></cfoutput>>
                    <label class="form-check-label" for="backend_custom">
                        <strong>Custom Backend Server</strong>
                        <br><small class="text-muted">Override domain default with a specific backend server for these recipients</small>
                    </label>
                </div>

                <!--- #290. The third destination is Hermes itself. Choosing it
                     does more than change routing: the address has no mailbox
                     to deliver into, so one is created, which is why this
                     option carries settings and the other two do not. --->
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_builtin" value="builtin">
                    <label class="form-check-label" for="backend_builtin">
                        <strong>Built-in Email Server</strong>
                        <br><small class="text-muted">Host these recipients' mail on Hermes instead of sending it on. Creates a mailbox for each one, keeping their existing login.</small>
                    </label>
                </div>
            </div>

            <cfoutput><cfif prefillMixed>
            <div class="alert alert-warning py-2">
                <small><strong>The selected recipients do not share one backend.</strong>
                The fields below are therefore blank rather than showing one recipient's
                settings as if they applied to all. Saving replaces the backend on every
                selected recipient.</small>
            </div>
            </cfif></cfoutput>

            <!--- Custom backend fields. Shown on load when an override is already
                 in force, since the JS below only reacts to a change event. --->
            <div id="custom_backend_fields" style="<cfoutput><cfif prefillCustom>display: block;<cfelse>display: none;</cfif></cfoutput> padding-left: 25px; border-left: 3px solid #007bff;">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="custom_server" class="form-label"><strong>Server Address</strong></label>
                        <input type="text" class="form-control" id="custom_server" name="custom_server" value="<cfoutput>#EncodeForHTMLAttribute(prefillServer)#</cfoutput>" placeholder="e.g., mail.example.com or 192.0.2.10">
                        <small class="text-muted">FQDN or IP address of the backend mail server</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_port" class="form-label"><strong>Port</strong></label>
                        <input type="number" class="form-control" id="custom_port" name="custom_port" value="<cfoutput>#EncodeForHTMLAttribute(prefillPort)#</cfoutput>" min="1" max="65535">
                        <small class="text-muted">SMTP port (default: 25)</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_tls" class="form-label"><strong>TLS Mode</strong></label>
                        <select class="form-control" id="custom_tls" name="custom_tls">
                            <cfoutput>
                            <option value="may"<cfif prefillTls EQ "may"> selected</cfif>>May (Opportunistic)</option>
                            <option value="encrypt"<cfif prefillTls EQ "encrypt"> selected</cfif>>Encrypt (Required)</option>
                            <option value="none"<cfif prefillTls EQ "none"> selected</cfif>>None (Disabled)</option>
                            </cfoutput>
                        </select>
                        <small class="text-muted">TLS encryption mode</small>
                    </div>
                </div>
            </div>

            <!--- Built-in mailbox settings. Deliberately short. Everything
                 that can be carried over from the recipient is carried over
                 rather than asked for: the spam policy, the encryption flags,
                 signing, MFA enforcement, and the authentication type with its
                 directory. What is left is what genuinely has no previous
                 value, and it is applied to every selected recipient.

                 Not asked for, and why:
                   display name   taken from what the directory already told us
                                  during provisioning, falling back to the
                                  address local part
                   password       not touched. A remote-auth recipient keeps
                                  authenticating against the provider, and a
                                  local one keeps the password it already has.
                                  Converting forty people must not reset forty
                                  passwords
                   certificates   no S/MIME is minted here. Existing
                                  certificates are untouched, and a new one can
                                  be issued afterwards as usual --->
            <div id="builtin_backend_fields" style="display: none; padding-left: 25px; border-left: 3px solid #198754;">
                <div class="alert alert-info py-2">
                    <small><strong>Each selected recipient gets a mailbox on this server.</strong>
                    Their existing login still works, nothing is sent to the old backend any more,
                    and the spam policy, encryption and authentication settings they already have
                    are kept. Their domain becomes a hybrid domain: the recipients you do not
                    convert carry on going to the provider exactly as before.</small>
                </div>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label for="builtin_quota_gb" class="form-label"><strong>Mailbox Quota (GB)</strong></label>
                        <input type="number" class="form-control" id="builtin_quota_gb" name="builtin_quota_gb" value="5" step="0.01" min="0.01">
                        <small class="text-muted">Applied to every selected recipient</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="builtin_nextcloud" class="form-label"><strong>Nextcloud Access</strong></label>
                        <select class="form-control" id="builtin_nextcloud" name="builtin_nextcloud">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                        <small class="text-muted">Files, calendar and contacts</small>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_reports" class="form-label"><strong>Quarantine Notices</strong></label>
                        <select class="form-control" id="builtin_reports" name="builtin_reports">
                            <option value="YES" selected>Yes</option>
                            <option value="NO">No</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_train_bayes" class="form-label"><strong>Bayes Training</strong></label>
                        <select class="form-control" id="builtin_train_bayes" name="builtin_train_bayes">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="builtin_download_msg" class="form-label"><strong>Message Download</strong></label>
                        <select class="form-control" id="builtin_download_msg" name="builtin_download_msg">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Saving...';this.form.submit();">
                    <i class="fas fa-save me-1"></i>Save Changes
                </button>
                <cfoutput><a href="#backUrl#" class="btn btn-secondary ms-2"></cfoutput>
                    <i class="fas fa-times me-1"></i>Cancel
                </a>
            </div>
        </form>
    </div>
</div>

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div><!-- ./app-wrapper -->

<!--- JavaScript for showing/hiding custom backend fields --->
<script>
$(document).ready(function() {
    // Show the panel belonging to the selected destination, hide the other.
    // Only one can be open, so this does not toggle them independently.
    $('input[name="backend_type"]').on('change', function() {
        var v = $(this).val();
        if (v === 'custom') {
            $('#builtin_backend_fields').slideUp();
            $('#custom_backend_fields').slideDown();
        } else if (v === 'builtin') {
            $('#custom_backend_fields').slideUp();
            $('#builtin_backend_fields').slideDown();
        } else {
            $('#custom_backend_fields').slideUp();
            $('#builtin_backend_fields').slideUp();
        }
    });
});
</script>

</body>
</html>
