
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET MAILBOX BCC COUNT - AJAX endpoint that returns the number of bcc_maps
entries that reference a given mailbox (either as address or bcc_to target).
Used by the delete mailbox confirmation modal to warn the admin before
cascading the deletion.
--->

<cfparam name="form.mailbox_id" default="">

<cfcontent type="application/json" reset="true">

<cfif form.mailbox_id EQ "" OR NOT IsNumeric(form.mailbox_id)>
    <cfoutput>{"error":"Invalid mailbox ID","count":0}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getMailbox" datasource="hermes">
    SELECT username FROM mailboxes
    WHERE id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailbox.recordcount LT 1>
    <cfoutput>{"error":"Mailbox not found","count":0}</cfoutput>
    <cfabort>
</cfif>

<cfset email = getMailbox.username>

<cfquery name="countBcc" datasource="hermes">
    SELECT
      COUNT(*) AS total,
      SUM(CASE WHEN address = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar"> THEN 1 ELSE 0 END) AS as_address,
      SUM(CASE WHEN bcc_to  = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar"> THEN 1 ELSE 0 END) AS as_target
    FROM bcc_maps
    WHERE address = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
       OR bcc_to  = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset out = {
    "count": Val(countBcc.total),
    "as_address": Val(countBcc.as_address),
    "as_target": Val(countBcc.as_target)
}>

<cfoutput>#SerializeJSON(out)#</cfoutput>
<cfabort>
