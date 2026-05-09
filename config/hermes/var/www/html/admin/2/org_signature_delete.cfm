<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
DELETE ORGANIZATIONAL SIGNATURE ACTION (#226 Phase 2A).

GET ?id=N -> delete the row, redirect to view_org_signatures.cfm.
Confirmation happens client-side on the list page (window.confirm).

Phase 2B will additionally remove the per-row file from the body
milter signatures dir + regenerate the resolution map + reload.
--->

<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset session.org_sig_msg = "<strong>Pro license required.</strong> Organizational Signatures are a Pro Edition feature.">
    <cfset session.org_sig_msg_type = "warning">
    <cflocation url="view_org_signatures.cfm" addtoken="no">
</cfif>

<cfparam name="url.id" default="0">

<cfif NOT IsNumeric(url.id) OR Val(url.id) LT 1>
    <cfset session.org_sig_msg = "<strong>Delete failed.</strong> Invalid id.">
    <cfset session.org_sig_msg_type = "danger">
    <cflocation url="view_org_signatures.cfm" addtoken="no">
</cfif>

<!--- Capture domain + department for the success message before
     deletion so the user sees a useful flash. --->
<cfquery name="getRow" datasource="hermes">
    SELECT os.id, os.department_label, d.domain
    FROM org_signatures os
    LEFT JOIN domains d ON d.id = os.domain_id
    WHERE os.id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getRow.recordcount LT 1>
    <cfset session.org_sig_msg = "<strong>Already gone.</strong> Organizational Signature ID ##" & url.id & " was not found.">
    <cfset session.org_sig_msg_type = "warning">
    <cflocation url="view_org_signatures.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    DELETE FROM org_signatures WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset variantLabel = Len(getRow.department_label) ? ("'" & getRow.department_label & "' department") : "domain default">
<cfset session.org_sig_msg = "<strong>Deleted.</strong> " & HTMLEditFormat(variantLabel) & " signature for " & HTMLEditFormat(getRow.domain) & " removed.">
<cfset session.org_sig_msg_type = "success">

<cflocation url="view_org_signatures.cfm" addtoken="no">
