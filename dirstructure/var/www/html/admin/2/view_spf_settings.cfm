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
  <title>Hermes SEG | SPF Settings</title>

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
            <h1 class="m-0">SPF Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">SPF Settings</li>
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
    <cfinclude template="./inc/get_spf_settings.cfm" />

    <cfquery name="getspfbypass" datasource="hermes">
      select id, entry_note, entry_type, entry from spf_bypass
      </cfquery>

    
   

      <cfif #m# is "9">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>SPF Settings were saved successfully </cfoutput><br> 
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
          <cfoutput>The Entry field cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "14">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Entry field in the entry you are attempting to edit already exists</cfoutput>
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
          <cfoutput>The Entry field in the entry you are attempting to edit cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>


      
      <cfif #m# is "17">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Entry field in the entry you are attempting to edit is not a valid</cfoutput>
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


<!--- ADD SPF WHITELIST BUTTON STARTS HERE --->
<cfoutput>
  <a href="##addwhitelist_modal"  class="btn btn-primary" role="button" data-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add SPF Whitelist Entries</a>
  </cfoutput>
  <!--- ADD SPF WHITELIST BUTTON ENDS HERE --->
&nbsp;&nbsp;



      <button type="button" id="deletedomains" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>
      &nbsp;&nbsp;


</p>
</span>

<div class="card col-sm-8">
  
  <!---
  <div class="card-header border-1">

    <h3 class="card-title"><strong>SPF Settings Settings</strong></h3>

  <!--- class="card-header border-1" --->
</div>
--->

<form name="spfsettings" method="post">

  <input type="hidden" name="action" value="SPF Settings">
<div>&nbsp;</div>

