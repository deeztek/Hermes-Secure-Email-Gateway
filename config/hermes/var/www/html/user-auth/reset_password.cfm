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

<!---
RESET PASSWORD PAGE
This page validates the reset token and allows the user to set a new password.

URL Parameters:
- token: The password reset token (64 characters)
--->

<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hermes SEG | Reset Password</title>
    <cfinclude template="./inc/html_head.cfm" />

    <!--- HIBP Password Check Script --->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    var password = document.querySelector('input[name="new_password"]').value;
                    var confirmPassword = document.querySelector('input[name="confirm_password"]').value;
                    var submitBtn = form.querySelector('button[type="submit"]');
                    var hibpResult = document.getElementById('hibp_result');

                    // Clear previous results
                    if (hibpResult) {
                        hibpResult.style.display = 'none';
                        hibpResult.className = 'alert mt-3';
                        hibpResult.innerHTML = '';
                    }

                    // Basic validation
                    if (password !== confirmPassword) {
                        e.preventDefault();
                        if (hibpResult) {
                            hibpResult.className = 'alert alert-danger mt-3';
                            hibpResult.innerHTML = '<i class="fas fa-exclamation-circle"></i> Passwords do not match.';
                            hibpResult.style.display = 'block';
                        }
                        return false;
                    }

                    if (password.length < 8) {
                        e.preventDefault();
                        if (hibpResult) {
                            hibpResult.className = 'alert alert-danger mt-3';
                            hibpResult.innerHTML = '<i class="fas fa-exclamation-circle"></i> Password must be at least 8 characters.';
                            hibpResult.style.display = 'block';
                        }
                        return false;
                    }

                    // Check HIBP
                    e.preventDefault();
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Checking...';

                    // Use fetch to check HIBP via our API endpoint
                    fetch('/admin/2/inc/check_hibp.cfm?type=api&password=' + encodeURIComponent(password))
                        .then(function(response) { return response.text(); })
                        .then(function(result) {
                            result = result.trim();
                            if (result === 'Hash Found') {
                                if (hibpResult) {
                                    hibpResult.className = 'alert alert-danger mt-3';
                                    hibpResult.innerHTML = '<i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> This password has appeared in a data breach. Please choose a different password.';
                                    hibpResult.style.display = 'block';
                                }
                                submitBtn.disabled = false;
                                submitBtn.innerHTML = 'Reset Password';
                            } else if (result === 'Hash Not Found') {
                                // Password is safe, submit the form
                                form.removeEventListener('submit', arguments.callee);
                                form.submit();
                            } else {
                                // HIBP unreachable - allow submission anyway
                                form.removeEventListener('submit', arguments.callee);
                                form.submit();
                            }
                        })
                        .catch(function() {
                            // Error - allow submission anyway
                            form.removeEventListener('submit', arguments.callee);
                            form.submit();
                        });

                    return false;
                });
            }
        });
    </script>
</head>

<!--- INITIALIZE VARIABLES --->
<cfparam name="session.reason" default="0">
<cfparam name="url.token" default="">
<cfset reason = session.reason>
<cfset tokenValid = false>
<cfset tokenError = "">
<cfset resetRequest = "">

