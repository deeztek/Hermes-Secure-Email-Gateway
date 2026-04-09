
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

EDIT BCC MAP ACTION HANDLER
Updates BCC target, enabled status, and description. Address and type are immutable.
--->

<!--- VALIDATE ID --->
<cfif NOT StructKeyExists(form, "bcc_id") OR NOT IsNumeric(form.bcc_id)>
    <cfset session.m = 20>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- GET EXISTING ENTRY --->
<cfquery name="getBcc" datasource="hermes">
    SELECT id FROM bcc_maps WHERE id = <cfqueryparam value="#form.bcc_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getBcc.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- VALIDATE BCC TO --->
<cfif NOT StructKeyExists(form, "edit_bcc_to") OR trim(form.edit_bcc_to) EQ "">
    <cfset session.m = 12>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>
<cfset editBccTo = LCase(trim(form.edit_bcc_to))>
<cfif NOT IsValid("email", editBccTo)>
    <cfset session.m = 13>
    <cflocation url="view_bcc_maps.cfm" addtoken="no">
</cfif>

<!--- VALIDATE ENABLED --->
<cfparam name="form.edit_enabled" default="1">
<cfif form.edit_enabled NEQ "0" AND form.edit_enabled NEQ "1">
    <cfset form.edit_enabled = 1>
</cfif>

<!--- VALIDATE DESCRIPTION --->
<cfparam name="form.edit_description" default="">

<!--- UPDATE --->
<cfquery datasource="hermes">
    UPDATE bcc_maps
    SET bcc_to = <cfqueryparam value="#editBccTo#" cfsqltype="cf_sql_varchar">,
        enabled = <cfqueryparam value="#form.edit_enabled#" cfsqltype="cf_sql_tinyint">,
        description = <cfqueryparam value="#trim(form.edit_description)#" cfsqltype="cf_sql_varchar" null="#(trim(form.edit_description) IS '')#">
    WHERE id = <cfqueryparam value="#form.bcc_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- SUCCESS --->
<cfset session.m = 2>
<cflocation url="view_bcc_maps.cfm" addtoken="no">
