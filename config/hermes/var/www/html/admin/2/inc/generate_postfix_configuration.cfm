

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
<!--- Always logged, whoever called. error.cfm only draws a box on a page;
     before this, a failure during a scheduled run left no trace at all. --->
<cflog file="hermes" type="error"
       text="generate_postfix_configuration: chown /etc/postfix/main.cf failed: #cfcatch.message#">
<cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
  <!--- Unattended caller: error.cfm would emit HTML into a JSON response and
       cfabort would end the whole run, not just this generator. Throw instead,
       so the caller's cftry records the failure and carries on. --->
  <cfthrow message="generate_postfix_configuration: chown /etc/postfix/main.cf failed: #cfcatch.message#">
<cfelse>
<cfset m="Generate Postfix Configuration: There was an error changing ownership of /etc/postfix/main.cf. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfif>
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

<!--- Try to build the map whenever the database thinks there is something to
     build. The count alone is NOT the decision: it only decides whether it is
     worth attempting.

     With nothing to build, any map still on disk is a leftover from a previous
     run and must go BEFORE the existence test below, or that test reads the
     leftover and re-enables the directive for names nothing validates. That is
     reachable whenever the last validated SAN goes away, which is exactly what
     the v260815 reconciliation does. --->
<cfif getValidatedCertCount.cnt GT 0>
    <cfinclude template="smtp_sni_generate_config.cfm">
<cfelse>
    <cfif FileExists("/etc/postfix/sni_maps")>
        <cffile action="delete" file="/etc/postfix/sni_maps">
    </cfif>
    <cfif FileExists("/etc/postfix/sni_maps.db")>
        <cffile action="delete" file="/etc/postfix/sni_maps.db">
    </cfif>
</cfif>

<!--- The directive is decided by the ARTIFACT, not by the row count.

     This used to enable tls_server_sni_maps whenever the count above was
     non-zero, while smtp_sni_generate_config.cfm only writes the map for
     certificates whose files are actually on disk, deleting it otherwise.
     When those two disagreed Postfix was pointed at a map that did not
     exist, every TLS handshake offering SNI failed, and inbound mail
     stopped. It failed CLOSED, and said so only in a log warning.
     They disagree whenever a certificate's files are gone while its SAN
     rows still read DNS = 'YES': deleted, still Pending, or imported
     without a chain so no bundle was ever produced.
     
     sni_maps.db is what Postfix actually opens, so that is what is tested,
     rather than the source file or the generator's own opinion. If postmap
     failed, the .db is absent and the directive stays off.
     
     Note the direction this errs in. Being wrong here leaves SNI disabled,
     which serves the default certificate and keeps mail flowing. The old
     behaviour was wrong in the other direction and refused mail outright. --->
<cfset sniMapUsable = FileExists("/etc/postfix/sni_maps") AND FileExists("/etc/postfix/sni_maps.db")>

<!--- Surface why the map could not be built. smtp_sni_generate_config.cfm
     records the reason and nothing ever read it, so a certificate that was
     silently skipped looked identical to one that was never configured. --->
<cfif getValidatedCertCount.cnt GT 0 AND NOT sniMapUsable>
    <cfset sniSkipReason = "no certificate files found for the validated SANs">
    <cfif IsDefined("sniSyncError") AND Len(Trim(sniSyncError))>
        <cfset sniSkipReason = sniSyncError>
    </cfif>
    <cflog file="hermes" type="warning"
           text="tls_server_sni_maps left disabled: #sniSkipReason#. Run SAN validation again once the certificate has been issued.">
</cfif>

