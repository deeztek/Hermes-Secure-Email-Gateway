<!---
Hermes Secure Email Gateway - Edit Virtual Recipient Action Handler
Updates an existing virtual recipient entry with full address and delivery target.
Expects: form.edit_id (integer), form.edit_address (virtual address), form.edit_forwards (delivery address)
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <cfset editAddress = LCase(trim(form.edit_address))>
  <cfset editForwards = LCase(trim(form.edit_forwards))>
  <cfset editId = form.edit_id>

  <!--- Validate virtual address --->
  <cfif editAddress is "">
    <cfset session.m = 10>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Validate delivers to --->
  <cfif editForwards is "">
    <cfset session.m = 11>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsValid("email", editForwards)>
    <cfset session.m = 12>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Validate format: catch-all or full email --->
  <cfset isCatchAll = Left(editAddress, 1) is "@" AND Len(editAddress) GT 1>
  <cfif NOT isCatchAll AND NOT IsValid("email", editAddress)>
    <cfset session.m = 10>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Extract and validate domain --->
  <cfif isCatchAll>
    <cfset editDomain = Mid(editAddress, 2, Len(editAddress))>
  <cfelse>
    <cfset editDomain = ListLast(editAddress, "@")>
  </cfif>

  <cfquery name="checkDomain" datasource="hermes">
    SELECT domain FROM domains
    WHERE domain = <cfqueryparam value="#editDomain#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDomain.recordcount LT 1>
    <cfset session.m = 13>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicates (exclude current record) --->
  <cfquery name="checkEntry" datasource="hermes">
    SELECT id FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
      AND maps = <cfqueryparam value="#editForwards#" cfsqltype="cf_sql_varchar">
      AND id <> <cfqueryparam value="#editId#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkEntry.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Update this destination row --->
  <cfquery datasource="hermes">
    UPDATE virtual_recipients
    SET virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">,
        maps = <cfqueryparam value="#editForwards#" cfsqltype="cf_sql_varchar">,
        system = '2'
    WHERE id = <cfqueryparam value="#editId#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Reachability belongs to the ADDRESS, not to one destination, so it is
       applied across every row that address has. Leaving it per-row would let
       an entry end up half open and half restricted, which Postfix cannot
       express and an admin cannot reason about. --->
  <cfparam name="form.edit_internal_only" default="0">
  <cfif form.edit_internal_only NEQ "0" AND form.edit_internal_only NEQ "1">
    <cfset form.edit_internal_only = 0>
  </cfif>
  <cfquery datasource="hermes">
    UPDATE virtual_recipients
    SET internal_only = <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">
    WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfset session.m = 3>
</cfif>
<cflocation url="view_virtual_recipients.cfm" addtoken="no">
