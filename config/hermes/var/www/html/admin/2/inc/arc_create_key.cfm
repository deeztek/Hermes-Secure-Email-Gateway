<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Generate a new ARC signing key for the domain in `getdomain.domain`.
      Mirrors dkim_create_key.cfm but:
        - Uses generate_arc.sh template (placeholders: THE-KEY, THE-SELECTOR, THE-DOMAIN)
        - Writes key files to /opt/hermes/arc/keys/<sel>_<dom>.arc.{private,txt}
        - Inserts into arc_sign table
        - chowns to openarc:openarc inside hermes_openarc container --->

<cfinclude template="generate_customtrans.cfm">

<!--- Read the generate_arc.sh template and substitute values --->
<cffile action="read" file="/opt/hermes/scripts/generate_arc.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_arc.sh"
    output="#REReplace(temp, 'THE-KEY', form.arckey, 'ALL')#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_arc.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_arc.sh"
    output="#REReplace(temp, 'THE-DOMAIN', getdomain.domain, 'ALL')#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_arc.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_arc.sh"
    output="#REReplace(temp, 'THE-SELECTOR', form.selector, 'ALL')#" addnewline="no">

<!--- CHMOD the script via Docker. Capture stdout/stderr separately so the
     error path can show WHAT actually failed (container not running,
     binary missing, file not visible in container, etc.) instead of just
     "there was an error". --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /bin/chmod +x /opt/hermes/tmp/#customtrans3#_generate_arc.sh"
        timeout="60"
        variable="chmodOut"
        errorVariable="chmodErr">
    </cfexecute>
    <cfcatch type="any">
        <cfset m = "/inc/arc_create_key.cfm: chmod failed. " &
                   "command: docker exec hermes_openarc /bin/chmod +x /opt/hermes/tmp/" & customtrans3 & "_generate_arc.sh. " &
                   "cfcatch.message: " & cfcatch.message & ". " &
                   "cfcatch.detail: " & (StructKeyExists(cfcatch, "detail") ? cfcatch.detail : "n/a")>
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>
<!--- Even on success, errorVariable may capture stderr (e.g. "container is
     not running"). Treat any non-empty stderr as a failure. --->
<cfif IsDefined("chmodErr") AND len(trim(chmodErr)) GT 0>
    <cfset m = "/inc/arc_create_key.cfm: chmod returned stderr: " & chmodErr & ". " &
               "stdout: " & (IsDefined("chmodOut") ? chmodOut : "(none)")>
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- Execute the script via Docker (runs openarc-keygen in the openarc container) --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_openarc /opt/hermes/tmp/#customtrans3#_generate_arc.sh"
        timeout="240"
        variable="keygenOut"
        errorVariable="keygenErr">
    </cfexecute>
    <cfcatch type="any">
        <cfset m = "/inc/arc_create_key.cfm: openarc-keygen failed. " &
                   "cfcatch.message: " & cfcatch.message & ". " &
                   "cfcatch.detail: " & (StructKeyExists(cfcatch, "detail") ? cfcatch.detail : "n/a")>
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>
<cfif IsDefined("keygenErr") AND len(trim(keygenErr)) GT 0>
    <cfset m = "/inc/arc_create_key.cfm: keygen stderr: " & keygenErr & ". " &
               "stdout: " & (IsDefined("keygenOut") ? keygenOut : "(none)")>
    <cfinclude template="error.cfm">
    <cfabort>
</cfif>

<!--- Delete the temp script --->
<cfset FiletoDelete = "/opt/hermes/tmp/#customtrans3#_generate_arc.sh">
<cfif fileExists(FiletoDelete)>
    <cffile action="delete" file="#FiletoDelete#">
</cfif>

<!--- CHECK KEY FILES EXIST --->
<cfset PrivateFile = "/opt/hermes/arc/keys/#form.selector#_#getdomain.domain#.arc.private">
<cfset PublicFile = "/opt/hermes/arc/keys/#form.selector#_#getdomain.domain#.arc.txt">

<cfif fileExists(PrivateFile) AND fileExists(PublicFile)>

    <cfquery name="insertkey" datasource="hermes">
        INSERT INTO arc_sign (domain, applied, public, private, enabled, generated, selector)
        VALUES ('#getdomain.domain#', '1', '#form.selector#_#getdomain.domain#.arc.txt', '#form.selector#_#getdomain.domain#.arc.private', '2', '1', '#form.selector#')
    </cfquery>

    <!--- SET OWNERSHIP OF NEWLY CREATED ARC KEY FILES --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_openarc /bin/chown openarc:openarc #PrivateFile# #PublicFile#"
            timeout="60">
        </cfexecute>
        <cfcatch type="any">
            <cfset m="/inc/arc_create_key.cfm: There was an error setting ownership on ARC key files">
            <cfinclude template="error.cfm">
            <cfabort>
        </cfcatch>
    </cftry>

<cfelse>

    <cfset m="/inc/arc_create_key.cfm: PublicFile and/or PrivateFile does not exist">
    <cfinclude template="error.cfm">
    <cfabort>

</cfif>
