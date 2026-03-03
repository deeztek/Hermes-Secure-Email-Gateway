<!---
Hermes Secure Email Gateway - Background Certificate/Keyring Queue Processor
Called by Ofelia scheduler every 60 seconds.
Processes pending S/MIME certificate and PGP keyring generation jobs in batches of 5.
--->

<cfsetting requesttimeout="600">

<!--- Generate a random 8-char string for temp file naming (no DB hit) --->
<cfscript>
function generateTempId() {
    var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    var result = "";
    for (var i = 1; i <= 8; i++) {
        result &= Mid(chars, RandRange(1, Len(chars), "SHA1PRNG"), 1);
    }
    return result;
}

function generatePassword() {
    var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    var result = "";
    for (var i = 1; i <= 16; i++) {
        result &= Mid(chars, RandRange(1, Len(chars), "SHA1PRNG"), 1);
    }
    return result;
}
</cfscript>

<!--- RETENTION: Purge completed entries older than 30 days, failed entries older than 90 days --->
<cfquery datasource="hermes">
    DELETE FROM cert_generation_queue
    WHERE (status = 'completed' AND completed_at < DATE_SUB(NOW(), INTERVAL 30 DAY))
    OR (status = 'failed' AND created_at < DATE_SUB(NOW(), INTERVAL 90 DAY))
</cfquery>

<!--- Get pending jobs (batch of 5) --->
<cfquery name="getPendingJobs" datasource="hermes">
    SELECT * FROM cert_generation_queue
    WHERE status = 'pending'
    ORDER BY created_at ASC
    LIMIT 5
</cfquery>

<cfif getPendingJobs.recordcount LT 1>
    <cfoutput>No pending jobs</cfoutput>
    <cfabort>
</cfif>

<cfoutput>Processing #getPendingJobs.recordcount# job(s)...</cfoutput><br>

