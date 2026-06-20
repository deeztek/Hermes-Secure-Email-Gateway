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
  <title>Hermes SEG | System Notifications</title>
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
            <h1 class="m-0">System Notifications</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Notifications</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "form_action")>
  <cfset action = form.form_action>
<cfelseif StructKeyExists(form, "action")>
  <cfset action = form.action>
</cfif>

<!--- GET CURRENT PUSHOVER SETTINGS --->
<cfquery name="getPushoverSettings" datasource="hermes">
    SELECT parameter, value FROM system_settings
    WHERE parameter IN ('pushover_enabled', 'pushover_api_token', 'pushover_user_key')
</cfquery>

<cfset pushover_enabled = "0">
<cfset pushover_api_token = "">
<cfset pushover_user_key = "">

<cfloop query="getPushoverSettings">
    <cfif parameter EQ "pushover_enabled">
        <cfset pushover_enabled = value>
    <cfelseif parameter EQ "pushover_api_token">
        <cfset pushover_api_token = value>
    <cfelseif parameter EQ "pushover_user_key">
        <cfset pushover_user_key = value>
    </cfif>
</cfloop>

<!--- TOGGLE NOTIFICATION --->
<cfif action EQ "toggle_notification">

    <cfif NOT StructKeyExists(form, "notification_id") OR NOT isValid("integer", form.notification_id)>
        <cfset session.m = 20>
        <cflocation url="view_system_notifications.cfm" addtoken="no">
    </cfif>

    <!--- Toggle enabled state in SQL --->
    <cfquery datasource="hermes">
        UPDATE pushover_notifications SET enabled = CASE WHEN enabled = 1 THEN 2 ELSE 1 END
        WHERE id = <cfqueryparam value="#form.notification_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Read back the new state and ofelia job name --->
    <cfquery name="getNotif" datasource="hermes">
        SELECT enabled AS notif_enabled, ofelia_job_name FROM pushover_notifications
        WHERE id = <cfqueryparam value="#form.notification_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Sync Ofelia job (only activate if Pushover is also enabled) --->
    <cfif pushover_enabled EQ "1" AND getNotif.notif_enabled EQ 1>
      <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET active = '1'
        WHERE job_name = <cfqueryparam value="#getNotif.ofelia_job_name#" cfsqltype="cf_sql_varchar">
      </cfquery>
    <cfelse>
      <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET active = '2'
        WHERE job_name = <cfqueryparam value="#getNotif.ofelia_job_name#" cfsqltype="cf_sql_varchar">
      </cfquery>
    </cfif>

    <cftry>
      <cfinclude template="./inc/ofelia_generate_config.cfm">
      <cfcatch type="any">
        <!--- Ofelia config generation failed, continue anyway --->
      </cfcatch>
    </cftry>

    <cfset session.m = 9>
    <cflocation url="view_system_notifications.cfm" addtoken="no">
</cfif>

<!--- PROCESS FORM SUBMISSION --->
<cfif action EQ "save_pushover">

    <!--- VALIDATE FORM FIELDS --->
    <cfif NOT StructKeyExists(form, "pushover_enabled")>
        <cfset m = "System Notifications: pushover_enabled does not exist">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    </cfif>

    <cfif form.pushover_enabled NEQ "0" AND form.pushover_enabled NEQ "1">
        <cfset m = "System Notifications: pushover_enabled is not 0 or 1">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    </cfif>

    <!--- If enabling Pushover, validate API token and user key --->
    <cfif form.pushover_enabled EQ "1">
        <cfif NOT StructKeyExists(form, "pushover_api_token") OR Len(Trim(form.pushover_api_token)) EQ 0>
            <cfset session.m = 2>
            <cflocation url="view_system_notifications.cfm" addtoken="no">
        </cfif>

        <cfif NOT StructKeyExists(form, "pushover_user_key") OR Len(Trim(form.pushover_user_key)) EQ 0>
            <cfset session.m = 3>
            <cflocation url="view_system_notifications.cfm" addtoken="no">
        </cfif>

        <cfif NOT REFind("^[a-zA-Z0-9]{30}$", Trim(form.pushover_api_token))>
            <cfset session.m = 4>
            <cflocation url="view_system_notifications.cfm" addtoken="no">
        </cfif>

        <cfif NOT REFind("^[a-zA-Z0-9]{30}$", Trim(form.pushover_user_key))>
            <cfset session.m = 5>
            <cflocation url="view_system_notifications.cfm" addtoken="no">
        </cfif>
    </cfif>

    <!--- UPDATE PUSHOVER SETTINGS --->
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pushover_enabled#">
        WHERE parameter = 'pushover_enabled'
    </cfquery>

    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.pushover_api_token)#">
        WHERE parameter = 'pushover_api_token'
    </cfquery>

    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.pushover_user_key)#">
        WHERE parameter = 'pushover_user_key'
    </cfquery>

    <!--- Sync Ofelia jobs: enable jobs for enabled notifications, disable all if Pushover off --->
    <cfif form.pushover_enabled EQ "1">
      <!--- Enable Ofelia jobs only for individually enabled notifications --->
      <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET active = '1'
        WHERE type = 'pushover'
          AND job_name IN (SELECT ofelia_job_name FROM pushover_notifications WHERE enabled = '1')
      </cfquery>
      <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET active = '2'
        WHERE type = 'pushover'
          AND job_name NOT IN (SELECT ofelia_job_name FROM pushover_notifications WHERE enabled = '1')
      </cfquery>
    <cfelse>
      <!--- Pushover disabled — disable all pushover Ofelia jobs --->
      <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET active = '2' WHERE type = 'pushover'
      </cfquery>
    </cfif>
    <cfinclude template="./inc/ofelia_generate_config.cfm">

    <cfset session.m = 1>
    <cflocation url="view_system_notifications.cfm" addtoken="no">

