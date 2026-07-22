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
  <title>Hermes SEG | Mail Queue</title>
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
            <h1 class="m-0">Mail Queue</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Mail Queue</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Load queue settings --->
<cfinclude template="./inc/get_mail_queue_settings.cfm">

<!--- ACTION HANDLER --->
<cfif action is not "">
  <cfinclude template="./inc/mail_queue_action.cfm">
</cfif>

<!--- Read session result variables --->
<cfparam name="session.successholdmessage" default="0">
<cfparam name="session.successholdmessage_email" default="">
<cfparam name="session.failureholdmessage" default="0">
<cfparam name="session.failureholdmessage_email" default="">
<cfparam name="session.successunholdmessage" default="0">
<cfparam name="session.successunholdmessage_email" default="">
<cfparam name="session.failureunholdmessage" default="0">
<cfparam name="session.failureunholdmessage_email" default="">
<cfparam name="session.successrequeuemessage" default="0">
<cfparam name="session.successrequeuemessage_email" default="">
<cfparam name="session.failurerequeuemessage" default="0">
<cfparam name="session.failurerequeuemessage_email" default="">
<cfparam name="session.successdeletemessage" default="0">
<cfparam name="session.successdeletemessage_email" default="">
<cfparam name="session.failuredeletemessage" default="0">
<cfparam name="session.failuredeletemessage_email" default="">

<!--- Copy to local vars and clear session --->
<cfset _sh = session.successholdmessage><cfset _she = session.successholdmessage_email>
<cfset _fh = session.failureholdmessage><cfset _fhe = session.failureholdmessage_email>
<cfset _su = session.successunholdmessage><cfset _sue = session.successunholdmessage_email>
<cfset _fu = session.failureunholdmessage><cfset _fue = session.failureunholdmessage_email>
<cfset _sr = session.successrequeuemessage><cfset _sre = session.successrequeuemessage_email>
<cfset _fr = session.failurerequeuemessage><cfset _fre = session.failurerequeuemessage_email>
<cfset _sd = session.successdeletemessage><cfset _sde = session.successdeletemessage_email>
<cfset _fd = session.failuredeletemessage><cfset _fde = session.failuredeletemessage_email>

<cfset session.m = "">
<cfset session.successholdmessage = 0><cfset session.successholdmessage_email = "">
<cfset session.failureholdmessage = 0><cfset session.failureholdmessage_email = "">
<cfset session.successunholdmessage = 0><cfset session.successunholdmessage_email = "">
<cfset session.failureunholdmessage = 0><cfset session.failureunholdmessage_email = "">
<cfset session.successrequeuemessage = 0><cfset session.successrequeuemessage_email = "">
<cfset session.failurerequeuemessage = 0><cfset session.failurerequeuemessage_email = "">
<cfset session.successdeletemessage = 0><cfset session.successdeletemessage_email = "">
<cfset session.failuredeletemessage = 0><cfset session.failuredeletemessage_email = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You must select message(s) before performing an action.
  </div>
</cfif>

<!--- Action result alerts (hold/unhold/requeue/delete) --->
<cfset _actionResults = [
  {m:3, label:"Hold", sc:_sh, se:_she, fc:_fh, fe:_fhe, verb:"held"},
  {m:4, label:"Re-queue", sc:_sr, se:_sre, fc:_fr, fe:_fre, verb:"re-queued"},
  {m:5, label:"Unhold", sc:_su, se:_sue, fc:_fu, fe:_fue, verb:"unheld"},
  {m:6, label:"Delete", sc:_sd, se:_sde, fc:_fd, fe:_fde, verb:"deleted"}
]>

<cfloop array="#_actionResults#" index="_r">
  <cfif m is _r.m>
    <cfif _r.fc GT 0>
      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fas fa-exclamation-triangle"></i> Warning</h4>
        <cfoutput>#_r.label# action completed with warnings.</cfoutput>
      </div>
    <cfelse>
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Success</h4>
        <cfoutput>#_r.label# action completed successfully.</cfoutput>
      </div>
    </cfif>
    <cfif _r.sc GT 0>
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput><strong>#_r.sc# messages were #_r.verb#:</strong><br>#_r.se#</cfoutput>
      </div>
    </cfif>
    <cfif _r.fc GT 0>
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <cfoutput><strong>#_r.fc# messages were NOT #_r.verb#:</strong><br>#_r.fe#</cfoutput>
      </div>
    </cfif>
  </cfif>
