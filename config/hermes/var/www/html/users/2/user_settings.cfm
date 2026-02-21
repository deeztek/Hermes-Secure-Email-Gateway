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
  <title>Hermes SEG | Account Settings</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<!--- INITIALIZE MESSAGE VARIABLES --->
<cfparam name="session.message" default="">
<cfparam name="session.messageType" default="">

<!--- PROCESS FORM SUBMISSION --->
<cfif StructKeyExists(form, "action")>
    <cfif form.action EQ "save_secondary_email">
        <cfinclude template="./inc/save_secondary_email.cfm">
    <cfelseif form.action EQ "resend_verification">
        <cfinclude template="./inc/resend_secondary_email_verification.cfm">
    <cfelseif form.action EQ "remove_secondary_email">
        <cfinclude template="./inc/remove_secondary_email.cfm">
    </cfif>
</cfif>

<!--- GET CURRENT USER SETTINGS --->
<cfquery name="getUserSettings" datasource="hermes">
    SELECT secondary_email, secondary_email_verified, pushover_enabled, pushover_user_key
    FROM user_settings
    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
</cfquery>

<cfset currentSecondaryEmail = "">
<cfset secondaryEmailVerified = 0>
<cfif getUserSettings.recordcount GTE 1>
    <cfset currentSecondaryEmail = getUserSettings.secondary_email>
    <cfset secondaryEmailVerified = getUserSettings.secondary_email_verified>
</cfif>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Account Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Account Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <!--- DISPLAY MESSAGES --->
        <cfif session.message NEQ "">
            <div class="alert alert-<cfoutput>#session.messageType#</cfoutput> alert-dismissible">
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                <cfoutput>#session.message#</cfoutput>
            </div>
            <cfset session.message = "">
            <cfset session.messageType = "">
        </cfif>

        <!--- ONLY SHOW FOR MAILBOX USERS --->
        <cfif session.theGroups CONTAINS "mailboxes">

        <div class="alert alert-warning">
            <p><i class="icon fas fa-exclamation-triangle"></i>Set a secondary email address for password recovery. If you forget your password, a reset link will be sent to this email address. <strong>This must be an external email address</strong> (e.g., Gmail, Yahoo, Outlook) that you can access independently of this system. Email addresses from domains handled by this system are not allowed.</p>
        </div>

        <cfif currentSecondaryEmail NEQ "">
            <!--- SECONDARY EMAIL IS SET --->
            <div class="mb-3">
                <label class="form-label fw-bold">Current Recovery Email:</label>
                <div class="input-group">
                    <span class="form-control"><cfoutput>#currentSecondaryEmail#</cfoutput></span>
                    <cfif secondaryEmailVerified EQ 1>
                        <span class="input-group-text text-bg-success">
                            <i class="fas fa-check-circle me-1"></i> Verified
                        </span>
                    <cfelse>
                        <span class="input-group-text text-bg-warning">
                            <i class="fas fa-exclamation-triangle me-1"></i> Not Verified
                        </span>
                    </cfif>
                </div>
            </div>

            <cfif secondaryEmailVerified EQ 0>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    Your recovery email has not been verified. Please check your inbox for the verification email
                    or click the button below to resend it.
                </div>

                <form method="post" action="user_settings.cfm" class="mb-3">
                    <input type="hidden" name="action" value="resend_verification">
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-paper-plane me-1"></i> Resend Verification Email
                    </button>
                </form>
            </cfif>

            <hr>

            <h5>Update Recovery Email</h5>
            <form method="post" action="user_settings.cfm">
                <input type="hidden" name="action" value="save_secondary_email">
                <div class="mb-3">
                    <label class="form-label">New Recovery Email Address</label>
                    <input type="email" name="secondary_email" class="form-control" placeholder="Enter new recovery email" required>
                    <div class="form-text">Must be an external email address. A verification email will be sent.</div>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-1"></i> Update Recovery Email
                </button>
            </form>

            <hr>

            <form method="post" action="user_settings.cfm" onsubmit="return confirm('Are you sure you want to remove your recovery email? You will not be able to reset your password via email.');">
                <input type="hidden" name="action" value="remove_secondary_email">
                <button type="submit" class="btn btn-outline-danger btn-sm">
                    <i class="fas fa-trash me-1"></i> Remove Recovery Email
                </button>
            </form>

        <cfelse>
            <!--- NO SECONDARY EMAIL SET --->
            <div class="alert alert-info">
                <i class="fas fa-lightbulb me-2"></i>
                <strong>Tip:</strong> Setting up a recovery email allows you to reset your password
                yourself if you ever forget it. Without a recovery email, you will need to contact
                an administrator for password resets.
            </div>

            <form method="post" action="user_settings.cfm">
                <input type="hidden" name="action" value="save_secondary_email">
                <div class="mb-3">
                    <label class="form-label">Recovery Email Address</label>
                    <input type="email" name="secondary_email" class="form-control" placeholder="Enter your recovery email" required>
                    <div class="form-text">Must be an external email address. A verification email will be sent.</div>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-1"></i> Save Recovery Email
                </button>
            </form>
        </cfif>

        <cfelse>
            <!--- NOT A MAILBOX USER --->
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Account settings are only available for mailbox users. Relay users can reset their password
                using the <a href="/user-auth/forgot_password.cfm">Forgot Password</a> feature.
            </div>
        </cfif>

      </div>
    </div>
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
<!-- ./wrapper -->

</body>
</html>
