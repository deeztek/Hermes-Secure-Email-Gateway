<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

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
  <title>Hermes SEG | Edit Backend Server</title>

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
            <h1 class="m-0">Edit Backend Server</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_internal_recipients.cfm">Internal Recipients</a></li>
              <li class="breadcrumb-item active">Edit Backend</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!--- PARAMETER VALIDATION --->
<cfparam name="m" default="0">
<cfif StructKeyExists(session, "backendMessage")>
    <cfset m = session.backendMessage>
    <cfset StructDelete(session, "backendMessage")>
</cfif>

<cfparam name="ids" default="">
<cfif StructKeyExists(url, "ids")>
    <cfset ids = url.ids>
<cfelseif StructKeyExists(form, "ids")>
    <cfset ids = form.ids>
</cfif>

<!--- Validate IDs --->
<cfif ids EQ "">
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">No recipients selected. Please select at least one recipient.</p>
    </div>
    <a href="view_internal_recipients.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back to Recipients</a>
    <cfabort>
</cfif>

<!--- Split IDs into array and validate each is integer --->
<cfset idArray = ListToArray(ids)>
<cfset validIds = []>
<cfloop array="#idArray#" item="thisId">
    <cfif IsValid("integer", thisId)>
        <cfset ArrayAppend(validIds, thisId)>
    </cfif>
</cfloop>

<cfif ArrayLen(validIds) EQ 0>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Invalid recipient IDs provided.</p>
    </div>
    <a href="view_internal_recipients.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back to Recipients</a>
    <cfabort>
</cfif>

<!--- Get selected recipients --->
<cfquery name="getSelectedRecipients" datasource="hermes">
    SELECT id, recipient, backend_server, backend_port, backend_tls
    FROM recipients
    WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
    ORDER BY recipient
</cfquery>

<cfif getSelectedRecipients.recordcount LT 1>
    <div class="alert alert-danger">
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        <p class="mb-0">Selected recipients not found.</p>
    </div>
    <a href="view_internal_recipients.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back to Recipients</a>
    <cfabort>
</cfif>

<!--- PROCESS FORM SUBMISSION --->
<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
    <cfset action = form.action>
</cfif>

<cfif action EQ "save">
    <cfparam name="backend_type" default="default">
    <cfif StructKeyExists(form, "backend_type")>
        <cfset backend_type = form.backend_type>
    </cfif>

    <cfif backend_type EQ "default">
        <!--- Clear backend override (set to NULL) --->
        <cfquery datasource="hermes">
            UPDATE recipients
            SET backend_server = NULL,
                backend_port = NULL,
                backend_tls = NULL
            WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
        </cfquery>
        <cfset session.backendMessage = "success_default">
        <cflocation url="view_internal_recipients.cfm" addtoken="no">

    <cfelseif backend_type EQ "custom">
        <!--- Validate custom backend fields --->
        <cfparam name="custom_server" default="">
        <cfparam name="custom_port" default="25">
        <cfparam name="custom_tls" default="may">

        <cfif StructKeyExists(form, "custom_server")>
            <cfset custom_server = Trim(form.custom_server)>
        </cfif>
        <cfif StructKeyExists(form, "custom_port")>
            <cfset custom_port = form.custom_port>
        </cfif>
        <cfif StructKeyExists(form, "custom_tls")>
            <cfset custom_tls = form.custom_tls>
        </cfif>

        <!--- Validate server --->
        <cfif custom_server EQ "">
            <cfset m = "error_server_empty">
        <cfelseif NOT IsValid("integer", custom_port) OR custom_port LT 1 OR custom_port GT 65535>
            <cfset m = "error_port_invalid">
        <cfelseif NOT ListFindNoCase("none,may,encrypt", custom_tls)>
            <cfset m = "error_tls_invalid">
        <cfelse>
            <!--- Save custom backend override --->
            <cfquery datasource="hermes">
                UPDATE recipients
                SET backend_server = <cfqueryparam value="#custom_server#" cfsqltype="cf_sql_varchar">,
                    backend_port = <cfqueryparam value="#custom_port#" cfsqltype="cf_sql_integer">,
                    backend_tls = <cfqueryparam value="#custom_tls#" cfsqltype="cf_sql_varchar">
                WHERE id IN (<cfqueryparam value="#ArrayToList(validIds)#" cfsqltype="cf_sql_integer" list="true">)
            </cfquery>
            <cfset session.backendMessage = "success_custom">
            <cflocation url="view_internal_recipients.cfm" addtoken="no">
        </cfif>
    </cfif>
