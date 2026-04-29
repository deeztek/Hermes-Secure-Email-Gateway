
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

    <cfif NOT StructKeyExists(form, "console_host")>

    <cfset m="Edit Console Settings: form.console_host does not exist">
    <cfinclude template="error.cfm">
    <cfabort>

    <cfelse>

<!--- Normalize: trim whitespace and strip any trailing dots (DNS zone-
     file FQDN syntax). The dot is valid in zone files but breaks mail
     clients that display the value (Outlook for Mac is one). Strip at
     the input boundary so the canonical clean form lands in the DB and
     downstream consumers (autoconfig.cfm, autodiscover.cfm, nginx
     vhost generation, NC theming URL, OIDC discovery URI, etc.) all
     see the same hostname. --->
<cfset form.console_host = REReplace(Trim(form.console_host), "\.+$", "")>

<!--- CHECK IF IPv4 ADDRESS --->
<cfif REFind("[0-9]",form.console_host) gt 0 AND REFind("[.]",form.console_host)>

<!--- VALIDATE IPV4 --->
<cfinclude template="validate_ip_address.cfm">

<cfif REFind(pattern,form.console_host) GT 0>

<cfquery name="update" datasource="hermes">
update parameters2 set value2='#form.console_host#', applied='2' where parameter='console.host'
</cfquery>

<cfset step=2>

<cfelse>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>


<!--- /CFIF REFind(pattern,form.console_host) GT 0 --->
</cfif>


<!--- CHECK IF IPv6 ADDRESS --->
<cfelseif REFind("[0-9]",form.console_host) gt 0 AND REFind("[:]",form.console_host) gt 0>

<!--- VALIDATE IPV6 ADDRESS --->
<cfinclude template="validate_ip_address_ipv6.cfm">

<cfif REFind(pattern,form.console_host) GT 0>

<cfset step=2>

<cfelse>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>


<!--- /CFIF REFind(pattern,form.console_host) GT 0 --->
</cfif>