<cfif sniMapUsable>
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
    <!--- No usable map - disable tls_server_sni_maps parameter --->
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

    <!--- Clean up any half-written SNI config files --->
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

  <!---
    Network alias expansion (#324).

    A child row with network_entry = '2' is not a literal address: its `parameter`
    holds the NAME of a network alias, and it renders as that alias's current IPv4
    ranges. Postfix never sees an alias -- the indirection is resolved here, so
    main.cf gets the same literal CIDRs it always did.

    IPv6 is excluded because the mail containers set
    net.ipv6.conf.all.disable_ipv6=1. The ranges are stored either way; this is
    where they get filtered.

    An alias that is disabled, or has not resolved yet, contributes NOTHING rather
    than injecting an empty element into the directive. That is deliberate: a
    half-rendered mynetworks is worse than a short one. The console flags an alias
    in that state so it is visible rather than silent.
  --->
  <cfquery name="getchildren" datasource="hermes">
  SELECT rendered AS parameter FROM (
    SELECT c.order1,
           CASE WHEN c.network_entry = '2'
                THEN (SELECT GROUP_CONCAT(v.cidr ORDER BY v.cidr SEPARATOR ', ')
                        FROM v_alias_ranges v
                       WHERE v.alias_name = c.parameter)
                ELSE c.parameter END AS rendered
      FROM parameters c
     WHERE c.child = '1'
       AND c.parent_name = <cfqueryparam value="#getparents.parameter#" cfsqltype="cf_sql_varchar">
       AND c.enabled = '1'
  ) x
  WHERE rendered IS NOT NULL AND rendered <> ''
  ORDER BY order1 ASC
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

<!--- Always logged, whoever called. error.cfm only draws a box on a page;
     before this, a failure during a scheduled run left no trace at all. --->
<cflog file="hermes" type="error"
       text="generate_postfix_configuration: dos2unix failed: #cfcatch.message#">
<cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
  <!--- Unattended caller: error.cfm would emit HTML into a JSON response and
       cfabort would end the whole run, not just this generator. Throw instead,
       so the caller's cftry records the failure and carries on. --->
  <cfthrow message="generate_postfix_configuration: dos2unix failed: #cfcatch.message#">
<cfelse>
<cfset m="Generate Postfix Configuration: There was an error executing /usr/bin/dos2unix. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfif>

</cfcatch>
</cftry>

<!--- MAKE POSTFIX CONFIG SCRIPT EXECUTABLE --->
<cftry>

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_postconf.sh"
timeout = "60">
</cfexecute>

<cfcatch type="any">

<!--- Always logged, whoever called. error.cfm only draws a box on a page;
     before this, a failure during a scheduled run left no trace at all. --->
<cflog file="hermes" type="error"
       text="generate_postfix_configuration: chmod of the postconf script failed: #cfcatch.message#">
<cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
  <!--- Unattended caller: error.cfm would emit HTML into a JSON response and
       cfabort would end the whole run, not just this generator. Throw instead,
       so the caller's cftry records the failure and carries on. --->
  <cfthrow message="generate_postfix_configuration: chmod of the postconf script failed: #cfcatch.message#">
<cfelse>
<cfset m="Generate Postfix Configuration: There was an error making /opt/hermes/tmp/#customtrans3#_postconf.sh executable. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfif>

</cfcatch>
</cftry>


<!--- RUN POSTFIX CONFIG SCRIPT IN DOCKER CONTAINER --->
<!--- The step that actually applies the config, and the only one in this file
     that had no error handling. A failure here threw a raw Lucee stack trace at
     the operator, left the temp script behind, and skipped the applied='1'
     commit below, so the rows stayed staged with no indication why.

     The common cause is the last line of the generated script: `postfix reload`
     exits non-zero when the Postfix daemon is not running, which the container
     can be while every postconf read still works. So nothing else in this file,
     and nothing in the verification commands an operator would reach for, shows
     the daemon is down. Only this does. --->
<cfset postconfFailed = false>
<cfset postconfFailMsg = "">
<cftry>
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim /bin/bash /opt/hermes/tmp/#customtrans3#_postconf.sh"
    timeout="240"
    variable="postconfOutput"
    errorVariable="postconfError" />
  <cfcatch type="any">
    <cfset postconfFailed = true>
    <cfset postconfFailMsg = cfcatch.message & " | " & cfcatch.detail>
  </cfcatch>
</cftry>

<!--- Delete postconf script. Outside the try so it happens either way; before
     this it was skipped on failure and the file accumulated in /opt/hermes/tmp. --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_postconf.sh")>
<cffile action = "delete"
file = "/opt/hermes/tmp/#customtrans3#_postconf.sh">
</cfif>

<cfif postconfFailed>
  <cflog file="hermes" type="error"
         text="generate_postfix_configuration: applying main.cf failed: #postconfFailMsg#">
  <cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
    <cfthrow message="generate_postfix_configuration: applying main.cf failed: #postconfFailMsg#">
  <cfelse>
    <cfset m="Generate Postfix Configuration: main.cf could not be applied. Check that Postfix is running in hermes_postfix_dkim. Error was #postconfFailMsg#">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>
</cfif>

<!--- UPDATE PARAMETERS TABLE --->
<cfquery name="updateparams" datasource="hermes">
update parameters set applied='1', action='NONE' where applied = '2'
</cfquery>

<!--- ============================================== --->
<!--- REGENERATE POSTFIX mysql-*.cf FROM TEMPLATES --->
<!--- ============================================== --->
<!--- Auto-discovers all mysql-*.HERMES templates in /opt/hermes/conf_files/
     and generates the corresponding mysql-*.cf files in /etc/postfix/ with
     database credentials injected from /opt/hermes/creds/ files. --->
<cftry>
    <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="hermesDbUser" charset="utf-8">
    <cffile action="read" file="/opt/hermes/creds/hermes_password" variable="hermesDbPass" charset="utf-8">
    <cfset hermesDbUser = trim(hermesDbUser)>
    <cfset hermesDbPass = trim(hermesDbPass)>

    <cfdirectory action="list" directory="/opt/hermes/conf_files" filter="mysql-*.HERMES" name="postfixMysqlTemplates" type="file">

    <cfloop query="postfixMysqlTemplates">
        <cftry>
            <cfset tplPath = "/opt/hermes/conf_files/" & postfixMysqlTemplates.name>
            <cfset outName = ReplaceNoCase(postfixMysqlTemplates.name, ".HERMES", ".cf")>
            <cfset outPath = "/etc/postfix/" & outName>

            <cffile action="read" file="#tplPath#" variable="tplContent" charset="utf-8">
            <cfset tplContent = ReplaceNoCase(tplContent, "HERMES-USERNAME", hermesDbUser, "ALL")>
            <cfset tplContent = ReplaceNoCase(tplContent, "HERMES-PASSWORD", hermesDbPass, "ALL")>

            <cfscript>fileWrite(outPath, tplContent, "utf-8");</cfscript>
        <cfcatch type="any">
            <!--- Non-fatal: continue with other templates --->
        </cfcatch>
        </cftry>
    </cfloop>
<cfcatch type="any">
    <!--- Non-fatal: Postfix main.cf was already applied above --->
</cfcatch>
</cftry>

<!--- ============================================== --->
<!--- REGENERATE CIPHERMAIL HIBERNATE XML FROM TEMPLATES --->
<!--- ============================================== --->
<!--- Auto-discovers hibernate.mysql.*.HERMES templates and generates
     the corresponding XML files with Ciphermail DB credentials. --->
<cftry>
    <cffile action="read" file="/opt/hermes/creds/ciphermail_username" variable="ciphermailDbUser" charset="utf-8">
    <cffile action="read" file="/opt/hermes/creds/ciphermail_password" variable="ciphermailDbPass" charset="utf-8">
    <cfset ciphermailDbUser = trim(ciphermailDbUser)>
    <cfset ciphermailDbPass = trim(ciphermailDbPass)>

    <cfdirectory action="list" directory="/opt/hermes/conf_files" filter="hibernate.mysql.*.HERMES" name="ciphermailTemplates" type="file">

    <cfloop query="ciphermailTemplates">
        <cftry>
            <cfset tplPath = "/opt/hermes/conf_files/" & ciphermailTemplates.name>
            <cfset outName = ReplaceNoCase(ciphermailTemplates.name, ".HERMES", ".xml")>
            <cfset outPath = "/usr/share/djigzo/conf/database/" & outName>

            <cffile action="read" file="#tplPath#" variable="tplContent" charset="utf-8">
            <cfset tplContent = ReplaceNoCase(tplContent, "DJIGZO-USERNAME", ciphermailDbUser, "ALL")>
            <cfset tplContent = ReplaceNoCase(tplContent, "DJIGZO-PASSWORD", ciphermailDbPass, "ALL")>

            <cfscript>fileWrite(outPath, tplContent, "utf-8");</cfscript>
        <cfcatch type="any">
            <!--- Non-fatal: continue with other templates --->
        </cfcatch>
        </cftry>
    </cfloop>
<cfcatch type="any">
    <!--- Non-fatal: ciphermail creds files may not exist on fresh install --->
</cfcatch>
</cftry>

<!--- ============================================== --->
<!--- UPDATE AMAVIS MYNETWORKS FILE --->
<!--- ============================================== --->

<!--- Get mynetworks parent parameter --->
<cfquery name="getmynetworksparent" datasource="hermes">
select parameter, parent_name, description, child, editable, enabled, conf_file from parameters where parameter = 'mynetworks' and enabled='1' and child = '2' and module='postfix'
</cfquery>

<!--- Get mynetworks child entries (networks and IPs) --->
<!--- Same alias expansion as the postconf path above (#324). Amavis reads one
     network per line, so an alias contributing several ranges is split below. --->
<cfquery name="getintnetworks" datasource="hermes">
  SELECT rendered AS parameter FROM (
    SELECT c.order1,
           CASE WHEN c.network_entry = '2'
                THEN (SELECT GROUP_CONCAT(v.cidr ORDER BY v.cidr SEPARATOR ', ')
                        FROM v_alias_ranges v
                       WHERE v.alias_name = c.parameter)
                ELSE c.parameter END AS rendered
      FROM parameters c
     WHERE c.child = '1' AND c.parent_name = 'mynetworks' AND c.enabled = '1'
  ) x
  WHERE rendered IS NOT NULL AND rendered <> ''
  ORDER BY order1 ASC
</cfquery>

<!--- Write new mynetworks file --->
<cffile action = "write"
file = "/etc/amavis/mynetworks"
output = ""
addnewline="no">

<!--- One network per line. A literal row contributes one entry; an expanded alias
     contributes several as a comma list, so split rather than writing a comma-joined
     line that amavis would not parse. --->
<cfloop query="getintnetworks">
<cfloop list="#getintnetworks.parameter#" index="oneNetwork" delimiters=",">
<cfoutput>
<cffile action = "append"
file = "/etc/amavis/mynetworks"
output = "#Trim(oneNetwork)#"
addnewline="yes">
</cfoutput>
</cfloop>
</cfloop>

<!--- Reload amavis in hermes_mail_filter container --->
<cftry>
<cfexecute name = "/usr/local/bin/docker"
arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
timeout = "240">
</cfexecute>
<cfcatch type="any">
<!--- Always logged, whoever called. error.cfm only draws a box on a page;
     before this, a failure during a scheduled run left no trace at all. --->
<cflog file="hermes" type="error"
       text="generate_postfix_configuration: amavis force-reload failed: #cfcatch.message#">
<cfif StructKeyExists(request, "generateQuiet") AND request.generateQuiet>
  <!--- Unattended caller: error.cfm would emit HTML into a JSON response and
       cfabort would end the whole run, not just this generator. Throw instead,
       so the caller's cftry records the failure and carries on. --->
  <cfthrow message="generate_postfix_configuration: amavis force-reload failed: #cfcatch.message#">
<cfelse>
<cfset m="Generate Postfix Configuration: There was an error reloading amavis in hermes_mail_filter container. Error was #cfcatch.message#">
<cfinclude template="error.cfm">
<cfabort>
</cfif>
</cfcatch>
</cftry>

<!--- main.cf and /etc/amavis/mynetworks now reflect whatever the aliases
     currently mean, so Relay Networks is caught up. --->
<cfset aliasStampConsumer = "Relay Networks">
<cfinclude template="alias_stamp_applied.cfm">
