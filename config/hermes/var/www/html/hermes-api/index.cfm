
<!--- Hermes internal API relay. Container network only. --->

<cfset reqHeaders = GetHttpRequestData().headers>

<!--- The only templates this relay may forward to --->
<cfset allowedTargets = "/admin/2/inc/check_system_update.cfm,/admin/2/inc/dovecot_overquota_notification.cfm,/admin/2/inc/fail2ban_ban_unban.cfm,/admin/2/inc/check_hibp.cfm">

<!--- Caller IP --->
<cfset theIP = cgi.remote_addr>

<!--- CHECK FOR X-TOKEN HEADER --->
<cfif NOT StructKeyExists(reqHeaders, "X-Token") OR Trim(reqHeaders["X-Token"]) is "">
    <cfoutput>Invalid Request: X-Token is missing</cfoutput>
    <cfabort>
</cfif>
<cfset theToken = Trim(reqHeaders["X-Token"])>

<!--- CHECK FOR X-ORIGINAL-URL HEADER --->
<cfif NOT StructKeyExists(reqHeaders, "X-Original-URL") OR Trim(reqHeaders["X-Original-URL"]) is "">
    <cfoutput>Invalid Request: X-Original-URL is missing</cfoutput>
    <cfabort>
</cfif>
<cfset theUrl = Trim(reqHeaders["X-Original-URL"])>

<!--- Allowed targets only --->
<cfif NOT REFind("^/[A-Za-z0-9/_.-]+\.cfm(\?[A-Za-z0-9._~%&=+@:,-]*)?$", theUrl) OR NOT ListFind(allowedTargets, ListFirst(theUrl, "?"))>
    <cfoutput>Invalid Request: X-Original-URL is not permitted</cfoutput>
    <cfabort>
</cfif>

<!--- Exact match --->
<cfquery name="gettoken" datasource="hermes">
    select ip from api_tokens
    where BINARY token = <cfqueryparam value="#theToken#" cfsqltype="cf_sql_varchar">
    and active = 1
</cfquery>

<cfif gettoken.recordcount NEQ 1>
    <cfoutput>Unauthorized Access: Invalid Token</cfoutput>
    <cfabort>
</cfif>

<cfset ipAllowed = false>
<cfloop index="theIpAddress" list="#gettoken.ip#" delimiters=",">
    <cfif Compare(theIP, Trim(theIpAddress)) EQ 0>
        <cfset ipAllowed = true>
    </cfif>
</cfloop>

<cfif NOT ipAllowed>
    <cfoutput>Unauthorized Access: Invalid IP</cfoutput>
    <cfabort>
</cfif>

<!--- GENERATE VERIFY TOKEN --->
<cfset _transLength = 32>
<cfinclude template="/admin/2/inc/generate_customtrans.cfm">
<cfset VerifyToken = customtrans3>

<!--- INSERT VERIFY TOKEN IN DATABASE --->
<cfquery name="createverifytoken" datasource="hermes">
    update api_tokens set verify = <cfqueryparam value="#VerifyToken#" cfsqltype="cf_sql_varchar">
    where BINARY token = <cfqueryparam value="#theToken#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Callers already URL-encode their query values --->
<cfhttp method="POST" url="http://127.0.0.1:8888#theUrl#" encodeurl="false" charset="utf-8" timeout="10" throwonerror="false">
    <cfhttpparam type="header" name="accept" value="*/*">
    <cfhttpparam type="header" name="X-Token" value="#theToken#">
    <cfhttpparam type="header" name="X-Verify-Token" value="#VerifyToken#">
</cfhttp>

<cfoutput>Authorized</cfoutput><br>
<cfoutput>#cfhttp.fileContent#</cfoutput>
