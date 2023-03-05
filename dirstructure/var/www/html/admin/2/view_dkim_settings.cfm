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
  <title>Hermes SEG | DKIM Settings</title>

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
            <h1 class="m-0">DKIM Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">DKIM Settings</li>
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


<cfparam name = "invalid_entry" default = "">

<cfif StructKeyExists(session, "invalid_entry")>
  <cfif session.invalid_entry is not "">
  <cfset invalid_entry = session.invalid_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.invalid_entry#</cfoutput>
--->

    <!--- /CFIF for session.invalid_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.invalid_entry --->
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


<cfparam name = "exists_entry" default = "">

<cfif StructKeyExists(session, "exists_entry")>
  <cfif session.exists_entry is not "">
  <cfset exists_entry = session.exists_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.exists#</cfoutput>
--->

    <!--- /CFIF for session.exists_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.exists_entry --->
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

<cfparam name = "success_entry" default = "">

<cfif StructKeyExists(session, "success_entry")>
  <cfif session.success_entry is not "">
  <cfset success_entry = session.success_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.success_entry#</cfoutput>
--->


    <!--- /CFIF for session.success_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.success_entry --->
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
    <cfinclude template="./inc/get_dkim_settings.cfm" />

    <cfquery name="getdkimbypass" datasource="hermes">
      select id, entry, note from dkim_bypass
      </cfquery>

<cfquery name="getdkimtrusted" datasource="hermes">
  select id, host, note from dkim_trusted_hosts
  </cfquery>
    
   

      <cfif #m# is "9">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>DKIM Settings settings were saved successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      
      <cfif #m# is "11">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>You must select entries before clicking the <strong>Delete</strong> button</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "12">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Entries were deleted successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>


      <cfif #m# is "13">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host field cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "14">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host in the entry you are attempting to edit already exists</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      
      <cfif #m# is "15">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Entry was edited successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "16">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host field in the entry you are attempting to edit cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>


      
      <cfif #m# is "17">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host field in the entry you are attempting to edit is not a valid</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>



      <cfif #success# GTE "1">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>The following #success# entries were added successfully:</cfoutput><br>
          <cfoutput>#success_entry#</cfoutput>
        </div>

        <cfset session.success = 0>
        <cfset session.success_entry = "">

      </cfif>
       
      
      
      <cfif #errormessage# is "1">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host field cannot be empty</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      <cfif #errormessage# is "2">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Domain/Host field must be valid</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      <cfif #errormessage# is "3">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>Errors were encountered while adding entries. Please see below</cfoutput>
        </div>

        <cfset session.errormessage = 0>
      
      </cfif>
      
      
      
      
      <cfif #invalid# is not "0">
      
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
            <cfoutput>The following #invalid# entries were invalid:</cfoutput><br>
            <cfoutput>#invalid_entry#</cfoutput>
          </div>

          <cfset session.invalid = 0>
          <cfset session.invalid_entry = "">
      
      </cfif>
      
      <cfif #exists# is not "0">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
          <cfoutput>The following #exists# entries already exist:</cfoutput><br>
          <cfoutput>#exists_entry#</cfoutput>
        </div>

        <cfset session.exists = 0>
        <cfset session.exists_entry = "">
      
      </cfif>
      



<!--- ERROR MESSAGES END HERE --->

  <span>
    <p>  

      
<!--- ADD WHITELISTED DOMAIN BUTTON STARTS HERE --->
<cfoutput>
  <a href="##adddomain_modal"  class="btn btn-primary" role="button" data-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Whitelisted Domain(s)</a>
  </cfoutput>
  <!--- ADD WHITELISTED DOMAIN BUTTON ENDS HERE --->
&nbsp;&nbsp;

<!--- ADD TRUSTED HOST BUTTON STARTS HERE --->
<cfoutput>
  <a href="##addhost_modal"  class="btn btn-primary" role="button" data-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Trusted Host(s)</a>
  </cfoutput>
  <!--- ADD TRUSTED HOST BUTTON ENDS HERE --->
&nbsp;&nbsp;



      <button type="button" id="deletedomains" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>
      &nbsp;&nbsp;


</p>
</span>

<div class="card col-sm-8">
  
  <!---
  <div class="card-header border-1">

    <h3 class="card-title"><strong>DKIM Settings Settings</strong></h3>

  <!--- class="card-header border-1" --->
</div>
--->

<form name="dkimsettings" method="post">

  <input type="hidden" name="action" value="DKIM Settings">
<div>&nbsp;</div>

