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
  <title>Hermes SEG | System Users</title>

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
      
          "order": [[ 2, "asc" ]]
      } );
  } );
    </script>


<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  

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
<body class="hold-transition sidebar-mini">
<div class="wrapper">



  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">System Users</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Users</li>
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

<!---
<cfparam name = "applied" default = "1"> 
<cfquery name="getapplied" datasource="hermes">
select applied from system_users where applied = '2'
</cfquery>

<cfif #getapplied.recordcount# GTE 1>
<cfset applied = 2>
</cfif>
    
--->

  
        <!--- ERROR MESSAGES START HERE --->
  <!---
        <cfif #applied# is "2">

          <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-exclamation"></i> Warning!</h4>
            <cfoutput>Changes to the System Users must be applied. Click the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput>
        
            <div>&nbsp;&nbsp;</div>
            <span style="width: 100%;text-align: center">
        
              <div>
                <!--- APPLY SETTINGS BUTTON STARTS HERE --->
                <cfoutput>
                 
                  <a href="##applysettings_modal"  class="btn btn-primary" role="button" data-toggle="modal"><i class="fa fa-check"></i>&nbsp;&nbsp;Apply Settings</a>
                  </cfoutput>
                  
                  <!--- APPLY SETTNGS BUTTON ENDS HERE --->
                </div>
          </span>
        
          </div>
        
        
          
        </cfif>
      --->
        
        <!--- ERROR MESSAGES END HERE --->

        
<cfif #m# is "1">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>System User was deleted successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>


        <!--- APPLY SETTINGS MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="applysettings_modal" tabindex="-1" role="dialog" aria-labelledby="applysettingsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Apply System User Settings </h4>
      </div>
        
      <div class="modal-body">
        <p>Applying Settings will automatically <strong>log you out</strong> of the system. If you changed any usernames or passwords, you must use the new credentials to log back in. Do you wish to continue applying the settings?</p>

      </div>
      <div class="modal-footer">
        <form name="apply_settings" method="post">

          <input type="hidden" name="action" value="applysettings">
             <button type="input" class="btn btn-danger" onclick="this.form.submit();">Yes</button>
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- APPLY SETTINGS MODAL HTML ENDS HERE --->

        

  
      <cfif #action# is "applysettings">

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


<a href="./inc/create_new.cfm?type=systemuser" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create System User</a>

<!---
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>
--->
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


<cfquery name="getsystemusers" datasource="hermes">
  select id, username, email, first_name, last_name, access_control, system, applied from system_users
  
  </cfquery>
    
    <cfif #getsystemusers.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>

            <!---
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            --->    
        
            <th>Edit</th>
            <th>Username</th>
            <th>E-Mail</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Access Control</th>
            <th>Built-In</th>
            <th>Active</th>
            
            
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getsystemusers">


<!---
        <td><input type="checkbox" name="id" value="#id#"></td>
--->
        <td><a href="edit_system_user.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>

        <td>#username#</td>
         <td>#email#</td>
            <td>#first_name#</td>
            <td>#last_name#</td>

            <cfif #access_control# is "one_factor">
              <td>ONE FACTOR</td>
            <cfelse>

  <td>TWO FACTOR</td>
            </cfif>

            <cfif #system# is "1">
            <td>YES</td>
            <cfelse>
            <td>NO</td>
            </cfif>

            <cfif #applied# is "1">
              <td>YES</td>
              <cfelse>
              <td>NO</td>
              </cfif>
       
     

      

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
          
            <!---
            <th></th>
            --->
            <th>Edit</th>
            <th>Username</th>
            <th>E-Mail</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Access Control</th>
            <th>Built-In</th>
            <th>Active</th>
            
            
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getsystemusers.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No System Users were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getrecipients.recordcount --->
    </cfif>
    
    

    <div>&nbsp;</div>

    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- Control Sidebar -->
<aside class="control-sidebar control-sidebar-dark">
<!-- Control sidebar content goes here -->
<div class="p-3">
  <h5>Title</h5>
  <p>Sidebar content</p>
</div>
</aside>
<!-- /.control-sidebar -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>


</html>