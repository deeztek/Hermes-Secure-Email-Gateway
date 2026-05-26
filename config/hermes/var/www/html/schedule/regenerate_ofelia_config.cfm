<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
Regenerate /etc/ofelia/config.ini from the ofelia_jobs DB table (#218).

The DB is the source of truth for Ofelia jobs. The static
config/ofelia/config.ini in the repo is a bootstrap snapshot; this
file rebuilds it from current DB state. Called by:

  1. install_hermes_docker.sh --apply-schema (after any schema migration)
  2. The admin UI's Scheduled Tasks page (which has its own regen path
     under /admin/2/inc/ofelia_generate_config.cfm -- this /schedule/
     entry point exists for non-UI callers)

Self-contained: no admin-scope dependencies (no session, no
generate_customtrans, no error.cfm). Uses a timestamp+random temp
filename instead of session.customtrans for uniqueness.

Does NOT restart Ofelia -- caller is responsible for `docker restart
hermes_ofelia` after a successful regen so the new config is picked up.
--->

<cfquery name="getofeliajobs" datasource="hermes">
    SELECT job_name, schedule, command, container, active, no_overlap
    FROM ofelia_jobs WHERE active = '1'
</cfquery>

<cfif getofeliajobs.recordcount EQ 0>
    <cfsetting enablecfoutputonly="yes">
    <cfoutput>SKIP: no active ofelia_jobs rows</cfoutput>
    <cfabort>
</cfif>

<!--- Unique temp filename (no session.customtrans available here) --->
<cfset tempId     = "regenofelia_" & DateFormat(now(), "yyyymmdd") & "_" & TimeFormat(now(), "HHmmss") & "_" & RandRange(1000, 9999)>
<cfset tempJobs   = "/opt/hermes/tmp/" & tempId & "_jobs">
<cfset tempConfig = "/opt/hermes/tmp/" & tempId & "_config.ini">

<!--- Build the [job-exec ...] blocks --->
<cffile action="write" file="#tempJobs#" output="" addnewline="no">

<cfloop query="getofeliajobs">
    <cfset jobBlock = job_name & chr(10) & "schedule = " & schedule & chr(10) & "container = " & container & chr(10) & "command = " & command>
    <cfif no_overlap EQ 1>
        <cfset jobBlock = jobBlock & chr(10) & "no-overlap = true">
    </cfif>
    <cffile action="append"
        file="#tempJobs#"
        output="#jobBlock##chr(10)##chr(10)#"
        addnewline="no">
</cfloop>

<!--- Normalize line endings (template + DB content may mix CRLF/LF) --->
<cftry>
    <cfexecute name="/usr/bin/dos2unix" arguments="#tempJobs#" timeout="30" />
    <cfcatch type="any">
        <cflog file="ofelia_regen" type="error" text="dos2unix failure: #cfcatch.detail#">
    </cfcatch>
</cftry>

<cffile action="read" file="#tempJobs#" variable="ofeliajobs">

<!--- Read POSTMASTER_EMAIL + ADMIN_EMAIL for template substitution --->
<cfquery name="getpostmaster" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'postmaster'
</cfquery>
<cfquery name="getadmin" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'admin_email'
</cfquery>

<cfset postmaster = (getpostmaster.recordcount EQ 1) ? getpostmaster.value : "">
<cfset adminEmail = (getadmin.recordcount       EQ 1) ? getadmin.value       : "">

<!--- Substitute placeholders in the template --->
<cffile action="read" file="/opt/hermes/conf_files/ofelia_config.ini" variable="ofeliaconfig">
<cfset ofeliaconfig = REReplace(ofeliaconfig, "POSTMASTER_EMAIL",   postmaster, "ALL")>
<cfset ofeliaconfig = REReplace(ofeliaconfig, "ADMIN_EMAIL",        adminEmail, "ALL")>
<cfset ofeliaconfig = REReplace(ofeliaconfig, "OFELIA_JOBS_GO_HERE", ofeliajobs, "ALL")>

<!--- Write to temp, then atomic move to live location --->
<cffile action="write" file="#tempConfig#" output="#ofeliaconfig#" addnewline="no">
<cffile action="move"  source="#tempConfig#" destination="/etc/ofelia/config.ini">

<!--- Cleanup --->
<cfif fileExists(tempJobs)>
    <cffile action="delete" file="#tempJobs#">
</cfif>

<cfsetting enablecfoutputonly="yes">
<cfoutput>OK: regenerated /etc/ofelia/config.ini (#getofeliajobs.recordcount# active jobs)</cfoutput>
