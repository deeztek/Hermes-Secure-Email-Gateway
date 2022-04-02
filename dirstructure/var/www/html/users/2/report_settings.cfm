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
  <title>Hermes SEG | Report Settings</title>

  <cfinclude template="./inc/html_head.cfm" />


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
            <h1 class="m-0">Report Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Report Settings</li>
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

<cfif form.action is "setreports">

<cfset action = form.action>


<cfelse>


<cfset m="Report Settings: form.action is not setreports">
<cfinclude template="./inc/error.cfm">
<cfabort>



<!--- /CFIF for form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.action --->
</cfif>

<cfquery name="getreportsettings" datasource="hermes">
select id, report_frequency, report_enabled from user_settings where id like binary '#session.uid#'
</cfquery>

<cfparam name = "report_frequency" default = "#getreportsettings.report_frequency#">

<cfparam name = "report_enabled" default = "#getreportsettings.report_enabled#">

  
        <!--- ERROR MESSAGES START HERE --->

        
  
        <cfif #m# is "6">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>


          
        <cfif #m# is "7">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Report Settings set successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

        </cfif>


     
        
        
        <!--- ERROR MESSAGES END HERE --->

    
  
<cfif #action# is "setreports">

<!--- VALIDATE PARAMETERS BELOW --->
<!--- FORM.REPORTS --->
<cfif NOT StructKeyExists(form, "reports")>
  
  <cfset m="report Settings: form.reports does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "reports")>

<cfif #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL">

<cfelse>

  <cfset m="Report Recipients: form.reports is not YEs, NO, or ALL">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "reports") --->
</cfif>

<!--- FORM.FREQUENCY --->
<cfif NOT StructKeyExists(form, "frequency")>

  <cfset m="Edit Internal Recipients: form.frequency does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "frequency")>

  <cfif NOT IsValid("integer", #form.frequency#)>

  <cfset m="Report Settings: form.frequency is not valid Integer">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- NOT IsValid("integer", #form.frequency#) --->
</cfif>

<!--- /CFIF StructKeyExists(form, "frequency") --->
</cfif>


<!--- EDIT USER_SETTINGS STARTS HERE --->

  <cfquery name="editusersettings" datasource="hermes">
      update user_settings 
      set 
      report_enabled = '#form.reports#',
      report_frequency = '#form.frequency#'
     where id like binary '#session.uid#'
      </cfquery>

        <!--- EDIT USER_SETTINGS ENDS HERE --->

        <cfset session.m = 7>
        <cflocation url="report_settings.cfm" addtoken="no">
    
      <!--- /CFIF #action# is --->     
    </cfif> 
    
    <!---
    <div class="alert alert-warning">
    
      <p><i class="icon fas fa-exclamation-triangle"></i>System default for Reports is Ena</p>
      </div>
    --->

  <form action="" method="post">



    <input type="hidden" name="action" value="setreports">

      <!--- QUARANTINE REPORTS STARTS HERE --->
    
     
     <div class="form-group">
      <label><strong>Quarantine Reports</strong></label>
    <!---
      <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    <select class="form-control" name="reports" data-placeholder="reports" id="reports" style="width: 100%">   
      
    <cfif #report_enabled# is "YES">
    <option value="YES" selected="selected">Enable Report Only if Quarantined Messages Exist</option>
    <option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
    <option value="NO">Disable Quarantine Reports</option>

    <cfelseif #report_enabled# is "ALL">

      <option value="YES">Enable Report Only if Quarantined Messages Exist</option>
      <option value="ALL" selected="selected">Enable Report Regardless if Quarantined Messages Exist</option>
      <option value="NO">Disable Quarantine Reports</option>

    <cfelseif #report_enabled# is "NO">

      <option value="YES">Enable Report Only if Quarantined Messages Exist</option>
      <option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
      <option value="NO" selected="selected">Disable Quarantine Reports</option>

    <cfelse>

      <cfset m="Report Settings: report_enabled is not YES, ALL or NO">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      
<!--- /CFIF report_enabled is --->
    </cfif>
    
    </select> 
    </div>
    
    <cfif #report_enabled# is "NO">
         
              <div class="form-group" id="reportsfrequency" style="display:none;">
                <label><strong>Quarantine Report Frequency</strong></label>
    <!---
                <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->


    
      <select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
      <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
      <option value="2">Every 2 Hours (Previous 2 Hours Quarantine Report)</option>
      <option value="4">Every 4 Hours (Previous 4 Hours Quarantine Report)</option>
      <option value="8">Every 8 Hours (Previous 8 Hours Quarantine Report)</option>
       </select> 
      </div>

    <cfelse>

      <div class="form-group" id="reportsfrequency">
        <label><strong>Quarantine Report Frequency</strong></label>
<!---
        <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
--->



<select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
<option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
<option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
<option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
<option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select> 
</div>



<!--- /CFIF report_enabled is --->
</cfif>

    
      <!--- QUARANTINE REPORTS ENDS HERE --->


     
      <div class="col-sm-4">

        <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait';this.form.submit();">


      </div>

    </form>
    
    
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
    

</html>