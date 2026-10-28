<!--- fail2ban_ban_unban.cfm --->
<!--- API endpoint for fail2ban to log bans/unbans to database --->
<!--- Blocking is handled by fail2ban's iptables action (with network_mode: host) --->
<!--- This API only handles database logging - no UFW calls --->

<!--- Check if Intrusion Prevention is enabled (tamper resistance) --->
<cfquery name="checkIPEnabled" datasource="hermes">
    SELECT setting_value FROM intrusion_prevention_settings
    WHERE setting_name = 'enabled'
</cfquery>

<cfif checkIPEnabled.recordcount EQ 0 OR checkIPEnabled.setting_value NEQ "1">
    <!--- Silently refuse to process - intrusion prevention is disabled --->
    <cfabort>
</cfif>

<cfif StructKeyExists(url, "action") AND StructKeyExists(url, "ip") AND StructKeyExists(url, "type") AND StructKeyExists(url, "source")>

    <!--- Get IP Address Validation Regex --->
    <cfinclude template="/admin/2/inc/validate_ip_address.cfm">

    <cfif REFind(pattern, url.ip) GT 0 AND (url.action is "BAN" OR url.action is "UNBAN") AND (url.type is "AUTOMATIC" OR url.type is "MANUAL") AND (url.source is "MAILSERVER" OR url.source is "SSO" OR url.source is "ADMIN")>

        <cfset apply = 1>

    <cfelse>

        <cfset apply = 0>

    </cfif>

<cfelse>

    <cfset apply = 0>

</cfif>

<cfif apply EQ 1>

    <!--- A jail that shares a source with another (postfix and dovecot are both
         MAILSERVER) names itself; only jails that exist are accepted. --->
    <cfset jailOverride = "">
    <cfif StructKeyExists(url, "jail") AND Len(Trim(url.jail))>
        <cfquery name="checkJail" datasource="hermes">
            SELECT jail_name FROM intrusion_prevention_jails
            WHERE jail_name = <cfqueryparam value="#Trim(url.jail)#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif checkJail.recordcount EQ 1>
            <cfset jailOverride = checkJail.jail_name>
        </cfif>
    </cfif>

    <cfif url.action is "BAN">

        <!--- Determine jail from source --->
        <cfif url.source EQ "MAILSERVER">
            <cfset theJail = "dovecot">
        <cfelseif url.source EQ "SSO">
            <cfset theJail = "authelia">
        <cfelse>
            <cfset theJail = "">
        </cfif>
        <cfif Len(jailOverride)>
            <cfset theJail = jailOverride>
        </cfif>

        <!--- Check if IP already exists in database for this jail --->
        <cfquery name="checkexists" datasource="hermes">
            SELECT ip FROM fail2ban_ips
            WHERE ip = <cfqueryparam value="#url.ip#" cfsqltype="cf_sql_varchar">
            AND jail = <cfqueryparam value="#theJail#" cfsqltype="cf_sql_varchar">
            LIMIT 1
        </cfquery>

        <cfif checkexists.recordcount LT 1>

            <!--- Get current date/time --->
            <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
            <cfset timenow = TimeFormat(now(), "HH:mm:ss")>

            <!--- Insert ban record to database --->
            <cfquery name="insertipaddress" datasource="hermes">
                INSERT INTO fail2ban_ips
                (ip, datetime, ban_type, ip_type, system, note, ban_source, jail)
                VALUES
                (
                    <cfqueryparam value="#url.ip#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#datenow# #timenow#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#url.type#" cfsqltype="cf_sql_varchar">,
                    'BAN',
                    '2',
                    <cfif url.type EQ "AUTOMATIC">'Automatically Banned by Intrusion Prevention'<cfelse>'Manually Banned via Intrusion Prevention GUI'</cfif>,
                    <cfqueryparam value="#url.source#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#theJail#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

        </cfif>

    <cfelseif url.action is "UNBAN">

        <!--- Determine jail from source --->
        <cfif url.source EQ "MAILSERVER">
            <cfset theJail = "dovecot">
        <cfelseif url.source EQ "SSO">
            <cfset theJail = "authelia">
        <cfelse>
            <cfset theJail = "">
        </cfif>
        <cfif Len(jailOverride)>
            <cfset theJail = jailOverride>
        </cfif>

        <!--- Delete ban record from database for this specific jail --->
        <cfquery name="deleteipaddress" datasource="hermes">
            DELETE FROM fail2ban_ips
            WHERE ip = <cfqueryparam value="#url.ip#" cfsqltype="cf_sql_varchar">
            AND jail = <cfqueryparam value="#theJail#" cfsqltype="cf_sql_varchar">
        </cfquery>

    </cfif>

</cfif>
