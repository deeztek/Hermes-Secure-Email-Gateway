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

  $(document).ready(function() {
    $("#editoptions").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#editoptions_modal').modal('show').on('shown.bs.modal', function() {
      $("#editoptionsid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
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

    <!--- FORCE LOGOUT RELAY USER --->
    <cfif action EQ "forcelogout">
        <cfparam name="form.logout_username" default="">
        <cfif form.logout_username NEQ "">
            <cfset targetSessionUser = form.logout_username>
            <cfinclude template="./inc/invalidate_user_sessions.cfm">
            <cfset session.m = "forcelogout_success">
        </cfif>
        <cflocation url="view_internal_recipients.cfm" addtoken="no">

    <!--- RESET FAILED CERT QUEUE JOBS --->
    <cfelseif action EQ "reset_failed_queue">
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

        <cfif m is "forcelogout_success">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            User sessions invalidated. The user will be redirected to the login page on their next request.
          </div>
          <cfset session.m = 0>

        <cfelseif #m# is "3">
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

    <!--- EDIT ACCESS CONTROL MODAL HTML STARTS HERE --->

  <div class="modal fade" id="editaccesscontrol_modal" tabindex="-1" role="dialog" aria-labelledby="editAccessControlModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
            <h4 class="modal-title"><i class="fas fa-shield-alt me-2"></i>Recipient Access Control</h4>
        </div>

        <div class="modal-body">

          <div class="alert alert-info">
            <p class="mb-0"><i class="icon fas fa-info-circle"></i>Configure two-factor authentication requirements for selected recipient(s). Changes take effect on their next login.</p>
          </div>

          <form name="edit_accesscontrol" method="post" action="">

            <input type="hidden" name="action" value="editaccesscontrol">
            <div id="editaccesscontrolid"></div>

            <div class="form-group mb-3">
              <label><strong>Access Control Policy</strong></label>
              <select class="form-control" name="access_control" data-placeholder="access_control" style="width: 100%">
                <option value="one_factor">One Factor (Password Only)</option>
                <option value="two_factor">Two Factor (Password + 2FA)</option>
              </select>
              <small class="text-muted">Two Factor requires recipients to configure TOTP, Duo Push, or WebAuthn on their next login.</small>
            </div>

            <hr>

            <div class="form-group mb-3">
              <label><strong>Delete 2FA Devices</strong></label>
              <div class="alert alert-warning">
                <p class="mb-2"><i class="icon fas fa-exclamation-triangle"></i>Check this box to delete all <strong>TOTP and WebAuthn</strong> devices for the selected recipient(s). They will need to re-register their 2FA devices on next login.</p>
                <p class="mb-0"><i class="icon fas fa-info-circle"></i><strong>Note:</strong> This does <strong>not</strong> affect Duo Push enrollments. Duo Push devices are managed through the <a href="https://admin.duosecurity.com" target="_blank">Duo Admin Console</a>.</p>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" name="delete_2fa_devices" value="1" id="delete2faCheck">
                <label class="form-check-label" for="delete2faCheck">
                  Delete TOTP and WebAuthn devices for selected recipient(s)
                </label>
              </div>
            </div>

            <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  <!--- EDIT ACCESS CONTROL MODAL HTML ENDS HERE --->


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

<!--- VALIDATE ACCESS_CONTROL PARAMETER --->
<cfif NOT StructKeyExists(form, "access_control")>
  <cfset m="Edit Relay Recipients: form.access_control does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
<cfelseif form.access_control NEQ "one_factor" AND form.access_control NEQ "two_factor">
  <cfset m="Edit Relay Recipients: form.access_control is not one_factor or two_factor">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- PROCESS EACH RECIPIENT --->
<cfloop index="i" list="#theCustId#" delimiters=",">
  <cfif IsValid("integer", i)>
    <!--- GET RECIPIENT INFO --->
    <cfquery name="getrecipient" datasource="hermes">
      SELECT r.id, r.recipient, us.ldap_username
      FROM recipients r
      LEFT JOIN user_settings us ON r.recipient = us.email
      WHERE r.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
    </cfquery>

    <cfif getrecipient.recordcount GTE 1>
      <!--- GET LDAP USERNAME FOR THIS RECIPIENT --->
      <cfif getrecipient.ldap_username NEQ "">
        <cfset ldapUsername = getrecipient.ldap_username>
      <cfelse>
        <!--- Username is the email address --->
        <cfset ldapUsername = LCase(getrecipient.recipient)>
      </cfif>

      <!--- CHANGE ACCESS CONTROL GROUP IN LDAP --->
      <cfset ldapNewAccessControl = form.access_control>
      <cfif form.access_control EQ "one_factor">
        <cfset ldapOldAccessControl = "two_factor">
      <cfelse>
        <cfset ldapOldAccessControl = "one_factor">
      </cfif>

      <cftry>
        <cfinclude template="./inc/ldap_change_user_access_control.cfm">
      <cfcatch type="any">
        <!--- Log error but continue processing --->
      </cfcatch>
      </cftry>

      <!--- DELETE 2FA DEVICES IF REQUESTED --->
      <cfif StructKeyExists(form, "delete_2fa_devices") AND form.delete_2fa_devices EQ "1">
        <cftry>
          <!--- Delete TOTP devices via docker exec --->
          <cfexecute name="/usr/local/bin/docker"
              arguments="exec hermes_authelia authelia storage user totp delete #ldapUsername# --config /config/configuration.yml"
              timeout="30"
              variable="totpDeleteResult"
              errorVariable="totpDeleteError">
          </cfexecute>

          <!--- Delete WebAuthn devices via docker exec --->
          <cfexecute name="/usr/local/bin/docker"
              arguments="exec hermes_authelia authelia storage user webauthn delete #ldapUsername# --config /config/configuration.yml --all"
              timeout="30"
              variable="webauthnDeleteResult"
              errorVariable="webauthnDeleteError">
          </cfexecute>
        <cfcatch type="any">
          <!--- Log error but continue processing --->
        </cfcatch>
        </cftry>
      </cfif>

    <!--- /CFIF getrecipient.recordcount GTE 1 --->
    </cfif>
  <!--- /CFIF IsValid("integer", i) --->
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
            <button type="button" id="editaccesscontrol" class="btn btn-primary"><i class="fas fa-shield-alt me-1"></i>Access Control</button>
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
    recipients.auth_type, recipients.remoteauth_domain,
    policy.policy_name, user_settings.report_enabled as report_enabled, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore, COALESCE(user_settings.ldap_username, '') as ldap_username
  from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL and (recipients.recipient_type = 'relay' or recipients.recipient_type is null) group by recipients.id

  </cfquery>
    
    <cfif #getrecipients.recordcount# GTE 1>

        <div class="table-responsive">
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
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
        </thead>
        <tbody>

        

<cfoutput query="getrecipients">
          <!--- Determine LDAP username for this recipient --->
          <cfset recipientLdapUser = ldap_username NEQ "" ? LCase(ldap_username) : LCase(recipient)>
          <!--- Check if user is in two_factor group (search for their DN in the member list) --->
          <cfset isTwoFactor = twoFactorMembers CONTAINS "cn=#recipientLdapUser#,ou=users,dc=hermes,dc=local">
          <tr>
            <td><input type="checkbox" name="id" value="#id#"></td>
            <td><button type="button" class="btn btn-sm btn-outline-warning" title="Force Logout" onclick="confirmForceLogout('#JSStringFormat(recipient)#')"><i class="fas fa-sign-out-alt"></i></button></td>
            <td><a href="view_recipient_certificates.cfm?type=1&id=#theID#" class="btn btn-secondary btn-sm" role="button"><i class="fas fa-user-shield"></i></a></td>
            <td><a href="view_recipient_keyrings.cfm?type=1&id=#theOtherID#" class="btn btn-secondary btn-sm" role="button"><i class="fas fa-user-lock"></i></a></td>
            <td>#recipient#</td>
            <td><cfif auth_type EQ "remote"><span class="badge bg-primary" title="#remoteauth_domain#"><i class="fas fa-cloud me-1"></i>REMOTE</span><cfelse><span class="badge bg-secondary">LOCAL</span></cfif></td>
            <td><cfif Len(Trim(backend_server)) GT 0><span class="text-primary" title="#backend_server#:#backend_port#">#backend_server#</span><cfelse><span class="text-muted">(domain default)</span></cfif></td>
            <td><cfif isTwoFactor><span class="badge bg-success"><i class="fas fa-shield-alt me-1"></i>2FA</span><cfelse><span class="badge bg-secondary">Password</span></cfif></td>
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



<!-- Force Logout Modal -->
<div class="modal fade" id="forceLogoutModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_internal_recipients.cfm">
        <input type="hidden" name="action" value="forcelogout">
        <input type="hidden" name="logout_username" id="forceLogoutUsername" value="">
        <div class="modal-header bg-warning">
          <h5 class="modal-title"><i class="fas fa-sign-out-alt me-2"></i>Force Logout</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>This will immediately invalidate all active sessions for <strong id="forceLogoutDisplayName"></strong>.</p>
          <p>The user will be redirected to the login page on their next request.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-warning">Force Logout</button>
        </div>
      </form>
    </div>
  </div>
</div>

</body>

  <script>
    function confirmForceLogout(username) {
      $('#forceLogoutUsername').val(username);
      $('#forceLogoutDisplayName').text(username);
      new bootstrap.Modal(document.getElementById('forceLogoutModal')).show();
    }
  </script>

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