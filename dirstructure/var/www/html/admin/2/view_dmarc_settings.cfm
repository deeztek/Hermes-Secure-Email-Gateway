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
  <title>Hermes SEG | DMARC Settings</title>

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
    $("#deletedomains").click(function() {
      var deletedomains = [];
      $.each($("input[name='id']:checked"), function() {
        deletedomains.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="delete_id" value=' + deletedomains + '>');
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
            <h1 class="m-0">DMARC Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">DMARC Settings</li>
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
  <cfoutput>M: #session.m#</cfoutput>
  --->

  <!--- /CFIF for session.m is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.m --->
  </cfif>

  <!---
  <cfoutput>session M: #m#</cfoutput>
  --->

  <cfparam name = "errormessage" default = "0">
  <cfif StructKeyExists(session, "errormessage")>
    <cfif session.errormessage is not "">
    <cfset errormessage = session.errormessage>

<!--- ENABLE FOR DEBUG BELOW --->

  <!---
  <cfoutput>M: #session.errormessage#</cfoutput>
  --->

    <!--- /CFIF for session.errormessage is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.errormessage --->
  </cfif>


<cfparam name = "invalid" default = "0">

<cfif StructKeyExists(session, "invalid")>
  <cfif session.invalid is not "">
  <cfset invalid = session.invalid>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.invalid#</cfoutput>
--->


    <!--- /CFIF for session.invalid is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.invalid --->
  </cfif>


<cfparam name = "invalid_domain" default = "">

<cfif StructKeyExists(session, "invalid_domain")>
  <cfif session.invalid_domain is not "">
  <cfset invalid_domain = session.invalid_domain>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.invalid_domain#</cfoutput>
--->

    <!--- /CFIF for session.invalid_domain is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.invalid_domain --->
  </cfif>


<cfparam name = "exists" default = "0">

<cfif StructKeyExists(session, "exists")>
  <cfif session.exists is not "">
  <cfset exists = session.exists>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.exists#</cfoutput>
--->


    <!--- /CFIF for session.exists is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.exists --->
  </cfif>


<cfparam name = "exists_domain" default = "">

<cfif StructKeyExists(session, "exists_domain")>
  <cfif session.exists_domain is not "">
  <cfset exists_domain = session.exists_domain>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.exists#</cfoutput>
--->

    <!--- /CFIF for session.exists_domain is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.exists_domain --->
  </cfif>

<cfparam name = "success" default = "0">

<cfif StructKeyExists(session, "success")>
  <cfif session.success is not "">
  <cfset success = session.success>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.success#</cfoutput>
--->


    <!--- /CFIF for session.success is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.success --->
  </cfif>

<cfparam name = "success_domain" default = "">

<cfif StructKeyExists(session, "success_domain")>
  <cfif session.success_domain is not "">
  <cfset success_domain = session.success_domain>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.success_domain#</cfoutput>
--->


    <!--- /CFIF for session.success_domain is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.success_domain --->
  </cfif>
  
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
<!---
    <cfinclude template="./inc/get_dmarc_mysql_creds.cfm" />
--->
    <cfinclude template="./inc/get_dmarc_settings.cfm" />

    <cfquery name="getdmarcdomains" datasource="hermes">
      select id, domain, note, type from dmarc_domains
      </cfquery>
    
<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must first enable both SPF and DKIM before you can enable DMARC</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Failure Reports From E-mail Address cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>
      

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Failure Reports From E-mail Address must be a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Failure Reports Reporting Organization cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Failure Reports Reporting Organization can only contain letters A-Z and numbers 0-9</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

   

      <cfif #m# is "9">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>DMARC Settings settings were saved successfully </cfoutput><br> 
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

      
      <cfif #m# is "11">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>You must select domain(s) before clicking the <strong>Delete Whitelisted Domain(s)</strong> button</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "12">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Domain(s) were deleted successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>


      <cfif #m# is "13">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain(s) field cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "14">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain name in the entry you are attempting to edit already exists</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      
      <cfif #m# is "15">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Domain was edited successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "16">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain field in the entry you are attempting to edit cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>


      
      <cfif #m# is "17">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain field in the entry you are attempting to edit is not a valid domain</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>



      <cfif #success# GTE "1">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>The following #success# Domains were added successfully:</cfoutput><br>
          <cfoutput>#success_domain#</cfoutput>
        </div>

        <cfset session.success = 0>
        <cfset session.success_domain = "">

      </cfif>
       
      
      
      <cfif #errormessage# is "1">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain field cannot be empty</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      <cfif #errormessage# is "2">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain field must be a valid domain</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      <cfif #errormessage# is "3">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>Errors were encountered while adding Domains. Please see below</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      
      
      
      <cfif #invalid# is not "0">
      
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
            <cfoutput>The following #invalid# entries were invalid domains:</cfoutput><br>
            <cfoutput>#invalid_domain#</cfoutput>
          </div>

          <cfset session.invalid = 0>
          <cfset session.invalid_domain = "">
      
      </cfif>
      
      <cfif #exists# is not "0">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
          <cfoutput>The following #exists# domain(s) already exist:</cfoutput><br>
          <cfoutput>#exists_domain#</cfoutput>
        </div>

        <cfset session.exists = 0>
        <cfset session.exists_domain = "">
      
      </cfif>
      



<!--- ERROR MESSAGES END HERE --->

  <span>
    <p>  

      
<!--- ADD IP BUTTON STARTS HERE --->
<cfoutput>
  <a href="##adddomain_modal"  class="btn btn-primary" role="button" data-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Whitelisted Domain(s)</a>
  </cfoutput>
  <!--- ADD IP BUTTON ENDS HERE --->
&nbsp;&nbsp;



      <button type="button" id="deletedomains" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete Whitelisted Domain(s)</button>
      &nbsp;&nbsp;


</p>
</span>

<div class="card col-sm-8">
  
  <!---
  <div class="card-header border-1">

    <h3 class="card-title"><strong>DMARC Settings Settings</strong></h3>

  <!--- class="card-header border-1" --->
</div>
--->

<form name="dmarcsettings" method="post">

  <input type="hidden" name="action" value="DMARC Settings">
<div>&nbsp;</div>
  <div class="alert alert-warning">
             
    <p><i class="icon fas fa-exclamation-triangle"></i>You will not be allowed to enable <strong>DMARC</strong> unless both <strong>DKIM</strong> and <strong>SPF</strong> are enabled</p>
    </div>

  <div class="col-sm-6">
    <div class="form-group">
  

             <label><strong>DMARC Enabled</strong></label>

        
               
             <select class="form-control" name="dmarcenabled" style="width: 100%;" id="dmarcenabled">
 
       <cfif #dmarcenabled# is "1">
         
                 <option value="1" selected>YES</option>
                 <option value="2">NO</option>
          
 
             <cfelseif #dmarcenabled# is "2">
 
               <option value="2" selected>NO</option>
               <option value="1">YES</option>
 
               <!--- /CFIF cfif #dmarcenabled# is --->
             </cfif>
            
                 </select>   
 
     
             
             <!-- class="form-group" -->  
             </div>

            <!--  class="col-sm-6" -->
            </div>


  
    <cfif #dmarcenabled# is "2">

      <div class="form-group" id="dmarcsettings" style="display:none;">

        <div class="col-sm-6">

            <label><strong>Reject Failures</strong></label>
              
            <select class="form-control" name="rejectfailures" style="width: 100%;" id="rejectfailures">

      <cfif #rejectfailures# is "true">
        
                <option value="true" selected>YES (Recommended)</option>
                <option value="false">NO</option>
         

            <cfelseif #rejectfailures# is "false">

              <option value="false" selected>NO</option>
              <option value="true">YES (Recommended)</option>

              <!--- /CFIF cfif #rejectfailures# is --->
            </cfif>
           
                </select>   


        
                       <label><strong>Hold Quarantine Policy Messages</strong></label>
                         
                       <select class="form-control" name="holdquarantinedmessages" style="width: 100%;" id="holdquarantinedmessages">
           
                 <cfif #holdquarantinedmessages# is "true">
                   
                           <option value="true" selected>YES</option>
                           <option value="false">NO (Recommended)</option>
                    
           
                       <cfelseif #holdquarantinedmessages# is "false">
           
                         <option value="false" selected>NO (Recommended)</option>
                         <option value="true">YES</option>
           
                         <!--- /CFIF cfif #rejectfailures# is --->
                       </cfif>
                      
                           </select>   

      
                           <label><strong>Generate Daily Failure Reports</strong></label>
                         
                           <select class="form-control" name="failurereports" style="width: 100%;" id="failurereports">
               
<cfif #failurereports# is "true">
                       
                               <option value="true" selected>YES (Recommended)</option>
                               <option value="false">NO</option>
                        
               
<cfelseif #failurereports# is "false">
               
                             <option value="false" selected>NO</option>
                             <option value="true">YES (Recommended)</option>
               
                             <!--- /CFIF cfif #failurereports# is --->
                           </cfif>
                          
                               </select>   


<cfif #failurereports# is "false">


                                <div class="form-group" id="failurereportssettings" style="display:none;">
 
                                 <label>Failure Reports From E-mail Address</label>
                                 <div class="input-group">
                                 <cfoutput>
                                 <input type="text" name="report_email" class="report_email form-control" id="report_email" placeholder="Enter a valid e-mail address" value="#report_email#" autocomplete="off">
                                 </cfoutput>
 
                                    <!--- /div class="input-group" --->
                                </div>
 
                                 <label>Failure Reports Reporting Organization</label>
                                 <div class="input-group">
                                 <cfoutput>
                                 <input type="text" name="report_org" class="report_org form-control" id="report_org" placeholder="Enter the name of your organization" value="#report_org#" autocomplete="off">
                                 </cfoutput>
 
                                 <!--- /div class="input-group" --->
                                 </div>
 
 
 <cfelseif #failurereports# is "true">
 
                                   
                                <div class="form-group" id="failurereportssettings">
 
                                 <label>Failure Reports From E-mail Address</label>
                                 <div class="input-group">
                                 <cfoutput>
                                 <input type="text" name="report_email" class="report_email form-control" id="report_email" placeholder="Enter a valid e-mail address" value="#report_email#" autocomplete="off">
                                 </cfoutput>
 
                                    <!--- /div class="input-group" --->
                                </div>
 
                                 <label>Failure Reports Reporting Organization</label>
                                 <div class="input-group">
                                 <cfoutput>
                                 <input type="text" name="report_org" class="report_org form-control" id="report_org" placeholder="Enter the name of your organization" value="#report_org#" autocomplete="off">
                                 </cfoutput>
 
                                 <!--- /div class="input-group" --->
                                 </div>
 
                               <!--- /CFIF #failurereports# is "true" --->
                               </cfif>
 
                           <!--- /DIV class="form-group" id="failurereportssettings" --->
                           </div>

      <!---  class="col-sm-6" --->
      </div>

        <!--- class="form-group" class="form-group" id="dmarcsettings"  --->  
          </div>
           
          
<cfelse>
          
          <div class="form-group" id="dmarcsettings">

            <div class="col-sm-6">
    
                <label><strong>Reject Failures</strong></label>
                  
                <select class="form-control" name="rejectfailures" style="width: 100%;" id="rejectfailures">
    
          <cfif #rejectfailures# is "true">
            
                    <option value="true" selected>YES (Recommended)</option>
                    <option value="false">NO</option>
             
    
                <cfelseif #rejectfailures# is "false">
    
                  <option value="false" selected>NO</option>
                  <option value="true">YES (Recommended)</option>
    
                  <!--- /CFIF cfif #rejectfailures# is --->
                </cfif>
               
                    </select>   
    
    
            
                           <label><strong>Hold Quarantine Policy Messages</strong></label>
                             
                           <select class="form-control" name="holdquarantinedmessages" style="width: 100%;" id="holdquarantinedmessages">
               
                     <cfif #holdquarantinedmessages# is "true">
                       
                               <option value="true" selected>YES</option>
                               <option value="false">NO (Recommended)</option>
                        
               
                           <cfelseif #holdquarantinedmessages# is "false">
               
                             <option value="false" selected>NO (Recommended)</option>
                             <option value="true">YES</option>
               
                             <!--- /CFIF cfif #rejectfailures# is --->
                           </cfif>
                          
                               </select>   


                               <label><strong>Generate Daily Failure Reports</strong></label>
                         
                           <select class="form-control" name="failurereports" style="width: 100%;" id="failurereports">
               
<cfif #failurereports# is "true">
                       
                               <option value="true" selected>YES (Recommended)</option>
                               <option value="false">NO</option>
                        
               
<cfelseif #failurereports# is "false">
               
                             <option value="false" selected>NO</option>
                             <option value="true">YES (Recommended)</option>
               
                             <!--- /CFIF cfif #failurereports# is --->
                           </cfif>
                          
                               </select>   



    <cfif #failurereports# is "false">


                               <div class="form-group" id="failurereportssettings" style="display:none;">

                                <label>Failure Reports From E-mail Address</label>
                                <div class="input-group">
                                <cfoutput>
                                <input type="text" name="report_email" class="report_email form-control" id="report_email" placeholder="Enter a valid e-mail address" value="#report_email#" autocomplete="off">
                                </cfoutput>

                                   <!--- /div class="input-group" --->
                               </div>

                                <label>Failure Reports Reporting Organization</label>
                                <div class="input-group">
                                <cfoutput>
                                <input type="text" name="report_org" class="report_org form-control" id="report_org" placeholder="Enter the name of your organization" value="#report_org#" autocomplete="off">
                                </cfoutput>

                                <!--- /div class="input-group" --->
                                </div>


<cfelseif #failurereports# is "true">

                                  
                               <div class="form-group" id="failurereportssettings">

                                <label>Failure Reports From E-mail Address</label>
                                <div class="input-group">
                                <cfoutput>
                                <input type="text" name="report_email" class="report_email form-control" id="report_email" placeholder="Enter a valid e-mail address" value="#report_email#" autocomplete="off">
                                </cfoutput>

                                   <!--- /div class="input-group" --->
                               </div>

                                <label>Failure Reports Reporting Organization</label>
                                <div class="input-group">
                                <cfoutput>
                                <input type="text" name="report_org" class="report_org form-control" id="report_org" placeholder="Enter the name of your organization" value="#report_org#" autocomplete="off">
                                </cfoutput>

                                <!--- /div class="input-group" --->
                                </div>

                              <!--- /CFIF #failurereports# is "true" --->
                              </cfif>

                          <!--- /DIV class="form-group" id="failurereportssettings" --->
                          </div>
    
          <!---  class="col-sm-6" --->
          </div>
    
            <!--- class="form-group" class="form-group" id="dmarcsettings"  --->  
              </div>

              <!--- /CFIF #dmarcenabled# is --->
            </cfif>
          

  
  
  <div class="col-sm-6">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  <!--- div class="col-sm-6" --->
  </div>
    
  </form>  
  
<br>

  <!--- div class="card"  --->  
</div>



<!--- DELETE DOMAIN MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Delete Whitelisted Domain(s) </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete the Domain(s) you have selected? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteDomain" method="post">

    <input type="hidden" name="action" value="Delete Domain">
    <div id="deleteid"></div>
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- DELETE DOMAIN MODAL HTML ENDS HERE --->


<!--- EDIT DOMAIN MODAL HTML STARTS HERE --->

<div class="modal fade" id="editdomain_modal" tabindex="-1" role="dialog" aria-labelledby="editDomainModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Edit Domain</h4>
</div>
  
<div class="modal-body">


  <form name="EditDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Edit Domain">

    <input type="hidden" name="id" value=""/>

    <cfoutput>
      <div class="form-group">
        <label><strong>Domain</strong></label>
        
        <input type="text" class="form-control" name="domain" value="" id="domain" placeholder="Domain" maxLength="255">
      </div>
      </cfoutput>

      
            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="note" value="" id="note" placeholder="Enter Note" maxLength="255">
              </div>
              </cfoutput>

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- EDIT DOMAIN MODAL HTML ENDS HERE --->


<!--- ADD DOMAIN MODAL HTML STARTS HERE --->

<div class="modal fade" id="adddomain_modal" tabindex="-1" role="dialog" aria-labelledby="AddDomainModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add Whitelisted Domain(s) </h4>
</div>
  
<div class="modal-body">

  <form name="AddDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Add Domain">



      <div class="form-group">
        <label>Domain(s)</label>
        <div class="textareacontainer">
    <textarea name="domain" placeholder="Enter domain(s) each in its own line" wrap="physical" rows="10"></textarea>
    </div>
    
      </div>

            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="note" value="" id="note" placeholder="Enter Note" maxLength="255">
              </div>
              </cfoutput>

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- ADD DOMAIN MODAL HTML ENDS HERE --->
  

         

<cfif #action# is "DMARC Settings">

  <cfif NOT StructKeyExists(form, "dmarcenabled")>

    <cfset m="DMARC Settings: form.dmarcenabled does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "dmarcenabled")>

    <cfif #form.dmarcenabled# is "1">
      
      <cfset step=1>

    <cfelseif #form.dmarcenabled# is "2">

      <cfset step=7>   

<cfelse>   

  <cfset m="DMARC Settings: form.dmarcenabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF #form.dmarcenabled# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "dmarcenabled") --->
</cfif>


<cfif #step# is "1">

<!--- CHECK IF SPF ENABLED --->
<cfinclude template="./inc/get_spf_settings.cfm">

<!--- CHECK IF DKIM ENABLED --->
<cfinclude template="./inc/get_dkim_settings.cfm">

<cfif #get_spf.enabled# is "1" AND #get_dkim.enabled# is "1">

<cfset step=2>

<cfelse>

<cfset session.m=1>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">


<!---  #get_spf.enabled# is "1" AND #get_dkim.enabled# is "1" --->
</cfif>

<!--- /CFIF #step# is "1" --->
</cfif>


<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "rejectfailures")>

    <cfset m="DMARC Settings: form.rejectfailures does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



    <cfelseif StructKeyExists(form, "rejectfailures")>
      

<cfif #form.rejectfailures# is "true" OR #form.rejectfailures# is "false">      

  <cfset step=3>
    
    <cfelse>
    

      <cfset m="DMARC Settings: form.rejectfailures is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<!--- /CFIF #form.rejectfailures# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "rejectfailures") --->
</cfif>


<!--- /CFIF #step# is "2" --->  
</cfif>



<cfif #step# is "3">

  <cfif NOT StructKeyExists(form, "holdquarantinedmessages")>

    <cfset m="DMARC Settings: form.holdquarantinedmessages does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



    <cfelseif StructKeyExists(form, "holdquarantinedmessages")>


<cfif #form.holdquarantinedmessages# is "true" OR #form.holdquarantinedmessages# is "false">      

  <cfset step=4>
    
    <cfelse>
    

      <cfset m="DMARC Settings: form.holdquarantinedmessages is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

<!--- /CFIF #form.holdquarantinedmessages# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "holdquarantinedmessages") --->
</cfif>


<!--- /CFIF #step# is "3" --->  
</cfif>



<cfif #step# is "4">

  <cfif NOT StructKeyExists(form, "failurereports")>

    <cfset m="DMARC Settings: form.failurereports does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "failurereports")>


<cfif #form.failurereports# is "true">      

  <cfset step=5>

<cfelseif  #form.failurereports# is "false">

  <cfset step=7>
    
    <cfelse>  

      <cfset m="DMARC Settings: form.failurereports is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.failurereports# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "failurereports") --->
</cfif>

<!--- /CFIF #step# is "4" --->  
</cfif>



<cfif #step# is "5">

  
  <cfif NOT StructKeyExists(form, "report_email")>

    <cfset m="DMARC Settings: form.report_email does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


   <cfelseif StructKeyExists(form, "report_email")>

    <cfif #form.report_email# is "">

      <cfset session.m=2>

      <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <cfelseif #form.report_email# is not "">

    <cfif IsValid("email", form.report_email)>

    <cfset step=6>

    <cfelse>

      <cfset session.m=3>

      <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <!--- /CFIF IsValid("email", form.report_email) --->
    </cfif>

        <!--- /CFIF  #form.report_email# is "" --->
      </cfif>

        <!--- /CFIF  StructKeyExists(form, "report_email") --->
      </cfif>


<!--- /CFIF #step# is "5" --->
</cfif>


<cfif #step# is "6">

  
  <cfif NOT StructKeyExists(form, "report_org")>

    <cfset m="DMARC Settings: form.report_org does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "report_org")>

    <cfif #form.report_org# is "">

      <cfset session.m=4>

      <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <cfelseif #form.report_org# is not "">

  <cfif REFind("[^A-Za-z0-9]",form.report_org) gt 0>

    <cfset session.m=5>

    <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <cfelse>

      <cfset step=7>


    <!--- /CFIF REFind("[^A-Za-z0-9]",form.report_org) gt 0 --->
    </cfif>

        <!--- /CFIF #form.report_org# is "" --->
      </cfif>

        <!--- /CFIF StructKeyExists(form, "report_org") --->
      </cfif>

<!--- /CFIF #step# is "6" --->
</cfif>


<cfif #step# is "7">


<cfinclude template="./inc/dmarc_set_settings.cfm">

<cfinclude template="./inc/generate_postfix_configuration.cfm">

<cfinclude template="./inc/restart_postfix.cfm">

<cfset session.m=9>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">


<!--- /CFIF #step# is "7" --->
</cfif>


<cfelseif #action# is "Delete Domain">

  <cfif NOT StructKeyExists(form, "delete_id")>

    <cfset session.m = 11>

  <cflocation url="view_dmarc_settings.cfm" addtoken="no">


    <cfelseif StructKeyExists(form, "delete_id")>

    <cfif #form.delete_id# is "">

      <cfset session.m = 11>

    <cflocation url="view_dmarc_settings.cfm" addtoken="no">
        

    <cfelseif #form.delete_id# is not "">      

<cfloop index="i" list="#form.delete_id#" delimiters=",">

<cfif IsValid("integer", #i#)>

  <cfquery name="getdomain" datasource="hermes">
  select id, domain from dmarc_domains where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

  <cfif #getdomain.recordcount# GTE 1>

    <cfset delete_id = #getdomain.id#>

    <cfinclude template="./inc/dmarc_delete_domain.cfm">

    
      <cfoutput>
      #i#<br>
    </cfoutput>
  

    <!--- /CFIF #getdomain.recordcount# --->
  </cfif>

    <!--- /CFIF IsValid("integer", #i#) --->
  </cfif>

  
  </cfloop>

  <cfset session.m = 12>

  <cfinclude template="./inc/dmarc_generate_domains.cfm">
  <cfinclude template="./inc/restart_opendmarc.cfm">

<cflocation url="view_dmarc_settings.cfm" addtoken="no">


<!--- /CFIF #form.delete_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "delete_id") --->
</cfif>

<cfelseif #action# is "Add Domain">

  <cfif NOT StructKeyExists(form, "domain")>
    
    
    <cfset m="DMARC Settings Add Domain: form.domain does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "domain")>

    <cfif #form.domain# is "">

      <cfset session.m = 13>

    <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <cfelse>
  
  <cfset step=1> 

    <!--- /CFIF #form.domain# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "domain") --->
  </cfif>


<cfif #step# is "1">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DMARC Settings Add Domain: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=2> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "1" --->
    </cfif>


        
  <cfif #step# is "2">

  <cfinclude template="./inc/dmarc_add_domains.cfm">


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dmarc_generate_domains.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cflocation url="view_dmarc_settings.cfm" addtoken="no">


<cfelseif #action# is "Edit Domain">


  <cfif NOT StructKeyExists(form, "id")>
    
    
    <cfset m="DMARC Settings Edit Domain: form.id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "id")>

    <cfif #form.id# is "">

      <cfset m="DMARC Settings Edit Domain: form.id is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<cfelseif #form.id# is not "">

<cfif isValid("integer", form.id)>

<cfquery name="getdomain" datasource="hermes">
select id, domain from dmarc_domains where id = <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER"> 
</cfquery>

<cfif #getdomain.recordcount# GTE 1>
  
<cfset step=1> 

<cfelseif #getdomain.recordcount# LT 1>

  <cfset m="DMARC Settings Edit Domain: getdomain.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getdomain.recordcount# --->  
</cfif>

<cfelseif NOT isValid("integer", form.id)>

  <cfset m="DMARC Settings Edit Domain: form.id is not valid integer">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF isValid("integer", form.domain) --->
</cfif>

    <!--- /CFIF #form.domain# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "domain") --->
  </cfif>


  <cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "domain")>
    
    
    <cfset m="DMARC Settings Add Domain: form.domain does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  

  <cfelseif StructKeyExists(form, "domain")>

    <cfif #form.domain# is "">

      <cfset session.m = 16>

    <cflocation url="view_dmarc_settings.cfm" addtoken="no">

    <cfelseif #form.domain# is not "">

  
      <!--- CHECK IF VALID DOMAIN --->
      <cfset tempemail="bob@#domain#">
    
      <cfif IsValid("email", tempemail)>
  
  <cfset step=2> 

  <cfelseif NOT IsValid("email", tempemail)>

    <cfset session.m = 17>

    <cflocation url="view_dmarc_settings.cfm" addtoken="no">

<!--- IsValid("email", tempemail) --->
  </cfif>


    <!--- /CFIF #form.domain# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "domain") --->
  </cfif>

  <!--- /CFIF for step "1" --->
</cfif>






<cfif #step# is "2">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DMARC Settings Add Domain: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=3> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "2" --->
    </cfif>


        
  <cfif #step# is "3">

<!--- CHECK IF DOMAIN EXISTS --->

<cfquery name="checkexists" datasource="hermes">
  select id, domain from dmarc_domains where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#"> and id <> <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER">  
  </cfquery>

<cfif #checkexists.recordcount# GTE 1>

  
<cfset session.m=14>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">

<cfelse>

<cfinclude template="./inc/dmarc_edit_domain.cfm">

<!--- /CFIF #checkexists.recordcount# --->
</cfif>


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dmarc_generate_domains.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cfset session.m=15>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">

    
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



  <!--- ENABLE FOR DEBUG BELOW --->
<!---
customtrans: <cfoutput>#customtrans3#</cfoutput>  
--->   
    <cfif #getdmarcdomains.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>Edit</th>    
      <th>Domain</th>
      <th>Note</th>
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getdmarcdomains">


  <td><input type="checkbox" name="id" value="#id#"></td>

  <td>

    <button a href="##editdomain_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-domain="#domain#" data-note="#note#"><i class="fas fa-edit"></i></button>

  </td>

  



<td>#domain#</td>  


<td>#note#</td>


    
          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>Edit</th>    
      <th>Domain</th>
      <th>Note</th>
           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getdmarcdomains.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Whitelisted Domain(s) were found</strong></cfoutput>
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

    <!--- SCRIPT TO DMARC SETTINGS SCRIPT STARTS HERE  --->
<script>

  $('#dmarcenabled').on('change',function(){
    if( $(this).val()==="2"){
    $("#dmarcsettings").hide()
    }
    else{
    $("#dmarcsettings").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE DMARC SETTINGS SCRIPT ENDS HERE  --->

    <!--- SCRIPT TO SHOW/HIDE DMARC REPORT SETTINGS SCRIPT STARTS HERE  --->
    <script>

      $('#failurereports').on('change',function(){
        if( $(this).val()==="false"){
        $("#failurereportssettings").hide()
        }
        else{
        $("#failurereportssettings").show()
        }
      });
      
      </script>
    
      
    <!--- SCRIPT TO SHOW/HIDE DMARC REPORT SETTINGS SCRIPT ENDS HERE  --->
    

<!--- EDIT DOMAIN MODAL SCRIPT STARTS HERE  --->
<script>
  $('#editdomain_modal').on('show.bs.modal', function(e) {
var id = $(e.relatedTarget).data('id');
$(e.currentTarget).find('input[name="id"]').val(id);

var domain = $(e.relatedTarget).data('domain');
$(e.currentTarget).find('input[name="domain"]').val(domain);

var note = $(e.relatedTarget).data('note');
$(e.currentTarget).find('input[name="note"]').val(note);


  });


    </script>

<!--- EDIT DOMAIN MODAL SCRIPT ENDS HERE  --->

</html>