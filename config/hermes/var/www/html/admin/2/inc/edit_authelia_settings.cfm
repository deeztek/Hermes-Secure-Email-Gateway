
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

<!--- VALIDATE FORM INPUTS STARTS HERE --->
 
    
<!--- ACCESS CONTROL NO LONGER A GLOBAL SETTING BUT SET ON A PER USER BASIS  --->
<!---
    <cfif NOT StructKeyExists(form, "access_control_rules_policy")>
    
    <cfset m="Edit Authentication Settings: form.access_control_rules_policy does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
  
    <cfelse>
  
    <cfif #form.access_control_rules_policy# is "one_factor" OR #form.access_control_rules_policy# is "two_factor">
  
    <cfelse>
      
      <cfset m="Edit Authentication Settings: form.access_control_rules_policy is not one_factor or two_factor">
      <cfinclude template="error.cfm">
      <cfabort>
  
    <!--- /CFIF #form.access_control_rules_policy# is not "one_factor" OR #form.access_control_rules_policy# is not "two_factor" --->
    </cfif>
    
    <!--- /CFIF StructKeyExists(form, "access_control_rules_policy") --->
    </cfif>
  --->
    
    <cfif NOT StructKeyExists(form, "authentication_backend_disable_reset_password")>
    
    <cfset m="Edit Authentication Settings: authentication_backend_disable_reset_password does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
  
  <cfelse>
  
    <cfif #form.authentication_backend_disable_reset_password# is "true" OR #form.authentication_backend_disable_reset_password# is "false">
  
    <cfelse>
      
      <cfset m="Edit Authentication Settings: form.authentication_backend_disable_reset_password is not true or false">
      <cfinclude template="error.cfm">
      <cfabort>
  
    <!--- /CFIF #form.authentication_backend_disable_reset_password# is "true" OR #form.authentication_backend_disable_reset_password# is "false" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "authentication_backend_disable_reset_password") --->
    </cfif>

    <!--- UPDATE RESET PASSWORD SETTING --->
    <cfquery name="update_disable_reset_password" datasource="hermes">
      UPDATE parameters2 SET value2 = '#form.authentication_backend_disable_reset_password#', applied = '2'
      WHERE parameter = 'authentication_backend.disable_reset_password' AND module = 'authelia'
    </cfquery>


    <cfif NOT StructKeyExists(form, "session_name")>
    
      <cfset m="Edit Authentication Settings: form.session_name does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
      
      <!--- /CFIF StructKeyExists(form, "session_name") --->
      </cfif>
    
        
        <cfif NOT StructKeyExists(form, "session_expiration")>
      
          <cfset m="Edit Authentication Settings: form.session_expiration does not exist">
          <cfinclude template="error.cfm">
          <cfabort>
          
          <!--- /CFIF StructKeyExists(form, "session_expiration") --->
          </cfif>
    
          <cfif NOT StructKeyExists(form, "session_inactivity")>
      
            <cfset m="Edit Authentication Settings: form.session_inactivity does not exist">
            <cfinclude template="error.cfm">
            <cfabort>
            
            <!--- /CFIF StructKeyExists(form, "session_inactivity") --->
            </cfif>
    
       
    <cfif NOT StructKeyExists(form, "notifier_smtp_sender")>
      
      <cfset m="Edit Authentication Settings: form.notifier_smtp_sender does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "notifier_smtp_sender") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "notifier_smtp_subject")>
      
      <cfset m="Edit Authentication Settings: form.notifier_smtp_subject does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "notifier_smtp_subject") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "regulation_max_retries")>
      
      <cfset m="Edit Authentication Settings: form.regulation_max_retries does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "regulation_max_retries") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "regulation_find_time")>
      
      <cfset m="Edit Authentication Settings: form.regulation_find_time does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "regulation_find_time") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "regulation_ban_time")>
      
      <cfset m="Edit Authentication Settings: form.regulation_ban_time does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "regulation_ban_time") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "log_level")>
      
      <cfset m="Edit Authentication Settings: form.log_level does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
  
  <cfif #form.log_level# is "debug" OR #form.log_level# is "info" OR #form.log_level# is "trace" OR #form.log_level# is "warn" OR #form.log_level# is "error">
  
      <cfelse>
  
        <cfset m="Edit Authentication Settings: form.log_level is not debug, info, warn, error or trace">
        <cfinclude template="error.cfm">
        <cfabort>
  
    <!--- /CFIF  #form.log_level# is "debug" OR #form.log_level# is "info" OR #form.log_level# is "trace" OR #form.log_level# is "warn" OR #form.log_level# is "error" --->
  </cfif>
              
    <!--- /CFIF StructKeyExists(form, "log_level") --->
    </cfif>
    
    <cfif NOT StructKeyExists(form, "log_format")>
      
      <cfset m="Edit Authentication Settings: form.log_format does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
  
      <cfif #form.log_format# is "json" OR #form.log_format# is "text">
  
      <cfelse>
  
        <cfset m="Edit Authentication Settings: form.log_format is not json or text">
        <cfinclude template="error.cfm">
        <cfabort>
  
     <!--- /CFIF #form.log_format# is "json" OR #form.log_format# is "text" --->
    </cfif>
    
              
    <!--- /CFIF StructKeyExists(form, "log_format") --->
    </cfif>


    <cfif NOT StructKeyExists(form, "duo_disable")>
      
      <cfset m="Edit Authentication Settings: form.duo_disable does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
  
      <cfif #form.duo_disable# is "true" OR #form.duo_disable# is "false">
  
      <cfelse>
  
        <cfset m="Edit Authentication Settings: form.duo_disable is not true or false">
        <cfinclude template="error.cfm">
        <cfabort>
  
     <!--- /CFIF #form.duo_disable# is "true" OR #form.duo_disable# is "false" --->
    </cfif>
    
              
    <!--- /CFIF StructKeyExists(form, "duo_disable") --->
    </cfif>


  <cfif #form.duo_disable# is "false">

  <cfif NOT StructKeyExists(form, "duo_hostname")>
      
  <cfset m="Edit Authentication Settings: form.duo_hostname does not exist when form.duo_disable is false">
  <cfinclude template="error.cfm">
  <cfabort>

    <!--- /CFIF StructKeyExists(form, "duo_hostname") --->
  </cfif>

 
      <cfif NOT StructKeyExists(form, "duo_self_enrollment")>
      
        <cfset m="Edit Authentication Settings: form.duo_self_enrollment does not exist when form.duo_disable is false">
        <cfinclude template="error.cfm">
        <cfabort>

        <cfif #form.duo_self_enrollment# is "true" OR #form.duo_self_enrollment# is "false">
  
        <cfelse>
    
          <cfset m="Edit Authentication Settings: form.duo_self_enrollment is not true or false">
          <cfinclude template="error.cfm">
          <cfabort>
    
       <!--- /CFIF #form.duo_self_enrollment# is "true" OR #form.duo_self_enrollment# is "false" --->
      </cfif>
      
          <!--- /CFIF StructKeyExists(form, "duo_self_enrollment") --->
        </cfif>


  <!--- /CFIF #form.duo_disable# is "false" --->
    </cfif>
    
  
    <!--- VALIDATE FORM INPUTS ENDS HERE --->
  
 
  <cfif #form.session_name# is "">
  
  <cfset step=0>
  <cfset session.m=4>
  
  <cfoutput>
  <cflocation url="#cgi.http_referer#" addtoken="no">
  </cfoutput>
  
  <cfelse>
  
  <cfif REFind("[^A-Za-z0-9\_\-]",form.session_name) gt 0>
  
  <cfset step=0>
  <cfset session.m=5>
  
  <cfoutput>
  <cflocation url="#cgi.http_referer#" addtoken="no">
  </cfoutput>
  
  <cfelse>
  
  <cfquery name="update" datasource="hermes">
  update parameters2 set value2='#form.session_name#', applied='2' where parameter='session.name'
  </cfquery>
  
  <cfset step=1>
  
  <!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.session_name) gt 0>  --->
  </cfif>
  
  <!--- /CFIF #form.session_name# is ""  --->
  </cfif>
  

  
  
  <cfif #step# is "1">
  
    <cfif #form.session_expiration# is "">
  
      <cfset step=0>
      <cfset session.m=9>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
  
    <cfelse>
  
    <cfif REFind("[^0-9]",form.session_expiration) gt 0>
    
    <cfset step=0>
    <cfset session.m=10>
    
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    
    <cfelse>
  
    <cfquery name="update" datasource="hermes">
    update parameters2 set value2='#form.session_expiration#', applied='2' where parameter='session.expiration'
    </cfquery>
    
    <cfset step=2>
    
    <!--- /CFIF REFind("[^0-9-]",form.session_expiration) gt 0>  --->
    </cfif>
      
    <!--- /CFIF #form.session_expiration# is "" --->
  </cfif>
    
    <!--- /CFIF step is 1 --->
    </cfif>
  
  
  
    <cfif #step# is "2">
  
  <cfif #form.session_inactivity# is "">
    
    <cfset step=0>
    <cfset session.m=11>
    
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
  
  <cfelse>
  
      <cfif REFind("[^0-9]",form.session_inactivity) gt 0>
      
      <cfset step=0>
      <cfset session.m=12>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
      
      <cfelse>
  
      <cfquery name="update" datasource="hermes">
      update parameters2 set value2='#form.session_inactivity#', applied='2' where parameter='session.inactivity'
      </cfquery>
      
      <cfset step=3>
      
      <!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.session_inactivity) gt 0>  --->
      </cfif>
  
         <!--- /CFIF #form.session_inactivity# is "" --->
        </cfif>
      
      <!--- /CFIF step is 2 --->
      </cfif>
  
  
      
  
                  <cfif #step# is "3">
  
                    <cfif #form.notifier_smtp_sender# is "">
                      
                      <cfset step=0>
                      <cfset session.m=17>
                      
                      <cfoutput>
                      <cflocation url="#cgi.http_referer#" addtoken="no">
                      </cfoutput>
                    
                    <cfelse>
  
                     <cfif NOT isValid("email", form.notifier_smtp_sender)> 
                        
                        <cfset step=0>
                        <cfset session.m=18>
                        
                        <cfoutput>
                        <cflocation url="#cgi.http_referer#" addtoken="no">
                        </cfoutput>
                        
                        <cfelse>
                    
                        <cfquery name="update" datasource="hermes">
                        update parameters2 set value2='#form.notifier_smtp_sender#', applied='2' where parameter='notifier.smtp.sender'
                        </cfquery>
                        
                        <cfset step=4>
                        
                        <!--- /CFIF NOT isValid("email", form.notifier_smtp_sender  --->
                        </cfif>
                    
                           <!--- /CFIF #form.notifier_smtp_sender# is "" --->
                          </cfif>
                        
                        <!--- /CFIF step is 3 --->
                        </cfif>
  
                        <cfif #step# is "4">
  
                          <cfif #form.notifier_smtp_subject# is "">
                            
                            <cfset step=0>
                            <cfset session.m=19>
                            
                            <cfoutput>
                            <cflocation url="#cgi.http_referer#" addtoken="no">
                            </cfoutput>
                          
                          <cfelse>
                          
                              <cfif REFind("[^A-Za-z0-9\_\-\[\]\{\}\ ]",form.notifier_smtp_subject) gt 0>
                              
                              <cfset step=0>
                              <cfset session.m=20>
                              
                              <cfoutput>
                              <cflocation url="#cgi.http_referer#" addtoken="no">
                              </cfoutput>
                              
                              <cfelse>
                          
                              <cfquery name="update" datasource="hermes">
                              update parameters2 set value2='#form.notifier_smtp_subject#', applied='2' where parameter='notifier.smtp.subject'
                              </cfquery>
                              
                              <cfset step=5>
                              
                              <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",notifier_smtp_subject) gt 0>  --->
                              </cfif>
                          
                                 <!--- /CFIF #form.notifier_smtp_subject# is "" --->
                                </cfif>
                              
                              <!--- /CFIF step is 4 --->
                              </cfif>
  
  
                              <cfif #step# is "5">
  
                                <cfif #form.regulation_max_retries# is "">
                                  
                                  <cfset step=0>
                                  <cfset session.m=21>
                                  
                                  <cfoutput>
                                  <cflocation url="#cgi.http_referer#" addtoken="no">
                                  </cfoutput>
                                
                                <cfelse>
                                
                                    <cfif REFind("[^0-9]",form.regulation_max_retries) gt 0>
                                    
                                    <cfset step=0>
                                    <cfset session.m=22>
                                    
                                    <cfoutput>
                                    <cflocation url="#cgi.http_referer#" addtoken="no">
                                    </cfoutput>
                                    
                                    <cfelse>
                                
                                    <cfquery name="update" datasource="hermes">
                                    update parameters2 set value2='#form.regulation_max_retries#', applied='2' where parameter='notifier.regulation.max_retries'
                                    </cfquery>
                                    
                                    <cfset step=6>
                                    
                                    <!--- /CFIF REFind("^0-9\_\-\[\]\.]",regulation_max_retries) gt 0>  --->
                                    </cfif>
                                
                                       <!--- /CFIF #form.regulation_max_retries# is "" --->
                                      </cfif>
                                    
                                    <!--- /CFIF step is 5 --->
                                    </cfif>
                    
  
                                    <cfif #step# is "6">
  
                                      <cfif #form.regulation_find_time# is "">
                                        
                                        <cfset step=0>
                                        <cfset session.m=23>
                                        
                                        <cfoutput>
                                        <cflocation url="#cgi.http_referer#" addtoken="no">
                                        </cfoutput>
                                      
                                      <cfelse>
                                      
                                          <cfif REFind("[^0-9]",form.regulation_find_time) gt 0>
                                          
                                          <cfset step=0>
                                          <cfset session.m=24>
                                          
                                          <cfoutput>
                                          <cflocation url="#cgi.http_referer#" addtoken="no">
                                          </cfoutput>
                                          
                                          <cfelse>
                                      
                                          <cfquery name="update" datasource="hermes">
                                          update parameters2 set value2='#form.regulation_find_time#', applied='2' where parameter='regulation.find_time'
                                          </cfquery>
                                          
                                          <cfset step=7>
                                          
                                          <!--- /CFIF REFind("^0-9\_\-\[\]\.]",regulation_find_time) gt 0>  --->
                                          </cfif>
                                      
                                             <!--- /CFIF #form.regulation_find_time# is "" --->
                                            </cfif>
                                          
                                          <!--- /CFIF step is 6 --->
                                          </cfif>                 
            
  
                                          <cfif #step# is "7">
  
                                            <cfif #form.regulation_ban_time# is "">
                                              
                                              <cfset step=0>
                                              <cfset session.m=25>
                                              
                                              <cfoutput>
                                              <cflocation url="#cgi.http_referer#" addtoken="no">
                                              </cfoutput>
                                            
                                            <cfelse>
                                            
                                                <cfif REFind("[^0-9]",form.regulation_ban_time) gt 0>
                                                
                                                <cfset step=0>
                                                <cfset session.m=26>
                                                
                                                <cfoutput>
                                                <cflocation url="#cgi.http_referer#" addtoken="no">
                                                </cfoutput>
                                                
                                                <cfelse>
                                            
                                                <cfquery name="update" datasource="hermes">
                                                update parameters2 set value2='#form.regulation_ban_time#', applied='2' where parameter='regulation.ban_time'
                                                </cfquery>
                                                
                                                <cfset step=8>
                                                
                                                <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",regulation_ban_time) gt 0>  --->
                                                </cfif>
                                            
                                                   <!--- /CFIF #form.regulation_ban_time# is "" --->
                                                  </cfif>
                                                
                                                <!--- /CFIF step is 7 --->
                                                </cfif>   
                                                
  
                                                <cfif #step# is "8">
  
                                                  <!--- UPDATE LOG LEVEL AND LOG FORMAT DROP-DOWN FIELDS --->
                                                  <cfquery name="update" datasource="hermes">
                                                  update parameters2 set value2='#form.log_level#', applied='2' where parameter='log.level'
                                                  </cfquery>
                                                  
                                                  <cfquery name="update" datasource="hermes">
                                                  update parameters2 set value2='#form.log_format#', applied='2' where parameter='log.format'
                                                  </cfquery>

                                                  <!--- UPDATE LOG RETENTION DAYS --->
                                                  <cfif StructKeyExists(form, "log_retention_days") AND ListFind("7,15,30,60,90,120,180", form.log_retention_days)>
                                                    <cfquery datasource="hermes">
                                                      UPDATE parameters2 SET value2 = <cfqueryparam value="#form.log_retention_days#" cfsqltype="cf_sql_varchar">
                                                      WHERE module = 'authelia' AND parameter = 'log.retention_days'
                                                    </cfquery>
                                                  </cfif>

                                                  <cfset step=9>
                                                  
                                                  <!--- /CFIF step is 8 --->
                                                  </cfif>

                                                  <cfif #step# is "9">
  
                                                    <!--- UPDATE DUO DISABLE --->
                                                    <cfquery name="update" datasource="hermes">
                                                    update parameters2 set value2='#form.duo_disable#', applied='2' where parameter='duo.disable'
                                                    </cfquery>
                                                    
                                                                                                  
                                                    <cfset step=10>
                                                    
                                                    <!--- /CFIF step is 9 --->
                                                    </cfif>

                                          <cfif #form.duo_disable# is "false">

                                                  <cfif #step# is "10">

                                                    <cfif #form.duo_hostname# is "">
                                              
                                                      <cfset step=0>
                                                      <cfset session.m=34>
                                                      
                                                      <cfoutput>
                                                      <cflocation url="#cgi.http_referer#" addtoken="no">
                                                      </cfoutput>
                                                    
                                                    <cfelse>
                                                    
                                                    <cfoutput>
                                                    <cfset tempemail = "bob@#form.duo_hostname#">
                                                  </cfoutput>

                                                    <cfif not IsValid("email", tempemail)>
                                                    
                                                    <cfset step=0>
                                                    <cfset session.m=35>
                                                    
                                                    <cfoutput>
                                                    <cflocation url="#cgi.http_referer#" addtoken="no">
                                                    </cfoutput>
                                                    
                                                    <cfelse>
                                                    
                                                    <!--- UPDATE FIELD --->
                                                    <cfquery name="update" datasource="hermes">
                                                      update parameters2 set value2='#form.duo_hostname#', applied='2' where parameter='duo.hostname'
                                                      </cfquery>
                                                    
                                                    <cfset step=11>
                                                    
                                                    <!--- /CFIF #form.duo_hostname# is "" --->
                                                    </cfif>

                                                        <!--- /CFIF IsValid("email", tempemail) --->
                                                      </cfif>
                                                    
                                                                                            
                                                    <!--- /CFIF step 10 --->
                                                    </cfif>

  
                                            
                                                                <cfif #step# is "11">
  
                                                                  <!--- UPDATE DUO SELF ENROLLMENT --->
                                                                  <cfquery name="update" datasource="hermes">
                                                                  update parameters2 set value2='#form.duo_self_enrollment#', applied='2' where parameter='duo.self_enrollment'
                                                                  </cfquery>

                                                                  <!--- UPDATE DUO INTEGRATION KEY (if provided) --->
                                                                  <cfif StructKeyExists(form, "duo_integration_key") AND trim(form.duo_integration_key) is not "">
                                                                    <cffile action="write" file="/opt/hermes/keys/authelia_duo_api_integration_key_file"
                                                                      output="#trim(form.duo_integration_key)#" addnewline="no">
                                                                  </cfif>

                                                                  <!--- UPDATE DUO SECRET KEY (if provided) --->
                                                                  <cfif StructKeyExists(form, "duo_secret_key") AND trim(form.duo_secret_key) is not "">
                                                                    <cffile action="write" file="/opt/hermes/keys/authelia_duo_api_secret_key_file"
                                                                      output="#trim(form.duo_secret_key)#" addnewline="no">
                                                                  </cfif>

                                                                  <cfset step=12>

                                                                  <!--- /CFIF step is 11 --->
                                                                  </cfif>

                                                                <cfelseif #form.duo_disable# is "true">

                                                                  <cfset step=12>

                                                                 <!--- /CFIF form.duo_disable is "false/true" --->
                                                                </cfif>
  
                                                  <cfif step is "12">
  
                                                    <cfquery name = "updateauthentication" datasource="hermes">
                                                    update parameters2 set
                                                    applied='1'
                                                    where module = 'authelia'
                                                    </cfquery>

                                                   <cfinclude template="generate_nextcloud_configuration.cfm">
                            
                                                    <cfinclude template="restart_nextcloud.cfm">
                                                    
                                                    <cfinclude template="generate_authelia_configuration.cfm">
                            
                                                    <cfinclude template="restart_authelia.cfm">

                                                    <cfinclude template="restart_redis.cfm">

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
    thread = CreateObject("java", "java.lang.Thread"); 
    thread.sleep(10000); 
    </cfscript> 
                                                    
                                                    <cfset session.m=27>
                                                    
                                                 
                                                    
                                                    <!--- /CFIF for step 12 --->
                                                    </cfif>
  