<div class="alert alert-warning">
             
  <p><i class="icon fas fa-exclamation-triangle"></i>Disabling <strong>SPF</strong> will also disable <strong>DMARC</strong></p>
  </div>

  <div class="col-sm-8">
    <div class="form-group">
  



             <label><strong>SPF Enabled</strong></label>

        
               
             <select class="form-control" name="spfenabled" style="width: 100%;" id="spfenabled">
 
       <cfif #spfenabled# is "1">
         
                 <option value="1" selected>YES</option>
                 <option value="2">NO</option>
          
 
             <cfelseif #spfenabled# is "2">
 
               <option value="2" selected>NO</option>
               <option value="1">YES</option>
 
               <!--- /CFIF cfif #spfenabled# is --->
             </cfif>
            
                 </select>   
 
     
             
             <!-- class="form-group" -->  
             </div>

            <!--  class="col-sm-6" -->
            </div>


  
    <cfif #spfenabled# is "2">

      <div class="form-group" id="spfsettings" style="display:none;">

        <div class="col-sm-8">

            <label><strong>Logging Level</strong></label>
              
            <select class="form-control" name="debuglevel" style="width: 100%;" id="debuglevel">

      <cfif #debuglevel# is "1">
        
                <option value="1" selected>Level 1 (Default. Logs only basic policy results and errors.)</option>
                <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
                <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
                <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
                <option value="0">Level 0 (Logs only errors)</option>
                <option value="-1">Disabled (No Logs are generated. Not recommended)</option>
         

            <cfelseif #debuglevel# is "2">

              <option value="2" selected>Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>

              <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
           
              <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
              <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
              <option value="0">Level 0 (Logs only errors)</option>
              <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

            <cfelseif #debuglevel# is "3">

              <option value="3" selected>Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>

              <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
              <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
              <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
              <option value="0">Level 0 (Logs only errors)</option>
              <option value="-1">Disabled (No Logs are generated. Not recommended)</option>


            <cfelseif #debuglevel# is "4">

              <option value="4" selected>Level 4 (Logs the complete data set received by SMTP server)</option>
              

              <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
              <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
              <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
              <option value="0">Level 0 (Logs only errors)</option>
              <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

            <cfelseif #debuglevel# is "0">

              <option value="0" selected>Level 0 (Logs only errors)</option>
              <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
              <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
              <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
              <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
              <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

              
            <cfelseif #debuglevel# is "-1">
              <option value="-1" selected>Disabled (No Logs are generated. Not recommended)</option>

        
              <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
              <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
              <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
              <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
              <option value="0">Level 0 (Logs only errors)</option>


              <!--- /CFIF cfif #debuglevel# is --->
            </cfif>
           
                </select>   

                <label><strong>Test Mode</strong></label>
              
                <select class="form-control" name="testonly" style="width: 100%;" id="testonly">
    
          <cfif #testonly# is "1">
            
                    <option value="1" selected>Enabled (Run SPF server in test mode and do NOT reject e-mail)</option>
                    <option value="2">Disabled (Recommended. Run SPF server normal operation)</option>
             
    
                <cfelseif #testonly# is "2">
            
                  <option value="2" selected>Disabled (Recommended. Run SPF server normal operation)</option>
                  <option value="1">Enabled (Run SPF server in test mode and do NOT reject e-mail)</option>
                 
              
    
                  <!--- /CFIF cfif #testonly# is --->
                </cfif>
               
                    </select>   
    

                    <label><strong>HELO Check Rejection Policy</strong></label>
              
                    <select class="form-control" name="helo_reject" style="width: 100%;" id="helo_reject">
        
              <cfif #helo_reject# is "Fail">
                
                        <option value="Fail" selected>Reject HELO Fail (Default. Reject only on HELO Fail)</option>
                        <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                        <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                        <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                        <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                        <option value="No_Check">Disable Check (Do NOT Check HELO)</option>
                 
        
                    <cfelseif #helo_reject# is "SPF_Not_Pass">
                
                      <option value="SPF_Not_Pass" selected>Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                      <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>
                    
                      <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                      <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT r)</option>
                      <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                      <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


                    <cfelseif #helo_reject# is "Softfail">
                
                      <option value="Softfail" selected>Reject SoftFail (Reject if result is Softfail or Fail)</option>
                   
                      <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>
                    
                      <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>

                      <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                      <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                      <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


                    <cfelseif #helo_reject# is "Null">

                      <option value="Null" selected>Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                      <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                      <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>

                      <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                   
                  

                      <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>

                      <option value="No_Check">Disable Check (Do NOT Check HELO)</option>

                      
                    <cfelseif #helo_reject# is "False">

                      <option value="False" selected>Append Only (Do NOT Reject, append SPF header only)</option>

                      <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                      <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                
                      <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                      
                      <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
            
                      <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


                    <cfelseif #helo_reject# is "No_Check">

                      <option value="No_Check" selected>Disable Check (Do NOT Check HELO)</option>

                      <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                      <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                
                      <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>

                      <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                      
                    <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                      
               
            
                  
             
                  
        
                      <!--- /CFIF cfif #helo_reject# is --->
                    </cfif>
                   
                        </select>   

                        <label><strong>Mail From Check Rejection Policy</strong></label>
              
                        <select class="form-control" name="mail_from_reject" style="width: 100%;" id="mail_from_reject">
            
                  <cfif #mail_from_reject# is "Fail">
                    
                            <option value="Fail" selected>Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                            <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                            <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>

                            <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                            <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>
                     
            
                        <cfelseif #mail_from_reject# is "SPF_Not_Pass">
                    
                          <option value="SPF_Not_Pass" selected>Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                          <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                        
                          <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>

                          <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                          <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>
    
    
                        <cfelseif #mail_from_reject# is "Softfail">
                    
                          <option value="Softfail" selected>Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>
                       
                          <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                        
                          <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
    
           
                          <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                          <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>
    
    
        
                          
                        <cfelseif #mail_from_reject# is "False">
    
                          <option value="False" selected>Append Only (Do NOT Reject, append SPF header only)</option>
    
                          <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
    
                          <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                    
                          <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>
                          

                
                          <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>
    
    
                        <cfelseif #mail_from_reject# is "No_Check">
    
                          <option value="No_Check" selected>Disable Check (Do NOT Check Mail From)</option>
    
                          <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
    
                          <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                    
                          <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>
    
                                      
                        <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                          
                  
            
                          <!--- /CFIF cfif #mail_from_reject# is --->
                        </cfif>
                       
                            </select>   
    

                            <label><strong>Permanent Error Policy</strong></label>
              
                            <select class="form-control" name="permerror_reject" style="width: 100%;" id="permerror_reject">
                
                      <cfif #permerror_reject# is "False">
                        
                                <option value="False" selected>False (Recommended. Treat PermError the same as no SPF record at all)</option>
                                <option value="True">True (Reject mail if HELO Check or Mail From Check is PermError)</option>
        
                         
                
                            <cfelseif #permerror_reject# is "True">
                        
                              <option value="True" selected>True (Reject mail if HELO Check or Mail From Check is PermError)</option>
                              <option value="False">False (Recommended. Treat PermError the same as no SPF record at all)</option>
                           
        
                           
                              <!--- /CFIF permerror_reject is --->
                            </cfif>
                           
                                </select>   


        
                                <label><strong>Temporary Error Policy</strong></label>
              
                                <select class="form-control" name="temperror_defer" style="width: 100%;" id="temperror_defer">
                    
                          <cfif #temperror_defer# is "False">
                            
                                    <option value="False" selected>False (Recommended. Treat TempError the same as no SPF record at all)</option>
                                    <option value="True">True (Defer mail if HELO Check or Mail From Check is TempError)</option>
            
                             
                    
                                <cfelseif #temperror_defer# is "True">
                            
                                  <option value="True" selected>True (Defer mail if HELO Check or Mail From Check is TempError)</option>
                                  <option value="False">False (Recommended. Treat TempError the same as no SPF record at all)</option>
                               
            
                               
                                  <!--- /CFIF temperror_defer is --->
                                </cfif>
                               
                                    </select>   
            

      <!---  class="col-sm-6" --->
      </div>

        <!--- class="form-group" class="form-group" id="spfsettings"  --->  
          </div>
           
          
