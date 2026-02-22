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
  <title>Hermes SEG | Forgot Password</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<!--- CFML CODE STARTS HERE --->

<cfparam name="reason" default="0">
<cfif StructKeyExists(session, "reason")>
    <cfif session.reason is not "">
        <cfset reason = session.reason>
    </cfif>
</cfif>

<cfparam name="action" default="">

<cfif StructKeyExists(form, "action")>
    <cfif form.action is "requestreset">
        <cfset action = form.action>
    <cfelse>
        <cfset m="Forgot Password: form.action is not requestreset">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfif>

<!--- GET CAPTCHA SETTINGS --->
<cfquery name="getCaptchaSettings" datasource="hermes">
    SELECT parameter, value FROM system_settings
    WHERE parameter IN ('captcha_provider', 'recaptcha_site_key', 'recaptcha_secret_key',
                        'hcaptcha_site_key', 'hcaptcha_secret_key',
                        'turnstile_site_key', 'turnstile_secret_key')
</cfquery>

<cfset captcha_provider = "builtin">
<cfset recaptcha_site_key = "">
<cfset recaptcha_secret_key = "">
<cfset hcaptcha_site_key = "">
<cfset hcaptcha_secret_key = "">
<cfset turnstile_site_key = "">
<cfset turnstile_secret_key = "">

<cfloop query="getCaptchaSettings">
    <cfswitch expression="#parameter#">
        <cfcase value="captcha_provider"><cfset captcha_provider = value></cfcase>
        <cfcase value="recaptcha_site_key"><cfset recaptcha_site_key = value></cfcase>
        <cfcase value="recaptcha_secret_key"><cfset recaptcha_secret_key = value></cfcase>
        <cfcase value="hcaptcha_site_key"><cfset hcaptcha_site_key = value></cfcase>
        <cfcase value="hcaptcha_secret_key"><cfset hcaptcha_secret_key = value></cfcase>
        <cfcase value="turnstile_site_key"><cfset turnstile_site_key = value></cfcase>
        <cfcase value="turnstile_secret_key"><cfset turnstile_secret_key = value></cfcase>
    </cfswitch>
</cfloop>