<div class="alert alert-warning">
             
  <p><i class="icon fas fa-exclamation-triangle"></i>Disabling <strong>DKIM</strong> will also disable <strong>DMARC</strong></p>
  </div>

  <div class="col-sm-6">
    <div class="form-group">
  



             <label><strong>DKIM Enabled</strong></label>

        
               
             <select class="form-control" name="dkimenabled" style="width: 100%;" id="dkimenabled">
 
       <cfif #dkimenabled# is "1">
         
                 <option value="1" selected>YES</option>
                 <option value="2">NO</option>
          
 
             <cfelseif #dkimenabled# is "2">
 
               <option value="2" selected>NO</option>
               <option value="1">YES</option>
 
               <!--- /CFIF cfif #dkimenabled# is --->
             </cfif>
            
                 </select>   
 
     
             
             <!-- class="form-group" -->  
             </div>

            <!--  class="col-sm-6" -->
            </div>


  
    <cfif #dkimenabled# is "2">

      <div class="form-group" id="dkimsettings" style="display:none;">

        <div class="col-sm-6">

            <label><strong>Body Canonicalization</strong></label>
              
            <select class="form-control" name="body_canonicalization" style="width: 100%;" id="body_canonicalization">

      <cfif #body_canonicalization# is "simple">
        
                <option value="simple" selected>Simple</option>
                <option value="relaxed">Relaxed (Recommended)</option>
         

            <cfelseif #body_canonicalization# is "relaxed">

              <option value="relaxed" selected>Relaxed (Recommended)</option>
              <option value="simple">Simple</option>
          

              <!--- /CFIF cfif #body_canonicalization# is --->
            </cfif>
           
                </select>   

                <label><strong>Headers Canonicalization</strong></label>
              
                <select class="form-control" name="headers_canonicalization" style="width: 100%;" id="headers_canonicalization">
    
          <cfif #headers_canonicalization# is "simple">
            
                    <option value="simple" selected>Simple</option>
                    <option value="relaxed">Relaxed (Recommended)</option>
             
    
                <cfelseif #headers_canonicalization# is "relaxed">
    
                  <option value="relaxed" selected>Relaxed (Recommended)</option>
                  <option value="simple">Simple</option>
              
    
                  <!--- /CFIF cfif #headers_canonicalization# is --->
                </cfif>
               
                    </select>   
    

                    <label><strong>Default Message Action</strong></label>
              
                    <select class="form-control" name="default_action" style="width: 100%;" id="default_action">
        
              <cfif #default_action# is "accept">
                
                        <option value="accept" selected>Accept (Recommended)</option>
                        <option value="discard">Discard</option>
                        <option value="reject">Reject</option>
                        <option value="tempfail">Temp Fail</option>
                        <option value="quarantine">Quarantine</option>
                 
        
                    <cfelseif #default_action# is "discard">

                      <option value="discard" selected>Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="reject">Reject</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="quarantine">Quarantine</option>

                    <cfelseif #default_action# is "reject">

                      <option value="reject" selected>Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="quarantine">Quarantine</option>

                    <cfelseif #default_action# is "tempfail">

                      <option value="tempfail" selected>Temp Fail</option>
                      <option value="reject">Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="quarantine">Quarantine</option>

                      
                    <cfelseif #default_action# is "quarantine">

                      <option value="quarantine" selected>Quarantine</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="reject">Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
             
                  
        
                      <!--- /CFIF cfif #default_action# is --->
                    </cfif>
                   
                        </select>   


                        <label><strong>Bad Signature Action</strong></label>
              
                        <select class="form-control" name="badsignature_action" style="width: 100%;" id="badsignature_action">
            
                  <cfif #badsignature_action# is "accept">
                    
                            <option value="accept" selected>Accept (Recommended)</option>
                            <option value="discard">Discard</option>
                            <option value="reject">Reject</option>
                            <option value="tempfail">Temp Fail</option>
                            <option value="quarantine">Quarantine</option>
                     
            
                        <cfelseif #badsignature_action# is "discard">
    
                          <option value="discard" selected>Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="reject">Reject</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="quarantine">Quarantine</option>
    
                        <cfelseif #badsignature_action# is "reject">
    
                          <option value="reject" selected>Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="quarantine">Quarantine</option>
    
                        <cfelseif #badsignature_action# is "tempfail">
    
                          <option value="tempfail" selected>Temp Fail</option>
                          <option value="reject">Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="quarantine">Quarantine</option>
    
                          
                        <cfelseif #badsignature_action# is "quarantine">
    
                          <option value="quarantine" selected>Quarantine</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="reject">Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                 
                      
            
                          <!--- /CFIF cfif #badsignature_action# is --->
                        </cfif>
                       
                            </select>   
    

                            <label><strong>DNS Error Action</strong></label>
              
                            <select class="form-control" name="dnserror_action" style="width: 100%;" id="dnserror_action">
                
                      <cfif #dnserror_action# is "accept">
                        
                                <option value="accept" selected>Accept (Recommended)</option>
                                <option value="discard">Discard</option>
                                <option value="reject">Reject</option>
                                <option value="tempfail">Temp Fail</option>
                                <option value="quarantine">Quarantine</option>
                         
                
                            <cfelseif #dnserror_action# is "discard">
        
                              <option value="discard" selected>Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="reject">Reject</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="quarantine">Quarantine</option>
        
                            <cfelseif #dnserror_action# is "reject">
        
                              <option value="reject" selected>Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="quarantine">Quarantine</option>
        
                            <cfelseif #dnserror_action# is "tempfail">
        
                              <option value="tempfail" selected>Temp Fail</option>
                              <option value="reject">Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="quarantine">Quarantine</option>
        
                              
                            <cfelseif #dnserror_action# is "quarantine">
        
                              <option value="quarantine" selected>Quarantine</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="reject">Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                     
                          
                
                              <!--- /CFIF cfif #dnserror_action# is --->
                            </cfif>
                           
                                </select>   


        
                                <label><strong>Internal Error Action</strong></label>
              
                                <select class="form-control" name="internalerror_action" style="width: 100%;" id="internalerror_action">
                    
                          <cfif #internalerror_action# is "accept">
                            
                                    <option value="accept" selected>Accept (Recommended)</option>
                                    <option value="discard">Discard</option>
                                    <option value="reject">Reject</option>
                                    <option value="tempfail">Temp Fail</option>
                                    <option value="quarantine">Quarantine</option>
                             
                    
                                <cfelseif #internalerror_action# is "discard">
            
                                  <option value="discard" selected>Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="reject">Reject</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="quarantine">Quarantine</option>
            
                                <cfelseif #internalerror_action# is "reject">
            
                                  <option value="reject" selected>Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="quarantine">Quarantine</option>
            
                                <cfelseif #internalerror_action# is "tempfail">
            
                                  <option value="tempfail" selected>Temp Fail</option>
                                  <option value="reject">Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="quarantine">Quarantine</option>
            
                                  
                                <cfelseif #internalerror_action# is "quarantine">
            
                                  <option value="quarantine" selected>Quarantine</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="reject">Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                         
                              
                    
                                  <!--- /CFIF cfif #internalerror_action# is --->
                                </cfif>
                               
                                    </select>   


                                    <label><strong>No Signature Action</strong></label>
              
                                    <select class="form-control" name="nosignature_action" style="width: 100%;" id="nosignature_action">
                        
                              <cfif #nosignature_action# is "accept">
                                
                                        <option value="accept" selected>Accept (Recommended)</option>
                                        <option value="discard">Discard</option>
                                        <option value="reject">Reject</option>
                                        <option value="tempfail">Temp Fail</option>
                                        <option value="quarantine">Quarantine</option>
                                 
                        
                                    <cfelseif #nosignature_action# is "discard">
                
                                      <option value="discard" selected>Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="reject">Reject</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="quarantine">Quarantine</option>
                
                                    <cfelseif #nosignature_action# is "reject">
                
                                      <option value="reject" selected>Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="quarantine">Quarantine</option>
                
                                    <cfelseif #nosignature_action# is "tempfail">
                
                                      <option value="tempfail" selected>Temp Fail</option>
                                      <option value="reject">Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="quarantine">Quarantine</option>
                
                                      
                                    <cfelseif #nosignature_action# is "quarantine">
                
                                      <option value="quarantine" selected>Quarantine</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="reject">Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                             
                                  
                        
                                      <!--- /CFIF cfif #nosignature_action# is --->
                                    </cfif>
                                   
                                        </select>   


                                        <label><strong>Security Concern Action</strong></label>
              
                                        <select class="form-control" name="security_action" style="width: 100%;" id="security_action">
                            
                                  <cfif #security_action# is "accept">
                                    
                                            <option value="accept" selected>Accept (Recommended)</option>
                                            <option value="discard">Discard</option>
                                            <option value="reject">Reject</option>
                                            <option value="tempfail">Temp Fail</option>
                                            <option value="quarantine">Quarantine</option>
                                     
                            
                                        <cfelseif #security_action# is "discard">
                    
                                          <option value="discard" selected>Discard</option>
                                          <option value="accept">Accept (Recommended)</option>
                                          <option value="reject">Reject</option>
                                          <option value="tempfail">Temp Fail</option>
                                          <option value="quarantine">Quarantine</option>
                    
                                        <cfelseif #security_action# is "reject">
                    
                                          <option value="reject" selected>Reject</option>
                                          <option value="discard">Discard</option>
                                          <option value="accept">Accept (Recommended)</option>
                                          <option value="tempfail">Temp Fail</option>
                                          <option value="quarantine">Quarantine</option>
                    
                                        <cfelseif #security_action# is "tempfail">
                    
                                          <option value="tempfail" selected>Temp Fail</option>
                                          <option value="reject">Reject</option>
                                          <option value="discard">Discard</option>
                                          <option value="accept">Accept (Recommended)</option>
                                          <option value="quarantine">Quarantine</option>
                    
                                          
                                        <cfelseif #security_action# is "quarantine">
                    
                                          <option value="quarantine" selected>Quarantine</option>
                                          <option value="tempfail">Temp Fail</option>
                                          <option value="reject">Reject</option>
                                          <option value="discard">Discard</option>
                                          <option value="accept">Accept (Recommended)</option>
                                 
                                      
                            
                                          <!--- /CFIF cfif #security_action# is --->
                                        </cfif>
                                       
                                            </select>   


                                            <label><strong>Signature Algorithm</strong></label>
              
                                            <select class="form-control" name="signature_algorithm" style="width: 100%;" id="signature_algorithm">
                                
                                      <cfif #signature_algorithm# is "rsa-sha256">
                                        
                                                <option value="rsa-sha256" selected>RSA-SHA256 (Recommended)</option>
                                                <option value="rsa-sha1">RSA-SHA1</option>
                                  
                                         
                                      <cfelseif #signature_algorithm# is "rsa-sha1">
                                        
                                                  <option value="rsa-sha1" selected>RSA-SHA1</option>
                                                  <option value="rsa-sha256">RSA-SHA256 (Recommended)</option>
             
                                
                                              <!--- /CFIF cfif #signature_algorithm# is --->
                                            </cfif>
                                           
                                                </select>   
                
            

      <!---  class="col-sm-6" --->
      </div>

        <!--- class="form-group" class="form-group" id="dkimsettings"  --->  
          </div>
           
          
