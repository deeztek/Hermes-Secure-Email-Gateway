<cfparam name = "success" default = "0">

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">

  <cfquery name="getunvalidatedip" datasource="hermes">
select id, acme_certificate, mailbox_domain, subdomain, ip from mailbox_domains_sans where ip = 'NO'
  </cfquery>


<cfif #getunvalidatedip.recordcount# GTE 1>

<cfloop query="getunvalidatedip">

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">
  
<!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_verifyip"
output = "#subdomain#" addnewline="no">
  

  <cftry> 

  <cfexecute name = "/usr/bin/openssl"
    arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_verifyip -out /opt/hermes/tmp/#customtrans3#_verifyip.ssl"
    timeout = "60">
    </cfexecute>
    
    <cfcatch type="any">
 
        <cfset m="/inc/acme_validate_ip.cfm: Error running /usr/bin/openssl">
        <cfinclude template="error.cfm">
        <cfabort>


    </cfcatch>
    </cftry>
    
 <!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY ENDS HERE --->
  

 <cftry> 


      <CFHTTP METHOD="Post" URL="https://verify.hermesseg.io" timeout="60">
      
      <CFHTTPPARAM TYPE="File"
              NAME="#customtrans3#_verifyip.ssl"
              FILE="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
              
      <CFHTTPPARAM TYPE="Formfield"
              VALUE="#customtrans3#"
              NAME="customtrans">
              
      </CFHTTP>


    <cfcatch type="any">
 
        <cfset m="/inc/acme_validate_ip.cfm: Error connecting to https://verify.hermesseg.io">
        <cfinclude template="error.cfm">
        <cfabort>


    </cfcatch>
    </cftry>
    
 <!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY ENDS HERE --->
  
 <!--- Uncomment below to debug --->
 <!---
<cfoutput> #cfhttp.status_code# </cfoutput>      
 --->

      <cfif #cfhttp.status_code# EQ "200">

 <!---  Delete Temp Files --->     

      <cfset verifyipfile="/opt/hermes/tmp/#customtrans3#_verifyip">
      <cfif fileExists(verifyipfile)>
      
      <cffile action = "delete" file = "#verifyipfile#">
      
      <!-- /CFIF fileExists(verifyipfile)> -->
      </cfif>
      
      <cfset verifyipfile_ssl="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
      <cfif fileExists(verifyipfile_ssl)>
      
      <cffile action = "delete" file = "#verifyipfile_ssl#">
      
      <!-- /CFIF fileExists(activatefile_ssl)> -->
      </cfif>

   
      <cfset step="1">



    <cfelse>

<!---  Delete Temp Files --->   

     <cfset verifyipfile="/opt/hermes/tmp/#customtrans3#_verifyip">
      <cfif fileExists(verifyipfile)>
      
      <cffile action = "delete" file = "#verifyipfile#">
      
      <!-- /CFIF fileExists(verifyipfile)> -->
      </cfif>
      
      <cfset verifyipfile_ssl="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
      <cfif fileExists(verifyipfile_ssl)>
      
      <cffile action = "delete" file = "#verifyipfile_ssl#">
      
      <!-- /CFIF fileExists(activatefile_ssl)> -->
      </cfif>
   
<!---
    <cfoutput>status not 200</cfoutput>
--->

<cfabort>

<!--- /CFIF  #cfhttp.status_code# EQ "200" --->
  </cfif>
 

<cfif #step# is "1">

  <cftry>
    <cfset serverResponse="#trim(cfhttp.FileContent)#">
     
    <cfcatch type="any">
    
    
    <cfif #cfcatch.message# contains "invalid call of the function listGetAt">
    
    
        <cfset m="/inc/acme_validate_ip.cfm: Error reading server response">
        <cfinclude template="error.cfm">
        <cfabort>
    
    <!-- /CFIF cfcatch.message -->
    </cfif>
    
    
    </cfcatch>

    <!---
    <cfoutput>#serverResponse#</cfoutput></br>
    --->
    
    <cfset step="2">
    
    </cftry>


<!--- /CFIF #step# is "1" --->
</cfif>

<cfif #step# is "2">

<cfif #serverResponse# contains "ERROR">



 <cfquery name="updateauto" datasource="hermes">
  update mailbox_domains_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#'
  where id = '#id#'
  </cfquery>