<!--- PROCESS PASSWORD CHANGE IF FORM SUBMITTED --->
<cfif StructKeyExists(form, "action") AND form.action EQ "reset_password">

    <!--- Validate form fields --->
    <cfif NOT StructKeyExists(form, "token") OR form.token EQ "">
        <cfset session.reason = 10>
        <cflocation url="reset_password.cfm?token=#url.token#" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "new_password") OR form.new_password EQ "">
        <cfset session.reason = 11>
        <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "confirm_password") OR form.confirm_password EQ "">
        <cfset session.reason = 12>
        <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
    </cfif>

    <!--- Check passwords match --->
    <cfif form.new_password NEQ form.confirm_password>
        <cfset session.reason = 13>
        <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
    </cfif>

    <!--- Validate password length --->
    <cfif Len(form.new_password) LT 8>
        <cfset session.reason = 14>
        <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
    </cfif>

    <!--- HIBP CHECK (server-side defense in depth) --->
    <cftry>
        <cfset theHash = hash(form.new_password, "SHA", "UTF-8")>
        <cfset leftHash = left(theHash, 5)>
        <cfset rightHash = right(theHash, 35)>

        <cfhttp result="hibpResult" method="GET" charset="utf-8" throwonerror="false"
                url="https://api.pwnedpasswords.com/range/#leftHash#" timeout="10" />

        <cfif hibpResult.status_code EQ "200">
            <cfif hibpResult.filecontent CONTAINS rightHash>
                <cfset session.reason = 18>
                <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
            </cfif>
        </cfif>
        <!--- If HIBP is unreachable, continue anyway - JavaScript should have warned the user --->
    <cfcatch type="any">
        <!--- HIBP check failed, continue anyway --->
    </cfcatch>
    </cftry>

    <!--- Validate token again before processing --->
    <cfquery name="validateToken" datasource="hermes">
        SELECT id, email, ldap_username, user_type, status, expires_at
        FROM password_reset_requests
        WHERE token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.token#">
        AND status = 'pending'
        AND expires_at > NOW()
        LIMIT 1
    </cfquery>

    <cfif validateToken.recordcount EQ 0>
        <cfset session.reason = 15>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <!--- SECURITY: Reject admin password reset tokens --->
    <cfif validateToken.user_type EQ "admin">
        <cfset session.reason = 10>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <!--- UPDATE PASSWORD IN LDAP --->
    <cfset ldapUsername = validateToken.ldap_username>
    <cfset newPassword = form.new_password>

    <!--- All users are in ou=users - role is determined by group membership --->
    <cfset ldapOU = "users">

    <cfinclude template="inc/ldap_modify_user_password.cfm">

    <!--- Check if LDAP update was successful --->
    <cfif IsDefined("ldapPasswordModified") AND ldapPasswordModified>

        <!--- Sync NC local password for DAV auth --->
        <cfquery name="checkNcEnabledReset" datasource="hermes">
            SELECT nextcloud_enabled FROM mailboxes
            WHERE username = <cfqueryparam value="#validateToken.email#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif checkNcEnabledReset.recordcount GTE 1 AND Val(checkNcEnabledReset.nextcloud_enabled) EQ 1>
            <cftry>
                <cfinclude template="../admin/2/inc/generate_customtrans.cfm">
                <cfset ncPwdScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_pwd_update.sh">
                <cfscript>
                    fileWrite(ncPwdScript,
                        chr(35) & "!/bin/bash" & chr(10) &
                        'docker exec -e OC_PASS="' & trim(form.new_password) & '" -u www-data hermes_nextcloud php /var/www/html/occ user:resetpassword --password-from-env "' & validateToken.email & '" 2>&1' & chr(10),
                        "utf-8");
                </cfscript>
                <cfexecute name="/bin/chmod" arguments="+x #ncPwdScript#" timeout="10" />
                <cfexecute name="#ncPwdScript#" variable="ncPwdResult" errorVariable="ncPwdError" timeout="30" />
                <cftry><cffile action="delete" file="#ncPwdScript#"><cfcatch type="any"></cfcatch></cftry>
            <cfcatch type="any"><!--- Non-fatal ---></cfcatch>
            </cftry>
        </cfif>

        <!--- Mark request as completed --->
        <cfquery name="markCompleted" datasource="hermes">
            UPDATE password_reset_requests
            SET status = 'completed',
                completed_at = NOW()
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#validateToken.id#">
        </cfquery>

        <!--- Expire any other pending requests for this user --->
        <cfquery name="expireOthers" datasource="hermes">
            UPDATE password_reset_requests
            SET status = 'expired'
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validateToken.email#">
            AND status = 'pending'
            AND id != <cfqueryparam cfsqltype="cf_sql_integer" value="#validateToken.id#">
        </cfquery>

        <!--- Send password changed notification email --->
        <cfquery name="getPostmaster" datasource="hermes">
            SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
        </cfquery>

        <cfmail from="#getPostmaster.value#" to="#validateToken.email#" server="hermes_postfix_dkim" subject="[Hermes SEG] User Console Password Changed" port="10026" type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">User Console Password Changed</h2>

<p>Someone, presumably you, has changed your Hermes SEG User Console Password.</p>

<p>If you did initiate this change, you can safely ignore this message.</p>

<p>If you <strong>did NOT</strong> initiate this change, please contact your Hermes SEG Administrator immediately as this may indicate an account compromise.</p>

<p style="margin-top: 30px; color: ##6c757d; font-size: 12px;">
This is an automated message from Hermes SEG.
</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
        </cfmail>

        <!--- Redirect to success page --->
        <cfset session.reason = 16>
        <cflocation url="forgot_password.cfm" addtoken="no">

    <cfelse>
        <!--- LDAP update failed --->
        <cfset session.reason = 17>
        <cflocation url="reset_password.cfm?token=#form.token#" addtoken="no">
    </cfif>

</cfif>

