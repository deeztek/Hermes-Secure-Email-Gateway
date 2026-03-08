
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

<!--- GET DEFAULT POLICY STARTS HERE --->
<!--- NOT USED SINCE ADD-INTERNAL-RECIPIENTS TEMPLATE SPECIFIES POLICY --->
<!---
<cfquery name="getdefaultpolicy" datasource="hermes">
select policy_id, default_policy from spam_policies where default_policy='1'
</cfquery>
    
<cfif #getdefaultpolicy.recordcount# GTE 1>
<cfset policy="#getdefaultpolicy.recordcount#">  

<cfelse>
<cfset policy="7">
<!--- #getdefaultpolicy.recordcount# GTE 1 --->
</cfif>
--->

<!--- GET DEFAULT POLICY ENDS HERE --->


<cfinclude template="generate_customtrans.cfm">


<!---
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_recipients"
output = "#show_recipient#"> 

<cfoutput>
textarea: #show_recipient#
</cfoutput>



    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_recipients" variable="therecipients">
--->

    <!---
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_recipients">

    <cfif fileExists(FiletoDelete)>
        <cffile action = "delete" file = "#FiletoDelete#"> 
        <!--- /CFIF fileExists --->
        </cfif>

    --->

<cfloop index="recipient" list="#show_recipient#" delimiters="#chr(10)#">

    <cfoutput>
    <cfset recipient = #LCase(recipient)#>
    <cfset recipient = #trim(recipient)#>
