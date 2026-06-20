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
  <title>Hermes SEG | Edit Virtual Recipient</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Edit Virtual Recipient</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_virtual_recipients.cfm">Virtual Recipients</a></li>
              <li class="breadcrumb-item active">Edit</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Validate URL ID parameter --->
<cfparam name="theID" default="">
<cfif StructKeyExists(url, "id") AND IsValid("integer", url.id)>
  <cfset theID = url.id>
<cfelse>
  <cfset m = "Edit Virtual Recipient: invalid or missing ID">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- Get current recipient data --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, virtual_address, maps FROM virtual_recipients
  WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getrecipient.recordcount LT 1>
  <cfset m = "Edit Virtual Recipient: record not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action") AND url.action is not "">
  <cfset action = url.action>
</cfif>

<!--- EDIT ACTION HANDLER --->
<cfif StructKeyExists(form, "action") AND form.action is "edit">
  <!--- Validate virtual address --->
  <cfset editAddress = LCase(trim(form.virtual_address))>
  <cfset editForwards = LCase(trim(form.forwards_1))>

  <cfif editAddress is "">
    <cfset session.m = 4>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
  </cfif>

  <cfif editForwards is "">
    <cfset session.m = 2>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
  </cfif>

  <cfif NOT IsValid("email", editForwards)>
    <cfset session.m = 3>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
  </cfif>

  <!--- Validate format: catch-all or full email --->
  <cfset isCatchAll = Left(editAddress, 1) is "@" AND Len(editAddress) GT 1>
  <cfif NOT isCatchAll AND NOT IsValid("email", editAddress)>
    <cfset session.m = 4>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
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
    <cfset session.m = 6>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
  </cfif>

  <!--- Check for duplicates (exclude current record) --->
  <cfquery name="checkEntry" datasource="hermes">
    SELECT id FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">
      AND maps = <cfqueryparam value="#editForwards#" cfsqltype="cf_sql_varchar">
      AND id <> <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkEntry.recordcount GTE 1>
    <cfset session.m = 5>
    <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
  </cfif>

  <!--- Update --->
  <cfquery datasource="hermes">
    UPDATE virtual_recipients
    SET virtual_address = <cfqueryparam value="#editAddress#" cfsqltype="cf_sql_varchar">,
        maps = <cfqueryparam value="#editForwards#" cfsqltype="cf_sql_varchar">,
        system = '2'
    WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfset session.m = 1>
  <cfoutput><cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no"></cfoutput>
</cfif>

<!--- Re-fetch after potential update --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, virtual_address, maps FROM virtual_recipients
  WHERE id = <cfqueryparam value="#theID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Recipient edited successfully.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field must be a valid email address.
  </div>
</cfif>
<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Virtual Address must be a valid email address or catch-all pattern (e.g., <code>@example.com</code>).
  </div>
</cfif>
<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The recipient you are attempting to save already exists.
  </div>
</cfif>
<cfif m is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain is not configured in the system.
  </div>
</cfif>

<!-- EDIT RECIPIENT CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-edit"></i> Edit Virtual Recipient</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="edit">

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label for="virtual_address" class="form-label"><strong>Virtual Address</strong></label>
            <cfoutput>
            <input type="text" class="form-control" id="virtual_address" name="virtual_address"
              value="#encodeForHTML(getrecipient.virtual_address)#" required>
            </cfoutput>
            <small class="text-muted">
              Full email address (e.g., <code>user@example.com</code>) or catch-all pattern (e.g., <code>@example.com</code>).
            </small>
          </div>
        </div>

        <div class="col-md-6">
          <div class="mb-3">
            <label for="forwards_1" class="form-label"><strong>Delivers To</strong></label>
            <cfoutput>
            <input type="text" name="forwards_1" class="forwards form-control" id="forwards_1"
              placeholder="Start typing to search existing Relay Recipients or enter external address"
              value="#encodeForHTML(getrecipient.maps)#" autocomplete="off">
            </cfoutput>
            <small class="text-muted">
              Start typing to search existing Relay Recipients or enter any valid email address.
            </small>
          </div>
        </div>
      </div>

      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-primary"
          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
          <i class="fas fa-save"></i> Save Changes
        </button>
        <a href="view_virtual_recipients.cfm" class="btn btn-secondary">
          <i class="fas fa-arrow-left"></i> Back to Virtual Recipients
        </a>
      </div>
    </form>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
$(document).ready(function(){
  $(document).on('keydown', '.forwards', function() {
    var id = this.id;
    $('#' + id).autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "./inc/getintrecipients.cfm",
          type: 'post',
          dataType: "json",
          data: { search: request.term, request: 1 },
          success: function(data) {
            response(data);
          }
        });
      },
      select: function(event, ui) {
        $(this).val(ui.item.label);
        return false;
      }
    });
  });
});
</script>

</body>
</html>
