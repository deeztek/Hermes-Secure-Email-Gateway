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
  <title>Hermes SEG | Add Virtual Recipient(s)</title>
  
  <cfinclude template="./inc/html_head.cfm" />





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
            <h1 class="m-0">Add Virtual Recipient(s)
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Add Virtual Recipient(s)</li>
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
<cfparam name = "errormessage" default = "0">
<cfparam name = "invalidemail" default = "0">
<cfparam name = "invalidemailrecipient" default = "">
<cfparam name = "alreadyexists" default = "0">
<cfparam name = "alreadyexistsrecipient" default = "">
<cfparam name = "success" default = "0">
<cfparam name = "successrecipient" default = "">


<cfparam name = "action" default = ""> 
<cfif StructKeyExists(url, "action")>
<cfif url.action is not "">
<cfset action = url.action>
</cfif>
</cfif> 


<cfif #action# is "add">

<!--- VALIDATE PARAMETERS BELOW --->
<cfif NOT StructKeyExists(form, "domain")>

  <cfset m="Add Virtual Recipients: form.domain does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "domain")>

<cfif #form.domain# is "">

<cfset m="Add Virtual Recipients: form.domain is empty">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset step=1>
 
<!--- /CFIF #form.domain# is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "domain") --->
</cfif>

<cfif #step# is "1">

  <cfoutput>
<cfset tempemail = "bob@#form.domain#">
</cfoutput>

<cfif IsValid("email", tempemail)>

<cfset step=2>

<cfelse>

<cfset m="Add Virtual Recipients: form.domain is invalid domain #tempemail#">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF IsValid("email", tempemail) --->
</cfif>

<!--- /CFIF for step is "1" --->
</cfif>

<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "local_part")>

    <cfset m="Add Virtual Recipients: form.local_part does not exist">
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

  <cfset m="Add Virtual Recipients: form.forwards_1 does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "forwards_1")>

<cfif #form.forwards_1# is "">

<cfset step=0>
<cfset errormessage=1>

<cfelse>

<cfif IsValid("email", form.forwards_1)>

<cfset step=4>

<cfelse>

<cfset step=0>
<cfset errormessage=2>

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

<cfinclude template="./inc/addvirtualrecipients.cfm">




<cfelseif #checkdomain.recordcount# LT 1>

<cfset m="Add Virtual Recipients: form.domain is does not exist">
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




<cfif #success# GTE "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The following #success# Recipients were added successfully:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>
 


<cfif #errormessage# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Delivers To field cannot be empty</cfoutput>
  </div>

</cfif>

<cfif #errormessage# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Delivers To field must be a valid e-mail address</cfoutput>
  </div>

</cfif>

<cfif #errormessage# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Errors were encountered while adding recipients. Please see below</cfoutput>
  </div>

</cfif>




<cfif #invalidemail# is not "0">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
      <cfoutput>The following #invalidemail# entries had invalid Local-Part(s). Local-Part is the part before the <strong>@</strong> symbol of an e-mail address NOT an actual e-mail address:</cfoutput><br>
      <cfoutput>#invalidemailrecipient#</cfoutput>
    </div>

</cfif>

<cfif #alreadyexists# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #alreadyexists# recipient(s) already exist:</cfoutput><br>
    <cfoutput>#alreadyexistsrecipient#</cfoutput>
  </div>

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
  <input type="hidden" name="action" value="add">
    <div class="box-body">
       
      <cfoutput>
        <div class="form-horizontal">
          <label for="local_part"><strong>Local-Part(s)</strong></label>
          <div class="form-group">
              
                
                  <textarea class="form-control" name="local_part" rows="10" placeholder="Enter the local-part(s) (part before the @ symbol of an e-mail address) each in its own line or leave empty to forward entire domain" required></textarea>            
          </div>


          <cfquery name="getdomains" datasource="hermes">
            select id, domain from domains order by domain asc
            </cfquery>




                    <div class="form-group">
                      <label><strong>@Domain</strong></label>
                      <select class="form-control select2" name="domain" data-placeholder="Domain"
                              style="width: 100%;">
                      
                        <cfoutput query="getdomains">
                          <option value="#domain#">#domain#</option>
                        
                          </cfoutput>
                          </select>


                       
      </div>
      </cfoutput>


      <div class="form-group">
        <label><strong>Delivers To</strong></label>
        <div class="input-group">
        <cfoutput>
        <input type="text" name="forwards_1" class="forwards form-control" id="forwards_1" placeholder="Start typing to search existing Internal Recipients or enter external recipient manually" value="" autocomplete="off">
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