</cfloop>

<cfif m is "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Mail Queue flushed successfully. Messages that are NOT On-Hold will be retried.
  </div>
</cfif>
<cfif m is "8">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    There was a problem flushing the mail queue. Check the mail logs.
  </div>
</cfif>
<cfif m is "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Mail Queue settings saved successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "30">
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-pause"></i> Outbound Delivery Paused</h4>
    All outbound mail is now HELD in the queue &mdash; nothing will leave the box until you Resume.
  </div>
</cfif>
<cfif m is "31">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-play"></i> Outbound Delivery Resumed</h4>
    Outbound delivery is active again and the queue has been flushed &mdash; held mail is being delivered.
  </div>
</cfif>

<!-- OUTBOUND DELIVERY CONTROL CARD -->
<cfoutput>
<div class="card mb-4 <cfif OutboundPaused>card-danger<cfelse>card-success</cfif> card-outline">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-paper-plane"></i> Outbound Delivery</h3>
  </div>
  <div class="card-body">
    <cfif OutboundPaused>
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div>
          <span class="badge bg-danger" style="font-size:0.95rem;"><i class="fas fa-pause"></i> PAUSED</span>
          <span class="ms-2">Outbound mail is <strong>held in the queue</strong> &mdash; nothing is leaving this box.
          Review the queue below (delete anything you do not want sent), then resume.</span>
        </div>
        <form method="post" autocomplete="off" class="mb-0 no-preloader">
          <input type="hidden" name="action" value="resume_outbound">
          <button type="submit" class="btn btn-success"
            onclick="return confirm('Resume outbound delivery and flush the queue? All queued mail that is not On-Hold will be delivered.');">
            <i class="fas fa-play"></i> Resume Outbound Delivery
          </button>
        </form>
      </div>
    <cfelse>
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div>
          <span class="badge bg-success" style="font-size:0.95rem;"><i class="fas fa-play"></i> ACTIVE</span>
          <span class="ms-2">Outbound mail is delivering normally. Pausing holds all outgoing mail in the
          queue (e.g. maintenance windows) without affecting inbound or filtering.</span>
        </div>
        <form method="post" autocomplete="off" class="mb-0 no-preloader">
          <input type="hidden" name="action" value="pause_outbound">
          <button type="submit" class="btn btn-warning"
            onclick="return confirm('Pause outbound delivery? All outgoing mail will be held in the queue until you Resume. Inbound and filtering are unaffected.');">
            <i class="fas fa-pause"></i> Pause Outbound Delivery
          </button>
        </form>
      </div>
    </cfif>
  </div>
</div>
</cfoutput>

