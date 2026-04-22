
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
GENERATE OFELIA CONFIGURATION
Renders /etc/ofelia/config.ini from the ofelia_jobs table (the
authoritative source of truth for scheduled jobs) and restarts
hermes_ofelia so the new config takes effect.

Flow:
  1. Read the global [global] settings from system_settings / parameters2
     (postmaster, etc. — kept as-is from the bootstrap file for now).
  2. SELECT every row from ofelia_jobs.
  3. Emit one [job-exec "name"] block per row. Enabled=0 rows are
     written as commented-out blocks so admins can see them in the
     file but Ofelia skips them.
  4. Write to a temp file, move into place, restart hermes_ofelia.
  5. UPDATE ofelia_jobs.config_synced = 1 for every row (clears any
     pending-change indicator).

Failure modes are non-fatal from the caller's perspective — caller
should check `ofeliaGenerateResult` for "success" / "error".
--->

<cfset ofeliaGenerateResult = "skipped">
<cfset ofeliaGenerateError = "">

<cftry>

    <cfinclude template="generate_customtrans.cfm">

    <!--- Global block. The smtp-host / email-to / email-from values
         come from existing system settings so admins don't have to
         manage two places. Defaults shipped with the bootstrap
         config.ini if settings are missing. --->
    <cfquery name="getPostmaster" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'postmaster'
    </cfquery>
    <cfset postmasterAddr = (getPostmaster.recordcount GTE 1 AND Len(Trim(getPostmaster.value)) GT 0)
        ? Trim(getPostmaster.value)
        : "postmaster@localhost">

    <cfquery name="qAllJobs" datasource="hermes">
        SELECT name, schedule, container, command, no_overlap, enabled, description
        FROM ofelia_jobs
        ORDER BY name ASC
    </cfquery>

    <!--- Build file content --->
    <cfsavecontent variable="ofeliaConfig"><cfoutput>[global]
smtp-host = hermes_postfix_dkim
smtp-port = 10026
email-to = #postmasterAddr#
email-from = #postmasterAddr#
mail-only-on-error = true

<cfloop query="qAllJobs">
<cfset prefix = (qAllJobs.enabled EQ 1) ? "" : "##">
<cfif Len(Trim(qAllJobs.description)) GT 0>#prefix## #qAllJobs.description#
</cfif>#prefix#[job-exec "#qAllJobs.name#"]
#prefix#schedule = #qAllJobs.schedule#
#prefix#container = #qAllJobs.container#
<cfif qAllJobs.no_overlap EQ 1>#prefix#no-overlap = true
</cfif>#prefix#command = #qAllJobs.command#

</cfloop></cfoutput></cfsavecontent>

    <!--- Write to temp, then atomically replace --->
    <cfset ofeliaTmpPath = "/opt/hermes/tmp/" & customtrans3 & "_ofelia_config.ini">
    <cffile action="write" file="#ofeliaTmpPath#" output="#ofeliaConfig#" charset="utf-8">

    <cffile action="copy"
        source="#ofeliaTmpPath#"
        destination="/etc/ofelia/config.ini">

    <cftry><cffile action="delete" file="#ofeliaTmpPath#"><cfcatch type="any"></cfcatch></cftry>

    <!--- Restart hermes_ofelia so it rereads the config. Ofelia picks
         up schedule/command changes only at container start. --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="container restart hermes_ofelia"
        variable="restartResult"
        errorVariable="restartError"
        timeout="30" />

    <!--- Mark everything as synced now that the file on disk matches
         the DB and the daemon has been bounced. --->
    <cfquery datasource="hermes">
        UPDATE ofelia_jobs SET config_synced = 1
    </cfquery>

    <cfset ofeliaGenerateResult = "success">

<cfcatch type="any">
    <cfset ofeliaGenerateResult = "error">
    <cfset ofeliaGenerateError = cfcatch.message & " / " & cfcatch.detail>
</cfcatch>
</cftry>
