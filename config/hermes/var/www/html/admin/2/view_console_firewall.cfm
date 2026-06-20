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
  <title>Hermes SEG | Admin Console Firewall</title>
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
            <h1 class="m-0">Admin Console Firewall</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Admin Console Firewall</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Pro Edition License Check --->
<cfinclude template="./inc/license_check.cfm" />

<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
  <cfset proFeatureName = "Admin Console Firewall">
  <cfinclude template="./inc/license_pro_required.cfm">
  <cfabort>
</cfif>

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLER --->
<cfif action is not "">
  <cfinclude template="./inc/firewall_action.cfm">
</cfif>

<!--- Load data --->
<cfquery name="checkstatus" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'firewall_status' AND module = 'firewall' AND active = '1'
</cfquery>
<cfset firewall_status = checkstatus.value2>

<cfquery name="getfirewallips" datasource="hermes">
  SELECT id, ip, note, hermesadmin, ciphermailadmin, datetime FROM firewall ORDER BY ip ASC
</cfquery>

<cfset session.m = "">

<!--- ALERTS --->
<cfset _alerts = {
  "1":{type:"danger", msg:"The IP Address you entered is invalid."},
  "2":{type:"danger", msg:"The IP Address you are attempting to edit already exists."},
  "3":{type:"danger", msg:"You cannot delete the IP you are accessing the system with while the firewall is enabled. Disable the firewall first."},
  "4":{type:"danger", msg:"You cannot edit the IP Address you are accessing the system with while the firewall is enabled. Disable the firewall first."},
  "5":{type:"danger", msg:"You cannot enable the firewall unless the IP you are accessing the system with is in the allowed list with <strong>Allow to Hermes Admin</strong> set to <strong>YES</strong>."},
  "6":{type:"danger", msg:"The IP Address you are attempting to add already exists."},
  "7":{type:"danger", msg:"The IP Address you are attempting to add is invalid."},
  "20":{type:"danger", msg:"Missing required form fields."},
  "33":{type:"success", msg:"IP Address edited and settings applied successfully."},
  "34":{type:"success", msg:"IP Address deleted and settings applied successfully."},
  "35":{type:"success", msg:"Admin Console Firewall enabled and settings applied successfully."},
  "36":{type:"success", msg:"Admin Console Firewall disabled and settings applied successfully."},
  "37":{type:"success", msg:"IP Address added and settings applied successfully."}
}>

<cfif StructKeyExists(_alerts, toString(m))>
  <cfset _a = _alerts[toString(m)]>
  <cfoutput>
  <div class="alert alert-#_a.type# alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <cfif _a.type is "success">
      <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfelse>
      <h4><i class="icon fa fa-ban"></i> Error</h4>
    </cfif>
    #_a.msg#
  </div>
  </cfoutput>
</cfif>

<!-- FIREWALL STATUS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> Firewall Status</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="setfirewall">
      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>Firewall Status</strong></label>
            <select class="form-select" name="firewall_status">
              <option value="enabled" <cfif firewall_status is "enabled">selected</cfif>>Enabled (Only Specified IP Addresses Allowed)</option>
              <option value="disabled" <cfif firewall_status is "disabled">selected</cfif>>Disabled (All IP Addresses Allowed)</option>
            </select>
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">
            <i class="fas fa-save"></i> Save &amp; Apply
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- ALLOWED IPs CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Allowed IP Addresses</h3>
  </div>
  <div class="card-body">

    <div class="callout callout-warning mb-3">
      <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> IP Addresses below are only enforced when the <strong>Firewall Status</strong> is set to <strong>Enabled</strong>. Changes are applied immediately.</p>
    </div>

    <!-- ADD IP FORM -->
    <form method="post" autocomplete="off" class="mb-4">
      <input type="hidden" name="action" value="addip">
      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>IP Address</strong></label>
            <input type="text" class="form-control" name="ip_address" placeholder="192.168.1.100" maxlength="20">
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Hermes Admin</strong></label>
            <select class="form-select" name="ip_hermesadmin">
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
            </select>
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Ciphermail Admin</strong></label>
            <select class="form-select" name="ip_ciphermailadmin">
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
            </select>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" name="ip_note" placeholder="Optional note" maxlength="255">
          </div>
        </div>
        <div class="col-md-2 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add
          </button>
        </div>
      </div>
    </form>

    <!-- IP TABLE -->
    <cfif getfirewallips.recordcount GTE 1>
      <table id="firewallTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th>IP Address</th>
            <th>Hermes Admin</th>
            <th>Ciphermail Admin</th>
            <th>Note</th>
            <th style="width: 12%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getfirewallips">
            <tr>
              <td>#encodeForHTML(ip)#</td>
              <td>
                <cfif hermesadmin is "yes"><span class="badge bg-success">YES</span>
                <cfelse><span class="badge bg-secondary">NO</span></cfif>
              </td>
              <td>
                <cfif ciphermailadmin is "yes"><span class="badge bg-success">YES</span>
                <cfelse><span class="badge bg-secondary">NO</span></cfif>
              </td>
              <td>#encodeForHTML(note)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" title="Edit"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(ip)#', '#encodeForJavaScript(note)#', '#encodeForJavaScript(hermesadmin)#', '#encodeForJavaScript(ciphermailadmin)#');">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" title="Delete"
                  onclick="openDeleteModal('#id#', '#encodeForJavaScript(ip)#');">
                  <i class="fas fa-trash-alt"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No IP addresses configured.
      </div>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- EDIT IP MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="editip">
        <input type="hidden" name="ip_id" id="edit_ip_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit IP Address</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>IP Address</strong></label>
            <input type="text" class="form-control" name="ip_address" id="edit_ip_address" maxlength="20" required>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Allow to Hermes Admin</strong></label>
            <select class="form-select" name="ip_hermesadmin" id="edit_hermesadmin">
              <option value="yes">YES</option>
              <option value="no">NO</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Allow to Ciphermail Admin</strong></label>
            <select class="form-select" name="ip_ciphermailadmin" id="edit_ciphermailadmin">
              <option value="yes">YES</option>
              <option value="no">NO</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" name="ip_note" id="edit_note" maxlength="255">
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

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="deleteip">
        <input type="hidden" name="ip_id" id="delete_ip_id" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete IP Address</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete <strong id="delete_ip_display"></strong> from the firewall? This action is irreversible!</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  $('#firewallTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[0, 'asc']],
    columnDefs: [
      { orderable: false, targets: [4] },
      { searchable: false, targets: [4] }
    ]
  });
});

function openEditModal(id, ip, note, hermesadmin, ciphermailadmin) {
  document.getElementById('edit_ip_id').value = id;
  document.getElementById('edit_ip_address').value = ip;
  document.getElementById('edit_note').value = note;
  document.getElementById('edit_hermesadmin').value = hermesadmin;
  document.getElementById('edit_ciphermailadmin').value = ciphermailadmin;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function openDeleteModal(id, ip) {
  document.getElementById('delete_ip_id').value = id;
  document.getElementById('delete_ip_display').textContent = ip;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>

</body>
</html>
