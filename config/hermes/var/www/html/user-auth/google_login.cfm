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
  <title>Hermes SEG | Organization Login</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<cfset googleSettings = {
    enabled: "0",
    client_id: "",
    client_secret: "",
    allowed_domains: "",
    email_claim: "email",
    name_claim: "name",
    policy: "",
    reports: "YES",
    train_bayes: "0",
    download_msg: "0",
    enforce_mfa: "0",
    pdf_enabled: "2",
    smime_enabled: "2",
    ca: "",
    validity: "1825",
    cert_encryption: "2048",
    cert_algorithm: "sha256",
    sign: "2",
    pgp_enabled: "2",
    pgp_encryption: "2048"
}>

<cfquery name="getGoogleProvisioningSettings" datasource="hermes">
    SELECT parameter, value2
    FROM parameters2
    WHERE module = 'google_provisioning'
</cfquery>

<cfloop query="getGoogleProvisioningSettings">
    <cfset googleSettings[parameter] = value2>
</cfloop>

<cfquery name="getConsoleHost" datasource="hermes">
    SELECT value2
    FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>

<cfquery name="getDefaultPolicy" datasource="hermes">
    SELECT policy_id
    FROM spam_policies
    WHERE default_policy = '1'
    LIMIT 1
</cfquery>

<cfquery name="getDefaultCa" datasource="hermes">
    SELECT id
    FROM ca_settings
    WHERE default2 = '1'
    LIMIT 1
</cfquery>

<cfif googleSettings.policy EQ "" AND getDefaultPolicy.recordcount GTE 1>
    <cfset googleSettings.policy = getDefaultPolicy.policy_id>
</cfif>
<cfif googleSettings.ca EQ "" AND getDefaultCa.recordcount GTE 1>
    <cfset googleSettings.ca = getDefaultCa.id>
</cfif>

<cfset googleClientSecret = "">
<cfif Len(Trim(googleSettings.client_secret)) GT 0>
    <cftry>
        <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="googleProvisionKey" charset="utf-8">
        <cfset googleClientSecret = Decrypt(googleSettings.client_secret, Trim(googleProvisionKey), "AES", "Base64")>
        <cfcatch type="any">
            <cfset googleClientSecret = "">
        </cfcatch>
    </cftry>
</cfif>

<cfscript>
function normalizeGoogleDomains(rawValue) {
    var normalized = Replace(arguments.rawValue, Chr(13), Chr(10), "all");
    normalized = Replace(normalized, ",", Chr(10), "all");
    normalized = Replace(normalized, ";", Chr(10), "all");
    normalized = Replace(normalized, " ", Chr(10), "all");
    var domains = [];
    for (var line in ListToArray(normalized, Chr(10), false)) {
        var item = LCase(Trim(line));
        if (Left(item, 1) == "@") {
            item = Mid(item, 2, Len(item) - 1);
        }
        if (Len(item) && ArrayFindNoCase(domains, item) EQ 0) {
            ArrayAppend(domains, item);
        }
    }
    return domains;
}
</cfscript>

<cfset allowedDomains = normalizeGoogleDomains(googleSettings.allowed_domains)>
<cfset callbackUrl = "https://#getConsoleHost.value2#/user-auth/google_login.cfm">
<cfset flowStatus = "error">
<cfset flowTitle = "Organization Login Unavailable">
<cfset flowMessage = "Please contact your system administrator.">
<cfset flowEmail = "">