<cfelse>
          
  <div class="form-group" id="dkimsettings">

    <div class="col-sm-6">

        <label><strong>Body Canonicalization</strong></label>
          
        <select class="form-control" name="body_canonicalization" style="width: 100%;" id="body_canonicalization">

  <cfif #body_canonicalization# is "simple">
    
            <option value="simple" selected>Simple</option>
            <option value="relaxed">Relaxed (Recommended)</option>
     

        <cfelseif #body_canonicalization# is "relaxed">

          <option value="relaxed" selected>Relaxed (Recommended)</option>
          <option value="simple">Simple</option>
      

          <!--- /CFIF cfif #body_canonicalization# is --->
        </cfif>
       
            </select>   

            <label><strong>Headers Canonicalization</strong></label>
          
            <select class="form-control" name="headers_canonicalization" style="width: 100%;" id="headers_canonicalization">

      <cfif #headers_canonicalization# is "simple">
        
                <option value="simple" selected>Simple</option>
                <option value="relaxed">Relaxed (Recommended)</option>
         

            <cfelseif #headers_canonicalization# is "relaxed">

              <option value="relaxed" selected>Relaxed (Recommended)</option>
              <option value="simple">Simple</option>
          

              <!--- /CFIF cfif #headers_canonicalization# is --->
            </cfif>
           
                </select>   


                <label><strong>Default Message Action</strong></label>
          
                <select class="form-control" name="default_action" style="width: 100%;" id="default_action">
    
          <cfif #default_action# is "accept">
            
                    <option value="accept" selected>Accept (Recommended)</option>
                    <option value="discard">Discard</option>
                    <option value="reject">Reject</option>
                    <option value="tempfail">Temp Fail</option>
                    <option value="quarantine">Quarantine</option>
             
    
                <cfelseif #default_action# is "discard">

                  <option value="discard" selected>Discard</option>
                  <option value="accept">Accept (Recommended)</option>
                  <option value="reject">Reject</option>
                  <option value="tempfail">Temp Fail</option>
                  <option value="quarantine">Quarantine</option>

                <cfelseif #default_action# is "reject">

                  <option value="reject" selected>Reject</option>
                  <option value="discard">Discard</option>
                  <option value="accept">Accept (Recommended)</option>
                  <option value="tempfail">Temp Fail</option>
                  <option value="quarantine">Quarantine</option>

                <cfelseif #default_action# is "tempfail">

                  <option value="tempfail" selected>Temp Fail</option>
                  <option value="reject">Reject</option>
                  <option value="discard">Discard</option>
                  <option value="accept">Accept (Recommended)</option>
                  <option value="quarantine">Quarantine</option>

                  
                <cfelseif #default_action# is "quarantine">

                  <option value="quarantine" selected>Quarantine</option>
                  <option value="tempfail">Temp Fail</option>
                  <option value="reject">Reject</option>
                  <option value="discard">Discard</option>
                  <option value="accept">Accept (Recommended)</option>
         
              
    
                  <!--- /CFIF cfif #default_action# is --->
                </cfif>
               
                    </select>   


                    <label><strong>Bad Signature Action</strong></label>
          
                    <select class="form-control" name="badsignature_action" style="width: 100%;" id="badsignature_action">
        
              <cfif #badsignature_action# is "accept">
                
                        <option value="accept" selected>Accept (Recommended)</option>
                        <option value="discard">Discard</option>
                        <option value="reject">Reject</option>
                        <option value="tempfail">Temp Fail</option>
                        <option value="quarantine">Quarantine</option>
                 
        
                    <cfelseif #badsignature_action# is "discard">

                      <option value="discard" selected>Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="reject">Reject</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="quarantine">Quarantine</option>

                    <cfelseif #badsignature_action# is "reject">

                      <option value="reject" selected>Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="quarantine">Quarantine</option>

                    <cfelseif #badsignature_action# is "tempfail">

                      <option value="tempfail" selected>Temp Fail</option>
                      <option value="reject">Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
                      <option value="quarantine">Quarantine</option>

                      
                    <cfelseif #badsignature_action# is "quarantine">

                      <option value="quarantine" selected>Quarantine</option>
                      <option value="tempfail">Temp Fail</option>
                      <option value="reject">Reject</option>
                      <option value="discard">Discard</option>
                      <option value="accept">Accept (Recommended)</option>
             
                  
        
                      <!--- /CFIF cfif #badsignature_action# is --->
                    </cfif>
                   
                        </select>   


                        <label><strong>DNS Error Action</strong></label>
          
                        <select class="form-control" name="dnserror_action" style="width: 100%;" id="dnserror_action">
            
                  <cfif #dnserror_action# is "accept">
                    
                            <option value="accept" selected>Accept (Recommended)</option>
                            <option value="discard">Discard</option>
                            <option value="reject">Reject</option>
                            <option value="tempfail">Temp Fail</option>
                            <option value="quarantine">Quarantine</option>
                     
            
                        <cfelseif #dnserror_action# is "discard">
    
                          <option value="discard" selected>Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="reject">Reject</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="quarantine">Quarantine</option>
    
                        <cfelseif #dnserror_action# is "reject">
    
                          <option value="reject" selected>Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="quarantine">Quarantine</option>
    
                        <cfelseif #dnserror_action# is "tempfail">
    
                          <option value="tempfail" selected>Temp Fail</option>
                          <option value="reject">Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                          <option value="quarantine">Quarantine</option>
    
                          
                        <cfelseif #dnserror_action# is "quarantine">
    
                          <option value="quarantine" selected>Quarantine</option>
                          <option value="tempfail">Temp Fail</option>
                          <option value="reject">Reject</option>
                          <option value="discard">Discard</option>
                          <option value="accept">Accept (Recommended)</option>
                 
                      
            
                          <!--- /CFIF cfif #dnserror_action# is --->
                        </cfif>
                       
                            </select>   


    
                            <label><strong>Internal Error Action</strong></label>
          
                            <select class="form-control" name="internalerror_action" style="width: 100%;" id="internalerror_action">
                
                      <cfif #internalerror_action# is "accept">
                        
                                <option value="accept" selected>Accept (Recommended)</option>
                                <option value="discard">Discard</option>
                                <option value="reject">Reject</option>
                                <option value="tempfail">Temp Fail</option>
                                <option value="quarantine">Quarantine</option>
                         
                
                            <cfelseif #internalerror_action# is "discard">
        
                              <option value="discard" selected>Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="reject">Reject</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="quarantine">Quarantine</option>
        
                            <cfelseif #internalerror_action# is "reject">
        
                              <option value="reject" selected>Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="quarantine">Quarantine</option>
        
                            <cfelseif #internalerror_action# is "tempfail">
        
                              <option value="tempfail" selected>Temp Fail</option>
                              <option value="reject">Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                              <option value="quarantine">Quarantine</option>
        
                              
                            <cfelseif #internalerror_action# is "quarantine">
        
                              <option value="quarantine" selected>Quarantine</option>
                              <option value="tempfail">Temp Fail</option>
                              <option value="reject">Reject</option>
                              <option value="discard">Discard</option>
                              <option value="accept">Accept (Recommended)</option>
                     
                          
                
                              <!--- /CFIF cfif #internalerror_action# is --->
                            </cfif>
                           
                                </select>   


                                <label><strong>No Signature Action</strong></label>
          
                                <select class="form-control" name="nosignature_action" style="width: 100%;" id="nosignature_action">
                    
                          <cfif #nosignature_action# is "accept">
                            
                                    <option value="accept" selected>Accept (Recommended)</option>
                                    <option value="discard">Discard</option>
                                    <option value="reject">Reject</option>
                                    <option value="tempfail">Temp Fail</option>
                                    <option value="quarantine">Quarantine</option>
                             
                    
                                <cfelseif #nosignature_action# is "discard">
            
                                  <option value="discard" selected>Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="reject">Reject</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="quarantine">Quarantine</option>
            
                                <cfelseif #nosignature_action# is "reject">
            
                                  <option value="reject" selected>Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="quarantine">Quarantine</option>
            
                                <cfelseif #nosignature_action# is "tempfail">
            
                                  <option value="tempfail" selected>Temp Fail</option>
                                  <option value="reject">Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                                  <option value="quarantine">Quarantine</option>
            
                                  
                                <cfelseif #nosignature_action# is "quarantine">
            
                                  <option value="quarantine" selected>Quarantine</option>
                                  <option value="tempfail">Temp Fail</option>
                                  <option value="reject">Reject</option>
                                  <option value="discard">Discard</option>
                                  <option value="accept">Accept (Recommended)</option>
                         
                              
                    
                                  <!--- /CFIF cfif #nosignature_action# is --->
                                </cfif>
                               
                                    </select>   


                                    <label><strong>Security Concern Action</strong></label>
          
                                    <select class="form-control" name="security_action" style="width: 100%;" id="security_action">
                        
                              <cfif #security_action# is "accept">
                                
                                        <option value="accept" selected>Accept (Recommended)</option>
                                        <option value="discard">Discard</option>
                                        <option value="reject">Reject</option>
                                        <option value="tempfail">Temp Fail</option>
                                        <option value="quarantine">Quarantine</option>
                                 
                        
                                    <cfelseif #security_action# is "discard">
                
                                      <option value="discard" selected>Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="reject">Reject</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="quarantine">Quarantine</option>
                
                                    <cfelseif #security_action# is "reject">
                
                                      <option value="reject" selected>Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="quarantine">Quarantine</option>
                
                                    <cfelseif #security_action# is "tempfail">
                
                                      <option value="tempfail" selected>Temp Fail</option>
                                      <option value="reject">Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                                      <option value="quarantine">Quarantine</option>
                
                                      
                                    <cfelseif #security_action# is "quarantine">
                
                                      <option value="quarantine" selected>Quarantine</option>
                                      <option value="tempfail">Temp Fail</option>
                                      <option value="reject">Reject</option>
                                      <option value="discard">Discard</option>
                                      <option value="accept">Accept (Recommended)</option>
                             
                                  
                        
                                      <!--- /CFIF cfif #security_action# is --->
                                    </cfif>
                                   
                                        </select>   


                                        <label><strong>Signature Algorithm</strong></label>
          
                                        <select class="form-control" name="signature_algorithm" style="width: 100%;" id="signature_algorithm">
                            
                                  <cfif #signature_algorithm# is "rsa-sha256">
                                    
                                            <option value="rsa-sha256" selected>RSA-SHA256 (Recommended)</option>
                                            <option value="rsa-sha1">RSA-SHA1</option>
                              
                                     
                                  <cfelseif #signature_algorithm# is "rsa-sha1">
                                    
                                              <option value="rsa-sha1" selected>RSA-SHA1</option>
                                              <option value="rsa-sha256">RSA-SHA256 (Recommended)</option>
         
                            
                                          <!--- /CFIF cfif #signature_algorithm# is --->
                                        </cfif>
                                       
                                            </select>   
            
        

  <!---  class="col-sm-6" --->
  </div>

    <!--- class="form-group" class="form-group" id="dkimsettings"  --->  
      </div>
       

              <!--- /CFIF #dkimenabled# is --->
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
    <h4 class="modal-title">Delete Entries </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete the Entries you have selected? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteEntry" method="post">

    <input type="hidden" name="action" value="Delete Entry">
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