<cfelse>
          
  <div class="form-group" id="spfsettings">

    <div class="col-sm-8">

      <label><strong>Logging Level</strong></label>
        
      <select class="form-control" name="debuglevel" style="width: 100%;" id="debuglevel">

<cfif #debuglevel# is "1">
  
          <option value="1" selected>Level 1 (Default. Logs only basic policy results and errors.)</option>
          <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
          <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
          <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
          <option value="0">Level 0 (Logs only errors)</option>
          <option value="-1">Disabled (No Logs are generated. Not recommended)</option>
   

      <cfelseif #debuglevel# is "2">

        <option value="2" selected>Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>

        <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
     
        <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
        <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
        <option value="0">Level 0 (Logs only errors)</option>
        <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

      <cfelseif #debuglevel# is "3">

        <option value="3" selected>Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>

        <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
        <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
        <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
        <option value="0">Level 0 (Logs only errors)</option>
        <option value="-1">Disabled (No Logs are generated. Not recommended)</option>


      <cfelseif #debuglevel# is "4">

        <option value="4" selected>Level 4 (Logs the complete data set received by SMTP server)</option>
        

        <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
        <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
        <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
        <option value="0">Level 0 (Logs only errors)</option>
        <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

      <cfelseif #debuglevel# is "0">

        <option value="0" selected>Level 0 (Logs only errors)</option>
        <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
        <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
        <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
        <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
        <option value="-1">Disabled (No Logs are generated. Not recommended)</option>

        
      <cfelseif #debuglevel# is "-1">
        <option value="-1" selected>Disabled (No Logs are generated. Not recommended)</option>

  
        <option value="1">Level 1 (Default. Logs only basic policy results and errors.)</option>
        <option value="2">Level 2 (Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</option>
        <option value="3">Level 3 (Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</option>
        <option value="4">Level 4 (Logs the complete data set received by SMTP server)</option>
        <option value="0">Level 0 (Logs only errors)</option>


        <!--- /CFIF cfif #debuglevel# is --->
      </cfif>
     
          </select>   

          <label><strong>Test Mode</strong></label>
        
          <select class="form-control" name="testonly" style="width: 100%;" id="testonly">

    <cfif #testonly# is "1">
      
              <option value="1" selected>Enabled (Run SPF server in test mode and do NOT reject e-mail)</option>
              <option value="2">Disabled (Recommended. Run SPF server normal operation)</option>
       

          <cfelseif #testonly# is "2">
      
            <option value="2" selected>Disabled (Recommended. Run SPF server normal operation)</option>
            <option value="1">Enabled (Run SPF server in test mode and do NOT reject e-mail)</option>
           
        

            <!--- /CFIF cfif #testonly# is --->
          </cfif>
         
              </select>   


              <label><strong>HELO Check Rejection Policy</strong></label>
        
              <select class="form-control" name="helo_reject" style="width: 100%;" id="helo_reject">
  
        <cfif #helo_reject# is "Fail">
          
                  <option value="Fail" selected>Reject HELO Fail (Default. Reject only on HELO Fail)</option>
                  <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                  <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                  <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                  <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                  <option value="No_Check">Disable Check (Do NOT Check HELO)</option>
           
  
              <cfelseif #helo_reject# is "SPF_Not_Pass">
          
                <option value="SPF_Not_Pass" selected>Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
                <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>
              
                <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT r)</option>
                <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


              <cfelseif #helo_reject# is "Softfail">
          
                <option value="Softfail" selected>Reject SoftFail (Reject if result is Softfail or Fail)</option>
             
                <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>
              
                <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>

                <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


              <cfelseif #helo_reject# is "Null">

                <option value="Null" selected>Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>

                <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
             
            

                <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>

                <option value="No_Check">Disable Check (Do NOT Check HELO)</option>

                
              <cfelseif #helo_reject# is "False">

                <option value="False" selected>Append Only (Do NOT Reject, append SPF header only)</option>

                <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
          
                <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>
                
                <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
      
                <option value="No_Check">Disable Check (Do NOT Check HELO)</option>


              <cfelseif #helo_reject# is "No_Check">

                <option value="No_Check" selected>Disable Check (Do NOT Check HELO)</option>

                <option value="Fail">Reject HELO Fail (Default. Reject only on HELO Fail)</option>

                <option value="SPF_Not_Pass">Reject All (Reject if result is Fail, Softfail, Neutral or PermError)</option>
          
                <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail)</option>

                <option value="Null">Reject Null (Reject if HELO for Null Sender. NOT Recommended)</option>
                
              <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                
         
      
            
       
            
  
                <!--- /CFIF cfif #helo_reject# is --->
              </cfif>
             
                  </select>   

                  <label><strong>Mail From Check Rejection Policy</strong></label>
        
                  <select class="form-control" name="mail_from_reject" style="width: 100%;" id="mail_from_reject">
      
            <cfif #mail_from_reject# is "Fail">
              
                      <option value="Fail" selected>Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                      <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                      <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>

                      <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                      <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>
               
      
                  <cfelseif #mail_from_reject# is "SPF_Not_Pass">
              
                    <option value="SPF_Not_Pass" selected>Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
                    <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                  
                    <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>

                    <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                    <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>


                  <cfelseif #mail_from_reject# is "Softfail">
              
                    <option value="Softfail" selected>Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>
                 
                    <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                  
                    <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>

     
                    <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                    <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>


  
                    
                  <cfelseif #mail_from_reject# is "False">

                    <option value="False" selected>Append Only (Do NOT Reject, append SPF header only)</option>

                    <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>

                    <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
              
                    <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>
                    

          
                    <option value="No_Check">Disable Check (Do NOT Check Mail From)</option>


                  <cfelseif #mail_from_reject# is "No_Check">

                    <option value="No_Check" selected>Disable Check (Do NOT Check Mail From)</option>

                    <option value="Fail">Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>

                    <option value="SPF_Not_Pass">Reject All (Reject if result is Pass/None/Tempfail. NOT Recommended)</option>
              
                    <option value="Softfail">Reject SoftFail (Reject if result is Softfail or Fail. NOT Recommended)</option>

                                
                  <option value="False">Append Only (Do NOT Reject, append SPF header only)</option>
                    
            
      
                    <!--- /CFIF cfif #mail_from_reject# is --->
                  </cfif>
                 
                      </select>   


                      <label><strong>Permanent Error Policy</strong></label>
        
                      <select class="form-control" name="permerror_reject" style="width: 100%;" id="permerror_reject">
          
                <cfif #permerror_reject# is "False">
                  
                          <option value="False" selected>False (Recommended. Treat PermError the same as no SPF record at all)</option>
                          <option value="True">True (Reject mail if HELO Check or Mail From Check is PermError)</option>
  
                   
          
                      <cfelseif #permerror_reject# is "True">
                  
                        <option value="True" selected>True (Reject mail if HELO Check or Mail From Check is PermError)</option>
                        <option value="False">False (Recommended. Treat PermError the same as no SPF record at all)</option>
                     
  
                     
                        <!--- /CFIF permerror_reject is --->
                      </cfif>
                     
                          </select>   


  
                          <label><strong>Temporary Error Policy</strong></label>
        
                          <select class="form-control" name="temperror_defer" style="width: 100%;" id="temperror_defer">
              
                    <cfif #temperror_defer# is "False">
                      
                              <option value="False" selected>False (Recommended. Treat TempError the same as no SPF record at all)</option>
                              <option value="True">True (Defer mail if HELO Check or Mail From Check is TempError)</option>
      
                       
              
                          <cfelseif #temperror_defer# is "True">
                      
                            <option value="True" selected>True (Defer mail if HELO Check or Mail From Check is TempError)</option>
                            <option value="False">False (Recommended. Treat TempError the same as no SPF record at all)</option>
                         
      
                         
                            <!--- /CFIF temperror_defer is --->
                          </cfif>
                         
                              </select>   
      

