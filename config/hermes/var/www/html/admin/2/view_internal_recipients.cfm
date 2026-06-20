<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
  <title>Hermes SEG | Relay Recipients</title>

  <cfinclude template="./inc/html_head.cfm" />
<!--- Sort Table Script Default Sort by Column 4 Desc --->


<!--- Sort Table Script  --->
<script>
  $(document).ready(function() {
      $('#sortTable').DataTable( {
        dom: 'Blfrtip',
          buttons: [
              'copy', 'csv', 'excel', 'pdf', 'print'
          ],
          stateSave: true,
          lengthMenu: [
            [ 25, 50, 100, -1 ],
      [ '25 rows', '50 rows', '100 rows', 'Show all' ]
  
      ],
      
          "order": [[ 3, "asc" ]]
      } );
  } );
    </script>

  

<script>

  $(document).ready(function() {
    $("#delete").click(function() {
      var deleterecipient = [];
      $.each($("input[name='id']:checked"), function() {
        deleterecipient.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="recipient_id" value=' + deleterecipient + '>');
      });
    });
  });
  
  </script>

<!---
<script>

  $(document).ready(function() {
    $("#edit").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#edit_modal').modal('show').on('shown.bs.modal', function() {
      $("#editid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });
  
  </script>
--->

<script>

  // Edit Options click handler.
  // Single selection: AJAX pre-fill the modal with the recipient's current
  // settings, including enforce_mfa (#225 Phase 2). Multi-selection: legacy
  // bulk-edit path with no pre-fill (form defaults will apply on submit).
  $(document).ready(function() {
    $("#editoptions").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      if (editrecipient.length === 0) {
        alert('Please select at least one recipient');
        return;
      }
      if (editrecipient.length === 1) {
        // Single-select: hide bulk warning, AJAX pre-fill the form with the
        // recipient's current values, then open the modal.
        $('#editoptionsBulkWarning').hide();
        var theRecipientId = editrecipient[0];
        $.post('./inc/get_int_recipient_json.cfm', { id: theRecipientId }, function(data) {
          try {
            var rec = (typeof data === 'string') ? JSON.parse(data) : data;
            if (rec.error) { alert('Error: ' + rec.error); return; }
            $("#editoptions_modal select[name='policy']").val(rec.policy_id).trigger('change');
            $("#editoptions_modal select[name='reports']").val(rec.report_enabled);
            $("#editoptions_modal select[name='train_bayes']").val(String(rec.train_bayes));
            $("#editoptions_modal select[name='download_msg']").val(String(rec.download_msg));
            $("#editoptions_modal select[name='enforce_mfa']").val(String(rec.enforce_mfa || 0));
            $("#editoptionsid").html('<input type="hidden" name="recipient_id" value="' + theRecipientId + '">');
            $('#editoptions_modal').modal('show');
          } catch (e) {
            alert('Error loading recipient data.');
          }
        });
      } else {
        // Multi-select: show the bulk-edit warning and open the modal with
        // the static form defaults. Submitting applies those defaults to
        // every selected recipient.
        $('#editoptionsBulkCount').text(editrecipient.length);
        $('#editoptionsBulkWarning').show();
        $('#editoptions_modal').modal('show').on('shown.bs.modal', function() {
          $("#editoptionsid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
        });
      }
    });
  });

  </script>

<script>

  $(document).ready(function() {
    $("#editencryption").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#editencryption_modal').modal('show').on('shown.bs.modal', function() {
      $("#editencryptionid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });

  </script>

<script>

  $(document).ready(function() {
    $("#editaccesscontrol").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      if (editrecipient.length === 0) {
        alert('Please select at least one recipient');
        return;
      }
      $('#editaccesscontrol_modal').modal('show').on('shown.bs.modal', function() {
        $("#editaccesscontrolid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });

  </script>

<script>

  $(document).ready(function() {
    $("#editbackend").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      if(editrecipient.length === 0) {
        alert('Please select at least one recipient');
        return;
      }
      // Redirect to edit backend page with selected IDs
      window.location.href = 'edit_internal_recipient_backend.cfm?ids=' + editrecipient.join(',');
    });
  });

  </script>

<!--- STYLE FOR EYE-SLASH STARTS HERE --->    
<style>
  td {
   word-break: break-all;
       },

body{
 padding:100px 0;
 background-color:#efefef
}

a, a:hover{
 color:#333
}

</style>
<!--- STYLE FOR EYE-SLASH ENDS HERE --->  

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
            <cfoutput>
            <h1 class="m-0">Relay Recipients</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Relay Recipients</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    <cfparam name = "errormessage" default = "0">
    
    <cfparam name = "m2" default = "0"> 
    <cfif StructKeyExists(url, "m2")>
    <cfif url.m2 is not "">
    <cfset m2 = url.m2>

    <!--- /CFIF for StructKeyExists --->
  </cfif>
  
  <!--- /CFIF for url.m2 is not "" --->
  </cfif>

  <cfparam name = "m" default = "0">
  <cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
  <cfset m = session.m>

  <!--- ENABLE FOR DEBUG BELOW --->
  <!---
  <cfoutput>#session.m#</cfoutput>
  --->

  <!--- /CFIF for session.m is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.m --->
  </cfif>

  <!---
  <cfoutput>session M: #m#</cfoutput>
  --->

  
    <cfparam name = "step" default = "0">
    
    <cfparam name = "action" default = "">
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>

    <!--- RESET FAILED CERT QUEUE JOBS --->
    <cfif action EQ "reset_failed_queue">
        <cftry>
            <cfquery datasource="hermes">
                UPDATE cert_generation_queue
                SET status = 'pending', error_message = NULL, started_at = NULL
                WHERE status = 'failed'
            </cfquery>
            <cfset session.queueMessage = "reset_success">
        <cfcatch type="any">
            <cfset session.queueMessage = "reset_error">
        </cfcatch>
        </cftry>
        <cflocation url="view_internal_recipients.cfm" addtoken="no">
    </cfif>

        <!--- ERROR MESSAGES START HERE --->

        <cfif #m# is "3">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) edited successfully</cfoutput><br>
            <cfif StructKeyExists(session, "smimeQueued") AND session.smimeQueued GT 0>
              <cfoutput><i class="fas fa-certificate me-1"></i> #session.smimeQueued# S/MIME certificate(s) queued for generation<br></cfoutput>
            </cfif>
            <cfif StructKeyExists(session, "pgpQueued") AND session.pgpQueued GT 0>
              <cfoutput><i class="fas fa-key me-1"></i> #session.pgpQueued# PGP keyring(s) queued for generation<br></cfoutput>
            </cfif>
            <cfif StructKeyExists(session, "smimeExisting") AND session.smimeExisting GT 0>
              <cfoutput><i class="fas fa-info-circle me-1"></i> #session.smimeExisting# recipient(s) already had S/MIME certificate(s) - existing certificates kept<br></cfoutput>
            </cfif>
            <cfif StructKeyExists(session, "pgpExisting") AND session.pgpExisting GT 0>
              <cfoutput><i class="fas fa-info-circle me-1"></i> #session.pgpExisting# recipient(s) already had PGP keyring(s) - existing keyrings kept<br></cfoutput>
            </cfif>
          </div>

          <cfset session.m = 0>
          <cfset session.smimeQueued = 0>
          <cfset session.pgpQueued = 0>
          <cfset session.smimeExisting = 0>
          <cfset session.pgpExisting = 0>

        </cfif>
        
  
        <cfif #m# is "2">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) deleted successfully</cfoutput><br>
        
          </div>

          <cfset session.m = 0>

        </cfif>

        <cfif #m# is "1">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You must first select recipient(s) before clicking the Edit or Delete buttons</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

<cfif #errormessage# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must first select recipient(s) before clicking the Delete button</cfoutput>
  </div>

</cfif>

<!--- BACKEND SERVER UPDATE MESSAGES --->
<cfif StructKeyExists(session, "backendMessage")>
    <cfif session.backendMessage EQ "success_default">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            Backend server override cleared. Selected recipients will now use domain default.
        </div>
    <cfelseif session.backendMessage EQ "success_custom">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            Custom backend server configured for selected recipients.
        </div>
    </cfif>
    <cfset StructDelete(session, "backendMessage")>
</cfif>

<!--- QUEUE RESET MESSAGES --->
<cfif StructKeyExists(session, "queueMessage")>
    <cfif session.queueMessage EQ "reset_success">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h5><i class="icon fa fa-check"></i> Queue Reset</h5>
            Failed jobs have been reset to pending. They will be retried on the next processing cycle.
        </div>
    <cfelseif session.queueMessage EQ "reset_error">
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h5><i class="icon fa fa-ban"></i> Error</h5>
            Failed to reset queue jobs. Please try again.
        </div>
    </cfif>
    <cfset StructDelete(session, "queueMessage")>
</cfif>

        <!--- CERT/KEYRING QUEUE STATUS BANNER --->
        <cfquery name="getPendingQueue" datasource="hermes">
            SELECT
                SUM(CASE WHEN status='pending' THEN 1 ELSE 0 END) as pending,
                SUM(CASE WHEN status='processing' THEN 1 ELSE 0 END) as processing,
                SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) as failed
            FROM cert_generation_queue
            WHERE status IN ('pending', 'processing', 'failed')
        </cfquery>

        <cfif getPendingQueue.pending GT 0 OR getPendingQueue.processing GT 0>
          <div class="alert alert-info alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h5><i class="icon fas fa-spinner fa-spin"></i> Background Generation in Progress</h5>
            <cfoutput>
            <cfif getPendingQueue.pending GT 0>#getPendingQueue.pending# certificate(s)/keyring(s) pending generation</cfif>
            <cfif getPendingQueue.pending GT 0 AND getPendingQueue.processing GT 0>, </cfif>
            <cfif getPendingQueue.processing GT 0>#getPendingQueue.processing# currently processing</cfif>
            </cfoutput>
          </div>
        </cfif>

        <cfif getPendingQueue.failed GT 0>
          <div class="alert alert-warning">
            <div class="d-flex justify-content-between align-items-start">
              <div>
                <h5><i class="icon fas fa-exclamation-triangle"></i> Generation Failures</h5>
                <cfoutput>#getPendingQueue.failed# certificate(s)/keyring(s) failed to generate.</cfoutput>
              </div>
              <form method="post" action="" class="ms-3">
                <input type="hidden" name="action" value="reset_failed_queue">
                <button type="submit" class="btn btn-sm btn-outline-dark" onclick="return confirm('Reset all failed jobs to pending? They will be retried on the next processing cycle.')">
                  <i class="fas fa-redo me-1"></i>Retry Failed Jobs
                </button>
              </form>
            </div>
          </div>
        </cfif>

        <!--- ERROR MESSAGES END HERE --->


  <!--- DELETE RECIPIENT MODAL HTML STARTS HERE --->
 

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteRecipientModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete Recipient(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you to delete the recipient(s) you have selected? This action is irreversible!</p>
  
      </div>
      <div class="modal-footer">
        <form name="delete_recipients" method="post" action="">
  
          <input type="hidden" name="action" value="deleterecipient">
          <div id="deleteid"></div>
       
  
<!---
          <button type="input" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Yes</button>
          --->

          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
      </div>
    </div>
  </div>
  </div>
  <!--- DELETE RECIPIENT MODAL HTML ENDS HERE --->
    
<!--- NO USED. EDIT RECIPIENT HAS BEEN SPLIT INTO EDIT OPTIONS AND EDIT ENCRYPTION  MODALS BELOW --->

<!---
  <!--- EDIT RECIPIENT MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="edit_modal" tabindex="-1" role="dialog" aria-labelledby="editRecipientModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-warning">
          <!---
          <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Edit Recipient(s) </h4>
        </div>
          
        <div class="modal-body">

          <!---
          <p>Are you sure you to edit the recipient(s) you have selected? This action is irreversible!</p>
          --->

          <form name="edit_recipients" method="post" action="">
    
            <input type="hidden" name="action" value="editrecipient">
            <div id="editid"></div>
         
               <!--- RECIPIENT POLICY STARTS HERE --->

               <cfquery name="getdefaultpolicy" datasource="hermes">
                select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
                </cfquery>
    
              <cfquery name="getuserpolicies" datasource="hermes">
                select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'#getdefaultpolicy.policy_id#' order by policy_name asc
                </cfquery>
    
    <cfoutput>
    <cfif #getuserpolicies.recordcount# LT 1>
    
    
    
                <div class="form-group">
                    <label><strong>SVF Policy to Assign</strong></label>
                    <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                            style="width: 100%;">
                      <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                        </select>
    
                      <cfelseif #getuserpolicies.recordcount# GTE 1>
                        <div class="form-group">
                          <label><strong>SVF Policy to Assign</strong></label>
                          <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                                  style="width: 100%;">
                            <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                            <cfoutput query="getuserpolicies">
                              <option value="#policy_id#">#policy_name#</option>
                              </cfoutput>
                              </select>
          <!--- /CFIF #getuserpolicies.recordcount# --->
                            </cfif>
    
              
          </div>
          </cfoutput>
    
           <!--- RECIPIENT POLICY ENDS HERE --->
    
    
    
     <!--- QUARANTINE NOTIFICATIONS STARTS HERE --->

     <div class="form-group">
      <label><strong>Quarantine Notifications</strong></label>
      <p class="help-block">When enabled, users receive an email notification each time a message is quarantined, with a one-click release button.</p>
    <select class="form-control" name="reports" style="width: 100%">
    <option value="YES" selected="selected">Enabled</option>
    <option value="NO">Disabled</option>
    </select>
    </div>

      <!--- QUARANTINE NOTIFICATIONS ENDS HERE --->
    
    <!--- TRAIN BAYES STARTS HERE --->
    
    <div class="form-group">
      <label><strong>Train Bayes Filter from User Portal</strong></label>
    
      <div class="alert alert-danger">
        <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
        <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
        </div>
    
    <select class="form-control" name="train_bayes" data-placeholder="train_bayes" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    <!--- TRAIN BAYES AND DOWNLOAD MESSAGES  ENDS HERE --->
    
    <!--- DOWNLOAD MESSAGES STARTS HERE --->
    
    <div class="form-group">
    
      <label><strong>Download Messages from User Portal</strong></label>
      <div class="alert alert-danger">
      <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
      <p>Enabling can expose recipients to malware</p>
      </div>
    <select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    <!--- DOWNLOAD MESSAGES  ENDS HERE --->
    
    
    <!---
      <div class="alert alert-warning">
        
        <h5><i class="icon fas fa-exclamation-circle"></i> Please Note!</h5>
        <cfoutput>Setting PDF, S/MIME or PGP Encryption below to <strong>Enable</strong> OR setting PDF, S/MIME or PGP Encryption below to <strong>Disable</strong> AFTER recipient(s) has been already enabled for will significantly increase the amount of time it takes to edit recipient(s) </cfoutput>
      </div>
    --->
    
      <cfinclude template="./inc/edit_encryption_form_fields.cfm">

            <input type="submit" class="btn btn-primary" value="Submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
        </div>
        <div class="modal-footer">
      
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    <!--- EDIT RECIPIENT MODAL HTML ENDS HERE --->

  --->

  <!--- EDIT ENCRYPTION MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="editencryption_modal" tabindex="-1" role="dialog" aria-labelledby="editEncryptionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          <!---
          <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Edit Recipient(s) Encryption </h4>
        </div>
          
        <div class="modal-body">

          <!---
          <p>Are you sure you to edit the recipient(s) you have selected? This action is irreversible!</p>
          --->

          <form name="edit_recipients" method="post" action="">
    
            <input type="hidden" name="action" value="editencryption">
            <div id="editencryptionid"></div>
         
                 
      <cfinclude template="./inc/edit_encryption_form_fields.cfm">

            <input type="submit" class="btn btn-primary" value="Submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
        </div>
        <div class="modal-footer">
      
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    <!--- EDIT ENCRYPTION MODAL HTML ENDS HERE --->

    <!--- EDIT OPTIONS MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="editoptions_modal" tabindex="-1" role="dialog" aria-labelledby="editOptionsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          <!---
          <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Edit Recipient Options </h4>
        </div>
          
        <div class="modal-body">

          <!---
          <p>Are you sure you to edit the recipient(s) you have selected? This action is irreversible!</p>
          --->

          <form name="edit_options" method="post" action="">

            <input type="hidden" name="action" value="editoptions">
            <div id="editoptionsid"></div>

            <!--- Bulk-edit warning. Only shown by JS when 2+ recipients are
                 selected. In bulk mode the form fields are static defaults
                 (not per-row values) and submitting OVERWRITES every field
                 on every selected recipient. Single-select gets the AJAX
                 pre-fill instead. (##225 Phase 2) --->
            <div id="editoptionsBulkWarning" class="alert alert-danger" style="display:none;">
              <h5 class="mb-2"><i class="fas fa-exclamation-triangle me-2"></i>Bulk edit &mdash; <span id="editoptionsBulkCount">0</span> recipients selected</h5>
              <p class="mb-2">The fields below are <strong>not pre-filled from each recipient's current settings</strong> &mdash; they show the form's default values. Submitting will <strong>OVERWRITE every field on every selected recipient</strong> with whatever you see now.</p>
              <p class="mb-0"><strong>Two-Factor Authentication:</strong> if you leave it at <em>Disable</em>, recipients who currently have it enabled will have <code>recipients.enforce_mfa</code> reset to 0. The user will <strong>not</strong> be removed from <code>cn=two_factor</code> automatically (the LDAP cascade only fires on 0&rarr;1 transitions). To strip an existing enrollment, use the <strong>Reset 2FA Devices</strong> modal with the &quot;also remove from two-factor&quot; checkbox. To edit a single recipient with their current values pre-filled, select <strong>only one row</strong>.</p>
            </div>

               <!--- RECIPIENT POLICY STARTS HERE --->

               <cfquery name="getdefaultpolicy" datasource="hermes">
                select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
                </cfquery>
    
              <cfquery name="getuserpolicies" datasource="hermes">
                select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'#getdefaultpolicy.policy_id#' order by policy_name asc
                </cfquery>
    
    <cfoutput>
    <cfif #getuserpolicies.recordcount# LT 1>
    
    
    
                <div class="form-group">
                    <label><strong>SVF Policy to Assign</strong></label>
                    <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                            style="width: 100%;">
                      <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                        </select>
    
                      <cfelseif #getuserpolicies.recordcount# GTE 1>
                        <div class="form-group">
                          <label><strong>SVF Policy to Assign</strong></label>
                          <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                                  style="width: 100%;">
                            <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                            <cfoutput query="getuserpolicies">
                              <option value="#policy_id#">#policy_name#</option>
                              </cfoutput>
                              </select>
          <!--- /CFIF #getuserpolicies.recordcount# --->
                            </cfif>
    
              
          </div>
          </cfoutput>
    
           <!--- RECIPIENT POLICY ENDS HERE --->
    
    
    
     <!--- QUARANTINE NOTIFICATIONS STARTS HERE --->

     <div class="form-group">
      <label><strong>Quarantine Notifications</strong></label>
      <p class="help-block">When enabled, users receive an email notification each time a message is quarantined, with a one-click release button.</p>
    <select class="form-control" name="reports" style="width: 100%">
    <option value="YES" selected="selected">Enabled</option>
    <option value="NO">Disabled</option>
    </select>
    </div>

      <!--- QUARANTINE NOTIFICATIONS ENDS HERE --->
    
    <!--- TRAIN BAYES STARTS HERE --->
    
    <div class="form-group">
      <label><strong>Train Bayes Filter from User Portal</strong></label>
    
      <div class="alert alert-danger">
        <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
        <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
        </div>
    
    <select class="form-control" name="train_bayes" data-placeholder="train_bayes" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    <!--- TRAIN BAYES AND DOWNLOAD MESSAGES  ENDS HERE --->
    
    <!--- DOWNLOAD MESSAGES STARTS HERE --->
    
    <div class="form-group">
    
      <label><strong>Download Messages from User Portal</strong></label>
      <div class="alert alert-danger">
      <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
      <p>Enabling can expose recipients to malware</p>
      </div>
    <select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>

    </select>
    </div>


    <!--- DOWNLOAD MESSAGES  ENDS HERE --->

    <!--- 2FA ENFORCEMENT (##225 Phase 2) --->
    <div class="form-group mb-3">
      <label><strong>Two-Factor Authentication</strong></label>
      <select class="form-control" name="enforce_mfa" style="width: 100%">
        <option value="0" selected="selected">Disable</option>
        <option value="1">Enable</option>
      </select>
      <small class="form-text text-muted"><i class="fas fa-info-circle me-1"></i>When enabled, the recipient sees an urgent banner in their portal directing them to Account Settings to enable 2FA themselves. After they click <em>Enable</em>, Authelia walks them through device registration (TOTP, security key, or Duo Push) on their next sign-in; the verification email is delivered to their existing upstream mailbox.</small>
    </div>
    <!--- /2FA ENFORCEMENT --->


            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

              </form>
        </div>
        <div class="modal-footer">

          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    <!--- EDIT OPTIONS MODAL HTML ENDS HERE --->

    <!--- RESET 2FA DEVICES MODAL HTML STARTS HERE (##225 Phase 2).
         Replaces the old "Recipient Access Control" modal. The
         one_factor/two_factor radio is gone &mdash; the canonical admin
         policy is the Two-Factor Authentication select on Edit Options.
         This modal is now single-purpose: clear Authelia TOTP/WebAuthn
         devices for the selected recipient(s). The nuclear-option
         checkbox additionally moves the user back to cn=one_factor for
         a full 2FA reset (admin override of voluntary enrollment, etc.).
         Form action name kept as "editaccesscontrol" so the existing
         dispatcher and ##editaccesscontrol_modal id don't need a
         rename cascade. --->

  <div class="modal fade" id="editaccesscontrol_modal" tabindex="-1" role="dialog" aria-labelledby="resetTwoFactorDevicesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
            <h4 class="modal-title"><i class="fas fa-mobile-alt me-2"></i>Reset 2FA Devices</h4>
        </div>

        <div class="modal-body">

          <form name="edit_accesscontrol" method="post" action="">

            <input type="hidden" name="action" value="editaccesscontrol">
            <div id="editaccesscontrolid"></div>

            <p>Reset Two-Factor Authentication devices for the selected recipient(s)?</p>

            <div class="alert alert-warning mb-3">
              <p class="mb-2"><i class="fas fa-exclamation-triangle me-1"></i> This deletes all <strong>TOTP and WebAuthn</strong> devices registered to the selected recipient(s) in Authelia. They will be guided through device re-registration on their next sign-in.</p>
              <p class="mb-0"><i class="fas fa-info-circle me-1"></i> <strong>Does not affect Duo Push.</strong> Duo enrollments are managed through the <a href="https://admin.duosecurity.com" target="_blank" rel="noopener">Duo Admin Console</a>.</p>
            </div>

            <div class="border rounded p-3 bg-light mb-3">
              <div class="form-check mb-0">
                <input class="form-check-input" type="checkbox" name="also_remove_from_two_factor" id="acRelayAlsoRemove2faGroup" value="1">
                <label class="form-check-label" for="acRelayAlsoRemove2faGroup">
                  <strong>Also remove user from the 2FA group <span class="badge bg-danger ms-1">Nuclear</span></strong>
                </label>
              </div>
              <p class="mb-0 mt-2 small text-muted">By default this modal only deletes registered devices &mdash; the user stays under 2FA enforcement and re-registers on next login. Check this option to <strong>also move the user out of <code>cn=two_factor</code> back to <code>cn=one_factor</code></strong>. Use this when the user must restart 2FA from scratch (admin override of a voluntary enrollment, full account reset). If the per-recipient <em>Two-Factor Authentication</em> policy in Edit Options is still <em>Enable</em>, the cascade will move the user back to <code>cn=two_factor</code> on the next save.</p>
            </div>

            <input type="submit" class="btn btn-warning" value="Reset Devices" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  <!--- RESET 2FA DEVICES MODAL HTML ENDS HERE --->


      <cfif #action# is "deleterecipient">

        <cfif NOT StructKeyExists(form, "recipient_id")>

          <cfset session.m = 1>

        <cflocation url="view_internal_recipients.cfm" addtoken="no">
      
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif StructKeyExists(form, "recipient_id")>

          <cfif #form.recipient_id# is "">

            <cfset session.m = 1>

          <cflocation url="view_internal_recipients.cfm" addtoken="no">
              
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif #form.recipient_id# is not "">      

<cfloop index="i" list="#form.recipient_id#" delimiters=",">

      <cfif IsValid("integer", #i#)>

        <cfquery name="getrecipient" datasource="hermes">
        select id, recipient from recipients where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>

        <cfif #getrecipient.recordcount# GTE 1>
          <cfset recipient = #getrecipient.recipient#>
          <cfset delete_id = #getrecipient.id#>

          <cfinclude template="./inc/delete_internal_recipients.cfm">

          
            <cfoutput>
            #i#<br>
          </cfoutput>
        

          <!--- /CFIF #getrecipient.recordcount# --->
        </cfif>
      
          <!--- /CFIF IsValid("integer", #i#) --->
        </cfif>
      
        
        </cfloop>
  
        <cfset session.m = 2>


  <cflocation url="view_internal_recipients.cfm" addtoken="no">
 

<!--- /CFIF #form.recipient_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
</cfif>


<cfelseif #action# is "editoptions">

  <!--- VALIDATE PARAMETERS BELOW --->
  <!--- FORM.POLICY --->
  <cfif NOT StructKeyExists(form, "policy")>
  
    <cfset m="Edit Relay Recipients: form.policy does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "policy")>
  
  <cfquery name="checkpolicy" datasource="hermes">
    select id from policy where id = <cfqueryparam value = #form.policy# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
  <cfif #checkpolicy.recordcount# LT 1>
  
    <cfset m="Edit Relay Recipients: checkpolicy.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- /CFIF #checkpolicy.recordcount# --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "policy") --->
  </cfif>
  
  <!--- FORM.REPORTS --->
  <cfif NOT StructKeyExists(form, "reports")>
  
    <cfset m="Edit Relay Recipients: form.reports does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "reports")>
  
  <cfif #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL">
  
  <cfelse>
  
    <cfset m="Edit Relay Recipients: form.reports is not YEs, NO, or ALL">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "reports") --->
  </cfif>
  
  <!--- FORM.TRAIN_BAYES --->
  <cfif NOT StructKeyExists(form, "train_bayes")>
  
    <cfset m="Edit Relay Recipients: form.train_bayes does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "train_bayes")>
  
  <cfif #form.train_bayes# is "0" OR #form.train_bayes# is "1">
  
  <cfelse>
    <cfset m="Edit Relay Recipients: form.train_bayes is not 0 or 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- #form.train_bayes# is "0" OR #form.train_bayes# is "1" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "train_bayes") --->
  </cfif>
  
  <!--- FORM.DOWNLOAD_MSG --->
  <cfif NOT StructKeyExists(form, "download_msg")>
  
    <cfset m="Edit Relay Recipients: form.download_msg does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "download_msg")>
  
  <cfif #form.download_msg# is "0" OR #form.download_msg# is "1">
  
  <cfelse>
    <cfset m="Edit Relay Recipients: form.download_msg is not 0 or 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- #form.download_msg# is "0" OR #form.download_msg# is "1" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "download_msg") --->
  </cfif>

  <!--- FORM.ENFORCE_MFA (##225 Phase 2) --->
  <cfif NOT StructKeyExists(form, "enforce_mfa")>
    <cfset m="Edit Relay Recipients: form.enforce_mfa does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  <cfelseif form.enforce_mfa NEQ "0" AND form.enforce_mfa NEQ "1">
    <cfset m="Edit Relay Recipients: form.enforce_mfa is not 0 or 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>


  <!--- FORM.RECIPIENT_ID --->
    <cfif NOT StructKeyExists(form, "recipient_id")>

      <cfset session.m = 1>
  
    <cflocation url="view_internal_recipients.cfm" addtoken="no">
  
  
      <cfelseif StructKeyExists(form, "recipient_id")>
  
      <cfif #form.recipient_id# is "">

        <cfset session.m = 1>
  
      <cflocation url="view_internal_recipients.cfm" addtoken="no">
          
  
  <cfelseif #form.recipient_id# is not "">      
  
  <!--- VALIDATE PARAMETERS ABOVE --->
  
  <cfloop index="i" list="#form.recipient_id#" delimiters=",">
  
  <cfif IsValid("integer", #i#)>
  
    <cfquery name="getrecipient" datasource="hermes">
    select id, recipient from recipients where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  
    <cfif #getrecipient.recordcount# GTE 1>
      <cfset recipient = #getrecipient.recipient#>
      <cfset edit_id = #getrecipient.id#>
  
      <cfinclude template="./inc/edit_internal_recipients.cfm">
  
      
        <cfoutput>
        #i#<br>
      </cfoutput>
    
  
      <!--- /CFIF #getrecipient.recordcount# --->
    </cfif>
  
      <!--- /CFIF IsValid("integer", #i#) --->
    </cfif>
  
    
    </cfloop>
  
    <cfset session.m = 3>

  <cfoutput>
  <cflocation url="view_internal_recipients.cfm" addtoken="no">
  </cfoutput>
  
  <!--- /CFIF #form.recipient_id# is/is not "" --->
  </cfif>
  
  
  <!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
  </cfif>


<cfelseif #action# is "editencryption">

<!--- VALIDATE PARAMETERS BELOW --->
<!--- FORM.PDF_ENABLED --->
<cfif NOT StructKeyExists(form, "pdf_enabled")>

  <cfset m="Edit Relay Recipients: form.pdf_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "pdf_enabled")>

<cfif #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2">

  <cfelse>
  <cfset m="Edit Relay Recipients: form.pdf_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pdf_enabled") --->
</cfif>

<!--- FORM.SMIME_ENABLED --->
<cfif NOT StructKeyExists(form, "smime_enabled")>

  <cfset m="Edit Relay Recipients: form.smime_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "smime_enabled")>

<cfif #form.smime_enabled# is "1" OR #form.smime_enabled# is "2">

<cfelse>

  <cfset m="Edit Relay Recipients: form.smime_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.smime_enabled# is "1" OR #form.smime_enabled# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "smime_enabled") --->
</cfif>

<!--- FORM.SIGN --->
<cfif NOT StructKeyExists(form, "sign")>

  <cfset m="Edit Relay Recipients: form.sign does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "sign")>

<cfif #form.sign# is "1" OR #form.sign# is "2">

<cfelse>
  <cfset m="Edit Relay Recipients: form.sign is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.sign# is "1" OR #form.sign# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "sign") --->
</cfif>

<!--- FORM.PGP_ENABLED --->
<cfif NOT StructKeyExists(form, "pgp_enabled")>

  <cfset m="Edit Relay Recipients: form.pgp_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "pgp_enabled")>

<cfif #form.pgp_enabled# is "1" OR #form.pgp_enabled# is "2">

<cfelse>
  <cfset m="Edit Relay Recipients: form.pgp_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.pgp_enabled# is not "1" OR #form.pgp_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pgp_enabled") --->
</cfif>

<!--- Default cert/key options if not submitted (hidden fields when encryption disabled) --->
<cfif NOT StructKeyExists(form, "ca")><cfset form.ca = 1></cfif>
<cfif NOT StructKeyExists(form, "validity")><cfset form.validity = 1825></cfif>
<cfif NOT StructKeyExists(form, "cert_encryption")><cfset form.cert_encryption = 2048></cfif>
<cfif NOT StructKeyExists(form, "cert_algorithm")><cfset form.cert_algorithm = "sha256"></cfif>
<cfif NOT StructKeyExists(form, "pgp_encryption")><cfset form.pgp_encryption = 2048></cfif>

<!--- FORM.RECIPIENT_ID --->
  <cfif NOT StructKeyExists(form, "recipient_id")>

    <cfset session.m = 1>

  <cflocation url="view_internal_recipients.cfm" addtoken="no">


    <cfelseif StructKeyExists(form, "recipient_id")>

    <cfif #form.recipient_id# is "">

      <cfset session.m = 1>

    <cflocation url="view_internal_recipients.cfm" addtoken="no">
        

<cfelseif #form.recipient_id# is not "">      

<!--- VALIDATE PARAMETERS ABOVE --->

<cfset session.smimeQueued = 0>
<cfset session.pgpQueued = 0>
<cfset session.smimeExisting = 0>
<cfset session.pgpExisting = 0>

<cfloop index="i" list="#form.recipient_id#" delimiters=",">

<cfif IsValid("integer", #i#)>

  <cfquery name="getrecipient" datasource="hermes">
  select id, recipient from recipients where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

  <cfif #getrecipient.recordcount# GTE 1>
    <cfset recipient = #getrecipient.recipient#>
    <cfset edit_id = #getrecipient.id#>

    <cfinclude template="./inc/edit_internal_recipients_djigzo.cfm">

    <!--- Queue S/MIME cert if enabling and no cert exists --->
    <cfif form.smime_enabled EQ "1">
        <cfquery name="existingSmimeCert" datasource="hermes">
            SELECT id FROM recipient_certificates
            WHERE user_id = <cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        <cfif existingSmimeCert.recordcount LT 1>
            <cfquery name="existingSmimeQueue" datasource="hermes">
                SELECT id FROM cert_generation_queue
                WHERE recipient_id = <cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">
                  AND job_type = 'smime' AND status IN ('pending', 'processing')
                LIMIT 1
            </cfquery>
            <cfif existingSmimeQueue.recordcount LT 1>
                <cfinclude template="./inc/generate_random_password.cfm">
                <cfquery datasource="hermes">
                    INSERT INTO cert_generation_queue
                    (recipient_id, recipient_email, job_type, ca_id, validity, encryption, algorithm, password)
                    VALUES
                    (<cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                     'smime',
                     <cfqueryparam value="#form.ca#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#form.validity#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#form.cert_encryption#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#form.cert_algorithm#" cfsqltype="cf_sql_varchar">,
                     <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
                </cfquery>
                <cfset session.smimeQueued = session.smimeQueued + 1>
            </cfif>
        <cfelse>
            <cfset session.smimeExisting = session.smimeExisting + 1>
        </cfif>
    </cfif>

    <!--- Queue PGP keyring if enabling and no keyring exists --->
    <cfif form.pgp_enabled EQ "1">
        <cfquery name="existingPgpKeyring" datasource="hermes">
            SELECT id FROM recipient_keystores
            WHERE user_id = <cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">
              AND master = '1'
            LIMIT 1
        </cfquery>
        <cfif existingPgpKeyring.recordcount LT 1>
            <cfquery name="existingPgpQueue" datasource="hermes">
                SELECT id FROM cert_generation_queue
                WHERE recipient_id = <cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">
                  AND job_type = 'pgp' AND status IN ('pending', 'processing')
                LIMIT 1
            </cfquery>
            <cfif existingPgpQueue.recordcount LT 1>
                <cfinclude template="./inc/generate_random_password.cfm">
                <cfset pgpNameReal = ListFirst(recipient, "@")>
                <cfquery datasource="hermes">
                    INSERT INTO cert_generation_queue
                    (recipient_id, recipient_email, job_type, pgp_key_length, pgp_name_real, password)
                    VALUES
                    (<cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#recipient#" cfsqltype="cf_sql_varchar">,
                     'pgp',
                     <cfqueryparam value="#form.pgp_encryption#" cfsqltype="cf_sql_integer">,
                     <cfqueryparam value="#pgpNameReal#" cfsqltype="cf_sql_varchar">,
                     <cfqueryparam value="#generatedPassword#" cfsqltype="cf_sql_varchar">)
                </cfquery>
                <cfset session.pgpQueued = session.pgpQueued + 1>
            </cfif>
        <cfelse>
            <cfset session.pgpExisting = session.pgpExisting + 1>
        </cfif>
    </cfif>

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

    <!--- /CFIF IsValid("integer", #i#) --->
  </cfif>

  
  </cfloop>

  <cfset session.m = 3>

<cflocation url="view_internal_recipients.cfm" addtoken="no">


<!--- /CFIF #form.recipient_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
</cfif>


<cfelseif #action# is "editaccesscontrol">

<!---
RESET 2FA DEVICES ACTION HANDLER (##225 Phase 2).
Was previously the "edit access control" handler with a one_factor /
two_factor radio. That radio is gone &mdash; the canonical admin policy
is the enforce_mfa select on Edit Options, and the LDAP cascade fires
from edit_internal_recipients.cfm on a 0->1 transition.

Two modes:
- DEFAULT: clear TOTP and WebAuthn devices in Authelia so the user
  re-registers on next sign-in. "User lost their phone" recovery.
- NUCLEAR (form.also_remove_from_two_factor=1): also remove the user
  from cn=two_factor LDAP group, moving them back to cn=one_factor.
  Used for admin override of a voluntary enrollment, or full account
  reset. The per-recipient enforce_mfa policy is left alone &mdash; if
  it's still 1, the cascade in edit_internal_recipients.cfm will move
  the user back to cn=two_factor on the next save.

(Form action name kept as "editaccesscontrol" so the dispatcher and
modal markup don't need a rename cascade.)
--->

<!--- VALIDATE PARAMETERS --->
<cfif NOT StructKeyExists(form, "recipient_id")>
  <cfset session.m = 1>
  <cflocation url="view_internal_recipients.cfm" addtoken="no">
<cfelseif StructKeyExists(form, "recipient_id")>
  <cfif form.recipient_id is "">
    <cfset session.m = 1>
    <cflocation url="view_internal_recipients.cfm" addtoken="no">
  <cfelseif form.recipient_id is not "">
    <cfset theCustId = form.recipient_id>
  </cfif>
</cfif>

<cfparam name="form.also_remove_from_two_factor" default="0">

<!--- PROCESS EACH RECIPIENT --->
<cfloop index="i" list="#theCustId#" delimiters=",">
  <cfif IsValid("integer", i)>
    <cfquery name="getrecipient" datasource="hermes">
      SELECT r.id, r.recipient, us.ldap_username
      FROM recipients r
      LEFT JOIN user_settings us ON r.recipient = us.email
      WHERE r.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
    </cfquery>

    <cfif getrecipient.recordcount GTE 1>
      <cfif getrecipient.ldap_username NEQ "">
        <cfset ldapUsername = getrecipient.ldap_username>
      <cfelse>
        <cfset ldapUsername = LCase(getrecipient.recipient)>
      </cfif>

      <!--- DELETE TOTP DEVICES via Authelia CLI. Failure is non-critical
           (e.g., user had no TOTP enrolled &mdash; Authelia returns
           non-zero); the desired end-state ("no TOTP devices") is
           achieved either way. --->
      <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia authelia storage user totp delete #ldapUsername# --config /config/configuration.yml"
            variable="totpDeleteResult"
            errorVariable="totpDeleteError"
            timeout="30">
        </cfexecute>
      <cfcatch type="any"></cfcatch>
      </cftry>

      <!--- DELETE WEBAUTHN DEVICES via Authelia CLI. Same non-critical
           handling as TOTP. --->
      <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_authelia authelia storage user webauthn delete #ldapUsername# --all --config /config/configuration.yml"
            variable="webauthnDeleteResult"
            errorVariable="webauthnDeleteError"
            timeout="30">
        </cfexecute>
      <cfcatch type="any"></cfcatch>
      </cftry>

      <!--- NUCLEAR OPTION: also remove user from cn=two_factor LDAP
           group. The ldap_change_user_access_control.cfm helper is
           idempotent on benign errors (e.g., user wasn't in two_factor
           to begin with). The per-recipient enforce_mfa policy is left
           alone &mdash; the editoptions cascade will re-add them to
           cn=two_factor on the next save if the policy is still 1. --->
      <cfif form.also_remove_from_two_factor EQ "1">
        <cftry>
          <cfset ldapOldAccessControl = "two_factor">
          <cfset ldapNewAccessControl = "one_factor">
          <cfinclude template="./inc/ldap_change_user_access_control.cfm">
        <cfcatch type="any">
          <!--- Non-critical: device clear above already happened. --->
        </cfcatch>
        </cftry>
      </cfif>

    </cfif>
  </cfif>
</cfloop>

<cfset session.m = 3>
<cflocation url="view_internal_recipients.cfm" addtoken="no">

<!--- /CFIF action is editaccesscontrol --->

      <!--- /CFIF #action# is --->
    </cfif> 
    

  <!--- DEBUGGING CODE BELOW --->
  <!---
  <cfif #action# is "deleterecipient">

    <cfif NOT StructKeyExists(form, "recipient_id")>
    
      <cfset m="recipient_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       <cfelseif StructKeyExists(form, "recipient_id")>
      <cfif #form.recipient_id# is "">
      <cfset m="recipient_id is blank">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      <cfelseif #form.recipient_id# is not "">
      <cfset theCustId = #form.recipient_id#>
      </cfif>
      </cfif>

      
   
        <cfoutput>
       TheCustID: #theCustId#<br>
      </cfoutput>
  
      

<cfloop index="i" list="#form.recipient_id#" delimiters=",">

  <cfif IsValid("integer", #i#)>
  

      
        <cfoutput>
        Index: #i#<br>
      </cfoutput>
    
  
      <!--- /CFIF IsValid("integer", #i#) --->
    </cfif>

    </cfloop>

  
  <!--- /CFIF #action# is --->     
</cfif>
--->

<!--- RELAY RECIPIENTS CARD --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-users me-2"></i>Relay Recipients</h3>
    </div>
    <div class="card-body">
        <form>
        <div class="mb-3">
            <a href="add_internal_recipients.cfm" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg me-1"></i>Create Recipient(s)</a>
            <button type="button" id="editoptions" class="btn btn-primary"><i class="fa fa-edit me-1"></i>Edit Options</button>
            <button type="button" id="editencryption" class="btn btn-primary"><i class="fas fa-lock me-1"></i>Edit Encryption</button>
            <button type="button" id="editbackend" class="btn btn-primary"><i class="fas fa-server me-1"></i>Edit Backend</button>
            <button type="button" id="editaccesscontrol" class="btn btn-primary"><i class="fas fa-mobile-alt me-1"></i>Reset 2FA Devices</button>
            <button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt me-1"></i>Delete</button>
        </div>



<!--- QUERY LDAP FOR TWO_FACTOR GROUP MEMBERS (single query for all users) --->
<cfset twoFactorMembers = "">
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=two_factor,ou=groups,dc=hermes,dc=local' -LLL member"
        variable="twoFactorMembers"
        errorVariable="ldapError"
        timeout="30">
    </cfexecute>
<cfcatch type="any">
    <!--- If LDAP query fails, twoFactorMembers stays empty - all users show as one_factor --->
    <cfset twoFactorMembers = "">
</cfcatch>
</cftry>

<cfquery name="getrecipients" datasource="hermes">
  select recipients.id, recipients.id as theID, recipients.id as theOtherID, recipients.recipient,
    recipients.backend_server, recipients.backend_port, recipients.backend_tls,
    recipients.auth_type, recipients.remoteauth_domain, recipients.enforce_mfa,
    policy.policy_name, user_settings.report_enabled as report_enabled, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore, COALESCE(user_settings.ldap_username, '') as ldap_username
  from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL and (recipients.recipient_type = 'relay' or recipients.recipient_type is null) group by recipients.id

  </cfquery>
    
    <cfif #getrecipients.recordcount# GTE 1>

        <div class="table-responsive">
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>S/MIME</th>
            <th>PGP</th>
            <th>Recipient</th>
            <th>Auth</th>
            <th>Backend</th>
            <th>2FA</th>
            <th>Policy</th>
            <th>Quarantine Notifications</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>S/MIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>S/MIME Cert</th>
            <th>PGP Keyring</th>
          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getrecipients">
          <!--- Determine LDAP username for this recipient --->
          <cfset recipientLdapUser = ldap_username NEQ "" ? LCase(ldap_username) : LCase(recipient)>
          <!--- Check if user is in two_factor group (search for their DN in the member list) --->
          <cfset isTwoFactor = twoFactorMembers CONTAINS "cn=#recipientLdapUser#,ou=users,dc=hermes,dc=local">
          <tr>
            <td><input type="checkbox" name="id" value="#id#"></td>
            <td><a href="view_recipient_certificates.cfm?type=1&id=#theID#" class="btn btn-secondary btn-sm" role="button"><i class="fas fa-user-shield"></i></a></td>
            <td><a href="view_recipient_keyrings.cfm?type=1&id=#theOtherID#" class="btn btn-secondary btn-sm" role="button"><i class="fas fa-user-lock"></i></a></td>
            <td>#recipient#</td>
            <td><cfif auth_type EQ "remote"><span class="badge bg-primary" title="#remoteauth_domain#"><i class="fas fa-cloud me-1"></i>REMOTE</span><cfelse><span class="badge bg-secondary">LOCAL</span></cfif></td>
            <td><cfif Len(Trim(backend_server)) GT 0><span class="text-primary" title="#backend_server#:#backend_port#">#backend_server#</span><cfelse><span class="text-muted">(domain default)</span></cfif></td>
            <td><!--- 2FA column: two orthogonal states, two independent pills.
                  "Enrolled" reads cn=two_factor LDAP membership (user has
                  registered a 2FA device — Authelia challenges them at
                  sign-in). "Required" reads recipients.enforce_mfa (admin
                  policy — set via Edit Options). A user can be enrolled
                  voluntarily without admin enforcement, and admin can
                  enforce without the user yet being enrolled, so the two
                  must be displayed independently. (##225 Phase 1.5 + Phase 2) --->
              <cfif isTwoFactor>
                <span class="badge bg-success me-1" title="User has registered a 2FA device (TOTP, security key, or Duo Push). Authelia challenges them at sign-in."><i class="fas fa-shield-alt me-1"></i>Enrolled</span>
              </cfif>
              <cfif Val(enforce_mfa) EQ 1>
                <span class="badge bg-warning text-dark" title="Admin requires 2FA &mdash; set via Edit Options. Independent of enrollment state."><i class="fas fa-exclamation-triangle me-1"></i>Required</span>
              </cfif>
              <cfif NOT isTwoFactor AND Val(enforce_mfa) NEQ 1>
                <span class="text-muted">&mdash;</span>
              </cfif>
            </td>
            <td>#policy_name#</td>
            <td><cfif report_enabled NEQ "NO"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif train_bayes EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif download_msg EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif pdf_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif smime_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif pgp_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif digital_sign EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif cert EQ "YES"><span class="badge bg-success"><i class="fas fa-certificate me-1"></i>YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
            <td><cfif keystore EQ "YES"><span class="badge bg-success"><i class="fas fa-key me-1"></i>YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          </tr>
        </cfoutput>

        </tbody>
        <tfoot>
          <tr>
            <th></th>
            <th>S/MIME</th>
            <th>PGP</th>
            <th>Recipient</th>
            <th>Auth</th>
            <th>Backend</th>
            <th>2FA</th>
            <th>Policy</th>
            <th>Quarantine Notifications</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>S/MIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>S/MIME Cert</th>
            <th>PGP Keyring</th>
          </tr>
        </tfoot>
      </table>
        </div><!--- /.table-responsive --->

        </form>

    <cfelseif #getrecipients.recordcount# LT 1>

      <div class="alert alert-info">
        <h5><i class="icon fas fa-info-circle"></i> No Recipients Found</h5>
        <p class="mb-0">No Relay Recipients were found. Click <strong>Create Recipient(s)</strong> to add new recipients.</p>
      </div>

      <!--- /CFIF FOR getrecipients.recordcount --->
    </cfif>

    </div><!--- /.card-body --->
</div><!--- /.card --->
<!--- END RELAY RECIPIENTS CARD --->

    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>

  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE STARTS HERE --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
  <script>
    $('#selectAll').click(function() {
      if(this.checked) {
          $(':checkbox').each(function() {
              this.checked = true;                        
          });
      } else {
         $(':checkbox').each(function() {
              this.checked = false;                        
          });
      } 
    });
    </script>
  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE ENDS HERE --->

</html>