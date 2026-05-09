<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.
--->

<!---
ORGANIZATIONAL SIGNATURES LIST (#226 Phase 2A)

Pro-only admin page. Lists every org_signatures row joined to the
domains row that owns it, grouped by domain in the visual order. A
NULL department_label is the domain default; non-NULL labels are
per-department variants that override the default for users whose
mailboxes.department matches.

Mirrors view_disclaimers.cfm in shape (license check, DataTable, alert
flash, scope-style filter) so admins coming from Disclaimers find a
familiar layout.
--->

<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Email Policies | Organizational Signatures</title>

<cfinclude template="./inc/html_head.cfm" />

<script>
$(document).ready(function () {
    var table = $('#orgSignaturesTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        order: [[0, 'asc'], [1, 'asc']]
    });

    // Domain filter -> column 0 (Domain)
    $('#filterDomain').on('change', function () {
        var v = this.value;
        table.column(0).search(v ? '^' + v + '$' : '', true, false).draw();
    });
});
</script>
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
                <h1 class="m-0">Organizational Signatures</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="##">Email Policies</a></li>
                    <li class="breadcrumb-item active">Organizational Signatures</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<section class="content">
<div class="container-fluid">

<!--- Pro license gate. Same pattern as Disclaimers. --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "Email Policies > Organizational Signatures">
    <cfinclude template="./inc/license_pro_required.cfm">
    <cfabort>
</cfif>

<!--- LIST QUERY. JOIN domains for human-readable domain name; LEFT JOIN
     so that an org_signature row pointing at a deleted domain (race
     condition) still renders with NULL domain so the admin can clean
     it up. --->
<cfquery name="getOrgSigs" datasource="hermes">
    SELECT os.id, os.domain_id, os.department_label, os.template_key,
           os.enabled, os.updated_at,
           d.domain
    FROM org_signatures os
    LEFT JOIN domains d ON d.id = os.domain_id
    ORDER BY d.domain ASC,
             CASE WHEN os.department_label IS NULL THEN 0 ELSE 1 END ASC,
             os.department_label ASC
</cfquery>

<!--- Pull distinct domains for the filter dropdown so admins of
     multi-domain installs can narrow to one tenant at a time. --->
<cfquery name="getFilterDomains" datasource="hermes">
    SELECT DISTINCT d.domain
    FROM org_signatures os
    JOIN domains d ON d.id = os.domain_id
    ORDER BY d.domain ASC
</cfquery>

<!--- Friendly template_key -> display name map. The list page only
     needs the labels, so loading template metadata once and caching
     the keys -> name mapping is cheaper than including the full
     loader. Falls back to the raw key if the template file is missing
     so old rows pointing at a deleted template still render. --->
<cfinclude template="./inc/org_signature_template_loader.cfm" />
<cfset templateNames = {}>
<cfloop array="#variables.orgSignatureTemplateRegistry#" index="tmplKey">
    <cfset tmplPath = variables.orgSignatureTemplateDir & tmplKey & ".cfm">
    <cfif FileExists(tmplPath)>
        <cfset template = {}>
        <cfinclude template="inc/org_signature_templates/#tmplKey#.cfm" />
        <cfif StructKeyExists(template, "name")>
            <cfset templateNames[tmplKey] = template.name>
        </cfif>
    </cfif>
</cfloop>

<cfif structKeyExists(session, "org_sig_msg") AND session.org_sig_msg NEQ "">
    <div class="alert alert-<cfoutput>#session.org_sig_msg_type#</cfoutput> alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput>#session.org_sig_msg#</cfoutput>
    </div>
    <cfset session.org_sig_msg = "">
    <cfset session.org_sig_msg_type = "">
</cfif>

<div class="card card-primary card-outline mb-4">
    <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-id-card me-2"></i>Organizational Signatures</h3>
    </div>
    <div class="card-body">

        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
            <a href="edit_org_signature.cfm" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i> Add Organizational Signature
            </a>
            <cfif getFilterDomains.recordcount GT 1>
                <div class="d-flex align-items-center gap-2">
                    <label for="filterDomain" class="form-label mb-0 small"><strong>Filter by Domain:</strong></label>
                    <select id="filterDomain" class="form-select form-select-sm" style="width: auto;">
                        <option value="">All</option>
                        <cfoutput query="getFilterDomains">
                            <option value="#HTMLEditFormat(domain)#">#HTMLEditFormat(domain)#</option>
                        </cfoutput>
                    </select>
                </div>
            </cfif>
        </div>
        <small class="text-muted d-block mb-3">
            <i class="fas fa-info-circle me-1"></i>
            One default signature per domain (no Department), plus optional per-department variants. The body milter resolves at send time using the recipient's <code>mailboxes.department</code>: department-specific row first, domain default if no match.
        </small>

        <cfif getOrgSigs.recordcount LT 1>
            <div class="alert alert-info mb-0">
                <i class="fas fa-info-circle me-1"></i>
                No organizational signatures configured. Click <strong>Add Organizational Signature</strong> above to create one. Most installs start with a per-domain default and add per-department variants later as branding needs evolve.
            </div>
        <cfelse>
            <div class="table-responsive">
            <table id="orgSignaturesTable" class="table table-bordered table-hover table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th>Domain</th>
                        <th>Department</th>
                        <th>Template</th>
                        <th style="width: 10%">Enabled</th>
                        <th style="width: 16%">Updated</th>
                        <th style="width: 14%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getOrgSigs">
                        <tr>
                            <td>
                                <cfif Len(domain)>
                                    <code>#HTMLEditFormat(domain)#</code>
                                <cfelse>
                                    <span class="badge bg-danger" title="The domain that owned this signature has been deleted">orphaned</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif Len(department_label)>
                                    <span class="badge bg-info">#HTMLEditFormat(department_label)#</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Domain default</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif StructKeyExists(templateNames, template_key)>
                                    #HTMLEditFormat(templateNames[template_key])#
                                <cfelse>
                                    <span class="text-warning"><i class="fas fa-exclamation-triangle me-1"></i>#HTMLEditFormat(template_key)# (missing)</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif Val(enabled) EQ 1>
                                    <span class="badge bg-success">Enabled</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Disabled</span>
                                </cfif>
                            </td>
                            <td>#DateTimeFormat(updated_at, "yyyy-mm-dd HH:nn")#</td>
                            <td>
                                <a href="edit_org_signature.cfm?id=#id#" class="btn btn-sm btn-primary" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-sm btn-danger"
                                    onclick="if(confirm('Delete the #(Len(department_label) ? department_label : 'domain default')# signature for #JSStringFormat(domain)#?')) { window.location='org_signature_delete.cfm?id=#id#'; }"
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