<!---  class="col-sm-6" --->
</div>

    <!--- class="form-group" class="form-group" id="spfsettings"  --->  
      </div>
       

              <!--- /CFIF #spfenabled# is --->
            </cfif>
          

  
  
  <div class="col-sm-6">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  <!--- div class="col-sm-6" --->
  </div>
    
  </form>  
  
<br>

  <!--- div class="card"  --->  
</div>



<!--- DELETE ENTRY MODAL HTML STARTS HERE --->
   

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
<!--- DELETE ENTRY MODAL HTML ENDS HERE --->


<!--- EDIT ENTRY MODAL HTML STARTS HERE --->

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
    <input type="hidden" name="type" value=""/>

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
<!--- EDIT ENTRY MODAL HTML ENDS HERE --->



<!--- ADD SPF WHITELIST MODAL HTML STARTS HERE --->

<div class="modal fade" id="addwhitelist_modal" tabindex="-1" role="dialog" aria-labelledby="AddHostModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add SPF Whitelist Entries </h4>
</div>
  
<div class="modal-body">

  <form name="AddWhitelist" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Add SPF Whitelist">

    <label><strong>Entry Type</strong></label>

        
               
    <select class="form-control" name="entry_type" style="width: 100%;" id="entry_type">


        <option value="ip" selected>IP/Network Address</option>
        <option value="helo">HELO/EHLO Host Name</option>
        <option value="domain">Domain Name</option>
        <option value="ptr">PTR Domain</option>
    
        </select>   

      <div class="form-group">
        <label>Trusted Host(s)</label>
        <div class="textareacontainer">
    <textarea name="host" placeholder="Enter SPF Whitelist Entries each in its own line" wrap="physical" rows="10"></textarea>
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
<!--- ADD SPF WHITELIST MODAL HTML ENDS HERE --->

  

         

