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
  <title>Hermes SEG | Edit Virtual Recipient</title>
  
  <cfinclude template="./inc/html_head.cfm" />

   <!-- Preloader -->
   <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>



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
         
            <h1 class="m-0">Edit Virtual Recipient
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
      
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Virtual Recipient</li>
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
<cfif StructKeyExists(url, "action")>
<cfif url.action is not "">
<cfset action = url.action>
</cfif>
</cfif> 

<cfparam name = "theID" default = ""> 
<cfif StructKeyExists(url, "id")>
<cfif url.id is not "">
<cfif IsValid("integer", url.id)>
<cfset theID = url.id>
<cfelse>
<cfset m="Edit Virtual Recipient: url.id not valid interger">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>

<cfelseif url.id is "">
  <cfset m="Edit Virtual Recipient: url.id is blank">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF url.id is "" --->
</cfif>

<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit Virtual Recipient: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getrecipient" datasource="hermes">
select virtual_address, maps from virtual_recipients where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getrecipient.recordcount# LT 1>

<cfset m="Edit Virtual Recipient: getrecipient.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset theLocalpart = #ListGetAt(getrecipient.virtual_address, 1, "@", "true")#>
<cfset theDomainpart = #ListGetAt(getrecipient.virtual_address, 2, "@", "true")#>

<!--- /CFIF getrecipient.recordcount --->
</cfif>



<cfif #action# is "edit">

<!--- VALIDATE PARAMETERS BELOW --->
<cfif NOT StructKeyExists(form, "domain")>

  <cfset m="Edit Virtual Recipient: form.domain does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "domain")>

<cfif #form.domain# is "">

<cfset m="Edit Virtual Recipient: form.domain is empty">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset step=1>
 
<!--- /CFIF #form.domain# is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "domain") --->
</cfif>

<cfif #step# is "1">


<cfset tempemail = "bob@#form.domain#">


<cfif IsValid("email", tempemail)>

<cfset step=2>

<cfelse>

<cfset m="Edit Virtual Recipient: form.domain is invalid domain #tempemail#">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF IsValid("email", tempemail) --->
</cfif>

<!--- /CFIF for step is "1" --->
</cfif>

<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "local_part")>

    <cfset m="Edit Virtual Recipient: form.local_part does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "local_part")>
  
 
  <cfset step=3>
   
  <!--- /CFIF StructKeyExists(form, "local_part") --->
  </cfif>

<!--- /CFIF for step is "2" --->
</cfif>


<cfif #step# is "3">

<cfif NOT StructKeyExists(form, "forwards_1")>

  <cfset m="Edit Virtual Recipient: form.forwards_1 does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "forwards_1")>

<cfif #form.forwards_1# is "">

<cfset step=0>
<cfset session.m=2>

<cfoutput>
<cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<cfif IsValid("email", form.forwards_1)>

<cfset step=4>

<cfelse>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF IsValid("email", form.forwards_1) --->
</cfif>

 
<!--- /CFIF #form.domain# is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "domain") --->
</cfif>

<!--- /CFIF for step is "3" --->
</cfif>


<cfif #step# is "4">

<cfquery name="checkdomain" datasource="hermes">
select domain from domains where domain='#form.domain#'
</cfquery>
    
<cfif #checkdomain.recordcount# GTE 1>

<cfinclude template="./inc/editvirtualrecipient.cfm">

<cfoutput>
<cflocation url="edit_virtual_recipient.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelseif #checkdomain.recordcount# LT 1>

<cfset m="Edit Virtual Recipient: form.domain is does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
        
<!--- /CFIF #checkdomain.recordcount# --->
</cfif>

<!--- /CFIF for step is "4" --->
</cfif>


<!--- VALIDATE PARAMETERS ABOVE --->


<!--- /CFIF #action# --->
</cfif> 




<!-- ERROR MESSAGES STARTS HERE -->




<cfif #m# is "1"> 

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Success!</h4>
    <cfoutput>Recipient was edited successfully</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Delivers To field cannot be empty</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Delivers To field must be a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>
 
<cfif #m# is "4"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Local-Part. Local-Part is the part before the <strong>@</strong> symbol of an e-mail address NOT an actual e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The recipient you are attempting to edit already exists</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>




<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       

<!--- BACK TO RECIPIENTS BUTTON STARTS HERE --->
<a href="view_virtual_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Virtual Recipients</a>

<!--- BACK TO RECIPIENTS BUTTON ENDS HERE --->





</p>


</span>


<!-- ADD RECIPIENT FORM STARTS HERE -->


<!-- form start -->

  <form name="add_virtual_recipients" method="post" action="">
  <input type="hidden" name="action" value="edit">
    <div class="box-body">
       
 
        <div class="form-horizontal">

     
              
                
            <div class="form-group">
              <label><strong>Local-Part</strong></label>
              <div class="input-group">
              <cfoutput>
              <input type="text" name="local_part" class="local_part form-control" id="local_part" placeholder="Enter the local-part (part before the @ symbol of an e-mail address or leave empty to forward entire domain" value="#theLocalpart#" autocomplete="off">
              </cfoutput>
              
              <!--- /div class="input-group" --->
              </div>
              
              <!--- /div class="form-group" --->
              </div>


          <cfquery name="getdomains" datasource="hermes">
            select id, domain from domains where domain <> '#theDomainpart#' order by domain asc
            </cfquery>

                    <div class="form-group">
                      <label><strong>@Domain</strong></label>
                      <select class="form-control select2" name="domain" data-placeholder="Domain"
                              style="width: 100%;">
                      <cfoutput>
                      <option value="#theDomainpart#" selected>#theDomainpart#</option>
                     </cfoutput>
                        <cfoutput query="getdomains">
                        <option value="#domain#">#domain#</option>
                        
                          </cfoutput>
                          </select>


                       
      </div>



      <div class="form-group">
        <label><strong>Delivers To</strong></label>
        <div class="input-group">
        <cfoutput>
        <input type="text" name="forwards_1" class="forwards form-control" id="forwards_1" placeholder="Start typing to search existing Internal Recipients or enter external recipient manually" value="#getrecipient.maps#" autocomplete="off">
        </cfoutput>
        
        <!--- /div class="input-group" --->
        </div>
        
        <!--- /div class="form-group" --->
        </div>


 

      <div class="box-footer">
        <!--- <p class="help-block">Help Block Text</p> --->
       
        <!---
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
        --->
        
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

<!--- SCRIPT TO GET RECIPIENTS BELOW --->

<script type="text/javascript">
  $(document).ready(function(){

      $(document).on('keydown', '.forwards', function() {
          
          var id = this.id;
          var splitid = id.split('_');
          var index = splitid[1];

          $( '#'+id ).autocomplete({
              source: function( request, response ) {
                  $.ajax({
                      url: "./inc/getintrecipients.cfm",
                      type: 'post',
                      dataType: "json",
                      data: {
                          search: request.term,request:1
                      },
                      success: function( data ) {
                          response( data );
                      }
                  });
              },
              select: function (event, ui) {
                  $(this).val(ui.item.label); // display the selected text
                  var id = ui.item.value; // selected id to input

                  // AJAX
                  $.ajax({
                      url: './inc/getintrecipients.cfm',
                      type: 'post',
                      data: {id:id,request:2},
                      dataType: 'json',
                      success:function(response){
                          
                          var len = response.length;

                          if(len > 0){
                              var recipient_no = response[0]['id'];
                              document.getElementById('certificateno_'+index).value = recipient_no;
                              
                          }
                          
                      }
                  });

                  return false;
              }
          });
      });
      
      

  });

</script>

</html>