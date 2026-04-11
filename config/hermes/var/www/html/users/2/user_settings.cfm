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

<!--- SCRIPT TO SHOW/HIDE PASSWORD FIELDS --->
<script>
$(document).ready(function() {
    $("#oldpasswordfield a").on('click', function(event) {
        event.preventDefault();
        if($('#oldpasswordfield input').attr("type") == "text"){
            $('#oldpasswordfield input').attr('type', 'password');
            $('#oldpasswordfield i').addClass( "fa-eye-slash" );
            $('#oldpasswordfield i').removeClass( "fa-eye" );
        }else if($('#oldpasswordfield input').attr("type") == "password"){
            $('#oldpasswordfield input').attr('type', 'text');
            $('#oldpasswordfield i').removeClass( "fa-eye-slash" );
            $('#oldpasswordfield i').addClass( "fa-eye" );
        }
    });
});
</script>

<script>
$(document).ready(function() {
    $("#newpasswordfield a").on('click', function(event) {
        event.preventDefault();
        if($('#newpasswordfield input').attr("type") == "text"){
            $('#newpasswordfield input').attr('type', 'password');
            $('#newpasswordfield i').addClass( "fa-eye-slash" );
            $('#newpasswordfield i').removeClass( "fa-eye" );
        }else if($('#newpasswordfield input').attr("type") == "password"){
            $('#newpasswordfield input').attr('type', 'text');
            $('#newpasswordfield i').removeClass( "fa-eye-slash" );
            $('#newpasswordfield i').addClass( "fa-eye" );
        }
    });
});
</script>

</head>

<!--- INITIALIZE MESSAGE VARIABLES --->
<cfparam name="session.message" default="">
<cfparam name="session.messageType" default="">

<!--- PASSWORD CHANGE MESSAGE VARIABLE --->
<cfparam name="session.pwdMessage" default="">
<cfparam name="session.pwdMessageType" default="">

<!--- 2FA MESSAGE VARIABLE --->
<cfparam name="session.mfaMessage" default="">
<cfparam name="session.mfaMessageType" default="">