<cfif googleSettings.enabled EQ "1" AND Len(Trim(googleSettings.client_id)) GT 0 AND Len(Trim(googleClientSecret)) GT 0 AND ArrayLen(allowedDomains) GT 0 AND StructKeyExists(url, "code") AND StructKeyExists(url, "state")>
    <cfif NOT StructKeyExists(session, "googleProvisionState") OR session.googleProvisionState NEQ url.state>
        <cfset flowTitle = "Organization Login Failed">
        <cfset flowMessage = "We could not validate your sign-in request. Please contact your system administrator.">
    <cfelse>
        <cfset StructDelete(session, "googleProvisionState")>
        <cftry>
            <cfhttp url="https://oauth2.googleapis.com/token" method="POST" result="googleTokenResult">
                <cfhttpparam type="formfield" name="code" value="#url.code#">
                <cfhttpparam type="formfield" name="client_id" value="#googleSettings.client_id#">
                <cfhttpparam type="formfield" name="client_secret" value="#googleClientSecret#">
                <cfhttpparam type="formfield" name="redirect_uri" value="#callbackUrl#">
                <cfhttpparam type="formfield" name="grant_type" value="authorization_code">
            </cfhttp>

            <cfset googleToken = DeserializeJSON(googleTokenResult.fileContent)>

            <cfif NOT StructKeyExists(googleToken, "access_token") OR Trim(googleToken.access_token) EQ "">
                <cfset flowTitle = "Organization Login Failed">
                <cfset flowMessage = "We could not verify your organization account. Please contact your system administrator.">
            <cfelse>
                <cfhttp url="https://openidconnect.googleapis.com/v1/userinfo" method="GET" result="googleUserInfoResult">
                    <cfhttpparam type="header" name="Authorization" value="#'Bearer ' & googleToken.access_token#">
                </cfhttp>

                <cfset googleUserInfo = DeserializeJSON(googleUserInfoResult.fileContent)>
                <cfset mappedEmailClaim = LCase(Trim(googleSettings.email_claim))>
                <cfset mappedNameClaim = LCase(Trim(googleSettings.name_claim))>
                <cfset flowEmail = "">
                <cfset flowName = "">
                <cfset googleEmailVerified = false>

                <cfif StructKeyExists(googleUserInfo, mappedEmailClaim)>
                    <cfset flowEmail = LCase(Trim(googleUserInfo[mappedEmailClaim]))>
                <cfelseif StructKeyExists(googleUserInfo, "email")>
                    <cfset flowEmail = LCase(Trim(googleUserInfo.email))>
                </cfif>

                <cfif StructKeyExists(googleUserInfo, mappedNameClaim)>
                    <cfset flowName = Trim(googleUserInfo[mappedNameClaim])>
                <cfelseif StructKeyExists(googleUserInfo, "name")>
                    <cfset flowName = Trim(googleUserInfo.name)>
                </cfif>

                <cfif StructKeyExists(googleUserInfo, "email_verified")>
                    <cfset googleEmailVerified = (CompareNoCase(ToString(googleUserInfo.email_verified), "true") EQ 0 OR ToString(googleUserInfo.email_verified) EQ "1")>
                </cfif>

                <cfif flowEmail EQ "" OR NOT IsValid("email", flowEmail) OR NOT googleEmailVerified>
                    <cfset flowTitle = "Organization Login Failed">
                    <cfset flowMessage = "We could not validate your organization email address. Please contact your system administrator.">
                <cfelse>
                    <cfset flowDomain = LCase(ListGetAt(flowEmail, 2, "@"))>
                    <cfif ArrayFindNoCase(allowedDomains, flowDomain) EQ 0>
                        <cfset flowTitle = "Organization Login Failed">
                        <cfset flowMessage = "Your organization account is not allowed for this portal. Please contact your system administrator.">
                    <cfelse>
                        <cfset googleProvisionRecipientEmail = flowEmail>
                        <cfset googleProvisionRecipientName = flowName>
                        <cfset googleProvisionPolicy = googleSettings.policy>
                        <cfset googleProvisionReports = googleSettings.reports>
                        <cfset googleProvisionTrainBayes = googleSettings.train_bayes>
                        <cfset googleProvisionDownloadMsg = googleSettings.download_msg>
                        <cfset googleProvisionEnforceMfa = googleSettings.enforce_mfa>
                        <cfset googleProvisionPdfEnabled = googleSettings.pdf_enabled>
                        <cfset googleProvisionSmimeEnabled = googleSettings.smime_enabled>
                        <cfset googleProvisionCa = googleSettings.ca>
                        <cfset googleProvisionValidity = googleSettings.validity>
                        <cfset googleProvisionCertEncryption = googleSettings.cert_encryption>
                        <cfset googleProvisionCertAlgorithm = googleSettings.cert_algorithm>
                        <cfset googleProvisionSign = googleSettings.sign>
                        <cfset googleProvisionPgpEnabled = googleSettings.pgp_enabled>
                        <cfset googleProvisionPgpEncryption = googleSettings.pgp_encryption>
                        <cfinclude template="./inc/google_auto_provision_relay_recipient.cfm">

                        <cfif googleProvisionStatus EQ "created">
                            <cfset flowStatus = "success">
                            <cfset flowTitle = "Organization Account Verified">
                            <cfset flowMessage = "A new Hermes SEG account has been created for #HTMLEditFormat(flowEmail)#. Please check your email for the welcome message, then use Reset password? to finish setup.">
                        <cfelseif googleProvisionStatus EQ "exists">
                            <cfset flowStatus = "success">
                            <cfset flowTitle = "Account Already Available">
                            <cfset flowMessage = "A Hermes SEG account already exists for #HTMLEditFormat(flowEmail)#. Open the User Console and use Reset password? if you need to set or change your password.">
                        <cfelse>
                            <cfset flowTitle = "Organization Login Failed">
                            <cfset flowMessage = googleProvisionMessage>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
            <cfcatch type="any">
                <cfset flowTitle = "Organization Login Failed">
                <cfset flowMessage = "We could not complete organization sign-in. Please contact your system administrator.">
            </cfcatch>
        </cftry>
    </cfif>