<cfif #action# is "SPF Settings">

  <cfif NOT StructKeyExists(form, "spfenabled")>

    <cfset m="SPF Settings: form.spfenabled does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "spfenabled")>

    <cfif #form.spfenabled# is "1">
      
      <cfset step=1>

    <cfelseif #form.spfenabled# is "2">

      <cfset step=7>   

<cfelse>   

  <cfset m="SPF Settings: form.spfenabled is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF #form.spfenabled# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "spfenabled") --->
</cfif>



<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "debuglevel")>

    <cfset m="SPF Settings: form.debuglevel does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



<cfelseif StructKeyExists(form, "debuglevel")>
      

<cfif #form.debuglevel# is "1" OR #form.debuglevel# is "2" OR #form.debuglevel# is "3" OR #form.debuglevel# is "4" OR #form.debuglevel# is "-1">      

  <cfset step=2>
    
    <cfelse>
    

      <cfset m="SPF Settings: form.debuglevel is not 1, 2, 3, 4 or -1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<!--- /CFIF #form.debuglevel# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "debuglevel") --->
</cfif>


<!--- /CFIF #step# is "1" --->  
</cfif>



<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "testonly")>

    <cfset m="SPF Settings: form.testonly does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



    <cfelseif StructKeyExists(form, "testonly")>


<cfif #form.testonly# is "1" OR #form.testonly# is "2">      

  <cfset step=3>
    
    <cfelse>
    

      <cfset m="SPF Settings: form.testonly is not 1 or 2">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

<!--- /CFIF #form.headers_canonictestonlyalization# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "testonly") --->
</cfif>


<!--- /CFIF #step# is "2" --->  
</cfif>



