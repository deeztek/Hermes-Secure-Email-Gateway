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
  <title>Hermes SEG | Verify Email</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<!--- PROCESS VERIFICATION TOKEN --->
<cfparam name="url.token" default="">

<cfset verificationResult = "">
<cfset verificationSuccess = false>

<cfif url.token NEQ "">
    <!--- Look up the token --->
    <cfquery name="findToken" datasource="hermes">
        SELECT email, secondary_email, secondary_email_token_expires
        FROM user_settings
        WHERE secondary_email_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.token#">
        AND secondary_email_verified = 0
    </cfquery>

    <cfif findToken.recordcount EQ 0>
        <cfset verificationResult = "invalid">
    <cfelseif findToken.secondary_email_token_expires LT Now()>
        <cfset verificationResult = "expired">
    <cfelse>
        <!--- Valid token - mark as verified --->
        <cfquery datasource="hermes">
            UPDATE user_settings
            SET secondary_email_verified = 1,
                secondary_email_token = NULL,
                secondary_email_token_expires = NULL
            WHERE secondary_email_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.token#">
        </cfquery>

        <cfset verificationResult = "success">
        <cfset verificationSuccess = true>

        <!--- Update session if this is the current user --->
        <cfif StructKeyExists(session, "email") AND session.email EQ findToken.email>
            <cfset session.secondary_email_verified = 1>
        </cfif>
    </cfif>
<cfelse>
    <cfset verificationResult = "missing">
</cfif>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="app-content-header">
      <div class="container-fluid">
        <div class="row">
          <div class="col-sm-6">
            <h3 class="mb-0">Email Verification</h3>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Verify Email</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

        <div class="row justify-content-center">
          <div class="col-lg-6">
            <div class="card">
              <div class="card-body text-center py-5">

                <cfif verificationResult EQ "success">
                    <div class="mb-4">
                        <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i>
                    </div>
                    <h3 class="text-success">Email Verified!</h3>
                    <p class="text-muted mb-4">
                        Your recovery email address has been verified successfully.
                        You can now use it to reset your password if needed.
                    </p>
                    <a href="user_settings.cfm" class="btn btn-primary">
                        <i class="fas fa-cog me-1"></i> Go to Account Settings
                    </a>

                <cfelseif verificationResult EQ "expired">
                    <div class="mb-4">
                        <i class="fas fa-clock text-warning" style="font-size: 5rem;"></i>
                    </div>
                    <h3 class="text-warning">Link Expired</h3>
                    <p class="text-muted mb-4">
                        This verification link has expired. Verification links are valid for 24 hours.
                        Please request a new verification email from your account settings.
                    </p>
                    <a href="user_settings.cfm" class="btn btn-warning">
                        <i class="fas fa-redo me-1"></i> Go to Account Settings
                    </a>

                <cfelseif verificationResult EQ "invalid">
                    <div class="mb-4">
                        <i class="fas fa-times-circle text-danger" style="font-size: 5rem;"></i>
                    </div>
                    <h3 class="text-danger">Invalid Link</h3>
                    <p class="text-muted mb-4">
                        This verification link is invalid or has already been used.
                        Please check your account settings to see if your email is already verified.
                    </p>
                    <a href="user_settings.cfm" class="btn btn-danger">
                        <i class="fas fa-cog me-1"></i> Go to Account Settings
                    </a>

                <cfelse>
                    <div class="mb-4">
                        <i class="fas fa-question-circle text-muted" style="font-size: 5rem;"></i>
                    </div>
                    <h3 class="text-muted">No Token Provided</h3>
                    <p class="text-muted mb-4">
                        No verification token was provided. Please use the link from your verification email.
                    </p>
                    <a href="user_settings.cfm" class="btn btn-secondary">
                        <i class="fas fa-cog me-1"></i> Go to Account Settings
                    </a>
                </cfif>

              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<cfinclude template="./inc/html_foot.cfm" />

</body>
</html>
