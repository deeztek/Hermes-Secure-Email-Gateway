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


<script>
$(document).ready(function() {
    $('#sortTable').DataTable( {
      'processing': true,
      "ajax": {
    "url": "./inc/get_int_recipients.cfm",
    "dataSrc": "DATA"
  },

      dom: 'Blfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ],
        lengthMenu: [
      [ 25, 50, 100, -1 ],
      [ '25 rows', '50 rows', '100 rows', 'Show all' ]

    ],
      'columnDefs': [

        {  targets: 0,
         render: function (data, type, row, meta) {
            return '<input type="checkbox" name="id" value=' + data + '>';
         }
         },
        {  targets: 1,
         render: function (data, type, row, meta) {
            return '<a href="view_recipient_certificates.cfm?type=1&id=' + data + '" class="btn btn-secondary" role="button"><i class="fas fa-user-shield"></i></a>';
         }
         },

         {  targets: 2,
         render: function (data, type, row, meta) {
            return '<a href="view_recipient_keyrings.cfm?type=1&id=' + data + '" class="btn btn-secondary" role="button"><i class="fas fa-user-lock"></i></a>';
         }
         },

   
      ],
      'select': {
         'style': 'multi'
      },
        "order": [[ 3, "asc" ]]
    });



  });
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

  
    <cfparam name = "step" default = "0">
    
    <cfparam name = "action" default = ""> 
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>  
    
  

  
        <!--- ERROR MESSAGES START HERE --->
  
        <cfif #m2# is "3">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) edited successfully</cfoutput><br>
        
          </div>
        </cfif>
        
  
        <cfif #m2# is "2">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) deleted successfully</cfoutput><br>
        
          </div>
        </cfif>

        <cfif #m2# is "1">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You must first select recipient(s) before clicking the Edit or Delete buttons</cfoutput>
          </div>
        
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
      
  
      <cfif #action# is "deleterecipient">

        <cfif NOT StructKeyExists(form, "recipient_id")>

        <cflocation url="view_internal_recipients.cfm?m2=1" addtoken="no">
      
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif StructKeyExists(form, "recipient_id")>

          <cfif #form.recipient_id# is "">

          <cflocation url="view_internal_recipients.cfm?m2=1" addtoken="no">
              
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
  
      
<cfoutput>
  <cflocation url="view_internal_recipients.cfm?m2=2" addtoken="no">
  </cfoutput>

<!--- /CFIF #form.recipient_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
</cfif>


<cfelseif #action# is "editrecipient">

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

<!--- FORM.FREQUENCY --->
<cfif NOT StructKeyExists(form, "frequency")>

  <cfset m="Edit Relay Recipients: form.frequency does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "frequency")>

  <cfif NOT IsValid("integer", #form.frequency#)>

  <cfset m="Edit Relay Recipients: form.frequency is not valid Integer">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- NOT IsValid("integer", #form.frequency#) --->
</cfif>

<!--- /CFIF StructKeyExists(form, "frequency") --->
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

<!--- FORM.RECIPIENT_ID --->
  <cfif NOT StructKeyExists(form, "recipient_id")>

  <cflocation url="view_internal_recipients.cfm?m2=1" addtoken="no">


    <cfelseif StructKeyExists(form, "recipient_id")>

    <cfif #form.recipient_id# is "">

    <cflocation url="view_internal_recipients.cfm?m2=1" addtoken="no">
        

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


<cfoutput>
<cflocation url="view_internal_recipients.cfm?m2=3" addtoken="no">
</cfoutput>

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


<a href="add_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Recipient(s)</a>
&nbsp;&nbsp;
<button type="button" id="edit" class="btn btn-warning"><i class="fa fa-edit"></i>&nbsp;&nbsp;Bulk Edit</button>
&nbsp;&nbsp;
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Bulk Delete</button>

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

<!---
    
    <cfquery name="getrecipients" datasource="hermes">
      select id, recipient, policy_id, pdf_enabled, smime_enabled, pgp_enabled, digital_sign from recipients where domain is NULL order by recipient asc
      </cfquery>
    
    <cfif #getrecipients.recordcount# GTE 1>
    --->


   
  <!---
    <form id="frm-sortTable" action="test.cfm" method="POST">
    --->
   
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
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
        </thead>
        <tbody>


        <td></td>
        <td></td>
        <td></td>
        <td></td>
         <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
      

          </tr>
<!---
        </cfoutput>
      --->
        </tbody>
        
       
        <tfoot>
          <tr>
              <th></th>
              <th>SMIME Certificates</th>
              <th>PGP Keyrings</th>
              <th>Recipient</th>
              <th>Policy</th>
              <th>Quarantine Reports</th>
              <th>Reports Frequency(Hours)</th>
              <th>Train Bayes</th>
              <th>Download Msg(s)</th>
              <th>PDF Encrypt</th>
              <th>S/MIME Encrypt</th>
              <th>PGP Encrypt</th>
              <th>Sign All</th>
              <th>S/MIME Cert(s)</th>
              <th>PGP Keyring(s)</th>
          </tr>
        </tfoot>
      

      </table>

    </form>
    
      <!---
    
    <cfelseif #getrecipients.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Relay Recipients were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getrecipients.recordcount --->
    </cfif>
    
    
  --->
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

</html>