<div class="modal fade" id="editentry_modal" tabindex="-1" role="dialog" aria-labelledby="editDomainModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Edit Entry</h4>
</div>
  
<div class="modal-body">


  <form name="EditEntry" autocomplete="off" method="post">

    <input type="hidden" name="action" value="">

    <input type="hidden" name="id" value=""/>

    <cfoutput>
      <div class="form-group">
        <label><strong>Entry</strong></label>
        
        <input type="text" class="form-control" name="entry" value="" id="entry" placeholder="Entry" maxLength="255">
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


<!--- ADD TRUSTED HOSTS MODAL HTML STARTS HERE --->

<div class="modal fade" id="addhost_modal" tabindex="-1" role="dialog" aria-labelledby="AddHostModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add Trusted Host(s) </h4>
</div>
  
<div class="modal-body">

  <form name="AddDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Add Trusted Hosts">



      <div class="form-group">
        <label>Trusted Host(s)</label>
        <div class="textareacontainer">
    <textarea name="host" placeholder="Enter trusted host(s) (IPs, Network Address(es), FQDNs) each in its own line" wrap="physical" rows="10"></textarea>
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
<!--- ADD TRUSTED HOSTS MODAL HTML ENDS HERE --->

  

         

<cfif #action# is "DKIM Settings">

  <cfif NOT StructKeyExists(form, "dkimenabled")>

    <cfset m="DKIM Settings: form.dkimenabled does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "dkimenabled")>

    <cfif #form.dkimenabled# is "1">
      
      <cfset step=1>

    <cfelseif #form.dkimenabled# is "2">

      <cfset step=10>   

