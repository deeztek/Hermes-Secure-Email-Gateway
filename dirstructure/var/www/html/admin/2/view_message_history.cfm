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
  <title>Hermes SEG | Message History</title>

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
            [ 50, 75, 100, -1 ],
      [ '50 rows', '75 rows', '100 rows', 'Show all' ]
  
      ],
      
          "order": [[ 3, "desc" ]]
      } );
  } );
    </script>

  

<script>

  $(document).ready(function() {
    $("#messageactions").click(function() {
      var messageactions = [];
      $.each($("input[name='mail_id']:checked"), function() {
        messageactions.push($(this).val());
      });
      $('#messageactions_modal').modal('show').on('shown.bs.modal', function() {
      $("#messageactionsid").html('<input type="hidden" name="mail_id" value=' + messageactions + '>');
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

<!--- BACK TO TOP BUTTON STYLE ---> 
<style>
  #btn-back-to-top {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: none;
  }
  </style>

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
            <h1 class="m-0">Message History</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Message History</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    <!-- Back to top button -->
<button
type="button"
class="btn btn-danger btn-floating btn-lg"
id="btn-back-to-top"
>
<i class="fas fa-arrow-up"></i>
</button>
    
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

    <!--- BLOCK SENDER PARAMETERS START HERE  --->

  <cfparam name = "successblocksender" default = "0">
  <cfif StructKeyExists(session, "successblocksender")>
  <cfif session.successblocksender is not "">
  <cfset successblocksender = session.successblocksender>
  
  <!--- /CFIF for session.successblocksender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successblocksender --->
  </cfif>

  <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Block Sender: #successblocksender#</cfoutput><br>
  --->

  <cfparam name = "successblocksender_email" default = "">
  <cfif StructKeyExists(session, "successblocksender_email")>
  <cfif session.successblocksender_email is not "">
  <cfset successblocksender_email = session.successblocksender_email>
  
  <!--- /CFIF for session.successblocksender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successblocksender_email --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 

   <cfoutput>Success Block Sender Email: #successblocksender_email#</cfoutput><br>
  --->

  <cfparam name = "failureblocksender" default = "0">
  <cfif StructKeyExists(session, "failureblocksender")>
  <cfif session.failureblocksender is not "">
  <cfset failureblocksender = session.failureblocksender>
  
  <!--- /CFIF for session.failureblocksender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureblocksender --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Block Sender: #failureblocksender#</cfoutput><br>
  --->

  <cfparam name = "failureblocksender_email" default = "">
  <cfif StructKeyExists(session, "failureblocksender_email")>
  <cfif session.failureblocksender_email is not "">
  <cfset failureblocksender_email = session.failureblocksender_email>
  
  <!--- /CFIF for session.failureblocksender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureblocksender_email --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
  
  <cfoutput>Failure Block Sender Email: #failureblocksender_email#</cfoutput><br>
  --->

      <!--- BLOCK SENDER PARAMETERS END HERE  --->

      <!--- ALLOW SENDER PARAMETERS START HERE  --->

  <cfparam name = "successallowsender" default = "0">
  <cfif StructKeyExists(session, "successallowsender")>
  <cfif session.successallowsender is not "">
  <cfset successallowsender = session.successallowsender>
  
  <!--- /CFIF for session.successallowsender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successallowsender --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Allow Sender: #successallowsender#</cfoutput><br>
  --->

  <cfparam name = "successallowsender_email" default = "">
  <cfif StructKeyExists(session, "successallowsender_email")>
  <cfif session.successallowsender_email is not "">
  <cfset successallowsender_email = session.successallowsender_email>
  
  <!--- /CFIF for session.successallowsender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successallowsender_email --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
   <cfoutput>Success Allow Sender Email: #successallowsender_email#</cfoutput><br>
  --->

  <cfparam name = "failureallowsender" default = "0">
  <cfif StructKeyExists(session, "failureallowsender")>
  <cfif session.failureallowsender is not "">
  <cfset failureallowsender = session.failureallowsender>
  
  <!--- /CFIF for session.failureallowsender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureallowsender --->
  </cfif>

    <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Failure Allow Sender: #failureallowsender#</cfoutput><br>
  --->

  <cfparam name = "failureallowsender_email" default = "">
  <cfif StructKeyExists(session, "failureallowsender_email")>
  <cfif session.failureallowsender_email is not "">
  <cfset failureallowsender_email = session.failureallowsender_email>
  
  <!--- /CFIF for session.failureallowsender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureallowsender_email --->
  </cfif>
  
    <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Failure Allow Sender Email: #failureallowsender_email#</cfoutput><br>
  --->

    <!--- ALLOW SENDER PARAMETERS END HERE  --->

  <!--- RELEASE MESSAGES PARAMETERS START HERE  --->

  <cfparam name = "successreleasemessage" default = "0">
  <cfif StructKeyExists(session, "successreleasemessage")>
  <cfif session.successreleasemessage is not "">
  <cfset successreleasemessage = session.successreleasemessage>
  
  <!--- /CFIF for session.successreleasemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successreleasemessage --->
  </cfif>

  <cfparam name = "successreleasemessage_email" default = "">
  <cfif StructKeyExists(session, "successreleasemessage_email")>
  <cfif session.successreleasemessage_email is not "">
  <cfset successreleasemessage_email = session.successreleasemessage_email>
  
  <!--- /CFIF for session.successreleasemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successreleasemessage_email --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Release Message: #successreleasemessage#</cfoutput><br>
  --->

  <cfparam name = "failurereleasemessage" default = "0">
  <cfif StructKeyExists(session, "failurereleasemessage")>
  <cfif session.failurereleasemessage is not "">
  <cfset failurereleasemessage = session.failurereleasemessage>
  
  <!--- /CFIF for session.failurereleasemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurereleasemessage --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Release Message: #failurereleasemessage#</cfoutput><br>
  --->

  <cfparam name = "failurereleasemessage_email" default = "">
  <cfif StructKeyExists(session, "failurereleasemessage_email")>
  <cfif session.failurereleasemessage_email is not "">
  <cfset failurereleasemessage_email = session.failurereleasemessage_email>
  
  <!--- /CFIF for session.failurereleasemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurereleasemessage_email --->
  </cfif>

    <!--- RELEASE MESSAGES PARAMETERS END HERE  --->

  <!--- TRAIN HAM MESSAGE PARAMETERS START HERE --->
  

  <cfparam name = "successhammessage" default = "0">
  <cfif StructKeyExists(session, "successhammessage")>
  <cfif session.successhammessage is not "">
  <cfset successhammessage = session.successhammessage>
  
  <!--- /CFIF for session.successhammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successhammessage --->
  </cfif>

  <cfparam name = "successhammessage_email" default = "">
  <cfif StructKeyExists(session, "successhammessage_email")>
  <cfif session.successhammessage_email is not "">
  <cfset successhammessage_email = session.successhammessage_email>
  
  <!--- /CFIF for session.successhammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successhammessage_email --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Ham Message: #successhammessage#</cfoutput><br>
  --->
  
  <cfparam name = "failurehammessage" default = "0">
  <cfif StructKeyExists(session, "failurehammessage")>
  <cfif session.failurehammessage is not "">
  <cfset failurehammessage = session.failurehammessage>
  
  <!--- /CFIF for session.failurehammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurehammessage --->
  </cfif>

        <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Ham Message: #failurehammessage#</cfoutput><br>
  --->
  
  <cfparam name = "failurehammessage_email" default = "">
  <cfif StructKeyExists(session, "failurehammessage_email")>
  <cfif session.failurehammessage_email is not "">
  <cfset failurehammessage_email = session.failurehammessage_email>
  
  <!--- /CFIF for session.failurehammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurehammessage_email --->
  </cfif>

  <!--- TRAIN HAM MESSAGE PARAMETERS END HERE --->

    <!--- TRAIN SPAM MESSAGE PARAMETERS START HERE --->
  

    <cfparam name = "successspammessage" default = "0">
    <cfif StructKeyExists(session, "successspammessage")>
    <cfif session.successspammessage is not "">
    <cfset successspammessage = session.successspammessage>
    
    <!--- /CFIF for session.successspammessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successspammessage --->
    </cfif>
  
    <cfparam name = "successspammessage_email" default = "">
    <cfif StructKeyExists(session, "successspammessage_email")>
    <cfif session.successspammessage_email is not "">
    <cfset successspammessage_email = session.successspammessage_email>
    
    <!--- /CFIF for session.successspammessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successspammessage_email --->
    </cfif>
  
        <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Success Ham Message: #successspammessage#</cfoutput><br>
    --->
    
    <cfparam name = "failurespammessage" default = "0">
    <cfif StructKeyExists(session, "failurespammessage")>
    <cfif session.failurespammessage is not "">
    <cfset failurespammessage = session.failurespammessage>
    
    <!--- /CFIF for session.failurespammessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failurespammessage --->
    </cfif>
  
          <!--- DEBUG BELOW --->
    <!--- 
  
    <cfoutput>Failure Ham Message: #failurespammessage#</cfoutput><br>
    --->
    
    <cfparam name = "failurespammessage_email" default = "">
    <cfif StructKeyExists(session, "failurespammessage_email")>
    <cfif session.failurespammessage_email is not "">
    <cfset failurespammessage_email = session.failurespammessage_email>
    
    <!--- /CFIF for session.failurespammessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failurespammessage_email --->
    </cfif>
  
    <!--- TRAIN SPAM MESSAGE PARAMETERS END HERE --->

  <!--- FORGET MESSAGE PARAMETERS START HERE --->
  

  <cfparam name = "successforgetmessage" default = "0">
  <cfif StructKeyExists(session, "successforgetmessage")>
  <cfif session.successforgetmessage is not "">
  <cfset successforgetmessage = session.successforgetmessage>
  
  <!--- /CFIF for session.successforgetmessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successforgetmessage --->
  </cfif>

  <cfparam name = "successforgetmessage_email" default = "">
  <cfif StructKeyExists(session, "successforgetmessage_email")>
  <cfif session.successforgetmessage_email is not "">
  <cfset successforgetmessage_email = session.successforgetmessage_email>
  
  <!--- /CFIF for session.successforgetmessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successforgetmessage_email --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Ham Message: #successforgetmessage#</cfoutput><br>
  --->
  
  <cfparam name = "failureforgetmessage" default = "0">
  <cfif StructKeyExists(session, "failureforgetmessage")>
  <cfif session.failureforgetmessage is not "">
  <cfset failureforgetmessage = session.failureforgetmessage>
  
  <!--- /CFIF for session.failureforgetmessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureforgetmessage --->
  </cfif>

        <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Ham Message: #failureforgetmessage#</cfoutput><br>
  --->
  
  <cfparam name = "failureforgetmessage_email" default = "">
  <cfif StructKeyExists(session, "failureforgetmessage_email")>
  <cfif session.failureforgetmessage_email is not "">
  <cfset failureforgetmessage_email = session.failureforgetmessage_email>
  
  <!--- /CFIF for session.failureforgetmessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureforgetmessage_email --->
  </cfif>

  <!--- FORGET MESSAGE PARAMETERS END HERE --->

    <cfparam name = "step" default = "0">
    
    <cfparam name = "action" default = ""> 
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>  
    
  <cfset defaultenddate2=#DateFormat(Now(),"yyyy-mm-dd")#>
  <cfset defaultendtime="23:59:59">
  <cfset defaultenddate="#defaultenddate2# #defaultendtime#">
  <cfset defaultstartdate=#DateAdd("h", -24, defaultenddate2)#>
  <cfset defaultstartdate=#DateFormat(defaultstartdate,"yyyy-mm-dd")#>
  <cfset defaultstarttime="00:00:00">
  <cfset defaultstartdate="#defaultstartdate# #defaultstarttime#">


  <!--- DEBUG ENABLE BELOW --->
<!---
  <cfoutput>Startdate: #defaultstartdate#<br>
  Enddate: #defaultenddate#</cfoutput>
 --->

    <cfparam name = "startdate" default = "#defaultstartdate#"> 
    <cfif IsDefined("url.startdate") is "True">
    <cfif url.startdate is not "">
    <cfif isValid("date", #url.startdate#)> 
    <cfset startdate = url.startdate>
    <cfelseif NOT isValid("date", #url.startdate#)>

    <cfset m="Message History: url.startdate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.startdate#) --->
     </cfif>

     <cfelseif url.startdate is "">

     <cfset m="Message History: url.startdate is empty">
     <cfinclude template="./inc/error.cfm">
     <cfabort>

    <!--- /CFIF url.startdate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.startdate") --->
    </cfif>
    
    <cfparam name = "enddate" default = "#defaultenddate#"> 
    <cfif IsDefined("url.enddate") is "True">
    <cfif url.enddate is not "">
    <cfif isValid("date", #url.enddate#)> 
    <cfset enddate = url.enddate>
    <cfelseif NOT isValid("date", #url.enddate#)>
    
    <cfset m="Message History: url.enddate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.enddate#) --->
     </cfif>

    <cfelseif url.enddate is "">

      <cfset m="Message History: url.enddate is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <!--- /CFIF url.enddate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.enddate") --->
    </cfif>
    
    <!---
    <cfparam name = "starttime" default = "00:00:00"> 
    <cfif IsDefined("url.starttime") is "True">
    <cfif url.starttime is not "">
    <cfif isValid("time", #url.starttime#)> 
    <cfset starttime = url.starttime>
    <cfelseif NOT isValid("time", #url.starttime#)>
    
    <cfset m="Message History: url.starttime is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.starttime#) --->
     </cfif>

    <!--- /CFIF url.starttime is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.starttime") --->
    </cfif>
    
    <cfparam name = "endtime" default = "23:59:59"> 

    <cfif IsDefined("url.endtime") is "True">

    <cfif url.endtime is not "">

    <cfif isValid("time", #url.endtime#)> 

    <cfset endtime = url.endtime>

    <cfelseif NOT isValid("time", #url.endtime#)>
 
    <cfset m="Message History: url.endtime is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.endtime#) --->
     </cfif>

    <cfelseif #url.endtime# is "">

    <cfset m="Message History: url.endtime is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF url.endtime is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.endtime") --->
    </cfif>

  --->

    <cfparam name = "limit" default = "1000">

    <cfif IsDefined("url.limit") is "True">

    <cfif url.limit is not "">

    <cfif #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000"> 

    <cfset limit = url.limit>

    <cfelse>
 
    <cfset m="Message History: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000" --->
     </cfif>

    <cfelseif #limit# is "">

    <cfset m="Message History: url.limit is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF url.limit is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.limit") --->
    </cfif>


    <cfquery name="getmsgs" datasource="hermes">
      SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.time_iso between '#startdate#' and '#enddate#' order by msgs.time_iso desc limit #limit#
      </cfquery>

  
       <!--- ERROR MESSAGES START HERE --->
  
       
        
  

       <cfif #m# is "1">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>You must first select message(s) before clicking the Message Actions button</cfoutput>
        </div>

        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "2">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>Unable to Block Sender because Recipient was not found</cfoutput>
        </div>

        <cfset session.m = 0>
      
      </cfif>

<!--- BLOCK SENDER ERROR CODES START HERE --->

<cfif #failureblocksender# is not "0">
        
<cfif #m# is "3">
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
    <cfoutput>Message Block Sender Action completed with warnings</cfoutput><br> 
  </div>

  <!--- /CFIF #m# is "3" --->
  </cfif>

  <cfif #successblocksender# is not "0">

    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      --->
      <cfoutput><strong>The following #successblocksender# senders were blocked:</strong></cfoutput><br>
      <cfoutput>#successblocksender_email#</cfoutput>
    </div>

    <!--- /CFIF successblocksender --->
  </cfif>


        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <!---
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          --->
          <cfoutput><strong>The following #failureblocksender# senders already existed and they were NOT blocked:</strong></cfoutput><br>
          <cfoutput>#failureblocksender_email#</cfoutput>
        </div>

        <cfset session.m = 0>
        <cfset session.failureblocksender = 0>
        <cfset session.failureblocksender_email = "">
        <cfset session.successblocksender = 0>
        <cfset session.successblocksender_email = "">

      <cfelseif #failureblocksender# is "0">
        
<cfif #m# is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Message Block Sender Action completed successfully</cfoutput><br> 
  </div>

  <!--- /CFIF #m# is "3" --->
</cfif>

  <cfif #successblocksender# is not "0">

    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      --->
      <cfoutput><strong>The following #successblocksender# senders were blocked:</strong></cfoutput><br>
      <cfoutput>#successblocksender_email#</cfoutput>
    </div>

    <!--- /CFIF successblocksender --->
  </cfif>

  <cfset session.m = 0>
  <cfset session.failureblocksender = 0>
  <cfset session.failureblocksender_email = "">
  <cfset session.successblocksender = 0>
  <cfset session.successblocksender_email = "">

  <!--- /CFIF #failureblocksender# is/is not "0" --->
</cfif>

    <!--- BLOCK SENDER ERROR CODES END HERE --->

    <!--- ALLOW SENDER ERROR CODES START HERE --->

<cfif #failureallowsender# is not "0">
        
  <cfif #m# is "4">
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
      <cfoutput>Message Allow Sender Action completed with warnings</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "4" --->
    </cfif>
  
    <cfif #successallowsender# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successallowsender# senders were allowed:</strong></cfoutput><br>
        <cfoutput>#successallowsender_email#</cfoutput>
      </div>
  
      <!--- /CFIF successallowsender --->
    </cfif>
  
  
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!---
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            --->
            <cfoutput><strong>The following #failureallowsender# senders already existed and they were NOT allowed:</strong></cfoutput><br>
            <cfoutput>#failureallowsender_email#</cfoutput>
          </div>
  
          <cfset session.m = 0>
          <cfset session.failureallowsender = 0>
          <cfset session.failureallowsender_email = "">
          <cfset session.successallowsender = 0>
          <cfset session.successallowsender_email = "">
  
        <cfelseif #failureallowsender# is "0">
          
  <cfif #m# is "4">
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Message Allow Sender Action completed successfully</cfoutput><br> 
    </div>
  
    <!--- /CFIF #m# is "4" --->
  </cfif>
  
    <cfif #successallowsender# is not "0">
  
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <!---
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        --->
        <cfoutput><strong>The following #successallowsender# senders were allowed:</strong></cfoutput><br>
        <cfoutput>#successallowsender_email#</cfoutput>
      </div>
  
      <!--- /CFIF successallowsender --->
    </cfif>
  
    <cfset session.m = 0>
    <cfset session.failureallowsender = 0>
    <cfset session.failureallowsender_email = "">
    <cfset session.successallowsender = 0>
    <cfset session.successallowsender_email = "">
  
    <!--- /CFIF #failureallowsender# is/is not "0" --->
  </cfif>

    <!--- ALLOW SENDER ERROR CODES END HERE --->

  <!--- RELEASE MESSAGE ERROR CODES START HERE --->
  <cfif #failurereleasemessage# is not "0">
        
    <cfif #m# is "5">
      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
        <cfoutput>Release Message(s) Action completed with warnings</cfoutput><br> 
      </div>
    
      <!--- /CFIF #m# is "5" --->
      </cfif>
    
      <cfif #successreleasemessage# is not "0">
    
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <!---
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          --->
          <cfoutput><strong>The following #successreleasemessage# messages were released:</strong></cfoutput><br>
          <cfoutput>#successreleasemessage_email#</cfoutput>
        </div>
    
        <!--- /CFIF successreleasemessage --->
      </cfif>
    
    
            <div class="alert alert-danger alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <!---
              <h4><i class="icon fa fa-ban"></i> Oops!</h4>
              --->
              <cfoutput><strong>The following #failurereleasemessage# message(s) were NOT released:</strong></cfoutput><br>
              <cfoutput>#failurereleasemessage_email#</cfoutput>
            </div>
    
            <cfset session.m = 0>
            <cfset session.failurereleasemessage = 0>
            <cfset session.failurereleasemessage_email = "">
            <cfset session.successreleasemessage = 0>
            <cfset session.successreleasemessage_email = "">
    
  <cfelseif #failurereleasemessage# is "0">
            
    <cfif #m# is "5">
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
 
        <cfoutput>Release Message(s) Action completed successfully</cfoutput><br> 
      </div>

    
      <!--- /CFIF #m# is "5" --->
    </cfif>
    
      <cfif #successreleasemessage# is not "0">
    
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <!---
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          --->
          <cfoutput><strong>The following #successreleasemessage# message(s) were released:</strong></cfoutput><br>
          <cfoutput>#successreleasemessage_email#</cfoutput>
        </div>
    
        <!--- /CFIF successreleasemessage --->
      </cfif>
    
      <cfset session.m = 0>
      <cfset session.successreleasemessage = 0>
      <cfset session.successreleasemessage_email = "">
    
      <!--- /CFIF #failurereleasemessage# is/is not "0" --->
    </cfif>

      <!--- RELEASE MESSAGE ERROR CODES END HERE --->

        <!--- TRAIN HAM ERROR CODES START HERE --->
        <cfif #failurehammessage# is not "0">
        
          <cfif #m# is "6">
            <div class="alert alert-warning alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
              <cfoutput>Train Message(s) as Ham Action completed with warnings</cfoutput><br> 
            </div>
          
            <!--- /CFIF #m# is "6" --->
            </cfif>
          
            <cfif #successhammessage# is not "0">
          
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <!---
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                --->
                <cfoutput><strong>The following #successhammessage# messages were trained:</strong></cfoutput><br>
                <cfoutput>#successhammessage_email#</cfoutput>
              </div>
          
              <!--- /CFIF successhammessage --->
            </cfif>
          
          
                  <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <!---
                    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                    --->
                    <cfoutput><strong>The following #failurehammessage# message(s) were NOT trained:</strong></cfoutput><br>
                    <cfoutput>#failurehammessage_email#</cfoutput>
                  </div>
          
                  <cfset session.m = 0>
                  <cfset session.failurehammessage = 0>
                  <cfset session.failurehammessage_email = "">
                  <cfset session.successhammessage = 0>
                  <cfset session.successhammessage_email = "">
          
        <cfelseif #failurehammessage# is "0">
                  
          <cfif #m# is "6">
            <div class="alert alert-success alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fa fa-check"></i> Success!</h4>
       
              <cfoutput>Train Message(s) as Ham Action completed successfully</cfoutput><br> 
            </div>
      
          
            <!--- /CFIF #m# is "6" --->
          </cfif>
          
            <cfif #successhammessage# is not "0">
          
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <!---
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                --->
                <cfoutput><strong>The following #successhammessage# message(s) were trained:</strong></cfoutput><br>
                <cfoutput>#successhammessage_email#</cfoutput>
              </div>
          
              <!--- /CFIF successhammessage --->
            </cfif>
          
            <cfset session.m = 0>
            <cfset session.successhammessage = 0>
            <cfset session.successhammessage_email = "">
          
            <!--- /CFIF #failurehammessage# is/is not "0" --->
          </cfif>
      
      <!--- TRAIN HAM ERROR CODES END HERE --->

      
        <!--- TRAIN SPAM ERROR CODES START HERE --->
        <cfif #failurespammessage# is not "0">
        
          <cfif #m# is "7">
            <div class="alert alert-warning alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
              <cfoutput>Train Message(s) as Spam Action completed with warnings</cfoutput><br> 
            </div>
          
            <!--- /CFIF #m# is "7" --->
            </cfif>
          
            <cfif #successspammessage# is not "0">
          
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <!---
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                --->
                <cfoutput><strong>The following #successspammessage# messages were trained:</strong></cfoutput><br>
                <cfoutput>#successspammessage_email#</cfoutput>
              </div>
          
              <!--- /CFIF successspammessage --->
            </cfif>
          
          
                  <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <!---
                    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                    --->
                    <cfoutput><strong>The following #failurespammessage# message(s) were NOT trained:</strong></cfoutput><br>
                    <cfoutput>#failurespammessage_email#</cfoutput>
                  </div>
          
                  <cfset session.m = 0>
                  <cfset session.failurespammessage = 0>
                  <cfset session.failurespammessage_email = "">
                  <cfset session.successspammessage = 0>
                  <cfset session.successspammessage_email = "">
          
        <cfelseif #failurespammessage# is "0">
                  
          <cfif #m# is "7">
            <div class="alert alert-success alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fa fa-check"></i> Success!</h4>
       
              <cfoutput>Train Message(s) as Spam Action completed successfully</cfoutput><br> 
            </div>
      
          
            <!--- /CFIF #m# is "7" --->
          </cfif>
          
            <cfif #successspammessage# is not "0">
          
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <!---
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                --->
                <cfoutput><strong>The following #successspammessage# message(s) were trained:</strong></cfoutput><br>
                <cfoutput>#successspammessage_email#</cfoutput>
              </div>
          
              <!--- /CFIF successspammessage --->
            </cfif>
          
            <cfset session.m = 0>
            <cfset session.successspammessage = 0>
            <cfset session.successspammessage_email = "">
          
            <!--- /CFIF #failurespammessage# is/is not "0" --->
          </cfif>
      
      <!--- TRAIN SPAM ERROR CODES END HERE --->
      
      <!--- ERROR MESSAGES END HERE --->

      <!--- FORGET MESSAGE ERROR CODES START HERE --->
      <cfif #failureforgetmessage# is not "0">
        
        <cfif #m# is "8">
          <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fas fa-exclamation-triangle"></i> Warning!</h4>
            <cfoutput>Remove Message(s) Previous Training Action completed with warnings</cfoutput><br> 
          </div>
        
          <!--- /CFIF #m# is "8" --->
          </cfif>
        
          <cfif #successforgetmessage# is not "0">
        
            <div class="alert alert-success alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <!---
              <h4><i class="icon fa fa-ban"></i> Oops!</h4>
              --->
              <cfoutput><strong>The following #successforgetmessage# messages were removed:</strong></cfoutput><br>
              <cfoutput>#successforgetmessage_email#</cfoutput>
            </div>
        
            <!--- /CFIF successforgetmessage --->
          </cfif>
        
        
                <div class="alert alert-danger alert-dismissible">
                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                  <!---
                  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                  --->
                  <cfoutput><strong>The following #failureforgetmessage# message(s) were NOT removed:</strong></cfoutput><br>
                  <cfoutput>#failureforgetmessage_email#</cfoutput>
                </div>
        
                <cfset session.m = 0>
                <cfset session.failureforgetmessage = 0>
                <cfset session.failureforgetmessage_email = "">
                <cfset session.successforgetmessage = 0>
                <cfset session.successforgetmessage_email = "">
        
      <cfelseif #failureforgetmessage# is "0">
                
        <cfif #m# is "8">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
     
            <cfoutput>Remove Message(s) Previous Training Action completed successfully</cfoutput><br> 
          </div>
    
        
          <!--- /CFIF #m# is "8" --->
        </cfif>
        
          <cfif #successforgetmessage# is not "0">
        
            <div class="alert alert-success alert-dismissible">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <!---
              <h4><i class="icon fa fa-ban"></i> Oops!</h4>
              --->
              <cfoutput><strong>The following #successforgetmessage# message(s) were removed:</strong></cfoutput><br>
              <cfoutput>#successforgetmessage_email#</cfoutput>
            </div>
        
            <!--- /CFIF successforgetmessage --->
          </cfif>
        
          <cfset session.m = 0>
          <cfset session.successforgetmessage = 0>
          <cfset session.successforgetmessage_email = "">
        
          <!--- /CFIF #failureforgetmessage# is/is not "0" --->
        </cfif>
    
    <!--- FORGET MESSAGE ERROR CODES END HERE --->


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
      <!---
        <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
      --->
      <select class="form-control" name="action" data-placeholder="action" style="width: 100%">                  
      <option value="Block Sender" selected="selected">Block Sender(s)</option>
      <option value="Allow Sender">Allow Sender(s)</option>
      <option value="Release Msg">Release Message(s) to Recipient</option>
      <option value="Train Spam">Train Message(s) as Spam</option>
      <option value="Train Ham">Train Message(s) as Ham (NOT Spam)</option>
      <option value="Forget">Remove Message(s) Previous Training</option>
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

    <!---
    <div class="modal" id="myModal" tabindex="-1" role="dialog">


      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
              <div class="modal-header">
                  <h5 class="modal-title">Modal title</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                  </button>
              </div>
              <div class="modal-body">
    
              
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary">Save changes</button>
              </div>
          </div>
      </div>
  </div>

--->
  
      <cfif #action# is "Block Sender">

        <cfif NOT StructKeyExists(form, "mail_id")>

          <cfset session.m = 1>

      
        <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
      
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif StructKeyExists(form, "mail_id")>

          <cfif #form.mail_id# is "">

            <cfset session.m = 1>

            <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
              
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

        <cfelseif #form.mail_id# is not "">    
            

       <cfloop index="i" list="#form.mail_id#" delimiters=",">

        <cfquery name="getemail" datasource="hermes">
        select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
        </cfquery>

        <cfif #getemail.recordcount# GTE 1>

          <cfset theMailId = #getemail.mail_id#>
   

          <cfinclude template="./inc/messages_block_sender.cfm">

          
            <cfoutput>
            #i#<br>
          </cfoutput>
        

          <!--- /CFIF #getrecipient.recordcount# --->
        </cfif>
      
         
        
        </cfloop>
  
  
        <cfset session.m = 3>

  <cfoutput>
  <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>
 

<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>

<cfelseif #action# is "Allow Sender">

  <cfif NOT StructKeyExists(form, "mail_id")>

    <cfset session.m = 1>

    <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">

    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "mail_id")>

    <cfif #form.mail_id# is "">

      <cfset session.m = 1>

      <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

  <cfelseif #form.mail_id# is not "">    
      

 <cfloop index="i" list="#form.mail_id#" delimiters=",">

  <cfquery name="getemail" datasource="hermes">
  select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
  </cfquery>

  <cfif #getemail.recordcount# GTE 1>

    <cfset theMailId = #getemail.mail_id#>


    <cfinclude template="./inc/messages_allow_sender.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

   
  
  </cfloop>


<cfset session.m = 4>

<cfoutput>
<cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>


<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>


<cfelseif #action# is "Release Msg">

  <cfif NOT StructKeyExists(form, "mail_id")>

    <cfset session.m = 1>

    <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">

    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "mail_id")>

    <cfif #form.mail_id# is "">

      <cfset session.m = 1>

      <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

  <cfelseif #form.mail_id# is not "">    
      

 <cfloop index="i" list="#form.mail_id#" delimiters=",">

  <cfquery name="getemail" datasource="hermes">
  select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
  </cfquery>

  <cfif #getemail.recordcount# GTE 1>

    <cfset theMailId = #getemail.mail_id#>


    <cfinclude template="./inc/messages_release_message.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

   
  
  </cfloop>


<cfset session.m = 5>

<cfoutput>
<cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>


<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>


<cfelseif #action# is "Train Ham">

  <cfif NOT StructKeyExists(form, "mail_id")>

    <cfset session.m = 1>

    <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">

    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "mail_id")>

    <cfif #form.mail_id# is "">

      <cfset session.m = 1>

      <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

  <cfelseif #form.mail_id# is not "">    
      

 <cfloop index="i" list="#form.mail_id#" delimiters=",">

  <cfquery name="getemail" datasource="hermes">
  select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
  </cfquery>

  <cfif #getemail.recordcount# GTE 1>

    <cfset theMailId = #getemail.mail_id#>


    <cfinclude template="./inc/messages_train_ham.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

   
  
  </cfloop>

  <cfinclude template="./inc/messages_sa_learn_sync.cfm">


<cfset session.m = 6>

<!--- RESET BAYES PERMISSIONS TO AMAVIS AND RESTART AMAVIS AND SPAMASSASSIN --->
<cftry>
  <cfexecute name = "/opt/hermes/scripts/bayes_chown_amavis.sh"
  timeout = "240"
  outputfile ="/dev/null"
  arguments="-inputformat none">
  </cfexecute>
  
  <cfcatch type="any">
  </cfcatch>
  </cftry>

<cfoutput>
<cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>


<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>

<cfelseif #action# is "Train Spam">

  <cfif NOT StructKeyExists(form, "mail_id")>

    <cfset session.m = 1>

    <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">

    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "mail_id")>

    <cfif #form.mail_id# is "">

      <cfset session.m = 1>

      <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

  <cfelseif #form.mail_id# is not "">    
      

 <cfloop index="i" list="#form.mail_id#" delimiters=",">

  <cfquery name="getemail" datasource="hermes">
  select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#"> 
  </cfquery>

  <cfif #getemail.recordcount# GTE 1>

    <cfset theMailId = #getemail.mail_id#>


    <cfinclude template="./inc/messages_train_spam.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

   
  
  </cfloop>

  <cfinclude template="./inc/messages_sa_learn_sync.cfm">


<cfset session.m = 7>

<!--- RESET BAYES PERMISSIONS TO AMAVIS AND RESTART AMAVIS AND SPAMASSASSIN --->
<cftry>
  <cfexecute name = "/opt/hermes/scripts/bayes_chown_amavis.sh"
  timeout = "240"
  outputfile ="/dev/null"
  arguments="-inputformat none">
  </cfexecute>
  
  <cfcatch type="any">
  </cfcatch>
  </cftry>

<cfoutput>
<cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>


<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>


<cfelseif #action# is "Forget">

  <cfif NOT StructKeyExists(form, "mail_id")>

    <cfset session.m = 1>

    <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">

    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

    <cfelseif StructKeyExists(form, "mail_id")>

    <cfif #form.mail_id# is "">

      <cfset session.m = 1>

      <cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
        
    <!---
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    --->

  <cfelseif #form.mail_id# is not "">    
      

 <cfloop index="i" list="#form.mail_id#" delimiters=",">

  <cfquery name="getemail" datasource="hermes">
  select mail_id, secret_id from msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
  </cfquery>

  <cfif #getemail.recordcount# GTE 1>

    <cfset theMailId = #getemail.mail_id#>


    <cfinclude template="./inc/messages_forget_bayes.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>

   
  <cfinclude template="./inc/messages_sa_learn_sync.cfm">
  
  </cfloop>


<cfset session.m = 8>

<!--- RESET BAYES PERMISSIONS TO AMAVIS AND RESTART AMAVIS AND SPAMASSASSIN --->
<cftry>
  <cfexecute name = "/opt/hermes/scripts/bayes_chown_amavis.sh"
  timeout = "240"
  outputfile ="/dev/null"
  arguments="-inputformat none">
  </cfexecute>
  
  <cfcatch type="any">
  </cfcatch>
  </cftry>

<cfoutput>
<cflocation url="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" addtoken="no">
</cfoutput>


<!--- /CFIF #form.mail_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "mail_id") --->
</cfif>



    
      <!--- /CFIF #action# is --->     
    </cfif> 
    
    <span>
      <p>  

            <!--- RELOAD MESSAGE HISTORY BUTTON STARTS HERE --->
<a href="preloader_view_message_history.cfm" class="btn btn-primary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Reload Message History</a>

<!--- RELOAD MESSAGE HISTORY BUTTON ENDS HERE --->

&nbsp;&nbsp;

    <button type="button" id="messageactions" class="btn btn-primary"><i class="fa fa-edit"></i>&nbsp;&nbsp;Message Actions</button>
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

<br>

<form>

<div class="col-sm-6">
  <label>Start Date/Time</label>
    <div class="form-group">
        <div class="input-group date" id="startdatetime" data-target-input="nearest">
          <cfoutput>
            <input type="text" name="startdate" value="#startdate#" class="form-control datetimepicker-input" data-target="##startdatetime"/>
          </cfoutput>
            <div class="input-group-append" data-target="#startdatetime" data-toggle="datetimepicker">
                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
            </div>
        </div>
    </div>
  </div>

<script type="text/javascript">
    $(function () {
        $('#startdatetime').datetimepicker({
          format: 'YYYY-MM-DD HH:mm:ss',
          icons: { time: 'far fa-clock' },
          sideBySide: true
          
        });
    });
</script>



  <div class="col-sm-6">
    <label>End Date/Time</label>
      <div class="form-group">
          <div class="input-group date" id="enddatetime" data-target-input="nearest">
            <cfoutput>
              <input type="text" name="enddate" value="#enddate#" class="form-control datetimepicker-input" data-target="##enddatetime"/>
            </cfoutput>
              <div class="input-group-append" data-target="#enddatetime" data-toggle="datetimepicker">
                  <div class="input-group-text"><i class="fa fa-calendar"></i></div>
              </div>
          </div>
      </div>
    </div>

  <script type="text/javascript">
      $(function () {
          $('#enddatetime').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            icons: { time: 'far fa-clock' },
            sideBySide: true
        
          });
      });
  </script>

<div class="form-group col-sm-6">
  <label>Search Results Limit</label>
  <div class="alert alert-warning">
<!---
    <h6><i class="icon fas fa-exclamation-triangle"></i> Warning!</h6>
--->
    <p><i class="icon fas fa-exclamation-triangle"></i>Setting Search Results Limit to 10000 or 15000 will <strong>significantly</strong> increase the page loading time </p>
    </div>
  <div class="input-group">

    <select class="form-control" name="limit" data-placeholder="limit">   
      <cfoutput>          
      <option value="#limit#" selected="selected">#limit#</option>
    </cfoutput>    
     
      <cfif #limit# is "1000">

      <option value="1500">1500</option>
      <option value="2500">2500</option>
      <option value="5000">5000</option>
      <option value="10000">10000</option>
      <option value="15000">15000</option>

      <cfelseif #limit# is "1500">

        <option value="1000">1000 (Default)</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "2500">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "5000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "10000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "15000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>

<!--- /CFIF #limit# is --->
      </cfif>

      </select> 


  
  <!--- /div class="input-group" --->
  </div>
  
  <!--- /div class="input-group" --->
  </div>

<div class="col-sm-6">

<input type="submit" class="btn btn-primary" name="" value="Fetch Messages" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
</div>

<br>
  
</form>

    <!--- div class="card"  --->  
  </div>

<br>

<!---

<span>
  <p>  
<button type="button" class="btn btn-default">Select All</button>
 <button type="button" class="btn btn-default">Clear</button>
</p>
</span>
--->



    
    <cfif #getmsgs.recordcount# GTE 1>

    
                
      <table class="table table-striped wrap"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>View</th>
            <th>Archived</th>
            <th>Date/Time</th>
            <th>Sender IP</th>
            <th>Return-Path</th>
            <th>From</th>
            <th>To</th>
            <th>Subject</th>
            <th>Score</th>
            <th>Type</th>
                  <th>Action</th>
        
 
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getmsgs">



        <td><input type="checkbox" name="mail_id" value="#mail_id#"></td>

       <td>

        <a href="preloader_view_message.cfm?mid=#mail_id#&startdate=#startdate#&enddate=#enddate#&limit=#limit#" class="btn btn-secondary" role="button"><i class="fas fa-search"></i></a>
  

            </td>

        <td>#archive#</td>
         <td>#DateFormat(time_iso, "yyyy-mm-dd")# #TimeFormat(time_iso, "HH:mm:ss")#</td>

 

            <td>#client_addr#</td>

            <cfquery name="getfromaddr" datasource="hermes">
              SELECT email as fromAddress FROM maddr where id='#sid#'
              </cfquery>

            <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">#getfromaddr.fromAddress#</td>

            <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">#htmlEditFormat(from_addr)#</td>

            <cfquery name="gettoaddr" datasource="hermes">
              SELECT msgrcpt.rid,maddr.email as toAddress FROM msgrcpt INNER JOIN maddr ON msgrcpt.rid = maddr.id where mail_id='#mail_id#'
              </cfquery>

<td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">#gettoaddr.toAddress#</td>

            <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">#subject#</td>

            <td>#Numberformat (spam_level, '____.__')#</td>

            <cfquery name="gettype" datasource="hermes">
              select content_type, description from msg_content_type where content_type like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">
              </cfquery>

            <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">#gettype.description#</td>

            <cfif #ds# is "P">
            <td>Delivered</td>

            <cfelseif #ds# is "D">
              <td>Blocked</td>

            <cfelseif #ds# is "B">

              <td>Blocked</td>

            <cfelse>

              <td>N/A</td>

              <!--- /CFIF #ds# --->
            </cfif>

          

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
            <th></th>
            <th>View</th>
            <th>Archived</th>
            <th>Date/Time</th>
            <th>Sender IP</th>
            <th>Return-Path</th>
            <th>From</th>
            <th>To</th>
            <th>Subject</th>
            <th>Score</th>
            <th>Type</th>
            <th>Action</th>

          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getmsgs.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Messages were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getmsgs.recordcount --->
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

    <!--- BACK TO TOP BUTTON SCRIPT STARTS HERE  --->

<script>

  //Get the button
  let mybutton = document.getElementById("btn-back-to-top");
  
  // When the user scrolls down 20px from the top of the document, show the button
  window.onscroll = function () {
    scrollFunction();
  };
  
  function scrollFunction() {
    if (
      document.body.scrollTop > 200 ||
      document.documentElement.scrollTop > 200
    ) {
      mybutton.style.display = "block";
    } else {
      mybutton.style.display = "none";
    }
  }
  // When the user clicks on the button, scroll to the top of the document
  mybutton.addEventListener("click", backToTop);
  
  function backToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
  }
  
  </script>
  
  <!--- BACK TO TOP BUTTON SCRIPT ENDS HERE  --->


  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE ENDS HERE --->

  <!---
  <script>
    $(document).ready(function(){
        $('.openPopup').on('click',function(){
            var dataURL = $(this).attr('data-href');
            $('.modal-body').load(dataURL,function(){
                $('#myModal').modal({show:true});
            });
        }); 
    });
    </script>
  --->


</html>