<!---
Hermes Secure Email Gateway - Sender/Recipient Block/Allow Delete Entry Action Handler
Deletes entries directly from wblist using composite key (rid+sid). After deletion, removes
any orphaned mailaddr entries no longer referenced by any wblist row.
Expects: form.delete_rid + form.delete_sid (single) or form.selected_ids (bulk, "rid:sid,rid:sid")
--->

<!--- Single delete --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_rid") AND IsNumeric(form.delete_rid)
    AND StructKeyExists(form, "delete_sid") AND IsNumeric(form.delete_sid)>
    <cfquery datasource="hermes">
      DELETE FROM wblist
      WHERE rid = <cfqueryparam value="#form.delete_rid#" cfsqltype="cf_sql_integer">
        AND sid = <cfqueryparam value="#form.delete_sid#" cfsqltype="cf_sql_integer">
    </cfquery>
    <!--- Remove orphaned mailaddr entries no longer referenced by any wblist row --->
    <cfquery datasource="hermes">
      DELETE FROM mailaddr
      WHERE id NOT IN (SELECT DISTINCT sid FROM wblist)
    </cfquery>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>

<!--- Bulk delete — selected_ids is a comma-separated list of "rid:sid" pairs --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="entry">
      <cfset entryRid = ListFirst(entry, ":")>
      <cfset entrySid = ListLast(entry, ":")>
      <cfif IsNumeric(entryRid) AND IsNumeric(entrySid)>
        <cfquery datasource="hermes">
          DELETE FROM wblist
          WHERE rid = <cfqueryparam value="#entryRid#" cfsqltype="cf_sql_integer">
            AND sid = <cfqueryparam value="#entrySid#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <!--- Remove orphaned mailaddr entries no longer referenced by any wblist row --->
    <cfquery datasource="hermes">
      DELETE FROM mailaddr
      WHERE id NOT IN (SELECT DISTINCT sid FROM wblist)
    </cfquery>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
</cfif>
