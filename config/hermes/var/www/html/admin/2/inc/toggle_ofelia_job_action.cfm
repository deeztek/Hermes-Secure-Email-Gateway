
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
TOGGLE OFELIA JOB (AJAX endpoint)
Flips the active flag on a single ofelia_jobs row and regenerates
/etc/ofelia/config.ini via the existing inc/ofelia_generate_config.cfm
(which also restarts hermes_ofelia).

Input (form):
  - job_name : full bracketed job_name as stored (e.g. [job-exec "x"])
  - new_state : '1' (enable) or '2' (disable)

Output:
  - Content-Type: application/json
  - { success, new_state, error }

Guards:
  - Rejects if job_name not in the table.
  - Rejects new_state values other than '1' or '2'.
  - No special handling for "system-critical" jobs — the UI warns the
    admin before the request fires, but the backend trusts the
    request. Admins already have direct DB access if they really want
    to disable everything.
--->

<!--- Collect the final JSON response in a variable so stray output
     from cfincluded generators (ofelia_generate_config.cfm +
     restart_ofelia.cfm) doesn't pollute the response body. We reset
     the output buffer just before emitting to guarantee the client
     sees ONLY the JSON payload. --->
<cfset responsePayload = "">

<cfif NOT StructKeyExists(form, "job_name") OR Trim(form.job_name) EQ ""
   OR NOT StructKeyExists(form, "new_state") OR (Trim(form.new_state) NEQ "1" AND Trim(form.new_state) NEQ "2")>
    <cfset responsePayload = SerializeJSON({"success": false, "error": "job_name and new_state ('1' or '2') are required"})>
<cfelse>

<cfset targetJob = Trim(form.job_name)>
<cfset newState = Trim(form.new_state)>

<cfquery name="getJob" datasource="hermes">
    SELECT job_name FROM ofelia_jobs
    WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getJob.recordcount LT 1>
    <cfset responsePayload = SerializeJSON({"success": false, "error": "Job not found: " & targetJob})>
<cfelse>

<cftry>
    <cfquery datasource="hermes">
        UPDATE ofelia_jobs
        SET active = <cfqueryparam value="#newState#" cfsqltype="cf_sql_varchar">
        WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!--- Regenerate /etc/ofelia/config.ini from the table and restart
         hermes_ofelia. Swallow any output from the generator +
         restart includes via cfsavecontent so the response body stays
         pure JSON. --->
    <cfsavecontent variable="_regenOutput">
        <cfinclude template="ofelia_generate_config.cfm">
    </cfsavecontent>

    <cfset responsePayload = SerializeJSON({"success": true, "new_state": newState})>

<cfcatch type="any">
    <!--- Best-effort rollback of the active flag if the regen failed. --->
    <cfset rollbackState = (newState EQ "1") ? "2" : "1">
    <cftry>
        <cfquery datasource="hermes">
            UPDATE ofelia_jobs
            SET active = <cfqueryparam value="#rollbackState#" cfsqltype="cf_sql_varchar">
            WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
        </cfquery>
    <cfcatch type="any"></cfcatch>
    </cftry>

    <cfset responsePayload = SerializeJSON({
        "success": false,
        "error": "Toggle saved but config regeneration failed: " & cfcatch.message,
        "detail": cfcatch.detail
    })>
</cfcatch>
</cftry>

</cfif>
</cfif>

<!--- Reset the output buffer RIGHT BEFORE emitting so any whitespace
     or transient output from the cfincluded generator is discarded. --->
<cfcontent type="application/json" reset="true"><cfoutput>#responsePayload#</cfoutput>
