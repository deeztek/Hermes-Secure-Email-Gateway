<!DOCTYPE html>

 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<html lang="en">



<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Welcome</title>

  <cfinclude template="./inc/html_head.cfm" />

  <!--
  <script>
    $(document).ready(function()
    {
        function refresh()
        {
            var div = $('#systemresources'),
                divHtml = div.html();
    
            div.html(divHtml);
        }
    
        setInterval(function()
        {
            refresh()
        }, 10000); //300000 is 5minutes in ms
    })
  </script>
-->


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
            <cfoutput>
            <h1 class="m-0">Welcome #session.theUser#!</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Home</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <div class="alert alert-warning alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
             
          <p><i class="icon fas fa-exclamation-triangle"></i>Welcome to new Hermes SEG 2.0 Web GUI. The new Web GUI is still a work in progress. Some of the navigation links will take you to the old Web GUI. We appreciate your patience as we continue to improve Hermes SEG.</p>

          <!--- /DIV class="alert alert-warning alert-dismissible" --->
          </div>
      
<!--- Check if Wizard has been ran --->
<cfquery name="checkwizard" datasource="hermes">
  select parameter, value from system_settings where parameter='wizard_settings'
  </cfquery>
  
  <cfif #checkwizard.value# is "2">
  
<!--- SET POSTFIX, DJIGZO SYSLOG AND AMAVIS DB CREDS IN CONFIG FILES --->
    <cfinclude template="./inc/update_postfix_config_files.cfm">
    <cfinclude template="./inc/update_djigzo_config_files.cfm">
    <cfinclude template="./inc/update_syslog_config_files.cfm">
    <cfinclude template="./inc/update_amavis_config_files.cfm">

<!--- SET WIZARD TO 1 --->
<cfquery name="setwizard" datasource="hermes">
update system_settings set value = '1' where parameter='wizard_settings'
</cfquery>

<!--- /CFIF #checkwizard.value# is "2" ---> 
  </cfif>




<!--- GET SYSTEM RESOURCES AND INFO --->

<cfinclude template="./inc/get_system_ip.cfm" />
<cfinclude template="./inc/get_system_uptime.cfm" />
<cfinclude template="./inc/get_system_version_build.cfm" />
<cfinclude template="./inc/get_system_reboot_required.cfm" />
<cfinclude template="./inc/check_system_update.cfm" />



<div id="systemresources">

  <cfinclude template="./inc/get_system_resources.cfm" />

<!--- /DIV id=systemresources --->
</div>

 <!-- System Info Card -->
 <div class="card">
  <div class="card-header">
    <h3 class="card-title">
      <i class="fas fa-info"></i>
     System Info
    </h3>


  <!-- /.card-header -->
</div>



  <div class="card-body table-responsive">

    <div class="row">

      <table class="table">
        <thead>
        <tr>
          <th>Version</th>
          <th>Build</th>
          <th>Edition</th>
          <th>Uptime</th>
          <th>System IP</th>
          <th>License Status</th>
          <th>OS Updates</th>
          <th>Hermes Update</th>
     
    
        </tr>
        </thead>
        <tbody>

          <tr>
            <cfoutput>
            <td>#theVersion#</td>
            <td>#theBuild#</td>

            <cfif #session.edition# is "Community">
            <td>#session.edition#&nbsp;&nbsp;<a href='view_system_settings.cfm'>ENTER SERIAL</a></td>
            <cfelseif #session.edition# is "Pro">
              <td>#session.edition#</td>
            <cfelse>
              <td>N/A</td>
          </cfif>

            <td>#uptime# Days</td>
            <td>#theIpAddress#</td>
            <cfif #session.licensevaliddays# GTE 1>
            <td>#session.license# (#session.licensevaliddays# Days)</td>
            <cfelse>
              <td>#session.license#</td>

          </cfif>

          <cfif #mustreboot# is "2">
            <td>REBOOT REQUIRED</td>
          <cfelse>
            <td>NO REBOOT REQUIRED</td>
          </cfif>

          <td>#hermesupdate#</td>

          </cfoutput>
         
      </tr>
            
                  
                  </tbody>
                </table>


<!--- /DIV class="row" --->
</div>

      
    <!--- /DIV class="card-body table-responsive" --->
    </div>

        <!--- /DIV class="card" --->
      </div>

 



        <!-- System Resources Card -->
        <div class="card">

          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-chart-bar"></i>
             System Resources
            </h3>


       <!-- /.card-header -->
</div>



          <div class="card-body" id="systemresources">

            <div class="row">
              <div class="col-6 col-md-3 text-center">
       
                <cfoutput>
                <input type="text" class="knob" value="#cpu#" data-width="90" data-height="90" data-fgColor="###cpucolor#" readonly>
              </cfoutput>

                <div class="knob-label">CPU Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                <cfoutput>
                <input type="text" class="knob" value="#mem#" data-width="90" data-height="90" data-fgColor="###memcolor#" readonly>
              </cfoutput>

                <div class="knob-label">Memory Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                <cfoutput>
                <input type="text" class="knob" value="#rootusage#" data-width="90" data-height="90" data-fgColor="###rootusagecolor#" readonly>
              </cfoutput>

                <div class="knob-label">Root FileSystem Utilization %</div>
              </div>
              <!-- ./col -->


              <div class="col-6 col-md-3 text-center">
                <cfoutput>
                <input type="text" class="knob" value="#datausage#" data-width="90" data-height="90" data-fgColor="###datausagecolor#" readonly>
              </cfoutput>

                <div class="knob-label">Data FileSystem Utilization %</div>

  <!--- /DIV class="row" --->
</div>

      
<!--- /DIV class="card-body table-responsive" --->
</div>

    <!--- /DIV class="card" --->
  </div>
                      

</div><!-- /.col -->
</div><!-- /.row -->
           
           
      
      <!-- /.container-fluid -->
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







</html>
