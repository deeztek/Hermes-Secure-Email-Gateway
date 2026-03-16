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
  <title>Hermes SEG | Perimeter Checks</title>

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
            <h1 class="m-0">Perimeter Checks</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Perimeter Checks</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not "">
    <cfset action = form.action>
  </cfif>
</cfif>

<!--- GET PERIMETER CHECK DATA --->
<cfinclude template="./inc/get_perimeter_checks.cfm">

<!--- ===================== --->
<!--- ACTION HANDLER --->
<!--- ===================== --->
<cfif action is "save_settings">
  <cfinclude template="./inc/perimeter_save_settings.cfm">
</cfif>

<!--- Clear session message after reading --->
<cfset session.m = "">

<!--- ===================== --->
<!--- DISPLAY ALERT MESSAGES --->
<!--- ===================== --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Settings Saved</h4>
    <p>Perimeter check settings have been saved and applied successfully.</p>
  </div>
</cfif>

<cfif m is 2>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid DNSBL Threshold</h4>
    <p>DNSBL threshold must be a valid integer.</p>
  </div>
</cfif>

<cfif m is 3>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Message Size</h4>
    <p>Message size limit must be a valid number greater than zero.</p>
  </div>
</cfif>

<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Configuration Error</h4>
    <p>An error occurred while applying the Postfix configuration.</p>
    <cfif StructKeyExists(session, "postfix_error") AND session.postfix_error is not "">
      <p><small><strong>Detail:</strong> <cfoutput>#encodeForHTML(session.postfix_error)#</cfoutput></small></p>
      <cfset session.postfix_error = "">
    </cfif>
  </div>
</cfif>


