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
  <title>Hermes SEG | Internal Recipients</title>

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
            <h1 class="m-0">Internal Recipients</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Internal Recipients</li>
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
    
  

  
        <!--- ERROR MESSAGES START HERE --->
  
        <cfif #m# is "3">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) edited successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

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
    
    
    
     <!--- QUARANTINE REPORTS STARTS HERE --->
    
     
     <div class="form-group">
      <label><strong>Quarantine Reports</strong></label>
    <!---
      <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    <select class="form-control" name="reports" data-placeholder="reports" id="reports" style="width: 100%">                  
    <option value="YES" selected="selected">Enable Report Only if Quarantined Messages Exist</option>
    <option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
    <option value="NO">Disable Quarantine Reports</option>
    
    </select> 
    </div>
    
         
              <div class="form-group" id="reportsfrequency">
                <label><strong>Quarantine Report Frequency</strong></label>
    <!---
                <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    
      <select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
      <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
      <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
      <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
      <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
       </select> 
      </div>
    
      <!--- QUARANTINE REPORTS ENDS HERE --->
    
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
    
      <!--- PDF ENCRYPTION STARTS HERE --->
    
      <div class="form-group">
        <label><strong>PDF Encryption</strong></label>
      <!---
        <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
      --->
      <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
      <option value="2" selected="selected">Disable</option>
      <option value="1">Enable</option>
      
      </select> 
      </div>
    
      <!--- PDF ENCRYPTION ENDS HERE --->
    
        <!--- SMIME ENCRYPTION STARTS HERE --->
    
        <div class="form-group">
          <label><strong>S/MIME Encryption</strong></label>
        <!---
          <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
        --->
        <select class="form-control" name="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">                  
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
        
        </select> 
        </div>
      
        <!--- SMIME ENCRYPTION ENDS HERE --->
    
        
        <!--- SMIME SIGN STARTS HERE --->
    
        <div class="form-group">
          <label><strong>S/MIME SIGNATURE</strong></label>
        
          <p class="help-block">Effective only when S/MIME Certificate present</p>
        
        <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
        <option value="2" selected="selected">Sign Encrypted Messages Only</option>
        <option value="1">Sign all messages</option>
        
        </select> 
        </div>
      
        <!--- SMIME SIGN ENDS HERE --->
    
    
            <!--- PGP ENCRYPTION STARTS HERE --->
    
            <div class="form-group">
              <label><strong>PGP Encryption</strong></label>
            <!---
              <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
            --->
            <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
            <option value="2" selected="selected">Disable</option>
            <option value="1">Enable</option>
            
            </select> 
            </div>
          
            <!--- PGP ENCRYPTION ENDS HERE --->
    

  
            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
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
         
                 
      <!--- PDF ENCRYPTION STARTS HERE --->
    
      <div class="form-group">
        <label><strong>PDF Encryption</strong></label>
      <!---
        <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
      --->
      <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
      <option value="2" selected="selected">Disable</option>
      <option value="1">Enable</option>
      
      </select> 
      </div>
    
      <!--- PDF ENCRYPTION ENDS HERE --->
    
        <!--- SMIME ENCRYPTION STARTS HERE --->
    
        <div class="form-group">
          <label><strong>S/MIME Encryption</strong></label>
        <!---
          <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
        --->
        <select class="form-control" name="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">                  
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
        
        </select> 
        </div>
      
        <!--- SMIME ENCRYPTION ENDS HERE --->
    
        
        <!--- SMIME SIGN STARTS HERE --->
    
        <div class="form-group">
          <label><strong>S/MIME SIGNATURE</strong></label>
        
          <p class="help-block">Effective only when S/MIME Certificate present</p>
        
        <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
        <option value="2" selected="selected">Sign Encrypted Messages Only</option>
        <option value="1">Sign all messages</option>
        
        </select> 
        </div>
      
        <!--- SMIME SIGN ENDS HERE --->
    
    
            <!--- PGP ENCRYPTION STARTS HERE --->
    
            <div class="form-group">
              <label><strong>PGP Encryption</strong></label>
            <!---
              <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
            --->
            <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
            <option value="2" selected="selected">Disable</option>
            <option value="1">Enable</option>
            
            </select> 
            </div>
          
            <!--- PGP ENCRYPTION ENDS HERE --->
    

  
            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
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
    
    
    
     <!--- QUARANTINE REPORTS STARTS HERE --->
    
     
     <div class="form-group">
      <label><strong>Quarantine Reports</strong></label>
    <!---
      <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    <select class="form-control" name="reports" data-placeholder="reports" id="reports" style="width: 100%">                  
    <option value="YES" selected="selected">Enable Report Only if Quarantined Messages Exist</option>
    <option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
    <option value="NO">Disable Quarantine Reports</option>
    
    </select> 
    </div>
    
         
              <div class="form-group" id="reportsfrequency">
                <label><strong>Quarantine Report Frequency</strong></label>
    <!---
                <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    
      <select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
      <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
      <option value="2">Every 2 Hours (Previous 2 Hours Quarantine Report)</option>
      <option value="4">Every 4 Hours (Previous 4 Hours Quarantine Report)</option>
      <option value="8">Every 8 Hours (Previous 8 Hours Quarantine Report)</option>
       </select> 
      </div>
    
      <!--- QUARANTINE REPORTS ENDS HERE --->
    
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
  
    <cfset m="Edit Internal Recipients: form.policy does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "policy")>
  
  <cfquery name="checkpolicy" datasource="hermes">
    select id from policy where id = <cfqueryparam value = #form.policy# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
  <cfif #checkpolicy.recordcount# LT 1>
  
    <cfset m="Edit Internal Recipients: checkpolicy.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- /CFIF #checkpolicy.recordcount# --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "policy") --->
  </cfif>
  
  <!--- FORM.REPORTS --->
  <cfif NOT StructKeyExists(form, "reports")>
  
    <cfset m="Edit Internal Recipients: form.reports does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "reports")>
  
  <cfif #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL">
  
  <cfelse>
  
    <cfset m="Edit Internal Recipients: form.reports is not YEs, NO, or ALL">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "reports") --->
  </cfif>
  
  <!--- FORM.FREQUENCY --->
  <cfif NOT StructKeyExists(form, "frequency")>
  
    <cfset m="Edit Internal Recipients: form.frequency does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "frequency")>
  
    <cfif NOT IsValid("integer", #form.frequency#)>
  
    <cfset m="Edit Internal Recipients: form.frequency is not valid Integer">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- NOT IsValid("integer", #form.frequency#) --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "frequency") --->
  </cfif>
  
  <!--- FORM.TRAIN_BAYES --->
  <cfif NOT StructKeyExists(form, "train_bayes")>
  
    <cfset m="Edit Internal Recipients: form.train_bayes does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "train_bayes")>
  
  <cfif #form.train_bayes# is "0" OR #form.train_bayes# is "1">
  
  <cfelse>
    <cfset m="Edit Internal Recipients: form.train_bayes is not 0 or 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <!--- #form.train_bayes# is "0" OR #form.train_bayes# is "1" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "train_bayes") --->
  </cfif>
  
  <!--- FORM.DOWNLOAD_MSG --->
  <cfif NOT StructKeyExists(form, "download_msg")>
  
    <cfset m="Edit Internal Recipients: form.download_msg does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "download_msg")>
  
  <cfif #form.download_msg# is "0" OR #form.download_msg# is "1">
  
  <cfelse>
    <cfset m="Edit Internal Recipients: form.download_msg is not 0 or 1">
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

  <cfset m="Edit Internal Recipients: form.pdf_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "pdf_enabled")>

<cfif #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2">

  <cfelse>
  <cfset m="Edit Internal Recipients: form.pdf_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pdf_enabled") --->
</cfif>

<!--- FORM.SMIME_ENABLED --->
<cfif NOT StructKeyExists(form, "smime_enabled")>

  <cfset m="Edit Internal Recipients: form.smime_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "smime_enabled")>

<cfif #form.smime_enabled# is "1" OR #form.smime_enabled# is "2">

<cfelse>

  <cfset m="Edit Internal Recipients: form.smime_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.smime_enabled# is "1" OR #form.smime_enabled# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "smime_enabled") --->
</cfif>

<!--- FORM.SIGN --->
<cfif NOT StructKeyExists(form, "sign")>

  <cfset m="Edit Internal Recipients: form.sign does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "sign")>

<cfif #form.sign# is "1" OR #form.sign# is "2">

<cfelse>
  <cfset m="Edit Internal Recipients: form.sign is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.sign# is "1" OR #form.sign# is "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "sign") --->