<!--- PROCESS FORM SUBMISSION --->
<cfif action is "requestreset">

    <!--- HONEYPOT CHECK (bots fill hidden fields) --->
    <!--- Field name intentionally obscure to avoid browser autofill --->
    <cfif StructKeyExists(form, "fax_number_ext") AND form.fax_number_ext NEQ "">
        <!--- Silently reject - don't give bots feedback --->
        <cfset session.reason = 3>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <!--- VALIDATE CAPTCHA BASED ON PROVIDER --->
    <cfset captchaValid = false>

    <cfswitch expression="#captcha_provider#">

        <!--- BUILT-IN MATH CAPTCHA --->
        <cfcase value="builtin">
            <cfif NOT StructKeyExists(form, "captcha_answer") OR form.captcha_answer is "">
                <cfset StructDelete(session, "captchaQuestion")>
                <cfset StructDelete(session, "captchaAnswer")>
                <cfset session.reason = 9>
                <cflocation url="forgot_password.cfm" addtoken="no">
            </cfif>

            <cfif NOT StructKeyExists(session, "captchaAnswer") OR NOT IsNumeric(form.captcha_answer) OR Int(form.captcha_answer) NEQ session.captchaAnswer>
                <cfset StructDelete(session, "captchaQuestion")>
                <cfset StructDelete(session, "captchaAnswer")>
                <cfset session.reason = 9>
                <cflocation url="forgot_password.cfm" addtoken="no">
            </cfif>

            <cfset StructDelete(session, "captchaQuestion")>
            <cfset StructDelete(session, "captchaAnswer")>
            <cfset captchaValid = true>
        </cfcase>

        <!--- GOOGLE RECAPTCHA V2 --->
        <cfcase value="recaptcha">
            <cfif NOT StructKeyExists(form, "g-recaptcha-response") OR form["g-recaptcha-response"] is "">
                <cfset session.reason = 9>
                <cflocation url="forgot_password.cfm" addtoken="no">
            </cfif>

            <!--- Verify with Google --->
            <cftry>
                <cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="POST" result="recaptchaResult">
                    <cfhttpparam type="formfield" name="secret" value="#recaptcha_secret_key#">
                    <cfhttpparam type="formfield" name="response" value="#form['g-recaptcha-response']#">
                </cfhttp>

                <cfset recaptchaResponse = DeserializeJSON(recaptchaResult.fileContent)>
                <cfif NOT recaptchaResponse.success>
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfif>
                <cfset captchaValid = true>

                <cfcatch type="any">
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfcatch>
            </cftry>
        </cfcase>

        <!--- HCAPTCHA --->
        <cfcase value="hcaptcha">
            <cfif NOT StructKeyExists(form, "h-captcha-response") OR form["h-captcha-response"] is "">
                <cfset session.reason = 9>
                <cflocation url="forgot_password.cfm" addtoken="no">
            </cfif>

            <!--- Verify with hCaptcha --->
            <cftry>
                <cfhttp url="https://hcaptcha.com/siteverify" method="POST" result="hcaptchaResult">
                    <cfhttpparam type="formfield" name="secret" value="#hcaptcha_secret_key#">
                    <cfhttpparam type="formfield" name="response" value="#form['h-captcha-response']#">
                </cfhttp>

                <cfset hcaptchaResponse = DeserializeJSON(hcaptchaResult.fileContent)>
                <cfif NOT hcaptchaResponse.success>
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfif>
                <cfset captchaValid = true>

                <cfcatch type="any">
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfcatch>
            </cftry>
        </cfcase>

        <!--- CLOUDFLARE TURNSTILE --->
        <cfcase value="turnstile">
            <cfif NOT StructKeyExists(form, "cf-turnstile-response") OR form["cf-turnstile-response"] is "">
                <cfset session.reason = 9>
                <cflocation url="forgot_password.cfm" addtoken="no">
            </cfif>

            <!--- Verify with Cloudflare --->
            <cftry>
                <cfhttp url="https://challenges.cloudflare.com/turnstile/v0/siteverify" method="POST" result="turnstileResult">
                    <cfhttpparam type="formfield" name="secret" value="#turnstile_secret_key#">
                    <cfhttpparam type="formfield" name="response" value="#form['cf-turnstile-response']#">
                </cfhttp>

                <cfset turnstileResponse = DeserializeJSON(turnstileResult.fileContent)>
                <cfif NOT turnstileResponse.success>
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfif>
                <cfset captchaValid = true>

                <cfcatch type="any">
                    <cfset session.reason = 9>
                    <cflocation url="forgot_password.cfm" addtoken="no">
                </cfcatch>
            </cftry>
        </cfcase>

        <!--- DEFAULT: Treat as builtin if unknown provider --->
        <cfdefaultcase>
            <cfset captchaValid = true>
        </cfdefaultcase>

    </cfswitch>

    <!--- VALIDATE EMAIL --->
    <cfif NOT StructKeyExists(form, "email") OR form.email is "">
        <cfset session.reason = 1>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <cfif NOT IsValid("email", form.email)>
        <cfset session.reason = 2>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <!--- LOOK UP USER IN LDAP --->
    <cfset userEmail = LCase(Trim(form.email))>
    <cfinclude template="./inc/ldap_get_user_groups.cfm">

    <!--- CHECK IF USER WAS FOUND --->
    <cfif NOT ldapUserFound>
        <!--- Don't reveal if user exists or not for security --->
        <cfset session.reason = 3>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

    <!--- DETERMINE USER TYPE AND HANDLE ACCORDINGLY --->
    <cfif isRelay>
        <!--- RELAY USER: Send token via email --->
        <cfset userType = "relay">
        <cfset notificationMethod = "email">
        <cfset tokenRecipient = userEmail>
        <cfinclude template="./inc/process_password_reset_request.cfm">

    <cfelseif isMailbox>
        <!--- MAILBOX USER: Check for verified secondary email --->
        <cfset userType = "mailbox">

        <!--- Get user settings --->
        <cfquery name="getUserSettings" datasource="hermes">
            SELECT secondary_email, secondary_email_verified
            FROM user_settings
            WHERE email = '#userEmail#'
        </cfquery>

        <cfif getUserSettings.recordcount EQ 1 AND getUserSettings.secondary_email NEQ "" AND getUserSettings.secondary_email_verified EQ 1>
            <!--- Send to verified secondary email --->
            <cfset notificationMethod = "email">
            <cfset tokenRecipient = getUserSettings.secondary_email>
            <cfinclude template="./inc/process_password_reset_request.cfm">

        <cfelse>
            <!--- No self-service available, notify admin --->
            <cfset notificationMethod = "admin">
            <cfinclude template="./inc/process_password_reset_request.cfm">
        </cfif>

    <cfelseif isAdmin>
        <!--- ADMIN USER: Self-service password reset disabled for security --->
        <!--- Admins must use another admin or direct LDAP access to reset password --->
        <cfset session.reason = 10>
        <cflocation url="forgot_password.cfm" addtoken="no">

    <cfelse>
        <!--- User exists in LDAP but not in any recognized group --->
        <cfset session.reason = 7>
        <cflocation url="forgot_password.cfm" addtoken="no">
    </cfif>

