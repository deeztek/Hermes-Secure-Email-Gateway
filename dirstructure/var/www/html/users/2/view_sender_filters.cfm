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
  <title>Hermes SEG | Sender Filters</title>

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
    $("#deletesender").click(function() {
      var deletesender = [];
      $.each($("input[name='id']:checked"), function() {
        deletesender.push($(this).val());
      });
      $('#deletesender_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="sender_id" value=' + deletesender + '>');
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
            <h1 class="m-0">Sender Filters</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Sender Filters</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    

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
    
    <cfif StructKeyExists(form, "action")>
    
      <cfif form.action is "addsender" or form.action is "deletesender">
      
      <cfset action = form.action>
      
      
      <cfelse>
      
      
      <cfset m="View Sender Filters: form.action is not addsender or deletesender">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      
      
      
      <!--- /CFIF for form.action is not "" --->
      </cfif>
      
      <!--- /CFIF for StructKeyExists form.action --->
      </cfif>
  
  

  
        <!--- ERROR MESSAGES START HERE --->

        
  
        <cfif #m# is "1">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You cannot use your e-mail address or the domain part of your e-mail address as the Sender</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "2">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Sender must be a valid domain or e-mail address</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "3">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Sender cannot be blank</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>


          
        <cfif #m# is "4">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Sender Added successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

        </cfif>

        <cfif #m# is "5">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Sender you are attempting to add already exists</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "6">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Sender(s) Deleted Successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

        </cfif>
     
        
        
        <!--- ERROR MESSAGES END HERE --->

        
  <!--- DELETE SENDER MODAL HTML STARTS HERE --->
 

<div class="modal fade" id="deletesender_modal" tabindex="-1" role="dialog" aria-labelledby="deleteSenderModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete Sender(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you to delete the sender(s) you have selected? This action is irreversible!</p>
  
      </div>
      <div class="modal-footer">
        <form name="delete_senders" method="post" action="">
  
          <input type="hidden" name="action" value="deletesender">
          <div id="deleteid"></div>
       
  
<!---
          <button type="input" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Yes</button>
          --->

          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
  </div>
  <!--- DELETE SENDER MODAL HTML ENDS HERE --->
    


  <!--- ADD SENDER MODAL HTML STARTS HERE --->
 

  <div class="modal fade" id="addsender_modal" tabindex="-1" role="dialog" aria-labelledby="AddSenderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          <!---
          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
          --->
            <h4 class="modal-title">Add Sender </h4>
        </div>
          
        <div class="modal-body">

          <!---
          <p>Are you sure you to edit the recipient(s) you have selected? This action is irreversible!</p>
          --->

          <form name="add_sender" method="post" action="">
    
            <input type="hidden" name="action" value="addsender">
            <div id="editencryptionid"></div>

            <div class="alert alert-warning">
    
              <p><i class="icon fas fa-exclamation-triangle"></i>Adding a <strong>"."</strong> in front of a domain name (Example: .domain.tld), will encompass that domain and all subdomains</p>
              </div>

            <div class="form-group" id="userpasswordfield">
              <label for="sender"><strong>Sender E-mail Address or Domain</strong></label>
              <div class="input-group">
              <input type="text" class="form-control" name="sender" value="" id="sender" placeholder="Enter an E-mail Address or Domain" maxLength="64">
              </div>
            </div>

      
              <div class="form-group" id="userpasswordfield">
              <label><strong>Select Action to Take</strong></label>
              <!---
                 <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
               --->
               <div class="input-group">
                 <select class="form-control select2" name="type" data-placeholder="type" style="width: 100%;">
                 
              
                   <option value="allow" selected>Allow</option>
                   <option value="block">Block</option>
           
                   </select>  

                  </div>
                </div>

         
         

  
            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
        </div>


        <div class="modal-footer">
      
          <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    <!--- ADD SENDER MODAL HTML ENDS HERE --->
      
  
      <cfif #action# is "deletesender">

        <cfif NOT StructKeyExists(form, "sender_id")>

        <cfset session.m = 6>
        <cflocation url="view_sender_filters.cfm" addtoken="no">
      

          <cfelseif StructKeyExists(form, "sender_id")>

          <cfif #form.sender_id# is "">

            <cfset step=0>
            <cfset session.m = 6>
            <cflocation url="view_sender_filters.cfm" addtoken="no">
              
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif #form.sender_id# is not "">     
            
          <cfquery name="getrecipientid" datasource="hermes">
          select id, recipient from recipients where recipient='#session.email#'
          </cfquery>
          
          <cfset recipient = #getrecipientid.id#>

<cfloop index="i" list="#form.sender_id#" delimiters=",">

      <cfif IsValid("integer", #i#)>

        <cfquery name="getid" datasource="hermes">
        select recipient_id, mailaddr_id from mailaddr_temp where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER"> and recipient_id = '#recipient#'
        </cfquery>

        <cfif #getid.recordcount# GTE 1>


          <cfinclude template="./inc/delete_sender.cfm">

          <!--- /CFIF #getrecipient.recordcount# --->
        </cfif>
      
          <!--- /CFIF IsValid("integer", #i#) --->
        </cfif>
      
        
        </cfloop>

        <cfset step=0>
        <cfset session.m = 6>
        <cflocation url="view_sender_filters.cfm" addtoken="no">
 

<!--- /CFIF #form.sender_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "sender_id") --->
</cfif>


<cfelseif #action# is "addsender">

   <cfif StructKeyExists(form, "sender")>
   
   <cfif form.sender is not "">
   
   <cfset step=1>
   
   <cfelse>
   

    <cfset step=0>
    <cfset session.m = 3>
    <cflocation url="view_sender_filters.cfm" addtoken="no">
   
   <!--- /CFIF for form.sender is not "" --->
   </cfif>

  <cfelse>

    <cfset m="View Sender Filters: form.sender does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
   
   <!--- /CFIF for StructKeyExists form.type --->
   </cfif> 
   
<cfif #step# is "1">

    <cfif StructKeyExists(form, "type")>
    
    <cfif form.type is "allow" OR form.type is "block">
    
  <cfif #form.type# is "allow">
    <cfset theType="A">
    <cfset theTypeText="ALLOW">
  <cfelse>
    <cfset theType="B">
    <cfset theTypeText="BLOCK">

    <!--- /CFIF #form.type# is --->
  </cfif>

   <cfset step=2>
    
    <cfelse>
    
    <cfset m="View Sender Filters: form.type is not allow or block">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <!--- /CFIF for form.type is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists form.type --->
    </cfif> 
    
  <!--- /CFIF step 1 --->
  </cfif>

  <cfif #step# is "2">

    <cfif REFIND("[@]",form.sender) gt 0>
      <cfset step=3>
      <cfset theSender="#form.sender#">
      <cfelse>
      <cfset step=4>
      <cfset theSender="@#form.sender#">
      </cfif>

  <!--- /CFIF step 2 --->
  </cfif>


<cfif #step# is "3">

  <cfif IsValid("email", theSender)>

    <cfset receiverdomain = #trim(ListGetAt(session.email, 2, "@"))#>
    <cfset senderdomain = #trim(ListGetAt(theSender, 2, "@"))#>
    <cfset compare_email = Compare(#receiverdomain#, #senderdomain#)>


    <cfif #compare_email# is "1">
    <cfset step=5>
    
    <cfelseif #compare_email# is "-1">
    <cfset step=5>
    
    <cfelseif #compare_email# is "0">

      <cfset step=0>
      <cfset session.m = 1>
      <cflocation url="view_sender_filters.cfm" addtoken="no">

      <!--- /CFIF compare_email is --->
    </cfif>

    <cfelseif not IsValid("email", form.sender)>

      <cfset step=0>
      <cfset session.m = 2>
      <cflocation url="view_sender_filters.cfm" addtoken="no">

     <!--- /CFIF IsValid("email", form.sender) --->
    </cfif>

    <!--- /CFIF step 3 --->
</cfif>


    <cfif #step# is "4">

    <cfset tempSender = REReplace("#theSender#","@","","ALL")>

      <cfif #trim(left(tempSender, 1))# EQ "."> 
        <cfset temp_email="bob@temp#tempSender#">
        <cfelseif #trim(left(tempSender, 1))# NEQ "."> 
        <cfset temp_email="bob@#tempSender#">

        <!--- /CFIF #trim(left(form.sender, 1))# EQ "." --->
        </cfif>

        <cfif IsValid("email", temp_email)>
        <cfset domainpart = #trim(ListGetAt(session.email, 2, "@"))#>
        <cfset compare_domain = Compare(#tempSender#, #domainpart#)>

        <cfif #compare_domain# is "1">
        <cfset step=5>
        <cfelseif #compare_domain# is "-1">
        <cfset step=5>
        <cfelseif #compare_domain# is "0">
  
        <cfset step=0>
        <cfset session.m = 1>
        <cflocation url="view_sender_filters.cfm" addtoken="no">

        <!--- /CFIF compare_domain --->
        </cfif>
        
        <cfelseif not IsValid("email", temp_email)>

          <cfset step=0>
          <cfset session.m = 2>
          <cflocation url="view_sender_filters.cfm" addtoken="no">

        <!--- /CFIF IsValid("email", temp_email) --->
        </cfif>
      

      <!--- /CFIF step 4 --->
    </cfif>

<cfif #step# is "5">

<cfinclude template="./inc/add_sender.cfm" />


<!--- /CFIF step 5 --->
</cfif>
    
      <!--- /CFIF #action# is --->     
    </cfif> 
    

  

<form>
    
<span>
  <p>       

    <!--- ADD SENDER BUTTON STARTS HERE --->
<cfoutput>
  <a href="##addsender_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Sender</a>
  </cfoutput>
  <!--- ADD SENDER BUTTON ENDS HERE --->
  &nbsp;&nbsp;

<button type="button" id="deletesender" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete Sender(s)</button>


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

<div class="alert alert-warning">
    
  <p><i class="icon fas fa-exclamation-triangle"></i>Adding a sender with an <strong>ALLOW</strong> action will only bypass the sender in the Spam filter. E-mails with banned or malware attachments will still be blocked.</p>
  </div>



<cfquery name="getmailaddrtemp" datasource="hermes">
select * from mailaddr_temp where applied='1' and receiver='#session.email#'
  </cfquery>
    
    <cfif #getmailaddrtemp.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            
            <th>Sender</th>
            <th>Receiver</th>
            <th>Action</th>         
          
          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getmailaddrtemp">



        <td><input type="checkbox" name="id" value="#id#"></td>
      
        <td>#sender#</td>
         <td>#receiver#</td>
            <td>#wb#</td>
         

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
            <th></th>
            <th>Sender</th>
            <th>Receiver</th>
            <th>Action</th>  
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getmailaddrtemp.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Senders were found</strong></cfoutput>
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