
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!--- SMTP SNI Configuration Generator ---
Generates Postfix SNI config files automatically from validated ACME certificates.
This follows the same pattern as generate_nginx_configuration.cfm for the mailbox SNI configs.

Reads from mailbox_sans table where DNS = 'YES' (validated domains)
Creates combined PEM files (key + fullchain) in /etc/postfix/sni/
Generates /etc/postfix/sni_maps and compiles with postmap -F

Sets:
- sniSyncSuccess: Boolean indicating success
- sniSyncError: Error message if failed
--->

<cfset sniSyncSuccess = false>
<cfset sniSyncError = "">

<cftry>

<!--- Get all validated certificates from mailbox_sans (same source as Nginx SNI) --->
<cfquery name="getValidatedCerts" datasource="hermes">
    SELECT DISTINCT(m.certificate), c.type, c.file_name, c.domain_name
    FROM mailbox_sans m
    JOIN system_certificates c ON m.certificate = c.id
    WHERE m.mailbox_domain = '1' AND m.DNS = 'YES'
</cfquery>

<cfif getValidatedCerts.recordcount LT 1>
    <!--- No validated certificates - clean up any existing SNI config --->
    <cfif FileExists("/etc/postfix/sni_maps")>
        <cffile action="delete" file="/etc/postfix/sni_maps">
    </cfif>
    <cfif FileExists("/etc/postfix/sni_maps.db")>
        <cffile action="delete" file="/etc/postfix/sni_maps.db">
    </cfif>
    <cfset sniSyncSuccess = true>
<cfelse>

    <!--- Create /etc/postfix/sni/ directory if not exists --->
    <cfif NOT DirectoryExists("/etc/postfix/sni")>
        <cfdirectory action="create" directory="/etc/postfix/sni">
        <cfexecute name="/bin/chmod" arguments="700 /etc/postfix/sni" timeout="10"/>
        <cfexecute name="/bin/chown" arguments="root:root /etc/postfix/sni" timeout="10"/>
    </cfif>

    <!--- Clean up old PEM files --->
    <cfif DirectoryExists("/etc/postfix/sni")>
        <cfdirectory action="list" directory="/etc/postfix/sni" name="oldPemFiles" filter="*.pem">
        <cfloop query="oldPemFiles">
            <cffile action="delete" file="/etc/postfix/sni/#oldPemFiles.name#">
        </cfloop>
    </cfif>

    <!--- Initialize sni_maps content --->
    <cfset sniMapsContent = "">

    <!--- Process each validated certificate --->
    <cfloop query="getValidatedCerts">

        <!--- Get all validated subdomains for this certificate --->
        <cfquery name="getSubdomains" datasource="hermes">
            SELECT subdomain FROM mailbox_sans
            WHERE certificate = <cfqueryparam value="#getValidatedCerts.certificate#" cfsqltype="cf_sql_integer">
            AND DNS = 'YES'
            ORDER BY subdomain ASC
        </cfquery>

        <!--- Determine source paths based on certificate type --->
        <cfif getValidatedCerts.type EQ "Imported">
            <cfset keyPath = "/opt/hermes/ssl/#getValidatedCerts.file_name#_hermes.key">
            <cfset certPath = "/opt/hermes/ssl/#getValidatedCerts.file_name#_hermes.bundle.pem">
        <cfelseif getValidatedCerts.type EQ "Acme">
            <cfset keyPath = "/etc/letsencrypt/live/#getValidatedCerts.file_name#/privkey.pem">
            <cfset certPath = "/etc/letsencrypt/live/#getValidatedCerts.file_name#/fullchain.pem">
        <cfelse>
            <!--- Unknown certificate type - skip --->
            <cfcontinue>
        </cfif>

        <!--- Verify source files exist --->
        <cfif NOT FileExists(keyPath)>
            <cfset sniSyncError = "Key file not found: #keyPath#">
            <cfcontinue>
        </cfif>
        <cfif NOT FileExists(certPath)>
            <cfset sniSyncError = "Certificate file not found: #certPath#">
            <cfcontinue>
        </cfif>

        <!--- Read key and certificate content --->
        <cffile action="read" file="#keyPath#" variable="keyContent">
        <cffile action="read" file="#certPath#" variable="certContent">

        <!--- Create combined PEM for each subdomain --->
        <cfloop query="getSubdomains">
            <cfset hostname = lCase(trim(getSubdomains.subdomain))>

            <!--- Write combined PEM file (key first, then fullchain) --->
            <cfset combinedPem = trim(keyContent) & chr(10) & trim(certContent)>
            <cffile action="write"
                file="/etc/postfix/sni/#hostname#.pem"
                output="#combinedPem#"
                addnewline="no">

            <!--- Set secure permissions (600 = owner read/write only) --->
            <cfexecute name="/bin/chmod" arguments="600 /etc/postfix/sni/#hostname#.pem" timeout="10"/>
            <cfexecute name="/bin/chown" arguments="root:root /etc/postfix/sni/#hostname#.pem" timeout="10"/>

            <!--- Add to sni_maps content --->
            <cfset sniMapsContent = sniMapsContent & hostname & "    /etc/postfix/sni/" & hostname & ".pem" & chr(10)>
        </cfloop>

    </cfloop>

    <!--- Write sni_maps file --->
    <cfif len(trim(sniMapsContent))>
        <cffile action="write"
            file="/etc/postfix/sni_maps"
            output="#trim(sniMapsContent)#"
            addnewline="yes">

        <!--- Convert to Unix line endings --->
        <cfexecute name="/usr/bin/dos2unix"
            arguments="/etc/postfix/sni_maps"
            timeout="10"/>

        <!--- Set permissions on sni_maps --->
        <cfexecute name="/bin/chmod" arguments="644 /etc/postfix/sni_maps" timeout="10"/>
        <cfexecute name="/bin/chown" arguments="root:root /etc/postfix/sni_maps" timeout="10"/>

        <!--- Compile sni_maps in Docker container (note the -F flag for file paths) --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_postfix_dkim postmap -F hash:/etc/postfix/sni_maps"
            variable="postmapResult"
            errorVariable="postmapError"
            timeout="60"/>

        <cfset sniSyncSuccess = true>
    <cfelse>
        <!--- No hostnames to map - clean up --->
        <cfif FileExists("/etc/postfix/sni_maps")>
            <cffile action="delete" file="/etc/postfix/sni_maps">
        </cfif>
        <cfif FileExists("/etc/postfix/sni_maps.db")>
            <cffile action="delete" file="/etc/postfix/sni_maps.db">
        </cfif>
        <cfset sniSyncSuccess = true>
    </cfif>

</cfif>

<cfcatch type="any">
    <cfset sniSyncSuccess = false>
    <cfset sniSyncError = cfcatch.message & " - " & cfcatch.detail>
</cfcatch>

</cftry>