</cfif>

<!--- ERROR/SUCCESS MESSAGES --->
<cfif m EQ "error_server_empty">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Backend Server field cannot be empty when using custom backend.
    </div>
</cfif>

<cfif m EQ "error_port_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        The Port must be a valid number between 1 and 65535.
    </div>
</cfif>

<cfif m EQ "error_tls_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h5><i class="icon fas fa-ban"></i> Error</h5>
        Invalid TLS setting selected.
    </div>
</cfif>

<!--- BACK BUTTON --->
<p>
    <a href="view_internal_recipients.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back to Recipients</a>
</p>

<!--- SELECTED RECIPIENTS CARD --->
<div class="card card-outline card-info mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-users me-2"></i>Selected Recipients (<cfoutput>#getSelectedRecipients.recordcount#</cfoutput>)</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <cfoutput query="getSelectedRecipients">
                <div class="col-md-4 col-sm-6 mb-2">
                    <span class="badge bg-secondary me-1"><i class="fas fa-envelope me-1"></i>#recipient#</span>
                    <cfif Len(Trim(backend_server)) GT 0>
                        <small class="text-primary">(#backend_server#:#backend_port#)</small>
                    <cfelse>
                        <small class="text-muted">(domain default)</small>
                    </cfif>
                </div>
            </cfoutput>
        </div>
    </div>
</div>

<!--- BACKEND SETTINGS FORM --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-server me-2"></i>Backend Server Settings</h3>
    </div>
    <div class="card-body">
        <form method="post" action="">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="ids" value="<cfoutput>#ArrayToList(validIds)#</cfoutput>">

            <div class="mb-3">
                <label class="form-label"><strong>Backend Server</strong></label>

                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_default" value="default" checked>
                    <label class="form-check-label" for="backend_default">
                        <strong>Use Domain Default</strong>
                        <br><small class="text-muted">Route to the backend server configured in the recipient's domain settings</small>
                    </label>
                </div>

                <div class="form-check">
                    <input class="form-check-input" type="radio" name="backend_type" id="backend_custom" value="custom">
                    <label class="form-check-label" for="backend_custom">
                        <strong>Custom Backend Server</strong>
                        <br><small class="text-muted">Override domain default with a specific backend server for these recipients</small>
                    </label>
                </div>
            </div>

            <!--- Custom backend fields (shown/hidden via JS) --->
            <div id="custom_backend_fields" style="display: none; padding-left: 25px; border-left: 3px solid #007bff;">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="custom_server" class="form-label"><strong>Server Address</strong></label>
                        <input type="text" class="form-control" id="custom_server" name="custom_server" placeholder="e.g., mail.example.com or 192.168.1.10">
                        <small class="text-muted">FQDN or IP address of the backend mail server</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_port" class="form-label"><strong>Port</strong></label>
                        <input type="number" class="form-control" id="custom_port" name="custom_port" value="25" min="1" max="65535">
                        <small class="text-muted">SMTP port (default: 25)</small>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="custom_tls" class="form-label"><strong>TLS Mode</strong></label>
                        <select class="form-control" id="custom_tls" name="custom_tls">
                            <option value="may" selected>May (Opportunistic)</option>
                            <option value="encrypt">Encrypt (Required)</option>
                            <option value="none">None (Disabled)</option>
                        </select>
                        <small class="text-muted">TLS encryption mode</small>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Saving...';this.form.submit();">
                    <i class="fas fa-save me-1"></i>Save Changes
                </button>
                <a href="view_internal_recipients.cfm" class="btn btn-secondary ms-2">
                    <i class="fas fa-times me-1"></i>Cancel
                </a>
            </div>
        </form>
    </div>
</div>

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

<cfinclude template="./inc/main_footer.cfm" />

</div><!-- ./app-wrapper -->

<!--- JavaScript for showing/hiding custom backend fields --->
<script>
$(document).ready(function() {
    // Show/hide custom fields based on radio selection
    $('input[name="backend_type"]').on('change', function() {
        if ($(this).val() === 'custom') {
            $('#custom_backend_fields').slideDown();
        } else {
            $('#custom_backend_fields').slideUp();
        }
    });
});
</script>

</body>
</html>