<!--- VALIDATE TOKEN FROM URL --->
<cfif url.token NEQ "">
    <cfquery name="checkToken" datasource="hermes">
        SELECT id, email, ldap_username, user_type, status, expires_at
        FROM password_reset_requests
        WHERE token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.token#">
        LIMIT 1
    </cfquery>

    <cfif checkToken.recordcount EQ 0>
        <cfset tokenError = "invalid">
    <cfelseif checkToken.status NEQ "pending">
        <cfset tokenError = "used">
    <cfelseif checkToken.expires_at LT Now()>
        <cfset tokenError = "expired">
        <!--- Mark as expired in database --->
        <cfquery name="markExpired" datasource="hermes">
            UPDATE password_reset_requests
            SET status = 'expired'
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkToken.id#">
        </cfquery>
    <cfelse>
        <cfset tokenValid = true>
        <cfset resetRequest = checkToken>
    </cfif>
<cfelse>
    <cfset tokenError = "missing">
</cfif>

<body class="hold-transition login-page">
<div class="login-box">

    <!--- ERROR/SUCCESS MESSAGES --->

    <cfif reason EQ 10>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Invalid request. Please try again.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 11>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Please enter a new password.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 12>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Please confirm your new password.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 13>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Passwords do not match. Please try again.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 14>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Password must be at least 8 characters long.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 15>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            This reset link has expired or already been used. Please request a new one.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 17>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Error</h4>
            Failed to update password. Please try again or contact an administrator.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason EQ 18>
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Compromised Password</h4>
            This password has appeared in a data breach and cannot be used. Please choose a different password.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <!--- TOKEN ERROR MESSAGES --->
    <cfif tokenError EQ "missing">
        <div class="card card-outline card-danger">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg text-danger">
                    <i class="fas fa-exclamation-triangle"></i> Invalid Request
                </p>
                <p class="text-center">No reset token provided. Please use the link from your email.</p>
                <div class="text-center mt-3">
                    <a href="forgot_password.cfm" class="btn btn-primary">Request New Reset Link</a>
                </div>
            </div>
        </div>
    </cfif>

    <cfif tokenError EQ "invalid">
        <div class="card card-outline card-danger">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg text-danger">
                    <i class="fas fa-exclamation-triangle"></i> Invalid Token
                </p>
                <p class="text-center">This password reset link is invalid. It may have been copied incorrectly.</p>
                <div class="text-center mt-3">
                    <a href="forgot_password.cfm" class="btn btn-primary">Request New Reset Link</a>
                </div>
            </div>
        </div>
    </cfif>

    <cfif tokenError EQ "used">
        <div class="card card-outline card-warning">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg text-warning">
                    <i class="fas fa-exclamation-circle"></i> Link Already Used
                </p>
                <p class="text-center">This password reset link has already been used. If you need to reset your password again, please request a new link.</p>
                <div class="text-center mt-3">
                    <a href="forgot_password.cfm" class="btn btn-primary">Request New Reset Link</a>
                </div>
            </div>
        </div>
    </cfif>

    <cfif tokenError EQ "expired">
        <div class="card card-outline card-warning">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg text-warning">
                    <i class="fas fa-clock"></i> Link Expired
                </p>
                <p class="text-center">This password reset link has expired. Reset links are only valid for 15 minutes for security reasons.</p>
                <div class="text-center mt-3">
                    <a href="forgot_password.cfm" class="btn btn-primary">Request New Reset Link</a>
                </div>
            </div>
        </div>
    </cfif>

    <!--- PASSWORD RESET FORM (only shown if token is valid) --->
    <cfif tokenValid>
        <div class="card card-outline card-primary">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg">Reset Your Password</p>
                <p class="text-center text-muted small">
                    <cfoutput>Account: #resetRequest.email#</cfoutput>
                </p>

                <form action="" method="post">
                    <input type="hidden" name="action" value="reset_password">
                    <cfoutput>
                    <input type="hidden" name="token" value="#url.token#">
                    </cfoutput>

                    <div class="input-group mb-3">
                        <input type="password" name="new_password" class="form-control" placeholder="New Password" minlength="8" maxlength="64" required>
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-lock"></span>
                            </div>
                        </div>
                    </div>

                    <div class="input-group mb-3">
                        <input type="password" name="confirm_password" class="form-control" placeholder="Confirm Password" minlength="8" maxlength="64" required>
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-lock"></span>
                            </div>
                        </div>
                    </div>

                    <div id="hibp_result" class="alert mt-3" style="display:none;"></div>

                    <div class="row">
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
                        </div>
                    </div>
                </form>

                <div class="mt-3 text-center">
                    <p class="text-muted small">
                        Password requirements:
                        <ul class="text-left text-muted small">
                            <li>Minimum 8 characters</li>
                            <li>Maximum 64 characters</li>
                        </ul>
                    </p>
                </div>
            </div>
        </div>
    </cfif>

</div>

<!-- jQuery -->
<script src="/plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="/dist/js/adminlte.min.js"></script>
</body>
</html>
