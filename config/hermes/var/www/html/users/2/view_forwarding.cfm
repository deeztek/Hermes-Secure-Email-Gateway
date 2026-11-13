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
  <title>Hermes SEG | Forwarding</title>
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
            <h1 class="m-0">Forwarding</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Forwarding</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfif NOT session.theGroups CONTAINS "mailboxes">
  <div class="alert alert-warning">
    <h4><i class="icon fas fa-exclamation-triangle"></i> Not Available</h4>
    <p class="mb-0">Forwarding is only available for mailbox users.</p>
  </div>
<cfelse>

<!--- 2FA enforce-mfa restriction gate (#225 Phase 1.5) --->
<cfinclude template="./inc/check_enforce_mfa_restriction.cfm">
<cfif enforceMfaRestricted>
  <cfinclude template="./inc/restricted_access_panel.cfm">
<cfelse>

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<cfif action EQ "save_forwarding">
  <cfinclude template="./inc/forwarding_action.cfm">
</cfif>

<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Saved!</h4>
    Your forwarding settings were saved.
  </div>
<cfelseif m EQ 21>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Enter a valid email address to forward to.
  </div>
<cfelseif m EQ 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You can only forward to a mailbox on your own domain.
  </div>
<cfelseif m EQ 23>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That address is not another mailbox on this server. Forwarding must go to an existing mailbox other than your own.
  </div>
<cfelseif m EQ 24>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That mailbox already forwards its mail back to you, directly or through another mailbox. Forwarding to it would create a loop.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Saved, but compilation failed</h4>
    <p class="mb-1">Your forwarding settings were saved, but the generated sieve script could not be compiled. Your previous filter configuration is still active. Please contact your administrator if the problem persists.</p>
    <cfif StructKeyExists(session, "compile_error")>
      <pre class="mb-0" style="white-space:pre-wrap;font-size:0.85em;"><cfoutput>#HTMLEditFormat(session.compile_error)#</cfoutput></pre>
      <cfset session.compile_error = "">
    </cfif>
  </div>
</cfif>

<!--- Load current settings --->
<cfquery name="getForwarding" datasource="hermes">
    SELECT enabled, forward_to, keep_copy
    FROM user_forwarding
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset fEnabled = 0>
<cfset fTo = "">
<cfset fKeep = 1>
<cfif getForwarding.recordcount GTE 1>
    <cfset fEnabled = Val(getForwarding.enabled)>
    <cfset fTo = getForwarding.forward_to>
    <cfset fKeep = Val(getForwarding.keep_copy)>
</cfif>

<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Forwarding</h5>
  <p class="mb-1">When enabled, every message that reaches your mailbox is also sent to another mailbox on your domain.</p>
  <p class="mb-0"><small>To forward only some messages, use <a href="view_sieve_rules.cfm">Mail Filters</a> instead.</small></p>
</div>

<cfif fEnabled EQ 1 AND fTo NEQ "">
  <div class="alert alert-success">
    <h5 class="mb-1"><i class="icon fas fa-share me-2"></i>Forwarding is <strong>ON</strong></h5>
    <p class="mb-0">
      <cfoutput>
      <cfif fKeep EQ 1>
        Your mail is copied to <strong>#HTMLEditFormat(fTo)#</strong> and also kept in this mailbox.
      <cfelse>
        Your mail goes to <strong>#HTMLEditFormat(fTo)#</strong> and is <strong>not</strong> kept in this mailbox.
      </cfif>
      </cfoutput>
    </p>
  </div>
</cfif>

<div class="card col-sm-8">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-share me-2"></i>Settings</h3>
  </div>
  <form method="post" action="view_forwarding.cfm" id="forwardingForm">
    <input type="hidden" name="action" value="save_forwarding">
    <div class="card-body">

      <div class="form-check form-switch mb-3">
        <input class="form-check-input" type="checkbox" id="enabledToggle" name="enabled" value="1" <cfif fEnabled EQ 1>checked</cfif>>
        <label class="form-check-label" for="enabledToggle"><strong>Enable forwarding</strong></label>
      </div>

      <div class="form-group mb-3">
        <label for="forward_to"><strong>Forward to</strong></label>
        <cfoutput>
        <input type="email" class="form-control" id="forward_to" name="forward_to" maxlength="255" placeholder="e.g., user@#HTMLEditFormat(ListLast(session.email, '@'))#" value="#HTMLEditFormat(fTo)#">
        </cfoutput>
        <small class="text-muted">Another mailbox on your domain.</small>
      </div>

      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" id="keep_copy" name="keep_copy" value="1" <cfif fKeep EQ 1>checked</cfif> onchange="document.getElementById('noKeepWarn').style.display = this.checked ? 'none' : 'block';">
        <label class="form-check-label" for="keep_copy">
          <strong>Keep a copy in this mailbox</strong>
        </label>
        <div><small class="text-muted">Recommended. Both mailboxes receive every message.</small></div>
      </div>

      <div id="noKeepWarn" class="alert alert-danger py-2 mb-3" <cfif fKeep EQ 1>style="display:none;"</cfif>>
        <h6 class="mb-1"><i class="fas fa-exclamation-triangle me-1"></i>Mail will no longer arrive in this mailbox</h6>
        <p class="mb-0"><small>Every message goes to the other mailbox <strong>instead of</strong> this one. Nothing is kept here, your vacation auto-reply and mail filters do not run, and if you forget to turn this off you will keep missing mail here.</small></p>
      </div>

      <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i>&nbsp;&nbsp;Save Settings</button>
    </div>
  </form>
</div>

</cfif><!-- /.enforceMfaRestricted -->
</cfif>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
  $(document).ready(function() {
    $('#forwardingForm').on('submit', function(e) {
      var on = $('#enabledToggle').is(':checked');
      var keep = $('#keep_copy').is(':checked');
      if (on && !keep) {
        if (!confirm('WARNING: Every incoming message will go to ' + $('#forward_to').val() + ' INSTEAD of this mailbox. Nothing will be kept here. Continue?')) {
          e.preventDefault();
          e.stopImmediatePropagation();
          // html_head.cfm's global submit hook already showed the preloader
          var preloader = document.querySelector('.preloader');
          if (preloader) {
            preloader.style.display = 'none';
            preloader.style.opacity = '0';
          }
          return false;
        }
      }
    });
  });
</script>

</body>
</html>
