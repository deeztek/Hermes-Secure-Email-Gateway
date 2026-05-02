<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | Disclaimers</title>

<cfinclude template="./inc/html_head.cfm" />

<!--- DataTable + filter wiring --->
<script>
$(document).ready(function() {
    var table = $('#disclaimersTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[0, "asc"], [1, "asc"]]
    });

    // Scope filter dropdown -> column 0 (Scope)
    $('#filterScope').on('change', function() {
        var v = this.value;
        // exact match: ^value$ wrapped to anchor
        table.column(0).search(v ? '^' + v + '$' : '', true, false).draw();
    });
});
</script>

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

<cfinclude template="./inc/top_navbar.cfm" />
<cfinclude template="./inc/main_sidebar.cfm" />

<!-- Content Wrapper -->
<main class="app-main">
<!-- Page header -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Disclaimers</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item active">Disclaimers</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main content -->
<section class="content">
<div class="container-fluid">

<!--- PRO EDITION LICENSE CHECK (##214). license_check.cfm handles the
     specialized states first &mdash; TAMPERED, PENDING_VALIDATION,
     VIOLATION, N/A, REVOKED, INVALID, EXPIRED &mdash; each with its
     own dedicated page. If the license is healthy but the edition is
     Community (no serial, or downgraded), license_pro_required.cfm
     renders the friendly upgrade panel. --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "Email Policies > Disclaimers">
    <cfinclude template="./inc/license_pro_required.cfm">
    <cfabort>
</cfif>

<!--- LIST QUERY. Joined to recipients/mailboxes/domains is unnecessary at
     list time; scope_key is rendered as-is and resolution at send time
     happens in Amavis. Future enhancement: validate scope_key still
     exists in its source table and badge rows whose scope_key has been
     deleted. --->
<cfquery name="getDisclaimers" datasource="hermes">
    SELECT id, scope, scope_key, enabled, position, body_text, body_html, updated_at
    FROM disclaimers
    ORDER BY scope ASC, scope_key ASC
</cfquery>

<!--- ALERTS / SESSION MESSAGE --->
<cfif structKeyExists(session, "disclaimer_msg") AND session.disclaimer_msg NEQ "">
    <div class="alert alert-<cfoutput>#session.disclaimer_msg_type#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput>#session.disclaimer_msg#</cfoutput>
    </div>
    <cfset session.disclaimer_msg = "">
    <cfset session.disclaimer_msg_type = "">
</cfif>

<!-- FILTER BAR + ADD BUTTON CARD -->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-filter me-2"></i>Filter</h3>
    </div>
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-sm-4">
                <label class="form-label"><strong>Scope</strong></label>
                <select id="filterScope" class="form-select">
                    <option value="">All</option>
                    <option value="domain">Domain</option>
                    <option value="relay">Relay Recipient</option>
                </select>
            </div>
            <div class="col-sm-8 text-sm-end">
                <a href="edit_disclaimer.cfm" class="btn btn-primary">
                    <i class="fas fa-plus me-1"></i> Add Disclaimer
                </a>
            </div>
        </div>
        <small class="text-muted d-block mt-2">
            <i class="fas fa-info-circle me-1"></i>
            Use the Scope dropdown to narrow the list. Use the table's own search box (top-right of the grid) to filter by scope key (domain or address).
        </small>
    </div>
</div>

<!-- DISCLAIMERS LIST CARD -->
<div class="card card-primary card-outline mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-file-signature me-2"></i>Disclaimers</h3>
    </div>
    <div class="card-body">
        <cfif getDisclaimers.recordcount LT 1>
            <div class="alert alert-info mb-0">
                <i class="fas fa-info-circle me-1"></i>
                No disclaimers configured. Click <strong>Add Disclaimer</strong> above to create your first one. Domain-level disclaimers are the typical default; relay-recipient overrides are for compliance text on a specific upstream sender (e.g., a third-party vendor that needs additional regulatory language).
            </div>
        <cfelse>
            <div class="table-responsive">
            <table id="disclaimersTable" class="table table-bordered table-hover table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th style="width: 12%">Scope</th>
                        <th>Scope Key</th>
                        <th style="width: 10%">Enabled</th>
                        <th style="width: 10%">Position</th>
                        <th style="width: 16%">Updated</th>
                        <th style="width: 14%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getDisclaimers">
                        <tr>
                            <td>
                                <cfswitch expression="#scope#">
                                    <cfcase value="domain"><span class="badge bg-info"><i class="fas fa-globe me-1"></i>Domain</span></cfcase>
                                    <cfcase value="relay"><span class="badge bg-warning text-dark"><i class="fas fa-share me-1"></i>Relay</span></cfcase>
                                    <cfdefaultcase><span class="badge bg-secondary">#HTMLEditFormat(scope)#</span></cfdefaultcase>
                                </cfswitch>
                            </td>
                            <td><code>#HTMLEditFormat(scope_key)#</code></td>
                            <td>
                                <cfif Val(enabled) EQ 1>
                                    <span class="badge bg-success">Enabled</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Disabled</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif position EQ "prepend">
                                    <span class="badge bg-secondary">Prepend</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Append</span>
                                </cfif>
                            </td>
                            <td>#DateTimeFormat(updated_at, "yyyy-mm-dd HH:nn")#</td>
                            <td>
                                <a href="edit_disclaimer.cfm?id=#id#" class="btn btn-sm btn-primary" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-sm btn-danger"
                                    onclick="if(confirm('Delete the #scope# disclaimer for ' + #JSStringFormat(scope_key)# + '?')) { window.location='disclaimer_delete.cfm?id=#id#'; }"
                                    title="Delete">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
            </div>
        </cfif>
    </div>
</div>

</div>
</section>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div>
</body>
</html>
