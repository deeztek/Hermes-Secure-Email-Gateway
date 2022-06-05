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
  <title>Hermes SEG | System Logs</title>

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
            [ 50, 75, 100, -1 ],
      [ '50 rows', '75 rows', '100 rows', 'Show all' ]
  
      ],
      
          "order": [[ 0, "desc" ]]
      } );
  } );
    </script>

  

<script>

  $(document).ready(function() {
    $("#messageactions").click(function() {
      var messageactions = [];
      $.each($("input[name='mail_id']:checked"), function() {
        messageactions.push($(this).val());
      });
      $('#messageactions_modal').modal('show').on('shown.bs.modal', function() {
      $("#messageactionsid").html('<input type="hidden" name="mail_id" value=' + messageactions + '>');
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
            <h1 class="m-0">System Logs</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Logs</li>
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
    
    <cfparam name = "errormessage" default = "0">
    
    <cfparam name = "m2" default = "0"> 
    <cfif StructKeyExists(url, "m2")>
    <cfif url.m2 is not "">
    <cfset m2 = url.m2>

    <!--- /CFIF for StructKeyExists --->
  </cfif>
  
  <!--- /CFIF for url.m2 is not "" --->
  </cfif>

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
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>  
    
  <cfset defaultenddate2=#DateFormat(Now(),"yyyy-mm-dd")#>
  <cfset defaultendtime="23:59:59">
  <cfset defaultenddate="#defaultenddate2# #defaultendtime#">
  <cfset defaultstartdate=#DateAdd("h", -24, defaultenddate2)#>
  <cfset defaultstartdate=#DateFormat(defaultstartdate,"yyyy-mm-dd")#>
  <cfset defaultstarttime="00:00:00">
  <cfset defaultstartdate="#defaultstartdate# #defaultstarttime#">


  <!--- DEBUG ENABLE BELOW --->
<!---
  <cfoutput>Startdate: #defaultstartdate#<br>
  Enddate: #defaultenddate#</cfoutput>
 --->

    <cfparam name = "startdate" default = "#defaultstartdate#"> 
    <cfif IsDefined("url.startdate") is "True">
    <cfif url.startdate is not "">
    <cfif isValid("date", #url.startdate#)> 
    <cfset startdate = url.startdate>
    <cfelseif NOT isValid("date", #url.startdate#)>

    <cfset m="System Logs: url.startdate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.startdate#) --->
     </cfif>

     <cfelseif url.startdate is "">

     <cfset m="System Logs: url.startdate is empty">
     <cfinclude template="./inc/error.cfm">
     <cfabort>

    <!--- /CFIF url.startdate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.startdate") --->
    </cfif>
    
    <cfparam name = "enddate" default = "#defaultenddate#"> 
    <cfif IsDefined("url.enddate") is "True">
    <cfif url.enddate is not "">
    <cfif isValid("date", #url.enddate#)> 
    <cfset enddate = url.enddate>
    <cfelseif NOT isValid("date", #url.enddate#)>
    
    <cfset m="System Logs: url.enddate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.enddate#) --->
     </cfif>

    <cfelseif url.enddate is "">

      <cfset m="System Logs: url.enddate is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <!--- /CFIF url.enddate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.enddate") --->
    </cfif>
    


    <cfparam name = "limit" default = "1000">

    <cfif IsDefined("url.limit") is "True">

    <cfif url.limit is not "">

    <cfif #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000"> 

    <cfset limit = url.limit>

    <cfelse>
 
    <cfset m="System Logs: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000" --->
     </cfif>

    <cfelseif #limit# is "">

    <cfset m="System Logs: url.limit is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF url.limit is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.limit") --->
    </cfif>


<cfquery name="getlogs" datasource="syslog">
  select ReceivedAt, Message, SysLogTag from SystemEvents where ReceivedAt between '#startdate#' and '#enddate#' order by ReceivedAt desc limit #limit#
  </cfquery>

  
       <!--- ERROR MESSAGES START HERE --->
  
       
        
  

       <cfif #m# is "1">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Log Retention was set successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

     <!--- ERROR MESSAGES START HERE --->

  
  
 <cfif #action# is "Set Log Retention">


<cfif NOT StructKeyExists(form, "logretention")>
    
    
  <cfset m="Set Log Retention: form.logretention does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>



<cfelseif StructKeyExists(form, "logretention")>

  <cfif #form.logretention# is "">

    <cfset m="Set Log Retention: form.logretention is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


<cfelseif #form.logretention# is not "">

<cfif isValid("integer", form.logretention)>

  <cfquery name="setlogretention" datasource="hermes">
    update parameters2 set value2 = <cfqueryparam value = #form.logretention# CFSQLType = "CF_SQL_INTEGER"> where parameter = 'system_log_retention' and module = 'systemlog'
    </cfquery>


<cfset session.m = 1>

<cflocation url="preloader_view_system_logs.cfm" addtoken="no">


<cfelseif NOT isValid("integer", form.id)>

<cfset m="Set Log Retention: form.logretention is not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.logretention) --->
</cfif>

  <!--- /CFIF #form.logretention# is "" --->
</cfif>


<!--- /CFIF StructKeyExists(form, "logretention") --->
</cfif>



    
      <!--- /CFIF #action# is --->     
    </cfif> 
    
    <span>
      <p>  


    <!--- RELOAD SYSTEM LOGS BUTTON STARTS HERE --->
<a href="preloader_view_system_logs.cfm" class="btn btn-primary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Reload System Logs</a>

<!--- RELOAD SYSTEM LOGS BUTTON ENDS HERE --->

&nbsp;&nbsp;

  </p>
</span>



<cfquery name="getlogretention" datasource="hermes">
  select parameter, value2, module from parameters2 where parameter = 'system_log_retention'
  </cfquery>
  
  
  <cfparam name = "logretention" default = "#getlogretention.value2#"> 
  
  
  
  <div class="card col-sm-8">
    
    <!---
    <div class="card-header border-1">
  
      <h3 class="card-title"><strong>Mail Queue Settings</strong></h3>
  
    <!--- class="card-header border-1" --->
  </div>
  --->
  
  <form name="logretention" method="post">
  <input type="hidden" name="action" value="Set Log Retention">
  
  <div class="col-sm-6">
     <div class="form-group">

      <br>
      <label><strong>Log Retention</strong></label>
              
 
  
  <cfoutput>
    
    <cfif #logretention# is "7">
      <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="7" selected="selected">7 Days</option>
     <option value="15">15 Days</option>
    <option value="30">30 Days</option>
    <option value="60">60 Days</option>
    <option value="90">90 Days</option>
    <option value="120">120 Days</option>
    <option value="180">180 Days</option>
    </select>
  
    
  <cfelseif #logretention# is "15">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="15" selected="selected">15 Days</option>
     <option value="7">7 Days</option>
    <option value="30">30 Days</option>
    <option value="60">60 Days</option>
    <option value="90">90 Days</option>
    <option value="120">120 Days</option>
    <option value="180">180 Days</option>
    </select>
  
  <cfelseif #logretention# is "30">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="30" selected="selected">30 Days</option>
     <option value="7">7 Days</option>
    <option value="15">15 Days</option>
    <option value="60">60 Days</option>
    <option value="90">90 Days</option>
    <option value="120">120 Days</option>
    <option value="180">180 Days</option>
    </select>
  
  <cfelseif #logretention# is "60">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="60" selected="selected">60 Days</option>
     <option value="7">7 Days</option>
    <option value="15">15 Days</option>
    <option value="30">30 Days</option>
    <option value="90">90 Days</option>
    <option value="120">120 Days</option>
    <option value="180">180 Days</option>
    </select>
  
  <cfelseif #logretention# is "90">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="90" selected="selected">90 Days</option>
     <option value="7">7 Days</option>
    <option value="15">15 Days</option>
    <option value="30">30 Days</option>
    <option value="60">60 Days</option>
    <option value="120">120 Days</option>
    <option value="180">180 Days</option>
    </select>
  
  <cfelseif #logretention# is "120">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="120" selected="selected">120 Days</option>
     <option value="7">7 Days</option>
    <option value="15">15 Days</option>
    <option value="30">30 Days</option>
    <option value="60">60 Days</option>
    <option value="90">90 Days</option>
    <option value="180">180 Days</option>
    </select>
  
  <cfelseif #logretention# is "180">
    <select class="form-control" name="logretention" style="width: 100%;" id="logretention">
  <option value="180" selected="selected">180 Days</option>
     <option value="7">7 Days</option>
      <option value="15">15 Days</option>
    <option value="30">30 Days</option>
    <option value="60">60 Days</option>
    <option value="90">90 Days</option>
    <option value="120">120 Days</option>
    </select>
  
  
  </cfif>
  
  </cfoutput>
     
  
                </div>
      </div>
    
    
    <div class="col-sm-6">
    
    <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
    </div>
      
    </form>  
    
  <br>
  
    <!--- div class="card"  --->  
  </div>
  
  <div class="card col-sm-8">
    
    <!---
    <div class="card-header border-1">
  
      <h3 class="card-title"><strong>Mail Queue Settings</strong></h3>
  
    <!--- class="card-header border-1" --->
  </div>
  --->
  
  <br>
  

<form>

<div class="col-sm-6">
  <label>Start Date/Time</label>
    <div class="form-group">
        <div class="input-group date" id="startdatetime" data-target-input="nearest">
          <cfoutput>
            <input type="text" name="startdate" value="#startdate#" class="form-control datetimepicker-input" data-target="##startdatetime"/>
          </cfoutput>
            <div class="input-group-append" data-target="#startdatetime" data-toggle="datetimepicker">
                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
            </div>
        </div>
    </div>
  </div>

<script type="text/javascript">
    $(function () {
        $('#startdatetime').datetimepicker({
          format: 'YYYY-MM-DD HH:mm:ss',
          icons: { time: 'far fa-clock' },
          sideBySide: true
          
        });
    });
</script>



  <div class="col-sm-6">
    <label>End Date/Time</label>
      <div class="form-group">
          <div class="input-group date" id="enddatetime" data-target-input="nearest">
            <cfoutput>
              <input type="text" name="enddate" value="#enddate#" class="form-control datetimepicker-input" data-target="##enddatetime"/>
            </cfoutput>
              <div class="input-group-append" data-target="#enddatetime" data-toggle="datetimepicker">
                  <div class="input-group-text"><i class="fa fa-calendar"></i></div>
              </div>
          </div>
      </div>
    </div>

  <script type="text/javascript">
      $(function () {
          $('#enddatetime').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            icons: { time: 'far fa-clock' },
            sideBySide: true
        
          });
      });
  </script>

<div class="form-group col-sm-6">
  <label>Search Results Limit</label>
  <div class="alert alert-warning">
<!---
    <h6><i class="icon fas fa-exclamation-triangle"></i> Warning!</h6>
--->
    <p><i class="icon fas fa-exclamation-triangle"></i>Setting Search Results Limit to 10000 or 15000 will <strong>significantly</strong> increase the page loading time </p>
    </div>
  <div class="input-group">

    <select class="form-control" name="limit" data-placeholder="limit">   
      <cfoutput>          
      <option value="#limit#" selected="selected">#limit#</option>
    </cfoutput>    
     
      <cfif #limit# is "1000">

      <option value="1500">1500</option>
      <option value="2500">2500</option>
      <option value="5000">5000</option>
      <option value="10000">10000</option>
      <option value="15000">15000</option>

      <cfelseif #limit# is "1500">

        <option value="1000">1000 (Default)</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "2500">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "5000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="10000">10000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "10000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="15000">15000</option>

      <cfelseif #limit# is "15000">

        <option value="1000">1000 (Default)</option>
        <option value="1500">1500</option>
        <option value="2500">2500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>

<!--- /CFIF #limit# is --->
      </cfif>

      </select> 


  
  <!--- /div class="input-group" --->
  </div>
  
  <!--- /div class="input-group" --->
  </div>

<div class="col-sm-6">

<input type="submit" class="btn btn-primary" name="" value="Fetch Logs" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
</div>
  
<br>

</form>


    <!--- div class="card"  --->  
  </div>

  <br>


    
    <cfif #getlogs.recordcount# GTE 1>  
                
      <table class="table table-striped wrap"  id="sortTable" style="width:100%">
        <thead>
          <tr>
      
            <th>Date/Time</th>
            <th>Message</th>
            <th>Facility</th>
     
 
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getlogs">

        
           <td>#DateFormat(ReceivedAt, "mm/dd/yyyy")# #TimeFormat(ReceivedAt, "HH:mm:ss")#</td>

 

            <td>#Message#</td>

            <td>#SysLogTag#</td>


          

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
            <th>Date/Time</th>
            <th>Message</th>
            <th>Facility</th>
     

          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getlogs.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Logs were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getlogs.recordcount --->
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