
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
  - job_name : name of the job to run (must match an ofelia_jobs.name)

Output:
  - Content-Type: application/json
  - { success, duration_ms, exit_code, output_summary, error }

Execution strategy:
  - Look up the job row in ofelia_jobs (DB is source of truth).
  - If the command is `/usr/bin/curl --silent http://localhost:8888/...`
    (the common pattern for calling a CFML endpoint), we issue a direct
    <cfhttp> — faster and captures the response body for the modal.
  - Otherwise, we <cfexecute> the command. Since Ofelia invokes
    `docker exec hermes_commandbox <command>` and we ARE inside
    hermes_commandbox, executing the command directly is equivalent.
  - 300s ceiling for the manual-trigger path; Ofelia's scheduled run
    has no such cap.

Every invocation appends a row to scheduled_job_runs, including failures.
Disabled jobs are allowed — admins sometimes want to run a disabled job
once without turning it on.
--->

<cfcontent type="application/json" reset="true">

<cfif NOT StructKeyExists(form, "job_name") OR Trim(form.job_name) EQ "">
    <cfoutput>#SerializeJSON({"success": false, "error": "job_name required"})#</cfoutput>
    <cfabort>
</cfif>

<cfset targetJob = Trim(form.job_name)>

<cfquery name="getJob" datasource="hermes">
    SELECT name, command
    FROM ofelia_jobs
    WHERE name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getJob.recordcount LT 1>
    <cfoutput>#SerializeJSON({"success": false, "error": "Job not found: " & targetJob})#</cfoutput>
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
    <!--- Detect the common curl-localhost pattern: convert to cfhttp. --->
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
    <cfelse>
        <!--- Shell command: invoke directly. First word is the binary; rest is args. --->
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
        <cfset runExitCode = "0">
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
