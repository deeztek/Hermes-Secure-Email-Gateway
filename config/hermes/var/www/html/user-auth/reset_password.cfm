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

    <!--- Client-side form validation --->
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

                    // The breached-password check runs on the server.
                    if (submitBtn) {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Checking...';
                    }
                    return true;
                });
            }
        });
    </script>
</head>

<!--- INITIALIZE VARIABLES --->
<cfparam name="session.reason" default="0">
<cfparam name="url.token" default="">
<cfparam name="form.ft" default="">
<cfset authSvc = createObject("component", "hermesauth.AuthService").init()>

<!--- 1. LINK OPENED FROM THE EMAIL: move the reset token into the session
     and reload without it, so it leaves the address bar, browser history,
     Referer headers and access logs. Only a well-formed token is kept. --->
<cfif url.token NEQ "">
    <cfset StructDelete(session, "pwResetDoneAt")>
    <cfif REFind("^[a-f0-9]{64}$", url.token) GT 0>
        <!--- SECURITY: new session id before the token is parked in it, so a
             session id planted in the browser beforehand is worthless --->
        <cfset sessionRotate()>
        <cfset session.pwResetToken = url.token>
    <cfelse>
        <cfset StructDelete(session, "pwResetToken")>
    </cfif>
    <cflocation url="reset_password.cfm" addtoken="no">
</cfif>

<cfset heldToken = "">
<cfif StructKeyExists(session, "pwResetToken") AND REFind("^[a-f0-9]{64}$", session.pwResetToken) GT 0>
    <cfset heldToken = session.pwResetToken>
</cfif>

<cfset reason = session.reason>
<cfset tokenValid = false>
<cfset tokenError = "">
<cfset resetDone = false>
<cfset resetRequest = "">

<!--- 2. PROCESS THE FORM --->
<cfif StructKeyExists(form, "action") AND form.action EQ "reset_password">

    <!--- One-time form token: deleted on every submission, valid or not --->
    <cfif NOT authSvc.consumeFormToken("reset_password", form.ft)>
        <cfset session.reason = 20>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <cfif heldToken EQ "">
        <cfset session.reason = 15>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "new_password") OR form.new_password EQ "">
        <cfset session.reason = 11>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "confirm_password") OR form.confirm_password EQ "">
        <cfset session.reason = 12>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <cfif form.new_password NEQ form.confirm_password>
        <cfset session.reason = 13>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <cfif Len(form.new_password) LT 8>
        <cfset session.reason = 14>
        <cflocation url="reset_password.cfm" addtoken="no">
    </cfif>

    <!--- HIBP CHECK (k-anonymity: only the first 5 hash characters leave the server) --->
    <cftry>
        <cfset theHash = hash(form.new_password, "SHA", "UTF-8")>
        <cfset leftHash = left(theHash, 5)>
        <cfset rightHash = right(theHash, 35)>

        <cfhttp result="hibpResult" method="GET" charset="utf-8" throwonerror="false"
                url="https://api.pwnedpasswords.com/range/#leftHash#" timeout="10" />

        <cfif hibpResult.status_code EQ "200">
            <cfif hibpResult.filecontent CONTAINS rightHash>
                <cfset session.reason = 18>
                <cflocation url="reset_password.cfm" addtoken="no">
            </cfif>
        </cfif>
        <!--- If HIBP is unreachable, continue anyway --->
    <cfcatch type="any">
        <!--- HIBP check failed, continue anyway --->
    </cfcatch>
    </cftry>

    <!--- SECURITY (GHSA-rgx7-j3qv-h2gm): the service checks the token,
         claims it so it can only be used once, takes the account from LDAP
         (never from the stored row), refuses administrators, sets the
         password and sends the "password changed" notice. --->
    <cfset resetResult = authSvc.resetPasswordWithToken(heldToken, form.new_password)>

    <cfif resetResult.success>
        <cfset StructDelete(session, "pwResetToken")>
        <cfset session.pwResetDoneAt = Now()>
        <cfset session.reason = 16>
    <cfelseif resetResult.error EQ "password">
        <cfset session.reason = 14>
    <cfelseif resetResult.error EQ "ldap">
        <cfset session.reason = 17>
    <cfelse>
        <cfset StructDelete(session, "pwResetToken")>
        <cfset session.reason = 15>
    </cfif>
    <cflocation url="reset_password.cfm" addtoken="no">

</cfif>

<!--- 3. DECIDE WHAT TO SHOW: result screen, error screen, or the form --->
<!--- A refresh within 15 minutes of a successful reset shows the result
     screen again rather than "no reset token" --->
<cfset recentlyDone = StructKeyExists(session, "pwResetDoneAt") AND IsDate(session.pwResetDoneAt)
                      AND DateDiff("n", session.pwResetDoneAt, Now()) LT 15>
<cfif reason EQ 16 OR (heldToken EQ "" AND recentlyDone)>
    <!--- also covers back-and-resubmit after success: the stale form was
         refused, and the accurate thing to show is the earlier result --->
    <cfset resetDone = true>
    <cfset reason = 0>
    <cfset session.reason = 0>
<cfelseif reason EQ 15>
    <cfset tokenError = "gone">
    <cfset session.reason = 0>
<cfelseif heldToken EQ "">
    <cfset tokenError = "missing">
<cfelse>
    <cfset resetRequest = authSvc.checkResetToken(heldToken)>
    <cfif resetRequest.valid>
        <cfset tokenValid = true>
    <cfelse>
        <cfset tokenError = resetRequest.error>
        <cfset StructDelete(session, "pwResetToken")>
    </cfif>
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

    <cfif reason EQ 20>
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-exclamation-triangle"></i> Please Try Again</h4>
            This form expired or was already submitted. Your password was not changed.
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

    <!--- RESULT SCREEN: password changed. No form, so nothing to resubmit --->
    <cfif resetDone>
        <div class="card card-outline card-success">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body text-center">
                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                <h4>Password Changed</h4>
                <p>Your password has been reset. Use your new password the next time you sign in, and update it in any mail apps on your devices.</p>
                <p class="text-muted small">A confirmation has been sent to your email address.</p>
                <p class="mb-0"><strong>You can close this window.</strong></p>
            </div>
        </div>
    </cfif>

    <cfif tokenError EQ "gone">
        <div class="card card-outline card-warning">
            <div class="card-header text-center">
                <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
                <h2><b>Hermes</b>&nbsp;SEG</h2>
            </div>
            <div class="card-body">
                <p class="login-box-msg text-warning">
                    <i class="fas fa-exclamation-circle"></i> Link No Longer Valid
                </p>
                <p class="text-center">This password reset link has expired or has already been used. Your password was not changed.</p>
                <div class="text-center mt-3">
                    <a href="forgot_password.cfm" class="btn btn-primary">Request New Reset Link</a>
                </div>
            </div>
        </div>
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
                    <cfoutput>Account: #EncodeForHTML(resetRequest.email)#</cfoutput>
                </p>

                <form action="reset_password.cfm" method="post">
                    <input type="hidden" name="action" value="reset_password">
                    <cfoutput>
                    <input type="hidden" name="ft" value="#authSvc.issueFormToken('reset_password')#">
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