</cfif>

<!--- FORM.PGP_ENABLED --->
<cfif NOT StructKeyExists(form, "pgp_enabled")>

  <cfset m="Edit Internal Recipients: form.pgp_enabled does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "pgp_enabled")>

<cfif #form.pgp_enabled# is "1" OR #form.pgp_enabled# is "2">

<cfelse>
  <cfset m="Edit Internal Recipients: form.pgp_enabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.pgp_enabled# is not "1" OR #form.pgp_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pgp_enabled") --->
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

    <cfinclude template="./inc/edit_internal_recipients_djigzo.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

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

<form>
    
<span>
  <p>       


<a href="add_internal_recipients.cfm" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Recipient(s)</a>
&nbsp;&nbsp;
<button type="button" id="editoptions" class="btn btn-primary"><i class="fa fa-edit"></i>&nbsp;&nbsp;Edit Options</button>
&nbsp;&nbsp;
<button type="button" id="editencryption" class="btn btn-primary"><i class="fas fa-lock"></i>&nbsp;&nbsp;Edit Encryption</button>
&nbsp;&nbsp;
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>

</p>

<p>

</p>
</span>






<br>

<!---

<span>
  <p>  
<button type="button" class="btn btn-default">Select All</button>
 <button type="button" class="btn btn-default">Clear</button>
