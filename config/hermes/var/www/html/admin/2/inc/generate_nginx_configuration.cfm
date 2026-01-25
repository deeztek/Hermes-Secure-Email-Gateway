
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET CONSOLE SETTINGS VARIABLES TO BE USED BELOW --->
<cfinclude template="get_console_settings.cfm">

<!--- GENERATE NGINX HERMES-SSL.CONF STARTS HERE --->

<cfif #console_certificate.value2# is "">

<cfset certpath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
<cfset keypath = "/etc/ssl/private/ssl-cert-snakeoil.key">

<cfelseif #console_certificate.value2# is "1">

  <cfset certpath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
  <cfset keypath = "/etc/ssl/private/ssl-cert-snakeoil.key">

<cfelse>

<cfquery name="getcertificate" datasource="hermes">
select id, type, file_name from system_certificates where id=<cfqueryparam value = #console_certificate.value2# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getcertificate.type# is "Imported">

<cfset certpath = "/opt/hermes/ssl/#getcertificate.file_name#_hermes.bundle.pem">
<cfset keypath = "/opt/hermes/ssl/#getcertificate.file_name#_hermes.key">

<cfelseif #getcertificate.type# is "Acme">
    
<cfset certpath = "/etc/letsencrypt/live/#getcertificate.file_name#/fullchain.pem">
<cfset keypath = "/etc/letsencrypt/live/#getcertificate.file_name#/privkey.pem">
    
<!--- /CFIF #getcertificate.type# is --->
</cfif>

<!--- /CFIF #console_certificate.value2# is --->
</cfif>

<cffile action="read" file="/opt/hermes/templates/hermes-ssl.conf" variable="nginx">
 
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_ssl_certificate","#certpath#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">
 
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_ssl_key","#keypath#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_server_name","#console_host.value2#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">
 
<cfif #console_dhparam.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_dhparam_file","##ssl_dhparam /opt/hermes/ssl/dhparam.pem","ALL")#" addnewline="no">

<cfelseif #console_dhparam.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_dhparam_file","ssl_dhparam /opt/hermes/ssl/dhparam.pem","ALL")#" addnewline="no">

<!--- /CFIF #console_dhparam.value2# is --->
</cfif>
    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">
 
<cfif #console_hsts.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_hsts","##add_header Strict-Transport-Security ""max-age=31536000; preload""","ALL")#" addnewline="no">

<cfelseif #console_hsts.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_hsts","add_header Strict-Transport-Security ""max-age=31536000; preload""","ALL")#" addnewline="no">

<!--- /CFIF #console_hsts.value2# is --->
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">
 
<cfif #console_ssl_stapling.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_ocsp","##ssl_stapling on","ALL")#" addnewline="no">

<cfelseif #console_ssl_stapling.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_ocsp","ssl_stapling on","ALL")#" addnewline="no">

<!--- /CFIF #console_ssl_stapling.value2# is --->
</cfif>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">
 
<cfif #console_ssl_stapling_verify.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_verify","##ssl_stapling_verify on","ALL")#" addnewline="no">

<cfelseif #console_ssl_stapling_verify.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_verify","ssl_stapling_verify on","ALL")#" addnewline="no">

<!--- /CFIF #console_ssl_stapling_verify.value2# is --->
</cfif>

<!--- GENERATE FIREWALL CONFIG STARTS HERE --->

<cfquery name="getfwstatus" datasource="hermes">
select parameter, value2, module from parameters2 where parameter='firewall_status' and module='firewall'
</cfquery>

<cfif #getfwstatus.value2# is "enabled">

  <cfquery name="getfwipshermes" datasource="hermes">
  select ip from firewall where hermesadmin = 'yes'
  </cfquery>


<!--- HERMES ADMIN FIREWALL IPS STARTS HERE --->

    <cfif #getfwipshermes.recordcount# GTE 1>
    
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_fwruleshermes"
    output = ""
    addNewLine = "no">
    
    <cfloop query="getfwipshermes">
    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_fwruleshermes"
    output = "allow #ip#;"
    addNewLine = "yes">
    
    </cfloop>
    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_fwruleshermes"
    output = "deny all;"
    addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cftry>
    <cfexecute name="/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_fwruleshermes"
    timeout="10" />
            
    <cfcatch type="any">
        
    <cfset m="Generate Nginx Configuration: There was an error executing /usr/bin/dos2unix">
    <cfinclude template="error.cfm">
    <cfabort>   
        
    </cfcatch>
    </cftry>
            

<!--- Read the /opt/hermes/tmp/#customtrans3#_fwrules file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_fwruleshermes" variable="fwruleshermes">

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<!--- Replace hermes_fw with the contents of the /opt/hermes/tmp/#customtrans3#_fwrules file --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_hermes","#fwruleshermes#","ALL")#" addnewline="no">