<cfloop query="getPendingJobs">

    <!--- Mark as processing --->
    <cfquery datasource="hermes">
        UPDATE cert_generation_queue
        SET status = 'processing', started_at = NOW()
        WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
        AND status = 'pending'
    </cfquery>

    <cftry>

    <!--- If password was cleared (e.g., from a previous failure), generate a fresh one --->
    <cfif password IS "">
        <cfset password = generatePassword()>
        <cfquery datasource="hermes">
            UPDATE cert_generation_queue
            SET password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>

    <!--- Generate unique temp file ID --->
    <cfset customtrans3 = generateTempId()>

    <!--- ============================================================ --->
    <!--- S/MIME CERTIFICATE GENERATION --->
    <!--- ============================================================ --->
    <cfif job_type is "smime">

        <!--- Check if recipient already has an S/MIME certificate --->
        <cfquery name="existingCert" datasource="hermes">
            SELECT id FROM recipient_certificates
            WHERE user_id = <cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        <cfif existingCert.recordcount GTE 1>
            <cfquery datasource="hermes">
                UPDATE cert_generation_queue
                SET status = 'completed', completed_at = NOW(), password = NULL,
                    error_message = 'Skipped - recipient already has an S/MIME certificate'
                WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfoutput>Skipped S/MIME for #recipient_email# (certificate already exists)</cfoutput><br>
            <cfcontinue>
        </cfif>

        <!--- Get CA details --->
        <cfquery name="getcadetails" datasource="hermes">
            SELECT * FROM ca_settings WHERE id = <cfqueryparam value="#ca_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif getcadetails.recordcount LT 1>
            <cfthrow message="CA not found for id #ca_id#">
        </cfif>

        <!--- Get any existing certificates from Djigzo for comparison --->
        <cfquery name="getdjigzocertificates" datasource="djigzo">
            SELECT * FROM cm_certificates_email WHERE cm_email = <cfqueryparam value="#recipient_email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif getdjigzocertificates.recordcount GTE 1>
            <cfloop query="getdjigzocertificates">
                <cfquery datasource="hermes">
                    INSERT INTO temp_table (session_id, djigzo_certificate_id, recipient_id)
                    VALUES (<cfqueryparam value="#customtrans3#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#cm_certificates_id#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">)
                </cfquery>
            </cfloop>
        </cfif>

        <!--- Set certificate expiration date --->
        <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
        <cfset certexpires = DateAdd('d', validity, datenow)>
        <cfset certexpires = DateFormat(certexpires, "yyyy-mm-dd")>

        <!--- Get current serial from CA --->
        <cffile action="read" file="/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/serial" variable="currentserial2">
        <cfset currentserial = rereplace(currentserial2, "[[:space:]]", "", "all")>

        <!--- Sanitize recipient name for filenames --->
        <cfset rcpt_name = rereplace(recipient_email, "[^A-Za-z0-9]+", "", "all")>

        <!--- Build shell script from template --->
        <cffile action="read" file="/opt/hermes/scripts/create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'CA-DIRECTORY', getcadetails.ca_directory, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'THE-RECIPIENT', recipient_email, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'THE-ENCRYPTION', encryption, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'THE-ALGORITHM', algorithm, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'THE-VALIDITY', validity, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'THE-PASSWORD', password, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            output="#REReplace(temp, 'RCPT-NAME', '#rcpt_name#_#customtrans3#', 'ALL')#" addnewline="no">

        <!--- Execute the script --->
        <cfexecute name="/bin/chmod"
            arguments="+x /opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            timeout="60" />

        <cfexecute name="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
            timeout="240"
            outputfile="/dev/null"
            arguments="-inputformat none" />

        <!--- Cleanup script --->
        <cfset filelocation = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh">
        <cfif fileExists(filelocation)><cffile action="delete" file="#filelocation#"></cfif>

        <!--- Cleanup serial PEM --->
        <cfset filelocation = "/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/newcerts/#currentserial#.pem">
        <cfif fileExists(filelocation)><cffile action="delete" file="#filelocation#"></cfif>

        <!--- Get certificates from Djigzo (should now include the new one) --->
        <cfquery name="getdjigzocertificates2" datasource="djigzo">
            SELECT * FROM cm_certificates_email WHERE cm_email = <cfqueryparam value="#recipient_email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif getdjigzocertificates2.recordcount LT 1>
            <cfthrow message="No certificates found in Djigzo after generation for #recipient_email#">
        </cfif>

        <!--- Find the new certificate by comparing with temp_table --->
        <cfset thumbprint = "">
        <cfset djigzo_certificate_id = "">
        <cfloop query="getdjigzocertificates2">
            <cfquery name="existsCheck" datasource="hermes">
                SELECT djigzo_certificate_id FROM temp_table
                WHERE session_id = <cfqueryparam value="#customtrans3#" cfsqltype="cf_sql_varchar">
                AND recipient_id = <cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">
                AND djigzo_certificate_id = <cfqueryparam value="#cm_certificates_id#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfif existsCheck.recordcount LT 1>
                <cfquery name="getcertprint" datasource="djigzo">
                    SELECT cm_id, cm_thumbprint FROM cm_certificates WHERE cm_id = <cfqueryparam value="#cm_certificates_id#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfset thumbprint = getcertprint.cm_thumbprint>
                <cfset djigzo_certificate_id = getcertprint.cm_id>
            </cfif>
        </cfloop>

        <!--- Clean up temp_table --->
        <cfquery datasource="hermes">
            DELETE FROM temp_table WHERE session_id = <cfqueryparam value="#customtrans3#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- Insert into Djigzo certificate trust list --->
        <cfquery name="getmax" datasource="djigzo">
            SELECT max(cm_id) as maxid FROM cm_ctl
        </cfquery>

        <cfif getmax.maxid is "">
            <cfset nextid = 1>
        <cfelse>
            <cfset nextid = getmax.maxid + 1>
        </cfif>

        <cfquery datasource="djigzo">
            INSERT INTO cm_ctl (cm_id, cm_name, cm_thumbprint) VALUES (#nextid#, 'global', '#thumbprint#')
        </cfquery>

        <cfquery datasource="djigzo">
            INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) VALUES (#nextid#, 'whitelisted', 'status')
        </cfquery>

        <cfquery datasource="djigzo">
            INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) VALUES (#nextid#, 'false', 'allowExpired')
        </cfquery>

        <!--- AES encrypt password for permanent storage --->
        <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
        <cfset encryptedPassword = encrypt(password, theKey, "AES", "Base64")>

        <!--- Insert into recipient_certificates (internal recipients, type=1) --->
        <cfquery datasource="hermes">
            INSERT INTO recipient_certificates
            (user_id, ca_id, validity, encryption, algorithm, smime_certificate_key, smime_certificate_request,
             smime_certificate_name, pfx_certificate_name, smime_certificate_password, smime_certificate_expiration,
             serial, thumbprint, djigzo_certificate_id)
            VALUES
            (<cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#ca_id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#validity#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#encryption#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#algorithm#" cfsqltype="cf_sql_varchar">,
             '#rcpt_name#_#customtrans3#_key.pem',
             '#rcpt_name#_#customtrans3#.csr',
             '#rcpt_name#_#customtrans3#_cert.pem',
             '#rcpt_name#_#customtrans3#.pfx',
             '#encryptedPassword#',
             '#certexpires#',
             '#currentserial#',
             '#thumbprint#',
             '#djigzo_certificate_id#')
        </cfquery>

        <cfoutput>S/MIME certificate created for #recipient_email#</cfoutput><br>

    <!--- ============================================================ --->
    <!--- PGP KEYRING GENERATION --->
    <!--- ============================================================ --->
    <cfelseif job_type is "pgp">

        <!--- Check if recipient already has a PGP keyring --->
        <cfquery name="existingKeyring" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE user_id = <cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">
            AND master = '1'
            LIMIT 1
        </cfquery>
        <cfif existingKeyring.recordcount GTE 1>
            <cfquery datasource="hermes">
                UPDATE cert_generation_queue
                SET status = 'completed', completed_at = NOW(), password = NULL,
                    error_message = 'Skipped - recipient already has a PGP keyring'
                WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfoutput>Skipped PGP for #recipient_email# (keyring already exists)</cfoutput><br>
            <cfcontinue>
        </cfif>

        <cfset rcpt_name = rereplace(recipient_email, "[^A-Za-z0-9]+", "", "all")>

        <!--- Create GPG batch template --->
        <cffile action="read" file="/opt/hermes/templates/gpg_template" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_gpg_template"
            output="#REReplace(temp, 'KEY_LENGTH', pgp_key_length, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_gpg_template"
            output="#REReplace(temp, 'NAME_REAL', pgp_name_real, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_gpg_template"
            output="#REReplace(temp, 'NAME_EMAIL', recipient_email, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_gpg_template"
            output="#REReplace(temp, 'PASS_PHRASE', password, 'ALL')#" addnewline="no">

        <!--- Create and execute key generation script --->
        <cffile action="read" file="/opt/hermes/scripts/create_pgp_key.sh" variable="temp1">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
            output="#REReplace(temp1, 'CUSTOM-TRANS', customtrans3, 'ALL')#" addnewline="no">

        <cfexecute name="/bin/chmod"
            arguments="+x /opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
            outputfile="/dev/null"
            timeout="60" />

        <cfexecute name="/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
            outputfile="/opt/hermes/tmp/#customtrans3#_gpg_output"
            timeout="240"
            arguments="-inputformat none" />

        <!--- Cleanup key gen script and template --->
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_gpg_template">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>

        <!--- Export and import keys --->
        <cffile action="read" file="/opt/hermes/scripts/export_import_pgp_key.sh" variable="temp1">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
            output="#REReplace(temp1, 'CUSTOM-TRANS', customtrans3, 'ALL')#" addnewline="no">
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh" variable="temp1">

        <cffile action="write"
            file="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
            output="#REReplace(temp1, 'THE-PASSWORD', password, 'ALL')#" addnewline="no">

        <cfexecute name="/bin/chmod"
            arguments="+x /opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
            outputfile="/dev/null"
            timeout="60" />

        <cfexecute name="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
            outputfile="/dev/null"
            timeout="240"
            arguments="-inputformat none" />

        <!--- Cleanup export/import script and key files --->
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_public.key">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_private.key">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>

        <!--- Read key ID from GPG output --->
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_output" variable="theKeyID2">
        <cfset theKeyID = TRIM(theKeyID2)>

        <!--- Cleanup GPG output file --->
        <cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_gpg_output">
        <cfif fileExists(FiletoDelete)><cffile action="delete" file="#FiletoDelete#"></cfif>

        <!--- Get keyring info from Djigzo --->
        <cfquery name="getparentdjigzokeyring" datasource="djigzo">
            SELECT * FROM cm_keyring WHERE cm_keyidhex = <cfqueryparam value="#theKeyID#" cfsqltype="cf_sql_varchar"> AND cm_master = '1'
        </cfquery>

        <cfif getparentdjigzokeyring.recordcount LT 1>
            <cfthrow message="PGP parent key not found in Djigzo for key ID #theKeyID#">
        </cfif>

        <cfquery name="getchilddjigzokeyring" datasource="djigzo">
            SELECT * FROM cm_keyring WHERE cm_parentid = <cfqueryparam value="#getparentdjigzokeyring.cm_id#" cfsqltype="cf_sql_varchar"> AND cm_master = '0'
        </cfquery>

        <!--- Insert parent key into PGP trust list --->
        <cfquery datasource="djigzo">
            INSERT INTO cm_pgp_trust_list (cm_name, cm_fingerprint)
            VALUES ('pgp', '#getparentdjigzokeyring.cm_sha256fingerprint#')
        </cfquery>

        <cfquery name="getctlmaster" datasource="djigzo">
            SELECT cm_id FROM cm_pgp_trust_list WHERE cm_fingerprint = '#getparentdjigzokeyring.cm_sha256fingerprint#'
        </cfquery>

        <cfquery datasource="djigzo">
            INSERT INTO cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name)
            VALUES (#getctlmaster.cm_id#, 'trusted', 'status')
        </cfquery>

        <!--- Insert child keys into PGP trust list --->
        <cfloop query="getchilddjigzokeyring">
            <cfquery datasource="djigzo">
                INSERT INTO cm_pgp_trust_list (cm_name, cm_fingerprint)
                VALUES ('pgp', '#cm_sha256fingerprint#')
            </cfquery>

            <cfquery name="getctlchild" datasource="djigzo">
                SELECT cm_id FROM cm_pgp_trust_list WHERE cm_fingerprint = '#cm_sha256fingerprint#'
            </cfquery>

            <cfquery datasource="djigzo">
                INSERT INTO cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name)
                VALUES (#getctlchild.cm_id#, 'trusted', 'status')
            </cfquery>
        </cfloop>

        <!--- Calculate expiration/creation dates --->
        <cfif getparentdjigzokeyring.cm_expiration_date is not "">
            <cfset pgp_keystore_expiration = DateFormat(getparentdjigzokeyring.cm_expiration_date, "yyyy-mm-dd") & " " & TimeFormat(getparentdjigzokeyring.cm_expiration_date, "HH:mm:ss")>
        <cfelse>
            <cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
        </cfif>

        <cfset pgp_keystore_creation = DateFormat(getparentdjigzokeyring.cm_creation_date, "yyyy-mm-dd") & " " & TimeFormat(getparentdjigzokeyring.cm_creation_date, "HH:mm:ss")>

        <!--- AES encrypt password for permanent storage --->
        <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
        <cfset encryptedPassword = encrypt(password, theKey, "AES", "Base64")>

        <!--- Build user_name in format "RealName <email>" --->
        <cfset pgpUserName = "#pgp_name_real# <#recipient_email#>">

        <!--- Insert parent key into recipient_keystores (internal recipients) --->
        <cfquery datasource="hermes">
            INSERT INTO recipient_keystores
            (user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation,
             encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
             djigzo_keystore_id, master)
            VALUES
            (<cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#pgpUserName#" cfsqltype="cf_sql_varchar">,
             '#encryptedPassword#',
             '#pgp_keystore_expiration#',
             '#pgp_keystore_creation#',
             <cfqueryparam value="#pgp_key_length#" cfsqltype="cf_sql_integer">,
             'RSA',
             '#getparentdjigzokeyring.cm_sha256fingerprint#',
             '#getparentdjigzokeyring.cm_fingerprint#',
             '#theKeyID#',
             '#getparentdjigzokeyring.cm_id#',
             '1')
        </cfquery>

        <!--- Get the parent record ID for child key references --->
        <cfquery name="getparentid" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE master = '1' AND pgp_fingerprint_sha256 = '#getparentdjigzokeyring.cm_sha256fingerprint#'
        </cfquery>

        <!--- Insert child keys into recipient_keystores --->
        <cfloop query="getchilddjigzokeyring">
            <cfquery datasource="hermes">
                INSERT INTO recipient_keystores
                (user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation,
                 encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
                 djigzo_keystore_id, master, parent)
                VALUES
                (<cfqueryparam value="#recipient_id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#pgpUserName#" cfsqltype="cf_sql_varchar">,
                 '#encryptedPassword#',
                 '#pgp_keystore_expiration#',
                 '#pgp_keystore_creation#',
                 <cfqueryparam value="#pgp_key_length#" cfsqltype="cf_sql_integer">,
                 'RSA',
                 '#cm_sha256fingerprint#',
                 '#cm_fingerprint#',
                 '#cm_keyidhex#',
                 '#cm_id#',
                 '#cm_master#',
                 '#getparentid.id#')
            </cfquery>
        </cfloop>

        <cfoutput>PGP keyring created for #recipient_email#</cfoutput><br>

    </cfif>
    <!--- /job_type --->

    <!--- Mark as completed and clear password --->
    <cfquery datasource="hermes">
        UPDATE cert_generation_queue
        SET status = 'completed', completed_at = NOW(), password = NULL
        WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfcatch type="any">
        <!--- Mark as failed with error message and clear password --->
        <cfquery datasource="hermes">
            UPDATE cert_generation_queue
            SET status = 'failed', password = NULL, error_message = <cfqueryparam value="#cfcatch.message# - #cfcatch.detail#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfoutput>ERROR processing job #id# (#recipient_email#): #cfcatch.message#</cfoutput><br>
    </cfcatch>
    </cftry>

</cfloop>

<cfoutput>Queue processing complete</cfoutput>
