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

<cfparam name="googleProvisionRecipientEmail" default="">
<cfparam name="googleProvisionRecipientName" default="#googleProvisionRecipientEmail#">
<cfparam name="googleProvisionPolicy" default="">
<cfparam name="googleProvisionReports" default="YES">
<cfparam name="googleProvisionTrainBayes" default="0">
<cfparam name="googleProvisionDownloadMsg" default="0">
<cfparam name="googleProvisionEnforceMfa" default="0">
<cfparam name="googleProvisionPdfEnabled" default="2">
<cfparam name="googleProvisionSmimeEnabled" default="2">
<cfparam name="googleProvisionCa" default="">
<cfparam name="googleProvisionValidity" default="1825">
<cfparam name="googleProvisionCertEncryption" default="2048">
<cfparam name="googleProvisionCertAlgorithm" default="sha256">
<cfparam name="googleProvisionSign" default="2">
<cfparam name="googleProvisionPgpEnabled" default="2">
<cfparam name="googleProvisionPgpEncryption" default="2048">

<cfset googleProvisionStatus = "error">
<cfset googleProvisionMessage = "Unable to create your account. Please contact your system administrator.">
<cfset googleProvisionExistingAuthType = "">
<cfset googleProvisionExistingRemoteAuthDomain = "">

<cfset recipientEmail = LCase(Trim(googleProvisionRecipientEmail))>
<cfset recipientName = Len(Trim(googleProvisionRecipientName)) GT 0 ? Trim(googleProvisionRecipientName) : recipientEmail>
<cfset recipientName = HTMLEditFormat(recipientName)>
<cfset googleProvisionRecipientId = 0>
<cfset recipientCreated = false>
<cfset userSettingsCreated = false>

<cfif recipientEmail EQ "" OR NOT IsValid("email", recipientEmail)>
    <cfset googleProvisionMessage = "Unable to validate your organization account. Please contact your system administrator.">
