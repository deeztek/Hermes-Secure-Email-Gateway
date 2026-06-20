<!---
Hermes Secure Email Gateway - SMTP SNI Configuration Generator
Called after successful ACME certificate request in acme_validate_ip.cfm

Generates SNI (Server Name Indication) configuration for Postfix to serve
different SSL certificates based on the client's requested hostname.

Pro Edition Feature - Requires valid license
--->

<cfsetting requesttimeout="300">

<!--- Get all validated subdomains with their certificate info --->
<cfquery name="getValidatedSans" datasource="hermes">
    SELECT DISTINCT
        m.subdomain,
        m.certificate,
        c.domain_name as cert_name
    FROM mailbox_sans m
    JOIN system_certificates c ON m.certificate = c.id
    WHERE m.ip = 'YES'
    AND m.dns = 'YES'
    ORDER BY m.subdomain
</cfquery>

<cfif getValidatedSans.recordcount GTE 1>

    <!--- Create /etc/postfix/sni/ directory if not exists --->
    <cfset sniDir = "/etc/postfix/sni">
    <cfif NOT DirectoryExists(sniDir)>
        <cftry>
            <cfdirectory action="create" directory="#sniDir#" mode="700">
            <cfcatch type="any">
                <cfoutput>Error creating SNI directory: #cfcatch.message#</cfoutput><br>
            </cfcatch>
        </cftry>
    </cfif>

    <!--- Initialize sni_maps content --->
    <cfset sniMapsContent = "">
    <cfset sniCount = 0>

    <!--- For each validated subdomain, create combined PEM file --->
    <cfloop query="getValidatedSans">
        <cfset keyPath = "/etc/letsencrypt/live/#cert_name#/privkey.pem">
        <cfset certPath = "/etc/letsencrypt/live/#cert_name#/fullchain.pem">
        <cfset outputPem = "#sniDir#/#subdomain#.pem">

        <!--- Check if source files exist --->
        <cfif FileExists(keyPath) AND FileExists(certPath)>
            <cftry>
                <!--- Read key and cert --->
                <cffile action="read" file="#keyPath#" variable="keyContent">
                <cffile action="read" file="#certPath#" variable="certContent">

                <!--- Write combined PEM (key first, then fullchain) --->
                <cffile action="write" file="#outputPem#" output="#Trim(keyContent)##chr(10)##Trim(certContent)#" mode="600">

                <!--- Add to sni_maps --->
                <cfset sniMapsContent = sniMapsContent & subdomain & "    " & outputPem & chr(10)>
                <cfset sniCount = sniCount + 1>

                <cfoutput>Created SNI PEM for #subdomain#</cfoutput><br>

                <cfcatch type="any">
                    <cfoutput>Error creating PEM for #subdomain#: #cfcatch.message#</cfoutput><br>
                </cfcatch>
            </cftry>
        <cfelse>
            <cfoutput>Warning: Certificate files not found for #subdomain# (cert: #cert_name#)</cfoutput><br>
        </cfif>
    </cfloop>

    <!--- Write sni_maps file and enable SNI if we have entries --->
    <cfif sniCount GT 0 AND Len(Trim(sniMapsContent)) GT 0>
        <cftry>
            <!--- Write sni_maps file --->
            <cffile action="write" file="/etc/postfix/sni_maps" output="#Trim(sniMapsContent)#" mode="644">
            <cfoutput>Written /etc/postfix/sni_maps with #sniCount# hostname(s)</cfoutput><br>

            <!--- Compile sni_maps in Docker container using postmap -F for file paths --->
            <cftry>
                <cfexecute name="/usr/local/bin/docker"
                    arguments="exec hermes_postfix_dkim postmap -F hash:/etc/postfix/sni_maps"
                    timeout="60"
                    variable="postmapOutput"
                    errorvariable="postmapError"/>
                <cfif Len(Trim(postmapOutput)) GT 0>
                    <cfoutput>Compiled sni_maps: #postmapOutput#</cfoutput><br>
                <cfelse>
                    <cfoutput>Compiled sni_maps successfully</cfoutput><br>
                </cfif>
                <cfcatch type="any">
                    <cfoutput>Error compiling sni_maps: #cfcatch.message#</cfoutput><br>
                </cfcatch>
            </cftry>

            <!--- Enable tls_server_sni_maps parameter in database --->
            <cfquery datasource="hermes">
                UPDATE parameters
                SET enabled = 1
                WHERE parameter = 'tls_server_sni_maps' AND child = 0
            </cfquery>
            <cfoutput>Enabled tls_server_sni_maps parameter</cfoutput><br>

            <cfoutput><strong>SMTP SNI configuration updated with #sniCount# hostname(s)</strong></cfoutput><br>

            <cfcatch type="any">
                <cfoutput>Error writing SNI configuration: #cfcatch.message#</cfoutput><br>
            </cfcatch>
        </cftry>
    <cfelse>
        <cfoutput>No valid SNI entries generated - SNI not enabled</cfoutput><br>
    </cfif>

<cfelse>
    <!--- No validated SANs - disable SNI if it was enabled --->
    <cfquery name="checkSniEnabled" datasource="hermes">
        SELECT enabled FROM parameters
        WHERE parameter = 'tls_server_sni_maps' AND child = 0
    </cfquery>

    <cfif checkSniEnabled.recordcount GT 0 AND checkSniEnabled.enabled EQ 1>
        <cfquery datasource="hermes">
            UPDATE parameters
            SET enabled = 0
            WHERE parameter = 'tls_server_sni_maps' AND child = 0
        </cfquery>
        <cfoutput>No validated SANs found - SMTP SNI disabled</cfoutput><br>
    <cfelse>
        <cfoutput>No validated SANs found - SMTP SNI remains disabled</cfoutput><br>
    </cfif>
</cfif>