<cfif #step# is "3">

  <cfif NOT StructKeyExists(form, "helo_reject")>

    <cfset m="SPF Settings: form.helo_reject does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "helo_reject")>


<cfif #form.helo_reject# is "Fail" OR #form.helo_reject# is "SPF_Not_Pass" OR #form.helo_reject# is "Softfail" OR #form.helo_reject# is "Null" OR #form.helo_reject# is "False" OR #form.helo_reject# is "No_Check">      

  <cfset step=4>

    
    <cfelse>  

      <cfset m="SPF Settings: form.helo_reject is not Fail, SPF_Not_Pass, Softfail, Null False or No_Check">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.helo_reject# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "helo_reject") --->
</cfif>

<!--- /CFIF #step# is "3" --->  
</cfif>


<cfif #step# is "4">

  <cfif NOT StructKeyExists(form, "mail_from_reject")>

    <cfset m="SPF Settings: form.mail_from_reject does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "mail_from_reject")>


<cfif #form.mail_from_reject# is "Fail" OR #form.mail_from_reject# is "SPF_Not_Pass" OR #form.mail_from_reject# is "Softfail" OR #form.mail_from_reject# is "False" OR #form.mail_from_reject# is "No_Check">      

  <cfset step=5>

    
    <cfelse>  

      <cfset m="SPF Settings: form.mail_from_reject is not Fail, SPF_Not_Pass, Softfail, False or No_Check">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.mail_from_reject# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "mail_from_reject") --->
</cfif>

<!--- /CFIF #step# is "4" --->  
</cfif>


<cfif #step# is "5">

  <cfif NOT StructKeyExists(form, "permerror_reject")>

    <cfset m="SPF Settings: form.permerror_reject does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "permerror_reject")>


<cfif #form.permerror_reject# is "False" OR #form.permerror_reject# is "True">      

  <cfset step=6>

    
    <cfelse>  

      <cfset m="SPF Settings: form.permerror_reject is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.permerror_reject# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "permerror_reject") --->
</cfif>

<!--- /CFIF #step# is "5" --->  
</cfif>


<cfif #step# is "6">

  <cfif NOT StructKeyExists(form, "temperror_defer")>

    <cfset m="SPF Settings: form.temperror_defer does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "temperror_defer")>


<cfif #form.temperror_defer# is "False" OR #form.temperror_defer# is "True">      

  <cfset step=7>

    
    <cfelse>  

      <cfset m="SPF Settings: form.temperror_defer is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.temperror_defer# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "temperror_defer") --->
</cfif>

<!--- /CFIF #step# is "6" --->  
</cfif>



<cfif #step# is "7">


<cfinclude template="./inc/spf_set_settings.cfm">

<cfinclude template="./inc/generate_postfix_configuration.cfm">

<cfinclude template="./inc/restart_postfix.cfm">

<cfset session.m=9>

<cflocation url="view_spf_settings.cfm" addtoken="no">


<!--- /CFIF #step# is "7" --->
</cfif>


<cfelseif #action# is "Delete Entry">


  <cfif NOT StructKeyExists(form, "delete_id")>

    <cfset session.m = 11>

  <cflocation url="view_spf_settings.cfm" addtoken="no">


    <cfelseif StructKeyExists(form, "delete_id")>

    <cfif #form.delete_id# is "">

      <cfset session.m = 11>

    <cflocation url="view_spf_settings.cfm" addtoken="no">
        

    <cfelseif #form.delete_id# is not "">      

<cfloop index="i" list="#form.delete_id#" delimiters=",">

  <cfoutput>#i#<br></cfoutput>

  <cfquery name="getentry" datasource="hermes">
  select id from spf_bypass where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

  <cfif #getentry.recordcount# GTE 1>

    <cfset delete_id = #i#>

    <cfinclude template="./inc/spf_delete_host.cfm">
  

    <!--- /CFIF #getentry.recordcount# --->
  </cfif>

  
  </cfloop>


  <cfset session.m = 12>

  <cfinclude template="./inc/get_spf_settings.cfm">

  <!--- SET FORM VARIABLES TO BE USED IN SPF_GENERATE_CONFIG_FILE.CFM --->
  
  <cfset form.debuglevel = "#get_debugLevel.value2#">
  <cfset form.testonly = "#get_testonly.value2#">
  <cfset form.helo_reject = "#get_helo_reject.value2#">
  <cfset form.mail_from_reject = "#get_mail_from_reject.value2#">
  <cfset form.permerror_reject = "#get_permerror_reject.value2#">
  <cfset form.temperror_defer = "#get_temperror_defer.value2#">
  
  
  <cfinclude template="./inc/spf_generate_config_file.cfm">
  <cfinclude template="./inc/restart_postfix.cfm">
  
  <cflocation url="view_spf_settings.cfm" addtoken="no">  