<!--- delete /opt/hermes/tmp/#customtrans3#_fwruleshermes file --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_fwruleshermes")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_fwruleshermes">
</cfif>

<cfelseif #getfwipshermes.recordcount# LT 1>

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_hermes","","ALL")#" addnewline="no">
        
<!--- /CFIF #getfwipshermes.recordcount# --->
</cfif>

<!--- HERMES ADMIN FIREWALL IPS ENDS HERE --->

<!--- CIPHERMAIL ADMIN FIREWALL IPS STARTS HERE --->

<cfquery name="getfwipsciphermail" datasource="hermes">
  select ip from firewall where ciphermailadmin = 'yes'
  </cfquery>

    <cfif #getfwipsciphermail.recordcount# GTE 1>
    
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_fwrulesciphermail"
    output = ""
    addNewLine = "no">
    
    <cfloop query="getfwipsciphermail">
    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_fwrulesciphermail"
    output = "allow #ip#;"
    addNewLine = "yes">
    
    </cfloop>
    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_fwrulesciphermail"
    output = "deny all;"
    addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cftry>
    <cfexecute name="/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_fwrulesciphermail"
    timeout="10" />
            
    <cfcatch type="any">
        
    <cfset m="Generate Nginx Configuration: There was an error executing /usr/bin/dos2unix">
    <cfinclude template="error.cfm">
    <cfabort>   
        
    </cfcatch>
    </cftry>
            

<!--- Read the /opt/hermes/tmp/#customtrans3#_fwrules file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_fwrulesciphermail" variable="fwrulesciphermail">

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<!--- Replace hermes_fw with the contents of the /opt/hermes/tmp/#customtrans3#_fwrules file --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_ciphermail","#fwrulesciphermail#","ALL")#" addnewline="no">

<!--- delete /opt/hermes/tmp/#customtrans3#_fwrulesciphermail file --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_fwrulesciphermail")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_fwrulesciphermail">
</cfif>

<cfelseif #getfwipsciphermail.recordcount# LT 1>

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_ciphermail","","ALL")#" addnewline="no">
        
<!--- /CFIF #getfwipsciphermail.recordcount# --->
</cfif>

<!--- CIPHERMAIL ADMIN FIREWALL IPS ENDS HERE --->

<!--- If fw is not enabled --->
<cfelse>

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_hermes","","ALL")#" addnewline="no">

<!--- Read the #customtrans3#_hermes-ssl.conf file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" variable="nginx">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf"
output = "#REReplace("#nginx#","hermes_fw_ciphermail","","ALL")#" addnewline="no">


<!--- /CFIF #getfwstatus.value2# --->
</cfif> 

<!--- GENERATE FIREWALL CONFIG ENDS HERE --->

<!--- Backup Nginx hermes-ssl.conf --->
<cffile action = "copy" source = "/etc/nginx/sites-available/hermes-ssl.conf" 
destination = "/etc/nginx/sites-available/hermes-ssl.HERMES">

<!--- First delete all symlink files from /etc/nginx/sites-enabled so that the delete /etc/nginx/sites-available below doesn't fail and additionally the /usr/bin/ln -sf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/ command further down don't fail. The filter is "*" instead of "*.conf" so that any files without ".conf" get deleted --->
<cfdirectory 
    action="list"
    directory="/etc/nginx/sites-enabled"
    name="qFiles"
    filter="*">

<cfloop query="qFiles">

  <cfif FileExists("/etc/nginx/sites-enabled/#qFiles.name#")>

    <cffile 
        action="delete" 
        file="/etc/nginx/sites-enabled/#qFiles.name#">

<!--- /CFIF FileExists --->
</cfif>

</cfloop>


<!--- Delete all *.conf files from /etc/nginx/sites-available in order to start fresh. The "*.conf" filter is used so that the hermes-ssl.HERMES backup files that was created above doesn't get deleted --->
<cfdirectory 
    action="list"
    directory="/etc/nginx/sites-available"
    name="qFiles"
    filter="*.conf">

<cfloop query="qFiles">

    <cfif FileExists("/etc/nginx/sites-available/#qFiles.name#")>

    <cffile 
        action="delete" 
        file="/etc/nginx/sites-available/#qFiles.name#">

<!--- /CFIF FileExists --->
</cfif>

</cfloop>


<!--- Move /opt/hermes/tmp/#customtrans3#_hermes-ssl.conf to /etc/nginx/sites-availble/hermes-ssl.conf --->
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_hermes-ssl.conf" 
destination = "/etc/nginx/sites-available/hermes-ssl.conf">


<!--- GENERATE NGINX HERMES-SSL.CONF ENDS HERE --->


<!--- GENERATE NGINX MAILBOX SNI CONFIGS STARTS HERE --->

