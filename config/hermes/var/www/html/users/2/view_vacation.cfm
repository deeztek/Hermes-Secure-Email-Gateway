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
  <title>Hermes SEG | Vacation Auto-Reply</title>
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
            <h1 class="m-0">Vacation Auto-Reply</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Vacation Auto-Reply</li>
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
    <p class="mb-0">Vacation auto-reply is only available for mailbox users.</p>
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

<cfif action EQ "save_vacation">
  <cfinclude template="./inc/vacation_action.cfm">
</cfif>

<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Saved!</h4>
    Your vacation auto-reply settings were saved.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Subject is required and must be 255 characters or less.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Message body is required.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid date format. Use the date picker.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    End date must be on or after the start date.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    "Reply only to" contains an invalid email address.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Saved, but compilation failed</h4>
    <p class="mb-1">Your vacation settings were saved, but the generated sieve script could not be compiled. Your previous filter configuration is still active. Please contact your administrator if the problem persists.</p>
    <cfif StructKeyExists(session, "compile_error")>
      <pre class="mb-0" style="white-space:pre-wrap;font-size:0.85em;"><cfoutput>#HTMLEditFormat(session.compile_error)#</cfoutput></pre>
      <cfset session.compile_error = "">
    </cfif>
  </div>
</cfif>

<!--- Load current settings --->
<!--- Load the user's timezone for display + datetime formatting --->
<cfinclude template="../../admin/2/inc/get_user_timezone.cfm">
<cfset userTz = getUserTimezone(session.email)>

<cfquery name="getVacation" datasource="hermes">
    SELECT enabled, subject, body, start_date, end_date, reply_interval_days, reply_external, reply_addresses, discard_incoming
    FROM user_vacation
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset vEnabled = 0>
<cfset vSubject = "Out of office">
<cfset vBody = "I am currently out of the office and will reply to your message when I return.">
<cfset vStart = "">
<cfset vEnd = "">
<cfset vDays = 7>
<cfset vExternal = 0>
<cfset vAddresses = "">
<cfset vDiscard = 0>
<cfset vIsActiveNow = false>

<cfif getVacation.recordcount GTE 1>
    <cfset vEnabled = getVacation.enabled>
    <cfif getVacation.subject NEQ "">
        <cfset vSubject = getVacation.subject>
    </cfif>
    <cfif getVacation.body NEQ "">
        <cfset vBody = getVacation.body>
    </cfif>
    <!--- Stored as user-local wall clock; render directly into the
         datetime-local input format (yyyy-MM-ddTHH:mm) without conversion. --->
    <cfif IsDate(getVacation.start_date)>
        <cfset vStart = DateFormat(getVacation.start_date, "yyyy-mm-dd") & "T" & TimeFormat(getVacation.start_date, "HH:mm")>
    </cfif>
    <cfif IsDate(getVacation.end_date)>
        <cfset vEnd = DateFormat(getVacation.end_date, "yyyy-mm-dd") & "T" & TimeFormat(getVacation.end_date, "HH:mm")>
    </cfif>
    <cfif Val(getVacation.reply_interval_days) GT 0>
        <cfset vDays = Val(getVacation.reply_interval_days)>
    </cfif>
    <cfset vExternal = Val(getVacation.reply_external)>
    <cfset vAddresses = getVacation.reply_addresses>
    <cfset vDiscard = Val(getVacation.discard_incoming)>

    <!--- Compute "active right now" by comparing user-local stored times
         to "now in user TZ". The actual sieve check is done by Pigeonhole
         using currentdate :iso8601 (UTC); this server-side compute is just
         for the dashboard banner display. --->
    <cfif vEnabled EQ 1>
        <cfset vIsActiveNow = true>
        <cfset nowInUserTz = convertFromUTC(DateConvert("local2utc", Now()), userTz, "yyyy-MM-dd HH:mm:ss")>
        <cfif IsDate(getVacation.start_date) AND DateCompare(nowInUserTz, getVacation.start_date) LT 0>
            <cfset vIsActiveNow = false>
        </cfif>
        <cfif IsDate(getVacation.end_date) AND DateCompare(nowInUserTz, getVacation.end_date) GT 0>
            <cfset vIsActiveNow = false>
        </cfif>
    </cfif>
</cfif>

