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
  <title>Hermes SEG | Network Settings</title>

  <cfinclude template="./inc/html_head.cfm" />

   <!-- Preloader -->
   <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>



<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  


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
            <h1 class="m-0">Network Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Network Settings</li>
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
        
        <cfquery name="network_mode" datasource="hermes">
            select * from parameters2 where parameter='network_mode' and module='network' and active='1'
            </cfquery>
          
          <cfif #network_mode.value2# is "">
            <cfparam name = "show_network_mode" default = "dhcp"> 
            <cfif IsDefined("form.network_mode") is "True">
            <cfif form.network_mode is not "">
            <cfset show_network_mode = form.network_mode>
            <cfquery name="update" datasource="hermes">
            update parameters2 set value2='#show_network_mode#' where parameter='network_mode'
            </cfquery>
            </cfif></cfif>
            <cfelseif #network_mode.value2# is not "">
            <cfparam name = "show_network_mode" default = "#network_mode.value2#"> 
            <cfif IsDefined("form.network_mode") is "True">
            <cfif form.network_mode is not "">
            <cfset show_network_mode = form.network_mode>
            <cfquery name="update" datasource="hermes">
            update parameters2 set value2='#show_network_mode#' where parameter='network_mode'
            </cfquery>
            </cfif></cfif>
            </cfif>
          
   
          
          <cfparam name = "errormessage" default = "0">
          <cfparam name = "step" default = "0"> 
          
          
          
          <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
          
          <cfif #authkey# is "">
          
          <!-- GENERATE SECRET KEY -->
          <cfset authkey=generateSecretKey("AES", 256)>
          <cffile action = "write"
          file = "/opt/hermes/keys/hermes.key"
          output = "#authkey#">
          
          <!-- READ SECRET KEY -->
          <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
          
          <!-- /CFIF #authkey# is  -->
          </cfif>
          
          <cfparam name = "algo" default = "AES">
          <cfparam name = "encoding" default = "Base64">
          
          <!--- VALIDATE IP ADDRESS REGEX --->
          <cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">
          
          <cfparam name = "show_action" default = "view"> 
          <cfif IsDefined("form.action") is "True">
          <cfif form.action is not "">
          <cfset show_action = form.action>
          </cfif></cfif> 
          
          <cfparam name = "show_action2" default = "view"> 
          <cfif IsDefined("form.action2") is "True">
          <cfif form.action2 is not "">
          <cfset show_action2 = form.action2>
          </cfif></cfif> 

 
          
          
          <cfquery name="server_ip" datasource="hermes">
          select * from parameters2 where parameter='server_ip' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_ip" default = "#server_ip.value2#"> 
          <cfif IsDefined("form.server_ip") is "True">
          <cfset show_server_ip = form.server_ip>
          </cfif>
          
          
          <cfquery name="server_gateway" datasource="hermes">
          select * from parameters2 where parameter='server_gateway' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_gateway" default = "#server_gateway.value2#"> 
          <cfif IsDefined("form.server_gateway") is "True">
          <cfset show_server_gateway = form.server_gateway>
          </cfif>
          
          
          <cfquery name="server_dns1" datasource="hermes">
          select * from parameters2 where parameter='server_dns1' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_dns1" default = "#server_dns1.value2#"> 
          <cfif IsDefined("form.server_dns1") is "True">
          <cfset show_server_dns1 = form.server_dns1>
          </cfif>
          
          <cfquery name="server_dns2" datasource="hermes">
          select * from parameters2 where parameter='server_dns2' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_dns2" default = "#server_dns2.value2#"> 
          <cfif IsDefined("form.server_dns2") is "True">
          <cfset show_server_dns2 = form.server_dns2>
          </cfif>
          
          <cfquery name="server_dns3" datasource="hermes">
          select * from parameters2 where parameter='server_dns3' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_dns3" default = "#server_dns3.value2#"> 
          <cfif IsDefined("form.server_dns3") is "True">
          <cfset show_server_dns3 = form.server_dns3>
          </cfif>
          
          <cfquery name="server_name" datasource="hermes">
          select * from parameters2 where parameter='server_name' and module='network' and active='1'
          </cfquery>
          
          <cfparam name = "show_server_name" default = "#server_name.value2#"> 
          <cfif IsDefined("form.server_name") is "True">
          <cfset show_server_name = form.server_name>
          </cfif>
          
          <cfquery name="server_domain" datasource="hermes">
          select * from parameters2 where parameter='server_domain' and module='network' and active='1'
          </cfquery>
          
          <cfparam name = "show_server_domain" default = "#server_domain.value2#"> 
          <cfif IsDefined("form.server_domain") is "True">
          <cfset show_server_domain = form.server_domain>
          </cfif>
          
          
          <cfquery name="server_subnet" datasource="hermes">
          select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
          </cfquery>
          
          
          <cfparam name = "show_server_subnet" default = "#server_subnet.value2#"> 
          <cfif IsDefined("form.server_subnet") is "True">
          <cfset show_server_subnet = form.server_subnet>
          </cfif>
          
          <cfparam name = "show_server_subnet" default = "#server_subnet.value2#"> 
          <cfif IsDefined("form.server_subnet") is "True">
          <cfset show_server_subnet = form.server_subnet>
          </cfif>
          
          <!--- UPDATE SECTION STARTS HERE --->
          
          <cfif #show_action# is "edit" and #show_network_mode# is "static">
          
          
          
          <cfif #show_server_ip# is not "">
          
          <cfif REFind(pattern,show_server_ip) GT 0>
          
          <cfset step=3>
          
          <cfelse>
          <cfset step=0>
          <cfset errormessage=1>
          
          <!--- /CFIF REFind --->
          </cfif>
          
          <cfelseif #show_server_ip# is "">
          <cfset step=0>
          <cfset errormessage=2>
          
          <!--- /CFIF #show_server_ip# is --->
          </cfif>
          
  
          <cfif step is "3">
          
          <cfif #show_server_gateway# is not "">
          
          <cfif REFind(pattern,show_server_gateway) GT 0>
          <cfset step=4>
          
          <cfelse>
          <cfset step=0>
          <cfset errormessage=3>
           
          <!--- /CFIF REFind --->
          </cfif>
          
          <cfelseif #show_server_gateway# is "">
          <cfset step=0>
          <cfset errormessage=4>
          
          <!--- /CFIF #show_server_gateway# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 3 --->
          </cfif>
          
          
          
          <cfif step is "4">
          
          <cfif #show_server_dns1# is not "">
          
          <cfif REFind(pattern,show_server_dns1) GT 0>
          <cfset step=5>
          <cfelse>
          <cfset step=0>
          <cfset errormessage=5>
           
          <!--- /CFIF REFind --->
          </cfif>
          
          <cfelseif #show_server_dns1# is "">
          <cfset step=0>
          <cfset errormessage=6>
          
          <!--- /CFIF #show_server_dns1# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 4 --->
          </cfif>
          
          
          <cfif step is "5">
          
          <cfif #show_server_dns2# is not "">
          
          <cfif REFind(pattern,show_server_dns2) gt 0>
          <cfset step=6> 
          <cfelse>
          <cfset step=0>
          <cfset errormessage=7>
          
          <!--- /CFIF REFind --->
          </cfif>
          
          <cfelseif #show_server_dns2# is "">
          <cfset step=6>
          
          <!--- /CFIF #show_server_dns2# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 13 --->
          </cfif>
          
          <cfif step is "6">
          
          <cfif #show_server_dns3# is not "">
          
          <cfif REFind(pattern,show_server_dns3) gt 0>
          <cfset step=7> 
          <cfelse>
          <cfset step=0>
          <cfset errormessage=9>
          
          <!--- /CFIF REFind --->
          </cfif>
          
          <cfelseif #show_server_dns3# is "">
          <cfset step=7> 
          
          <!--- /CFIF #show_server_dns3# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 6 --->
          </cfif>
          
          
          <cfif step is "7">
          
          <cfif #show_server_domain# is not "">
          
          <cfset temp_email="bob@#show_server_domain#">
          <cfif IsValid("email", temp_email)>
          <cfset step=8>
          <cfelseif not IsValid("email", temp_email)>
          <cfset step=0>
          <cfset errormessage=11>
          
          <!--- /CFIF IsValid("email", temp_email) --->
          </cfif>
          
          <cfelseif #show_server_domain# is "">
          <cfset step=0>
          <cfset errormessage=12>
          
          <!--- /CFIF #show_server_domain# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 7 --->
          </cfif>
          
          
          <cfif step is "8">
          
          <cfif #show_server_name# is "">
          
          <cfset step=0>
          <cfset errormessage=14>
          <cfelseif #show_server_name# is not "">
          <cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
          <cfset step=0>
          <cfset errormessage=13>
          <cfelse>
          <cfset step=9>
          
          <!--- /CFIF REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0 --->
          </cfif>
          
          <!--- /CFIF #show_server_name# is --->
          </cfif>
          
          <!--- /CFIF FOR STEP 8 --->
          </cfif>
          
          
          
          <cfif step is "9">
          
          <cfset errormessage=15>
          
          <cftransaction>
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_ip#', applied='2' where parameter='server_ip'
          </cfquery>
          
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_gateway#', applied='2' where parameter='server_gateway'
          </cfquery>
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_dns1#', applied='2' where parameter='server_dns1'
          </cfquery>
          
          <cfif #show_server_dns2# is not "">
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_dns2#', applied='2' where parameter='server_dns2'
          </cfquery>
          
          <cfelseif #show_server_dns2# is "">
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='', applied='2' where parameter='server_dns2'
          </cfquery>
          
          <!--- /CFIF #show_server_dns2_octet1#  --->
          </cfif>
          
          <cfif #show_server_dns3# is not "">
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_dns3#', applied='2' where parameter='server_dns3'
          </cfquery>
          
          <cfelseif #show_server_dns3# is "">
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='', applied='2' where parameter='server_dns3'
          </cfquery>
          
          <!--- /CFIF #show_server_dns3#  --->
          </cfif>
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_name#' , applied='2'where parameter='server_name'
          </cfquery>
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_domain#', applied='2' where parameter='server_domain'
          </cfquery>
          
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_subnet#', applied='2' where parameter='server_subnet'
          </cfquery>
          
          </cftransaction>
          
          
          
          <!--- /CFIF FOR STEP 9 --->
          </cfif>
          
          
          
          <cfelseif #show_action# is "edit" and #show_network_mode# is "dhcp">
          
          
         
          
          <cfif #show_server_domain# is not "">
          <cfset temp_email="bob@#show_server_domain#">
          <cfif IsValid("email", temp_email)>
          <cfset step=3>
          <cfelseif not IsValid("email", temp_email)>
          <cfset step=0>
          <cfset errormessage=11>
          </cfif>
          <cfelseif #show_server_domain# is "">
          <cfset step=0>
          <cfset errormessage=12>
          </cfif>
          

          
          
          <cfif step is "3" and #show_server_name# is "">
          <cfset step=0>
          <cfset errormessage=14>
          <cfelseif step is "3" and #show_server_name# is not "">
          <cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
          <cfset step=0>
          <cfset errormessage=13>
          <cfelse>
          <cfset step=4>
          </cfif>
          
          <!--- /CFIF FOR STEP 3 --->
          </cfif>
          
          
          <cfif step is "4">
          
          <cfset errormessage=15>
          
          <cftransaction>
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_name#' , applied='2'where parameter='server_name'
          </cfquery>
          <cfquery name="update" datasource="hermes">
          update parameters2 set value2='#show_server_domain#', applied='2' where parameter='server_domain'
          </cfquery>
          </cftransaction>
          
          <!--- /CFIF FOR STEP 4 --->
          </cfif>
          
          <!--- /CFIF FOR show_action--->
          </cfif>
          
          <!--- UPDATE SECTION ENDS HERE --->
          
          <!--- APPLY SECTION STARTS HERE --->
          
          <cfif #show_action2# is "apply" and #show_network_mode# is "static">

          <cftry>
       
         <!--- Set Interface name --->
         <cfexecute name="/opt/hermes/scripts/get_network_interface.sh"
         variable="thenetworkinterface"
         timeout="10" />
                
          <cfcatch type="any">
          
          <cfset m="View Network Settings: There was an error execuring /opt/hermes/scripts/get_network_interface.sh">
          <cfinclude template="error.cfm">
          <cfabort>   
          
          </cfcatch>
          </cftry>
          
            <cfset THEINTERFACE = "#TRIM(thenetworkinterface)#">
            
            <cfset THENETCOMMAND = "/usr/sbin/netplan apply">
            
            <cfset THENETWORKFILE = "/etc/netplan/50-cloud-init.yaml">
            
            <cfset THEINTFILE = "50-cloud-init.yaml">
            
            <cfquery name="getsystoken" datasource="hermes">
            select token from api_tokens where system='1' and active='1'
            </cfquery>

            <cfif #getsystoken.recordcount# EQ 1>

            <cfif #getsystoken.token# is "">

            <cfset m="View Network Settings: getsystoken.token is blank">
            <cfinclude template="error.cfm">
            <cfabort>
            
          <cfelse>

          <cfset THETOKEN = "#getsystoken.token#">

          <!--- #getsystoken.token# is --->
          </cfif>

            <cfelse>

            <cfset m="View Network Settings: getsystoken.recordcount NEQ 1">
            <cfinclude template="error.cfm">
            <cfabort>

            <!--- /CFIF #getsystoken.recordcount# --->
            </cfif>
            
          
            <cfset errormessage=16>
            
            <!--- GET PARAMETERS FROM PARAMETERS2 TABLE BELOW --->

            <cfinclude template="./inc/get_network_parameters.cfm" />
               
            <cfquery name="update" datasource="hermes">
            update parameters2 set applied='1' where module='network'
            </cfquery>
            
            <cfset ServerAddress="#server_ip.value2#">
            <cfset ServerGateway="#server_gateway.value2#">
            <cfset ServerDns1="#server_dns1.value2#">
            <cfif #server_dns2.value2# is not "">
            <cfset ServerDns2="#server_dns2.value2#">
            <cfelseif #server_dns2.value2# is "">
            <cfset ServerDns2="">
            </cfif>
            <cfif #server_dns3.value2# is not "">
            <cfset ServerDns3="#server_dns3.value2#">
            <cfelseif #server_dns3.value2# is "">
            <cfset ServerDns3="">
            </cfif>
            <cfset ServerName="#server_name.value2#">
            <cfset ServerDomain="#server_domain.value2#">
            <cfset ServerSubnet="#server_subnet.value2#">
            
            <!--- GET PARAMETERS FROM PARAMETERS2 TABLE ABOVE --->
            
            <!--- Update Postfix Parameters Below --->

            <cfinclude template="./inc/update_postfix_network_parameters.cfm" />

            <!--- Update Postfix Parameters Above --->
            
            <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
            select random_letter as random from captcha_list_all2 order by RAND() limit 8
            </cfquery>
            
            <cfquery name="inserttrans" datasource="hermes" result="stResult">
            insert into salt
            (salt)
            values
            ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
            </cfquery>
            
            <cfquery name="gettrans" datasource="hermes">
            select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
            </cfquery>
            
            <cfset customtrans3=#gettrans.customtrans2#>
            
            <cfquery name="deletetrans" datasource="hermes">
            delete from salt where id='#stResult.GENERATED_KEY#'
            </cfquery>
            
          
            <!--- MODIFY /etc/netplan/50-cloud-init.yaml BELOW --->
            
            <cfinclude template="./inc/modify_network_interface.cfm" />
            
            <!--- MODIFY /etc/netplan/50-cloud-init.yaml ABOVE --->
            
            <!--- MODIFY /etc/amavis/conf.d/50-user BELOW --->
            
            <cfinclude template="./inc/update_amavis_config_files.cfm" />
            
             <!--- MODIFY /etc/amavis/conf.d/50-user ABOVE --->
            
            <!--- MODIFY /opt/hermes/conf_files/hosts BELOW --->
          
            <cfinclude template="./inc/modify_hosts.cfm" />
          
            <!--- MODIFY /opt/hermes/conf_files/hosts ABOVE --->
            
            <!--- Create Network Restart Script BELOW  which will update Auth Nginx, Nginx, authelia, Console IP and Ciphermail via API ---> 
            
            <cfinclude template="./inc/create_network_restart_script.cfm" />
          
            <!--- Create Network Restart Script ABOVE ---> 
          
            
            <cfelseif #show_action2# is "apply" and #show_network_mode# is "dhcp">
            
              <cftry>
       
                <!--- Set Interface name --->
                <cfexecute name="/opt/hermes/scripts/get_network_interface.sh"
                variable="thenetworkinterface"
                timeout="10" />
                       
                 <cfcatch type="any">
                 
                 <cfset m="View Network Settings: There was an error execuring /opt/hermes/scripts/get_network_interface.sh">
                 <cfinclude template="error.cfm">
                 <cfabort>   
                 
                 </cfcatch>
                 </cftry>
                 
                   <cfset THEINTERFACE = "#TRIM(thenetworkinterface)#">
                   
                   <cfset THENETCOMMAND = "/usr/sbin/netplan apply">
                   
                   <cfset THENETWORKFILE = "/etc/netplan/50-cloud-init.yaml">
                   
                   <cfset THEINTFILE = "50-cloud-init.yaml">
                   
                   <cfquery name="getsystoken" datasource="hermes">
                   select token from api_tokens where system='1' and active='1'
                   </cfquery>
       
                   <cfif #getsystoken.recordcount# EQ 1>
       
                   <cfif #getsystoken.token# is "">
       
                   <cfset m="View Network Settings: getsystoken.token is blank">
                   <cfinclude template="error.cfm">
                   <cfabort>
                   
                 <cfelse>
       
                 <cfset THETOKEN = "#getsystoken.token#">
       
                 <!--- #getsystoken.token# is --->
                 </cfif>
       
                   <cfelse>
       
                   <cfset m="View Network Settings: getsystoken.recordcount NEQ 1">
                   <cfinclude template="error.cfm">
                   <cfabort>
       
                   <!--- /CFIF #getsystoken.recordcount# --->
                   </cfif>
            

            
            <cfset errormessage=16>
            
            <!--- GET PARAMETERS FROM PARAMETERS2 TABLE BELOW --->

            <cfinclude template="./inc/get_network_parameters.cfm" />
      
            <cfquery name="update" datasource="hermes">
            update parameters2 set applied='1' where module='network'
            </cfquery>
            
            <cfset ServerName="#server_name.value2#">
            <cfset ServerDomain="#server_domain.value2#">
          
              <!--- GET PARAMETERS FROM PARAMETERS2 TABLE ABOVE --->
            
            <!--- Update Postfix Parameters Below --->

            <cfinclude template="./inc/update_postfix_network_parameters.cfm" />

            <!--- Update Postfix Parameters Above --->
            
            <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
            select random_letter as random from captcha_list_all2 order by RAND() limit 8
            </cfquery>
            
            <cfquery name="inserttrans" datasource="hermes" result="stResult">
            insert into salt
            (salt)
            values
            ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
            </cfquery>
            
            <cfquery name="gettrans" datasource="hermes">
            select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
            </cfquery>
            
            <cfset customtrans3=#gettrans.customtrans2#>
            
            <cfquery name="deletetrans" datasource="hermes">
            delete from salt where id='#stResult.GENERATED_KEY#'
            </cfquery>
            
           
            
            <!--- MODIFY /etc/netplan/50-cloud-init.yaml BELOW --->
            
            <cfinclude template="./inc/modify_network_interface.cfm" />
            
            <!--- MODIFY /etc/netplan/50-cloud-init.yaml ABOVE --->
            
            <!--- MODIFY /etc/amavis/conf.d/50-user BELOW --->
            
            <cfinclude template="./inc/update_amavis_config_files.cfm" />
            
             <!--- MODIFY /etc/amavis/conf.d/50-user ABOVE --->
            
            <!--- MODIFY /opt/hermes/conf_files/hosts BELOW --->
          
            <cfinclude template="./inc/modify_hosts.cfm" />
          
            <!--- MODIFY /opt/hermes/conf_files/hosts ABOVE --->
            
            <!--- Create Network Restart Script BELOW  which will update Auth Nginx, Nginx, authelia, Console IP and Ciphermail via API---> 
            
            <cfinclude template="./inc/create_network_restart_script.cfm" />
          
            <!--- Create Network Restart Script ABOVE ---> 
          
            <!--- /CFIF FOR #show_action2# is "apply" --->
            </cfif>
          
            <!--- APPLY SECTION ENDS HERE --->
          
          <!-- CFML CODE ENDS HERE -->
          
          
          <!-- ERROR MESSAGES START HERE -->
          
          <cfif #errormessage# is "1"> 
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid Server IP Address</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "2">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The Server IP Address fields cannot be blank</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "3">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid Server Gateway Address</cfoutput>
              </div>
          
          </cfif>
          
          
          <cfif #errormessage# is "4">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The Server Gateway Address fields cannot be blank</cfoutput>
              </div>
          
          </cfif>
          
          
          <cfif #errormessage# is "5">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid Server DNS1 Address</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "6">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The Server DNS1 Address fields cannot be blank</cfoutput>
              </div>
          
          </cfif>
          
          <!---
          <cfif #errormessage# is "7">
          
              <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-check"></i> Success!</h4>
                <cfoutput>Mailbox Created</cfoutput>
              </div>
          
          </cfif>
          
          --->
          
          <cfif #errormessage# is "7">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid DNS2 Address</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "8">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The DNS2 fields cannot be blank</cfoutput>
              </div>
          
          </cfif>
          
          
          <cfif #errormessage# is "9">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invald DNS3 Address</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "10">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The DNS3 fields cannot be blank</cfoutput>
              </div>
          
          </cfif>
          
          <cfif #errormessage# is "11">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid Server Domain</cfoutput>
              </div>
          
          </cfif>
          
          
          
          <cfif #errormessage# is "12">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The Server Domain field canot be blank</cfoutput>
              </div>
          
          </cfif>
          
          
          <cfif #errormessage# is "13">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>You have entered an invalid Server Name</cfoutput>
              </div>
          
          </cfif>
          
          
          
          <cfif #errormessage# is "14">
          
              <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                <cfoutput>The Server Name field cannot be blank</strong></cfoutput>
              </div>
          
          </cfif>
          
          
          <cfif #errormessage# is "15">
          
              <div class="alert alert-warning alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-exclamation-triangle"></i> Success!</h4><br>
                <cfoutput>Changes Saved. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. If you have changed the system IP address and you access the system via the IP Address ensure you connect to the <strong>New IP Address</strong>. If you changed the system IP address and you access the system via Host Name, ensure the new IP address is updated in DNS.</cfoutput>
             
                <cfquery name="getapplied" datasource="hermes">
                  select * from parameters2 where module='network' and active='1' and applied='2'
                  </cfquery>
          
          <cfif #getapplied.recordcount# GTE 1>
              
                  <!--- <p class="help-block">Help Block Text</p> --->
                  <form action="" method="post">
                      <input type="hidden" name="action2" value="apply">
                      <cfoutput>
                      <input type="hidden" name="network_mode" value="#show_network_mode#">
                      </cfoutput>


                      <div class="text-center">
                        <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
                      </div>
                  </form>
                   
                  <!--- /CFIF for getapplied.recordcount --->
                  </cfif>
              </div>
          
              
          <!--- /CFIF for errormessage is "15" --->
          </cfif>
          
              <cfif #errormessage# is "16">
          
                  <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-check"></i> Success!</h4>
                    <cfoutput>Changes Applied.</cfoutput>
                  </div>
              </cfif>
          
                  <cfif #errormessage# is "17">
          
                      <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                        <cfoutput>The system is not able to save your settings because the Hermes MySQL Database Username is not defined. Please navigate to System -->System Settings and specify a username for the Hermes MySQL Database</strong></cfoutput>
                      </div>
                  
                  </cfif>
          
          <!-- ERROR MESSAGES END HERE -->

          <!-- UPDATE NETWORK SETTINGS FORM STARTS HERE -->
          
          <!-- form start -->
          <form name="network_settings" action="" method="post">
            <input type="hidden" name="action" value="edit">
         

                <div class="form-group">
                  <label><strong>Network Mode</strong></label>
              
                  <select class="form-control" name="network_mode" data-placeholder="network_mode" style="width: 100%;"  id="setNetworkMode">
                    <cfif #show_network_mode# is "static">                           
                      <option value="static" selected>Static</option>
                      <option value="dhcp">DHCP</option>
                    <cfelseif #show_network_mode# is "dhcp">
                      <option value="dhcp" selected>DHCP</option>
                      <option value="static">Static</option></option>
                    </cfif>
                      </select>   
              
                    </div>
    
                 
                <cfoutput>
                <div class="form-group">
                  <label for="server_name"><strong>Hostname</strong></label>
                  <input type="text" class="form-control" name="server_name" value="#show_server_name#" id="server_name" placeholder="Enter Server Name without domain">
                </div>
                </cfoutput>
          
                
                  <cfoutput>
                      <div class="form-group">
                        <label for="server_domain"><strong>Primary Domain Name</strong></label>
                        <input type="text" class="form-control" name="server_domain" value="#show_server_domain#" id="server_domain" placeholder="Enter Server Domain (Ex: domain.tld)">
                      </div>
                      </cfoutput>
          
               <cfif #show_network_mode# is "static">

                      <cfoutput>
                          <div class="form-group" id="NetworkMode">

                            <label for="server_ip"><strong>IP Address</strong></label>
                            <input type="text" class="form-control" name="server_ip" value="#show_server_ip#" placeholder="Enter Server IP Address (Ex: 192.168.0.1)" >
                     
                          </cfoutput>
          
                
                      <cfif #show_server_subnet# is "">
                          <cfset default_value="24">
                          <cfset default_mask="/24 (255.255.255.0)">

                      <cfelseif #show_server_subnet# is not "">
                          <cfquery name="getmask" datasource="hermes">
                          select mask,value3 from subnet where value3='#show_server_subnet#'
                          </cfquery>
                          <cfset default_value="#getmask.value3#">
                          <cfset default_mask="#getmask.mask#">
                          
                          <!--- /CFIF for #show_server_subnet# is --->
                          </cfif>
                          
                          <cfquery name="getsubnet" datasource="hermes">
                          select * from subnet where value3 <> '#default_value#' order by value2 asc
                          </cfquery>
          
            
                              <label><strong>Subnet Mask</strong></label>
                              <select class="form-control select2" name="server_subnet" data-placeholder="Subnet Mask"
                                      style="width: 100%;">
                                <cfoutput><option value="#default_value#" selected="selected">#default_mask#</option></cfoutput>
                                <cfoutput query="getsubnet">
                                  <option value="#value3#">#mask#</option>
                                  </cfoutput>
                                  </select>
                           
                              
          
                       
                                      <cfoutput>
                                      
                                            <label for="server_gateway"><strong>Gateway</strong></label>
                                            <input type="text" class="form-control" name="server_gateway" value="#show_server_gateway#" id="server_gateway" placeholder="Enter Server Gateway Address (Ex: 192.168.0.1)" >
                                      
                                          </cfoutput>
                          
                            
                                
                                      
                               
                              
                                          <cfoutput>
                                       
                                                <label for="server_dns1"><strong>DNS1</strong></label>
                                                <input type="text" class="form-control" name="server_dns1" value="#show_server_dns1#" id="server_dns1" placeholder="Enter Server DNS1 Address (Ex: 192.168.0.1)" >
                                          
                                              </cfoutput>
                                   
          
                                    
                                              <cfoutput>
                                            
                                                    <label for="server_dns2"><strong>DNS2</strong></label>
                                                    <input type="text" class="form-control" name="server_dns2" value="#show_server_dns2#" id="server_dns2" placeholder="Enter Server DNS2 Address (Ex: 192.168.0.1)" >
                                             
                                                  </cfoutput>
                                  
                                            
                                                  <cfoutput>
                                                
                                                        <label for="server_dns3"><strong>DNS3</strong></label>
                                                        <input type="text" class="form-control" name="server_dns3" value="#show_server_dns3#" id="server_dns3" placeholder="Enter Server DNS3 Address (Ex: 192.168.0.1)" >
                                                   
                                                      </cfoutput>
                                      
                             <!--- /DIV  <div class="form-group" id="NetworkMode"> --->            
                            </div>


                          <cfelseif #show_network_mode# is "dhcp">

                              <cfoutput>
                                  <div class="form-group" id="NetworkMode" style="display:none;">
        
                                    <label for="server_ip"><strong>IP Address</strong></label>
                                    <input type="text" class="form-control" name="server_ip" value="#show_server_ip#" placeholder="Enter Server IP Address (Ex: 192.168.0.1)" >
                             
                                  </cfoutput>
                  
                        
                              <cfif #show_server_subnet# is "">
                                  <cfset default_value="24">
                                  <cfset default_mask="/24 (255.255.255.0)">
        
                              <cfelseif #show_server_subnet# is not "">
                                  <cfquery name="getmask" datasource="hermes">
                                  select mask,value3 from subnet where value3='#show_server_subnet#'
                                  </cfquery>
                                  <cfset default_value="#getmask.value3#">
                                  <cfset default_mask="#getmask.mask#">
                                  
                                  <!--- /CFIF for #show_server_subnet# is --->
                                  </cfif>
                                  
                                  <cfquery name="getsubnet" datasource="hermes">
                                  select * from subnet where value3 <> '#default_value#' order by value2 asc
                                  </cfquery>
                  
                    
                                      <label><strong>Subnet Mask</strong></label>
                                      <select class="form-control select2" name="server_subnet" data-placeholder="Subnet Mask"
                                              style="width: 100%;">
                                        <cfoutput><option value="#default_value#" selected="selected">#default_mask#</option></cfoutput>
                                        <cfoutput query="getsubnet">
                                          <option value="#value3#">#mask#</option>
                                          </cfoutput>
                                          </select>
                                   
                                      
                  
                               
                                              <cfoutput>
                                              
                                                    <label for="server_gateway"><strong>Gateway</strong></label>
                                                    <input type="text" class="form-control" name="server_gateway" value="#show_server_gateway#" id="server_gateway" placeholder="Enter Server Gateway Address (Ex: 192.168.0.1)" >
                                              
                                                  </cfoutput>
                                  
                                    
                                        
                                              
                                       
                                      
                                                  <cfoutput>
                                               
                                                        <label for="server_dns1"><strong>DNS1</strong></label>
                                                        <input type="text" class="form-control" name="server_dns1" value="#show_server_dns1#" id="server_dns1" placeholder="Enter Server DNS1 Address (Ex: 192.168.0.1)" >
                                                  
                                                      </cfoutput>
                                           
                  
                                            
                                                      <cfoutput>
                                                    
                                                            <label for="server_dns2"><strong>DNS2</strong></label>
                                                            <input type="text" class="form-control" name="server_dns2" value="#show_server_dns2#" id="server_dns2" placeholder="Enter Server DNS2 Address (Ex: 192.168.0.1)" >
                                                     
                                                          </cfoutput>
                                          
                                                    
                                                          <cfoutput>
                                                        
                                                                <label for="server_dns3"><strong>DNS3</strong></label>
                                                                <input type="text" class="form-control" name="server_dns3" value="#show_server_dns3#" id="server_dns3" placeholder="Enter Server DNS3 Address (Ex: 192.168.0.1)" >
                                                           
                                                              </cfoutput>
                                              
                                     <!--- /DIV  <div class="form-group" id="NetworkMode"> --->            
                                    </div>
        

                            



                          <!--- /CFIF #show_network_mode# is "" --->
                          </cfif>
          
            
          <!--- <p class="help-block">Help Block Text</p> --->


              <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

              
            </form>

            <div>&nbsp;</div>
          
          <!-- UPDATE NEWORK SETTINGS FORM ENDS HERE -->

        
    
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

<!--- SCRIPT TO SHOW/HIDE STAIC SCRIPT STARTS HERE  --->
<script>

  $('#setNetworkMode').on('change',function(){
    if( $(this).val()==="static"){
    $("#NetworkMode").show()
    }
    else{
    $("#NetworkMode").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE STATIC SCRIPT ENDS HERE  --->

</html>