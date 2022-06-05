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
  <title>Hermes SEG | Mail Queue</title>

  <cfinclude template="./inc/html_head.cfm" />

   <!-- Preloader -->
   <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>


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

    
<script>

  $(document).ready(function() {
    $("#messageactions").click(function() {
      var messageactions = [];
      $.each($("input[name='msg_id']:checked"), function() {
        messageactions.push($(this).val());
      });
      $('#messageactions_modal').modal('show').on('shown.bs.modal', function() {
      $("#messageactionsid").html('<input type="hidden" name="msg_id" value=' + messageactions + '>');
      });
    });
  });
  
  </script>

<script>

  $(document).ready(function() {
    $("#deletemessages").click(function() {
      var deletemessages = [];
      $.each($("input[name='msg_id']:checked"), function() {
        deletemessages.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="msg_id" value=' + deletemessages + '>');
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
            <h1 class="m-0">Mail Queue</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Mail Queue</li>
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
    



  <cfparam name = "m" default = "0">
  <cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
  <cfset m = session.m>

  <!--- ENABLE FOR DEBUG BELOW --->
<!---
  <cfoutput>M: #session.m#</cfoutput>
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

    <!--- DEBUG BELOW --->
    <!---
    <cfoutput>Action: #action#</cfoutput><br>
    --->


    <cfinclude template="./inc/get_mail_queue_settings.cfm" />

    <cfparam name = "successholdmessage" default = "0">
    <cfif StructKeyExists(session, "successholdmessage")>
    <cfif session.successholdmessage is not "">
    <cfset successholdmessage = session.successholdmessage>
    
    <!--- /CFIF for session.successholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
<!---
    <cfoutput>Success Hold Message: #successholdmessage#</cfoutput><br>
--->
  
    <cfparam name = "successholdmessage_email" default = "">
    <cfif StructKeyExists(session, "successholdmessage_email")>
    <cfif session.successholdmessage_email is not "">
    <cfset successholdmessage_email = session.successholdmessage_email>
    
    <!--- /CFIF for session.successholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
<!---
     <cfoutput>Success Hold Message Email: #successholdmessage_email#</cfoutput><br>
--->


    <cfparam name = "failureholdmessage" default = "0">
    <cfif StructKeyExists(session, "failureholdmessage")>
    <cfif session.failureholdmessage is not "">
    <cfset failureholdmessage = session.failureholdmessage>
    
    <!--- /CFIF for session.failureholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Failure Hold Message: #failureholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "failureholdmessage_email" default = "">
    <cfif StructKeyExists(session, "failureholdmessage_email")>
    <cfif session.failureholdmessage_email is not "">
    <cfset failureholdmessage_email = session.failureholdmessage_email>
    
    <!--- /CFIF for session.failureholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Failure Hold Message: #failureholdmessage_email#</cfoutput><br>
    --->

    <cfparam name = "successunholdmessage" default = "0">
    <cfif StructKeyExists(session, "successunholdmessage")>
    <cfif session.successunholdmessage is not "">
    <cfset successunholdmessage = session.successunholdmessage>
    
    <!--- /CFIF for session.successunholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successunholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Success Unhold Message: #successunholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "successunholdmessage_email" default = "">
    <cfif StructKeyExists(session, "successunholdmessage_email")>
    <cfif session.successunholdmessage_email is not "">
    <cfset successunholdmessage_email = session.successunholdmessage_email>
    
    <!--- /CFIF for session.successunholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successunholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Success Unhold Message: #successunholdmessage_email#</cfoutput><br>
    --->


    <cfparam name = "failureunholdmessage" default = "0">
    <cfif StructKeyExists(session, "failureunholdmessage")>
    <cfif session.failureunholdmessage is not "">
    <cfset failureunholdmessage = session.failureunholdmessage>
    
    <!--- /CFIF for session.failureunholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureunholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Failure Unhold Message: #failureunholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "failureunholdmessage_email" default = "">
    <cfif StructKeyExists(session, "failureunholdmessage_email")>
    <cfif session.failureunholdmessage_email is not "">
    <cfset failureunholdmessage_email = session.failureunholdmessage_email>
    
    <!--- /CFIF for session.failureunholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureunholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Failure Unhold Message: #failureunholdmessage_email#</cfoutput><br>
    --->


    <cfparam name = "successrequeuemessage" default = "0">
    <cfif StructKeyExists(session, "successrequeuemessage")>
    <cfif session.successrequeuemessage is not "">
    <cfset successrequeuemessage = session.successrequeuemessage>
    
    <!--- /CFIF for session.successrequeuemessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successrequeuemessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Success Re-queue Message: #successrequeuemessage#</cfoutput><br>
    --->
  
    <cfparam name = "successrequeuemessage_email" default = "">
    <cfif StructKeyExists(session, "successrequeuemessage_email")>
    <cfif session.successrequeuemessage_email is not "">
    <cfset successrequeuemessage_email = session.successrequeuemessage_email>
    
    <!--- /CFIF for session.successrequeuemessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successrequeuemessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Success Re-Queue Message: #successrequeuemessage_email#</cfoutput><br>
    --->
   


    <cfparam name = "failurerequeuemessage" default = "0">
  <cfif StructKeyExists(session, "failurerequeuemessage")>
  <cfif session.failurerequeuemessage is not "">
  <cfset failurerequeuemessage = session.failurerequeuemessage>
  
  <!--- /CFIF for session.failurerequeuemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurerequeuemessage --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Failure Re-queue Message: #failurerequeuemessage#</cfoutput><br>
  --->

  <cfparam name = "failurerequeuemessage_email" default = "">
  <cfif StructKeyExists(session, "failurerequeuemessage_email")>
  <cfif session.failurerequeuemessage_email is not "">
  <cfset failurerequeuemessage_email = session.failurerequeuemessage_email>
  
  <!--- /CFIF for session.failurerequeuemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurerequeuemessage_email --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
   <cfoutput>Failure Re-Queue Message: #failurerequeuemessage_email#</cfoutput><br>
  --->

  <cfparam name = "successdeletemessage" default = "0">
  <cfif StructKeyExists(session, "successdeletemessage")>
  <cfif session.successdeletemessage is not "">
  <cfset successdeletemessage = session.successdeletemessage>
  
  <!--- /CFIF for session.successdeletemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successdeletemessage --->
  </cfif>
  
    <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Re-queue Message: #successdeletemessage#</cfoutput><br>
  --->
  
  <cfparam name = "successdeletemessage_email" default = "">
  <cfif StructKeyExists(session, "successdeletemessage_email")>
  <cfif session.successdeletemessage_email is not "">
  <cfset successdeletemessage_email = session.successdeletemessage_email>
  
  <!--- /CFIF for session.successdeletemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successdeletemessage_email --->
  </cfif>
  
    <!--- DEBUG BELOW --->
  <!--- 
   <cfoutput>Success Re-Queue Message: #successdeletemessage_email#</cfoutput><br>
  --->
  
  
  
  <cfparam name = "failuredeletemessage" default = "0">
  <cfif StructKeyExists(session, "failuredeletemessage")>
  <cfif session.failuredeletemessage is not "">
  <cfset failuredeletemessage = session.failuredeletemessage>
  
  <!--- /CFIF for session.failuredeletemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failuredeletemessage --->
  </cfif>
  
  <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Failure Re-queue Message: #failuredeletemessage#</cfoutput><br>
  --->
  
  <cfparam name = "failuredeletemessage_email" default = "">
  <cfif StructKeyExists(session, "failuredeletemessage_email")>
  <cfif session.failuredeletemessage_email is not "">
  <cfset failuredeletemessage_email = session.failuredeletemessage_email>
  
  <!--- /CFIF for session.failuredeletemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failuredeletemessage_email --->
  </cfif>
  
  <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Failure Re-Queue Message: #failuredeletemessage_email#</cfoutput><br>
  --->

  <!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must first select message(s) before clicking the Message Actions button</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<!--- HOLD MESSAGE ERROR CODES START HERE --->

<cfif #failureholdmessage# is not "0">
        
  <cfif #m# is "3">
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
      <cfoutput>Hold Message Action completed with warnings</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "3" --->
    </cfif>
  
    <cfif #successholdmessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successholdmessage# messages were held:</strong></cfoutput><br>
        <cfoutput>#successholdmessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successholdmessage --->
    </cfif>
  
  
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!---
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            --->
            <cfoutput><strong>The following #failureholdmessage# messages were not held:</strong></cfoutput><br>
            <cfoutput>#failureholdmessage_email#</cfoutput>
          </div>
  
          <cfset session.m = 0>
          <cfset session.failureholdmessage = 0>
          <cfset session.failureholdmessage_email = "">
          <cfset session.successholdmessage = 0>
          <cfset session.successholdmessage_email = "">
  
        <cfelseif #failureholdmessage# is "0">
          
  <cfif #m# is "3">
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Hold Message Action completed successfully</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "3" --->
  </cfif>
  
    <cfif #successholdmessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successholdmessage# messages were held:</strong></cfoutput><br>
        <cfoutput>#successholdmessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successholdmessage --->
    </cfif>
  
    <cfset session.m = 0>
    <cfset session.failureholdmessage = 0>
    <cfset session.failureholdmessage_email = "">
    <cfset session.successholdmessage = 0>
    <cfset session.successholdmessage_email = "">
  
    <!--- /CFIF #failureholdmessage# is/is not "0" --->
  </cfif>
  
  <!--- HOLD MESSAGE ERROR CODES END HERE --->

  <!--- REQUEUE MESSAGE ERROR CODES START HERE --->

<cfif #failurerequeuemessage# is not "0">
        
  <cfif #m# is "4">
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
      <cfoutput>Re-queue Message Action completed with warnings</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "4" --->
    </cfif>
  
    <cfif #successrequeuemessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successrequeuemessage# messages were re-queued:</strong></cfoutput><br>
        <cfoutput>#successrequeuemessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successrequeuemessage --->
    </cfif>
  
  
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!---
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            --->
            <cfoutput><strong>The following #failurerequeuemessage# messages were not re-queued:</strong></cfoutput><br>
            <cfoutput>#failurerequeuemessage_email#</cfoutput>
          </div>
  
          <cfset session.m = 0>
          <cfset session.failurerequeuemessage = 0>
          <cfset session.failurerequeuemessage_email = "">
          <cfset session.successrequeuemessage = 0>
          <cfset session.successrequeuemessage_email = "">
  
        <cfelseif #failurerequeuemessage# is "0">
          
  <cfif #m# is "4">
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Re-queue Message Action completed successfully</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "4" --->
  </cfif>
  
    <cfif #successrequeuemessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successrequeuemessage# messages were re-queued:</strong></cfoutput><br>
        <cfoutput>#successrequeuemessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successrequeuemessage --->
    </cfif>
  
    <cfset session.m = 0>
    <cfset session.failurerequeuemessage = 0>
    <cfset session.failurerequeuemessage_email = "">
    <cfset session.successrequeuemessage = 0>
    <cfset session.successrequeuemessage_email = "">
  
    <!--- /CFIF #failurerequeuemessage# is/is not "0" --->
  </cfif>
  
      <!--- REQUEUE MESSAGE ERROR CODES END HERE --->


<!--- UNHOLD MESSAGE ERROR CODES START HERE --->

<cfif #failureunholdmessage# is not "0">
        
  <cfif #m# is "5">
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
      <cfoutput>Unhold Message Action completed with warnings</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "5" --->
    </cfif>
  
    <cfif #successunholdmessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successunholdmessage# messages were unheld:</strong></cfoutput><br>
        <cfoutput>#successunholdmessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successunholdmessage --->
    </cfif>
  
  
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!---
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            --->
            <cfoutput><strong>The following #failureunholdmessage# messages were not unheld:</strong></cfoutput><br>
            <cfoutput>#failureunholdmessage_email#</cfoutput>
          </div>
  
          <cfset session.m = 0>
          <cfset session.failureunholdmessage = 0>
          <cfset session.failureunholdmessage_email = "">
          <cfset session.successunholdmessage = 0>
          <cfset session.successunholdmessage_email = "">
  
        <cfelseif #failureunholdmessage# is "0">
          
  <cfif #m# is "5">
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Unhold Message Action completed successfully</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "5" --->
  </cfif>
  
    <cfif #successunholdmessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successunholdmessage# messages were unheld:</strong></cfoutput><br>
        <cfoutput>#successunholdmessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successunholdmessage --->
    </cfif>
  
    <cfset session.m = 0>
    <cfset session.failureunholdmessage = 0>
    <cfset session.failureunholdmessage_email = "">
    <cfset session.successunholdmessage = 0>
    <cfset session.successunholdmessage_email = "">
  
    <!--- /CFIF #failureunholdmessage# is/is not "0" --->
  </cfif>
  
      <!--- UNHOLD MESSAGE ERROR CODES END HERE --->

<!--- DELETE MESSAGE ERROR CODES START HERE --->

<cfif #failuredeletemessage# is not "0">
        
  <cfif #m# is "6">
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
      <cfoutput>Delete Message Action completed with warnings</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "6" --->
    </cfif>
  
    <cfif #successdeletemessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successdeletemessage# messages were deleted:</strong></cfoutput><br>
        <cfoutput>#successdeletemessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successdeletemessage --->
    </cfif>
  
  
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!---
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            --->
            <cfoutput><strong>The following #failuredeletemessage# messages were not deleted:</strong></cfoutput><br>
            <cfoutput>#failuredeletemessage_email#</cfoutput>
          </div>
  
          <cfset session.m = 0>
          <cfset session.failuredeletemessage = 0>
          <cfset session.failuredeletemessage_email = "">
          <cfset session.successdeletemessage = 0>
          <cfset session.successdeletemessage_email = "">
  
        <cfelseif #failuredeletemessage# is "0">
          
  <cfif #m# is "6">
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Delete Message Action completed successfully</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "6" --->
  </cfif>
  
    <cfif #successdeletemessage# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successdeletemessage# messages were deleted:</strong></cfoutput><br>
        <cfoutput>#successdeletemessage_email#</cfoutput>
      </div>
  
      <!--- /CFIF successdeletemessage --->
    </cfif>
  
    <cfset session.m = 0>
    <cfset session.failuredeletemessage = 0>
    <cfset session.failuredeletemessage_email = "">
    <cfset session.successdeletemessage = 0>
    <cfset session.successdeletemessage_email = "">
  
    <!--- /CFIF #failuredeletemessage# is/is not "0" --->
  </cfif>
  
      <!--- DELETE MESSAGE ERROR CODES END HERE --->


      

      <cfif #m# is "7">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Mail Queue Flush completed successfully. If messages remain in the mailqueue that are NOT On-Hold, consider troubleshooting delivery, unholding them or deleting them </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "8">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>There was a problem flushing the mail queue. Please check the mail logs for details</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>


      <cfif #m# is "9">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Mail Queue settings were saved successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "10">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>There was a problem viewing the mail queue message. This usually happens when the message is no longer in the mail queue</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>



<!--- ERROR MESSAGES END HERE --->

  <span>
    <p>  

      
<a href="preloader_view_mail_queue.cfm" class="btn btn-primary" role="button" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();"><i class="fas fa-sync"></i>&nbsp;&nbsp;Reload Mail Queue</a>
&nbsp;&nbsp;

    <cfoutput>
      <a href="##flushqueue_modal"  class="btn btn-primary" role="button" data-toggle="modal"><i class="fas fa-toilet"></i>&nbsp;&nbsp;Flush Mail Queue</a>
    </cfoutput>
    
    &nbsp;&nbsp;


      <button type="button" id="messageactions" class="btn btn-primary"><i class="fa fa-edit"></i>&nbsp;&nbsp;Message Actions</button>
      &nbsp;&nbsp;

      <button type="button" id="deletemessages" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete Message(s)</button>
      &nbsp;&nbsp;


</p>
</span>

<div class="card col-sm-8">
  
  <!---
  <div class="card-header border-1">

    <h3 class="card-title"><strong>Mail Queue Settings</strong></h3>

  <!--- class="card-header border-1" --->
</div>
--->

<form name="mailqueuesettings" method="post">

  <input type="hidden" name="action" value="Mail Queue Settings">

  <div class="col-sm-6">
   <div class="form-group">
            <label><strong>Bounce Queue Lifetime in Days</strong></label>
              
            <select class="form-control" name="bouncequeue" style="width: 100%;" id="bouncequeue">

  <!-- Check if there is a d in bouncequeue variable -->
<cfif #trim(bouncequeue)# contains "d">

  <!-- Remove d from bouncequeue variable -->
  <cfset BounceQueueNoD = reReplace("#trim(bouncequeue)#", "[d]", "", "ALL")>

<cfelse>

  <cfset BounceQueueNoD = #bouncequeue#>

  <!-- /CFIF #trim(bouncequeue)# contains "d" -->
</cfif>
      
               <cfoutput>
                <option value="#BounceQueueNoD#" selected>#BounceQueueNoD#d</option>
              </cfoutput>

              <cfloop from="0" to="90" index="i" step="1"> 
                <cfoutput>
                <option value="#i#">#i#d</option>
                </cfoutput>
                </cfloop>
                </select>   


                <label><strong>Max Queue Lifetime in Days</strong></label>
              
                <select class="form-control" name="maxqueue" style="width: 100%;" id="maxqueue">

                  <!-- Check if there is a d in maxqueue variable -->
<cfif #trim(maxqueue)# contains "d">

  <!-- Remove d from maxqueue variable -->
  <cfset MaxQueueNoD = reReplace("#trim(maxqueue)#", "[d]", "", "ALL")>

<cfelse>

  <cfset MaxQueueNoD = #maxqueue#>

  <!-- /CFIF #trim(maxqueue)# contains "d" -->
  </cfif>
    
          
                   <cfoutput>
                    <option value="#MaxQueueNoD#" selected>#MaxQueueNoD#d</option>
                  </cfoutput>

                  
                  <cfloop from="0" to="90" index="i" step="1"> 
                    <cfoutput>
                    <option value="#i#">#i#d</option>
                    </cfoutput>
                    </cfloop>
                    </select>   
              
              </div>
    </div>
  
  
  <div class="col-sm-6">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  </div>
    
  </form>  
  
<br>

  <!--- div class="card"  --->  
</div>








<!--- MESSAGE ACTIONS MODAL HTML STARTS HERE --->
 

<div class="modal fade" id="messageactions_modal" tabindex="-1" role="dialog" aria-labelledby="MessageActionsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Message(s) Actions </h4>
      </div>
        
      <div class="modal-body">

        <!---
        <p>Are you sure you to edit the recipient(s) you have selected? This action is irreversible!</p>
        --->

        <form name="message_actions" method="post" action="">
  
        <div id="messageactionsid"></div>
       
               
    <!--- ACTIONS TO TAKE STARTS HERE --->
  
    <div class="form-group">
      <label><strong>Action to Take</strong></label>

    <select class="form-control" name="action" data-placeholder="action" style="width: 100%">                  
    <option value="Hold Message" selected="selected">Hold Message(s)</option>
    <option value="Unhold Message">Unhold Message(s)</option>
    <option value="Requeue Message">Re-Queue Message(s)</option>
    </select> 
    </div>
  
    <!--- ACTIONS TO TAKE END HERE --->
  
     


          <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
      </div>
      <div class="modal-footer">
    
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
  </div>
  <!--- MESSAGE ACTIONS MODAL HTML ENDS HERE --->


  <!--- DELETE MESSAGES MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-danger">
          <!---
          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Delete Message(s) </h4>
        </div>
          
        <div class="modal-body">
          <p>Are you sure you to delete the message(s) you have selected? This action is irreversible and it has the potential to result in e-mail loss!</p>
    
        </div>
        <div class="modal-footer">
          <form name="requeue_messages" method="post" action="">
    
            <input type="hidden" name="action" value="Delete Message">

            <div id="deleteid"></div>
              
  
  
            <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
          <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
        </div>
      </div>
    </div>
    </div>
    <!--- DELETE MESSAGES MODAL HTML ENDS HERE --->



    <!--- FLUSH QUEUE MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="flushqueue_modal" tabindex="-1" role="dialog" aria-labelledby="flushqueueModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          <!---
          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Flush Mail Queue</h4>
        </div>
          
        <div class="modal-body">
          <p>Are you sure you to flush the mail queue? This action will attempt to re-deliver all messages in the queue that are NOT On-Hold</p>
    
        </div>
        <div class="modal-footer">
          <form name="flushmailqueue" method="post" action="">
    
            <input type="hidden" name="action" value="Flush Mail Queue">

        
  
            <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
          <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
        </div>
      </div>
    </div>
    </div>
    <!--- FLUSH QUEUE MODAL HTML ENDS HERE --->
  
        
    


         
  <cfif #action# is "Hold Message">

    <cfif NOT StructKeyExists(form, "msg_id")>

      <cfset m="Mail Queue: form.msg_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

  
      <!---
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      --->

      <cfelseif StructKeyExists(form, "msg_id")>

      <cfif #form.msg_id# is "">

        <cfset session.m = 1>

      <cflocation url="view_mail_queue.cfm" addtoken="no">
          
      <!---
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      --->

<cfelseif #form.msg_id# is not "">      

<cfloop index="i" list="#form.msg_id#" delimiters=",">


  <cfinclude template="./inc/mail_queue_hold_message.cfm">

    
    </cfloop>


<cflocation url="view_mail_queue.cfm" addtoken="no">


<!--- /CFIF #form.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>


<cfelseif #action# is "Unhold Message">

    <cfif NOT StructKeyExists(form, "msg_id")>

      <cfset m="Mail Queue: form.msg_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

  
      <!---
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      --->

      <cfelseif StructKeyExists(form, "msg_id")>

      <cfif #form.msg_id# is "">

        <cfset session.m = 1>

      <cflocation url="view_mail_queue.cfm" addtoken="no">
          
      <!---
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      --->

<cfelseif #form.msg_id# is not "">      

<cfloop index="i" list="#form.msg_id#" delimiters=",">


  <cfinclude template="./inc/mail_queue_unhold_message.cfm">

    
    </cfloop>


<cflocation url="view_mail_queue.cfm" addtoken="no">


<!--- /CFIF #form.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>


<cfelseif #action# is "Requeue Message">

  <cfif NOT StructKeyExists(form, "msg_id")>

    <cfset m="Mail Queue: form.msg_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "msg_id")>

    <cfif #form.msg_id# is "">

      <cfset session.m = 1>

    <cflocation url="view_mail_queue.cfm" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

<cfelseif #form.msg_id# is not "">      

<cfloop index="i" list="#form.msg_id#" delimiters=",">


<cfinclude template="./inc/mail_queue_requeue_message.cfm">

  
  </cfloop>


<cflocation url="view_mail_queue.cfm" addtoken="no">


<!--- /CFIF #form.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>

<cfelseif #action# is "Delete Message">

  <cfif NOT StructKeyExists(form, "msg_id")>

    <cfset m="Mail Queue: form.msg_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "msg_id")>

    <cfif #form.msg_id# is "">

      <cfset session.m = 1>

    <cflocation url="view_mail_queue.cfm" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

<cfelseif #form.msg_id# is not "">      

<cfloop index="i" list="#form.msg_id#" delimiters=",">


<cfinclude template="./inc/mail_queue_delete_message.cfm">

  
  </cfloop>


<cflocation url="view_mail_queue.cfm" addtoken="no">


<!--- /CFIF #form.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>



<cfelseif #action# is "Flush Mail Queue">



<cfinclude template="./inc/mail_queue_flush_mailqueue.cfm">


<cflocation url="view_mail_queue.cfm" addtoken="no">


<cfelseif #action# is "Mail Queue Settings">

  <cfif NOT StructKeyExists(form, "bouncequeue")>

    <cfset m="Mail Queue: form.bouncequeue does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "bouncequeue")>

    <cfif #form.bouncequeue# is "">

      <cfset m="Mail Queue: form.bouncequeue is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<cfelseif #form.bouncequeue# is not "">   

<cfif NOT IsValid("integer", #form.bouncequeue#)>
  

<cfset m="Mail Queue: form.bouncequeue is not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset step=1>

<!--- /CFIF IsValid("integer", #form.bouncequeue#) --->
</cfif>

<!--- /CFIF #form.bouncequeue# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "bouncequeue") --->
</cfif>

<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "maxqueue")>

    <cfset m="Mail Queue: form.maxqueue does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "maxqueue")>

    <cfif #form.maxqueue# is "">

      <cfset m="Mail Queue: form.maxqueue is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      

<cfelseif #form.maxqueue# is not "">      

  <cfif NOT IsValid("integer", #form.maxqueue#)>
  

    <cfset m="Mail Queue: form.maxqueue is not valid integer">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelse>
    
    <cfset step=2>
    
    <!--- /CFIF IsValid("integer", #form.maxqueue#) --->
    </cfif>

<!--- /CFIF #form.maxqueue# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "maxqueue") --->
</cfif>


<!--- /CFIF #step# is "1" --->  
</cfif>

<cfif #step# is "2">

<cfinclude template="./inc/mail_queue_set_queue_settings.cfm">

<cfinclude template="./inc/generate_postfix_configuration.cfm">

<cfinclude template="./inc/restart_postfix.cfm">

<cfset session.m=9>

<cflocation url="view_mail_queue.cfm" addtoken="no">


<!--- /CFIF #step# is "2" --->
</cfif>


    
<!--- /CFIF #action# is --->     
</cfif> 
    




<form>
    
    


<!---

<span>
  <p>  
<button type="button" class="btn btn-default">Select All</button>
 <button type="button" class="btn btn-default">Clear</button>
</p>
</span>
--->

<cfinclude template="./inc/mail_queue_check.cfm">

  <!--- ENABLE FOR DEBUG BELOW --->
<!---
customtrans: <cfoutput>#customtrans3#</cfoutput>  
--->   
    <cfif #getqueue.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>View</th>
            <th>ID</th>
            <th>Queue Type</th>
            <th>Date</th>
            <th>From</th>
            <th>To</th>
            <th>Subject</th>
            <th>Diag Code</th>         
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getqueue">

  <cfinclude template="./inc/mail_queue_get_message.cfm">

  <td><input type="checkbox" name="msg_id" value="#msg_id#"></td>

  <td><a href="preloader_view_mail_queue_message.cfm?msg_id=#msg_id#" class="btn btn-secondary" role="button"><i class="fas fa-search"></i></a></td>

  <td>#msg_id#</td>


<td>#queue_type#</td>  



<td>#htmlEditFormat(msgDate)#</td>

<td>#htmlEditFormat(msgFrom)#</td>

<td>#htmlEditFormat(msgTo)#</td>
        
<td>#msgSubject#</td>

<td>#msgDiag#</td>
    
          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>View</th>
            <th>ID</th>
            <th>Queue Type</th>
            <th>Date</th>
            <th>From</th>
            <th>To</th>
            <th>Subject</th>
            <th>Diag Code</th>    
           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getqueue.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Message(s) were found in the mail queue</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getqueue.recordcount --->
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