<!--- CHECK IF FQDN --->
<cfelseif REFind("[a-z]",form.console_host) gt 0 AND REFind("[.]",form.console_host)>

    <cfoutput>
    <cfset testDomain = "bob@#form.console_host#">
    </cfoutput>

    <cfif NOT IsValid("email", #testDomain#)>

    <cfset step=0>
    <cfset session.m=3>

    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>

  <cfelse>

  <cfquery name="update" datasource="hermes">
  update parameters2 set value2='#form.console_host#', applied='2' where parameter='console.host'
  </cfquery>

  <cfset step=2>

  <!--- /CFIF NOT IsValid("email", #testDomain#) --->
  </cfif>

<!--- IF ELSE --->
<cfelse>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>

<!--- /CFIF REFind --->
</cfif>


<cfif #step# is "2">
    
<cfif NOT StructKeyExists(form, "certificateno_1")>
    
<cfset m="Edit Console Settings: certificateno_1 does not exist">
<cfinclude template="error.cfm">
<cfabort>
  
<cfelse>
  
<cfif #form.certificateno_1# is "">

<cfset step=3>
  
<cfelse>
      
<cfquery name="checkcertificate" datasource="hermes">
select id from system_certificates where id=<cfqueryparam value = #form.certificateno_1# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkcertificate.recordcount# LT 1>

<cfset step=0>
<cfset session.m=2>
          
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="update" datasource="hermes">
update parameters2 set value2='#form.certificateno_1#', applied='2' where parameter='console.certificate'
</cfquery>  

<cfset step=3>

<!--- /CFIF checkcertificate.recordcount --->
</cfif>
  
<!--- /CFIF form.certificateno_1 is  --->
</cfif>
    
<!--- /CFIF StructKeyExists(form, "certificateno_1") --->
</cfif>

<!--- /CFIF for step is 2 --->
</cfif>


<cfif #step# is "3">
    
<cfif StructKeyExists(form, "dh_param")>

<cfif FileExists("/opt/hermes/ssl/dhparam.pem")>

<cfif #form.dh_param# is "enable">
      
<cfquery name="updatedhparam" datasource="hermes">
update parameters2 set value2='enable', active='1', applied='2' where parameter='console.dhparam' and module='console'
</cfquery>

<cfset step=4>

<cfelseif #form.dh_param# is "disable">

<cfquery name="updatedhparam" datasource="hermes">
update parameters2 set value2='disable', active='1', applied='2' where parameter='console.dhparam' and module='console'
</cfquery>

<cfset step=4>

<cfelse>

<cfset m="Edit Console Settings: form.dh_param is not enable or disable">
<cfinclude template="error.cfm">
<cfabort>

<!--- #form.dh_param# is --->
</cfif>

<cfelse>

<cfset m="Edit Console Settings: form.dh_param passed without dhparam file">
<cfinclude template="error.cfm">
<cfabort>

<!--- FileExists("/opt/hermes/ssl/dhparam.pem") --->
</cfif>

<cfelse>

<cfset step=4>
      
<!--- /CFIF StructKeyExists(form, "dh_param") --->
</cfif>
  
<!--- /CFIF for step is 3 --->
</cfif>



<cfif #step# is "4">
    
<cfif NOT StructKeyExists(form, "hsts")>

<cfset m="Edit Console Settings: form.hsts does not exist">
<cfinclude template="error.cfm">
<cfabort>
  
<cfelse>

  <cfif #form.hsts# is "enable">
        
  <cfquery name="updatehsts" datasource="hermes">
  update parameters2 set value2='enable', active='1', applied='2' where parameter='console.hsts' and module='console'
  </cfquery>
  
  <cfset step=5>
  
  <cfelseif #form.hsts# is "disable">
  
  <cfquery name="updatehsts" datasource="hermes">
  update parameters2 set value2='disable', active='1', applied='2' where parameter='console.hsts' and module='console'
  </cfquery>
  
  <cfset step=5>
  
  <cfelse>
  
  <cfset m="Edit Console Settings: form.hsts is not enable or disable">
  <cfinclude template="error.cfm">
  <cfabort>
  
  <!--- #form.hsts# is --->
  </cfif>
        
  <!--- /CFIF StructKeyExists(form, "hsts") --->
  </cfif>
    
  <!--- /CFIF for step is 4 --->
  </cfif>
    

  <cfif #step# is "5">
    
    <cfif NOT StructKeyExists(form, "ocsp")>
    
    <cfset m="Edit Console Settings: form.ocsp does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
      
    <cfelse>
    
      <cfif #form.ocsp# is "enable">
            
      <cfquery name="updateocsp" datasource="hermes">
      update parameters2 set value2='enable', active='1', applied='2' where parameter='console.ssl_stapling' and module='console'
      </cfquery>
      
      <cfset step=6>
      
      <cfelseif #form.ocsp# is "disable">
      
      <cfquery name="updateocsp" datasource="hermes">
      update parameters2 set value2='disable', active='1', applied='2' where parameter='console.ssl_stapling' and module='console'
      </cfquery>
      
      <cfset step=6>
      
      <cfelse>
      
      <cfset m="Edit Console Settings: form.ocsp is not enable or disable">
      <cfinclude template="error.cfm">
      <cfabort>
      
      <!--- #form.ocsp# is --->
      </cfif>
            
      <!--- /CFIF StructKeyExists(form, "ocsp") --->
      </cfif>
        
      <!--- /CFIF for step is 5 --->
      </cfif>



      <cfif #step# is "6">
    
        <cfif NOT StructKeyExists(form, "ocspverify")>
        
        <cfset m="Edit Console Settings: form.ocspverify does not exist">
        <cfinclude template="error.cfm">
        <cfabort>
          
        <cfelse>
        
          <cfif #form.ocspverify# is "enable">
                
          <cfquery name="updateocspverify" datasource="hermes">
          update parameters2 set value2='enable', active='1', applied='2' where parameter='console.ssl_stapling_verify' and module='console'
          </cfquery>
          
        <cfset step=7>
          
          <cfelseif #form.ocspverify# is "disable">
          
          <cfquery name="updateocspverify" datasource="hermes">
          update parameters2 set value2='disable', active='1', applied='2' where parameter='console.ssl_stapling_verify' and module='console'
          </cfquery>
          
            <cfset step=7>
       
          <cfelse>
          
          <cfset m="Edit Console Settings: form.ocspverify is not enable or disable">
          <cfinclude template="error.cfm">
          <cfabort>
          
          <!--- #form.ocspverify# is --->
          </cfif>
                
          <!--- /CFIF StructKeyExists(form, "ocspverify") --->
          </cfif>
            
          <!--- /CFIF for step is 6 --->
          </cfif>

<cfif #step# is "7">


<!--- GENERATE AUTH NGINX CONFIGURATION --->
<cfinclude template="generate_auth_nginx_configuration.cfm">

<!--- GENERATE NGINX CONFIGURATION --->
<cfinclude template="generate_nginx_configuration.cfm">

<!--- GENERATE AUTHELIA CONFIGURATION --->
<cfinclude template="generate_authelia_configuration.cfm">

<!--- GENERATE NEXTCLOUD CONFIGURATION (trusted domains) --->
<cfinclude template="generate_nextcloud_configuration.cfm">

<!--- UPDATE USER_OIDC PROVIDER DISCOVERY URI WITH NEW CONSOLE HOST --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider Hermes_SEG --discoveryuri=https://#form.console_host#/.well-known/openid-configuration --endsessionendpointuri=https://#form.console_host#/logout"
        variable="oidcProviderResult"
        errorVariable="oidcProviderError"
        timeout="30" />
<cfcatch type="any">
    <!--- Non-fatal: log but don't block console settings save --->
</cfcatch>
</cftry>

<!--- UPDATE NEXTCLOUD EXTERNAL SITES "USER CONSOLE" LINK --->
<cftry>
    <cfinclude template="generate_customtrans.cfm">
    <cfset extSitesScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_ext_sites.sh">
    <cfscript>
        fileWrite(extSitesScript,
            chr(35) & "!/bin/bash" & chr(10) &
            "docker exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set external sites " &
            "--value='{""1"":{""id"":1,""name"":""User Console"",""url"":""https://" & form.console_host & "/users/"",""lang"":"""",""type"":""link"",""device"":"""",""icon"":""external.svg"",""groups"":[],""redirect"":true}}'" & chr(10),
            "utf-8");
    </cfscript>
    <cfexecute name="/bin/chmod" arguments="+x #extSitesScript#" timeout="10" />
    <cfexecute name="#extSitesScript#"
        variable="extSitesResult"
        errorVariable="extSitesError"
        timeout="30" />
    <cffile action="delete" file="#extSitesScript#">
<cfcatch type="any">
    <!--- Non-fatal: don't block console settings save --->
</cfcatch>
</cftry>

<!--- UPDATE NEXTCLOUD THEMING URL --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ theming:config url https://#form.console_host#"
        variable="themingResult"
        errorVariable="themingError"
        timeout="30" />
<cfcatch type="any">
    <!--- Non-fatal --->
</cfcatch>
</cftry>

<!--- EDIT CIPHERMAIL SETTINGS --->
<cfinclude template="edit_ciphermail_settings.cfm">


<!--- /CFIF for step is 7 --->
</cfif>
 

<!--- /CFIF StructKeyExists(form, "console_host") --->
    </cfif>


  