<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Vacation Auto-Reply</h5>
  <p class="mb-1">When enabled, an automatic reply will be sent to senders while you are away. The reply is sent at most once per sender within the interval you set, and is automatically suppressed for mailing lists and bulk mail.</p>
  <p class="mb-0"><small>Leave the start and end dates empty to keep the auto-reply active until you disable it manually.</small></p>
</div>

<cfif vIsActiveNow>
  <div class="alert alert-success">
    <h5 class="mb-1"><i class="icon fas fa-paper-plane me-2"></i>Auto-reply is currently <strong>ACTIVE</strong></h5>
    <p class="mb-0">
      <cfif IsDate(getVacation.end_date)>
        <cfoutput>Active until #DateFormat(getVacation.end_date, "yyyy/mm/dd")# #TimeFormat(getVacation.end_date, "HH:mm")# (#userTz#).</cfoutput>
      <cfelse>
        Active until you turn it off.
      </cfif>
    </p>
  </div>
<cfelseif vEnabled EQ 1>
  <div class="alert alert-secondary">
    <h5 class="mb-1"><i class="icon fas fa-clock me-2"></i>Auto-reply is enabled but not currently active</h5>
    <p class="mb-0">
      <cfif IsDate(getVacation.start_date) AND DateCompare(nowInUserTz, getVacation.start_date) LT 0>
        <cfoutput>It will become active on #DateFormat(getVacation.start_date, "yyyy/mm/dd")# #TimeFormat(getVacation.start_date, "HH:mm")# (#userTz#).</cfoutput>
      <cfelseif IsDate(getVacation.end_date) AND DateCompare(nowInUserTz, getVacation.end_date) GT 0>
        <cfoutput>The end date (#DateFormat(getVacation.end_date, "yyyy/mm/dd")# #TimeFormat(getVacation.end_date, "HH:mm")#) has passed. Update the dates or disable the auto-reply.</cfoutput>
      </cfif>
    </p>
  </div>
</cfif>

<div class="card col-sm-8">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-paper-plane me-2"></i>Settings</h3>
  </div>
  <form method="post" action="view_vacation.cfm">
    <input type="hidden" name="action" value="save_vacation">
    <div class="card-body">

      <div class="form-check form-switch mb-3">
        <input class="form-check-input" type="checkbox" id="enabledToggle" name="enabled" value="1" <cfif vEnabled EQ 1>checked</cfif>>
        <label class="form-check-label" for="enabledToggle"><strong>Enable vacation auto-reply</strong></label>
      </div>

      <div class="form-group mb-3">
        <label for="vacation_subject"><strong>Subject</strong></label>
        <cfoutput>
        <input type="text" class="form-control" id="vacation_subject" name="vacation_subject" maxlength="255" value="#HTMLEditFormat(vSubject)#">
        </cfoutput>
      </div>

      <div class="form-group mb-3">
        <label for="vacation_body"><strong>Message</strong></label>
        <cfoutput>
        <textarea class="form-control" id="vacation_body" name="vacation_body" rows="6">#HTMLEditFormat(vBody)#</textarea>
        </cfoutput>
        <small class="text-muted">Plain text only. Avoid including sensitive information - this message is sent to anyone who emails you.</small>
      </div>

      <div class="form-group mb-3">
        <label for="reply_addresses"><strong>Reply only when message is addressed to</strong> <small class="text-muted">(optional)</small></label>
        <select id="reply_addresses" name="reply_addresses" multiple style="width:100%;">
          <!-- Options populated by AJAX from get_user_addresses.cfm -->
        </select>
        <small class="text-muted">Leave empty to reply to any message that reaches your mailbox. Pick one or more of your addresses to restrict the auto-reply (e.g. only fire when mail is sent to <code>sales@</code> but not when you are Cc'd).</small>
      </div>

      <div class="alert alert-light border py-2 mb-3">
        <small><i class="fas fa-globe me-1"></i>Times below are interpreted in your timezone: <strong><cfoutput>#userTz#</cfoutput></strong>. <a href="user_settings.cfm">Change timezone</a></small>
      </div>

      <div class="row">
        <div class="col-md-4 form-group mb-3">
          <label for="start_date"><strong>Start date and time</strong> <small class="text-muted">(optional)</small></label>
          <cfoutput>
          <input type="datetime-local" class="form-control" id="start_date" name="start_date" value="#vStart#">
          </cfoutput>
        </div>
        <div class="col-md-4 form-group mb-3">
          <label for="end_date"><strong>End date and time</strong> <small class="text-muted">(optional)</small></label>
          <cfoutput>
          <input type="datetime-local" class="form-control" id="end_date" name="end_date" value="#vEnd#">
          </cfoutput>
        </div>
        <div class="col-md-4 form-group mb-3">
          <label for="reply_interval_days"><strong>Reply interval (days)</strong></label>
          <cfoutput>
          <input type="number" class="form-control" id="reply_interval_days" name="reply_interval_days" min="1" max="365" value="#vDays#">
          </cfoutput>
          <small class="text-muted">Don't reply to the same sender more often than this.</small>
        </div>
      </div>

      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" id="reply_external" name="reply_external" value="1" <cfif vExternal EQ 1>checked</cfif> onchange="document.getElementById('externalWarn').style.display = this.checked ? 'block' : 'none';">
        <label class="form-check-label" for="reply_external">
          <strong>Also reply to external senders</strong>
        </label>
        <div><small class="text-muted">By default, auto-replies are sent only to people inside your organization.</small></div>
      </div>

      <div id="externalWarn" class="alert alert-warning py-2 mb-3" <cfif vExternal NEQ 1>style="display:none;"</cfif>>
        <h6 class="mb-1"><i class="fas fa-exclamation-triangle me-1"></i>Not recommended</h6>
        <p class="mb-0"><small>Replying to external senders is <strong>generally a bad idea</strong>. It confirms your address to spammers (increasing the spam you receive when you return), reveals to anyone who emails you that you are away (a known social-engineering risk), and can trigger reply loops with other auto-responders or mailing-list bounces. Only enable this if you have a specific business need and understand the trade-offs.</small></p>
      </div>

      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" id="discard_incoming" name="discard_incoming" value="1" <cfif vDiscard EQ 1>checked</cfif> onchange="document.getElementById('discardWarn').style.display = this.checked ? 'block' : 'none';">
        <label class="form-check-label" for="discard_incoming">
          <strong>Delete incoming messages while away</strong>
        </label>
        <div><small class="text-muted">The auto-reply is still sent, but the original message is dropped from your inbox.</small></div>
      </div>

      <div id="discardWarn" class="alert alert-danger py-2 mb-3" <cfif vDiscard NEQ 1>style="display:none;"</cfif>>
        <h6 class="mb-1"><i class="fas fa-exclamation-triangle me-1"></i>Destructive - messages cannot be recovered</h6>
        <p class="mb-0"><small>Every message that triggers an auto-reply will be <strong>permanently deleted</strong> from your inbox. There is no copy in Trash. If you forget to disable this when you return, you will continue losing mail. Only use this if you are certain you do not need to read the messages received during your vacation.</small></p>
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

<cfoutput>
<script>
  // Saved values for the addresses multi-select (comma-separated from DB)
  var savedAddresses = "#JSStringFormat(vAddresses)#";

  $(document).ready(function() {
    var savedList = savedAddresses ? savedAddresses.split(',').map(function(s){ return s.trim(); }).filter(Boolean) : [];

    // Fetch the user's primary email + aliases for the dropdown options
    $.getJSON('./inc/get_user_addresses.cfm', function(data) {
      var opts = (data && data.addresses) ? data.addresses : [];
      var sel = document.getElementById('reply_addresses');

      // Add fetched addresses
      opts.forEach(function(a) {
        sel.appendChild(new Option(a, a));
      });
      // Make sure any saved value that isn't in the alias list is still present
      // (e.g. if an alias was removed after the user saved the rule)
      savedList.forEach(function(a) {
        if (opts.indexOf(a) === -1) {
          sel.appendChild(new Option(a, a));
        }
      });

      var ts = new TomSelect('##reply_addresses', {
        plugins: ['remove_button'],
        create: false,
        persist: true,
        sortField: { field: 'text', direction: 'asc' },
        placeholder: 'No restriction (reply to any address)',
        maxOptions: 100
      });
      ts.setValue(savedList);
    }).fail(function() {
      // If fetch fails, still init Tom Select on whatever is in the select
      new TomSelect('##reply_addresses', {
        plugins: ['remove_button'],
        create: false,
        placeholder: 'No restriction (reply to any address)'
      });
    });
  });
</script>
</cfoutput>

</body>
</html>
