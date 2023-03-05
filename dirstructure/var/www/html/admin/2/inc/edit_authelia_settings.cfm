
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
<cfif NOT StructKeyExists(form, "jwt_secret")>

    <cfset m="Edit Authentication Settings: form.jwt_secret does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
  
    <!--- /CFIF StructKeyExists(form, "jwt_secret") --->
    </cfif>

    <cfif NOT StructKeyExists(form, "storage_encryption_key")>

      <cfset m="Edit Authentication Settings: form.storage_encryption_key does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
    
      <!--- /CFIF StructKeyExists(form, "storage_encryption_key") --->
      </cfif>
  
    
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
  
    <!--- /CFIF #form.access_control_rules_policy# is not "one_factor" OR #form.access_control_rules_policy# is not "two_factor" --->
    </cfif>
    
    <!--- /CFIF StructKeyExists(form, "authentication_backend_disable_reset_password") --->
    </cfif>
    
    
    <cfif NOT StructKeyExists(form, "session_name")>
    
      <cfset m="Edit Authentication Settings: form.session_name does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
      
      <!--- /CFIF StructKeyExists(form, "session_name") --->
      </cfif>
    
      <cfif NOT StructKeyExists(form, "session_secret")>
      
        <cfset m="Edit Authentication Settings: form.session_secret does not exist">
        <cfinclude template="error.cfm">
        <cfabort>
        
        <!--- /CFIF StructKeyExists(form, "session_secret") --->
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
    
    <cfif NOT StructKeyExists(form, "notifier_smtp_host")>
      
    <cfset m="Edit Authentication Settings: form.notifier_smtp_host does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "notifier_smtp_host") --->
  </cfif>
    
    <cfif NOT StructKeyExists(form, "notifier_smtp_port")>
      
      <cfset m="Edit Authentication Settings: form.notifier_smtp_port does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
              
    <!--- /CFIF StructKeyExists(form, "notifier_smtp_port") --->
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

  <cfif NOT StructKeyExists(form, "duo_integration_key")>
      
    <cfset m="Edit Authentication Settings: form.integration_key does not exist when form.duo_disable is false">
    <cfinclude template="error.cfm">
    <cfabort>
  
      <!--- /CFIF StructKeyExists(form, "duo_integration_key") --->
    </cfif>

    <cfif NOT StructKeyExists(form, "duo_secret_key")>
      
      <cfset m="Edit Authentication Settings: form.duo_secret_key does not exist when form.duo_disable is false">
      <cfinclude template="error.cfm">
      <cfabort>
    
        <!--- /CFIF StructKeyExists(form, "duo_secret_key") --->
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
  
  <cfif #form.jwt_secret# is "">
  
    <cfset step=0>
    <cfset session.m=1>
    
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
  
  <cfelse>
  
  <cfif REFind("[^A-Za-z0-9]",form.jwt_secret) gt 0>
  
    <cfset step=0>
    <cfset session.m=2>
    
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
  
  <cfelse>
  
  <!--- CODE TO ENFORCE 24 CHARACTER LENGTH --->
  <cfif NOT ( len(form.jwt_secret) GTE 24)>
  <cfset step=0>
  <cfset session.m=3>
          
  <cfoutput>
  <cflocation url="#cgi.http_referer#" addtoken="no">
  </cfoutput>
  
  <cfelse>
  
  <cfquery name="update" datasource="hermes">
  update parameters2 set value2='#form.jwt_secret#', applied='2' where parameter='jwt_secret'
  </cfquery>
  
  <cfset step=1.5>
  
  <!--- /CFIF  #form.jwt_secret# is ""  --->
  </cfif>
  
  <!--- /CFIF  NOT ( len(form.jwt_secret) GTE 24  --->
  </cfif>
    
  <!--- /CFIF REFind("[^A-Za-z0-9]",form.jwt_secret) gt 0  --->
  </cfif>

  <cfif #step# is "1.5">


    <cfif #form.storage_encryption_key# is "">
  
      <cfset step=0>
      <cfset session.m=31>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
    
    <cfelse>
    
    <cfif REFind("[^A-Za-z0-9]",form.storage_encryption_key) gt 0>
    
      <cfset step=0>
      <cfset session.m=32>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
    
    <cfelse>
    
    <!--- CODE TO ENFORCE 24 CHARACTER LENGTH --->
    <cfif NOT ( len(form.storage_encryption_key) GTE 24)>
    <cfset step=0>
    <cfset session.m=33>
            
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    
    <cfelse>
    
    <cfquery name="update" datasource="hermes">
    update parameters2 set value2='#form.storage_encryption_key#', applied='2' where parameter='storage.encryption_key'
    </cfquery>
    
    <cfset step=2>
    
    <!--- /CFIF  #form.storage_encryption_key# is ""  --->
    </cfif>
    
    <!--- /CFIF  NOT ( len(form.storage_encryption_key) GTE 24  --->
    </cfif>
      
    <!--- /CFIF REFind("[^A-Za-z0-9]",form.storage_encryption_key) gt 0  --->
    </cfif>
  

  <!--- /CFIF step is 1.5 --->
  </cfif>
  
  <cfif #step# is "2">
  
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
  
  <cfset step=3>
  
  <!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.session_name) gt 0>  --->
  </cfif>
  
  <!--- /CFIF #form.session_name# is ""  --->
  </cfif>
  
  <!--- /CFIF step is 2 --->
  </cfif>
  
  
  
  <cfif #step# is "3">
  
    <cfif #form.session_secret# is "">
  
      <cfset step=0>
      <cfset session.m=6>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
      
    <cfelse>
  
    <cfif REFind("[^A-Za-z0-9]",form.session_secret) gt 0>
  
      <cfset step=0>
      <cfset session.m=7>
      
      <cfoutput>
      <cflocation url="#cgi.http_referer#" addtoken="no">
      </cfoutput>
      
      <cfelse>
      
        <!--- CODE TO ENFORCE 12 CHARACTER LENGTH --->
        <cfif NOT ( len(form.session_secret) GTE 12)>
        <cfset step=0>
        <cfset session.m=8>
        
        <cfoutput>
        <cflocation url="#cgi.http_referer#" addtoken="no">
        </cfoutput>
      
      <cfelse>
  
      <cfquery name="update" datasource="hermes">
      update parameters2 set value2='#form.session_secret#', applied='2' where parameter='session.secret'
      </cfquery>
      
      <cfset step=4>
      
      <!--- /CFIF  NOT ( len(form.session_secret) GTE 12  --->
      </cfif>
        
      <!--- /CFIF REFind("[^A-Za-z0-9]",form.session_secret) gt 0  --->
      </cfif>
  
         <!--- /CFIF #form.session_secret# is ""  --->
        </cfif>
    
  <!--- /CFIF step is 3 --->
  </cfif>
    
  
  <cfif #step# is "4">
  
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
    
    <cfset step=5>
    
    <!--- /CFIF REFind("[^0-9-]",form.session_expiration) gt 0>  --->
    </cfif>
      
    <!--- /CFIF #form.session_expiration# is "" --->
  </cfif>
    
    <!--- /CFIF step is 4 --->
    </cfif>
  
  
  
    <cfif #step# is "5">
  
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
      
      <cfset step=6>
      
      <!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.session_inactivity) gt 0>  --->
      </cfif>
  
         <!--- /CFIF #form.session_inactivity# is "" --->
        </cfif>
      
      <!--- /CFIF step is 5 --->
      </cfif>
  
  
      <cfif #step# is "6">
  
        <cfif #form.notifier_smtp_host# is "">
          
          <cfset step=0>
          <cfset session.m=13>
          
          <cfoutput>
          <cflocation url="#cgi.http_referer#" addtoken="no">
          </cfoutput>
        
        <cfelse>
        
            <cfif REFind("[^A-Za-z0-9\_\-\[\]\.]",form.notifier_smtp_host) gt 0>
            
            <cfset step=0>
            <cfset session.m=14>
            
            <cfoutput>
            <cflocation url="#cgi.http_referer#" addtoken="no">
            </cfoutput>
            
            <cfelse>
        
            <cfquery name="update" datasource="hermes">
            update parameters2 set value2='#form.notifier_smtp_host#', applied='2' where parameter='notifier.smtp.host'
            </cfquery>
            
            <cfset step=7>
            
            <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",notifier_smtp_host) gt 0>  --->
            </cfif>
        
               <!--- /CFIF #form.notifier_smtp_host# is "" --->
              </cfif>
            
            <!--- /CFIF step is 6 --->
            </cfif>
  
            <cfif #step# is "7">
  
              <cfif #form.notifier_smtp_port# is "">
                
                <cfset step=0>
                <cfset session.m=15>
                
                <cfoutput>
                <cflocation url="#cgi.http_referer#" addtoken="no">
                </cfoutput>
              
              <cfelse>
              
                  <cfif REFind("[^0-9]",form.notifier_smtp_port) gt 0>
                  
                  <cfset step=0>
                  <cfset session.m=16>
                  
                  <cfoutput>
                  <cflocation url="#cgi.http_referer#" addtoken="no">
                  </cfoutput>
                  
                  <cfelse>
              
                  <cfquery name="update" datasource="hermes">
                  update parameters2 set value2='#form.notifier_smtp_port#', applied='2' where parameter='notifier.smtp.port'
                  </cfquery>
                  
                  <cfset step=8>
                  
                  <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",notifier_smtp_port) gt 0>  --->
                  </cfif>
              
                     <!--- /CFIF #form.notifier_smtp_port# is "" --->
                    </cfif>
                  
                  <!--- /CFIF step is 7 --->
                  </cfif>
  
                  <cfif #step# is "8">
  
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
                        
                        <cfset step=9>
                        
                        <!--- /CFIF NOT isValid("email", form.notifier_smtp_sender  --->
                        </cfif>
                    
                           <!--- /CFIF #form.notifier_smtp_sender# is "" --->
                          </cfif>
                        
                        <!--- /CFIF step is 8 --->
                        </cfif>
  
                        <cfif #step# is "9">
  
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
                              
                              <cfset step=10>
                              
                              <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",notifier_smtp_subject) gt 0>  --->
                              </cfif>
                          
                                 <!--- /CFIF #form.notifier_smtp_subject# is "" --->
                                </cfif>
                              
                              <!--- /CFIF step is 9 --->
                              </cfif>
  
  
                              <cfif #step# is "10">
  
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
                                    
                                    <cfset step=11>
                                    
                                    <!--- /CFIF REFind("^0-9\_\-\[\]\.]",regulation_max_retries) gt 0>  --->
                                    </cfif>
                                
                                       <!--- /CFIF #form.regulation_max_retries# is "" --->
                                      </cfif>
                                    
                                    <!--- /CFIF step is 10 --->
                                    </cfif>
                    
  
                                    <cfif #step# is "11">
  
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
                                          
                                          <cfset step=12>
                                          
                                          <!--- /CFIF REFind("^0-9\_\-\[\]\.]",regulation_find_time) gt 0>  --->
                                          </cfif>
                                      
                                             <!--- /CFIF #form.regulation_find_time# is "" --->
                                            </cfif>
                                          
                                          <!--- /CFIF step is 11 --->
                                          </cfif>                 
            
  
                                          <cfif #step# is "12">
  
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
                                                
                                                <cfset step=13>
                                                
                                                <!--- /CFIF REFind("^A-Za-z0-9\_\-\[\]\.]",regulation_ban_time) gt 0>  --->
                                                </cfif>
                                            
                                                   <!--- /CFIF #form.regulation_ban_time# is "" --->
                                                  </cfif>
                                                
                                                <!--- /CFIF step is 12 --->
                                                </cfif>   
                                                
  
                                                <cfif #step# is "13">
  
                                                  <!--- UPDATE LOG LEVEL AND LOG FORMAT DROP-DOWN FIELDS --->
                                                  <cfquery name="update" datasource="hermes">
                                                  update parameters2 set value2='#form.log_level#', applied='2' where parameter='log.level'
                                                  </cfquery>
                                                  
                                                  <cfquery name="update" datasource="hermes">
                                                  update parameters2 set value2='#form.log_format#', applied='2' where parameter='log.format'
                                                  </cfquery>
                                                  
                                                  <cfset step=13.1>
                                                  
                                                  <!--- /CFIF step is 13 --->
                                                  </cfif>

                                                  <cfif #step# is "13.1">
  
                                                    <!--- UPDATE DUO DISABLE --->
                                                    <cfquery name="update" datasource="hermes">
                                                    update parameters2 set value2='#form.duo_disable#', applied='2' where parameter='duo.disable'
                                                    </cfquery>
                                                    
                                                                                                  
                                                    <cfset step=14>
                                                    
                                                    <!--- /CFIF step is 13.1 --->
                                                    </cfif>

                                          <cfif #form.duo_disable# is "false">

                                                  <cfif #step# is "14">

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
                                                    
                                                    <cfset step=15>
                                                    
                                                    <!--- /CFIF #form.duo_hostname# is "" --->
                                                    </cfif>

                                                        <!--- /CFIF IsValid("email", tempemail) --->
                                                      </cfif>
                                                    
                                                                                            
                                                    <!--- /CFIF step 14 --->
                                                    </cfif>

                                                    <cfif #step# is "15">
  
                                                      <cfif #form.duo_integration_key# is "">
                                                        
                                                        <cfset step=0>
                                                        <cfset session.m=36>
                                                        
                                                        <cfoutput>
                                                        <cflocation url="#cgi.http_referer#" addtoken="no">
                                                        </cfoutput>
                                                      
                                                      <cfelse>
                                                      
                                                          <cfif REFind("[^A-Za-z0-9]",form.duo_integration_key) gt 0>
                                                          
                                                          <cfset step=0>
                                                          <cfset session.m=37>
                                                          
                                                          <cfoutput>
                                                          <cflocation url="#cgi.http_referer#" addtoken="no">
                                                          </cfoutput>
                                                          
                                                          <cfelse>
                                                      
                                                          <cfquery name="update" datasource="hermes">
                                                          update parameters2 set value2='#form.duo_integration_key#', applied='2' where parameter='duo.integration_key'
                                                          </cfquery>
                                                          
                                                          <cfset step=16>
                                                          
                                                          <!--- /CFIF REFind("^A-Za-z0-9]",form.duo_integration_key) gt 0>  --->
                                                          </cfif>
                                                      
                                                             <!--- /CFIF #form.duo_integration_key# is "" --->
                                                            </cfif>
                                                          
                                                          <!--- /CFIF step is 15 --->
                                                          </cfif>

                                                          <cfif #step# is "16">
  
                                                            <cfif #form.duo_secret_key# is "">
                                                              
                                                              <cfset step=0>
                                                              <cfset session.m=38>
                                                              
                                                              <cfoutput>
                                                              <cflocation url="#cgi.http_referer#" addtoken="no">
                                                              </cfoutput>
                                                            
                                                            <cfelse>
                                                            
                                                                <cfif REFind("[^A-Za-z0-9]",form.duo_secret_key) gt 0>
                                                                
                                                                <cfset step=0>
                                                                <cfset session.m=39>
                                                                
                                                                <cfoutput>
                                                                <cflocation url="#cgi.http_referer#" addtoken="no">
                                                                </cfoutput>
                                                                
                                                                <cfelse>
                                                            
                                                                <cfquery name="update" datasource="hermes">
                                                                update parameters2 set value2='#form.duo_secret_key#', applied='2' where parameter='duo.secret_key'
                                                                </cfquery>
                                                                
                                                                <cfset step=17>
                                                                
                                                                <!--- /CFIF REFind("^A-Za-z0-9]",form.duo_secret_key) gt 0>  --->
                                                                </cfif>
                                                            
                                                                   <!--- /CFIF #form.duo_secret_key# is "" --->
                                                                  </cfif>
                                                                
                                                                <!--- /CFIF step is 16 --->
                                                                </cfif>

                                                                <cfif #step# is "17">
  
                                                                  <!--- UPDATE DUO SELF ENROLLMENT --->
                                                                  <cfquery name="update" datasource="hermes">
                                                                  update parameters2 set value2='#form.duo_self_enrollment#', applied='2' where parameter='duo.self_enrollment'
                                                                  </cfquery>
                                                                  
                                                                                                                
                                                                  <cfset step=18>
                                                                  
                                                                  <!--- /CFIF step is 17 --->
                                                                  </cfif>

                                                                <cfelseif #form.duo_disable# is "true">

                                                                  <cfset step=18>

                                                                 <!--- /CFIF form.duo_disable is "false/true" --->
                                                                </cfif>
  
                                                  <cfif step is "18">
  
                                                    <cfquery name = "updateauthentication" datasource="hermes">
                                                    update parameters2 set
                                                    applied='1'
                                                    where module = 'authelia'
                                                    </cfquery>
                                                    
                                                    <cfinclude template="generate_authelia_configuration.cfm">

                                                    <cfinclude template="restart_authelia.cfm">

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
    thread = CreateObject("java", "java.lang.Thread"); 
    thread.sleep(10000); 
    </cfscript> 
                                                    
                                                    <cfset session.m=27>
                                                    
                                                 
                                                    
                                                    <!--- /CFIF for step 14 --->
                                                    </cfif>
  