</cfif>

<!--- CFML CODE ENDS HERE --->

<!--- GENERATE MATH CAPTCHA WITH WORD NUMBERS (only for builtin provider) --->
<cfif captcha_provider EQ "builtin">
    <cfif NOT StructKeyExists(session, "captchaQuestion") OR NOT StructKeyExists(session, "captchaAnswer")>
        <cfset numberWords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]>
        <cfset captchaNum1 = RandRange(1, 10)>
        <cfset captchaNum2 = RandRange(1, 10)>
        <cfset captchaOperation = RandRange(1, 3)>

        <cfswitch expression="#captchaOperation#">
            <cfcase value="1">
                <!--- Addition --->
                <cfset session.captchaAnswer = captchaNum1 + captchaNum2>
                <cfset session.captchaQuestion = "What is #numberWords[captchaNum1]# plus #numberWords[captchaNum2]#?">
            </cfcase>
            <cfcase value="2">
                <!--- Subtraction (ensure positive result) --->
                <cfif captchaNum1 LT captchaNum2>
                    <cfset temp = captchaNum1>
                    <cfset captchaNum1 = captchaNum2>
                    <cfset captchaNum2 = temp>
                </cfif>
                <cfset session.captchaAnswer = captchaNum1 - captchaNum2>
                <cfset session.captchaQuestion = "What is #numberWords[captchaNum1]# minus #numberWords[captchaNum2]#?">
            </cfcase>
            <cfcase value="3">
                <!--- Multiplication (use smaller numbers) --->
                <cfset captchaNum1 = RandRange(1, 5)>
                <cfset captchaNum2 = RandRange(1, 5)>
                <cfset session.captchaAnswer = captchaNum1 * captchaNum2>
                <cfset session.captchaQuestion = "What is #numberWords[captchaNum1]# times #numberWords[captchaNum2]#?">
            </cfcase>
        </cfswitch>
    </cfif>
</cfif>