</cfoutput>

        <cfif #recipient# is not "">
        <cfset step=1>
        <cfelseif #recipient# is "">
        <cfset step=0>
        <cfset errormessage=2>
        <cfset emptyemail=#emptyemail#+1>

        <!--- /CFIF #trim(recipient)# --->
        </cfif>

        <cfif #step# is "1">
        <cfif IsValid("email", recipient)>
        <cfset step=2>

        <cfelseif NOT IsValid("email", recipient)>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset invalidemail=#invalidemail#+1>
        <cfset invalidemailrecipient="#invalidemailrecipient# #recipient#<br>">

         <!--- /CFIF IsValid("email", recipient) --->
        </cfif>
        
        <!--- /CFIF #step# is "1" --->
        </cfif>

        <cfif #step# is "2">
        <cfset domainpart = #ListGetAt(recipient, 2, "@")#>
        
        <cfquery name="checkdomain" datasource="hermes">
        select domain from domains where domain='#domainpart#'
        </cfquery>

        <cfif #checkdomain.recordcount# GTE 1>
        <cfset step=3>
        <cfelseif #checkdomain.recordcount# LT 1>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset invaliddomain=#invaliddomain#+1>
        <cfset invaliddomainrecipient="#invaliddomainrecipient# #recipient#<br>">
        
         <!--- /CFIF #checkdomain.recordcount# --->
        </cfif>

        <!--- /CFIF #step# is "2" --->
        </cfif>
        
        <cfif #step# is "3">
        <cfoutput>
        <cfquery name="checkentry" datasource="hermes">
        select recipient from recipients where recipient='#recipient#'
        </cfquery>
        </cfoutput>

        <cfif #checkentry.recordcount# LT 1>
        <cfset step=4>
        <cfelseif #checkentry.recordcount# GTE 1>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset alreadyexists=#alreadyexists#+1>
        <cfset alreadyexistsrecipient="#alreadyexistsrecipient# #recipient#<br>">

         <!--- /CFIF #checkentry.recordcount# --->
        </cfif>

        <!--- /CFIF #step# is "3" --->
        </cfif>

        
        <cfif #step# is "4">
        <cfoutput>
        
        <cfquery name="insert" datasource="hermes">
        insert into recipients
        (policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm, auth_type, remoteauth_domain)
        values
        ('#show_policy#', '#recipient#', 'OK', '2', '#show_pdf_enabled#', '#show_smime_enabled#', '#show_pgp_enabled#', '1', '#show_sign#', '1825', '4096', 'sha512', <cfqueryparam value="#show_auth_type#" cfsqltype="cf_sql_varchar">, <cfif show_remoteauth_domain NEQ ""><cfqueryparam value="#show_remoteauth_domain#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>)
        </cfquery>
        </cfoutput>
                
    <!--- INSERT INTO USER_SETTINGS STARTS HERE --->

    <cfquery name="insertreport" datasource="hermes">
        INSERT INTO user_settings
        (email, report_enabled, report_frequency, train_bayes, download_msg)
        VALUES
        ('#recipient#', '#show_reports#', '#show_frequency#', '#show_train_bayes#', '#show_download_msg#')
    </cfquery>

    <!--- INSERT INTO USER_SETTINGS ENDS HERE --->

    <!--- CREATE LDAP USER FOR RECIPIENT STARTS HERE --->
    <cfset recipientEmail = recipient>
    <cfif show_auth_type EQ "remote">
        <!--- Remote Auth: creates LDAP user with seeAlso/associatedDomain, no password --->
        <cfset remoteauthDomain = show_remoteauth_domain>
        <cfinclude template="ldap_add_user_relay_remoteauth.cfm">
    <cfelse>
        <!--- Local Auth: creates LDAP user with random password, user must reset --->
        <cfinclude template="ldap_add_user_relay.cfm">
    </cfif>

    <!--- SEND WELCOME EMAIL TO NEW RECIPIENT --->
    <cfset recipientName = recipientEmail>
    <cfif show_auth_type EQ "remote">
        <cfinclude template="send_recipient_welcome_email_remoteauth.cfm">
    <cfelse>
        <cfinclude template="send_recipient_welcome_email.cfm">
    </cfif>
    <!--- CREATE LDAP USER FOR RECIPIENT ENDS HERE --->


    <cfset success=#success#+1>
    <cfset successrecipient="#successrecipient# #recipient#<br>">

      <!--- /CFIF #step# is "4" --->
    </cfif>

    <!--- ENCRYPTION AND CERTIFICATE SETUP (only for successfully added recipients) --->
    <cfif #step# is "4">

<cfif #pdf_enabled# is "1" OR #smime_enabled# is "1" OR #pgp_enabled# is "1">

<cfinclude template="add_internal_recipients_djigzo.cfm">

<!--- #pdf_enabled# is "1" OR #smime_enabled# is "1" OR #pgp_enabled# is "1" --->
</cfif>

<!--- QUEUE S/MIME CERTIFICATE GENERATION (background) --->
<cfif show_smime_enabled is "1" AND StructKeyExists(form, "ca")>
    <cfquery name="getNewRecipientId" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getNewRecipientId.recordcount GTE 1>
        <!--- Only queue if recipient doesn't already have a certificate --->
        <cfquery name="existingSmimeCert" datasource="hermes">
            SELECT id FROM recipient_certificates
            WHERE user_id = <cfqueryparam value="#getNewRecipientId.id#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        <cfif existingSmimeCert.recordcount LT 1>
            <cfinclude template="generate_random_password.cfm">
            <cfquery datasource="hermes">
                INSERT INTO cert_generation_queue
                (recipient_id, recipient_email, job_type, ca_id, validity, encryption, algorithm, password)
                VALUES
                (<cfqueryparam value="#getNewRecipientId.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                 'smime',
                 <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.validity#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_algorithm#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<!--- QUEUE PGP KEYRING GENERATION (background) --->
<cfif show_pgp_enabled is "1">
    <cfquery name="getNewRecipientId2" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getNewRecipientId2.recordcount GTE 1>
        <!--- Only queue if recipient doesn't already have a keyring --->
        <cfquery name="existingPgpKeyring" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE user_id = <cfqueryparam value="#getNewRecipientId2.id#" cfsqltype="cf_sql_integer">
            AND master = '1'
            LIMIT 1
        </cfquery>
        <cfif existingPgpKeyring.recordcount LT 1>
            <cfinclude template="generate_random_password.cfm">
            <cfset pgpNameReal = ListFirst(recipient, "@")>
            <cfquery datasource="hermes">
                INSERT INTO cert_generation_queue
                (recipient_id, recipient_email, job_type, pgp_key_length, pgp_name_real, password)
                VALUES
                (<cfqueryparam value="#getNewRecipientId2.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                 'pgp',
                 <cfqueryparam value="#form.pgp_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#pgpNameReal#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
        </cfif>
    </cfif>
</cfif>

      <!--- /CFIF #step# is "4" (encryption/cert setup) --->
    </cfif>

<!--- /CFLOOP index="recipient" --->
</cfloop>

<!--- CREATE USERS TABLE WITH RECIPIENTS TABLE STARTS HERE --->
<!---
<cfinclude template="../common/stop_postfix.cfm">
<cfinclude template="../common/stop_amavis.cfm">
<cfinclude template="../common/create_users_table_with_recipients_table.cfm">
<cfinclude template="../common/start_postfix.cfm">
<cfinclude template="../common/start_amavis.cfm">
--->

<!--- CREATE USERS TABLE WITH RECIPIENTS TABLE ENDS HERE --->