<!--- PROCESS FORM SUBMISSION --->
<cfif StructKeyExists(form, "action")>
    <cfif form.action EQ "save_secondary_email">
        <cfinclude template="./inc/save_secondary_email.cfm">
    <cfelseif form.action EQ "resend_verification">
        <cfinclude template="./inc/resend_secondary_email_verification.cfm">
    <cfelseif form.action EQ "remove_secondary_email">
        <cfinclude template="./inc/remove_secondary_email.cfm">
    <cfelseif form.action EQ "save_timezone">
        <cfinclude template="./inc/save_timezone.cfm">
    <cfelseif form.action EQ "changepassword">
        <!--- BLOCK PASSWORD CHANGE FOR REMOTE AUTH USERS --->
        <cfquery name="checkUserAuthType" datasource="hermes">
            SELECT auth_type FROM recipients WHERE recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
        </cfquery>
        <cfif checkUserAuthType.recordcount GT 0 AND checkUserAuthType.auth_type EQ "remote">
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Not Allowed</h4>Your account uses Remote Authentication. Password changes must be made through your organization's directory service.">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- PROCESS PASSWORD CHANGE --->
        <cfset pwdStep = 0>
        <cfparam name="form.hibp" default="YES">

        <!--- VALIDATE OLD PASSWORD --->
        <cfif NOT StructKeyExists(form, "oldpassword") OR form.oldpassword EQ "">
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The Existing Password field cannot be blank">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- VALIDATE NEW PASSWORD --->
        <cfif NOT StructKeyExists(form, "newpassword") OR form.newpassword EQ "">
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The New Password field cannot be blank">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- VALIDATE PASSWORD LENGTH (8-64 chars) --->
        <cfif len(form.newpassword) LT 8 OR len(form.newpassword) GT 64>
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The New Password must be between 8 and 64 characters">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- VALIDATE HIBP FIELD --->
        <cfif form.hibp NEQ "YES" AND form.hibp NEQ "NO">
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Invalid value for password check option">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- STEP 1: GET LDAP USERNAME FOR THIS USER --->
        <cfquery name="getLdapUsername" datasource="hermes">
            SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
        </cfquery>

        <cfif getLdapUsername.recordcount EQ 1 AND getLdapUsername.ldap_username NEQ "">
            <cfset ldapUsername = getLdapUsername.ldap_username>
        <cfelse>
            <!--- Not in database - query LDAP directly by email --->
            <cfset userEmail = session.email>
            <cfinclude template="/user-auth/inc/ldap_get_user_groups.cfm">

            <cfif ldapUserFound AND ldapUsername NEQ "">
                <!--- Found in LDAP --->
            <cfelse>
                <!--- No LDAP user found - cannot change password --->
                <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Your account is not configured for password changes. Please contact your system administrator.">
                <cfset session.pwdMessageType = "danger">
                <cflocation url="user_settings.cfm" addtoken="no">
            </cfif>
        </cfif>

        <!--- STEP 2: VERIFY OLD PASSWORD VIA LDAP BIND --->
        <cfset ldapOU = "users">
        <cfset ldapBindDN = "cn=#ldapUsername#,ou=#ldapOU#,dc=hermes,dc=local">

        <cftry>
            <!--- Generate unique temp filename --->
            <cfinclude template="/admin/2/inc/generate_customtrans.cfm">

            <!--- Write password to temp file to avoid shell escaping issues --->
            <cfset tempPwdFile = "/opt/hermes/tmp/#customtrans3#_pwd.txt">
            <cffile action="write" file="#tempPwdFile#" output="#form.oldpassword#" addNewLine="no">

            <!--- Use ldapwhoami to verify password - binds and returns DN if successful --->
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_ldap ldapwhoami -x -D '#ldapBindDN#' -y /opt/hermes/tmp/#customtrans3#_pwd.txt"
                variable="ldapWhoamiResult"
                errorVariable="ldapWhoamiError"
                timeout="30">
            </cfexecute>

            <!--- Cleanup temp password file --->
            <cfif fileExists(tempPwdFile)>
                <cffile action="delete" file="#tempPwdFile#">
            </cfif>

            <!--- Check if bind was successful --->
            <cfif ldapWhoamiResult CONTAINS "dn:" OR ldapWhoamiResult CONTAINS ldapUsername>
                <!--- Bind was successful - password is correct --->
                <cfset pwdStep = 2>
            <cfelse>
                <!--- Bind failed - check error --->
                <cfif ldapWhoamiError CONTAINS "Invalid credentials" OR ldapWhoamiError CONTAINS "49">
                    <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The Existing Password you entered is incorrect">
                    <cfset session.pwdMessageType = "danger">
                    <cflocation url="user_settings.cfm" addtoken="no">
                <cfelse>
                    <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>There was a problem verifying your password. Please try again or contact your system administrator.">
                    <cfset session.pwdMessageType = "danger">
                    <cflocation url="user_settings.cfm" addtoken="no">
                </cfif>
            </cfif>

        <cfcatch type="any">
            <!--- Cleanup temp password file on error --->
            <cfif isDefined("tempPwdFile") AND fileExists(tempPwdFile)>
                <cffile action="delete" file="#tempPwdFile#">
            </cfif>
            <!--- LDAP bind failed --->
            <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The Existing Password you entered is incorrect">
            <cfset session.pwdMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfcatch>
        </cftry>

        <!--- STEP 3: CHECK AGAINST HAVEIBEENPWNED (if enabled) --->
        <cfif pwdStep EQ 2>
            <cfif form.hibp EQ "YES">
                <cfinclude template="./inc/get_system_token.cfm">

                <cfif getsystoken.recordcount EQ 1 AND getsystoken.token NEQ "">
                    <cfset THETOKEN = getsystoken.token>
                    <cfset urlencodedpassword = URLEncodedFormat(Trim(form.newpassword))>

                    <cfhttp method="POST" charset="utf-8" throwonerror="false" url="http://127.0.0.1:8888/hermes-api/">
                        <cfhttpparam name="accept" type="header" value="accept: */*">
                        <cfhttpparam name="X-Original-URL" type="header" value="/admin/2/inc/check_hibp.cfm?type=api&password=#urlencodedpassword#">
                        <cfhttpparam name="X-Token" type="header" value="#THETOKEN#">
                    </cfhttp>

                    <cfif cfhttp.fileContent contains "Hash Not Found">
                        <cfset pwdStep = 3>
                    <cfelseif cfhttp.fileContent contains "Hash Found">
                        <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>The New Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href='https://haveibeenpwned.com/Passwords' target='_blank'>haveibeenpwned.com</a>">
                        <cfset session.pwdMessageType = "danger">
                        <cflocation url="user_settings.cfm" addtoken="no">
                    <cfelseif cfhttp.fileContent contains "Hibp Unreachable">
                        <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again">
                        <cfset session.pwdMessageType = "danger">
                        <cflocation url="user_settings.cfm" addtoken="no">
                    <cfelse>
                        <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again">
                        <cfset session.pwdMessageType = "danger">
                        <cflocation url="user_settings.cfm" addtoken="no">
                    </cfif>
                <cfelse>
                    <!--- Token not found, skip HIBP check --->
                    <cfset pwdStep = 3>
                </cfif>
            <cfelse>
                <!--- HIBP check disabled --->
                <cfset pwdStep = 3>
            </cfif>
        </cfif>

        <!--- STEP 4: CHANGE PASSWORD IN LDAP --->
        <cfif pwdStep EQ 3>
            <cfset newPassword = form.newpassword>
            <cfinclude template="/user-auth/inc/ldap_modify_user_password.cfm">

            <cfif ldapPasswordModified>
                <cfinclude template="./inc/send_changed_password_email.cfm">
                <cfset session.pwdMessage = "<h4><i class='icon fa fa-check'></i> Success!</h4>Your Password was changed successfully. Please ensure you use the new password to login from now on">
                <cfset session.pwdMessageType = "success">
                <cflocation url="user_settings.cfm" addtoken="no">
            <cfelse>
                <cfset session.pwdMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>There was a problem changing your password. Please try again or contact your system administrator.">
                <cfset session.pwdMessageType = "danger">
                <cflocation url="user_settings.cfm" addtoken="no">
            </cfif>
        </cfif>
    <cfelseif form.action EQ "toggle_mfa">
        <!--- PROCESS 2FA TOGGLE --->
        <cfif NOT StructKeyExists(form, "mfa_setting") OR (form.mfa_setting NEQ "enable" AND form.mfa_setting NEQ "disable")>
            <cfset session.mfaMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Invalid 2FA setting value">
            <cfset session.mfaMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfif>

        <!--- GET LDAP USERNAME FOR THIS USER --->
        <cfquery name="getLdapUsernameMfa" datasource="hermes">
            SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
        </cfquery>

        <cfif getLdapUsernameMfa.recordcount EQ 1 AND getLdapUsernameMfa.ldap_username NEQ "">
            <cfset ldapUsername = getLdapUsernameMfa.ldap_username>
        <cfelse>
            <!--- Not in database - query LDAP directly by email --->
            <cfset userEmail = session.email>
            <cfinclude template="/user-auth/inc/ldap_get_user_groups.cfm">

            <cfif NOT ldapUserFound OR ldapUsername EQ "">
                <cfset session.mfaMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>Your account is not configured for 2FA changes. Please contact your system administrator.">
                <cfset session.mfaMessageType = "danger">
                <cflocation url="user_settings.cfm" addtoken="no">
            </cfif>
        </cfif>

        <!--- DETERMINE CURRENT AND NEW ACCESS CONTROL --->
        <cfif form.mfa_setting EQ "enable">
            <cfset ldapOldAccessControl = "one_factor">
            <cfset ldapNewAccessControl = "two_factor">
        <cfelse>
            <cfset ldapOldAccessControl = "two_factor">
            <cfset ldapNewAccessControl = "one_factor">
        </cfif>

        <!--- CHANGE ACCESS CONTROL GROUP --->
        <cftry>
            <cfinclude template="/admin/2/inc/ldap_change_user_access_control.cfm">

            <!--- UPDATE SESSION GROUPS (using native list functions) --->
            <cfif form.mfa_setting EQ "enable">
                <!--- Remove one_factor and add two_factor --->
                <cfset oneFactorPos = ListFindNoCase(session.theGroups, "one_factor")>
                <cfif oneFactorPos GT 0>
                    <cfset session.theGroups = ListDeleteAt(session.theGroups, oneFactorPos)>
                </cfif>
                <cfif NOT ListFindNoCase(session.theGroups, "two_factor")>
                    <cfset session.theGroups = ListAppend(session.theGroups, "two_factor")>
                </cfif>
                <cfset session.mfaMessage = "<h4><i class='icon fa fa-check'></i> Success!</h4>Two-Factor Authentication has been enabled. You will be prompted to set up your authenticator app on your next login.">
            <cfelse>
                <!--- Remove two_factor and add one_factor --->
                <cfset twoFactorPos = ListFindNoCase(session.theGroups, "two_factor")>
                <cfif twoFactorPos GT 0>
                    <cfset session.theGroups = ListDeleteAt(session.theGroups, twoFactorPos)>
                </cfif>
                <cfif NOT ListFindNoCase(session.theGroups, "one_factor")>
                    <cfset session.theGroups = ListAppend(session.theGroups, "one_factor")>
                </cfif>
                <cfset session.mfaMessage = "<h4><i class='icon fa fa-check'></i> Success!</h4>Two-Factor Authentication has been disabled.">
            </cfif>
            <cfset session.mfaMessageType = "success">
            <cflocation url="user_settings.cfm" addtoken="no">

        <cfcatch type="any">
            <cfset session.mfaMessage = "<h4><i class='icon fa fa-ban'></i> Oops!</h4>There was a problem changing your 2FA setting. Please try again or contact your system administrator.">
            <cfset session.mfaMessageType = "danger">
            <cflocation url="user_settings.cfm" addtoken="no">
        </cfcatch>
        </cftry>
    </cfif>
