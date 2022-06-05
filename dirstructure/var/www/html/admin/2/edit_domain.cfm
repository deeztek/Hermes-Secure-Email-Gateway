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
  <title>Hermes SEG | Edit Domain</title>
  
  <cfinclude template="./inc/html_head.cfm" />

     <!-- Preloader -->
     <div class="preloader flex-column justify-content-center align-items-center">
      <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
      </div>

<!--- SCRIPT TO SHOW/HIDE PASSWORD ON VIEW KEYRING MODAL--->
<script>

  $(document).ready(function() {
      $("#viewdestinationpassword a").on('click', function(event) {
          event.preventDefault();
          if($('#viewdestinationpassword input').attr("type") == "text"){
              $('#viewdestinationpassword input').attr('type', 'password');
              $('#viewdestinationpassword i').addClass( "fa-eye-slash" );
              $('#viewdestinationpassword i').removeClass( "fa-eye" );
          }else if($('#viewdestinationpassword input').attr("type") == "password"){
              $('#viewdestinationpassword input').attr('type', 'text');
              $('#viewdestinationpassword i').removeClass( "fa-eye-slash" );
              $('#viewdestinationpassword i').addClass( "fa-eye" );
          }
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
            <h1 class="m-0">Edit Domain
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Domain</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">


<!-- CFML CODE STARTS HERE -->

<cfparam name = "step" default = "0"> 

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

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfset action = form.action>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>


<!---
<cfparam name = "applied" default = "1"> 
<cfquery name="getapplied" datasource="hermes">
select applied from system_users where applied = '2'
</cfquery>

<cfif #getapplied.recordcount# GTE 1>
<cfset applied = 2>
</cfif>
--->

<cfparam name = "theDomainID" default = ""> 

<cfif StructKeyExists(url, "id")>
<cfif IsValid("integer", url.id)>
<cfset theDomainID = url.id>
<cfelse>
<cfset m="Edit Domain: url.id not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>


<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit Domain: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getdomain" datasource="hermes">
select id, domain, transport_id, senders_id, action_taken, recipients_id from domains where id = <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getdomain.recordcount# LT 1>
<cfset m="Edit Domain: getdomain.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<cfparam name = "theOriginalDomain" default = "#getdomain.domain#"> 


<cfquery name="gettransport" datasource="hermes">
  select id, domain, transport, destination, method, port, mx, authentication, authentication_username, authentication_password from transport where id = <cfqueryparam value = #getdomain.transport_id# CFSQLType = "CF_SQL_INTEGER"> and domain = '#theOriginalDomain#'
  </cfquery>
  
  <cfif #gettransport.recordcount# LT 1>
  <cfset m="Edit Domain: gettransport.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  </cfif>
  
  <cfparam name = "theTransportID" default = "#gettransport.id#">

  <cfparam name = "delivery_method" default = "#gettransport.method#"> 
  <cfif StructKeyExists(form, "delivery_method")>
  <cfif form.delivery_method is not "">
  <cfset delivery_method = form.delivery_method>
  
<!--- /CFIF form.delivery_method is --->
</cfif>

<!--- StructKeyExists(form, "delivery_method") --->
  </cfif>

  <cfparam name = "destination_authentication" default = "#gettransport.authentication#"> 
  <cfif StructKeyExists(form, "destination_authentication")>
  <cfif form.destination_authentication is not "">
  <cfset destination_authentication = form.destination_authentication>
  
<!--- /CFIF form.destination_authentication is --->
</cfif>

<!--- StructKeyExists(form, "destination_authentication") --->
  </cfif>

  <cfif #gettransport.authentication_username# is "">

  <cfset DecryptedUsername="">
  
  <cfelse>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<!-- DECRYPT USERNAME -->
<cfset DecryptedUsername = decrypt(gettransport.authentication_username, #hermeskey#, "AES", "Base64")>

<!--- /CFIF #gettransport.authentication_username# is --->
  </cfif>

  <cfparam name = "destination_username" default = "#DecryptedUsername#"> 

  <cfif StructKeyExists(form, "destination_username")>
  <cfif form.destination_username is not "">
  <cfset destination_username = form.destination_username>
  
<!--- /CFIF form.destination_username is --->
</cfif>

<!--- StructKeyExists(form, "destination_username") --->
</cfif>

<cfif #gettransport.authentication_password# is "">

  <cfset DecryptedPassword="">
  
  <cfelse>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<!-- DECRYPT USERNAME -->
<cfset DecryptedPassword = decrypt(gettransport.authentication_password, #hermeskey#, "AES", "Base64")>

<!--- /CFIF #gettransport.authentication_password# is --->
  </cfif>

<cfparam name = "destination_password" default = "#DecryptedPassword#"> 
<cfif StructKeyExists(form, "destination_password")>
<cfif form.destination_password is not "">
<cfset destination_password = form.destination_password>

<!--- /CFIF form.destination_password is --->
</cfif>

<!--- StructKeyExists(form, "destination_password") --->
  </cfif>


  <cfparam name = "destination_mx" default = "#gettransport.mx#"> 
  <cfif StructKeyExists(form, "destination_mx")>
  <cfif form.destination_mx is not "">
  <cfset destination_mx = form.destination_mx>
  
<!--- /CFIF form.destination_mx is --->
</cfif>

<!--- StructKeyExists(form, "destination_mx") --->
  </cfif>



  <cfquery name="getrecipient" datasource="hermes">
    select id, recipient, status from recipients where id = <cfqueryparam value = #getdomain.recipients_id# CFSQLType = "CF_SQL_INTEGER"> and recipient = '@#theOriginalDomain#'
    </cfquery>
    
    <cfif #getrecipient.recordcount# LT 1>
    <cfset m="Edit Domain: getrecipient.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    </cfif>
    
    <cfparam name = "theRecipientID" default = "#getrecipient.id#">


    <cfquery name="getsender" datasource="hermes">
      select id, sender from senders where id = <cfqueryparam value = #getdomain.senders_id# CFSQLType = "CF_SQL_INTEGER"> and sender = '#theOriginalDomain#'
      </cfquery>
      
      <cfif #getsender.recordcount# LT 1>
      <cfset m="Edit Domain: getsender.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      </cfif>
      
      <cfparam name = "theSenderID" default = "#getsender.id#">



<cfif #action# is "edit">

<!--- VALIDATE PARAMETERS BELOW --->
<cfif NOT StructKeyExists(form, "domain_name")>

  <cfset m="Edit Domain: form.domain_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "domain_name")>

<cfif #form.domain_name# is "">

<cfset step=0>
<cfset session.m=1>

<cfoutput>
  <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
  </cfoutput>

<cfelse>

<cfset step=1>
 
<!--- /CFIF #form.domain_name# is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "domain_name") --->
</cfif>

<cfif #step# is "1">

<cfset tempemail = "bob@#form.domain_name#">  

<cfif IsValid("email", tempemail)>

<cfset step=2>

<cfelse>

<cfset step=0>
<cfset session.m=2>

<cfoutput>
  <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
  </cfoutput>

<!--- /CFIF IsValid("email", tempemail) --->
</cfif>

<!--- /CFIF for step is "1" --->
</cfif>

<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "delivery_method")>

    <cfset m="Edit Domain: form.delivery_method does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "delivery_method")>

    <cfif form.delivery_method is "smtp">

    <cfset step=3>
  
    <cfelseif form.delivery_method is "discard">

    <cfset step=10>
    
    <cfelse>

    <cfset m="Edit Domain: form.delivery_method is not smtp or discard">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <!--- /CFIF form.delivery_method is  --->
    </cfif>
      
    <!--- /CFIF StructKeyExists(form, "delivery_method") --->
    </cfif>
  

<!--- /CFIF for step is "2" --->
</cfif>

<cfif #step# is "3">

  <cfif NOT StructKeyExists(form, "recipient_delivery")>

    <cfset m="Edit Domain: form.recipient_delivery does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "recipient_delivery")>

    <cfif form.recipient_delivery is "" OR form.recipient_delivery is "OK">

    <cfset step=4>
  
    <cfelse>
    
    <cfset m="Edit Domain: form.recipient_delivery is not blank or OK">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <!--- /CFIF form.recipient_delivery is "" OR form.recipient_delivery is "OK" --->
    </cfif>
      
    <!--- /CFIF StructKeyExists(form, "recipient_delivery") --->
    </cfif>
  

<!--- /CFIF for step is "3" --->
</cfif>


<cfif #step# is "4">

<cfif NOT StructKeyExists(form, "destination_address")>

  <cfset m="Edit Domain: form.destination_address does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "destination_address")>

<cfif #form.destination_address# is "">

  <cfset step=0>
  <cfset session.m=3>

  <cfoutput>
    <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
    </cfoutput>

<cfelse>

<cfoutput>
<cfset tempemail = "bob@#form.destination_address#">
</cfoutput>

<cfif IsValid("email", tempemail)>

<cfset step=5>

<cfelseif NOT IsValid("email", tempemail)>


  <cfset step=0>
  <cfset session.m=4>

  <cfoutput>
    <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
    </cfoutput>

<!--- /CFIF IsValid("email", form.destination_address) --->
</cfif>

 
<!--- /CFIF #form.destination_address# is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "destination_address") --->
</cfif>

<!--- /CFIF for step is "4" --->
</cfif>


<cfif #step# is "5">

  <cfif NOT StructKeyExists(form, "destination_port")>
  
    <cfset m="Edit Domain: form.destination_port does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "destination_port")>
  
  <cfif #form.destination_port# is "">
  
    <cfset step=0>
    <cfset session.m=5>

    <cfoutput>
      <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
      </cfoutput>
  
  <cfelse>

  <cfif IsValid("integer", form.destination_port)>
  
  <cfset step=6>
  
  <cfelse>
  
    <cfset step=0>
    <cfset session.m=6>

    <cfoutput>
      <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
      </cfoutput>

  
  <!--- /CFIF IsValid("integer", form.destination_port) --->
  </cfif>
  
   
  <!--- /CFIF #form.destination_port# is --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "destination_port") --->
  </cfif>
  
  <!--- /CFIF for step is "5" --->
  </cfif>


  <cfif #step# is "6">

  <cfif #destination_authentication# is "NO">

  <cfset step=10>

  <cfelseif #destination_authentication# is "YES">

  <cfquery name="getrelayhostid" datasource="hermes">
  select id, parameter, parent, child from parameters where parameter = 'relayhost'
  </cfquery>

<cfquery name="relayhostenabled" datasource="hermes">
select parameter, parent, child from parameters where parent='#getrelayhostid.id#' and child='1'
</cfquery>

<cfif #relayhostenabled.parameter# is "">

<cfset step=7>

<cfelse>

<cfset step=0>
<cfset session.m=9>

<cfoutput>
  <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
  </cfoutput>

<!--- /CFIF #relayhostenabled.parameter# is --->
</cfif>


  <!--- #destination_authentication# is "" --->
  </cfif>


  <!--- /CFIF for step is "6" --->
  </cfif>


  <cfif #step# is "7">

    <cfif NOT StructKeyExists(form, "destination_username")>
  
      <cfset m="Edit Domain: form.destination_username does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    
    <cfelseif StructKeyExists(form, "destination_username")>
  
      <cfif form.destination_username is "">
  
        <cfset step=0>
        <cfset session.m=10>

        <cfoutput>
        <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
        </cfoutput>
    
      <cfelse>
      
  <cfset step=8>
      
      <!--- /CFIF form.destination_username is --->
      </cfif>
        
      <!--- /CFIF StructKeyExists(form, "destination_username") --->
      </cfif>
    
  
  <!--- /CFIF for step is "7" --->
  </cfif>


  <cfif #step# is "8">

    <cfif NOT StructKeyExists(form, "destination_password")>
  
      <cfset m="Edit Domain: form.destination_password does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    
    <cfelseif StructKeyExists(form, "destination_password")>
  
      <cfif form.destination_password is "">
  
        <cfset step=0>
        <cfset session.m=11>

        <cfoutput>
        <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
        </cfoutput>
    
      <cfelse>
  
  <cfset form.destination_mx="NO">    
  <cfset step=10>
      
      <!--- /CFIF form.destination_password is --->
      </cfif>
        
      <!--- /CFIF StructKeyExists(form, "destination_password") --->
      </cfif>
    
  
  <!--- /CFIF for step is "8" --->
  </cfif>

  <cfif #step# is "9">

    <cfif NOT StructKeyExists(form, "destination_mx")>
  
      <cfset m="Edit Domain: form.destination_mx does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    
    <cfelseif StructKeyExists(form, "destination_mx")>
  
      <cfif form.destination_mx is "YES" OR form.destination_mx is "NO">
  
      <cfset step=10>
    
      <cfelse>
      
      <cfset m="Edit Domain: form.destination_mx is not YES or NO">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      
      <!--- /CFIF form.destination_mx is "YES" OR form.destination_mx is "NO" --->
      </cfif>
        
      <!--- /CFIF StructKeyExists(form, "destination_mx") --->
      </cfif>
    
  
  <!--- /CFIF for step is "6" --->
  </cfif>


<cfif #step# is "10">

  <cfinclude template="./inc/editdomain.cfm">

  <cfset session.m=7>

  <cfoutput>
  <cflocation url="edit_domain.cfm?id=#theDomainID#" addtoken="no">
  </cfoutput>

<!--- /CFIF for step is "10" --->
</cfif>


<!--- VALIDATE PARAMETERS ABOVE --->


<!--- /CFIF #action# --->
</cfif> 




<!-- ERROR MESSAGES STARTS HERE -->



<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain Name field cannot be empty</cfoutput>
  </div>
  
  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain Name field must be a valid domain name</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Address field cannot be empty</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Address field must be a valid FQDN or IP Address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Port field cannot be empty</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Port field must be a valid integer</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "7">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>Domain Changes were saved successfully</cfoutput> 
    
</div>

<cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain Name you are attempting to use already exists</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot set the Destination Authentication field to YES if <strong>Gateway --> Relay Host</strong> is set to Enabled</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Username field cannot be empty if the Destination Requires Authentication field is set to YES</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Destination Password field cannot be empty if the Destination Requires Authentication field is set to YES</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       

<!--- BACK TO RECIPIENTS BUTTON STARTS HERE --->
<a href="view_domains.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Domains</a>

<!--- BACK TO RECIPIENTS BUTTON ENDS HERE --->





</p>


</span>


<!-- ADD RECIPIENT FORM STARTS HERE -->


<!-- form start -->

  <form name="edit_domain" method="post" action="">
  <input type="hidden" name="action" value="edit">
    <div class="box-body">
       


        <label><strong>Domain Name</strong></label>

        

        <div class="input-group">
        <cfoutput>
        <input type="text" name="domain_name" class="domain_name form-control" id="domain_name" placeholder="Enter a valid domain name" value="#theOriginalDomain#" autocomplete="off">
        </cfoutput>
        
        <!--- /div class="input-group" --->
        </div>
        


  

          <label><strong>Delivery Method</strong></label>
            
          <select class="form-control" name="delivery_method" style="width: 100%;" id="delivery_method">
  
  
            <cfif #delivery_method# is "smtp">
  
              <option value="smtp" selected>SMTP (Recommended)</option>
              <option value="discard">NONE (Discard All E-mail Silently)</option>
          
      
  
            <cfelseif #delivery_method# is "discard">
  
              <option value="discard" selected>NONE (Discard All E-mail Silently)</option>
              <option value="smtp">SMTP (Recommended)</option>
  
  
            <!--- /CFIF #delivery_method# is --->
            </cfif>
           
              </select>   
  
     


               

      

      <cfif #delivery_method# is "smtp">

      <div class="form-group"  id="destination">

  

          <label><strong>Recipient Delivery</strong></label>
          <select class="form-control select2" name="recipient_delivery" data-placeholder="recipient_delivery"
                  style="width: 100%;">

    <cfif #getrecipient.status# is "OK">
          
          <option value="OK" default>ANY</option>
          <option value="">SPECIFIED</option>

    <cfelseif #getrecipient.status# is "">
  
      <option value="" default>SPECIFIED</option>
      <option value="OK">ANY</option>

    <cfelse>
  
      <option value="OK" default>ANY</option>
      <option value="">SPECIFIED</option>


   <!--- /CFIF #getrecipient.status# --->
    </cfif>
            
              </select>



        <label><strong>Destination Address</strong></label>
   
        <cfoutput>
        <input type="text" name="destination_address" class="destination_address form-control" id="destination_address" placeholder="Enter a valid FQDN or IP Address" value="#gettransport.destination#" autocomplete="off">
        </cfoutput>
        
        <label><strong>Destination Port</strong></label>
   
        <cfoutput>
        <input type="text" name="destination_port" class="destination_port form-control" id="destination_port" placeholder="Enter a Port Number" value="#gettransport.port#" autocomplete="off">
        </cfoutput>


  


          <label><strong>Destination Requires Authentication</strong></label>

          <div class="alert alert-warning">
     
            <p><i class="icon fas fa-exclamation-triangle"></i>You will not be allowed to set the <strong>Destination Requires Authentication</strong> field below to <strong>YES</strong> if <strong>Gateway --> Relay Host</strong> is set to <strong>Enabled</strong></p>
            </div>
            
          <select class="form-control" name="destination_authentication" style="width: 100%;" id="destination_authentication">
  
  
            <cfif #destination_authentication# is "YES">
  
              <option value="YES" selected>YES</option>
              <option value="NO">NO</option>
            
      
  
            <cfelseif #destination_authentication# is "NO">
  
              <option value="NO" selected>NO</option>
              <option value="YES">YES</option>
  
  
            <!--- /CFIF #destination_authentication# is --->
            </cfif>
           
              </select>   

  

       <cfif #destination_authentication# is "NO">    

        <div class="form-group"  id="authentication" style="display:none;">
          
                  <label><strong>Destination Username</strong></label>
             
                  <cfoutput>
                  <input type="text" name="destination_username" class="destination_username form-control" id="destination_username" placeholder="Enter Destination username" value="#destination_username#" autocomplete="off">
                  </cfoutput>



<!--- DESTINATION PASSWORD STARTS HERE --->
           
<div class="form-group" id="viewdestinationpassword">
  <label><strong>Destination Password</strong></label>


<div class="input-group">
<cfoutput>
<input type="password" name="destination_password" value="#destination_password#" class="destination_password form-control" maxlength="64" autocomplete="off" placeholder="Enter Destination Password">
</cfoutput>
<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>


<!--- /DIV class="form-group" id="viewdestinationpassword" --->
</div>

<!--- DESTINATION PASSWORD PASSWORD ENDS HERE --->

<!--- /DIV class="form-group" id="authentication" --->
</div>
                  
       

          <cfelseif #destination_authentication# is "YES">

            <div class="form-group"  id="authentication">
          
              <label><strong>Destination Username</strong></label>
         
              <cfoutput>
              <input type="text" name="destination_username" class="destination_username form-control" id="destination_username" placeholder="Enter Destination username" value="#destination_username#" autocomplete="off">
              </cfoutput>

<!--- DESTINATION PASSWORD STARTS HERE --->
           
<div class="form-group" id="viewdestinationpassword">
  <label><strong>Destination Password</strong></label>


<div class="input-group">
  <cfoutput>
<input type="password" name="destination_password" value="#destination_password#" class="destination_password form-control" maxlength="64" autocomplete="off" placeholder="Enter Destination Password">
</cfoutput>

<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>

<!--- /DIV class="form-group" id="viewdestinationpassword" --->
</div>

<!--- DESTINATION PASSWORD PASSWORD ENDS HERE --->

<!--- /DIV class="form-group" id="authentication" --->
</div>

      
  <!--- /CFIF destination_authentication is "" --->
  </cfif>

  <!--- /DIV class="form-group" id="destination" --->
</div>
 

      <cfelseif #delivery_method# is "discard">

    <div class="form-group"  id="destination" style="display:none;">

      <label><strong>Recipient Delivery</strong></label>
      <select class="form-control select2" name="recipient_delivery" data-placeholder="recipient_delivery"
              style="width: 100%;">

<cfif #getrecipient.status# is "OK">
      
      <option value="OK" default>ANY</option>
      <option value="">SPECIFIED</option>

<cfelseif #getrecipient.status# is "">

  <option value="" default>SPECIFIED</option>
  <option value="OK">ANY</option>

<cfelse>

  <option value="OK" default>ANY</option>
  <option value="">SPECIFIED</option>


<!--- /CFIF #getrecipient.status# --->
</cfif>
        
          </select>

      <label><strong>Destination Address</strong></label>
 
      <cfoutput>
      <input type="text" name="destination_address" class="destination_address form-control" id="destination_address" placeholder="Enter a valid FQDN or IP Address" value="#gettransport.destination#" autocomplete="off">
      </cfoutput>
      


      <label><strong>Destination Port</strong></label>
 
      <cfoutput>
      <input type="text" name="destination_port" class="destination_port form-control" id="destination_port" placeholder="Enter a Port Number" value="#gettransport.port#" autocomplete="off">
      </cfoutput>

      <label><strong>Destination Requires Authentication</strong></label>

      <div class="alert alert-warning">
 
        <p><i class="icon fas fa-exclamation-triangle"></i>You will not be allowed to set the <strong>Destination Requires Authentication</strong> field below to <strong>YES</strong> if <strong>Gateway --> Relay Host</strong> is set to <strong>Enabled</strong></p>
        </div>
        
      <select class="form-control" name="destination_authentication" style="width: 100%;" id="destination_authentication">


        <cfif #destination_authentication# is "YES">

          <option value="YES" selected>YES</option>
          <option value="NO">NO</option>
        
  

        <cfelseif #destination_authentication# is "NO">

          <option value="NO" selected>NO</option>
          <option value="YES">YES</option>


        <!--- /CFIF #destination_authentication# is --->
        </cfif>
       
          </select>   

    <!--- /div class="form-group" id="destination" --->
  </div>

  <!--- /CFIF #delivery_method# is --->
  </cfif>


  <cfif #destination_authentication# is "NO">    

  <div class="form-group" id="destinationmx">
    
    
              <label><strong>Destination Use MX Lookup</strong></label>
    
     
              <select class="form-control" name="destination_mx" style="width: 100%;" id="destination_mx">
      
      
                <cfif #destination_mx# is "YES">
      
                  <option value="YES" selected>YES</option>
                  <option value="NO">NO</option>
                
          
      
                <cfelseif #destination_mx# is "NO">
      
                  <option value="NO" selected>NO</option>
                  <option value="YES">YES</option>
      
      
                <!--- /CFIF #destination_mx# is --->
                </cfif>
               
                  </select>   
    
                  <!--- /DIV class="form-group" id="destinationmx" --->
                </div>
    
    <cfelseif #destination_authentication# is "YES">    
    
    <div class="form-group" id="authentication" style="display:none;">
    
    
              <label><strong>Destination Use MX Lookup</strong></label>
    
     
              <select class="form-control" name="destination_mx" style="width: 100%;" id="destination_mx">
      
      
                <cfif #destination_mx# is "YES">
      
                  <option value="NO">NO</option>
                  <option value="YES" selected>YES</option>
          
      
                <cfelseif #destination_mx# is "NO">
      
                  <option value="NO" selected>NO</option>
                  <option value="YES">YES</option>
      
      
                <!--- /CFIF #destination_mx# is --->
                </cfif>
               
                  </select>   
    
                  <!--- /DIV class="form-group" id="authentication" --->
                </div>
    
    
    <!--- /CFIF #destination_authentication# is --->
    </cfif>


      <div class="box-footer">

              <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  

            </div>      

  

    
  </form>

  <div>&nbsp;</div>


<!-- ADD RECIPIENT FORM ENDS HERE -->

</div>
</div>

<div id="loader"></div>

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

<!--- SCRIPT TO SHOW/HIDE DESTINATION FIELDS SCRIPT STARTS HERE  --->
<script>

  $('#delivery_method').on('change',function(){
    if( $(this).val()==="discard"){
    $("#destination").hide()
    }
    else{
    $("#destination").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE DESTINATION FIELDS SCRIPT ENDS HERE  --->

<!--- SCRIPT TO SHOW/HIDE AUTHENTICATION FIELDS SCRIPT STARTS HERE  --->
<script>

  $('#destination_authentication').on('change',function(){
    if( $(this).val()==="NO"){
    $("#authentication").hide()
    }
    else{
    $("#authentication").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE AUTHENTICATION FIELDS SCRIPT ENDS HERE  --->

<!--- SCRIPT TO SHOW/HIDE DESTINATION MX FIELDS SCRIPT STARTS HERE  --->
<script>

  $('#destination_authentication').on('change',function(){
    if( $(this).val()==="YES"){
    $("#destinationmx").hide()
    }
    else{
    $("#destinationmx").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE DESTINATION MX FIELDS SCRIPT ENDS HERE  --->

</html>