<cfelse>   

  <cfset m="DKIM Settings: form.dkimenabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF #form.dkimenabled# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "dkimenabled") --->
</cfif>



<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "body_canonicalization")>

    <cfset m="DKIM Settings: form.body_canonicalization does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



<cfelseif StructKeyExists(form, "body_canonicalization")>
      

<cfif #form.body_canonicalization# is "relaxed" OR #form.body_canonicalization# is "simple">      

  <cfset step=2>
    
    <cfelse>
    

      <cfset m="DKIM Settings: form.body_canonicalization is not relaxed or simple">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<!--- /CFIF #form.body_canonicalization# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "body_canonicalization") --->
</cfif>


<!--- /CFIF #step# is "1" --->  
</cfif>



<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "headers_canonicalization")>

    <cfset m="DKIM Settings: form.headers_canonicalization does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



    <cfelseif StructKeyExists(form, "headers_canonicalization")>


<cfif #form.headers_canonicalization# is "relaxed" OR #form.headers_canonicalization# is "simple">      

  <cfset step=3>
    
    <cfelse>
    

      <cfset m="DKIM Settings: form.headers_canonicalization is not relaxed or simple">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

<!--- /CFIF #form.headers_canonicalization# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "headers_canonicalization") --->
</cfif>


<!--- /CFIF #step# is "2" --->  
</cfif>



