

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

<cfinclude template="generate_customtrans.cfm">

<!--- Backup main.cf --->
<cffile action = "copy" source = "/etc/postfix/main.cf"
destination = "/etc/postfix/main.cf.HERMES">

<!--- Copy main.cf.HERMES template --->
<cffile action = "copy" source = "/opt/hermes/conf_files/main.cf.HERMES"
destination = "/etc/postfix/main.cf">

<!--- Change ownership of main.cf to root:root --->
<cftry>
<cfexecute name="/usr/local/bin/docker"
arguments="exec hermes_postfix_dkim chown root:root /etc/postfix/main.cf"
timeout="10" />

<cfcatch type="any">
<cfset m="Generate Postfix Configuration: There was an error changing ownership of /etc/postfix/main.cf. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfcatch>
</cftry>

<!--- ============================================== --->
<!--- SMTP SNI CONFIGURATION - BEFORE MAIN LOOP --->
<!--- Check for validated certificates and enable/disable tls_server_sni_maps parameter --->
<!--- This must run BEFORE the main loop so the parameter gets picked up --->
<!--- ============================================== --->

<!--- Check for validated certificates in mailbox_sans (same source as Nginx SNI) --->
<cfquery name="getValidatedCertCount" datasource="hermes">
    SELECT COUNT(DISTINCT certificate) as cnt
    FROM mailbox_sans
    WHERE mailbox_domain = '1' AND DNS = 'YES'
</cfquery>

<cfif getValidatedCertCount.cnt GT 0>
    <!--- Validated certificates exist - generate SNI files and enable the parameter --->

    <!--- Generate SNI configuration files from validated certificates --->
    <cfinclude template="smtp_sni_generate_config.cfm">

    <!--- Enable tls_server_sni_maps parameter (both parent and child) --->
    <cfquery datasource="hermes">
        UPDATE parameters
        SET enabled = 1, applied = 2, action = 'APPLY'
        WHERE parameter = 'tls_server_sni_maps' AND child = 2 AND module = 'postfix'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters
        SET enabled = 1, applied = 2, action = 'APPLY'
        WHERE parent_name = 'tls_server_sni_maps' AND child = 1 AND module = 'postfix'
    </cfquery>
<cfelse>
    <!--- No validated certificates - disable tls_server_sni_maps parameter --->
    <cfquery datasource="hermes">
        UPDATE parameters
        SET enabled = 0, applied = 2, action = 'APPLY'
        WHERE parameter = 'tls_server_sni_maps' AND child = 2 AND module = 'postfix'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters
        SET enabled = 0, applied = 2, action = 'APPLY'
        WHERE parent_name = 'tls_server_sni_maps' AND child = 1 AND module = 'postfix'
    </cfquery>

    <!--- Clean up any existing SNI config files --->
    <cfif FileExists("/etc/postfix/sni_maps")>
        <cffile action="delete" file="/etc/postfix/sni_maps">
    </cfif>
    <cfif FileExists("/etc/postfix/sni_maps.db")>
        <cffile action="delete" file="/etc/postfix/sni_maps.db">
    </cfif>
</cfif>

<cfquery name="getparents" datasource="hermes">
  select distinct(parameter), parent_name, description, child, editable, enabled, conf_file from parameters where enabled='1' and child = '2' and module='postfix'
  </cfquery>

<!--- Create postconf script starts here --->
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_postconf.sh"
    output = ""
    addNewLine = "no">

<cfloop query="getparents">

  <cfquery name="getchildren" datasource="hermes">
  select parameter from parameters where child='1' and parent_name = '#getparents.parameter#' and enabled = '1' order by order1 asc
  </cfquery>


    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_postconf.sh"
    output = '/usr/sbin/postconf -e "#getparents.parameter# = #ValueList(getchildren.parameter,", ")#"'
    addNewLine = "yes">

    </cfloop>

<!--- Append postfix reload command --->
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_postconf.sh"
    output = "/usr/sbin/postfix reload"
    addNewLine = "yes">


<!--- CONVERT TO UNIX --->
<cftry>
<cfexecute name="/usr/bin/dos2unix"
arguments="/opt/hermes/tmp/#customtrans3#_postconf.sh"
timeout="10" />

<cfcatch type="any">

<cfset m="Generate Postfix Configuration: There was an error executing /usr/bin/dos2unix. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>

</cfcatch>
</cftry>

<!--- MAKE POSTFIX CONFIG SCRIPT EXECUTABLE --->
<cftry>

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_postconf.sh"
timeout = "60">
</cfexecute>

<cfcatch type="any">

<cfset m="Generate Postfix Configuration: There was an error making /opt/hermes/tmp/#customtrans3#_postconf.sh executable. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>

</cfcatch>
</cftry>


<!--- RUN POSTFIX CONFIG SCRIPT IN DOCKER CONTAINER --->
<cftry>

<cfexecute name = "/usr/local/bin/docker"
arguments="exec hermes_postfix_dkim /bin/bash /opt/hermes/tmp/#customtrans3#_postconf.sh"
timeout = "240">
</cfexecute>

<cfcatch type="any">

<cfset m="Generate Postfix Configuration: There was an error running /opt/hermes/tmp/#customtrans3#_postconf.sh. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>

</cfcatch>
</cftry>

<!--- Delete postconf script --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_postconf.sh")>
<cffile action = "delete"
file = "/opt/hermes/tmp/#customtrans3#_postconf.sh">
</cfif>

<!--- UPDATE PARAMETERS TABLE --->
<cfquery name="updateparams" datasource="hermes">
update parameters set applied='1', action='NONE' where applied = '2'
</cfquery>

<!--- ============================================== --->
<!--- UPDATE AMAVIS MYNETWORKS FILE --->
<!--- ============================================== --->

<!--- Get mynetworks parent parameter --->
<cfquery name="getmynetworksparent" datasource="hermes">
select parameter, parent_name, description, child, editable, enabled, conf_file from parameters where parameter = 'mynetworks' and enabled='1' and child = '2' and module='postfix'
</cfquery>

<!--- Get mynetworks child entries (networks and IPs) --->
<cfquery name="getintnetworks" datasource="hermes">
select parameter from parameters where child='1' and parent_name = 'mynetworks' and enabled = '1' order by order1 asc
</cfquery>

<!--- Write new mynetworks file --->
<cffile action = "write"
file = "/etc/amavis/mynetworks"
output = ""
addnewline="no">

<cfloop query="getintnetworks">
<cfoutput>
<cffile action = "append"
file = "/etc/amavis/mynetworks"
output = "#parameter#"
addnewline="yes">
</cfoutput>
</cfloop>

<!--- Reload amavis in hermes_mail_filter container --->
<cftry>
<cfexecute name = "/usr/local/bin/docker"
arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
timeout = "240">
</cfexecute>
<cfcatch type="any">
<cfset m="Generate Postfix Configuration: There was an error reloading amavis in hermes_mail_filter container. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfcatch>
</cftry>

