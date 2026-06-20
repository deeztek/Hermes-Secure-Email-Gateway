
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

ADD BCC MAP ACTION HANDLER
Creates a sender or recipient BCC map entry.
--->

<!--- VALIDATE ADDRESS --->
<cfif NOT StructKeyExists(form, "address") OR trim(form.address) EQ "">
    <cfset session.m = 10>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<cfset bccAddress = LCase(trim(form.address))>

<!--- Validate format: email address or @domain pattern --->
<cfset isAtDomain = Left(bccAddress, 1) is "@" AND Len(bccAddress) GT 1>
<cfif NOT isAtDomain AND NOT IsValid("email", bccAddress)>
    <cfset session.m = 11>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- VALIDATE BCC TYPE --->
<cfparam name="form.bcc_type" default="sender">
<cfif form.bcc_type NEQ "sender" AND form.bcc_type NEQ "recipient">
    <cfset form.bcc_type = "sender">
</cfif>

<!--- VALIDATE BCC TO --->
<cfif NOT StructKeyExists(form, "bcc_to") OR trim(form.bcc_to) EQ "">
    <cfset session.m = 12>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<cfset bccTo = LCase(trim(form.bcc_to))>

<cfif NOT IsValid("email", bccTo)>
    <cfset session.m = 13>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- VALIDATE DESCRIPTION --->
<cfparam name="form.description" default="">

<!--- CHECK FOR DUPLICATE --->
<cfquery name="checkDuplicate" datasource="hermes">
    SELECT id FROM bcc_maps
    WHERE address = <cfqueryparam value="#bccAddress#" cfsqltype="cf_sql_varchar">
    AND bcc_type = <cfqueryparam value="#form.bcc_type#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif checkDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- INSERT --->
<cfquery datasource="hermes">
    INSERT INTO bcc_maps (address, bcc_to, bcc_type, enabled, description)
    VALUES (
      <cfqueryparam value="#bccAddress#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#bccTo#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.bcc_type#" cfsqltype="cf_sql_varchar">,
      1,
      <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar" null="#(trim(form.description) IS '')#">
    )
</cfquery>

<!--- SUCCESS --->
<cfset session.m = 1>
<cflocation url="view_bcc_maps.cfm" addtoken="no">
