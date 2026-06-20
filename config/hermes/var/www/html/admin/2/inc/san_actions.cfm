
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

SAN ACTIONS HANDLER
Handles add and delete actions for SAN prefixes (additional_sans table).
After each action, calls sync_mailbox_sans.cfm to re-sync the
mailbox_sans table with the updated prefix list.
--->

<cfif action EQ "add_san">

    <cfparam name="form.san_prefix" default="">
    <cfset sanValue = LCase(trim(form.san_prefix))>

    <!--- Validate: not blank --->
    <cfif sanValue EQ "">
        <cfset session.m = 10>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <!--- Validate: format (lowercase letters, numbers, hyphens; starts with letter; max 63 chars per DNS label spec) --->
    <cfif NOT REFind("^[a-z][a-z0-9-]{0,62}$", sanValue)>
        <cfset session.m = 11>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <!--- Check uniqueness --->
    <cfquery name="checkDupe" datasource="hermes">
        SELECT id FROM additional_sans
        WHERE san = <cfqueryparam value="#sanValue#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkDupe.recordcount GTE 1>
        <cfset session.m = 12>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <!--- Insert --->
    <cfquery datasource="hermes">
        INSERT INTO additional_sans (san, system)
        VALUES (
            <cfqueryparam value="#sanValue#" cfsqltype="cf_sql_varchar">,
            2
        )
    </cfquery>

    <!--- Sync mailbox_sans table with the updated prefix list --->
    <cfinclude template="sync_mailbox_sans.cfm">

    <cfset session.m = 1>
    <cflocation url="view_mailbox_sans.cfm" addtoken="no">

<cfelseif action EQ "delete_san">

    <cfparam name="form.delete_san_id" default="">

    <cfif form.delete_san_id EQ "" OR NOT IsNumeric(form.delete_san_id)>
        <cfset session.m = 20>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <!--- Check if system prefix --->
    <cfquery name="checkSystem" datasource="hermes">
        SELECT id, san, system FROM additional_sans
        WHERE id = <cfqueryparam value="#form.delete_san_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif checkSystem.recordcount LT 1>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <cfif checkSystem.system EQ 1>
        <cfset session.m = 13>
        <cflocation url="view_mailbox_sans.cfm" addtoken="no">
    </cfif>

    <!--- Delete --->
    <cfquery datasource="hermes">
        DELETE FROM additional_sans
        WHERE id = <cfqueryparam value="#form.delete_san_id#" cfsqltype="cf_sql_integer">
        AND system <> 1
    </cfquery>

    <!--- Sync mailbox_sans table - removes orphaned SANs --->
    <cfinclude template="sync_mailbox_sans.cfm">

    <cfset session.m = 3>
    <cflocation url="view_mailbox_sans.cfm" addtoken="no">

</cfif>
