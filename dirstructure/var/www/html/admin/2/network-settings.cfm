<h1>Network Settings</h1>
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
  
  
  <!--- GET UBUNTU VERSION BELOW - NOT USED ANYMORE --->
  
  <!--- NOT USED ANY MORE --->
  <!---
  <cfexecute name="/opt/hermes/scripts/get_ubuntu_version.sh"
  variable="theubuntuversion"
  timeout="10" />
  
  <cfset UBUNTUVERSION = "#TRIM(theubuntuversion)#">
  
  <!--- GET UBUNTU VERSION ABOVE --->
  --->
  
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
  
  <!--- GET HERMES USERNAME --->
  <cfquery name="get_mysql_username_hermes" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_username_hermes'
  </cfquery>
  
  <cfif #get_mysql_username_hermes.value# is "">
  <cfset step=0>
  <cfset errormessage=17>
  <cfelseif #get_mysql_username_hermes.value# is not "">
  <cfset step=1>
  
  <!--- /CFIF FOR get_mysql_username_hermes.value --->
  </cfif>
  
  <cfif step is "1">
  
  <!--- GET HERMES PASSWORD --->
  <cfquery name="get_mysql_password_hermes" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_password_hermes'
  </cfquery>
  
  <cfif #get_mysql_password_hermes.value# is "">
  <cfset step=0>
  <cfset errormessage=18>
  
  <cfelseif #get_mysql_password_hermes.value# is not "">
  
  <cfset step=2>
  
  <!--- /CFIF FOR get_mysql_password_hermes.value --->
  </cfif>
  
  <!--- /CFIF FOR STEP 1 --->
  </cfif>
  
  <cfif step is "2">
  
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
  
  <!--- /CFIF FOR STEP 2 --->
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
  
  <!--- GET HERMES USERNAME --->
  <cfquery name="get_mysql_username_hermes" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_username_hermes'
  </cfquery>
  
  <cfif #get_mysql_username_hermes.value# is "">
  <cfset step=0>
  <cfset errormessage=17>
  <cfelseif #get_mysql_username_hermes.value# is not "">
  <cfset mysqlusernamehermes=#get_mysql_username_hermes.value#>
  <cfset step=1>
  
  <!--- /CFIF FOR get_mysql_username_hermes.value --->
  </cfif>
  
  <cfif step is "1">
  
  <!--- GET HERMES PASSWORD --->
  <cfquery name="get_mysql_password_hermes" datasource="hermes">
  select parameter, value from system_settings where parameter='mysql_password_hermes'
  </cfquery>
  
  <cfif #get_mysql_password_hermes.value# is "">
  <cfset step=0>
  <cfset errormessage=18>
  
  <cfelseif #get_mysql_password_hermes.value# is not "">
  
  <!--- DECRYPT HERMES PASSWORD --->
  <cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>
  
  <cfset step=2>
  
  <!--- /CFIF FOR get_mysql_password_hermes.value --->
  </cfif>
  
  <!--- /CFIF FOR STEP 1 --->
  </cfif>
  
  <cfif step is "2">
  
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
  
  <!--- /CFIF FOR STEP 2 --->
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
  
    <!--- Set Interface name --->
    <cfexecute name="/opt/hermes/scripts/get_network_interface.sh"
    variable="thenetworkinterface"
    timeout="10" />
    
    <cfset THEINTERFACE = "#TRIM(thenetworkinterface)#">
    
    <cfset THENETCOMMAND = "/usr/sbin/netplan apply">
    
    <cfset THENETWORKFILE = "/etc/netplan/50-cloud-init.yaml">
    
    <cfset THEINTFILE = "50-cloud-init.yaml">
    
    
    
    <!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS BELOW --->
    
    <cfinclude template="../segcommon/validate_hermes_db_creds.cfm" />
    
    <!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS ABOVE --->
  
    
    
    <cfset errormessage=16>
    
    <!--- GET PARAMETERS FROM PARAMETERS2 TABLE BELOW --->
  
    <cfquery name="server_ip" datasource="hermes">
    select * from parameters2 where parameter='server_ip' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_gateway" datasource="hermes">
    select * from parameters2 where parameter='server_gateway' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns1" datasource="hermes">
    select * from parameters2 where parameter='server_dns1' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns2" datasource="hermes">
    select * from parameters2 where parameter='server_dns2' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_dns3" datasource="hermes">
    select * from parameters2 where parameter='server_dns3' and module='network' and active='1'
    </cfquery>
    
    
    <cfquery name="server_name" datasource="hermes">
    select * from parameters2 where parameter='server_name' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_domain" datasource="hermes">
    select * from parameters2 where parameter='server_domain' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_subnet" datasource="hermes">
    select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="get_sa_spam_subject_tag" datasource="hermes">
    select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_virus_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_banned_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_spam_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_bad_header_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
    </cfquery>
    
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
    <!--- Get myorigin parent parameter id --->
    <cfquery name="getmyoriginparent" datasource="hermes">
    select id from parameters where parameter='myorigin' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myorigin child parameter --->
    <cfquery name="updatemyorigin" datasource="hermes">
    update parameters set parameter='#ServerDomain#' where parent='#getmyoriginparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>
    
    <!--- Get myhostname parent parameter id --->
    <cfquery name="getmyhostnameparent" datasource="hermes">
    select id from parameters where parameter='myhostname' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myhostname child parameter --->
    <cfquery name="updatemyhostname" datasource="hermes">
    update parameters set parameter='#ServerName#' where parent='#getmyhostnameparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>
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
    
    <cfinclude template="../segcommon/modify_network_interface.cfm" />
    
    <!--- MODIFY /etc/netplan/50-cloud-init.yaml ABOVE --->
    
    <!--- MODIFY /etc/amavis/conf.d/50-user BELOW --->
    
    <cfinclude template="../segcommon/modify_amavis_50_user.cfm" />
    
     <!--- MODIFY /etc/amavis/conf.d/50-user ABOVE --->
    
    <!--- MODIFY /opt/hermes/conf_files/hosts BELOW --->
  
    <cfinclude template="../segcommon/modify_hosts.cfm" />
  
    <!--- MODIFY /opt/hermes/conf_files/hosts ABOVE --->
    
    <!--- Create Network Restart Script BELOW ---> 
    
    <cfinclude template="../segcommon/create_network_restart_script.cfm" />
  
    <!--- Create Network Restart Script ABOVE ---> 
  
    
    <cfelseif #show_action2# is "apply" and #show_network_mode# is "dhcp">
    
    
    <!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS BELOW --->
    
    <cfinclude template="../segcommon/validate_hermes_db_creds.cfm" />
    
    <!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS ABOVE --->
  
    
    
    <cfset errormessage=16>
    
    <!--- GET PARAMETERS FROM PARAMETERS2 TABLE BELOW --->
  
    <cfquery name="server_domain" datasource="hermes">
    select * from parameters2 where parameter='server_domain' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="server_subnet" datasource="hermes">
    select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
    </cfquery>
    
    <cfquery name="get_sa_spam_subject_tag" datasource="hermes">
    select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_virus_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_banned_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_spam_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="get_final_bad_header_destiny" datasource="hermes">
    select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
    </cfquery>
    
    <cfquery name="update" datasource="hermes">
    update parameters2 set applied='1' where module='network'
    </cfquery>
    
    <cfset ServerName="#server_name.value2#">
    <cfset ServerDomain="#server_domain.value2#">
  
      <!--- GET PARAMETERS FROM PARAMETERS2 TABLE ABOVE --->
    
    <!--- Update Postfix Parameters Below --->
    <!--- Get myorigin parent parameter id --->
    <cfquery name="getmyoriginparent" datasource="hermes">
    select id from parameters where parameter='myorigin' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myorigin child parameter --->
    <cfquery name="updatemyorigin" datasource="hermes">
    update parameters set parameter='#ServerDomain#' where parent='#getmyoriginparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>
    
    <!--- Get myhostname parent parameter id --->
    <cfquery name="getmyhostnameparent" datasource="hermes">
    select id from parameters where parameter='myhostname' and module='postfix' and conf_file='main.cf' and
     child='2'
    </cfquery>
    
    <!--- Update myhostname child parameter --->
    <cfquery name="updatemyhostname" datasource="hermes">
    update parameters set parameter='#ServerName#' where parent='#getmyhostnameparent.id#' and child='1' and
     module='postfix' and conf_file='main.cf'
    </cfquery>
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
    
    <cfinclude template="../segcommon/modify_network_interface.cfm" />
    
    <!--- MODIFY /etc/netplan/50-cloud-init.yaml ABOVE --->
    
    <!--- MODIFY /etc/amavis/conf.d/50-user BELOW --->
    
    <cfinclude template="../segcommon/modify_amavis_50_user.cfm" />
    
     <!--- MODIFY /etc/amavis/conf.d/50-user ABOVE --->
    
    <!--- MODIFY /opt/hermes/conf_files/hosts BELOW --->
  
    <cfinclude template="../segcommon/modify_hosts.cfm" />
  
    <!--- MODIFY /opt/hermes/conf_files/hosts ABOVE --->
    
    <!--- Create Network Restart Script BELOW ---> 
    
    <cfinclude template="../segcommon/create_network_restart_script.cfm" />
  
    <!--- Create Network Restart Script ABOVE ---> 
  
    
    
    
    <!--- /CFIF FOR #show_action2# is "apply" --->
    </cfif>
  
    <!--- APPLY SECTION ENDS HERE --->
  
  <!-- CFML CODE ENDS HERE -->
  
  
  <!-- CFML APPLICATION ALERTS STARTS HERE -->
  
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
        <h4><i class="icon fa fa-exclamation-triangle"></i> Success!</h4>
        <cfoutput>Changes Saved. You must click on the Apply Settings button below for the changes to take effect. If you have changed the system IP address, ensure you connect to the new IP address after you click the Apply Setings</cfoutput>
     
        <cfquery name="getapplied" datasource="hermes">
          select * from parameters2 where module='network' and active='1' and applied='2'
          </cfquery>
  
  <cfif #getapplied.recordcount# GTE 1>
      
          <!--- <p class="help-block">Help Block Text</p> --->
          <form action="index.cfm" method="post">
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
  
  <!-- CFML APPLICATION ALERTS ENDS HERE -->
  <form action="index.cfm" method="post">
  <!-- radio -->
  
               <!-- IF NETWORK MODE IS STATIC STARTS HERE -->
  
  
               <cfif #show_network_mode# is "static">
  
                  <div class="form-group">
                    <label for="network_mode"><strong>Network Mode</strong></label>
                    <div class="radio">
                      <label>
                        <input type="radio" name="network_mode" id="network_mode" value="static" checked onclick="this.form.submit();">
                       Static
                      </label>
                    <!-- div class="radio" -->
                  </div>
                    
                    
  
                    <div class="radio">
                      <label>
                        <input type="radio" name="network_mode" id="network_mode" value="dhcp" onclick="this.form.submit();">
                        DHCP
                      </label>
                     <!-- div class="radio" --></div>
  
                   <!--- <p class="help-block">Help Block Text</p> --->
                    
                  <!-- div class="form-group" -->
                </div>
  
                   <!-- IF NETWORK MODE IS STATIC ENDS HERE -->
  
                    <!-- IF NETWORK MODE IS DHCP STARTS HERE -->
  
                 <cfelseif #show_network_mode# is "dhcp">
  
                 <div class="form-group">
                  <label for="network_mode"><strong>Network Mode</strong></label>
                    <div class="radio">
                      <label>
                        <input type="radio" name="network_mode" id="network_mode" value="static" onclick="this.form.submit();">
                        Static
                      </label>
                    <!-- div class="radio" --></div>
  
  
                    <div class="radio">
                      <label>
                        <input type="radio" name="network_mode" id="network_mode" value="dhcp" checked onclick="this.form.submit();">
                        DHCP
                      </label>
                     <!-- div class="radio" --></div>
  
                 
                <!--- <p class="help-block">Help Block Text</p> ---->
                    
                  <!-- div class="form-group" --></div>
  
                   <!-- IF NETWORK MODE IS DHCP ENDS HERE -->
  
                </cfif>
  
  
               <!-- radio -->
  
              </form>
  
  
  <!-- UPDATE NETWORK SETTINGS FORM STARTS HERE -->
  
  
  <!-- form start -->
    <form action="index.cfm" method="post">
    <input type="hidden" name="action" value="edit">
      <div class="box-body">
         
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
                  <div class="form-group">
                    <label for="server_ip"><strong>IP Address</strong></label>
                    <input type="text" class="form-control" name="server_ip" value="#show_server_ip#" id="server_ip" placeholder="Enter Server IP Address (Ex: 192.168.0.1)" >
                  </div>
                  </cfoutput>
  
              <cfelseif #show_network_mode# is "dhcp">
                  <cfoutput>
                  <div class="form-group">
                    <label for="server_ip"><strong>IP Address</strong></label>
                    <input type="text" class="form-control" name="server_ip" value="#show_server_ip#" id="server_ip" placeholder="Enter Server IP Address (Ex: 192.168.0.1)" disabled="disabled">
                  </div>
                  </cfoutput>
              </cfif>
  
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
  
              <cfif #show_network_mode# is "static">
                  <div class="form-group">
                      <label><strong>Subnet Mask</strong></label>
                      <select class="form-control select2" name="server_subnet" data-placeholder="Subnet Mask"
                              style="width: 100%;">
                        <cfoutput><option value="#default_value#" selected="selected">#default_mask#</option></cfoutput>
                        <cfoutput query="getsubnet">
                          <option value="#value3#">#mask#</option>
                          </cfoutput>
                          </select>
  
                      <cfelseif #show_network_mode# is "dhcp">
                          <div class="form-group">
                              <label><strong>Subnet Mask</strong></label>
                              <select class="form-control select2" name="server_subnet" data-placeholder="Subnet Mask"
                                      style="width: 100%;" disabled="disabled">
                                <cfoutput><option value="#default_value#" selected="selected">#default_mask#</option></cfoutput>
                                <cfoutput query="getsubnet">
                                  <option value="#value3#">#mask#</option>
                                  </cfoutput>
                              </select>
                          </cfif>
  
                          <cfif #show_network_mode# is "static">
                              <cfoutput>
                                  <div class="form-group">
                                    <label for="server_gateway"><strong>Gateway</strong></label>
                                    <input type="text" class="form-control" name="server_gateway" value="#show_server_gateway#" id="server_gateway" placeholder="Enter Server Gateway Address (Ex: 192.168.0.1)" >
                                  </div>
                                  </cfoutput>
                  
                              <cfelseif #show_network_mode# is "dhcp">
                                  <cfoutput>
                                  <div class="form-group">
                                    <label for="server_gateway"><strong>Gateway</strong></label>
                                    <input type="text" class="form-control" name="server_gateway" value="#show_server_gateway#" id="server_gateway" placeholder="Enter Server Gateway Address (Ex: 192.168.0.1)" disabled="disabled">
                                  </div>
                                  </cfoutput>
                              </cfif>         
                       
                              <cfif #show_network_mode# is "static">
                                  <cfoutput>
                                      <div class="form-group">
                                        <label for="server_dns1"><strong>DNS1</strong></label>
                                        <input type="text" class="form-control" name="server_dns1" value="#show_server_dns1#" id="server_dns1" placeholder="Enter Server DNS1 Address (Ex: 192.168.0.1)" >
                                      </div>
                                      </cfoutput>
                      
                                  <cfelseif #show_network_mode# is "dhcp">
                                      <cfoutput>
                                      <div class="form-group">
                                        <label for="server_dns1"><strong>DNS1</strong></label>
                                        <input type="text" class="form-control" name="server_dns1" value="#show_server_dns1#" id="server_dns1" placeholder="Enter Server DNS1 Address (Ex: 192.168.0.1)" disabled="disabled">
                                      </div>
                                      </cfoutput>
                                  </cfif>       
  
                                  <cfif #show_network_mode# is "static">
                                      <cfoutput>
                                          <div class="form-group">
                                            <label for="server_dns2"><strong>DNS2</strong></label>
                                            <input type="text" class="form-control" name="server_dns2" value="#show_server_dns2#" id="server_dns2" placeholder="Enter Server DNS2 Address (Ex: 192.168.0.1)" >
                                          </div>
                                          </cfoutput>
                          
                                      <cfelseif #show_network_mode# is "dhcp">
                                          <cfoutput>
                                          <div class="form-group">
                                            <label for="server_dns2"><strong>DNS2</strong></label>
                                            <input type="text" class="form-control" name="server_dns2" value="#show_server_dns2#" id="server_dns2" placeholder="Enter Server DNS2 Address (Ex: 192.168.0.1)" disabled="disabled">
                                          </div>
                                          </cfoutput>
                                      </cfif>   
                                      
                                      <cfif #show_network_mode# is "static">
                                          <cfoutput>
                                              <div class="form-group">
                                                <label for="server_dns3"><strong>DNS3</strong></label>
                                                <input type="text" class="form-control" name="server_dns3" value="#show_server_dns3#" id="server_dns3" placeholder="Enter Server DNS3 Address (Ex: 192.168.0.1)" >
                                              </div>
                                              </cfoutput>
                              
                                          <cfelseif #show_network_mode# is "dhcp">
                                              <cfoutput>
                                              <div class="form-group">
                                                <label for="server_dns3"><strong>DNS3</strong></label>
                                                <input type="text" class="form-control" name="server_dns3" value="#show_server_dns3#" id="server_dns3" placeholder="Enter Server DNS3 Address (Ex: 192.168.0.1)" disabled="disabled">
                                              </div>
                                              </cfoutput>
                                          </cfif>       
                    </div>
  
      <div class="box-footer">
  <!--- <p class="help-block">Help Block Text</p> --->
        <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
      </div>
    </form>
  
  <!-- UPDATE NEWORK SETTINGS FORM ENDS HERE -->