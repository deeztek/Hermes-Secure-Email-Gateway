<!DOCTYPE html>

  
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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
  <title>Hermes SEG | Console Settings</title>

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

<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  

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
            <h1 class="m-0">Console Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Console Settings</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">


     
<!--- CFML CODE STARTS HERE --->


<cfparam name = "step" default = "0"> 

<cfparam name = "m" default = "0">
<cfif StructKeyExists(session, "m")>

  <!---
  <cfoutput>Session M: #session.m#<br></cfoutput>
  --->

<cfif #session.m# is not "">
<cfset m = #session.m#>

<!--- ENABLE FOR DEBUG BELOW --->

<!--- /CFIF for session.m is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.m --->
</cfif>


<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfif form.action is not "">
<cfset action = form.action>

<!--- /CFIF form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists --->
</cfif>  

<!---
<cfoutput>M: #m#<br></cfoutput>
--->
<!---
<cfparam name = "applied" default = "1"> 
<cfquery name="getapplied" datasource="hermes">
select applied from system_users where applied = '2'
</cfquery>

<cfif #getapplied.recordcount# GTE 1>
<cfset applied = 2>
</cfif>
--->


<!--- GET CONSOLE SETTINGS TO BE USED AS FORM INPUTS BELOW --->
<cfinclude template="./inc/get_console_settings.cfm">

<!---
<cfparam name = "consoleHost" default = "#console_host.value2#"> 
--->

<cfparam name = "consoleCertificate" default = "#console_certificate.value2#"> 

<cfparam name = "dhparam" default = "#console_dhparam.value2#"> 

<cfparam name = "hsts" default = "#console_hsts.value2#"> 

<cfparam name = "sslstapling" default = "#console_ssl_stapling.value2#"> 

<cfparam name = "sslstaplingverify" default = "#console_ssl_stapling_verify.value2#"> 

<cfquery name = "getcertdetails" datasource="hermes">
select id, subject, issuer, serial, type, friendly_name from system_certificates where id = '#consoleCertificate#'
</cfquery>


<!--- DEBUG --->
<!---
<cfoutput>
</cfoutput>
--->

<cfif #action# is "edit">


<!--- EDIT CONSOLE SETTINGS --->
<cfinclude template="./inc/edit_console_settings.cfm">



 <!--- Restart Authelia --->   
<cfinclude template="./inc/restart_authelia.cfm">

<!--- RESTART CIPHERMAIL --->
<cfinclude template="./inc/restart_ciphermail.cfm"> 

<cfset session.m=27>

<cflocation url="preload_restart_nginx.cfm" addtoken="no">





 
  <cfoutput>
  <cflocation url="https://#consoleHost#/admin/2/view_console_settings.cfm" addtoken="no">
  </cfoutput>



<cfelseif  #action# is "generatedh">

<cfif FileExists("/opt/hermes/tmp/dhparam.pem")>

<cfset m="Generate DH Parameters File: There was an attempt to generate DH Parameters file while /opt/hermes/tmp/dhparam.pem exists">
<cfinclude template="./inc/error.cfm">
<cfabort>   

<cfelse>

<!--- IF EXISTS DELETE /OPT/HERMES/SSL/DHPARAM.PEM FILE --->
<cfif FileExists("/opt/hermes/ssl/dhparam.pem")>
<cffile action="delete" file="/opt/hermes/ssl/dhparam.pem">
</cfif>

<!--- DISABLE DHPARAM IN DBASE --->
<cfquery name="disablehparam" datasource="hermes">
update parameters2 set value2='disable', active='1', applied='2' where parameter='dhparam' and module='console'
</cfquery>

<!--- GENERATE DHPARAM --->
<cftry>
<cfexecute name="/opt/hermes/scripts/generate_dhparam.sh"
timeout="0" />
    
<cfcatch type="any">

<cfset m="Generate DH Parameters File: There was an error executing /opt/hermes/scripts/generate_dhparam.sh">
<cfinclude template="./inc/error.cfm">
<cfabort>   

</cfcatch>
</cftry>


<cfset session.m=28>



  <cfoutput>
  <cflocation url="https://#consoleHost#/admin/2/view_console_settings.cfm" addtoken="no">
  </cfoutput>