</p>
</span>
--->


<cfquery name="getrecipients" datasource="hermes">
  select recipients.id, recipients.id as theID, recipients.id as theOtherID, recipients.recipient, policy.policy_name, user_settings.report_enabled as report_enabled, user_settings.report_frequency as report_frequency, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore
  from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL group by recipients.id
  
  </cfquery>
    
    <cfif #getrecipients.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            <th>Recipient</th>
            <th>Policy</th>
            <th>Reports</th>
            <th>Frequency</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>SMIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getrecipients">



        <td><input type="checkbox" name="id" value="#id#"></td>
        <td><a href="view_recipient_certificates.cfm?type=1&id=#theID#" class="btn btn-secondary" role="button"><i class="fas fa-user-shield"></i></a></td>
        <td><a href="view_recipient_keyrings.cfm?type=1&id=#theOtherID#" class="btn btn-secondary" role="button"><i class="fas fa-user-lock"></i></a></td>
        <td>#recipient#</td>
         <td>#policy_name#</td>
            <td>#report_enabled#</td>
            <td>#report_frequency#</td>
            <td>#train_bayes#</td>
            <td>#download_msg#</td>
            <td>#pdf_enabled#</td>
            <td>#smime_enabled#</td>
            <td>#pgp_enabled#</td>
            <td>#digital_sign#</td>
            <td>#cert#</td>
            <td>#keystore#</td>

      

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
            <th></th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            <th>Recipient</th>
            <th>Policy</th>
            <th>Reports</th>
            <th>Frequency</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>SMIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getrecipients.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Internal Recipients were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getrecipients.recordcount --->
    </cfif>
    
    

    <div>&nbsp;</div>

    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>

  <!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT STARTS HERE  --->
   <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->

  <script>

    $('#reports').on('change',function(){
      if( $(this).val()==="NO" ){
      $("#reportsfrequency").hide()
      }
      else{
      $("#reportsfrequency").show()
      }
    });
    
    </script>
  
  <!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT ENDS HERE  --->

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