</cfif>

<!--- GET CURRENT USER SETTINGS --->
<cfquery name="getUserSettings" datasource="hermes">
    SELECT secondary_email, secondary_email_verified, timezone
    FROM user_settings
    WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
</cfquery>

<cfset currentSecondaryEmail = "">
<cfset secondaryEmailVerified = 0>
<cfset currentTimezone = "">
<cfif getUserSettings.recordcount GTE 1>
    <cfset currentSecondaryEmail = getUserSettings.secondary_email>
    <cfset secondaryEmailVerified = getUserSettings.secondary_email_verified>
    <cfset currentTimezone = getUserSettings.timezone>
</cfif>

<!--- Fall back to system TZ if user has no value yet --->
<cfif currentTimezone EQ "">
    <cfinclude template="../../admin/2/inc/get_user_timezone.cfm">
    <cfset currentTimezone = getUserTimezone(session.email)>
</cfif>

<!--- Build the IANA timezone list once for the dropdown --->
<cfset zoneIdClass = createObject("java", "java.time.ZoneId")>
<cfset availableZones = zoneIdClass.getAvailableZoneIds().toArray()>
<cfset tzList = []>
<cfloop array="#availableZones#" index="z">
    <cfset ArrayAppend(tzList, z)>
</cfloop>
<cfset ArraySort(tzList, "textnocase")>