<!--- TEST PUSHOVER --->
<cfelseif action EQ "test_pushover">

    <cfif pushover_enabled NEQ "1" OR Len(Trim(pushover_api_token)) EQ 0 OR Len(Trim(pushover_user_key)) EQ 0>
        <cfset session.m = 6>
        <cflocation url="view_system_notifications.cfm" addtoken="no">
    </cfif>

    <cftry>
        <cfhttp url="https://api.pushover.net/1/messages.json" method="POST" result="pushoverResult">
            <cfhttpparam type="formfield" name="token" value="#pushover_api_token#">
            <cfhttpparam type="formfield" name="user" value="#pushover_user_key#">
            <cfhttpparam type="formfield" name="title" value="Hermes SEG: Test Notification">
            <cfhttpparam type="formfield" name="message" value="This is a test notification from Hermes SEG. If you received this, Pushover is configured correctly!">
            <cfhttpparam type="formfield" name="priority" value="0">
            <cfhttpparam type="formfield" name="sound" value="pushover">
        </cfhttp>

        <cfif pushoverResult.statusCode CONTAINS "200">
            <cfset session.m = 7>
        <cfelse>
            <cfset session.m = 8>
            <cfset session.errordetail = pushoverResult.fileContent>
        </cfif>

        <cfcatch type="any">
            <cfset session.m = 8>
            <cfset session.errordetail = cfcatch.message>
        </cfcatch>
    </cftry>

    <cflocation url="view_system_notifications.cfm" addtoken="no">

</cfif>

<!--- Re-read pushover_enabled after save actions --->
<cfquery name="getPushoverEnabled" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'pushover_enabled'
</cfquery>
<cfset pushover_enabled = getPushoverEnabled.value>

<!--- Get available notifications --->
<cfquery name="getNotifications" datasource="hermes">
    SELECT id, name, display_name, description, ofelia_job_name, enabled AS is_enabled, category
    FROM pushover_notifications ORDER BY category, display_name
</cfquery>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m EQ "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Pushover settings saved successfully.
  </div>
</cfif>
<cfif m EQ "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The API Token field cannot be empty when Pushover is enabled.
  </div>
</cfif>
<cfif m EQ "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The User/Group Key field cannot be empty when Pushover is enabled.
  </div>
</cfif>
<cfif m EQ "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The API Token format is invalid. It should be 30 alphanumeric characters.
  </div>
</cfif>
<cfif m EQ "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The User/Group Key format is invalid. It should be 30 alphanumeric characters.
  </div>
</cfif>
<cfif m EQ "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Pushover must be enabled and configured before sending a test notification.
  </div>
</cfif>
<cfif m EQ "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Test notification sent successfully! Check your Pushover app.
  </div>
</cfif>
<cfif m EQ "8">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <cfif StructKeyExists(session, "errordetail") AND session.errordetail is not "">
      <cfoutput>Failed to send test notification. Error: #encodeForHTML(session.errordetail)#</cfoutput>
      <cfset session.errordetail = "">
    <cfelse>
      Failed to send test notification.
    </cfif>
  </div>
</cfif>
<cfif m EQ "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Notification setting updated.
  </div>
</cfif>
<cfif m EQ "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
</cfif>