<body class="hold-transition login-page">
<div class="login-box">

    <!--- ERROR/SUCCESS MESSAGES --->

    <cfif reason is "1">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            Email address cannot be blank.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "2">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            Please enter a valid email address.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "3">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fa fa-check"></i>
            If an account exists with that email address, password reset instructions have been sent. Please check your email. <strong>You may close this window.</strong>
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "4">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fa fa-check"></i>
            Password reset instructions have been sent via Pushover notification. <strong>You may close this window.</strong>
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "5">
        <div class="alert alert-info alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-info-circle"></i>
            Your password reset request has been sent to the system administrator. They will contact you with further instructions. <strong>You may close this window.</strong>
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "6">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            Unable to send password reset. Please contact your system administrator.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "7">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            Account configuration error. Please contact your system administrator.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "8">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            A password reset request was recently submitted. Please wait 15 minutes before trying again.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "9">
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-exclamation-triangle"></i>
            Invalid CAPTCHA. Please try again.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "10">
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fas fa-shield-alt"></i>
            Administrator accounts cannot use self-service password reset. Please contact another administrator or use direct system access.
        </div>
        <cfset session.reason = 0>
    </cfif>

    <cfif reason is "16">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <i class="icon fa fa-check"></i>
            Your password has been reset successfully! <strong>You may close this window.</strong>
        </div>
        <cfset session.reason = 0>
    </cfif>

    <!--- LOGIN BOX --->
    <div class="card card-outline card-primary">
        <div class="card-header text-center">
            <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
            <h2><b>Hermes</b>&nbsp;SEG</h2>
        </div>
        <div class="card-body">

            <h4 class="text-center">Forgot Password</h4>

            <p class="text-center">Enter your email address below and click <strong>Reset Password</strong>. If your account exists, you will receive instructions to reset your password.</p>

            <form action="forgot_password.cfm" method="post">
                <input type="hidden" name="action" value="requestreset">

                <div class="input-group mb-3">
                    <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                    <div class="input-group-append">
                        <div class="input-group-text">
                            <span class="fas fa-envelope"></span>
                        </div>
                    </div>
                </div>

                <!--- CAPTCHA WIDGET (based on configured provider) --->
                <cfswitch expression="#captcha_provider#">

                    <!--- BUILT-IN MATH CAPTCHA --->
                    <cfcase value="builtin">
                        <div class="mb-3">
                            <cfoutput>
                            <label class="form-label text-muted">#session.captchaQuestion#</label>
                            </cfoutput>
                            <div class="input-group">
                                <input type="text" name="captcha_answer" class="form-control" placeholder="Enter your answer" maxlength="3" required autocomplete="off">
                                <div class="input-group-append">
                                    <div class="input-group-text">
                                        <span class="fas fa-shield-alt"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfcase>

                    <!--- GOOGLE RECAPTCHA V2 --->
                    <cfcase value="recaptcha">
                        <div class="mb-3">
                            <cfoutput>
                            <div class="g-recaptcha" data-sitekey="#recaptcha_site_key#"></div>
                            </cfoutput>
                        </div>
                        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
                    </cfcase>

                    <!--- HCAPTCHA --->
                    <cfcase value="hcaptcha">
                        <div class="mb-3">
                            <cfoutput>
                            <div class="h-captcha" data-sitekey="#hcaptcha_site_key#"></div>
                            </cfoutput>
                        </div>
                        <script src="https://js.hcaptcha.com/1/api.js" async defer></script>
                    </cfcase>

                    <!--- CLOUDFLARE TURNSTILE --->
                    <cfcase value="turnstile">
                        <div class="mb-3">
                            <cfoutput>
                            <div class="cf-turnstile" data-sitekey="#turnstile_site_key#"></div>
                            </cfoutput>
                        </div>
                        <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
                    </cfcase>

                </cfswitch>

                <!--- HONEYPOT FIELD (hidden from humans, bots will fill it) --->
                <!--- Field name intentionally obscure to avoid browser autofill --->
                <div style="position: absolute; left: -9999px;" aria-hidden="true">
                    <input type="text" name="fax_number_ext" tabindex="-1" autocomplete="off">
                </div>

                <div class="row">
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
                    </div>
                </div>
            </form>


        </div>
    </div>
</div>

</body>
</html>