<!--- Get all certificates including imported  --->
<cfquery name="getallcerts" datasource="hermes">
    SELECT DISTINCT(certificate) FROM mailbox_sans where mailbox_domain = '1' and DNS = 'YES'
</cfquery>

<cfloop query = "getallcerts">

  <cfquery name = "getcertdetails" datasource="hermes">
  select type, file_name, domain_name from system_certificates where id = '#getallcerts.certificate#'
  </cfquery>

<cfif #getcertdetails.type# is "Acme">

<cfquery name = "getsubdomains" datasource="hermes">
select subdomain from mailbox_sans where certificate = '#getallcerts.certificate#' and DNS = 'YES' order by subdomain asc
  </cfquery>

<cfelse>

<cfquery name = "getsubdomains" datasource="hermes">
select subdomain from mailbox_sans where certificate = '#getallcerts.certificate#' order by subdomain asc
</cfquery>

<!--- /CFIF #getcertdetails.type# --->
</cfif>

<cfset theSubdomains = ValueList(getsubdomains.subdomain, " ")>

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- Read the hermes-mailbox-ssl.conf template file --->
<cffile action="read" file="/opt/hermes/templates/hermes-mailbox-ssl.conf" variable="nginx_mailbox">


<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_server_name","#theSubdomains#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">


<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_server_name","#theSubdomains#","ALL")#" addnewline="no">


<cfif #getcertificate.type# is "Imported">

<cfset certpath = "/opt/hermes/ssl/#getcertdetails.file_name#_hermes.bundle.pem">
<cfset keypath = "/opt/hermes/ssl/#getcertificate.file_name#_hermes.key">

<cfelseif #getcertificate.type# is "Acme">
    
<cfset certpath = "/etc/letsencrypt/live/#getcertdetails.file_name#/fullchain.pem">
<cfset keypath = "/etc/letsencrypt/live/#getcertdetails.file_name#/privkey.pem">
    
<!--- /CFIF #getcertificate.type# is --->
</cfif>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">
 
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_ssl_certificate","#certpath#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">
 
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_ssl_key","#keypath#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">

<cfif #console_dhparam.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_dhparam_file","##ssl_dhparam /opt/hermes/ssl/dhparam.pem","ALL")#" addnewline="no">

<cfelseif #console_dhparam.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_dhparam_file","ssl_dhparam /opt/hermes/ssl/dhparam.pem","ALL")#" addnewline="no">

<!--- /CFIF #console_dhparam.value2# is --->
</cfif>
    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">
 
<cfif #console_hsts.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_hsts","##add_header Strict-Transport-Security ""max-age=31536000; preload""","ALL")#" addnewline="no">

<cfelseif #console_hsts.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_hsts","add_header Strict-Transport-Security ""max-age=31536000; preload""","ALL")#" addnewline="no">

<!--- /CFIF #console_hsts.value2# is --->
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">
 
<cfif #console_ssl_stapling.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_ocsp","##ssl_stapling on","ALL")#" addnewline="no">

<cfelseif #console_ssl_stapling.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_ocsp","ssl_stapling on","ALL")#" addnewline="no">

<!--- /CFIF #console_ssl_stapling.value2# is --->
</cfif>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">
 
<cfif #console_ssl_stapling_verify.value2# is "disable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_verify","##ssl_stapling_verify on","ALL")#" addnewline="no">

<cfelseif #console_ssl_stapling_verify.value2# is "enable">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_verify","ssl_stapling_verify on","ALL")#" addnewline="no">

<!--- /CFIF #console_ssl_stapling_verify.value2# is --->
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" variable="nginx_mailbox">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf"
output = "#REReplace("#nginx_mailbox#","hermes_console_host","#console_host.value2#","ALL")#" addnewline="no">

<!--- Move /opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf to /etc/nginx/sites-available/#customtrans3#__hermes-mailbox-ssl.conf --->
<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_hermes-mailbox-ssl.conf" 
destination = "/etc/nginx/sites-available/#customtrans3#_hermes-mailbox-ssl.conf">

<!--- /CFLOOP getallcerts --->
</cfloop>


<!--- Make symlinks for all files from sites-available to sites-enabled. Ensure "-sf" switch is present in order for this to work. This must be run in a bash shell in order to expand the *.conf because coldfusion puts a literal '*.conf' in the directory instead of expanding --->
    <cftry>
    <cfexecute name="/bin/bash"
    arguments='-c "ln -sf /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/"'
    timeout="10" />
            
    <cfcatch type="any">
        
    <cfset m="Generate Nginx Configuration: There was an error executing /bin/bash -c ln -s /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/">
    <cfinclude template="error.cfm">
    <cfabort>   
        
    </cfcatch>
    </cftry>


<!--- GENERATE NGINX MAILBOX SNI CONFIGS ENDS HERE --->


