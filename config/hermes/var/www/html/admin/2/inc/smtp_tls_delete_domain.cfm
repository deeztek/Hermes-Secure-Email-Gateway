<!---
Hermes Secure Email Gateway - SMTP TLS Delete Domain Action Handler
Deletes a domain from TLS policies table.
Expects: form.delete_id (comma-separated list of integer IDs)
--->

<cfif NOT StructKeyExists(form, "delete_id") OR trim(form.delete_id) is "">
  <cfset session.m = 20>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<cfloop index="i" list="#form.delete_id#" delimiters=",">
  <cfif IsValid("integer", i)>
    <cfquery datasource="hermes">
      DELETE FROM tls_policies WHERE id = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfif>
</cfloop>

<!--- Generate TLS policy file and reload Postfix --->
<cfset datasource = "hermes">
<cfinclude template="./generate_tls_policy.cfm">
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 34>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
