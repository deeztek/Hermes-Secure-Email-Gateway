<!--- intrusion_prevention_get_status.cfm --->
<!--- Query fail2ban for live status via docker exec --->

<cfset f2bRunning = false>
<cfset f2bError = "">
<cfset jailList = []>
<cfset jailStatuses = {}>

<cftry>
    <!--- Check if fail2ban is running --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_fail2ban fail2ban-client ping"
        variable="pingResult"
        errorVariable="pingError"
        timeout="10">
    </cfexecute>

    <cfif FindNoCase("pong", pingResult)>
        <cfset f2bRunning = true>
    </cfif>

<cfcatch type="any">
    <cfset f2bError = "Failed to connect to fail2ban: #cfcatch.message#">
</cfcatch>
</cftry>

<cfif f2bRunning>
    <cftry>
        <!--- Get overall fail2ban status --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_fail2ban fail2ban-client status"
            variable="f2bStatus"
            errorVariable="f2bStatusError"
            timeout="15">
        </cfexecute>

        <!--- Parse jail list from output --->
        <cfset statusLines = listToArray(f2bStatus, chr(10))>
        <cfloop array="#statusLines#" index="line">
            <cfif FindNoCase("Jail list:", line)>
                <cfset jailPart = trim(listLast(line, ":"))>
                <cfif len(jailPart)>
                    <cfset jailList = listToArray(jailPart, ",")>
                    <!--- Trim whitespace from each jail name --->
                    <cfloop from="1" to="#arrayLen(jailList)#" index="i">
                        <cfset jailList[i] = trim(jailList[i])>
                    </cfloop>
                </cfif>
            </cfif>
        </cfloop>

        <!--- Get status for each jail --->
        <cfloop array="#jailList#" index="jailName">
            <cfset jailName = trim(jailName)>
            <cftry>
                <cfexecute name="/usr/local/bin/docker"
                    arguments="exec hermes_fail2ban fail2ban-client status #jailName#"
                    variable="jailStatus"
                    errorVariable="jailError"
                    timeout="15">
                </cfexecute>

                <!--- Parse jail status --->
                <cfset bannedCount = 0>
                <cfset bannedIPs = []>
                <cfset totalFailed = 0>
                <cfset totalBanned = 0>

                <cfloop list="#jailStatus#" delimiters="#chr(10)#" index="line">
                    <cfif FindNoCase("Currently banned:", line)>
                        <cfset bannedCount = val(trim(listLast(line, ":")))>
                    <cfelseif FindNoCase("Banned IP list:", line)>
                        <cfset ipList = trim(listLast(line, ":"))>
                        <cfif len(ipList)>
                            <cfset bannedIPs = listToArray(ipList, " ")>
                        </cfif>
                    <cfelseif FindNoCase("Currently failed:", line)>
                        <cfset totalFailed = val(trim(listLast(line, ":")))>
                    <cfelseif FindNoCase("Total banned:", line)>
                        <cfset totalBanned = val(trim(listLast(line, ":")))>
                    </cfif>
                </cfloop>

                <cfset jailStatuses[jailName] = {
                    "bannedCount": bannedCount,
                    "bannedIPs": bannedIPs,
                    "totalFailed": totalFailed,
                    "totalBanned": totalBanned,
                    "rawStatus": jailStatus,
                    "error": ""
                }>

            <cfcatch type="any">
                <cfset jailStatuses[jailName] = {
                    "bannedCount": 0,
                    "bannedIPs": [],
                    "totalFailed": 0,
                    "totalBanned": 0,
                    "rawStatus": "",
                    "error": cfcatch.message
                }>
            </cfcatch>
            </cftry>
        </cfloop>

    <cfcatch type="any">
        <cfset f2bError = "Failed to get fail2ban status: #cfcatch.message#">
    </cfcatch>
    </cftry>
</cfif>

<!--- Calculate totals --->
<cfset totalBannedIPs = 0>
<cfset activeJailCount = arrayLen(jailList)>
<cfloop collection="#jailStatuses#" item="jn">
    <cfset totalBannedIPs = totalBannedIPs + jailStatuses[jn].bannedCount>
</cfloop>
