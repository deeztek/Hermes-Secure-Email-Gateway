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
  <title>Hermes SEG | Notification Settings</title>

  <cfinclude template="./inc/html_head.cfm" />



</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">



  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Notification Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Notification Settings</li>
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
select report_enabled from user_settings where email = '#session.email#'
</cfquery>

<cfparam name = "report_enabled" default = "#getreportsettings.report_enabled#">

  
        <!--- ERROR MESSAGES START HERE --->

        
  
        <cfif #m# is "6">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>


          
        <cfif #m# is "7">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Notification Settings saved successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

        </cfif>


     
        
        
        <!--- ERROR MESSAGES END HERE --->

    
  
<cfif #action# is "setreports">

<!--- VALIDATE PARAMETERS --->
<cfif NOT StructKeyExists(form, "reports")>
  <cfset m="Notification Settings: form.reports does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfif NOT ListFindNoCase("YES,NO", form.reports)>
  <cfset m="Notification Settings: invalid reports value">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- SAVE SETTINGS --->
<cfquery name="editusersettings" datasource="hermes">
    UPDATE user_settings
    SET report_enabled = <cfqueryparam value="#form.reports#" cfsqltype="cf_sql_varchar">
    WHERE email = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

        <cfset session.m = 7>
        <cflocation url="report_settings.cfm" addtoken="no">
    
      <!--- /CFIF #action# is --->     
    </cfif> 
    
        <!--- QUARANTINE NOTIFICATIONS CARD --->
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-bell me-2"></i>Quarantine Notifications</h3>
            </div>
            <div class="card-body">
                <p>When enabled, you will receive an email notification each time a message to your address is quarantined. Each notification includes a one-click <strong>Release Message</strong> button that does not require logging in.</p>
                <form action="" method="post">
                    <input type="hidden" name="action" value="setreports">

                    <div class="mb-3">
                        <label class="form-label"><strong>Quarantine Notifications</strong></label>
                        <select class="form-control" name="reports" style="width: 100%">
                            <option value="YES" <cfif report_enabled NEQ "NO">selected</cfif>>Enabled</option>
                            <option value="NO" <cfif report_enabled EQ "NO">selected</cfif>>Disabled</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                        <i class="fas fa-save me-1"></i> Save Settings
                    </button>
                </form>
            </div>
        </div>
    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>

  


</html>