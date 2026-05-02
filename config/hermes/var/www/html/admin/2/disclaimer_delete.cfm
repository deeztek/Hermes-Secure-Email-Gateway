<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
DELETE DISCLAIMER ACTION HANDLER (#214 Phase 2).

GET ?id=N -> delete the row, redirect to view_disclaimers.cfm.
Confirmation happens client-side on the list page (window.confirm).

Phase 3 will additionally remove the per-scope file from
/etc/amavis/disclaimers/ and regenerate the policy bank + reload.
--->

<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset session.disclaimer_msg = "<strong>Pro license required.</strong> Disclaimers are a Pro Edition feature.">
    <cfset session.disclaimer_msg_type = "warning">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<cfparam name="url.id" default="0">

<cfif NOT IsNumeric(url.id) OR Val(url.id) LT 1>
    <cfset session.disclaimer_msg = "<strong>Delete failed.</strong> Invalid id.">
    <cfset session.disclaimer_msg_type = "danger">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<!--- Capture scope_key for the success message before deletion. --->
<cfquery name="getRow" datasource="hermes">
    SELECT scope, scope_key FROM disclaimers
    WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getRow.recordcount LT 1>
    <cfset session.disclaimer_msg = "<strong>Already gone.</strong> Disclaimer ID ##" & url.id & " was not found.">
    <cfset session.disclaimer_msg_type = "warning">
    <cflocation url="view_disclaimers.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    DELETE FROM disclaimers WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset session.disclaimer_msg = "<strong>Deleted.</strong> " & HTMLEditFormat(getRow.scope) & " disclaimer for " & HTMLEditFormat(getRow.scope_key) & " removed.">
<cfset session.disclaimer_msg_type = "success">

<cflocation url="view_disclaimers.cfm" addtoken="no">
