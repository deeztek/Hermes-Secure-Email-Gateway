<!---
Hermes Secure Email Gateway - Edit Virtual Recipient Action Handler

Edits a whole entry: the address, its complete set of destinations, and its
reachability. The modal shows every destination as a removable chip, the same
way the list renders them, so what arrives here is the set the admin wants,
not a single row.

The save is a DIFF against what is stored, not a rewrite. Insert what is new,
delete what was taken off, leave the rest alone. That matters for three
reasons: there is never a moment where the address has no destinations and
mail would bounce, unchanged rows keep their identity, and a failure partway
through cannot empty the entry.

Expects:
  form.edit_original_address  the address being edited, as it is stored
  form.edit_address           the address to save, possibly renamed
  form.edit_forwards          comma-delimited destination set
  form.edit_internal_only     0 or 1
--->

<cfif StructKeyExists(form, "edit_original_address") AND Trim(form.edit_original_address) is not "">

  <cfset originalAddress = LCase(Trim(form.edit_original_address))>
  <cfset editAddress     = LCase(Trim(form.edit_address))>

  <!--- Validate virtual address --->
  <cfif editAddress is "">
    <cfset session.m = 10>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <!--- Catch-all or full email --->
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

  <!--- Destination set. Split on comma, semicolon and whitespace so a pasted
       list needs no reformatting, deduplicated so the diff below cannot try
       to insert the same pair twice. --->
  <cfparam name="form.edit_forwards" default="">
  <cfset wantedDests = "">
  <cfloop index="fwdCandidate" list="#Trim(form.edit_forwards)#" delimiters=",; #chr(9)##chr(10)##chr(13)#">
    <cfset fwdCandidate = LCase(Trim(fwdCandidate))>
    <cfif fwdCandidate is "">
      <cfcontinue>
    </cfif>
    <cfif NOT IsValid("email", fwdCandidate)>
      <cfset session.m = 12>
      <cflocation url="view_virtual_recipients.cfm" addtoken="no">
    </cfif>
    <cfif ListFindNoCase(wantedDests, fwdCandidate) EQ 0>
      <cfset wantedDests = ListAppend(wantedDests, fwdCandidate)>
    </cfif>
  </cfloop>

  <!--- Removing every destination would leave an address that resolves to
       nothing. Deleting the entry is the way to do that, so it is refused
       here rather than silently emptying it. --->
  <cfif ListLen(wantedDests) EQ 0>
    <cfset session.m = 11>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>

  <cfparam name="form.edit_internal_only" default="0">
  <cfif form.edit_internal_only NEQ "0" AND form.edit_internal_only NEQ "1">
    <cfset form.edit_internal_only = 0>
  </cfif>

  <!--- Renaming the address must not collide with an entry that already
       exists under the new name, which would silently merge two lists. --->
  <cfif editAddress NEQ originalAddress>
    <cfquery name="checkRenameClash" datasource="hermes">
      SELECT id FROM virtual_recipients
      WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkRenameClash.recordcount GTE 1>
      <cfset session.m = 14>
      <cflocation url="view_virtual_recipients.cfm" addtoken="no">
    </cfif>

    <!--- Carry the rows over first, so the diff below works against the new
         name and destinations keep their rows rather than being recreated. --->
    <cfquery datasource="hermes">
      UPDATE virtual_recipients
      SET virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
      WHERE virtual_address = <cfqueryparam value="#originalAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>
  </cfif>

  <!--- DIFF --->
  <cfquery name="currentDests" datasource="hermes">
    SELECT id, maps FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfset currentList = "">
  <cfoutput query="currentDests">
    <cfset currentList = ListAppend(currentList, LCase(Trim(maps)))>
  </cfoutput>

  <!--- ADD what is new --->
  <cfloop index="wantedOne" list="#wantedDests#" delimiters=",">
    <cfset wantedOne = Trim(wantedOne)>
    <cfif ListFindNoCase(currentList, wantedOne) GT 0>
      <cfcontinue>
    </cfif>
    <cfquery datasource="hermes">
      INSERT INTO virtual_recipients (virtual_address, maps, internal_only, system)
      VALUES (
        <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#wantedOne#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">,
        '2'
      )
    </cfquery>
  </cfloop>

  <!--- REMOVE what was taken off. By id, so untouched rows stay untouched. --->
  <cfoutput query="currentDests">
    <cfif ListFindNoCase(wantedDests, LCase(Trim(currentDests.maps))) EQ 0>
      <cfquery datasource="hermes">
        DELETE FROM virtual_recipients
        WHERE id = <cfqueryparam value="#currentDests.id#" cfsqltype="cf_sql_integer">
      </cfquery>
    </cfif>
  </cfoutput>

  <!--- Reachability belongs to the ADDRESS, so it applies to every row.
       Leaving it per-row would let an entry end up half open and half
       restricted, which Postfix cannot express and an admin cannot reason
       about. --->
  <cfquery datasource="hermes">
    UPDATE virtual_recipients
    SET internal_only = <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">,
        system = '2'
    WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfset session.m = 3>
</cfif>
<cflocation url="view_virtual_recipients.cfm" addtoken="no">
