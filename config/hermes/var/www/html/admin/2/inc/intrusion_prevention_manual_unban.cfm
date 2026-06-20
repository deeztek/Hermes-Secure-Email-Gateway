<!--- intrusion_prevention_manual_unban.cfm --->
<!--- Manual unban IP(s) via fail2ban-client (removes iptables rule) and database --->
<!--- Expects: form.unban_ips (comma-separated list of "ip|jail" pairs) --->

<cfset manualUnbanSuccess = false>
<cfset manualUnbanError = "">
<cfset unbannedCount = 0>
<cfset failedUnbans = []>

<cfif StructKeyExists(form, "unban_ips") AND len(trim(form.unban_ips))>

    <!--- Get IP validation pattern --->
    <cfinclude template="validate_ip_address.cfm">

    <!--- Process each IP|jail pair --->
    <cfloop list="#form.unban_ips#" index="ipJailPair">
        <cfset ipJailPair = trim(ipJailPair)>

        <!--- Parse IP and jail from "ip|jail" format --->
        <cfif listLen(ipJailPair, "|") GTE 2>
            <cfset ipToUnban = trim(listFirst(ipJailPair, "|"))>
            <cfset jailToUnban = trim(listLast(ipJailPair, "|"))>
        <cfelse>
            <!--- Fallback for old format (IP only) - unban from all jails --->
            <cfset ipToUnban = ipJailPair>
            <cfset jailToUnban = "">
        </cfif>

        <cfif REFind(pattern, ipToUnban) GT 0>

            <cftry>
                <cfif len(jailToUnban)>
                    <!--- Unban from specific jail only --->
                    <cftry>
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec hermes_fail2ban fail2ban-client set #jailToUnban# unbanip #ipToUnban#"
                            variable="unbanResult"
                            errorVariable="unbanError"
                            timeout="30">
                        </cfexecute>
                    <cfcatch type="any">
                        <!--- Ignore errors - IP may already be unbanned --->
                    </cfcatch>
                    </cftry>

                    <!--- Remove entry for this IP+jail from database --->
                    <cfquery name="deleteIP" datasource="hermes">
                        DELETE FROM fail2ban_ips
                        WHERE ip = <cfqueryparam value="#ipToUnban#" cfsqltype="cf_sql_varchar">
                        AND jail = <cfqueryparam value="#jailToUnban#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                <cfelse>
                    <!--- No jail specified - unban from all jails (legacy behavior) --->
                    <cfquery name="getJails" datasource="hermes">
                        SELECT jail_name FROM intrusion_prevention_jails WHERE enabled = 1
                    </cfquery>

                    <cfloop query="getJails">
                        <cftry>
                            <cfexecute name="/usr/local/bin/docker"
                                arguments="exec hermes_fail2ban fail2ban-client set #getJails.jail_name# unbanip #ipToUnban#"
                                variable="unbanResult"
                                errorVariable="unbanError"
                                timeout="30">
                            </cfexecute>
                        <cfcatch type="any">
                            <!--- Ignore errors - IP may not be banned in this jail --->
                        </cfcatch>
                        </cftry>
                    </cfloop>

                    <!--- Remove ALL entries for this IP from database --->
                    <cfquery name="deleteIP" datasource="hermes">
                        DELETE FROM fail2ban_ips
                        WHERE ip = <cfqueryparam value="#ipToUnban#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                </cfif>

                <cfset unbannedCount = unbannedCount + 1>

            <cfcatch type="any">
                <cfset arrayAppend(failedUnbans, "#ipToUnban# (Error: #cfcatch.message#)")>
            </cfcatch>
            </cftry>

        <cfelse>
            <cfset arrayAppend(failedUnbans, ipToUnban)>
        </cfif>
    </cfloop>

    <cfif unbannedCount GT 0>
        <cfset manualUnbanSuccess = true>
    </cfif>

    <cfif arrayLen(failedUnbans) GT 0>
        <cfset manualUnbanError = "Failed to unban: #arrayToList(failedUnbans, ', ')#">
    </cfif>

<cfelse>
    <cfset manualUnbanError = "No IP addresses specified">
</cfif>
