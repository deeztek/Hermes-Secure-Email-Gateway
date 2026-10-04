<cfsetting enablecfoutputonly="true" showdebugoutput="false">
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
REGENERATE THE OFELIA SCHEDULE ON DEMAND (#343)

Ofelia reads /etc/ofelia/config.ini, which is rendered from the ofelia_jobs
table. Changing that table does nothing until the render runs, and until now
the only ways to trigger it from the console were side effects of unrelated
work: toggling a job off and on again, or saving SPF, DMARC, ACME or malware
feed settings. Outside the console it meant

    docker exec hermes_commandbox curl -s \
        http://localhost:8888/schedule/regen_ofelia_config.cfm

which is not something an administrator should need a shell for. Saving Email
Server Settings does NOT do it; that regenerates Dovecot.

Same generator the toggle uses, so there is one render path rather than two.
Output from the generator and the restart is captured so it cannot pollute the
JSON body, the same reason the toggle does it.
--->

<cfset responsePayload = "">

<cftry>
    <cfsavecontent variable="regenNoise">
        <cfinclude template="ofelia_generate_config.cfm">
    </cfsavecontent>

    <cfquery name="countJobs" datasource="hermes">
        SELECT COUNT(*) AS n FROM ofelia_jobs WHERE active = '1'
    </cfquery>

    <cfset responsePayload = SerializeJSON({
        "success": true,
        "jobs": Val(countJobs.n)
    })>

<cfcatch type="any">
    <cfset responsePayload = SerializeJSON({
        "success": false,
        "error": cfcatch.message
    })>
</cfcatch>
</cftry>

<cfcontent type="application/json" reset="true"><cfoutput>#responsePayload#</cfoutput>