<!--- /CFIF #form.delete_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "delete_id") --->
</cfif>


<cfelseif #action# is "Add SPF Whitelist">

  <cfif NOT StructKeyExists(form, "entry_type")>
    
    
    <cfset m="SPF Settings Add Whitelist Entries: form.entry_type does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "entry_type")>

    <cfif #form.entry_type# is "ip" OR #form.entry_type# is "helo" OR #form.entry_type# is "domain" OR #form.entry_type# is "ptr">

      <cfset step=1> 


    <cfelse>
  
      <cfset m="SPF Settings Add Whitelist Entries: form.entry_type is not ip, helo, domain or ptr">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <!--- /CFIF #form.entry_type# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "entry_type") --->
  </cfif>


<cfif #step# is "1">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="SPF Settings Add Whitelist Entries: form.note does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       
    
    <cfelseif StructKeyExists(form, "note")>
    
    <cfset step=2> 
    
    
    <!--- /CFIF StructKeyExists(form, "note") --->
    </cfif>

  <!--- CFIF #step# is "1" --->
    </cfif>

    <cfif #step# is "2">

      <cfif NOT StructKeyExists(form, "host")>
      
      
        <cfset m="SPF Settings Add Whitelist Entries: form.host does not exist">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
         
      
      <cfelseif StructKeyExists(form, "host")>

        <cfif #form.host# is not "">
      
      <cfset step=3> 

        <cfelseif #form.host# is "">

          
    <cfset session.m = 13>

    <cflocation url="view_spf_settings.cfm" addtoken="no">
      
    <!--- #form.host# is not "" --->
    </cfif>
      
      <!--- /CFIF StructKeyExists(form, "note") --->
      </cfif>
  
    <!--- CFIF #step# is "2" --->
      </cfif>



       
  <cfif #step# is "3">
    

  <cfinclude template="./inc/spf_add_hosts.cfm">

<!--- CFIF #step# is "3" --->
</cfif>

<cfinclude template="./inc/get_spf_settings.cfm">

<!--- SET FORM VARIABLES TO BE USED IN SPF_GENERATE_CONFIG_FILE.CFM --->

<cfset form.debuglevel = "#get_debugLevel.value2#">
<cfset form.testonly = "#get_testonly.value2#">
<cfset form.helo_reject = "#get_helo_reject.value2#">
<cfset form.mail_from_reject = "#get_mail_from_reject.value2#">
<cfset form.permerror_reject = "#get_permerror_reject.value2#">
<cfset form.temperror_defer = "#get_temperror_defer.value2#">


<cfinclude template="./inc/spf_generate_config_file.cfm">
<cfinclude template="./inc/restart_postfix.cfm">

<cflocation url="view_spf_settings.cfm" addtoken="no">




<cfelseif #action# is "Edit Entry">

  <!--- VALIDATE IP CIDR REGEX --->
  <cfset network_cidr = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$">
  <cfset ip_cidr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

  <cfif NOT StructKeyExists(form, "id")>
    
    
    <cfset m="SPF Settings Edit Entry: form.id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  
  
  <cfelseif StructKeyExists(form, "id")>

    <cfif #form.id# is "">

      <cfset m="SPF Settings Edit Entry: form.id is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<cfelseif #form.id# is not "">

<cfif isValid("integer", form.id)>

<cfquery name="getentry" datasource="hermes">
select id, entry from spf_bypass where id = <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER"> 
</cfquery>

<cfif #getentry.recordcount# GTE 1>
  
<cfset step=1> 

<cfelseif #getentry.recordcount# LT 1>

  <cfset m="SPF Settings Edit Entry: getentry.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getentry.recordcount# --->  
</cfif>