<cfelseif #serverResponse# contains "SUCCESS">


 <cfquery name="updateauto" datasource="hermes">
  update mailbox_domains_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#', ip = 'YES'
  where id = '#id#'
  </cfquery>

<cfset success = #success# + 1>

<cfoutput>Success is: #success#</cfoutput><br>

<!--- /CFIF #serverresponse# contains --->
</cfif>



<!--- /CFIF #step# is "2" --->
</cfif>

<!--- /CFLOOP getunvalidatedip --->
</cfloop>

<!--- /CFIF #getunvalidatedip.recordcount# --->
</cfif>


<cfif #success# GTE 1>

<cfquery name="getvalidatedip" datasource="hermes">
select distinct(acme_certificate) from mailbox_domains_sans where ip = 'YES' and dns = 'NO'
</cfquery>

<cfif #getvalidatedip.recordcount# GTE 1>

<cfloop query = "getvalidatedip">

<cfquery name="getvalidatedsubdomain" datasource="hermes">
select id, subdomain from mailbox_domains_sans where acme_certificate = '#acme_certificate#' and ip = 'YES' and dns = 'YES'
</cfquery>

<cfquery name="getunvalidatedsubdomain" datasource="hermes">
 select id, subdomain from mailbox_domains_sans where acme_certificate = '#acme_certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>  

<cfset totalsubdomain = #getvalidatedsubdomain.recordcount# + #getunvalidatedsubdomain.recordcount#>

<cfoutput>Total Subdomain: #totalsubdomain#</cfoutput><br>

<cfif #totalsubdomain# LT 100>


<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

  <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_san_domains"
        output = "" addnewline="no">

<cfoutput query="getunvalidatedsubdomain">

    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_san_domains"
    output = "-d #subdomain##chr(32)#"
    addNewLine = "no">

</cfoutput>

<!--- GET CERTIFICATE NAME --->
<cfquery name="getcertname" datasource="hermes">
 select domain_name from system_certificates where id = '#acme_certificate#'
</cfquery>  

<cfset theCertname = "#getcertname.domain_name#">

<!--- READ THE SAN_DOMAINS OUTPUT FILE --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_san_domains" variable="theSan">

 <!--- DELETE /opt/hermes/tmp/#customtrans3#_san_domains --->
 <cfset sansdomains="/opt/hermes/tmp/#customtrans3#_san_domains">
 <cfif fileExists(sansdomains)>
 
 <cffile action = "delete" file = "#sansdomains#">
 
 <!-- /CFIF fileExists(sansdomains)> -->
 </cfif>

<!--- REQUEST SAN CERTIFICATE--->
<cfinclude template="acme_request_san_certificate.cfm">

<cfoutput>Acme Output: #acmeOutput#</cfoutput><br>

<cfoutput>Docker Directory: #DockerDir#</cfoutput><br>

<cfif FindNoCase("Successfully received certificate", acmeOutput)>

<cfquery name="insertsuccess" datasource="hermes">
update mailbox_domains_sans set dns = 'YES', dns_result_msg = 'SUCCESS: Successfully Received SAN Certificate', dns_result_datetime = '#datenow# #timenow#' where acme_certificate = '#acme_certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<!--- RESTART NGINX--->
<cfinclude template="restart_nginx.cfm">

<cfelse>

<cfquery name="insertfailure" datasource="hermes">
update mailbox_domains_sans set dns_result_msg = 'ERROR: #acmeOutput#', dns_result_datetime = '#datenow# #timenow#' where acme_certificate = '#acme_certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<!--- /CFIF FindNoCase("Congratulations", acmeOutput) --->
</cfif>


<cfelse>

<cfquery name="insertsanlimit" datasource="hermes">
update mailbox_domains_sans set dns_result_msg = 'ERROR: SAN limit reached', dns_result_datetime = '#datenow# #timenow#' where acme_certificate = '#acme_certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<!--- /CFIF #totalsubdomain# LT 100 --->
</cfif>

<!--- /CFLOOP query = "getvalidatedip" --->
</cfloop>

<!--- /CFIF #getvalidatedip.recordcount# GTE 1 --->
</cfif>


<!--- /CFIF #success# GTE 1 --->
</cfif>






















