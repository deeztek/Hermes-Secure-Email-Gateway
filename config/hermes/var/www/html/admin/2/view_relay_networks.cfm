<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Relay Networks</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Relay IPs/Networks</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Relay Networks</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="step" default="0">

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not "">
    <cfset action = url.action>
  </cfif>
</cfif>
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not "">
    <cfset action = form.action>
  </cfif>
</cfif>

<!--- IPv4 validation pattern --->
<cfset ipv4_pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

<!--- Function to normalize IP address (remove leading zeros from octets) --->
<cffunction name="normalizeIP" returntype="string" output="false">
  <cfargument name="ip" type="string" required="true">
  <cfset var octets = ListToArray(arguments.ip, ".")>
  <cfset var normalized = "">
  <cfloop array="#octets#" index="octet">
    <!--- Convert to number to remove leading zeros, then back to string --->
    <cfset normalized = ListAppend(normalized, Int(octet), ".")>
  </cfloop>
  <cfreturn normalized>
</cffunction>

<!--- GET RELAY NETWORKS DATA --->
<cfinclude template="./inc/get_relay_networks.cfm">


<!--- ===================== --->
<!--- ACTION: ADD ENTRIES --->
<!--- ===================== --->
<cfif action is "add_entries">
  <cfset entries_added = 0>
  <cfset entries_skipped = 0>
  <cfset entry_errors = "">

  <!--- Validate entries exists and is not empty --->
  <cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
    <cfset session.m = 30>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Normalize line endings and split into lines --->
  <cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
  <cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
  <cfset lines = ListToArray(entryText, Chr(10))>

  <cfloop array="#lines#" index="line">
    <cfset line = trim(line)>

    <!--- Skip empty lines --->
    <cfif line is "">
      <cfcontinue>
    </cfif>

    <!--- Parse line: first part is IP/Network, rest is note (optional) --->
    <cfset firstSpace = Find(" ", line)>
    <cfif firstSpace GT 0>
      <cfset entryAddress = trim(Left(line, firstSpace - 1))>
      <cfset entryNote = trim(Mid(line, firstSpace + 1, Len(line)))>
    <cfelse>
      <!--- No space found, entire line is address - use address as note --->
      <cfset entryAddress = line>
      <cfset entryNote = line>
    </cfif>

    <!--- Note validation removed - cfqueryparam handles SQL injection --->
    <!--- HTML encoding on output handles XSS --->

    <!--- Determine if it's a network (has /) or single IP --->
    <cfset isNetwork = Find("/", entryAddress) GT 0>

    <cfif isNetwork>
      <!--- Parse network address and CIDR --->
      <cfset networkPart = ListFirst(entryAddress, "/")>
      <cfset cidrPart = ListLast(entryAddress, "/")>

      <!--- Validate network address --->
      <cfif NOT REFind(ipv4_pattern, networkPart)>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid network address: " & encodeForHTML(entryAddress) & "<br>">
        <cfcontinue>
      </cfif>

      <!--- Validate CIDR (1-32) --->
      <cfif NOT IsNumeric(cidrPart) OR cidrPart LT 1 OR cidrPart GT 32>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid CIDR mask: " & encodeForHTML(entryAddress) & "<br>">
        <cfcontinue>
      </cfif>

      <!--- Normalize IP (remove leading zeros) and rebuild with CIDR --->
      <cfset theEntry = normalizeIP(networkPart) & "/" & Int(cidrPart)>
      <cfset isNetworkEntry = "1">

    <cfelse>
      <!--- Single IP address --->
      <cfif NOT REFind(ipv4_pattern, entryAddress)>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid IP address: " & encodeForHTML(entryAddress) & "<br>">
        <cfcontinue>
      </cfif>

      <!--- Normalize IP (remove leading zeros) --->
      <cfset theEntry = normalizeIP(entryAddress)>
      <cfset isNetworkEntry = "0">
    </cfif>

    <!--- Check if already exists --->
    <cfquery name="checkexists_entry" datasource="hermes">
      SELECT id FROM parameters
      WHERE parameter = <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">
      AND parent = '#mynetworks_parent_id#'
      AND child = '1'
    </cfquery>

    <cfif checkexists_entry.recordcount GTE 1>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Already exists: " & encodeForHTML(theEntry) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Get max order --->
    <cfquery name="getmaxorder_entry" datasource="hermes">
      SELECT COALESCE(MAX(order1), 0) as maximum FROM parameters WHERE parent='#mynetworks_parent_id#' AND child='1'
    </cfquery>
    <cfset nextorder_entry = getmaxorder_entry.maximum + 1>

    <!--- Insert the entry --->
    <cfquery name="add_entry" datasource="hermes">
      INSERT INTO parameters (parameter, module, editable, conf_file, parent, parent_name, child, order1, enabled, applied, action, network_entry, note)
      VALUES (
        <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">,
        'postfix', '1', 'main.cf', '#mynetworks_parent_id#', 'mynetworks', '1', '#nextorder_entry#', '1', '2', 'insert', '#isNetworkEntry#',
        <cfqueryparam value="#entryNote#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>

    <cfset entries_added = entries_added + 1>

  </cfloop>

  <!--- Store results in session for display --->
  <cfset session.entries_added = entries_added>
  <cfset session.entries_skipped = entries_skipped>
  <cfset session.entry_errors = entry_errors>

  <cfif entries_added GT 0>
    <cfset session.m = 31>
  <cfelseif entries_skipped GT 0>
    <cfset session.m = 32>
  <cfelse>
    <cfset session.m = 30>
  </cfif>

  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: DELETE --->
<!--- ===================== --->
<cfif action is "delete">
  <cfif NOT StructKeyExists(form, "network_id") OR trim(form.network_id) is "">
    <cfset session.m = 12>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Mark for deletion --->
  <cfquery name="mark_delete" datasource="hermes">
    UPDATE parameters
    SET action = 'delete', applied = '2'
    WHERE id = <cfqueryparam value="#form.network_id#" cfsqltype="cf_sql_integer">
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <cfset session.m = 13>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: BULK DELETE --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif NOT StructKeyExists(form, "selected_ids") OR trim(form.selected_ids) is "">
    <cfset session.m = 16>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Convert comma-separated list to array for validation --->
  <cfset idList = ListToArray(form.selected_ids)>
  <cfset deleteCount = 0>

  <cfloop array="#idList#" index="networkId">
    <cfif IsNumeric(networkId)>
      <!--- Mark for deletion --->
      <cfquery name="mark_bulk_delete" datasource="hermes">
        UPDATE parameters
        SET action = 'delete', applied = '2'
        WHERE id = <cfqueryparam value="#networkId#" cfsqltype="cf_sql_integer">
        AND parent = '#mynetworks_parent_id#'
      </cfquery>
      <cfset deleteCount = deleteCount + 1>
    </cfif>
  </cfloop>

  <cfset session.bulk_delete_count = deleteCount>
  <cfset session.m = 17>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: EDIT ENTRY --->
<!--- ===================== --->
<cfif action is "edit_entry">
  <cfif NOT StructKeyExists(form, "edit_id") OR trim(form.edit_id) is "" OR NOT IsNumeric(form.edit_id)>
    <cfset session.m = 18>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfif NOT StructKeyExists(form, "edit_parameter") OR trim(form.edit_parameter) is "">
    <cfset session.m = 21>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfset editAddress = trim(form.edit_parameter)>
  <cfset editNote = StructKeyExists(form, "edit_note") ? trim(form.edit_note) : editAddress>

  <!--- Determine if it's a network (has /) or single IP --->
  <cfset isNetwork = Find("/", editAddress) GT 0>

  <cfif isNetwork>
    <!--- Parse network address and CIDR --->
    <cfset networkPart = ListFirst(editAddress, "/")>
    <cfset cidrPart = ListLast(editAddress, "/")>

    <!--- Validate network address --->
    <cfif NOT REFind(ipv4_pattern, networkPart)>
      <cfset session.m = 22>
      <cfset session.edit_error = "Invalid network address: " & encodeForHTML(editAddress)>
      <cflocation url="view_relay_networks.cfm" addtoken="no">
    </cfif>

    <!--- Validate CIDR (1-32) --->
    <cfif NOT IsNumeric(cidrPart) OR cidrPart LT 1 OR cidrPart GT 32>
      <cfset session.m = 22>
      <cfset session.edit_error = "Invalid CIDR mask (must be 1-32): " & encodeForHTML(editAddress)>
      <cflocation url="view_relay_networks.cfm" addtoken="no">
    </cfif>

    <!--- Normalize IP (remove leading zeros) and rebuild with CIDR --->
    <cfset editAddress = normalizeIP(networkPart) & "/" & Int(cidrPart)>
    <cfset isNetworkEntry = "1">
  <cfelse>
    <!--- Single IP address --->
    <cfif NOT REFind(ipv4_pattern, editAddress)>
      <cfset session.m = 22>
      <cfset session.edit_error = "Invalid IP address: " & encodeForHTML(editAddress)>
      <cflocation url="view_relay_networks.cfm" addtoken="no">
    </cfif>

    <!--- Normalize IP (remove leading zeros) --->
    <cfset editAddress = normalizeIP(editAddress)>
    <cfset isNetworkEntry = "0">
  </cfif>

  <!--- Get the original entry to check if IP/network changed --->
  <cfquery name="getOriginal" datasource="hermes">
    SELECT parameter FROM parameters
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <cfif getOriginal.recordcount LT 1>
    <cfset session.m = 18>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfset ipChanged = (getOriginal.parameter NEQ editAddress)>

  <!--- If IP/network changed, check for duplicates --->
  <cfif ipChanged>
    <cfquery name="checkDuplicate" datasource="hermes">
      SELECT id FROM parameters
      WHERE parameter = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
      AND parent = '#mynetworks_parent_id#'
      AND child = '1'
      AND id <> <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif checkDuplicate.recordcount GTE 1>
      <cfset session.m = 23>
      <cfset session.edit_error = encodeForHTML(editAddress)>
      <cflocation url="view_relay_networks.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Update the entry --->
  <cfif ipChanged>
    <!--- IP/network changed - mark as pending --->
    <cfquery name="update_entry" datasource="hermes">
      UPDATE parameters
      SET parameter = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">,
          note = <cfqueryparam value="#editNote#" cfsqltype="cf_sql_varchar">,
          network_entry = '#isNetworkEntry#',
          applied = '2',
          action = 'APPLY'
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      AND parent = '#mynetworks_parent_id#'
    </cfquery>
    <cfset session.m = 24>
  <cfelse>
    <!--- Only note changed - update immediately (no config change) --->
    <cfquery name="update_entry" datasource="hermes">
      UPDATE parameters
      SET note = <cfqueryparam value="#editNote#" cfsqltype="cf_sql_varchar">
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      AND parent = '#mynetworks_parent_id#'
    </cfquery>
    <cfset session.m = 19>
  </cfif>

  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: CANCEL ADD --->
<!--- ===================== --->
<cfif action is "cancel_add">
  <cfquery name="cancel_adds" datasource="hermes">
    DELETE FROM parameters
    WHERE action = 'insert'
    AND applied = '2'
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <cfset session.m = 14>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: CANCEL DELETE --->
<!--- ===================== --->
<cfif action is "cancel_delete">
  <cfquery name="cancel_deletes" datasource="hermes">
    UPDATE parameters
    SET action = 'NONE', applied = '1'
    WHERE action = 'delete'
    AND applied = '2'
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <cfset session.m = 15>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: APPLY --->
<!--- ===================== --->
<cfif action is "apply">

  <!--- Delete entries marked for deletion --->
  <cfquery name="do_deletes" datasource="hermes">
    DELETE FROM parameters
    WHERE action = 'delete'
    AND applied = '2'
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <!--- Mark pending inserts as applied --->
  <cfquery name="apply_inserts" datasource="hermes">
    UPDATE parameters
    SET applied = '1', action = 'NONE'
    WHERE action = 'insert'
    AND applied = '2'
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <!--- Mark edited entries as applied --->
  <cfquery name="apply_edits" datasource="hermes">
    UPDATE parameters
    SET applied = '1', action = 'NONE'
    WHERE action = 'APPLY'
    AND applied = '2'
    AND parent = '#mynetworks_parent_id#'
  </cfquery>

  <!--- Generate Postfix configuration and reload services --->
  <cfinclude template="./inc/generate_postfix_configuration.cfm">

  <cfset session.m = 20>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- REFRESH DATA AFTER ACTIONS --->
<!--- ===================== --->
<cfinclude template="./inc/get_relay_networks.cfm">


<!--- ERROR MESSAGES START HERE --->

<cfif m is "12">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select an entry before clicking Delete</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "13">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Entry marked for deletion. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "14">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>All pending additions have been cancelled</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "15">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>All pending deletions have been cancelled</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Please select at least one entry to delete.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "17">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput><strong>#session.bulk_delete_count#</strong> <cfif session.bulk_delete_count EQ 1>entry<cfelse>entries</cfif> marked for deletion. Click <strong>Apply Settings</strong> to confirm.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
  <cfset session.bulk_delete_count = 0>
</cfif>

<cfif m is "18">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Invalid entry selected for editing.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "19">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Entry note updated successfully.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "21">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>IP/Network field cannot be empty.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "22">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>#session.edit_error#</cfoutput>
  </div>
  <cfset session.m = 0>
  <cfset session.edit_error = "">
</cfif>

<cfif m is "23">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP/Network <strong>#session.edit_error#</strong> already exists.</cfoutput>
  </div>
  <cfset session.m = 0>
  <cfset session.edit_error = "">
</cfif>

<cfif m is "24">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Entry updated. Click <strong>Apply Settings</strong> to save changes to Postfix configuration.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "20">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Changes applied successfully. Postfix and Amavis have been reloaded.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "30">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Please enter at least one IP address or network.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "31">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>
      <strong>#session.entries_added#</strong> <cfif session.entries_added EQ 1>entry<cfelse>entries</cfif> added to pending list.
      <cfif session.entries_skipped GT 0>
        <strong>#session.entries_skipped#</strong> <cfif session.entries_skipped EQ 1>entry<cfelse>entries</cfif> skipped.
        <details class="mt-2">
          <summary>View skipped entries</summary>
          <div class="mt-1 small">#session.entry_errors#</div>
        </details>
      </cfif>
      <br>You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.
    </cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
  <cfset session.entries_added = 0>
  <cfset session.entries_skipped = 0>
  <cfset session.entry_errors = "">
</cfif>

<cfif m is "32">
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> All Entries Skipped</h4>
    <cfoutput>
      All <strong>#session.entries_skipped#</strong> <cfif session.entries_skipped EQ 1>entry was<cfelse>entries were</cfif> skipped due to errors:
      <div class="mt-2 small">#session.entry_errors#</div>
    </cfoutput>
  </div>
  <cfset session.m = 0>
  <cfset session.entries_added = 0>
  <cfset session.entries_skipped = 0>
  <cfset session.entry_errors = "">
</cfif>

<!--- ERROR MESSAGES END HERE --->


<!--- PENDING CHANGES ALERT (shown when there are pending changes but no action message) --->
<cfif m is "0" AND has_pending_changes>
  <div class="alert alert-warning">
    <h4><i class="icon fa fa-exclamation-triangle"></i> Pending Changes</h4>
    <cfoutput>You have pending changes that have not been applied. Click the <strong>Apply Settings</strong> button below to save your changes.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
</cfif>


<!--- INFORMATION CARD --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-info-circle"></i> Information</h3>
  </div>
  <div class="card-body">
    <p>Configure IP addresses and networks that are permitted to relay mail through this gateway. These are trusted sources that can send mail without authentication. Common uses include:</p>
    <ul>
      <li>Internal mail servers</li>
      <li>Printers and scanners with scan-to-email</li>
      <li>Applications that send email notifications</li>
      <li>Other trusted network devices</li>
    </ul>
    <p class="mb-0"><strong>Note:</strong> Changes are staged until you click <strong>Apply Settings</strong>. This allows you to batch multiple changes before reloading services.</p>
  </div>
</div>


<!--- ADD IP/NETWORK CARD --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Relay IP/Network</h3>
  </div>
  <div class="card-body">
    <form name="add_entries_form" method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-8">
          <label for="entries" class="form-label"><strong>IP Addresses and/or Networks</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5" placeholder="192.168.1.100 Office Printer
192.168.1.101
10.0.0.0/24 Server Network"></textarea>
          <small class="text-muted">
            Enter one entry per line. Format: <code>IP_or_Network [Note]</code> (note is optional)<br>
            Examples: <code>192.168.1.100 My Device</code> or <code>192.168.1.0/24</code>
          </small>
        </div>
        <div class="col-md-4 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Entries
          </button>
        </div>
      </div>
    </form>
  </div>
</div>


<!--- PENDING ADDITIONS CARD --->
<cfif get_pending_adds.recordcount GTE 1>
<div class="card card-warning card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-clock"></i> Pending Additions (<cfoutput>#get_pending_adds.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
      <table class="table table-bordered table-striped">
        <thead>
          <tr>
            <th>IP/Network</th>
            <th>Note</th>
            <th>Type</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_pending_adds">
          <tr>
            <td><span class="badge bg-success">+ #parameter#</span></td>
            <td>#encodeForHTML(note)#</td>
            <td><cfif network_entry is "1">Network<cfelse>IP Address</cfif></td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
    </div>
    <form method="post" class="mt-2">
      <input type="hidden" name="action" value="cancel_add">
      <button type="submit" class="btn btn-sm btn-outline-secondary" onclick="this.disabled=true;this.innerHTML='Cancelling...';this.form.submit();">
        <i class="fas fa-times"></i> Cancel All Additions
      </button>
    </form>
  </div>
</div>
</cfif>


<!--- CURRENT RELAY NETWORKS CARD --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Current Relay IPs/Networks</h3>
  </div>
  <div class="card-body">
    <cfif get_active_networks.recordcount LT 1>
      <p class="text-muted">No custom relay IPs/Networks configured. The system defaults (127.0.0.1 and internal Docker network) are always allowed.</p>
    <cfelse>
      <form id="bulkDeleteForm" method="post">
        <input type="hidden" name="action" value="bulk_delete">
        <input type="hidden" name="selected_ids" id="selected_ids" value="">

        <!--- Bulk delete button --->
        <div class="mb-3">
          <button type="button" id="deleteSelectedBtn" class="btn btn-danger btn-sm" disabled onclick="submitBulkDelete();">
            <i class="fas fa-trash"></i> Delete Selected (<span id="selectedCount">0</span>)
          </button>
        </div>

        <div class="table-responsive">
          <table id="relayNetworksTable" class="table table-bordered table-hover table-striped">
            <thead>
              <tr>
                <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
                <th style="width: 30%">IP/Network</th>
                <th style="width: 35%">Note</th>
                <th style="width: 10%">Type</th>
                <th style="width: 20%">Actions</th>
              </tr>
            </thead>
            <tbody>
              <cfoutput query="get_active_networks">
              <tr>
                <td><input type="checkbox" class="network-checkbox" value="#id#"></td>
                <td>#parameter#</td>
                <td>#encodeForHTML(note)#</td>
                <td><cfif network_entry is "1"><span class="badge bg-info">Network</span><cfelse><span class="badge bg-secondary">IP</span></cfif></td>
                <td>
                  <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#JSStringFormat(parameter)#', '#JSStringFormat(note)#');" title="Edit">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#JSStringFormat(parameter)#');" title="Delete">
                    <i class="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
              </cfoutput>
            </tbody>
          </table>
        </div>
      </form>

      <!--- Hidden form for single delete --->
      <form id="singleDeleteForm" method="post" style="display:none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="network_id" id="singleDeleteId" value="">
      </form>
    </cfif>
  </div>
</div>


<!--- PENDING DELETIONS CARD --->
<cfif get_pending_deletes.recordcount GTE 1>
<div class="card card-danger card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-trash-alt"></i> Pending Deletions (<cfoutput>#get_pending_deletes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
      <table class="table table-bordered table-striped">
        <thead>
          <tr>
            <th>IP/Network</th>
            <th>Note</th>
            <th>Type</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_pending_deletes">
          <tr class="table-danger">
            <td><span class="badge bg-danger">- #parameter#</span></td>
            <td>#encodeForHTML(note)#</td>
            <td><cfif network_entry is "1">Network<cfelse>IP Address</cfif></td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
    </div>
    <form method="post" class="mt-2">
      <input type="hidden" name="action" value="cancel_delete">
      <button type="submit" class="btn btn-sm btn-outline-secondary" onclick="this.disabled=true;this.innerHTML='Cancelling...';this.form.submit();">
        <i class="fas fa-undo"></i> Cancel All Deletions
      </button>
    </form>
  </div>
</div>
</cfif>


<!--- PENDING EDITS CARD --->
<cfif get_pending_edits.recordcount GTE 1>
<div class="card card-info card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-edit"></i> Pending Edits (<cfoutput>#get_pending_edits.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <p class="text-muted small">These entries have been modified. Click <strong>Apply Settings</strong> to update Postfix configuration.</p>
    <div class="table-responsive">
      <table class="table table-bordered table-striped">
        <thead>
          <tr>
            <th>IP/Network (New Value)</th>
            <th>Note</th>
            <th>Type</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_pending_edits">
          <tr class="table-info">
            <td><span class="badge bg-info"><i class="fas fa-edit"></i> #parameter#</span></td>
            <td>#encodeForHTML(note)#</td>
            <td><cfif network_entry is "1">Network<cfelse>IP Address</cfif></td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
    </div>
  </div>
</div>
</cfif>


      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->

</div>

<!--- EDIT MODAL --->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="editForm" method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title" id="editModalLabel">Edit Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_parameter" class="form-label"><strong>IP/Network</strong></label>
            <input type="text" class="form-control" id="edit_parameter" name="edit_parameter" required>
            <small class="text-muted">IPv4 address (e.g., 192.168.1.100) or CIDR notation (e.g., 192.168.1.0/24)</small>
          </div>
          <div class="mb-3">
            <label for="edit_note" class="form-label"><strong>Note</strong> <span class="text-muted">(optional)</span></label>
            <input type="text" class="form-control" id="edit_note" name="edit_note" maxlength="255">
          </div>
          <div class="alert alert-info mb-0">
            <small><i class="fas fa-info-circle"></i> Changing the IP/Network requires clicking <strong>Apply Settings</strong> to update Postfix configuration.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
var relayTable;
var selectedIds = new Set();

$(document).ready(function() {
  // Initialize DataTable
  relayTable = $('#relayNetworksTable').DataTable({
    dom: 'Blfrtip',
    buttons: [
      'copy', 'csv', 'excel', 'pdf', 'print'
    ],
    stateSave: true,
    lengthMenu: [
      [25, 50, 100, -1],
      ['25 rows', '50 rows', '100 rows', 'Show all']
    ],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 4] }, // Disable sorting on checkbox and actions columns
      { searchable: false, targets: [0, 4] } // Disable search on checkbox and actions columns
    ]
  });

  // Handle select all checkbox
  $('#selectAll').on('click', function() {
    var isChecked = this.checked;
    // Select/deselect all checkboxes on current page
    relayTable.rows({ page: 'current' }).nodes().each(function(row) {
      var checkbox = $(row).find('.network-checkbox');
      checkbox.prop('checked', isChecked);
      var id = checkbox.val();
      if (isChecked) {
        selectedIds.add(id);
      } else {
        selectedIds.delete(id);
      }
    });
    updateSelectedCount();
  });

  // Handle individual checkbox changes
  $('#relayNetworksTable tbody').on('change', '.network-checkbox', function() {
    var id = $(this).val();
    if (this.checked) {
      selectedIds.add(id);
    } else {
      selectedIds.delete(id);
    }
    updateSelectAllState();
    updateSelectedCount();
  });

  // Update select all state when page changes
  relayTable.on('draw', function() {
    // Restore checkbox states after redraw
    relayTable.rows().nodes().each(function(row) {
      var checkbox = $(row).find('.network-checkbox');
      var id = checkbox.val();
      checkbox.prop('checked', selectedIds.has(id));
    });
    updateSelectAllState();
  });
});

// Update select all checkbox state based on current page
function updateSelectAllState() {
  var allOnPage = relayTable.rows({ page: 'current' }).nodes();
  var checkedOnPage = 0;
  var totalOnPage = allOnPage.length;

  allOnPage.each(function(row) {
    if ($(row).find('.network-checkbox').prop('checked')) {
      checkedOnPage++;
    }
  });

  var selectAll = document.getElementById('selectAll');
  if (totalOnPage > 0) {
    selectAll.checked = checkedOnPage === totalOnPage;
    selectAll.indeterminate = checkedOnPage > 0 && checkedOnPage < totalOnPage;
  }
}

// Update selected count and enable/disable delete button
function updateSelectedCount() {
  var count = selectedIds.size;
  document.getElementById('selectedCount').textContent = count;
  document.getElementById('deleteSelectedBtn').disabled = count === 0;
}

// Submit bulk delete
function submitBulkDelete() {
  if (selectedIds.size === 0) {
    alert('Please select at least one entry to delete.');
    return;
  }

  if (!confirm('Are you sure you want to delete ' + selectedIds.size + ' selected entries?')) {
    return;
  }

  document.getElementById('selected_ids').value = Array.from(selectedIds).join(',');
  document.getElementById('bulkDeleteForm').submit();
}

// Delete single entry
function deleteSingle(id, parameter) {
  if (!confirm('Are you sure you want to delete ' + parameter + '?')) {
    return;
  }
  document.getElementById('singleDeleteId').value = id;
  document.getElementById('singleDeleteForm').submit();
}

// Open edit modal
function openEditModal(id, parameter, note) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_parameter').value = parameter;
  document.getElementById('edit_note').value = note;
  var modal = new bootstrap.Modal(document.getElementById('editModal'));
  modal.show();
}
</script>

</body>

</html>
