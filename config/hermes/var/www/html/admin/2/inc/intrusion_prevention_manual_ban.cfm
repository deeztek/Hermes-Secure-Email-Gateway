<!--- intrusion_prevention_manual_ban.cfm --->
<!--- Manual ban IP via fail2ban-client (triggers iptables blocking) and database --->
<!--- Expects: form.ban_ip, form.ban_jail (can be "ALL" for all jails) --->
<!--- Inserts one row per jail into fail2ban_ips table --->

<cfset manualBanSuccess = false>
<cfset manualBanError = "">
<cfset bannedJailCount = 0>

<cfif StructKeyExists(form, "ban_ip") AND StructKeyExists(form, "ban_jail")>

    <!--- Validate IP address --->
    <cfinclude template="validate_ip_address.cfm">

    <cfif REFind(pattern, form.ban_ip) GT 0>

        <!--- Get list of jails to ban --->
        <cfif form.ban_jail EQ "ALL">
            <!--- Get all enabled jails --->
            <cfquery name="getJailsToBan" datasource="hermes">
                SELECT jail_name, display_name FROM intrusion_prevention_jails
                WHERE enabled = 1
                ORDER BY jail_name
            </cfquery>
        <cfelse>
            <!--- Single jail specified --->
            <cfquery name="getJailsToBan" datasource="hermes">
                SELECT jail_name, display_name FROM intrusion_prevention_jails
                WHERE jail_name = <cfqueryparam value="#form.ban_jail#" cfsqltype="cf_sql_varchar">
                AND enabled = 1
            </cfquery>
        </cfif>

        <cfif getJailsToBan.recordcount GT 0>

            <cftry>
                <cfset banSuccessCount = 0>
                <cfset banErrors = []>

                <!--- Get current date/time --->
                <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
                <cfset timenow = TimeFormat(now(), "HH:mm:ss")>

                <!--- Loop through jails and ban IP in each --->
                <cfloop query="getJailsToBan">
                    <!--- Check if IP is already banned in this jail --->
                    <cfquery name="checkExists" datasource="hermes">
                        SELECT ip FROM fail2ban_ips
                        WHERE ip = <cfqueryparam value="#form.ban_ip#" cfsqltype="cf_sql_varchar">
                        AND jail = <cfqueryparam value="#getJailsToBan.jail_name#" cfsqltype="cf_sql_varchar">
                    </cfquery>

                    <cfif checkExists.recordcount LT 1>
                        <!--- Ban IP via fail2ban-client (triggers iptables blocking) --->
                        <cftry>
                            <cfexecute name="/usr/local/bin/docker"
                                arguments="exec hermes_fail2ban fail2ban-client set #getJailsToBan.jail_name# banip #form.ban_ip#"
                                variable="banResult"
                                errorVariable="banError"
                                timeout="30">
                            </cfexecute>

                            <!--- Check if ban was successful (returns 1 for success) --->
                            <cfif val(trim(banResult)) EQ 1 OR FindNoCase("already banned", banResult)>
                                <!--- fail2ban's action calls hermes-api-notify.sh which may insert with AUTOMATIC type --->
                                <!--- We update the record to MANUAL/ADMIN to reflect this was a GUI action --->
                                <!--- Small delay to ensure API has time to insert first --->
                                <cfset sleep(500)>
                                <cfquery name="updateBanSource" datasource="hermes">
                                    UPDATE fail2ban_ips
                                    SET ban_type = 'MANUAL',
                                        ban_source = 'ADMIN',
                                        note = 'Manually banned via Intrusion Prevention GUI'
                                    WHERE ip = <cfqueryparam value="#form.ban_ip#" cfsqltype="cf_sql_varchar">
                                    AND jail = <cfqueryparam value="#getJailsToBan.jail_name#" cfsqltype="cf_sql_varchar">
                                </cfquery>
                                <cfset banSuccessCount = banSuccessCount + 1>
                            <cfelse>
                                <cfset ArrayAppend(banErrors, "#getJailsToBan.display_name#: #banResult#")>
                            </cfif>

                        <cfcatch type="any">
                            <cfset ArrayAppend(banErrors, "#getJailsToBan.display_name#: #cfcatch.message#")>
                        </cfcatch>
                        </cftry>
                    <cfelse>
                        <!--- Already banned in this jail --->
                        <cfset ArrayAppend(banErrors, "#getJailsToBan.display_name#: Already banned")>
                    </cfif>
                </cfloop>

                <!--- Report results --->
                <cfif banSuccessCount GT 0>
                    <cfset manualBanSuccess = true>
                    <cfset bannedJailCount = banSuccessCount>

                    <!--- If some jails failed, note it but still report success --->
                    <cfif ArrayLen(banErrors) GT 0>
                        <cfset manualBanError = "Banned in #banSuccessCount# jail(s), but: #ArrayToList(banErrors, '; ')#">
                    </cfif>
                <cfelseif ArrayLen(banErrors) GT 0>
                    <cfset manualBanError = "#ArrayToList(banErrors, '; ')#">
                </cfif>

            <cfcatch type="any">
                <cfset manualBanError = "Error executing ban: #cfcatch.message#">
            </cfcatch>
            </cftry>

        <cfelse>
            <cfset manualBanError = "Invalid or disabled jail specified">
        </cfif>

    <cfelse>
        <cfset manualBanError = "Invalid IP address format">
    </cfif>

<cfelse>
    <cfset manualBanError = "Missing required parameters">
</cfif>