<!-- PUSHOVER SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-bell"></i> Pushover Settings</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info mb-3">
      <p class="mb-0"><i class="icon fas fa-info-circle"></i>
        Pushover enables push notifications to your mobile device for critical system alerts (e.g., mail queue issues, security events)
        where email delivery may fail. Create a free account at <a href="https://pushover.net" target="_blank">pushover.net</a>
        and create an application to get your API Token. Use a <strong>Group Key</strong> instead of a User Key to notify multiple administrators.
      </p>
    </div>

    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_pushover">

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Pushover Notifications</strong></label>
            <select class="form-select" name="pushover_enabled" id="pushover_enabled">
              <option value="1" <cfif pushover_enabled EQ "1">selected</cfif>>Enabled</option>
              <option value="0" <cfif pushover_enabled EQ "0">selected</cfif>>Disabled</option>
            </select>
          </div>
        </div>
      </div>

      <div id="pushover_fields" <cfif pushover_enabled EQ "0">style="display:none;"</cfif>>
        <div class="row">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>API Token (Application Token)</strong></label>
              <cfoutput>
              <input type="text" class="form-control" name="pushover_api_token" value="#encodeForHTMLAttribute(pushover_api_token)#" placeholder="Enter your Pushover API Token" maxlength="30">
              </cfoutput>
              <div class="form-text">The API Token from your Pushover application (30 characters)</div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>User/Group Key</strong></label>
              <cfoutput>
              <input type="text" class="form-control" name="pushover_user_key" value="#encodeForHTMLAttribute(pushover_user_key)#" placeholder="Enter your Pushover User or Group Key" maxlength="30">
              </cfoutput>
              <div class="form-text">Your User Key or a Group Key to notify multiple administrators (30 characters)</div>
            </div>
          </div>
        </div>
      </div>

      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
        <i class="fas fa-save"></i> Save Settings
      </button>
    </form>

    <cfif pushover_enabled EQ "1" AND Len(Trim(pushover_api_token)) GT 0 AND Len(Trim(pushover_user_key)) GT 0>
    <hr>
    <form method="post">
      <input type="hidden" name="action" value="test_pushover">
      <button type="submit" class="btn btn-secondary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Sending...';this.form.submit();">
        <i class="fas fa-paper-plane"></i> Send Test Notification
      </button>
    </form>
    </cfif>
  </div>
</div>

<!-- AVAILABLE NOTIFICATIONS CARD (only visible when Pushover is enabled) -->
<cfif pushover_enabled EQ "1">
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list-check"></i> Available Notifications</h3>
  </div>
  <div class="card-body">

    <cfif getNotifications.recordcount EQ 0>
      <p class="text-muted">No notifications available.</p>
    <cfelse>
      <cfoutput query="getNotifications">
        <div class="d-flex align-items-start justify-content-between py-3 <cfif getNotifications.currentRow LT getNotifications.recordcount>border-bottom</cfif>">
          <div class="d-flex align-items-start">
            <div class="me-3 mt-1">
              <span style="font-size:1.5rem; cursor:pointer;" onclick="toggleNotification(#getNotifications.id#, this);">
                <cfif getNotifications.is_enabled IS "1">
                  <i class="fas fa-toggle-on text-success"></i>
                <cfelse>
                  <i class="fas fa-toggle-off text-secondary"></i>
                </cfif>
              </span>
            </div>
            <div>
              <strong>#encodeForHTML(getNotifications.display_name)#</strong>
              <cfif Len(Trim(getNotifications.description))>
                <br><small class="text-muted">#encodeForHTML(getNotifications.description)#</small>
              </cfif>
            </div>
          </div>
        </div>
      </cfoutput>
    </cfif>

  </div>
</div>
</cfif>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
$('#pushover_enabled').on('change', function() {
  if ($(this).val() === '1') {
    $('#pushover_fields').slideDown();
  } else {
    $('#pushover_fields').slideUp();
  }
});

var _toggleSubmitting = false;
function toggleNotification(notifId, el) {
  if (_toggleSubmitting) return;
  _toggleSubmitting = true;
  if (el) el.style.opacity = '0.5';

  var f = document.createElement('form');
  f.method = 'POST';
  f.setAttribute('action', 'view_system_notifications.cfm');
  f.style.display = 'none';

  var a = document.createElement('input');
  a.type = 'hidden';
  a.name = 'form_action';
  a.value = 'toggle_notification';
  f.appendChild(a);

  var n = document.createElement('input');
  n.type = 'hidden';
  n.name = 'notification_id';
  n.value = notifId;
  f.appendChild(n);

  document.body.appendChild(f);
  f.submit();
}
</script>

</body>
</html>
