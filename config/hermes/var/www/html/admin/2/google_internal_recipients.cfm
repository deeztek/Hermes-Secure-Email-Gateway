<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
  <title>Hermes SEG | Manage Google Provisioning</title>

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
            <h1 class="m-0">Manage Google Provisioning</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_internal_recipients.cfm">Relay Recipients</a></li>
              <li class="breadcrumb-item active">Manage Google Provisioning</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name = "action" default = "">
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfset googleProvisionSettings = {
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
  <cfset googleProvisionSettings[parameter] = value2>
</cfloop>

<cfquery name="googleConsoleHost" datasource="hermes">
  SELECT value2
  FROM parameters2
  WHERE module = 'console' AND parameter = 'console.host'
</cfquery>

<cfquery name="googleDefaultPolicy" datasource="hermes">
  SELECT policy_id, policy_name
  FROM spam_policies
  WHERE default_policy ='1'
  LIMIT 1
</cfquery>

<cfquery name="googleUserPolicies" datasource="hermes">
  SELECT policy_id, policy_name
  FROM spam_policies
  WHERE custom='1' AND system<>'1' AND policy_id<>'#googleDefaultPolicy.policy_id#'
  ORDER BY policy_name ASC
</cfquery>

<cfquery name="googleDefaultCa" datasource="hermes">
  SELECT id, ca_commonname
  FROM ca_settings
  WHERE default2='1'
  LIMIT 1
</cfquery>

<cfquery name="googleOtherCas" datasource="hermes">
  SELECT id, ca_commonname
  FROM ca_settings
  WHERE id <> '#googleDefaultCa.id#'
  ORDER BY ca_commonname ASC
</cfquery>

<cfif googleProvisionSettings.policy EQ "" AND googleDefaultPolicy.recordcount GTE 1>
  <cfset googleProvisionSettings.policy = googleDefaultPolicy.policy_id>
</cfif>
<cfif googleProvisionSettings.ca EQ "" AND googleDefaultCa.recordcount GTE 1>
  <cfset googleProvisionSettings.ca = googleDefaultCa.id>
</cfif>

<cfset googleClientSecretMasked = "">
<cfif Len(Trim(googleProvisionSettings.client_secret)) GT 0>
  <cfset googleClientSecretMasked = "********">
</cfif>

<cfscript>
  function normalizeGoogleProvisioningDomains(rawValue) {
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

<cfset googleProvisionCallbackUrl = "https://#googleConsoleHost.value2#/user-auth/google_login.cfm">

<cfif action EQ "save_google_provisioning">
  <cfset googleEnabled = (StructKeyExists(form, "google_enabled") AND form.google_enabled EQ "1") ? "1" : "0">
  <cfset googleClientId = Trim(form.google_client_id)>
  <cfset googleClientSecretInput = Trim(form.google_client_secret)>
  <cfset googleEmailClaim = LCase(Trim(form.google_email_claim))>
  <cfset googleNameClaim = LCase(Trim(form.google_name_claim))>
  <cfset googleAllowedDomainsArray = normalizeGoogleProvisioningDomains(form.google_allowed_domains)>
  <cfset googleAllowedDomains = ArrayToList(googleAllowedDomainsArray, Chr(10))>
  <cfset googlePolicy = form.google_policy>
  <cfset googleReports = form.google_reports>
  <cfset googleTrainBayes = form.google_train_bayes>
  <cfset googleDownloadMsg = form.google_download_msg>
  <cfset googleEnforceMfa = form.google_enforce_mfa>
  <cfset googlePdfEnabled = form.google_pdf_enabled>
  <cfset googleSmimeEnabled = form.google_smime_enabled>
  <cfset googleCa = form.google_ca>
  <cfset googleValidity = form.google_validity>
  <cfset googleCertEncryption = form.google_cert_encryption>
  <cfset googleCertAlgorithm = form.google_cert_algorithm>
  <cfset googleSign = form.google_sign>
  <cfset googlePgpEnabled = form.google_pgp_enabled>
  <cfset googlePgpEncryption = form.google_pgp_encryption>

  <cfset googleProvisionError = "">

  <cfif googleEmailClaim EQ ""><cfset googleEmailClaim = "email"></cfif>
  <cfif googleNameClaim EQ ""><cfset googleNameClaim = "name"></cfif>

  <cfif NOT REFind("^[a-z0-9_]+$", googleEmailClaim)>
    <cfset googleProvisionError = "Google email claim must contain only lowercase letters, numbers, or underscores.">
  <cfelseif NOT REFind("^[a-z0-9_]+$", googleNameClaim)>
    <cfset googleProvisionError = "Google name claim must contain only lowercase letters, numbers, or underscores.">
  <cfelseif googleEnabled EQ "1" AND ArrayLen(googleAllowedDomainsArray) EQ 0>
    <cfset googleProvisionError = "Enter at least one allowed login domain.">
  <cfelseif Len(googleAllowedDomains) GT 255>
    <cfset googleProvisionError = "Allowed login domains are too long to save. Remove some domains and try again.">
  <cfelseif NOT ListFindNoCase("YES,NO", googleReports)>
    <cfset googleProvisionError = "Invalid Quarantine Notifications value.">
  <cfelseif NOT ListFindNoCase("0,1", googleTrainBayes)>
    <cfset googleProvisionError = "Invalid Train Bayes value.">
  <cfelseif NOT ListFindNoCase("0,1", googleDownloadMsg)>
    <cfset googleProvisionError = "Invalid Download Messages value.">
  <cfelseif NOT ListFindNoCase("0,1", googleEnforceMfa)>
    <cfset googleProvisionError = "Invalid Two-Factor Authentication value.">
  <cfelseif NOT ListFindNoCase("1,2", googlePdfEnabled)>
    <cfset googleProvisionError = "Invalid PDF Encryption value.">
  <cfelseif NOT ListFindNoCase("1,2", googleSmimeEnabled)>
    <cfset googleProvisionError = "Invalid S/MIME Encryption value.">
  <cfelseif NOT ListFindNoCase("365,730,1095,1460,1825", googleValidity)>
    <cfset googleProvisionError = "Invalid certificate validity period.">
  <cfelseif NOT ListFindNoCase("2048,4096", googleCertEncryption)>
    <cfset googleProvisionError = "Invalid certificate key length.">
  <cfelseif NOT ListFindNoCase("sha256,sha512", googleCertAlgorithm)>
    <cfset googleProvisionError = "Invalid certificate hash algorithm.">
  <cfelseif NOT ListFindNoCase("1,2", googleSign)>
    <cfset googleProvisionError = "Invalid S/MIME signature value.">
  <cfelseif NOT ListFindNoCase("1,2", googlePgpEnabled)>
    <cfset googleProvisionError = "Invalid PGP Encryption value.">
  <cfelseif NOT ListFindNoCase("2048,4096", googlePgpEncryption)>
    <cfset googleProvisionError = "Invalid PGP key size.">
  </cfif>

  <cfloop array="#googleAllowedDomainsArray#" index="googleAllowedDomain">
    <cfif googleProvisionError EQ "" AND NOT IsValid("email", "user@" & googleAllowedDomain)>
      <cfset googleProvisionError = "Invalid allowed login domain: " & googleAllowedDomain>
    </cfif>
  </cfloop>

  <cfif googleProvisionError EQ "">
    <cfquery name="checkGooglePolicy" datasource="hermes">
      SELECT id
      FROM policy
      WHERE id = <cfqueryparam value="#googlePolicy#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkGooglePolicy.recordcount LT 1>
      <cfset googleProvisionError = "The selected SVF policy does not exist.">
    </cfif>
  </cfif>

  <cfif googleProvisionError EQ "" AND googleSmimeEnabled EQ "1">
    <cfquery name="checkGoogleCa" datasource="hermes">
      SELECT id
      FROM ca_settings
      WHERE id = <cfqueryparam value="#googleCa#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkGoogleCa.recordcount LT 1>
      <cfset googleProvisionError = "The selected Certificate Authority does not exist.">
    </cfif>
  </cfif>

  <cfif googleProvisionError EQ "" AND googleEnabled EQ "1">
    <cfif googleClientId EQ "">
      <cfset googleProvisionError = "Google Client ID cannot be blank when organization login is enabled.">
    <cfelseif googleClientSecretInput EQ "" AND googleClientSecretMasked EQ "">
      <cfset googleProvisionError = "Google Client Secret cannot be blank when organization login is enabled.">
    </cfif>
  </cfif>

  <cfif googleProvisionError EQ "">
    <cfset googleClientSecretValue = googleProvisionSettings.client_secret>
    <cfif googleClientSecretInput NEQ googleClientSecretMasked>
      <cfif googleClientSecretInput EQ "">
        <cfset googleClientSecretValue = "">
      <cfelse>
        <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="googleProvisionAuthKey" charset="utf-8">
        <cfset googleClientSecretValue = Encrypt(googleClientSecretInput, Trim(googleProvisionAuthKey), "AES", "Base64")>
      </cfif>
    </cfif>

    <cfset googleSavePairs = [
      {parameter="enabled", value=googleEnabled},
      {parameter="client_id", value=googleClientId},
      {parameter="client_secret", value=googleClientSecretValue},
      {parameter="allowed_domains", value=googleAllowedDomains},
      {parameter="email_claim", value=googleEmailClaim},
      {parameter="name_claim", value=googleNameClaim},
      {parameter="policy", value=googlePolicy},
      {parameter="reports", value=googleReports},
      {parameter="train_bayes", value=googleTrainBayes},
      {parameter="download_msg", value=googleDownloadMsg},
      {parameter="enforce_mfa", value=googleEnforceMfa},
      {parameter="pdf_enabled", value=googlePdfEnabled},
      {parameter="smime_enabled", value=googleSmimeEnabled},
      {parameter="ca", value=googleCa},
      {parameter="validity", value=googleValidity},
      {parameter="cert_encryption", value=googleCertEncryption},
      {parameter="cert_algorithm", value=googleCertAlgorithm},
      {parameter="sign", value=googleSign},
      {parameter="pgp_enabled", value=googlePgpEnabled},
      {parameter="pgp_encryption", value=googlePgpEncryption}
    ]>

    <cfloop array="#googleSavePairs#" index="googleSavePair">
      <cfquery name="checkGoogleParam" datasource="hermes">
        SELECT id
        FROM parameters2
        WHERE module = 'google_provisioning'
        AND parameter = <cfqueryparam value="#googleSavePair.parameter#" cfsqltype="cf_sql_varchar">
        LIMIT 1
      </cfquery>
      <cfif checkGoogleParam.recordcount GTE 1>
        <cfquery datasource="hermes">
          UPDATE parameters2
          SET value2 = <cfqueryparam value="#googleSavePair.value#" cfsqltype="cf_sql_varchar">, applied = '2'
          WHERE id = <cfqueryparam value="#checkGoogleParam.id#" cfsqltype="cf_sql_integer">
        </cfquery>
      <cfelse>
        <cfquery datasource="hermes">
          INSERT INTO parameters2 (module, parameter, value2, applied)
          VALUES (
            'google_provisioning',
            <cfqueryparam value="#googleSavePair.parameter#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#googleSavePair.value#" cfsqltype="cf_sql_varchar">,
            '2'
          )
        </cfquery>
      </cfif>
    </cfloop>

    <cfset session.googleProvisioningMessageType = "success">
    <cfset session.googleProvisioningMessage = "Google provisioning settings saved successfully.">
  <cfelse>
    <cfset session.googleProvisioningMessageType = "danger">
    <cfset session.googleProvisioningMessage = googleProvisionError>
  </cfif>

  <cflocation url="google_internal_recipients.cfm" addtoken="no">
</cfif>

<cfif StructKeyExists(session, "googleProvisioningMessage")>
    <div class="alert alert-<cfoutput>#session.googleProvisioningMessageType#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
        <h5><i class="icon <cfoutput><cfif session.googleProvisioningMessageType EQ 'success'>fa fa-check<cfelse>fa fa-ban</cfif></cfoutput>"></i> <cfoutput><cfif session.googleProvisioningMessageType EQ "success">Success<cfelse>Error</cfif></cfoutput></h5>
        <cfoutput>#HTMLEditFormat(session.googleProvisioningMessage)#</cfoutput>
    </div>
    <cfset StructDelete(session, "googleProvisioningMessage")>
    <cfset StructDelete(session, "googleProvisioningMessageType")>
</cfif>

<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fab fa-google me-2"></i>Google OIDC Provisioning</h3>
    </div>
    <div class="card-body">
        <div class="alert alert-info">
            <h5><i class="icon fas fa-info-circle"></i> Organization account onboarding</h5>
            <p class="mb-2">This creates a public Google sign-in flow for users who do not already have a Hermes SEG relay-recipient account. The Google email claim is used as the recipient address and portal username.</p>
            <p class="mb-2">After a successful Google sign-in, Hermes verifies the email domain, creates the relay recipient with the template below, and sends the existing welcome email so the user can use <strong>Reset password?</strong> to finish setup.</p>
            <p class="mb-0"><strong>Callback URL:</strong> <cfoutput><code>#googleProvisionCallbackUrl#</code></cfoutput></p>
        </div>

        <form method="post" action="">
            <input type="hidden" name="action" value="save_google_provisioning">

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label><strong>Enable Organization Login</strong></label>
                        <select class="form-control" name="google_enabled">
                            <option value="0" <cfif googleProvisionSettings.enabled EQ "0">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.enabled EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Google Client ID</strong></label>
                        <cfoutput><input type="text" class="form-control" name="google_client_id" value="#HTMLEditFormat(googleProvisionSettings.client_id)#"></cfoutput>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Google Client Secret</strong></label>
                        <cfoutput><input type="password" class="form-control" name="google_client_secret" value="#googleClientSecretMasked#" autocomplete="off"></cfoutput>
                        <small class="text-muted">Leave <code>********</code> unchanged to keep the stored secret.</small>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Allowed Login Domain(s)</strong></label>
                        <textarea class="form-control" name="google_allowed_domains" rows="4" placeholder="example.com&#10;example.org"><cfoutput>#HTMLEditFormat(googleProvisionSettings.allowed_domains)#</cfoutput></textarea>
                        <small class="text-muted">Enter one domain per line. Entries such as <code>@example.com</code> are also accepted.</small>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Google Email Claim</strong></label>
                        <cfoutput><input type="text" class="form-control" name="google_email_claim" value="#HTMLEditFormat(googleProvisionSettings.email_claim)#"></cfoutput>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Google Name Claim</strong></label>
                        <cfoutput><input type="text" class="form-control" name="google_name_claim" value="#HTMLEditFormat(googleProvisionSettings.name_claim)#"></cfoutput>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="alert alert-secondary">
                        <h5><i class="icon fas fa-copy"></i> Auto-provisioning template</h5>
                        <p class="mb-0">These defaults match the existing <strong>Add Relay Recipient(s)</strong> options and are applied only when Google creates a new relay recipient.</p>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>SVF Policy to Assign</strong></label>
                        <select class="form-control select2" name="google_policy" style="width: 100%;">
                            <cfoutput><option value="#googleDefaultPolicy.policy_id#" <cfif googleProvisionSettings.policy EQ googleDefaultPolicy.policy_id>selected</cfif>>#googleDefaultPolicy.policy_name#</option></cfoutput>
                            <cfoutput query="googleUserPolicies">
                                <option value="#policy_id#" <cfif googleProvisionSettings.policy EQ policy_id>selected</cfif>>#policy_name#</option>
                            </cfoutput>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Quarantine Notifications</strong></label>
                        <select class="form-control" name="google_reports">
                            <option value="YES" <cfif googleProvisionSettings.reports EQ "YES">selected</cfif>>Enabled</option>
                            <option value="NO" <cfif googleProvisionSettings.reports EQ "NO">selected</cfif>>Disabled</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Train Bayes Filter from User Portal</strong></label>
                        <select class="form-control" name="google_train_bayes">
                            <option value="0" <cfif googleProvisionSettings.train_bayes EQ "0">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.train_bayes EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Download Messages from User Portal</strong></label>
                        <select class="form-control" name="google_download_msg">
                            <option value="0" <cfif googleProvisionSettings.download_msg EQ "0">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.download_msg EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Two-Factor Authentication</strong></label>
                        <select class="form-control" name="google_enforce_mfa">
                            <option value="0" <cfif googleProvisionSettings.enforce_mfa EQ "0">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.enforce_mfa EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>PDF Encryption</strong></label>
                        <select class="form-control" name="google_pdf_enabled">
                            <option value="2" <cfif googleProvisionSettings.pdf_enabled EQ "2">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.pdf_enabled EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>S/MIME Encryption</strong></label>
                        <select class="form-control" name="google_smime_enabled">
                            <option value="2" <cfif googleProvisionSettings.smime_enabled EQ "2">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.smime_enabled EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Certificate Authority</strong></label>
                        <select class="form-control select2" name="google_ca" style="width: 100%;">
                            <cfoutput><option value="#googleDefaultCa.id#" <cfif googleProvisionSettings.ca EQ googleDefaultCa.id>selected</cfif>>#googleDefaultCa.ca_commonname#</option></cfoutput>
                            <cfoutput query="googleOtherCas">
                                <option value="#id#" <cfif googleProvisionSettings.ca EQ id>selected</cfif>>#ca_commonname#</option>
                            </cfoutput>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Certificate Validity Period</strong></label>
                        <select class="form-control" name="google_validity">
                            <option value="1825" <cfif googleProvisionSettings.validity EQ "1825">selected</cfif>>5 Years</option>
                            <option value="1460" <cfif googleProvisionSettings.validity EQ "1460">selected</cfif>>4 Years</option>
                            <option value="1095" <cfif googleProvisionSettings.validity EQ "1095">selected</cfif>>3 Years</option>
                            <option value="730" <cfif googleProvisionSettings.validity EQ "730">selected</cfif>>2 Years</option>
                            <option value="365" <cfif googleProvisionSettings.validity EQ "365">selected</cfif>>1 Year</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Certificate Key Length</strong></label>
                        <select class="form-control" name="google_cert_encryption">
                            <option value="2048" <cfif googleProvisionSettings.cert_encryption EQ "2048">selected</cfif>>2048-bit (Recommended)</option>
                            <option value="4096" <cfif googleProvisionSettings.cert_encryption EQ "4096">selected</cfif>>4096-bit (High Security)</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>Certificate Hash Algorithm</strong></label>
                        <select class="form-control" name="google_cert_algorithm">
                            <option value="sha256" <cfif googleProvisionSettings.cert_algorithm EQ "sha256">selected</cfif>>SHA-256 (Recommended)</option>
                            <option value="sha512" <cfif googleProvisionSettings.cert_algorithm EQ "sha512">selected</cfif>>SHA-512 (High Security)</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>S/MIME SIGNATURE</strong></label>
                        <select class="form-control" name="google_sign">
                            <option value="2" <cfif googleProvisionSettings.sign EQ "2">selected</cfif>>Sign Encrypted Messages Only</option>
                            <option value="1" <cfif googleProvisionSettings.sign EQ "1">selected</cfif>>Sign all messages</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>PGP Encryption</strong></label>
                        <select class="form-control" name="google_pgp_enabled">
                            <option value="2" <cfif googleProvisionSettings.pgp_enabled EQ "2">selected</cfif>>Disable</option>
                            <option value="1" <cfif googleProvisionSettings.pgp_enabled EQ "1">selected</cfif>>Enable</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label><strong>PGP Key Size</strong></label>
                        <select class="form-control" name="google_pgp_encryption">
                            <option value="2048" <cfif googleProvisionSettings.pgp_encryption EQ "2048">selected</cfif>>2048-bit (Recommended)</option>
                            <option value="4096" <cfif googleProvisionSettings.pgp_encryption EQ "4096">selected</cfif>>4096-bit (High Security)</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="mt-3">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i>Save Google Provisioning</button>
                <a href="/user-auth/google_login.cfm" class="btn btn-secondary" target="_blank" rel="noopener"><i class="fab fa-google me-1"></i>Test Organization Login</a>
                <a href="view_internal_recipients.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back to Relay Recipients</a>
            </div>
        </form>
    </div>
</div>

      </div>
    </div>
  </main>
</div>
</body>
</html>