<form method="post" autocomplete="off">
  <input type="hidden" name="action" value="save_settings">

  <!-- ===================== -->
  <!-- CARD 1: POSTSCREEN -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-shield-alt"></i> Postscreen Settings</h3>
    </div>
    <div class="card-body">
      <div class="callout callout-warning" style="margin-bottom: 2rem;">
        <h5><i class="fas fa-exclamation-triangle"></i> Graylisting Notice</h5>
        <p class="mb-0">Enabling any Postscreen check activates <strong>graylisting</strong>, which temporarily defers mail from unknown senders. While this is effective against spam, it can cause <strong>delayed or failed email delivery</strong> from remote servers that are incorrectly configured and do not properly retry deferred messages.</p>
      </div>

      <cfoutput>
      <div class="row mb-3">
        <div class="col-md-6">
          <label class="form-label"><strong>Pipelining Detection</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_pipelining" id="pipelining_yes" value="yes" <cfif get_postscreen_pipelining.parameter is "yes">checked</cfif>>
              <label class="form-check-label" for="pipelining_yes">Enabled</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_pipelining" id="pipelining_no" value="no" <cfif get_postscreen_pipelining.parameter is "no">checked</cfif>>
              <label class="form-check-label" for="pipelining_no">Disabled</label>
            </div>
          </div>
          <small class="text-muted">Detect SMTP command pipelining before the server greeting</small>
        </div>
        <div class="col-md-6">
          <label class="form-label"><strong>Non-SMTP Command Detection</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_non_smtp" id="nonsmtp_yes" value="yes" <cfif get_postscreen_non_smtp.parameter is "yes">checked</cfif>>
              <label class="form-check-label" for="nonsmtp_yes">Enabled</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_non_smtp" id="nonsmtp_no" value="no" <cfif get_postscreen_non_smtp.parameter is "no">checked</cfif>>
              <label class="form-check-label" for="nonsmtp_no">Disabled</label>
            </div>
          </div>
          <small class="text-muted">Detect non-SMTP commands in the SMTP session</small>
        </div>
      </div>

      <div class="row mb-3">
        <div class="col-md-6">
          <label class="form-label"><strong>Bare Newline Detection</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_bare_newline" id="bare_yes" value="yes" <cfif get_postscreen_bare_newline.parameter is "yes">checked</cfif>>
              <label class="form-check-label" for="bare_yes">Enabled</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="postscreen_bare_newline" id="bare_no" value="no" <cfif get_postscreen_bare_newline.parameter is "no">checked</cfif>>
              <label class="form-check-label" for="bare_no">Disabled</label>
            </div>
          </div>
          <small class="text-muted">Detect bare newline characters (not preceded by carriage return)</small>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 2: MESSAGE LIMITS -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-envelope"></i> Message Limits</h3>
    </div>
    <div class="card-body">
      <cfoutput>
      <div class="row">
        <div class="col-md-6">
          <label for="message_size_limit" class="form-label"><strong>Maximum Message Size (MB)</strong></label>
          <input type="number" class="form-control" id="message_size_limit" name="message_size_limit"
            value="#messageSizeMB#" step="0.01" min="0.01" style="max-width: 200px;" required>
          <small class="text-muted">Maximum size of incoming messages in megabytes (currently #messageSizeMB# MB)</small>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 3: RESTRICTIONS -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-filter"></i> SMTP Restrictions</h3>
    </div>
    <div class="card-body">
      <cfoutput>

      <div class="row mb-3">
        <div class="col-md-6">
          <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="helo_required" id="helo_required" value="1" <cfif get_helo_required.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="helo_required"><strong>Require HELO/EHLO</strong></label>
            <br><small class="text-muted">Require clients to send a HELO or EHLO command before sending mail</small>
          </div>
        </div>
      </div>

      <hr>
      <h5 class="mb-3">DNSBL Settings</h5>

      <div class="row mb-3">
        <div class="col-md-6">
          <label for="dnsbl_threshold" class="form-label"><strong>DNSBL Threshold</strong></label>
          <input type="number" class="form-control" id="dnsbl_threshold" name="dnsbl_threshold"
            value="#encodeForHTML(get_dnsbl_threshold.parameter)#" style="max-width: 200px;" required>
          <small class="text-muted">Combined DNSBL score threshold for blocking connections</small>
        </div>
      </div>

      <hr>
      <h5 class="mb-3">Recipient Restrictions</h5>

      <div class="row">
        <div class="col-md-6">
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_unauth_destination" id="reject_unauth_destination" value="1" <cfif get_reject_unauth_destination.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_unauth_destination"><strong>Reject Unauthorized Destination</strong></label>
            <br><small class="text-muted">Reject mail to domains this server does not relay for</small>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_unauth_pipelining" id="reject_unauth_pipelining" value="1" <cfif get_reject_unauth_pipelining.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_unauth_pipelining"><strong>Reject Unauthorized Pipelining</strong></label>
            <br><small class="text-muted">Reject mail from clients that pipeline commands without permission</small>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_invalid_hostname" id="reject_invalid_hostname" value="1" <cfif get_reject_invalid_hostname.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_invalid_hostname"><strong>Reject Invalid Hostname</strong></label>
            <br><small class="text-muted">Reject mail from clients with invalid HELO/EHLO hostname</small>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_non_fqdn_sender" id="reject_non_fqdn_sender" value="1" <cfif get_reject_non_fqdn_sender.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_non_fqdn_sender"><strong>Reject Non-FQDN Sender</strong></label>
            <br><small class="text-muted">Reject mail from senders with non-fully-qualified domain names</small>
          </div>
        </div>
        <div class="col-md-6">
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_unknown_sender_domain" id="reject_unknown_sender_domain" value="1" <cfif get_reject_unknown_sender_domain.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_unknown_sender_domain"><strong>Reject Unknown Sender Domain</strong></label>
            <br><small class="text-muted">Reject mail from senders whose domain has no DNS A or MX record</small>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_non_fqdn_recipient" id="reject_non_fqdn_recipient" value="1" <cfif get_reject_non_fqdn_recipient.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_non_fqdn_recipient"><strong>Reject Non-FQDN Recipient</strong></label>
            <br><small class="text-muted">Reject mail to recipients with non-fully-qualified domain names</small>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="reject_unknown_recipient_domain" id="reject_unknown_recipient_domain" value="1" <cfif get_reject_unknown_recipient_domain.enabled is "1">checked</cfif>>
            <label class="form-check-label" for="reject_unknown_recipient_domain"><strong>Reject Unknown Recipient Domain</strong></label>
            <br><small class="text-muted">Reject mail to recipients whose domain has no DNS A or MX record</small>
          </div>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 4: SPF/DKIM/DMARC (read-only status) -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-check-double"></i> Email Authentication</h3>
    </div>
    <div class="card-body">
      <p class="text-muted mb-3">These settings are managed from their respective configuration pages under <strong>Content Checks</strong>.</p>
      <cfoutput>
      <div class="row">
        <div class="col-md-4 mb-3">
          <strong>SPF (Sender Policy Framework)</strong><br>
          <cfif get_spf.enabled is "1">
            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Enabled</span>
          <cfelse>
            <span class="badge bg-secondary"><i class="fas fa-times-circle"></i> Disabled</span>
          </cfif>
          <br><a href="view_spf_settings.cfm" class="small">Configure SPF Settings <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="col-md-4 mb-3">
          <strong>DKIM (DomainKeys Identified Mail)</strong><br>
          <cfif get_dkim.enabled is "1">
            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Enabled</span>
          <cfelse>
            <span class="badge bg-secondary"><i class="fas fa-times-circle"></i> Disabled</span>
          </cfif>
          <br><a href="view_dkim_settings.cfm" class="small">Configure DKIM Settings <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="col-md-4 mb-3">
          <strong>DMARC</strong><br>
          <cfif get_dmarc.enabled is "1">
            <span class="badge bg-success"><i class="fas fa-check-circle"></i> Enabled</span>
          <cfelse>
            <span class="badge bg-secondary"><i class="fas fa-times-circle"></i> Disabled</span>
          </cfif>
          <cfif (get_spf.enabled is not "1") OR (get_dkim.enabled is not "1")>
            <br><small class="text-muted">Requires both SPF and DKIM</small>
          </cfif>
          <br><a href="view_dmarc_settings.cfm" class="small">Configure DMARC Settings <i class="fas fa-arrow-right"></i></a>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>

  <!-- SAVE BUTTON -->
  <div class="mb-4">
    <button type="submit" class="btn btn-primary btn-lg"
      onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving &amp; Applying...';this.form.submit();">
      <i class="fas fa-save"></i> Save &amp; Apply Settings
    </button>
  </div>

</form>

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


</body>
</html>
