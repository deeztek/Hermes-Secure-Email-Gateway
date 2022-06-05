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
  <title>Hermes SEG Admin | View Mail Queue Message</title>

<cfinclude template="./inc/html_head.cfm" />


  <!-- Preloader -->
  <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>

<!--- TEXT AREA STYLE ---> 
<style>
textarea{
    border:1px solid #999999;
    width:100%;
    margin:5px 0;
    padding:3px;
}
.textareacontainer{
    padding-right: 8px; /* 1 + 3 + 3 + 1 */
}
  </style>

</head>



<cfif NOT StructKeyExists(url, "msg_id")>

  <cfset m="View Mail Queue Message: url.msg_id does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif StructKeyExists(url, "msg_id")>

  <cfif #url.msg_id# is "">

  <cfset m="View Mail Queue Message: url.msg_id is empty">
  <cfinclude template="./inc/error.cfm">
  <cfabort>


<cfelseif #url.msg_id# is not "">      


<cfinclude template="./inc/mail_queue_view_message.cfm">


<!--- /CFIF #url.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>






<body>
  <div class="container-fluid">

<div class="card card-primary card-outline">


    <div class="mailbox-controls with-border text-left">
      <div class="btn-group">
        <!---
        <button type="button" class="btn btn-default btn-sm" data-container="body" title="Delete">
          <i class="far fa-trash-alt"></i>
        </button>
      --->

      <cfoutput>
      <a href="preloader_view_mail_queue.cfm" title="Back to Mail Queue" class="btn btn-secondary btn-lg" role="button"><i class="fas fa-reply"></i></a>
    </cfoutput>

    &nbsp;&nbsp;


    <button class="btn btn-secondary btn-lg" title="Print Message" onclick="printPage()"><i class="fas fa-print"></i></button>

   
      </div>
      <!-- /.btn-group -->
 
    </div>
    <!-- /.mailbox-controls -->

    <div class="card-header">

    <h2 class="card-title">View Mail Queue Message</h2>


  </div>
  
   

<div class="mailbox-read-message">


<div class="textareacontainer">
<textarea wrap="physical" rows="25">
<cfoutput>#viewqueuemsg#</cfoutput>
</textarea>
</div>

      
    </div>
    <!-- /.mailbox-read-message -->



  </div>
  <!-- /.card-body -->

</wrapper>

</body>

<!--- SCRIPT TO PRINT PAGE --->
<script>
function printPage() {
  window.print();
}
</script>

</html>