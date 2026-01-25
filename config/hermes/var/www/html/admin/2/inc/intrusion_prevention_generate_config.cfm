<!--- intrusion_prevention_generate_config.cfm --->
<!--- Generate jail.local from database and reload fail2ban --->

<cfset ipSyncSuccess = false>
<cfset ipSyncError = "">

<!--- Protected IPs that are always included regardless of database --->
<cfset protectedIPs = ["127.0.0.1/8", "::1", "172.16.0.0/12"]>

<cftry>
    <!--- 1. Get whitelist (user-added entries only) --->
    <cfquery name="getWhitelist" datasource="hermes">
        SELECT ip_cidr FROM intrusion_prevention_whitelist
        WHERE LOWER(ip_cidr) NOT IN ('127.0.0.1/8', '::1', '172.16.0.0/12')
        ORDER BY id
    </cfquery>

    <!--- 2. Get jails --->
    <cfquery name="getJails" datasource="hermes">
        SELECT * FROM intrusion_prevention_jails ORDER BY jail_name
    </cfquery>

    <!--- 3. Build jail.local content --->
    <!--- Always include protected IPs first, then user-added entries --->
    <cfsavecontent variable="jailConfig"><cfoutput>[DEFAULT]
ignoreip = 127.0.0.1/8 ::1 172.16.0.0/12<cfloop query="getWhitelist">
          #getWhitelist.ip_cidr#</cfloop>

<cfloop query="getJails">
[#getJails.jail_name#]
enabled = <cfif getJails.enabled EQ 1>true<cfelse>false</cfif>
filter = #getJails.filter_name#
action = #getJails.action_name#
logpath = #getJails.logpath#<cfif len(trim(getJails.port))>
port = #getJails.port#</cfif>
maxretry = #getJails.maxretry#
findtime = #getJails.findtime#
bantime = #getJails.bantime#
</cfloop></cfoutput></cfsavecontent>

    <!--- 4. Write jail.local --->
    <!--- Write to shared volume (mounted in both commandbox and fail2ban) --->
    <cfset tempFile = "/opt/hermes/tmp/jail.local.tmp">
    <cffile action="write" file="#tempFile#" output="#trim(jailConfig)#">

    <!--- Copy from shared volume to fail2ban config directory --->
    <!--- fail2ban has /opt/hermes mounted as read-only at /opt/hermes --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_fail2ban cp /opt/hermes/tmp/jail.local.tmp /config/fail2ban/jail.local"
        variable="copyResult"
        errorVariable="copyError"
        timeout="30">
    </cfexecute>

    <!--- 5. Reload fail2ban --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_fail2ban fail2ban-client reload"
        variable="reloadResult"
        errorVariable="reloadError"
        timeout="30">
    </cfexecute>

    <!--- 6. Update sync flags --->
    <cfquery datasource="hermes">
        UPDATE intrusion_prevention_settings SET setting_value = '1' WHERE setting_name = 'config_synced'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE intrusion_prevention_jails SET config_synced = 1
    </cfquery>

    <cfset ipSyncSuccess = true>

<cfcatch type="any">
    <cfset ipSyncError = cfcatch.message & " | Detail: " & cfcatch.detail & " | Type: " & cfcatch.type>
    <!--- Log the error --->
    <cfset m = "intrusion_prevention_generate_config.cfm: Error - #cfcatch.message# | Detail: #cfcatch.detail# | Type: #cfcatch.type#">
    <cfinclude template="error.cfm">
</cfcatch>
</cftry>