<!-- QUEUE SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cog"></i> Queue Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">
      <div class="row">
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Bounce Queue Lifetime (days)</strong></label>
            <cfset BounceQueueNoD = reReplace(trim(bouncequeue), "[d]", "", "ALL")>
            <select class="form-select" name="bouncequeue">
              <cfloop from="0" to="90" index="i">
                <cfoutput><option value="#i#" <cfif i is BounceQueueNoD>selected</cfif>>#i#</option></cfoutput>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Max Queue Lifetime (days)</strong></label>
            <cfset MaxQueueNoD = reReplace(trim(maxqueue), "[d]", "", "ALL")>
            <select class="form-select" name="maxqueue">
              <cfloop from="0" to="90" index="i">
                <cfoutput><option value="#i#" <cfif i is MaxQueueNoD>selected</cfif>>#i#</option></cfoutput>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            <i class="fas fa-save"></i> Save Settings
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- MAIL QUEUE CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox"></i> Mail Queue</h3>
  </div>
  <div class="card-body">

    <!--- Load queue (in-memory parsing) --->
    <cfinclude template="./inc/mail_queue_get_queue.cfm">

    <div class="mb-3">
      <a href="view_mail_queue.cfm" class="btn btn-primary">
        <i class="fas fa-sync"></i> Reload
      </a>
      <button type="button" class="btn btn-primary" onclick="showFlushModal();">
        <i class="fas fa-toilet"></i> Flush Queue
      </button>
      <div class="btn-group">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" id="actionDropdown" disabled>
          <i class="fa fa-edit"></i> Actions
        </button>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" href="#" onclick="submitAction('hold'); return false;"><i class="fas fa-pause"></i> Hold</a></li>
          <li><a class="dropdown-item" href="#" onclick="submitAction('unhold'); return false;"><i class="fas fa-play"></i> Unhold</a></li>
          <li><a class="dropdown-item" href="#" onclick="submitAction('requeue'); return false;"><i class="fas fa-redo"></i> Re-queue</a></li>
        </ul>
      </div>
      <button type="button" class="btn btn-danger" id="deleteBtn" disabled onclick="showDeleteModal();">
        <i class="fas fa-trash-alt"></i> Delete
      </button>
    </div>

    <cfif mailqueueoverload>
      <div class="callout callout-danger mb-3">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>
          <cfoutput>The Mail Queue contains <strong>#mailqueuetotalcount#</strong> messages, which exceeds the display limit of #maxQueueLoad#.
          The queue cannot be displayed to prevent system overload. Use <strong>Flush Queue</strong> to retry delivery, or manage the queue via command line:
          <code>docker exec hermes_postfix_dkim postsuper -d ALL</code> to delete all, or
          <code>docker exec hermes_postfix_dkim postsuper -H ALL</code> to unhold all.</cfoutput>
        </p>
      </div>
    <cfelseif mailqueuelimit EQ 1>
      <div class="callout callout-warning mb-3">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> The Mail Queue has more than 100 messages. Display is limited to 100.</p>
      </div>
    </cfif>

    <cfif NOT mailqueueoverload AND getqueue.recordcount GTE 1>
      <!-- Hidden form for actions -->
      <form id="actionForm" method="post" style="display:none;">
        <input type="hidden" name="action" id="actionValue" value="">
        <input type="hidden" name="msg_id" id="selectedMsgIds" value="">
      </form>

      <table id="queueTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th>View</th>
            <th>Msg ID</th>
            <th>Sender</th>
            <th>Recipient</th>
            <th>Error</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getqueue">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#encodeForHTMLAttribute(QueueID)#"></td>
              <td><a href="view_mail_queue_message.cfm?msg_id=#encodeForURL(QueueID)#" class="btn btn-sm btn-secondary" title="View"><i class="fas fa-search"></i></a></td>
              <td>#encodeForHTML(QueueID)#</td>
              <td>#encodeForHTML(Sender)#</td>
              <td>#encodeForHTML(Recipient)#</td>
              <td>#encodeForHTML(ConnectionStatus)#</td>
              <td>
                <cfif MsgStatus is "ON-HOLD">
                  <span class="badge bg-warning">ON-HOLD</span>
                <cfelseif MsgStatus is "ACTIVE">
                  <span class="badge bg-success">ACTIVE</span>
                <cfelse>
                  <span class="badge bg-secondary">#encodeForHTML(MsgStatus)#</span>
                </cfif>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    <cfelseif NOT mailqueueoverload>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> The mail queue is empty.
      </div>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- FLUSH QUEUE MODAL -->
<div class="modal fade" id="flushModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="flush">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Flush Mail Queue</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to flush the mail queue? This will attempt to re-deliver all messages that are NOT On-Hold.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-primary">Yes, Flush</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Delete Messages</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete the selected messages? This action is irreversible and may result in email loss!</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
        <button type="button" class="btn btn-danger" onclick="submitAction('delete_msg');">Yes, Delete</button>
      </div>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  $('#queueTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[2, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 1] },
      { searchable: false, targets: [0, 1] }
    ]
  });

  // Checkbox selection
  var selectedIds = new Set();

  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    });
    updateButtons();
  });

  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    updateButtons();
  });

  function updateButtons() {
    var hasSelection = selectedIds.size > 0;
    $('#actionDropdown').prop('disabled', !hasSelection);
    $('#deleteBtn').prop('disabled', !hasSelection);
  }

  // Make selectedIds accessible globally
  window.getSelectedIds = function() { return Array.from(selectedIds).join(','); };
});

function submitAction(action) {
  var ids = window.getSelectedIds();
  if (!ids && action !== 'flush') return;
  document.getElementById('actionValue').value = action;
  document.getElementById('selectedMsgIds').value = ids;
  document.getElementById('actionForm').submit();
}

function showFlushModal() {
  new bootstrap.Modal(document.getElementById('flushModal')).show();
}

function showDeleteModal() {
  if (!window.getSelectedIds()) return;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>

</body>
</html>
