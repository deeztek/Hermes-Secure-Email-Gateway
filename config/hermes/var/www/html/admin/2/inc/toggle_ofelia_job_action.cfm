
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

<cfcontent type="application/json" reset="true">

<cfif NOT StructKeyExists(form, "job_name") OR Trim(form.job_name) EQ ""
   OR NOT StructKeyExists(form, "new_state") OR (Trim(form.new_state) NEQ "1" AND Trim(form.new_state) NEQ "2")>
    <cfoutput>#SerializeJSON({"success": false, "error": "job_name and new_state ('1' or '2') are required"})#</cfoutput>
    <cfabort>
</cfif>

<cfset targetJob = Trim(form.job_name)>
<cfset newState = Trim(form.new_state)>

<cfquery name="getJob" datasource="hermes">
    SELECT job_name FROM ofelia_jobs
    WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getJob.recordcount LT 1>
    <cfoutput>#SerializeJSON({"success": false, "error": "Job not found: " & targetJob})#</cfoutput>
    <cfabort>
</cfif>

<cftry>
    <cfquery datasource="hermes">
        UPDATE ofelia_jobs
        SET active = <cfqueryparam value="#newState#" cfsqltype="cf_sql_varchar">
        WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!--- Regenerate /etc/ofelia/config.ini from the table and restart
         hermes_ofelia. The existing include handles both. --->
    <cfinclude template="ofelia_generate_config.cfm">

    <cfoutput>#SerializeJSON({"success": true, "new_state": newState})#</cfoutput>

<cfcatch type="any">
    <!--- Best-effort rollback of the active flag if the regen failed.
         If this too fails, the DB and config.ini are out of sync;
         the admin can re-toggle to resync. --->
    <cfset rollbackState = (newState EQ "1") ? "2" : "1">
    <cftry>
        <cfquery datasource="hermes">
            UPDATE ofelia_jobs
            SET active = <cfqueryparam value="#rollbackState#" cfsqltype="cf_sql_varchar">
            WHERE job_name = <cfqueryparam value="#targetJob#" cfsqltype="cf_sql_varchar">
        </cfquery>
    <cfcatch type="any"></cfcatch>
    </cftry>

    <cfoutput>#SerializeJSON({
        "success": false,
        "error": "Toggle saved but config regeneration failed: " & cfcatch.message,
        "detail": cfcatch.detail
    })#</cfoutput>
</cfcatch>
</cftry>