<cfelseif NOT isValid("integer", form.id)>

  <cfset m="SPF Settings Edit Entry: form.id is not valid integer">
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
    
    
    <cfset m="SPF Settings Edit Entry: form.entry does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  

  <cfelseif StructKeyExists(form, "entry")>

    <cfif #form.entry# is "">

      <cfset session.m = 16>

    <cflocation url="view_spf_settings.cfm" addtoken="no">

    <cfelseif #form.entry# is not "">

  
      <!--- CHECK IF VALID DOMAIN --->
      <cfset tempemail="bob@#form.entry#">
    
      <cfif IsValid("email", tempemail) OR REFind(ip_cidr,form.entry) GT 0 OR REFind(network_cidr,form.entry) GT 0>
  
  <cfset step=2> 

  <cfelse>

    <cfset session.m = 17>

    <cflocation url="view_spf_settings.cfm" addtoken="no">

<!--- IsValid("email", tempemail) OR REFind(ip_cidr,form.entry) GT 0 OR REFind(network_cidr,form.entry) GT 0 --->
  </cfif>


    <!--- /CFIF #form.entry# is "" --->
  </cfif>
  
  
  <!--- /CFIF StructKeyExists(form, "entry) --->
  </cfif>

  <!--- /CFIF for step "1" --->
</cfif>






<cfif #step# is "2">

    <cfif NOT StructKeyExists(form, "note")>
    
    
      <cfset m="SPF Settings Edit Entry: form.note does not exist">
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
  select id, entry from spf_bypass where entry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entry#"> and id <> <cfqueryparam value = #form.id# CFSQLType = "CF_SQL_INTEGER"> and entry_type =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">
  </cfquery>

<cfif #checkexists.recordcount# GTE 1>

  
<cfset session.m=14>

<cflocation url="view_spf_settings.cfm" addtoken="no">

<cfelse>

<cfinclude template="./inc/spf_edit_entry.cfm">

<!--- /CFIF #checkexists.recordcount# --->
</cfif>


<!--- CFIF #step# is "2" --->
</cfif>



<cfset session.m=15>

<cfinclude template="./inc/get_spf_settings.cfm">

<!--- SET FORM VARIABLES TO BE USED IN SPF_GENERATE_CONFIG_FILE.CFM --->

<cfset form.debuglevel = "#get_debugLevel.value2#">
<cfset form.testonly = "#get_testonly.value2#">
<cfset form.helo_reject = "#get_helo_reject.value2#">
<cfset form.mail_from_reject = "#get_mail_from_reject.value2#">
<cfset form.permerror_reject = "#get_permerror_reject.value2#">
<cfset form.temperror_defer = "#get_temperror_defer.value2#">


<cfinclude template="./inc/spf_generate_config_file.cfm">
<cfinclude template="./inc/restart_postfix.cfm">

<cflocation url="view_spf_settings.cfm" addtoken="no">

    
<!--- /CFIF #action# is --->     
</cfif> 


<form>

  <!--- ENABLE FOR DEBUG BELOW --->
<!---
customtrans: <cfoutput>#customtrans3#</cfoutput>  
--->   
    <cfif #getspfbypass.recordcount# GTE 1>

    
                
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

        

<cfoutput query="getspfbypass">


  <td><input type="checkbox" name="id" value="#id#"></td>

  <td>

    <button a href="##editentry_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-entry="#entry#" data-note="#entry_note#" data-action="Edit Entry" data-type="#entry_type#"><i class="fas fa-edit"></i></button>

  </td>

  



<td>#entry#</td>  

<cfif #entry_type# is "ip">
<td>IP/Network Address</td>

<cfelseif #entry_type# is "helo">
  <td>HELO/EHLO Host Name</td>

<cfelseif #entry_type# is "domain">
  <td>Domain Name</td>

<cfelseif #entry_type# is "ptr">
  <td>PTR Name</td>

<cfelse>
  <td>N/A</td>

<!--- /CFIF #entry_type# is --->
</cfif>
<td>#entry_note#</td>



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
        <cfoutput>No SPF Whitelist entries were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getspfbypass.recordcount --->
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

  $('#spfenabled').on('change',function(){
    if( $(this).val()==="2"){
    $("#spfsettings").hide()
    }
    else{
    $("#spfsettings").show()
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

var type = $(e.relatedTarget).data('type');
$(e.currentTarget).find('input[name="type"]').val(type);

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