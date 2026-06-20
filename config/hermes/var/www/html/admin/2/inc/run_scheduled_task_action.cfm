
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
RUN SCHEDULED TASK (AJAX endpoint)
Executes an Ofelia job on demand. Called via POST from
view_scheduled_tasks.cfm's "Run Now" buttons.

Input (form):
  - job_name : full bracketed job_name as stored in ofelia_jobs
              (e.g. [job-exec "hermes-quarantine-notify"])

Output:
  - Content-Type: application/json
  - { success, duration_ms, exit_code, output_summary, error }

Execution strategy:
  - Look up the row in ofelia_jobs by job_name (exact match).
  - If the command is /usr/bin/curl --silent http://localhost:8888/...
    we issue <cfhttp> and capture the response body for the modal.
  - Otherwise, <cfexecute> the command directly inside commandbox.
    Since Ofelia itself invokes `docker exec hermes_commandbox <command>`
    and we ARE inside hermes_commandbox, this is equivalent for most
    jobs. A handful of jobs target different containers (e.g. the DMARC
    job targets hermes_dmarc); for those we docker-exec into the right
    container explicitly.
  - 300s ceiling for the manual-trigger path; Ofelia's scheduled run
    has no such cap.

Every invocation appends a row to scheduled_job_runs including failures.
Disabled jobs (active='2') are still runnable — admins sometimes want a
one-off run without flipping the flag.
--->

<cfcontent type="application/json" reset="true">

<cfif NOT StructKeyExists(form, "job_name") OR Trim(form.job_name) EQ "">
    <cfoutput>#SerializeJSON({"success": false, "error": "job_name required"})#</cfoutput>
    <cfabort>
</cfif>

<cfset targetJob = Trim(form.job_name)>

<cfquery name="getJob" datasource="hermes">
    SELECT job_name, command, container, active
    FROM ofelia_jobs
    WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getJob.recordcount LT 1>
    <cfoutput>#SerializeJSON({"success": false, "error": "Job not found in ofelia_jobs: " & targetJob})#</cfoutput>
    <cfabort>
</cfif>

<cfif Len(Trim(getJob.command)) EQ 0>
    <cfoutput>#SerializeJSON({"success": false, "error": "Job has no command defined"})#</cfoutput>
    <cfabort>
</cfif>

<cfset startTick = getTickCount()>
<cfset runOutput = "">
<cfset runExitCode = "0">
<cfset runError = "">
<cfset runSuccess = false>

<cftry>
    <!--- Curl-to-localhost pattern: route via cfhttp for clean body capture. --->
    <cfset curlMatch = REFind("^\s*/usr/bin/curl\s+(?:--silent\s+)?(http://[^\s]+)", getJob.command, 1, true)>

    <cfif IsStruct(curlMatch) AND curlMatch.pos[1] GT 0 AND ArrayLen(curlMatch.pos) GTE 2>
        <cfset targetUrl = Mid(getJob.command, curlMatch.pos[2], curlMatch.len[2])>
        <cfhttp url="#targetUrl#" method="GET" timeout="300" throwonerror="no">
            <cfhttpparam type="header" name="User-Agent" value="Hermes-Scheduled-Tasks-RunNow">
        </cfhttp>
        <cfset runOutput = cfhttp.fileContent>
        <cfset runExitCode = cfhttp.statusCode>
        <cfif cfhttp.statusCode CONTAINS "200">
            <cfset runSuccess = true>
        <cfelse>
            <cfset runError = "HTTP " & cfhttp.statusCode>
        </cfif>
    <cfelseif Trim(getJob.container) NEQ "hermes_commandbox" AND Len(Trim(getJob.container)) GT 0>
        <!--- Target is a different container (e.g. hermes_dmarc). Proxy via
             docker exec the same way Ofelia would. --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec #Trim(getJob.container)# #Trim(getJob.command)#"
            variable="runOutput"
            errorVariable="runStderr"
            timeout="300" />
        <cfif isDefined("runStderr") AND Len(Trim(runStderr)) GT 0>
            <cfset runOutput = runOutput & chr(10) & "[STDERR] " & runStderr>
        </cfif>
        <cfset runSuccess = true>
    <cfelse>
        <!--- Shell command, targets commandbox (us). Split on first whitespace. --->
        <cfset cmdParts = REReplace(Trim(getJob.command), "\s+", " ", "ALL")>
        <cfset spaceIdx = Find(" ", cmdParts)>
        <cfif spaceIdx GT 0>
            <cfset cmdBin = Left(cmdParts, spaceIdx - 1)>
            <cfset cmdArgs = Mid(cmdParts, spaceIdx + 1, Len(cmdParts))>
        <cfelse>
            <cfset cmdBin = cmdParts>
            <cfset cmdArgs = "">
        </cfif>
        <cfexecute name="#cmdBin#"
            arguments="#cmdArgs#"
            variable="runOutput"
            errorVariable="runStderr"
            timeout="300" />
        <cfif isDefined("runStderr") AND Len(Trim(runStderr)) GT 0>
            <cfset runOutput = runOutput & chr(10) & "[STDERR] " & runStderr>
        </cfif>
        <cfset runSuccess = true>
    </cfif>

<cfcatch type="any">
    <cfset runSuccess = false>
    <cfset runError = cfcatch.message>
    <cfset runOutput = cfcatch.detail>
    <cfset runExitCode = "exception">
</cfcatch>
</cftry>

<cfset durationMs = getTickCount() - startTick>

<cfset storedOutput = Left(runOutput, 2048)>

<cfset triggeredBy = StructKeyExists(session, "adminUsername") ? session.adminUsername :
                    (StructKeyExists(session, "username") ? session.username : "unknown")>

<cftry>
    <cfquery datasource="hermes">
        INSERT INTO scheduled_job_runs (job_name, triggered_at, triggered_by, duration_ms, exit_code, output_summary)
        VALUES (
            <cfqueryparam value="#targetJob#"    cfsqltype="cf_sql_varchar">,
            NOW(),
            <cfqueryparam value="#triggeredBy#"  cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#durationMs#"   cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#runExitCode#"  cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#storedOutput#" cfsqltype="cf_sql_longvarchar">
        )
    </cfquery>
<cfcatch type="any"></cfcatch>
</cftry>

<cfset response = {
    "success": runSuccess,
    "job_name": targetJob,
    "duration_ms": durationMs,
    "exit_code": runExitCode,
    "output_summary": storedOutput,
    "error": runError
}>

<cfoutput>#SerializeJSON(response)#</cfoutput>