<cfif #step# is "3">

  <cfif NOT StructKeyExists(form, "default_action")>

    <cfset m="DKIM Settings: form.default_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "default_action")>


<cfif #form.default_action# is "accept" OR #form.default_action# is "discard" OR #form.default_action# is "reject" OR #form.default_action# is "tempfail" OR #form.default_action# is "quarantine">      

  <cfset step=4>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.default_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.default_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "default_action") --->
</cfif>

<!--- /CFIF #step# is "3" --->  
</cfif>


<cfif #step# is "4">

  <cfif NOT StructKeyExists(form, "badsignature_action")>

    <cfset m="DKIM Settings: form.badsignature_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "badsignature_action")>


<cfif #form.badsignature_action# is "accept" OR #form.badsignature_action# is "discard" OR #form.badsignature_action# is "reject" OR #form.badsignature_action# is "tempfail" OR #form.badsignature_action# is "quarantine">      

  <cfset step=5>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.badsignature_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.badsignature_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "badsignature_action") --->
</cfif>

<!--- /CFIF #step# is "4" --->  
</cfif>


<cfif #step# is "5">

  <cfif NOT StructKeyExists(form, "dnserror_action")>

    <cfset m="DKIM Settings: form.dnserror_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "dnserror_action")>


<cfif #form.dnserror_action# is "accept" OR #form.dnserror_action# is "discard" OR #form.dnserror_action# is "reject" OR #form.dnserror_action# is "tempfail" OR #form.dnserror_action# is "quarantine">      

  <cfset step=6>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.dnserror_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.dnserror_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "dnserror_action") --->
</cfif>

<!--- /CFIF #step# is "5" --->  
</cfif>


<cfif #step# is "6">

  <cfif NOT StructKeyExists(form, "internalerror_action")>

    <cfset m="DKIM Settings: form.internalerror_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "internalerror_action")>


<cfif #form.internalerror_action# is "accept" OR #form.internalerror_action# is "discard" OR #form.internalerror_action# is "reject" OR #form.internalerror_action# is "tempfail" OR #form.internalerror_action# is "quarantine">      

  <cfset step=7>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.internalerror_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.internalerror_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "internalerror_action") --->
</cfif>

<!--- /CFIF #step# is "6" --->  
</cfif>


<cfif #step# is "7">

  <cfif NOT StructKeyExists(form, "nosignature_action")>

    <cfset m="DKIM Settings: form.nosignature_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "nosignature_action")>


<cfif #form.nosignature_action# is "accept" OR #form.nosignature_action# is "discard" OR #form.nosignature_action# is "reject" OR #form.nosignature_action# is "tempfail" OR #form.nosignature_action# is "quarantine">      

  <cfset step=8>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.nosignature_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.nosignature_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "nosignature_action") --->
</cfif>

<!--- /CFIF #step# is "7" --->  
</cfif>


<cfif #step# is "8">

  <cfif NOT StructKeyExists(form, "security_action")>

    <cfset m="DKIM Settings: form.security_action does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "security_action")>


<cfif #form.security_action# is "accept" OR #form.security_action# is "discard" OR #form.security_action# is "reject" OR #form.security_action# is "tempfail" OR #form.security_action# is "quarantine">      

  <cfset step=9>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.security_action is not accept, discard, reject tempfail or quarantine">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.security_action# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "security_action") --->
</cfif>

<!--- /CFIF #step# is "8" --->  
</cfif>


<cfif #step# is "9">

  <cfif NOT StructKeyExists(form, "signature_algorithm")>

    <cfset m="DKIM Settings: form.signature_algorithm does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "signature_algorithm")>


<cfif #form.signature_algorithm# is "rsa-sha256" OR #form.signature_algorithm# is "rsa-sha1">      

  <cfset step=10>

    
    <cfelse>  

      <cfset m="DKIM Settings: form.signature_algorithm is not rsa-sha256 or rsa-sha1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.signature_algorithm# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "signature_algorithm") --->
</cfif>

<!--- /CFIF #step# is "9" --->  
</cfif>





<cfif #step# is "10">


<cfinclude template="./inc/dkim_set_settings.cfm">

<cfinclude template="./inc/generate_postfix_configuration.cfm">

<cfinclude template="./inc/restart_postfix.cfm">

<cfset session.m=9>

<cflocation url="view_dkim_settings.cfm" addtoken="no">


<!--- /CFIF #step# is "10" --->
</cfif>


<cfelseif #action# is "Delete Entry">


  <cfif NOT StructKeyExists(form, "delete_id")>

    <cfset session.m = 11>

  <cflocation url="view_dkim_settings.cfm" addtoken="no">


    <cfelseif StructKeyExists(form, "delete_id")>

    <cfif #form.delete_id# is "">

      <cfset session.m = 11>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">
        

    <cfelseif #form.delete_id# is not "">      

