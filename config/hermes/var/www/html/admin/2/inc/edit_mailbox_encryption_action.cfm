
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
EDIT MAILBOX ENCRYPTION ACTION HANDLER
Updates encryption settings for a mailbox user:
- recipients table: pdf_enabled, smime_enabled, pgp_enabled, digital_sign
- Ciphermail: CLITool enable/disable encryption types
- cert_generation_queue: queue new S/MIME or PGP cert generation if enabled
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "mailbox_id") OR NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE RECIPIENT EMAIL --->
<cfif NOT StructKeyExists(form, "recipient_email") OR trim(form.recipient_email) EQ "">
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset recipient = trim(form.recipient_email)>

<!--- VERIFY MAILBOX EXISTS --->
<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username FROM mailboxes m
    WHERE m.id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getMailbox.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE FORM FIELDS --->
<cfparam name="form.pdf_enabled" default="2">
<cfif form.pdf_enabled NEQ "1" AND form.pdf_enabled NEQ "2">
    <cfset m="Edit Mailbox Encryption: invalid pdf_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<cfparam name="form.smime_enabled" default="2">
<cfif form.smime_enabled NEQ "1" AND form.smime_enabled NEQ "2">
    <cfset m="Edit Mailbox Encryption: invalid smime_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<cfparam name="form.sign" default="2">
<cfif form.sign NEQ "1" AND form.sign NEQ "2">
    <cfset m="Edit Mailbox Encryption: invalid sign value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<cfparam name="form.pgp_enabled" default="2">
<cfif form.pgp_enabled NEQ "1" AND form.pgp_enabled NEQ "2">
    <cfset m="Edit Mailbox Encryption: invalid pgp_enabled value">
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- VALIDATE S/MIME OPTIONS --->
<cfparam name="form.ca" default="">
<cfparam name="form.validity" default="1825">
<cfparam name="form.cert_encryption" default="2048">
<cfparam name="form.cert_algorithm" default="sha256">

<!--- VALIDATE PGP OPTIONS --->
<cfparam name="form.pgp_encryption" default="2048">

<!--- SET VARIABLES FOR DJIGZO INCLUDE (reuses relay recipient handler) --->
<cfset show_pdf_enabled = form.pdf_enabled>
<cfset show_smime_enabled = form.smime_enabled>
<cfset show_pgp_enabled = form.pgp_enabled>
<cfset show_sign = form.sign>
<cfset djigzonotadded = 0>
<cfset djigzonotaddedrecipient = "">

<!--- UPDATE CIPHERMAIL ENCRYPTION SETTINGS --->
<cfinclude template="edit_internal_recipients_djigzo.cfm">

<!--- QUEUE S/MIME CERTIFICATE GENERATION (if enabling and no cert exists) --->
<cfset session.smimeQueued = 0>
<cfif form.smime_enabled EQ "1" AND form.ca NEQ "">
    <cfquery name="getRecipientId" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getRecipientId.recordcount GTE 1>
        <cfquery name="existingSmimeCert" datasource="hermes">
            SELECT id FROM recipient_certificates
            WHERE user_id = <cfqueryparam value="#getRecipientId.id#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        <cfif existingSmimeCert.recordcount LT 1>
            <cfinclude template="generate_random_password.cfm">
            <cfquery datasource="hermes">
                INSERT INTO cert_generation_queue
                (recipient_id, recipient_email, job_type, ca_id, validity, encryption, algorithm, password)
                VALUES
                (<cfqueryparam value="#getRecipientId.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                 'smime',
                 <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.validity#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#form.cert_algorithm#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
            <cfset session.smimeQueued = 1>
        </cfif>
    </cfif>
</cfif>

<!--- QUEUE PGP KEYRING GENERATION (if enabling and no keyring exists) --->
<cfset session.pgpQueued = 0>
<cfif form.pgp_enabled EQ "1">
    <cfquery name="getRecipientId2" datasource="hermes">
        SELECT id FROM recipients WHERE recipient = <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getRecipientId2.recordcount GTE 1>
        <cfquery name="existingPgpKeyring" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE user_id = <cfqueryparam value="#getRecipientId2.id#" cfsqltype="cf_sql_integer">
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
                (<cfqueryparam value="#getRecipientId2.id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                 'pgp',
                 <cfqueryparam value="#form.pgp_encryption#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#pgpNameReal#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
            </cfquery>
            <cfset session.pgpQueued = 1>
        </cfif>
    </cfif>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 4>
<cflocation url="view_mailboxes.cfm" addtoken="no">
