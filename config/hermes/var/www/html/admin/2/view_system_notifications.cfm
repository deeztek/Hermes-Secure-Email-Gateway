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

<style>
  td {
   word-break: break-all;
  }
</style>

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
            <h1 class="m-0">System Notifications</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Notifications</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!--- CFML CODE STARTS HERE --->

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
    <cfif session.m is not "">
        <cfset m = session.m>
    </cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
    <cfset action = form.action>
</cfif>

<!--- GET CURRENT PUSHOVER SETTINGS --->
<cfquery name="getPushoverSettings" datasource="hermes">
    SELECT parameter, value FROM system_settings
    WHERE parameter IN ('pushover_enabled', 'pushover_api_token', 'pushover_user_key')
</cfquery>

<!--- SET DEFAULT VALUES --->
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

        <!--- Validate API token format (30 characters, alphanumeric) --->
        <cfif NOT REFind("^[a-zA-Z0-9]{30}$", Trim(form.pushover_api_token))>
            <cfset session.m = 4>
            <cflocation url="view_system_notifications.cfm" addtoken="no">
        </cfif>

        <!--- Validate User/Group key format (30 characters, alphanumeric) --->
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

    <cfset session.m = 1>
    <cflocation url="view_system_notifications.cfm" addtoken="no">

<!--- TEST PUSHOVER --->
<cfelseif action EQ "test_pushover">

    <!--- Get current settings --->
    <cfif pushover_enabled NEQ "1" OR Len(Trim(pushover_api_token)) EQ 0 OR Len(Trim(pushover_user_key)) EQ 0>
        <cfset session.m = 6>
        <cflocation url="view_system_notifications.cfm" addtoken="no">
    </cfif>

    <!--- Send test notification --->
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

<!--- CFML CODE ENDS HERE --->

<!--- ERROR/SUCCESS MESSAGES START HERE --->

<cfif m EQ "1">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        Pushover settings saved successfully
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "2">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The API Token field cannot be empty when Pushover is enabled
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "3">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The User/Group Key field cannot be empty when Pushover is enabled
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "4">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The API Token format is invalid. It should be 30 alphanumeric characters.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "5">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The User/Group Key format is invalid. It should be 30 alphanumeric characters.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "6">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        Pushover must be enabled and configured before sending a test notification. Please save your settings first.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "7">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        Test notification sent successfully! Check your Pushover app.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "8">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>Failed to send test notification. Error: #session.errordetail#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.errordetail = "">
</cfif>

<!--- ERROR/SUCCESS MESSAGES END HERE --->

<!--- PUSHOVER SETTINGS CARD --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-bell me-2"></i>Pushover Notifications</h3>
    </div>
    <div class="card-body">
        <div class="alert alert-info">
            <p class="mb-0"><i class="icon fas fa-info-circle"></i>
            Pushover enables push notifications to your mobile device for critical system alerts (e.g., mail queue issues, security events)
            where email delivery may fail. Create a free account at <a href="https://pushover.net" target="_blank">pushover.net</a>
            and create an application to get your API Token. Use a <strong>Group Key</strong> instead of a User Key to notify multiple administrators.
            </p>
        </div>

        <form name="pushover_settings" method="post" action="">
            <input type="hidden" name="action" value="save_pushover">

            <div class="mb-3">
                <label class="form-label"><strong>Pushover Notifications</strong></label>
                <select class="form-control" name="pushover_enabled" id="pushover_enabled" style="width: 100%">
                    <cfif pushover_enabled EQ "1">
                        <option value="1" selected>Enabled</option>
                        <option value="0">Disabled</option>
                    <cfelse>
                        <option value="0" selected>Disabled</option>
                        <option value="1">Enabled</option>
                    </cfif>
                </select>
            </div>

            <cfif pushover_enabled EQ "0">
            <div class="mb-3" id="pushover_fields" style="display:none;">
            <cfelse>
            <div class="mb-3" id="pushover_fields">
            </cfif>
                <div class="mb-3">
                    <label class="form-label"><strong>API Token (Application Token)</strong></label>
                    <cfoutput>
                    <input type="text" class="form-control" name="pushover_api_token" value="#pushover_api_token#" placeholder="Enter your Pushover API Token" maxlength="30">
                    </cfoutput>
                    <div class="form-text">The API Token from your Pushover application (30 characters)</div>
                </div>

                <div class="mb-3">
                    <label class="form-label"><strong>User/Group Key</strong></label>
                    <cfoutput>
                    <input type="text" class="form-control" name="pushover_user_key" value="#pushover_user_key#" placeholder="Enter your Pushover User or Group Key" maxlength="30">
                    </cfoutput>
                    <div class="form-text">Your User Key or a Group Key to notify multiple administrators (30 characters)</div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                <i class="fas fa-save me-1"></i> Save Settings
            </button>
        </form>

        <cfif pushover_enabled EQ "1" AND Len(Trim(pushover_api_token)) GT 0 AND Len(Trim(pushover_user_key)) GT 0>
        <hr>
        <form name="test_pushover" method="post" action="">
            <input type="hidden" name="action" value="test_pushover">
            <button type="submit" class="btn btn-secondary" onclick="this.disabled=true;this.innerHTML='Sending...';this.form.submit();">
                <i class="fas fa-paper-plane me-1"></i> Send Test Notification
            </button>
        </form>
        </cfif>
    </div>
</div>

<!--- FUTURE: NOTIFICATION TYPES CARD (placeholder for ofelia_config.ini integration) --->
<!---
<div class="card card-outline card-secondary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-list-check me-2"></i>Notification Types</h3>
    </div>
    <div class="card-body">
        <p class="text-muted">Future feature: Enable/disable specific notification types and configure their schedules.</p>
    </div>
</div>
--->

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
<!-- ./wrapper -->

</body>

<!--- SCRIPT TO SHOW/HIDE PUSHOVER FIELDS --->
<script>
$('#pushover_enabled').on('change', function(){
    if($(this).val() === "1"){
        $("#pushover_fields").show();
    } else {
        $("#pushover_fields").hide();
    }
});
</script>

</html>