<!--- /CFIF  FileExists("/opt/hermes/tmp/dhparam.pem")> --->
</cfif>

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->


<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a valid Console Certificate  (Error Code: #session.m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Host Name field must be a valid FQDN domain or IP Address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "27">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>Console Settings were saved successfully</cfoutput> 
    
</div>

<cfset session.m = 0>

</cfif>


<cfif #m# is "28">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Generate DH Parameters File was started. This is going to take a long time to complete. Check back on this page for the Diffie-Hellman (DH) key-exchange drop-down option to appear. <strong>Do NOT</strong> start another Generate DH Parameters File process</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>
  


<!--- ERROR MESSAGES END HERE --->

<span>
<p> 

<!--- IF /OPT/HERMES/TMP/DHPARAM.PEM EXISTS THEN SYSTEM IN PROCESS OF GENERATING DHPARAM.PEM FILE SO HIDE GENERATE DH PARAMETERS FILE BUTTON --->
<cfif FileExists("/opt/hermes/tmp/dhparam.pem")>



  <div class="alert alert-warning">
    <p>The system in in progress of generating a Diffie-Hellman (DH) Parameters file. The Generate DH Parameters File button will re-appear once the process is finished.</p>
    </div>

<!--- IF /OPT/HERMES/TMP/DHPARAM.PEM DOES NOT EXIST THEN SHOW GENERATE DH PARAMETERS FILE BUTTON --->
<cfelse>

<!--- GENERATE DH PARAMETERS BUTTON STARTS HERE --->
<cfoutput>
  <a href="##generate_modal"  class="btn btn-primary" role="button" data-bs-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Generate DH Parameters File</a>
  </cfoutput>
<!--- GENERATE DH PARAMETERS ENDS HERE --->


<!--- /CFIF FileExists("/opt/hermes/tmp/dhparam.pem") --->
</cfif>

</p>
</span>

<!--- GENERATE DH MODAL HTML STARTS HERE --->
   
<div class="modal fade" id="generate_modal" tabindex="-1" role="dialog" aria-labelledby="generateDHParameterModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Diffie-Hellman (DH) Parameters File</h4>
</div>
  
<div class="modal-body">
  <p>This process will take very long time to complete (~40 minutes on 1 CPU systems).</p>
  
  <p><strong>If this the first time you are generating a Diffie-Hellman (DH) file</strong>, when the process is complete there will be a new <strong>Diffie-Hellman (DH) key-exchange</strong> drop-down option on the Console Settings page. <strong>The option will only appear when the process is complete.</strong></p>
    
  <p><strong>If this is not the first time you are generating a Diffie-Hellman (DH) file</strong>, generating a new file will automatically <strong>Disable the Diffie-Hellman key-exchange for your system</strong>, replace the existing Diffie-Hellman (DH) file and remove the Diffie-Hellman (DH) key-exchange drop-down option from the Console Settings page.<strong> You must manually re-enable the Diffie-Hellman (DH) key-exchange option when the process is complete.</strong></p>

  <p>Are you sure you want to Generate a Diffie-Hellman (DH) Parameters File?</p>

</div>
<div class="modal-footer">
  <form name="GenerateDH" method="post">

    <input type="hidden" name="action" value="generatedh">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE DH MODAL HTML ENDS HERE --->


<!--- CONSOLE SETTINGS FORM STARTS HERE --->


<form name="EditConsoleSettings" method="post">

<input type="hidden" name="action" value="edit">

<cfoutput>
<input type="hidden" name="certificateno_1" class="certificateno form-control" id="certificateno_1" value="#consoleCertificate#">
</cfoutput>

    <div class="box-body">


                          <div class="form-group" id="console_host">



                              <cfoutput>
                                <div class="form-group" id="console_host">

                                                                  <div class="alert alert-warning">

          <p><i class="icon fas fa-exclamation-triangle"></i>If you modify the existing <strong>Console Address</strong> ensure you adjust your web browser to reflect the new IP Address FQDN you set. This setting also sets the Ciphermail Portal and the User Console addresses.</p>
          </div>
                                  <label for="console_host">Console Address (IP or FQDN)</label>
                                  <div class="input-group">

                                    
      
                                  <input type="text" class="form-control" name="console_host" value="#consoleHost#" id="console_host" placeholder="Enter an IP or FQDN to be used to access Hermes SEG" maxLength="255">

                                </div>



                                </div>
                                </cfoutput>

                              </div>


                <div class="form-group">
<!---
 <div class="alert alert-warning">

          <p><i class="icon fas fa-exclamation-triangle"></i>If you select a new ACME <strong>Console Certificate</strong>, the application will not load the new certificate after clicking the <strong>Submit</strong> button. This is a known limitation of Nginx in docker. In that case, you must restart the Nginx container from the command line in order to load the new certificate.</p>
          </div>
        --->

                  <label>Console Certificate</label>
                  <div class="input-group">
                  <cfoutput>
                  <input type="text" name="certificate_1" class="certificate form-control" id="certificate_1" placeholder="Start typing to search..." value="#getcertdetails.friendly_name#" autocomplete="off">
                  </cfoutput>
                  
                  <!--- /div class="input-group" --->
                  </div>
                  
                  <!--- /div class="form-group" --->
                  </div>

                  <div class="form-group">
                    <label>Certificate Subject</label>
                    <div class="input-group">
                    <cfoutput>
                    <input type="text" name="subject_1" class="subject form-control" id="subject_1" value="#getcertdetails.subject#" readonly>
                    </cfoutput>
                    
                    <!--- /div class="input-group" --->
                    </div>
                    
                    <!--- /div class="form-group col-sm-4" --->
                    </div>
                  

                    
                  <div class="form-group">
                    <label>Certificate Issuer</label>
                    <div class="input-group">
                    <cfoutput>
                    <input type="text" name="issuer_1" class="issuer form-control" id="issuer_1" value="#getcertdetails.issuer#" readonly>
                    </cfoutput>
                    
                    <!--- /div class="input-group" --->
                    </div>
                    
                    <!--- /div class="form-group col-sm-4" --->
                    </div>

                    <!---

                    <div class="form-group col-sm-4">
                      <label>Certificate Startdate</label>
                      <div class="input-group">
                      <cfoutput>
                      <input type="text" name="certstart_1" class="certstart form-control" id="certstart_1" value="" readonly>
                      </cfoutput>
                      
                      <!--- /div class="input-group" --->
                      </div>
                      
                      <!--- /div class="form-group col-sm-4" --->
                      </div>

                       

                      <div class="form-group col-sm-4">
                        <label>Certificate Enddate</label>
                        <div class="input-group">
                        <cfoutput>
                        <input type="text" name="certend_1" class="certstart form-control" id="certend_1" value="#theenddate#" readonly>
                        </cfoutput>
                        
                        <!--- /div class="input-group" --->
                        </div>
                        
                        <!--- /div class="form-group col-sm-4" --->
                        </div>
 --->
                    

                        <div class="form-group">
                          <label>Certificate Serial</label>
                          <div class="input-group">
                          <cfoutput>
                          <input type="text" name="serial_1" class="serial form-control" id="serial_1" value="#getcertdetails.serial#" readonly>
                          </cfoutput>
                          
                          <!--- /div class="input-group" --->
                          </div>
                          
                          <!--- /div class="form-group col-sm-4" --->
                          </div>


                  <div class="form-group">
                    <label>Certificate Type</label>
                    <div class="input-group">
                    <cfoutput>
                    <input type="text" name="type_1" class="type form-control" id="type_1" value="#getcertdetails.type#" readonly>
                    </cfoutput>
                    
                    <!--- /div class="input-group" --->
                    </div>
                    
                    <!--- /div class="form-group col-sm-4" --->
                    </div>


                    <cfif FileExists("/opt/hermes/ssl/dhparam.pem")>
                  
                      <div class="form-group">
                        <label>Diffie-Hellman (DH) key-exchange</label>
                    
                        <select class="form-control" name="dh_param" data-placeholder="dh_param" style="width: 100%;"  id="dh_param">
                          <cfif #dhparam# is "enable">                           
                            <option value="enable" selected>Enable (Recommended)</option></option>
                            <option value="disable">Disable</option>
                          <cfelseif #dhparam# is "disable">
                            <option value="disable" selected>Disable</option></option>
                            <option value="enable">Enable (Recommended)</option>
                          </cfif>
                            </select>   
                    
                          </div>          
                      
                    </cfif>

                    <div class="form-group">
                      <label>HTTP Strict Transport Security (HSTS)</label>
                  
                      <select class="form-control" name="hsts" data-placeholder="hsts" style="width: 100%;"  id="hsts">
                        <cfif #hsts# is "enable">                           
                          <option value="enable" selected>Enable (Recommended)</option></option>
                          <option value="disable">Disable</option>
                        <cfelseif #hsts# is "disable">
                          <option value="disable" selected>Disable</option></option>
                          <option value="enable">Enable (Recommended)</option>
                        </cfif>
                          </select>   
                  
                        </div>       
                        

                        <div class="form-group">
                          <label>Online Certificate Status Protocol (OCSP) Stapling</label>
                      
                          <select class="form-control" name="ocsp" data-placeholder="ocsp" style="width: 100%;"  id="ocsp">
                            <cfif #sslstapling# is "enable">                           
                              <option value="enable" selected>Enable (Recommended)</option></option>
                              <option value="disable">Disable</option>
                            <cfelseif #sslstapling# is "disable">
                              <option value="disable" selected>Disable</option></option>
                              <option value="enable">Enable (Recommended)</option>
                            </cfif>
                              </select>   
                      
                            </div>     

                            <div class="form-group">
                              <label>Online Certificate Status Protocol (OCSP) Stapling Verify</label>
                          
                              <select class="form-control" name="ocspverify" data-placeholder="ocspverify" style="width: 100%;"  id="ocspverify">
                                <cfif #sslstaplingverify# is "enable">                           
                                  <option value="enable" selected>Enable (Recommended)</option></option>
                                  <option value="disable">Disable</option>
                                <cfelseif #sslstaplingverify# is "disable">
                                  <option value="disable" selected>Disable</option></option>
                                  <option value="enable">Enable (Recommended)</option>
                                </cfif>
                                  </select>   
                          
                                </div>  


<!--- <p class="help-block">Help Block Text</p> --->


<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">


  </form>

  <div>&nbsp;</div>


<!-- CONSOLE SETTINGS FORM ENDS HERE -->

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

<!--- NO LONGER USED --->
<!---
<!--- SCRIPT TO SHOW/HIDE SET CONSOLE HOST SCRIPT STARTS HERE  --->

<script>

  $('#console_mode').on('change',function(){
    if( $(this).val()==="fqdn"){
    $("#console_host").show()
    }
    else{
    $("#console_host").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE SET CONSOLE HOST SCRIPT ENDS HERE  --->
--->

 <!--- SCRIPT TO GET CERTIFICATES BELOW --->

<script type="text/javascript">
  $(document).ready(function(){

      $(document).on('keydown', '.certificate', function() {
          
          var id = this.id;
          var splitid = id.split('_');
          var index = splitid[1];

          $( '#'+id ).autocomplete({
              source: function( request, response ) {
                  $.ajax({
                      url: "./inc/getcertificates.cfm",
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
                      url: './inc/getcertificates.cfm',
                      type: 'post',
                      data: {id:id,request:2},
                      dataType: 'json',
                      success:function(response){
                          
                          var len = response.length;

                          if(len > 0){
                              var certificate_no = response[0]['id'];
                              var type = response[0]['type'];
                              var subject = response[0]['subject'];
                              var issuer = response[0]['issuer'];
                              var serial = response[0]['serial'];
                              var fingerprint = response[0]['fingerprint'];
                              var certstart = response[0]['certstart'];
                              var certend = response[0]['certend'];
                              var friendlyname = response[0]['friendly_name'];
                  
                              document.getElementById('certificateno_'+index).value = certificate_no;
                              document.getElementById('type_'+index).value = type;
                              document.getElementById('subject_'+index).value = subject;
                              document.getElementById('issuer_'+index).value = issuer;
                              document.getElementById('serial_'+index).value = serial;
                              document.getElementById('fingerprint_'+index).value = fingerprint;
                              document.getElementById('certstart_'+index).value = certstart;
                              document.getElementById('certend_'+index).value = certend;
                              document.getElementById('friendlyname_'+index).value = friendlyname;
             
                        
                              
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