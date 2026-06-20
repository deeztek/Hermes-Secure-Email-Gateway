<!---
Hermes Secure Email Gateway - Domain Delete Action Handler
Validates cascade dependencies and deletes domain with linked records.
Expects: form.domain_id
--->

<cfif NOT StructKeyExists(form, "domain_id") OR NOT isValid("integer", form.domain_id)>
  <cfset session.m = 20>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfset datasource = "hermes">
<cfinclude template="./deletedomain.cfm">
