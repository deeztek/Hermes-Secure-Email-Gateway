
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

SAVE USER TIMEZONE
Updates the logged-in user's IANA timezone in user_settings. Validated against
Java's available zone IDs to prevent injecting garbage that would later break
sieve generation or display formatting.
--->

<cfparam name="form.timezone" default="">

<cfset newTz = trim(form.timezone)>

<cfif newTz EQ "">
    <cfset session.tzMessage = "<h4><i class='icon fa fa-ban'></i> Error</h4>Timezone cannot be empty.">
    <cfset session.tzMessageType = "danger">
    <cflocation url="user_settings.cfm" addtoken="no">
</cfif>

<!--- Validate against Java's known zone IDs --->
<cftry>
    <cfset zoneId = createObject("java", "java.time.ZoneId")>
    <cfset zoneId.of(newTz)>
<cfcatch type="any">
    <cfset session.tzMessage = "<h4><i class='icon fa fa-ban'></i> Error</h4>Invalid timezone: " & HTMLEditFormat(newTz)>
    <cfset session.tzMessageType = "danger">
    <cflocation url="user_settings.cfm" addtoken="no">
</cfcatch>
</cftry>

<cfquery datasource="hermes">
    UPDATE user_settings
    SET timezone = <cfqueryparam value="#newTz#" cfsqltype="cf_sql_varchar">
    WHERE email = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Regenerate the user's sieve script so vacation date checks pick up
     the new timezone immediately --->
<cftry>
    <cfset sieveUsername = session.email>
    <cfinclude template="../../../admin/2/inc/generate_sieve_user.cfm">
<cfcatch type="any"></cfcatch>
</cftry>

<cfset session.tzMessage = "<h4><i class='icon fa fa-check'></i> Saved</h4>Timezone updated to " & HTMLEditFormat(newTz) & ".">
<cfset session.tzMessageType = "success">
<cflocation url="user_settings.cfm" addtoken="no">