<cfloop index="i" list="#form.delete_id#" delimiters=",">

  <cfoutput>#i#<br></cfoutput>


  <cfset theType = listGetAt(i, 2, "|")>

  <cfoutput>Type: #theType#</cfoutput>

  <cfset theId = listGetAt(i, 1, "|")>

  <cfoutput>ID: #theId#</cfoutput>


<cfif #theType# is "host">

  <cfquery name="gethost" datasource="hermes">
  select id, host from dkim_trusted_hosts where id = <cfqueryparam value = #theId# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

  <cfif #gethost.recordcount# GTE 1>

    <cfset delete_id = #theId#>

    <cfinclude template="./inc/dkim_delete_host.cfm">
  

    <!--- /CFIF #gethost.recordcount# --->
  </cfif>

  <cfelseif #theType# is "domain">

    
  <cfquery name="getdomain" datasource="hermes">
    select id, entry from dkim_bypass where id = <cfqueryparam value = #theId# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  
    <cfif #getdomain.recordcount# GTE 1>
  
      <cfset delete_id = #theId#>
  
      <cfinclude template="./inc/dkim_delete_domain.cfm">
     
      <!--- /CFIF #gethost.recordcount# --->
    </cfif>

  <cfelse>      
    
    <cfset m="DKIM Delete Entry: theType is not host or domain">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


  <!--- /CFIF #theType# is "" --->
  </cfif>

  
  </cfloop>


  <cfset session.m = 12>

  <cfinclude template="./inc/dkim_generate_hosts.cfm">
  <cfinclude template="./inc/dkim_generate_domains.cfm">
  <cfinclude template="./inc/restart_opendkim.cfm">
  <cfinclude template="./inc/restart_opendmarc.cfm">

<cflocation url="view_dkim_settings.cfm" addtoken="no">


<!--- /CFIF #form.delete_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "delete_id") --->
</cfif>

<cfelseif #action# is "Add Domain">

  <cfif NOT StructKeyExists(form, "domain")>
    
    
    <cfset m="DKIM Settings Add Domain: form.domain does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "domain")>

    <cfif #form.domain# is "">

      <cfset session.m = 13>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

    <cfelse>
  
  <cfset step=1> 

    <!--- /CFIF #form.domain# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "domain") --->
  </cfif>


<cfif #step# is "1">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DKIM Settings Add Domain: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=2> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "1" --->
    </cfif>


        
  <cfif #step# is "2">

  <cfinclude template="./inc/dkim_add_domains.cfm">


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dkim_generate_domains.cfm">
<cfinclude template="./inc/restart_opendkim.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cflocation url="view_dkim_settings.cfm" addtoken="no">


<cfelseif #action# is "Add Trusted Hosts">

  <cfif NOT StructKeyExists(form, "host")>
    
    
    <cfset m="DKIM Settings Add Trusted Host: form.host does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "host")>

    <cfif #form.host# is "">

      <cfset session.m = 13>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

    <cfelse>
  
  <cfset step=1> 

    <!--- /CFIF #form.host# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "host") --->
  </cfif>


<cfif #step# is "1">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DKIM Settings Add Domain: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=2> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "1" --->
    </cfif>


        
  <cfif #step# is "2">

  <cfinclude template="./inc/dkim_add_hosts.cfm">


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dkim_generate_hosts.cfm">
<cfinclude template="./inc/restart_opendkim.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cflocation url="view_dkim_settings.cfm" addtoken="no">



<cfelseif #action# is "Edit Domain">


  <cfif NOT StructKeyExists(form, "id")>
    
    
    <cfset m="DKIM Settings Edit Domain: form.id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "id")>

    <cfif #form.id# is "">

      <cfset m="DKIM Settings Edit Domain: form.id is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<cfelseif #form.id# is not "">

<cfif isValid("integer", form.id)>

<cfquery name="getdomain" datasource="hermes">
select id, entry from dkim_bypass where id = <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER"> 
</cfquery>

<cfif #getdomain.recordcount# GTE 1>
  
<cfset step=1> 

<cfelseif #getdomain.recordcount# LT 1>

  <cfset m="DKIM Settings Edit Domain: getdomain.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getdomain.recordcount# --->  
</cfif>

<cfelseif NOT isValid("integer", form.id)>

  <cfset m="DKIM Settings Edit Domain: form.id is not valid integer">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>

    <!--- /CFIF #form.id# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "id") --->
  </cfif>


  <cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "entry")>
    
    
    <cfset m="DKIM Settings Add Domain: form.entry does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  

  <cfelseif StructKeyExists(form, "entry")>

    <cfif #form.entry# is "">

      <cfset session.m = 16>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

    <cfelseif #form.entry# is not "">

  
      <!--- CHECK IF VALID DOMAIN --->
      <cfset tempemail="bob@#form.entry#">
    
      <cfif IsValid("email", tempemail)>
  
  <cfset step=2> 

  <cfelseif NOT IsValid("email", tempemail)>

    <cfset session.m = 17>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

<!--- IsValid("email", tempemail) --->
  </cfif>


    <!--- /CFIF #form.entry# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "entry") --->
  </cfif>

  <!--- /CFIF for step "1" --->
</cfif>






<cfif #step# is "2">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DKIM Settings Add Domain: form.note does not exist">
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
  select id, domain from dmarc_domains where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entry#"> and id <> <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER">  
  </cfquery>

<cfif #checkexists.recordcount# GTE 1>

  
<cfset session.m=14>

<cflocation url="view_dkim_settings.cfm" addtoken="no">

<cfelse>

<cfinclude template="./inc/dkim_edit_domain.cfm">

