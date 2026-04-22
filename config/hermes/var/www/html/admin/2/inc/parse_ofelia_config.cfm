
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
PARSE OFELIA CONFIG
Reads /etc/ofelia/config.ini (volume-mounted into hermes_commandbox)
and returns an array of job structs.

Output (set in the including scope):
  ofeliaJobs : array of struct:
    - name      : job name (from [job-exec "name"])
    - schedule  : value of the `schedule` line
    - container : value of the `container` line
    - command   : value of the `command` line
    - enabled   : boolean (false if block header is commented with #)

A block starts at `[job-exec "name"]` (optionally prefixed with `#`)
and ends at the next `[...]` header or a blank line.
--->

<cfscript>
    // Parse a single [job-exec] block (header line + content lines array)
    // into a job struct. Defined up front so it's callable below.
    function parseOfeliaBlock(headerLine, contentLines) {
        var job = {
            "name": "",
            "schedule": "",
            "container": "",
            "command": "",
            "enabled": true
        };

        var nameMatch = reFind('\[job-exec\s+"([^"]+)"', headerLine, 1, true);
        if (nameMatch.pos[1] GT 0 AND ArrayLen(nameMatch.pos) GTE 2) {
            job.name = mid(headerLine, nameMatch.pos[2], nameMatch.len[2]);
        }

        // Header commented => block disabled.
        // Note: "##" in a cfscript string literal IS a single `#` char
        // (CFML escapes `#` as `##` inside string context).
        if (left(trim(headerLine), 1) EQ "##") {
            job.enabled = false;
        }

        var i = 0;
        for (i = 1; i LTE arrayLen(contentLines); i++) {
            var line = contentLines[i];
            var t = trim(line);
            if (t EQ "") continue;

            // Strip leading # (escaped as ##) for key=value parsing
            var unc = t;
            while (left(unc, 1) EQ "##") {
                unc = trim(mid(unc, 2, len(unc)));
            }

            if (reFindNoCase("^schedule\s*=", unc) GT 0) {
                job.schedule = trim(listRest(unc, "="));
            } else if (reFindNoCase("^container\s*=", unc) GT 0) {
                job.container = trim(listRest(unc, "="));
            } else if (reFindNoCase("^command\s*=", unc) GT 0) {
                job.command = trim(listRest(unc, "="));
            }
        }

        return job;
    }
</cfscript>

<cfset ofeliaConfigPath = "/etc/ofelia/config.ini">
<cfset ofeliaJobs = []>

<cftry>
    <cffile action="read" file="#ofeliaConfigPath#" variable="ofeliaRaw" charset="utf-8">
<cfcatch type="any">
    <cfset ofeliaRaw = "">
</cfcatch>
</cftry>

<cfif Len(ofeliaRaw) GT 0>
    <cfset allLines = ListToArray(ofeliaRaw, chr(10), true)>
    <cfset currentBlock = []>
    <cfset blockHeader = "">

    <cfloop array="#allLines#" index="rawLine">
        <cfset trimmed = Trim(rawLine)>

        <cfset isJobHeader = (REFind("^##*\s*\[job-exec\s+""", trimmed) GT 0)>
        <cfset isOtherHeader = (NOT isJobHeader) AND (REFind("^##*\s*\[", trimmed) GT 0)>

        <cfif isJobHeader>
            <!--- New job header closes any previous block --->
            <cfif Len(blockHeader) GT 0>
                <cfset ArrayAppend(ofeliaJobs, parseOfeliaBlock(blockHeader, currentBlock))>
            </cfif>
            <cfset blockHeader = trimmed>
            <cfset currentBlock = []>
        <cfelseif isOtherHeader>
            <!--- Non-job header (e.g. [global]) — flush and skip --->
            <cfif Len(blockHeader) GT 0>
                <cfset ArrayAppend(ofeliaJobs, parseOfeliaBlock(blockHeader, currentBlock))>
                <cfset blockHeader = "">
                <cfset currentBlock = []>
            </cfif>
        <cfelseif Len(blockHeader) GT 0 AND Len(trimmed) EQ 0>
            <!--- Blank line ends block --->
            <cfset ArrayAppend(ofeliaJobs, parseOfeliaBlock(blockHeader, currentBlock))>
            <cfset blockHeader = "">
            <cfset currentBlock = []>
        <cfelseif Len(blockHeader) GT 0>
            <cfset ArrayAppend(currentBlock, rawLine)>
        </cfif>
    </cfloop>

    <!--- Flush trailing block --->
    <cfif Len(blockHeader) GT 0>
        <cfset ArrayAppend(ofeliaJobs, parseOfeliaBlock(blockHeader, currentBlock))>
    </cfif>
</cfif>

<!--- Drop malformed entries with no name --->
<cfset cleanJobs = []>
<cfloop array="#ofeliaJobs#" index="j">
    <cfif StructKeyExists(j, "name") AND Len(j.name) GT 0>
        <cfset ArrayAppend(cleanJobs, j)>
    </cfif>
</cfloop>
<cfset ofeliaJobs = cleanJobs>
