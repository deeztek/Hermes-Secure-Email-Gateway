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

<!--- GET RELAY NETWORKS DATA --->
<cfinclude template="./inc/get_relay_networks.cfm">


<!--- ===================== --->
<!--- ACTION: ADD IP --->
<!--- ===================== --->
<cfif action is "add_ip">
  <cfset step = 0>

  <!--- Validate IP address --->
  <cfif NOT StructKeyExists(form, "ip_address") OR trim(form.ip_address) is "">
    <cfset session.m = 1>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfif NOT REFind(ipv4_pattern, trim(form.ip_address))>
    <cfset session.m = 2>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Validate note --->
  <cfif NOT StructKeyExists(form, "note") OR trim(form.note) is "">
    <cfset session.m = 3>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfif REFind("[^_a-zA-Z0-9\-\.]", form.note) GT 0>
    <cfset session.m = 4>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Check if already exists --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT id FROM parameters
    WHERE parameter = <cfqueryparam value="#trim(form.ip_address)#" cfsqltype="cf_sql_varchar">
    AND parent = '#mynetworks_parent_id#'
    AND child = '1'
  </cfquery>

  <cfif checkexists.recordcount GTE 1>
    <cfset session.m = 5>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Get max order --->
  <cfquery name="getmaxorder" datasource="hermes">
    SELECT COALESCE(MAX(order1), 0) as maximum FROM parameters WHERE parent='#mynetworks_parent_id#' AND child='1'
  </cfquery>
  <cfset nextorder = getmaxorder.maximum + 1>

  <!--- Insert new IP address --->
  <cfquery name="add_ip" datasource="hermes">
    INSERT INTO parameters (parameter, module, editable, conf_file, parent, parent_name, child, order1, enabled, applied, action, network_entry, note)
    VALUES (
      <cfqueryparam value="#trim(form.ip_address)#" cfsqltype="cf_sql_varchar">,
      'postfix', '1', 'main.cf', '#mynetworks_parent_id#', 'mynetworks', '1', '#nextorder#', '1', '2', 'insert', '0',
      <cfqueryparam value="#trim(form.note)#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cfset session.m = 10>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: ADD NETWORK --->
<!--- ===================== --->
<cfif action is "add_network">
  <cfset step = 0>

  <!--- Validate network address --->
  <cfif NOT StructKeyExists(form, "network_address") OR trim(form.network_address) is "">
    <cfset session.m = 6>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfif NOT REFind(ipv4_pattern, trim(form.network_address))>
    <cfset session.m = 7>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Validate subnet --->
  <cfif NOT StructKeyExists(form, "subnet") OR trim(form.subnet) is "">
    <cfset session.m = 8>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Validate note --->
  <cfif NOT StructKeyExists(form, "network_note") OR trim(form.network_note) is "">
    <cfset session.m = 3>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfif REFind("[^_a-zA-Z0-9\-\.]", form.network_note) GT 0>
    <cfset session.m = 4>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <cfset theNetwork = "#trim(form.network_address)#/#trim(form.subnet)#">

  <!--- Check if already exists --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT id FROM parameters
    WHERE parameter = <cfqueryparam value="#theNetwork#" cfsqltype="cf_sql_varchar">
    AND parent = '#mynetworks_parent_id#'
    AND child = '1'
  </cfquery>

  <cfif checkexists.recordcount GTE 1>
    <cfset session.m = 9>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Get max order --->
  <cfquery name="getmaxorder" datasource="hermes">
    SELECT COALESCE(MAX(order1), 0) as maximum FROM parameters WHERE parent='#mynetworks_parent_id#' AND child='1'
  </cfquery>
  <cfset nextorder = getmaxorder.maximum + 1>

  <!--- Insert new network --->
  <cfquery name="add_network" datasource="hermes">
    INSERT INTO parameters (parameter, module, editable, conf_file, parent, parent_name, child, order1, enabled, applied, action, network_entry, note)
    VALUES (
      <cfqueryparam value="#theNetwork#" cfsqltype="cf_sql_varchar">,
      'postfix', '1', 'main.cf', '#mynetworks_parent_id#', 'mynetworks', '1', '#nextorder#', '1', '2', 'insert', '1',
      <cfqueryparam value="#trim(form.network_note)#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cfset session.m = 11>
  <cflocation url="view_relay_networks.cfm" addtoken="no">
</cfif>


<!--- ===================== --->
<!--- ACTION: BULK IMPORT --->
<!--- ===================== --->
<cfif action is "bulk_import">
  <cfset bulk_added = 0>
  <cfset bulk_skipped = 0>
  <cfset bulk_errors = "">

  <!--- Validate bulk_entries exists and is not empty --->
  <cfif NOT StructKeyExists(form, "bulk_entries") OR trim(form.bulk_entries) is "">
    <cfset session.m = 30>
    <cflocation url="view_relay_networks.cfm" addtoken="no">
  </cfif>

  <!--- Normalize line endings and split into lines --->
  <cfset bulkText = Replace(form.bulk_entries, Chr(13) & Chr(10), Chr(10), "ALL")>
  <cfset bulkText = Replace(bulkText, Chr(13), Chr(10), "ALL")>
  <cfset lines = ListToArray(bulkText, Chr(10))>

  <cfloop array="#lines#" index="line">
    <cfset line = trim(line)>

    <!--- Skip empty lines --->
    <cfif line is "">
      <cfcontinue>
    </cfif>

    <!--- Parse line: first part is IP/Network, rest is note --->
    <cfset firstSpace = Find(" ", line)>
    <cfif firstSpace GT 0>
      <cfset entryAddress = trim(Left(line, firstSpace - 1))>
      <cfset entryNote = trim(Mid(line, firstSpace + 1, Len(line)))>
    <cfelse>
      <!--- No space found, entire line is address with no note --->
      <cfset bulk_skipped = bulk_skipped + 1>
      <cfset bulk_errors = bulk_errors & "Line missing note: " & line & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Validate note --->
    <cfif entryNote is "" OR REFind("[^_a-zA-Z0-9\-\.]", entryNote) GT 0>
      <cfset bulk_skipped = bulk_skipped + 1>
      <cfset bulk_errors = bulk_errors & "Invalid note for: " & entryAddress & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Determine if it's a network (has /) or single IP --->
    <cfset isNetwork = Find("/", entryAddress) GT 0>

    <cfif isNetwork>
      <!--- Parse network address and CIDR --->
      <cfset networkPart = ListFirst(entryAddress, "/")>
      <cfset cidrPart = ListLast(entryAddress, "/")>

      <!--- Validate network address --->
      <cfif NOT REFind(ipv4_pattern, networkPart)>
        <cfset bulk_skipped = bulk_skipped + 1>
        <cfset bulk_errors = bulk_errors & "Invalid network address: " & entryAddress & "<br>">
        <cfcontinue>
      </cfif>

      <!--- Validate CIDR (1-32) --->
      <cfif NOT IsNumeric(cidrPart) OR cidrPart LT 1 OR cidrPart GT 32>
        <cfset bulk_skipped = bulk_skipped + 1>
        <cfset bulk_errors = bulk_errors & "Invalid CIDR mask: " & entryAddress & "<br>">
        <cfcontinue>
      </cfif>

      <cfset theEntry = entryAddress>
      <cfset isNetworkEntry = "1">

    <cfelse>
      <!--- Single IP address --->
      <cfif NOT REFind(ipv4_pattern, entryAddress)>
        <cfset bulk_skipped = bulk_skipped + 1>
        <cfset bulk_errors = bulk_errors & "Invalid IP address: " & entryAddress & "<br>">
        <cfcontinue>
      </cfif>

      <cfset theEntry = entryAddress>
      <cfset isNetworkEntry = "0">
    </cfif>

    <!--- Check if already exists --->
    <cfquery name="checkexists_bulk" datasource="hermes">
      SELECT id FROM parameters
      WHERE parameter = <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">
      AND parent = '#mynetworks_parent_id#'
      AND child = '1'
    </cfquery>

    <cfif checkexists_bulk.recordcount GTE 1>
      <cfset bulk_skipped = bulk_skipped + 1>
      <cfset bulk_errors = bulk_errors & "Already exists: " & theEntry & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Get max order --->
    <cfquery name="getmaxorder_bulk" datasource="hermes">
      SELECT COALESCE(MAX(order1), 0) as maximum FROM parameters WHERE parent='#mynetworks_parent_id#' AND child='1'
    </cfquery>
    <cfset nextorder_bulk = getmaxorder_bulk.maximum + 1>

    <!--- Insert the entry --->
    <cfquery name="add_bulk" datasource="hermes">
      INSERT INTO parameters (parameter, module, editable, conf_file, parent, parent_name, child, order1, enabled, applied, action, network_entry, note)
      VALUES (
        <cfqueryparam value="#theEntry#" cfsqltype="cf_sql_varchar">,
        'postfix', '1', 'main.cf', '#mynetworks_parent_id#', 'mynetworks', '1', '#nextorder_bulk#', '1', '2', 'insert', '#isNetworkEntry#',
        <cfqueryparam value="#entryNote#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>

    <cfset bulk_added = bulk_added + 1>

  </cfloop>

  <!--- Store results in session for display --->
  <cfset session.bulk_added = bulk_added>
  <cfset session.bulk_skipped = bulk_skipped>
  <cfset session.bulk_errors = bulk_errors>

  <cfif bulk_added GT 0>
    <cfset session.m = 31>
  <cfelseif bulk_skipped GT 0>
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

<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address field cannot be empty</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address is not valid. Please enter a valid IPv4 address (e.g., 192.168.1.100)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Note field cannot be empty</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Note field can only contain letters, numbers, dashes (-), underscores (_), and periods (.)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address you are attempting to add already exists</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Network Address field cannot be empty</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "7">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Network Address is not valid. Please enter a valid IPv4 address (e.g., 192.168.1.0)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "8">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Please select a network mask</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "9">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Network you are attempting to add already exists</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "10">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>IP Address added to pending list. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "11">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Network added to pending list. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
      <div class="text-center">
        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">Apply Settings</button>
      </div>
    </form>
  </div>
  <cfset session.m = 0>
</cfif>

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
    <cfoutput>The bulk import field cannot be empty. Please enter at least one entry.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "31">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Bulk Import Successful!</h4>
    <cfoutput>
      <strong>#session.bulk_added#</strong> entries added to pending list.
      <cfif session.bulk_skipped GT 0>
        <strong>#session.bulk_skipped#</strong> entries skipped.
        <details class="mt-2">
          <summary>View skipped entries</summary>
          <div class="mt-1 small">#session.bulk_errors#</div>
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
  <cfset session.bulk_added = 0>
  <cfset session.bulk_skipped = 0>
  <cfset session.bulk_errors = "">
</cfif>

<cfif m is "32">
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Bulk Import - All Entries Skipped</h4>
    <cfoutput>
      All <strong>#session.bulk_skipped#</strong> entries were skipped due to errors:
      <div class="mt-2 small">#session.bulk_errors#</div>
    </cfoutput>
  </div>
  <cfset session.m = 0>
  <cfset session.bulk_added = 0>
  <cfset session.bulk_skipped = 0>
  <cfset session.bulk_errors = "">
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

    <!--- Nav tabs --->
    <ul class="nav nav-tabs" id="addTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="ip-tab" data-bs-toggle="tab" data-bs-target="#ip-pane" type="button" role="tab" aria-controls="ip-pane" aria-selected="true">
          <i class="fas fa-desktop"></i> IP Address
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="network-tab" data-bs-toggle="tab" data-bs-target="#network-pane" type="button" role="tab" aria-controls="network-pane" aria-selected="false">
          <i class="fas fa-network-wired"></i> Network
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="bulk-tab" data-bs-toggle="tab" data-bs-target="#bulk-pane" type="button" role="tab" aria-controls="bulk-pane" aria-selected="false">
          <i class="fas fa-list"></i> Bulk Import
        </button>
      </li>
    </ul>

    <!--- Tab content --->
    <div class="tab-content mt-3" id="addTabContent">

      <!--- IP Address Tab --->
      <div class="tab-pane fade show active" id="ip-pane" role="tabpanel" aria-labelledby="ip-tab">
        <form name="add_ip_form" method="post" autocomplete="off">
          <input type="hidden" name="action" value="add_ip">
          <div class="row">
            <div class="col-md-4">
              <label for="ip_address" class="form-label"><strong>IP Address</strong></label>
              <input type="text" class="form-control" id="ip_address" name="ip_address" placeholder="e.g., 192.168.1.100" maxlength="45">
            </div>
            <div class="col-md-4">
              <label for="note" class="form-label"><strong>Note</strong></label>
              <input type="text" class="form-control" id="note" name="note" placeholder="e.g., Office-Printer" maxlength="255">
              <small class="text-muted">Letters, numbers, dashes, underscores, periods only</small>
            </div>
            <div class="col-md-2 d-flex align-items-end">
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
                <i class="fas fa-plus"></i> Add IP
              </button>
            </div>
          </div>
        </form>
      </div>

      <!--- Network Tab --->
      <div class="tab-pane fade" id="network-pane" role="tabpanel" aria-labelledby="network-tab">
        <form name="add_network_form" method="post" autocomplete="off">
          <input type="hidden" name="action" value="add_network">
          <div class="row">
            <div class="col-md-3">
              <label for="network_address" class="form-label"><strong>Network Address</strong></label>
              <input type="text" class="form-control" id="network_address" name="network_address" placeholder="e.g., 192.168.1.0" maxlength="45">
            </div>
            <div class="col-md-2">
              <label for="subnet" class="form-label"><strong>Mask</strong></label>
              <select class="form-select" id="subnet" name="subnet">
                <cfoutput query="get_subnets">
                <option value="#value3#">#mask#</option>
                </cfoutput>
              </select>
            </div>
            <div class="col-md-3">
              <label for="network_note" class="form-label"><strong>Note</strong></label>
              <input type="text" class="form-control" id="network_note" name="network_note" placeholder="e.g., Office-LAN" maxlength="255">
            </div>
            <div class="col-md-2 d-flex align-items-end">
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
                <i class="fas fa-plus"></i> Add Network
              </button>
            </div>
          </div>
        </form>
      </div>

      <!--- Bulk Import Tab --->
      <div class="tab-pane fade" id="bulk-pane" role="tabpanel" aria-labelledby="bulk-tab">
        <form name="bulk_import_form" method="post" autocomplete="off">
          <input type="hidden" name="action" value="bulk_import">
          <div class="row">
            <div class="col-md-8">
              <label for="bulk_entries" class="form-label"><strong>IP Addresses and Networks</strong></label>
              <textarea class="form-control" id="bulk_entries" name="bulk_entries" rows="8" placeholder="Enter one entry per line. Examples:
192.168.1.100 Office-Printer
192.168.1.101 Scanner
10.0.0.0/24 Server-Network
172.16.0.0/16 VPN-Clients"></textarea>
              <small class="text-muted">
                Format: <code>IP_or_Network Note</code> (one per line)<br>
                - Single IP: <code>192.168.1.100 My-Device</code><br>
                - Network with CIDR: <code>192.168.1.0/24 Office-LAN</code><br>
                - Note is required and can only contain letters, numbers, dashes, underscores, and periods
              </small>
            </div>
            <div class="col-md-4 d-flex align-items-end">
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Importing...';this.form.submit();">
                <i class="fas fa-file-import"></i> Import All
              </button>
            </div>
          </div>
        </form>
      </div>

    </div>
    <!--- /tab-content --->

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
            <td>#note#</td>
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
      <div class="table-responsive">
        <table class="table table-bordered table-hover">
          <thead>
            <tr>
              <th style="width: 40%">IP/Network</th>
              <th style="width: 40%">Note</th>
              <th style="width: 10%">Type</th>
              <th style="width: 10%">Action</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="get_active_networks">
            <tr>
              <td>#parameter#</td>
              <td>#note#</td>
              <td><cfif network_entry is "1"><span class="badge bg-info">Network</span><cfelse><span class="badge bg-secondary">IP</span></cfif></td>
              <td>
                <form method="post" style="display:inline;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="network_id" value="#id#">
                  <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete #parameter#?');">
                    <i class="fas fa-trash"></i>
                  </button>
                </form>
              </td>
            </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
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
            <td>#note#</td>
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




      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->

</div>
</body>

</html>