<cfelse>
    <cfset domainpart = ListGetAt(recipientEmail, 2, "@")>

    <cfquery name="checkdomain" datasource="hermes">
        SELECT domain
        FROM domains
        WHERE domain = <cfqueryparam value="#domainpart#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkdomain.recordcount LT 1>
        <cfset googleProvisionMessage = "Your email domain is not configured for this portal. Please contact your system administrator.">
    <cfelse>
        <cflock timeout="15" throwontimeout="true" type="exclusive" name="google_provision_recipient_#Hash(recipientEmail)#">
            <cfquery name="checkentry" datasource="hermes">
                SELECT id, auth_type, remoteauth_domain
                FROM recipients
                WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
                LIMIT 1
            </cfquery>

            <cfif checkentry.recordcount GTE 1>
                <cfset googleProvisionStatus = "exists">
                <cfset googleProvisionMessage = "An account already exists for this email address.">
                <cfset googleProvisionExistingAuthType = checkentry.auth_type>
                <cfset googleProvisionExistingRemoteAuthDomain = checkentry.remoteauth_domain>
            <cfelse>
                <cfquery datasource="hermes">
                    INSERT INTO recipients
                    (policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm, auth_type, remoteauth_domain, enforce_mfa)
                    VALUES
                    (
                        <cfqueryparam value="#googleProvisionPolicy#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                        'OK',
                        '2',
                        <cfqueryparam value="#googleProvisionPdfEnabled#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#googleProvisionSmimeEnabled#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#googleProvisionPgpEnabled#" cfsqltype="cf_sql_integer">,
                        '1',
                        <cfqueryparam value="#googleProvisionSign#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#googleProvisionValidity#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#googleProvisionCertEncryption#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#googleProvisionCertAlgorithm#" cfsqltype="cf_sql_varchar">,
                        'local',
                        NULL,
                        <cfqueryparam value="#googleProvisionEnforceMfa#" cfsqltype="cf_sql_tinyint">
                    )
                </cfquery>
                <cfquery name="getNewRecipientId" datasource="hermes">
                    SELECT id
                    FROM recipients
                    WHERE recipient = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
                    ORDER BY id DESC
                    LIMIT 1
                </cfquery>
                <cfif getNewRecipientId.recordcount GTE 1>
                    <cfset googleProvisionRecipientId = getNewRecipientId.id>
                    <cfset recipientCreated = true>
                </cfif>
            </cfif>
        </cflock>

        <cfif recipientCreated>
            <cftry>
            <cfquery name="checkUserSettings" datasource="hermes">
                SELECT email
                FROM user_settings
                WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
                LIMIT 1
            </cfquery>

            <cfif checkUserSettings.recordcount GTE 1>
                <cfquery datasource="hermes">
                    UPDATE user_settings
                    SET report_enabled = <cfqueryparam value="#googleProvisionReports#" cfsqltype="cf_sql_varchar">,
                        train_bayes = <cfqueryparam value="#googleProvisionTrainBayes#" cfsqltype="cf_sql_tinyint">,
                        download_msg = <cfqueryparam value="#googleProvisionDownloadMsg#" cfsqltype="cf_sql_tinyint">
                    WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
                </cfquery>
            <cfelse>
                <cfquery datasource="hermes">
                    INSERT INTO user_settings
                    (email, report_enabled, train_bayes, download_msg)
                    VALUES
                    (
                        <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#googleProvisionReports#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#googleProvisionTrainBayes#" cfsqltype="cf_sql_tinyint">,
                        <cfqueryparam value="#googleProvisionDownloadMsg#" cfsqltype="cf_sql_tinyint">
                    )
                </cfquery>
                <cfset userSettingsCreated = true>
            </cfif>

            <cfset show_pdf_enabled = googleProvisionPdfEnabled>
            <cfset show_smime_enabled = googleProvisionSmimeEnabled>
            <cfset show_pgp_enabled = googleProvisionPgpEnabled>
            <cfset show_sign = googleProvisionSign>

            <cfif show_pdf_enabled EQ "1" OR show_smime_enabled EQ "1" OR show_pgp_enabled EQ "1">
                <cfthread action="run" name="googleProvisionDjigzo_#Hash(recipientEmail & CreateUUID())#" recipientEmail="#recipientEmail#">
                    <cfset recipient = attributes.recipientEmail>
                    <cfset djigzonotadded = 0>
                    <cfset djigzonotaddedrecipient = "">
                    <cfinclude template="/admin/2/inc/add_internal_recipients_djigzo.cfm">
                </cfthread>
            </cfif>

            <cfif googleProvisionRecipientId GT 0 AND show_smime_enabled EQ "1" AND IsValid("integer", googleProvisionCa)>
                <cfquery name="existingSmimeCert" datasource="hermes">
                    SELECT id
                    FROM recipient_certificates
                    WHERE user_id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                    LIMIT 1
                </cfquery>
                <cfif existingSmimeCert.recordcount LT 1>
                    <cfinclude template="/admin/2/inc/generate_random_password.cfm">
                    <cfquery datasource="hermes">
                        INSERT INTO cert_generation_queue
                        (recipient_id, recipient_email, job_type, ca_id, validity, encryption, algorithm, password)
                        VALUES
                        (
                            <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                            'smime',
                            <cfqueryparam value="#googleProvisionCa#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#googleProvisionValidity#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#googleProvisionCertEncryption#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#googleProvisionCertAlgorithm#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">
                        )
                    </cfquery>
                </cfif>
            </cfif>

            <cfif googleProvisionRecipientId GT 0 AND show_pgp_enabled EQ "1">
                <cfquery name="existingPgpKeyring" datasource="hermes">
                    SELECT id
                    FROM recipient_keystores
                    WHERE user_id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                    AND master = '1'
                    LIMIT 1
                </cfquery>
                <cfif existingPgpKeyring.recordcount LT 1>
                    <cfinclude template="/admin/2/inc/generate_random_password.cfm">
                    <cfset pgpNameReal = ListFirst(recipientEmail, "@")>
                    <cfquery datasource="hermes">
                        INSERT INTO cert_generation_queue
                        (recipient_id, recipient_email, job_type, pgp_key_length, pgp_name_real, password)
                        VALUES
                        (
                            <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">,
                            'pgp',
                            <cfqueryparam value="#googleProvisionPgpEncryption#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#pgpNameReal#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">
                        )
                    </cfquery>
                </cfif>
            </cfif>

            <cfset ldapAddError = "">
            <cfinclude template="/admin/2/inc/ldap_add_user_relay.cfm">
            <cfset ldapProvisionSucceeded = (IsDefined("ldapUserCreated") AND ldapUserCreated)>
            <cfif ldapProvisionSucceeded AND Len(Trim(ldapAddError)) GT 0 AND NOT FindNoCase("Already exists", ldapAddError)>
                <cfset ldapProvisionSucceeded = false>
            </cfif>

            <cfif NOT ldapProvisionSucceeded>
                <cfthrow message="Unable to provision LDAP user.">
            </cfif>

            <cfset welcomeEmailSent = true>
            <cftry>
                <cfinclude template="/admin/2/inc/send_recipient_welcome_email.cfm">
                <cfcatch type="any">
                    <cfset welcomeEmailSent = false>
                </cfcatch>
            </cftry>

            <cfif welcomeEmailSent>
                <cfset googleProvisionStatus = "created">
                <cfset googleProvisionMessage = "Your account has been created and a welcome email has been sent.">
            <cfelse>
                <cfset googleProvisionStatus = "created_email_failed">
                <cfset googleProvisionMessage = "Your account has been created, but we were unable to send the welcome email. Please contact your system administrator for password setup instructions.">
            </cfif>
            <cfcatch type="any">
                <cftry>
                    <cfif googleProvisionRecipientId GT 0>
                        <cfquery datasource="hermes">
                            DELETE FROM cert_generation_queue
                            WHERE recipient_id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        <cfquery datasource="hermes">
                            DELETE FROM recipient_certificates
                            WHERE user_id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        <cfquery datasource="hermes">
                            DELETE FROM recipient_keystores
                            WHERE user_id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        <cfquery datasource="hermes">
                            DELETE FROM recipients
                            WHERE id = <cfqueryparam value="#googleProvisionRecipientId#" cfsqltype="cf_sql_integer">
                        </cfquery>
                    </cfif>
                    <cfif userSettingsCreated>
                        <cfquery datasource="hermes">
                            DELETE FROM user_settings
                            WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                    </cfif>
                    <cfcatch type="any"></cfcatch>
                </cftry>
                <cfset googleProvisionStatus = "error">
                <cfset googleProvisionMessage = "Unable to finish creating your account. Please contact your system administrator.">
            </cfcatch>
            </cftry>
        </cfif>
    </cfif>
</cfif>
