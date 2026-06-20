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
  <title>Hermes SEG | Add Virtual Recipient(s)</title>
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
            <h1 class="m-0">Add Virtual Recipient(s)</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_virtual_recipients.cfm">Virtual Recipients</a></li>
              <li class="breadcrumb-item active">Add</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="action" default="">
<cfparam name="errormessage" default="0">
<cfparam name="invalidemail" default="0">
<cfparam name="invalidemailrecipient" default="">
<cfparam name="invaliddomain" default="0">
<cfparam name="invaliddomainrecipient" default="">
<cfparam name="alreadyexists" default="0">
<cfparam name="alreadyexistsrecipient" default="">
<cfparam name="success" default="0">
<cfparam name="successrecipient" default="">

<cfif StructKeyExists(form, "action") AND form.action is "add">
  <cfset action = "add">
</cfif>

<!--- ACTION HANDLER --->
<cfif action is "add">
  <!--- Validate addresses field --->
  <cfif NOT StructKeyExists(form, "addresses") OR trim(form.addresses) is "">
    <cfset errormessage = 1>
  <!--- Validate delivers to field --->
  <cfelseif NOT StructKeyExists(form, "forwards_1") OR trim(form.forwards_1) is "">
    <cfset errormessage = 2>
  <cfelseif NOT IsValid("email", trim(form.forwards_1))>
    <cfset errormessage = 3>
  <cfelse>
    <cfinclude template="./inc/addvirtualrecipients.cfm">
  </cfif>
</cfif>

<!--- ALERTS --->
<cfif success GTE 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>The following #success# virtual recipients were added successfully:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>

<cfif errormessage is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Please enter at least one email address or catch-all pattern.
  </div>
</cfif>

<cfif errormessage is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>

<cfif errormessage is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field must be a valid email address.
  </div>
</cfif>

<cfif invalidemail is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
    <cfoutput>The following #invalidemail# entries had invalid email address(es):</cfoutput><br>
    <cfoutput>#invalidemailrecipient#</cfoutput>
  </div>
</cfif>

<cfif invaliddomain is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Domain</h4>
    <cfoutput>The following #invaliddomain# entries have domains the system does not relay:</cfoutput><br>
    <cfoutput>#invaliddomainrecipient#</cfoutput>
  </div>
</cfif>

<cfif alreadyexists is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
    <cfoutput>The following #alreadyexists# virtual recipients already exist:</cfoutput><br>
    <cfoutput>#alreadyexistsrecipient#</cfoutput>
  </div>
</cfif>

<!--- WARNING CALLOUT --->
<div class="callout callout-warning mb-4">
  <h5><i class="fas fa-exclamation-triangle"></i> Important</h5>
  <p class="mb-0">
    Virtual recipients bypass <strong>ALL</strong> content checking (spam, virus, banned files).
    Email is forwarded directly to the delivery address without filtering.
  </p>
</div>

<!-- ADD RECIPIENT CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Virtual Recipients</h3>
  </div>
  <div class="card-body">
    <form name="add_virtual_recipients" method="post" autocomplete="off">
      <input type="hidden" name="action" value="add">

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label for="addresses" class="form-label"><strong>Virtual Address(es)</strong></label>
            <textarea class="form-control" id="addresses" name="addresses" rows="6"
              placeholder="user@example.com
info@example.com
@example.com"></textarea>
            <small class="text-muted">
              One entry per line. Enter a full email address (e.g., <code>user@example.com</code>)
              or a catch-all pattern (e.g., <code>@example.com</code>) to forward all unmatched mail for that domain.
              The domain must exist in the system.
            </small>
          </div>
        </div>

        <div class="col-md-6">
          <div class="mb-3">
            <label for="forwards_1" class="form-label"><strong>Delivers To</strong></label>
            <input type="text" name="forwards_1" class="forwards form-control" id="forwards_1"
              placeholder="Start typing to search existing Relay Recipients or enter external address" value="" autocomplete="off">
            <small class="text-muted">
              All entries above will be delivered to this address. Start typing to search existing Relay Recipients
              or enter any valid email address.
            </small>
          </div>
        </div>
      </div>

      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-primary"
          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
          <i class="fas fa-plus"></i> Add Recipients
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