<!--- /CFIF #checkexists.recordcount# --->
</cfif>


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dkim_generate_domains.cfm">
<cfinclude template="./inc/restart_opendkim.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cfset session.m=15>

<cflocation url="view_dkim_settings.cfm" addtoken="no">




<cfelseif #action# is "Edit Host">

  <!--- VALIDATE IP CIDR REGEX --->
  <cfset network_cidr = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$">
  <cfset ip_cidr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

  <cfif NOT StructKeyExists(form, "id")>
    
    
    <cfset m="DKIM Settings Edit Host: form.id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "id")>

    <cfif #form.id# is "">

      <cfset m="DKIM Settings Edit Host: form.id is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<cfelseif #form.id# is not "">

<cfif isValid("integer", form.id)>

<cfquery name="gethost" datasource="hermes">
select id, host from dkim_trusted_hosts where id = <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER"> 
</cfquery>

<cfif #gethost.recordcount# GTE 1>
  
<cfset step=1> 

<cfelseif #gethost.recordcount# LT 1>

  <cfset m="DKIM Settings Edit Host: gethost.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #gethost.recordcount# --->  
</cfif>

<cfelseif NOT isValid("integer", form.id)>

  <cfset m="DKIM Settings Edit Host: form.id is not valid integer">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>

    <!--- /CFIF #form.id# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "id") --->
  </cfif>


  <cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "entry")>
    
    
    <cfset m="DKIM Settings Edit Host: form.entry does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  

  <cfelseif StructKeyExists(form, "entry")>

    <cfif #form.entry# is "">

      <cfset session.m = 16>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

    <cfelseif #form.entry# is not "">

  
      <!--- CHECK IF VALID DOMAIN --->
      <cfset tempemail="bob@#form.entry#">
    
      <cfif IsValid("email", tempemail) OR REFind(ip_cidr,form.entry) GT 0 OR REFind(network_cidr,form.entry) GT 0>
  
  <cfset step=2> 

  <cfelse>

    <cfset session.m = 17>

    <cflocation url="view_dkim_settings.cfm" addtoken="no">

<!--- IsValid("email", tempemail) OR REFind(ip_cidr,form.entry) GT 0 --->
  </cfif>


    <!--- /CFIF #form.entry# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "entry) --->
  </cfif>

  <!--- /CFIF for step "1" --->
</cfif>






<cfif #step# is "2">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="DKIM Settings Edit Host: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=3> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "2" --->
    </cfif>


        
  <cfif #step# is "3">

<!--- CHECK IF HOST EXISTS --->

<cfquery name="checkexists" datasource="hermes">
  select id, host from dkim_trusted_hosts where host = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entry#"> and id <> <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER">  
  </cfquery>

<cfif #checkexists.recordcount# GTE 1>

  
<cfset session.m=14>

<cflocation url="view_dkim_settings.cfm" addtoken="no">

<cfelse>

<cfinclude template="./inc/dkim_edit_host.cfm">

<!--- /CFIF #checkexists.recordcount# --->
</cfif>


<!--- CFIF #step# is "2" --->
</cfif>


<cfinclude template="./inc/dkim_generate_hosts.cfm">
<cfinclude template="./inc/restart_opendkim.cfm">
<cfinclude template="./inc/restart_opendmarc.cfm">

<cfset session.m=15>

<cflocation url="view_dkim_settings.cfm" addtoken="no">

    
<!--- /CFIF #action# is --->     
</cfif> 


<form>

  <!--- ENABLE FOR DEBUG BELOW --->
<!---
customtrans: <cfoutput>#customtrans3#</cfoutput>  
--->   
    <cfif #getdkimtrusted.recordcount# GTE 1 OR #getdkimbypass.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>Edit</th>    
      <th>Entry</th>
    
      <th>Type</th>

      <th>Note</th>
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getdkimtrusted">


  <td><input type="checkbox" name="id" value="#id#|host"></td>

  <td>

    <button a href="##editentry_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-entry="#host#" data-note="#note#" data-action="Edit Host"><i class="fas fa-edit"></i></button>

  </td>

  



<td>#host#</td>  

<td>TRUSTED HOST</td>

<td>#note#</td>



</tr>

</cfoutput>



<cfoutput query="getdkimbypass">


  <td><input type="checkbox" name="id" value="#id#|domain"></td>

  <td>

    <button a href="##editentry_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-entry="#entry#" data-note="#note#" data-action="Edit Domain"><i class="fas fa-edit"></i></button>

  </td>

  
    



<td>#entry#</td>  

<td>WHITELISTED DOMAIN</td>

<td>#note#</td>





    
          </tr>

        </cfoutput>
    

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>Edit</th>    
      <th>Entry</th>

      <th>Type</th>

      <th>Note</th>
           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelse>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Whitelisted Domain(s) or Trusted Host(s) entries were found</strong></cfoutput>
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

  $('#dkimenabled').on('change',function(){
    if( $(this).val()==="2"){
    $("#dkimsettings").hide()
    }
    else{
    $("#dkimsettings").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE DMARC SETTINGS SCRIPT ENDS HERE  --->



<!--- EDIT DOMAIN MODAL SCRIPT STARTS HERE  --->
<script>
  $('#editentry_modal').on('show.bs.modal', function(e) {
var id = $(e.relatedTarget).data('id');
$(e.currentTarget).find('input[name="id"]').val(id);

var entry = $(e.relatedTarget).data('entry');
$(e.currentTarget).find('input[name="entry"]').val(entry);

var note = $(e.relatedTarget).data('note');
$(e.currentTarget).find('input[name="note"]').val(note);

var action = $(e.relatedTarget).data('action');
$(e.currentTarget).find('input[name="action"]').val(action);


  });


    </script>

<!--- EDIT DOMAIN MODAL SCRIPT ENDS HERE  --->

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

</html>