<cfelseif googleSettings.enabled EQ "1" AND Len(Trim(googleSettings.client_id)) GT 0 AND Len(Trim(googleClientSecret)) GT 0 AND ArrayLen(allowedDomains) GT 0>
    <cfset session.googleProvisionState = Hash(CreateUUID() & Now() & RandRange(1000,9999))>
    <cfset googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth?client_id=#URLEncodedFormat(googleSettings.client_id)#&redirect_uri=#URLEncodedFormat(callbackUrl)#&response_type=code&scope=#URLEncodedFormat('openid email profile')#&access_type=online&prompt=select_account&state=#URLEncodedFormat(session.googleProvisionState)#">
    <cfif ArrayLen(allowedDomains) EQ 1>
        <cfset googleAuthUrl = googleAuthUrl & "&hd=" & URLEncodedFormat(allowedDomains[1])>
    </cfif>
    <cflocation url="#googleAuthUrl#" addtoken="no">
<cfelse>
    <cfset flowTitle = "Organization Login Unavailable">
    <cfset flowMessage = "Organization sign-in is not configured. Please contact your system administrator.">
</cfif>

<body class="hold-transition login-page">
<div class="login-box">
    <div class="card card-outline card-primary">
        <div class="card-header text-center">
            <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="img-fluid mb-2" style="max-height: 80px;">
            <h2><b>Hermes</b>&nbsp;SEG</h2>
        </div>
        <div class="card-body">
            <h4 class="text-center"><cfoutput>#flowTitle#</cfoutput></h4>

            <cfif flowStatus EQ "success">
                <div class="alert alert-success">
                    <i class="icon fa fa-check"></i>
                    <cfoutput>#flowMessage#</cfoutput>
                </div>
            <cfelse>
                <div class="alert alert-warning">
                    <i class="icon fas fa-exclamation-triangle"></i>
                    <cfoutput>#flowMessage#</cfoutput>
                </div>
            </cfif>

            <div class="d-grid gap-2">
                <a href="/users/" class="btn btn-primary btn-block">Open User Console</a>
                <a href="/user-auth/forgot_password.cfm" class="btn btn-default btn-block">Reset password?</a>
                <a href="/" class="btn btn-default btn-block">Back to Home</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