<cfparam name="session.tzMessage" default="">
<cfparam name="session.tzMessageType" default="">

<!--- Check if vacation auto-reply has start/end times set so we can warn
     the user that wall-clock values stay the same when changing TZ --->
<cfquery name="getVacationForTzWarn" datasource="hermes">
    SELECT enabled, start_date, end_date
    FROM user_vacation
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
      AND enabled = 1
      AND (start_date IS NOT NULL OR end_date IS NOT NULL)
</cfquery>
<cfset vacationHasTimes = (getVacationForTzWarn.recordcount GTE 1)>
<cfset vacationStartDisplay = "">
<cfset vacationEndDisplay = "">
<cfif vacationHasTimes>
    <cfif IsDate(getVacationForTzWarn.start_date)>
        <cfset vacationStartDisplay = DateFormat(getVacationForTzWarn.start_date, "yyyy/mm/dd") & " " & TimeFormat(getVacationForTzWarn.start_date, "HH:mm")>
    </cfif>
    <cfif IsDate(getVacationForTzWarn.end_date)>
        <cfset vacationEndDisplay = DateFormat(getVacationForTzWarn.end_date, "yyyy/mm/dd") & " " & TimeFormat(getVacationForTzWarn.end_date, "HH:mm")>
    </cfif>
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

        <!--- DISPLAY RECOVERY EMAIL MESSAGES --->
        <cfif session.message NEQ "">
            <div class="alert alert-<cfoutput>#session.messageType#</cfoutput> alert-dismissible">
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                <cfoutput>#session.message#</cfoutput>
            </div>
            <cfset session.message = "">
            <cfset session.messageType = "">
        </cfif>

        <!--- DISPLAY PASSWORD CHANGE MESSAGES --->
        <cfif session.pwdMessage NEQ "">
            <div class="alert alert-<cfoutput>#session.pwdMessageType#</cfoutput> alert-dismissible">
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                <cfoutput>#session.pwdMessage#</cfoutput>
            </div>
            <cfset session.pwdMessage = "">
            <cfset session.pwdMessageType = "">
        </cfif>

        <!--- DISPLAY 2FA MESSAGES --->
        <cfif session.mfaMessage NEQ "">
            <div class="alert alert-<cfoutput>#session.mfaMessageType#</cfoutput> alert-dismissible">
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                <cfoutput>#session.mfaMessage#</cfoutput>
            </div>
            <cfset session.mfaMessage = "">
            <cfset session.mfaMessageType = "">
        </cfif>

        <!--- CHECK IF USER IS REMOTE AUTH --->
        <cfquery name="getUserAuthType" datasource="hermes">
            SELECT auth_type FROM recipients WHERE recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
        </cfquery>
        <cfset isRemoteAuth = getUserAuthType.recordcount GT 0 AND getUserAuthType.auth_type EQ "remote">

        <!--- CHANGE PASSWORD SECTION (LOCAL USERS ONLY) --->
        <cfif isRemoteAuth>
        <div class="card card-outline card-secondary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-key me-2"></i>Change Password</h3>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <p class="mb-0"><i class="icon fas fa-info-circle"></i>Your account uses <strong>Remote Authentication</strong>. Password changes must be made through your organization's directory service. Please contact your IT administrator if you need to change your password.</p>
                </div>
            </div>
        </div>
        <cfelse>
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-key me-2"></i>Change Password</h3>
            </div>
            <div class="card-body">
                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Enter your existing password in the <strong>Existing Password</strong> field, enter the new password in the <strong>New Password</strong> field and click the <strong>Change Password</strong> button below. Click the <i class="fa fa-eye-slash" aria-hidden="true"></i> icon to show the password you've typed in order to verify accuracy. Passwords must be <strong>between 8 and 64 characters long.</strong> It's highly recommended to leave the <strong>Check against haveibeenpwned.com</strong> field set to <strong>YES</strong> in order to check your password against known data breaches.</p>
                </div>

                <form action="user_settings.cfm" method="post">
                    <input type="hidden" name="action" value="changepassword">

                    <div class="mb-3" id="oldpasswordfield">
                        <label for="oldpassword" class="form-label"><strong>Existing Password</strong></label>
                        <div class="input-group">
                            <input type="password" class="form-control" name="oldpassword" value="" id="oldpassword" placeholder="Enter Existing Password" maxLength="64">
                            <a href="" class="input-group-text"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        </div>
                    </div>

                    <div class="mb-3" id="newpasswordfield">
                        <label for="newpassword" class="form-label"><strong>New Password</strong></label>
                        <div class="input-group">
                            <input type="password" class="form-control" name="newpassword" value="" id="newpassword" placeholder="Enter New Password" maxLength="64">
                            <a href="" class="input-group-text"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Check against haveibeenpwned.com</strong></label>
                        <select class="form-control" name="hibp" style="width: 100%;">
                            <option value="YES" selected>YES (Recommended)</option>
                            <option value="NO">NO</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                        <i class="fas fa-save me-1"></i> Change Password
                    </button>
                </form>
            </div>
        </div>
        </cfif>

        <!--- TWO-FACTOR AUTHENTICATION SECTION (ALL USERS) --->
        <!--- Query LDAP directly for accurate 2FA status (session may be stale) --->
        <cfset mfaEnabled = false>
        <cftry>
            <!--- Get the user's LDAP username --->
            <cfquery name="getUserLdapName" datasource="hermes">
                SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
            </cfquery>
            <cfset userLdapName = "">
            <cfif getUserLdapName.recordcount EQ 1 AND getUserLdapName.ldap_username NEQ "">
                <cfset userLdapName = LCase(getUserLdapName.ldap_username)>
            <cfelse>
                <cfset userLdapName = LCase(session.email)>
            </cfif>

            <!--- Query LDAP for two_factor group members --->
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=two_factor,ou=groups,dc=hermes,dc=local' -LLL member"
                variable="twoFactorMembers"
                errorVariable="ldapError"
                timeout="30">
            </cfexecute>

            <!--- Check if user is in the two_factor group --->
            <cfif twoFactorMembers CONTAINS "cn=#userLdapName#,ou=users,dc=hermes,dc=local">
                <cfset mfaEnabled = true>
            </cfif>
        <cfcatch type="any">
            <!--- On error, fall back to session check --->
            <cfset mfaEnabled = session.theGroups CONTAINS "two_factor">
        </cfcatch>
        </cftry>
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-shield-alt me-2"></i>Two-Factor Authentication (2FA)</h3>
            </div>
            <div class="card-body">
                <cfif session.theGroups CONTAINS "mailboxes">
                <div class="alert alert-info">
                    <p class="mb-2"><i class="icon fas fa-info-circle"></i><strong>Important:</strong> Two-Factor Authentication only applies to web-based logins (User Console and Webmail). It does <strong>not</strong> affect email client connections such as IMAP, POP3, or SMTP. Your email applications will continue to use your regular password.</p>
                    <p class="mb-0"><i class="icon fas fa-mobile-alt"></i><strong>Groupware Apps:</strong> Once 2FA is enabled, third-party apps that sync with Webmail groupware services (Contacts, Calendar, Tasks, Notes) will require <strong>app-specific passwords</strong>. You can generate these in <strong>Webmail &gt; Profile &gt; Personal Settings &gt; Security &gt; Devices &amp; Sessions &gt; Create new app password</strong>.</p>
                </div>
                </cfif>

                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Two-Factor Authentication adds an extra layer of security to your account by requiring a one-time code from an authenticator app (such as Google Authenticator, Microsoft Authenticator, or Authy) in addition to your password when logging in.</p>
                </div>

                <div class="alert alert-info">
                    <p class="mb-2"><i class="icon fas fa-info-circle"></i><strong>How to Configure 2FA:</strong> After enabling Two-Factor Authentication, you must <strong>log off and log back in</strong> to configure your preferred 2FA method.</p>
                    <p class="mb-0"><strong>Available methods:</strong></p>
                    <ul class="mb-0 mt-1">
                        <li><strong>TOTP</strong> - Time-based One-Time Password using an authenticator app (Google Authenticator, Microsoft Authenticator, Authy, etc.)</li>
                        <li><strong>Duo Push</strong> - Push notifications via the Duo Mobile app (if Duo Security is enabled by your administrator)</li>
                        <li><strong>WebAuthn</strong> - Hardware security keys (YubiKey, etc.) or built-in authenticators (Windows Hello, Touch ID)</li>
                    </ul>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Current 2FA Status:</label>
                    <div class="input-group">
                        <cfif mfaEnabled>
                            <span class="form-control text-success fw-bold"><i class="fas fa-check-circle me-1"></i> Enabled</span>
                        <cfelse>
                            <span class="form-control text-danger fw-bold"><i class="fas fa-times-circle me-1"></i> Disabled</span>
                        </cfif>
                    </div>
                </div>

                <cfif mfaEnabled>
                    <form method="post" action="user_settings.cfm" onsubmit="return confirm('Are you sure you want to disable Two-Factor Authentication? This will make your account less secure.');">
                        <input type="hidden" name="action" value="toggle_mfa">
                        <input type="hidden" name="mfa_setting" value="disable">
                        <button type="submit" class="btn btn-outline-danger">
                            <i class="fas fa-shield-alt me-1"></i> Disable 2FA
                        </button>
                    </form>
                <cfelse>
                    <div class="alert alert-success mb-3">
                        <i class="fas fa-lightbulb me-2"></i>
                        <strong>Recommended:</strong> Enable 2FA to protect your account from unauthorized access. After enabling, you will be prompted to set up your authenticator app on your next login.
                    </div>
                    <form method="post" action="user_settings.cfm">
                        <input type="hidden" name="action" value="toggle_mfa">
                        <input type="hidden" name="mfa_setting" value="enable">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-shield-alt me-1"></i> Enable 2FA
                        </button>
                    </form>
                </cfif>
            </div>
        </div>

        <!--- RECOVERY EMAIL SECTION (MAILBOX USERS ONLY) --->
        <cfif session.theGroups CONTAINS "mailboxes">

        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-envelope me-2"></i>Recovery Email</h3>
            </div>
            <div class="card-body">
                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Set a secondary email address for password recovery. If you forget your password, a reset link will be sent to this email address. <strong>This must be an external email address</strong> (e.g., Gmail, Yahoo, Outlook) that you can access independently of this system. Email addresses from domains handled by this system are not allowed.</p>
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
            </div>
        </div>

        <!--- TIMEZONE CARD --->
        <div class="card col-sm-8 mt-3">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-globe me-2"></i>Timezone</h3>
            </div>
            <div class="card-body">
                <cfif session.tzMessage NEQ "">
                    <cfoutput>
                    <div class="alert alert-#session.tzMessageType# alert-dismissible">
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        #session.tzMessage#
                    </div>
                    </cfoutput>
                    <cfset session.tzMessage = "">
                    <cfset session.tzMessageType = "">
                </cfif>

                <p>Your timezone is used for vacation auto-reply scheduling, dashboard timestamps, and notification times. Choose the timezone that matches where you live or work.</p>

                <form method="post" action="user_settings.cfm" id="timezoneForm">
                    <input type="hidden" name="action" value="save_timezone">
                    <div class="mb-3">
                        <label for="timezone" class="form-label"><strong>Timezone</strong></label>
                        <select name="timezone" id="timezone" class="form-control" style="width:100%;">
                            <cfoutput>
                            <cfloop array="#tzList#" index="z">
                                <option value="#z#"<cfif z EQ currentTimezone> selected</cfif>>#z#</option>
                            </cfloop>
                            </cfoutput>
                        </select>
                        <div class="form-text">Currently set to: <strong><cfoutput>#currentTimezone#</cfoutput></strong></div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Save Timezone
                    </button>
                </form>

                <cfif vacationHasTimes>
                <cfoutput>
                <script>
                    // Saved vacation has start/end times. Warn the user that
                    // changing TZ keeps the wall-clock values the same, which
                    // shifts the absolute moment they fire.
                    var vacationStart = "#JSStringFormat(vacationStartDisplay)#";
                    var vacationEnd = "#JSStringFormat(vacationEndDisplay)#";
                    var currentTz = "#JSStringFormat(currentTimezone)#";

                    document.getElementById('timezoneForm').addEventListener('submit', function(e) {
                        var newTz = document.getElementById('timezone').value;
                        if (newTz === currentTz) return; // No change, skip

                        var msg = 'You have a vacation auto-reply enabled with the following times:\n\n';
                        if (vacationStart) msg += '  Start: ' + vacationStart + '\n';
                        if (vacationEnd)   msg += '  End:   ' + vacationEnd + '\n';
                        msg += '\nThese values are interpreted as wall-clock times in your selected timezone. ';
                        msg += 'If you change your timezone from "' + currentTz + '" to "' + newTz + '", the same wall-clock numbers will now be evaluated in the new timezone, ';
                        msg += 'which means the auto-reply may fire at a different absolute moment than you originally intended.\n\n';
                        msg += 'Continue with the timezone change?';

                        if (!confirm(msg)) {
                            e.preventDefault();
                            e.stopImmediatePropagation();
                            // Hide the global preloader if it kicked in
                            var preloader = document.querySelector('.preloader');
                            if (preloader) {
                                preloader.style.display = 'none';
                                preloader.style.opacity = '0';
                            }
                            return false;
                        }
                    });
                </script>
                </cfoutput>
                </cfif>
            </div>
        </div>

        <script>
        $(document).ready(function() {
            new TomSelect('#timezone', {
                create: false,
                sortField: { field: 'text', direction: 'asc' },
                maxOptions: 1000
            });
        });
        </script>

        </cfif>

      </div>
    </div>
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
<!-- ./wrapper -->

</body>
</html>
