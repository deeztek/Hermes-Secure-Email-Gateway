 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- Include retention policy functions (lightweight, no cleanup operations) --->
<cfinclude template="retention_policy_functions.cfm">

<cfif NOT isRetentionEnabled()>
    <cfoutput>Advanced retention policies require valid configuration (Status: #getRetentionStatus()#). Exiting...</cfoutput><br>
    <cfabort>
</cfif>

<cfparam name = "requestacme" default = "0">

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">

  <cfquery name="getsubdomains" datasource="hermes">
select id, certificate, mailbox_domain, subdomain, ip from mailbox_sans
  </cfquery>


<cfif #getsubdomains.recordcount# GTE 1>

<cfloop query="getsubdomains">

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="../admin/2/inc/generate_customtrans.cfm">
  
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
        <cfinclude template="../admin/2/inc/error.cfm">
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
        <cfinclude template="../admin/2/inc/error.cfm">
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
      
      <!--- /CFIF fileExists(verifyipfile)> --->
      </cfif>
      
      <cfset verifyipfile_ssl="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
      <cfif fileExists(verifyipfile_ssl)>
      
      <cffile action = "delete" file = "#verifyipfile_ssl#">
      
      <!--- /CFIF fileExists(verifyipfile_ssl)> --->
      </cfif>

   
      <cfset step="1">



    <cfelse>

<!---  Delete Temp Files --->   

     <cfset verifyipfile="/opt/hermes/tmp/#customtrans3#_verifyip">
      <cfif fileExists(verifyipfile)>
      
      <cffile action = "delete" file = "#verifyipfile#">
      
      <!--- /CFIF fileExists(verifyipfile)> --->
      </cfif>
      
      <cfset verifyipfile_ssl="/opt/hermes/tmp/#customtrans3#_verifyip.ssl">
      <cfif fileExists(verifyipfile_ssl)>
      
      <cffile action = "delete" file = "#verifyipfile_ssl#">
      
      <!--- /CFIF fileExists(verifyipfile_ssl)> --->
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
        <cfinclude template="../admin/2/inc/error.cfm">
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
  update mailbox_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#'
  where id = '#id#'
  </cfquery>

<cfelseif #serverResponse# contains "SUCCESS">


 <cfquery name="updateauto" datasource="hermes">
  update mailbox_sans set ip_result_datetime = '#datenow# #timenow#', ip_result_msg = '#serverResponse#', ip = 'YES'
  where id = '#id#'
  </cfquery>


<!--- /CFIF #serverresponse# contains --->
</cfif>



<!--- /CFIF #step# is "2" --->
</cfif>

<!--- /CFLOOP getsubdomains --->
</cfloop>

<cfelse>

<cfoutput>No SAN Domains found. Nothing to do. Exiting...</cfoutput><br>

<cfabort>

<!--- /CFIF #getsubdomains.recordcount# --->
</cfif>


<!--- Get all validated ip san subdomains --->
<cfquery name="getvalidatedip" datasource="hermes">
select distinct(certificate) from mailbox_sans where ip = 'YES'
</cfquery>


<cfloop query = "getvalidatedip">

<!--- Ensure requestacme=0  --->
<cfset requestacme=0>

<!--- Create validated ip subdomain hash starts here --->
<cfquery name="create_validated_hash" datasource="hermes">
  select subdomain from mailbox_sans where certificate = '#certificate#' and ip = 'YES' order by subdomain asc
</cfquery>

<!--- If records exist --->
<cfif #create_validated_hash.recordcount# GTE 1>

<!--- Generate the current SAN Subdomain string out of the previous query --->
<cfset san_list = ValueList(create_validated_hash.subdomain)>

<!--- Convert List to Array --->
<cfset san_array = ListToArray(san_list, ",")>

<!--- Iterate through the array and remove any white spaces from each element --->
<cfloop index="i" from="1" to="#ArrayLen(san_array)#">
    <cfset san_array[i] = trim(san_array[i])>
</cfloop>

<!-- Convert array back to string for further use -->
<cfset san_list = ArrayToList(san_array, ",")>

<!--- Create current SAN Hash --->
<cfset newHash = Hash(san_list, "SHA-256")>
<cfoutput>New Hash: #newHash#</cfoutput><br>



<!--- Create validated ip subdomain hash ends here --->

<!--- Get previous validatedip hash if it exists --->
<cfquery name="getprevioushash" datasource="hermes">
select acme_hash from system_certificates where id = '#certificate#'
</cfquery>

<cfset oldHash = #getprevioushash.acme_hash#>
<cfoutput>Old Hash: #oldHash#</cfoutput><br>

<cfif #oldHash# is "">

<cfoutput>No SAN Domains Hash found. Creating new one and will attempt new certificate request..</cfoutput><br>

<cfquery name="updatehash" datasource="hermes">
update system_certificates set acme_hash = '#newHash#' where id = '#certificate#'
</cfquery>

<!--- Since no old hash exists set requestacme=1 so that it will request new Acme cert --->
<cfset requestacme=1>

<cfelse>

<!--- If Old hash does not equal new hash then set requestacme=1 so that it will request new Acme cert --->
<cfif #oldHash# NEQ #newHash#>
<cfset requestacme=1>

<!--- Update new hash --->
<cfquery name="updatehash" datasource="hermes">
update system_certificates set acme_hash = '#newHash#' where id = '#certificate#'
</cfquery>

<cfoutput>SAN Domains Hash changed. Will attempt new certificate request...</cfoutput><br>

<!--- /CFIF #oldHash# NEQ #newHash# --->
</cfif>

<!--- /CFIF #oldHash# is "" --->
</cfif>

<cfif #requestacme# is "1">

<!--- Count the number of subdomains from previous create_validated_hash query from above --->
<cfset totalsubdomain = #create_validated_hash.recordcount#>

<cfoutput>Total number of SANs is: #totalsubdomain#</cfoutput><br>

<cfif #totalsubdomain# LT 100>

<cfoutput>The number of SANs is below 100. Proceeding with certificate request...</cfoutput><br>

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="../admin/2/inc/generate_customtrans.cfm">

  <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_san_domains"
        output = "" addnewline="no">

<!--- Create SAN subdomain list from create_validated_hash query above --->
<cfoutput query="create_validated_hash">

    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_san_domains"
    output = "-d #subdomain##chr(32)#"
    addNewLine = "no">

</cfoutput>


<!--- GET CERTIFICATE NAME --->
<cfquery name="getcertname" datasource="hermes">
 select domain_name from system_certificates where id = '#certificate#'
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


 <cfoutput>Requesting new certificate for certificate #theCertname#...</cfoutput><br>

<!--- REQUEST SAN CERTIFICATE--->
<cfinclude template="../admin/2/inc/acme_request_san_certificate.cfm">

<cfoutput>Acme Output: #acmeOutput#</cfoutput><br>

<cfoutput>Docker Directory: #DockerDir#</cfoutput><br>

<cfif FindNoCase("Successfully received certificate", acmeOutput)>

<cfquery name="insertsuccess" datasource="hermes">
update mailbox_sans set dns = 'YES', dns_result_msg = 'SUCCESS: Successfully Received SAN Certificate', dns_result_datetime = '#datenow# #timenow#' where certificate = '#certificate#'
</cfquery>

<cfoutput>Successfully obtained certificate for #theCertname#...</cfoutput><br>

<!--- GENERATE NGINX CONFIGURATION (includes SNI configs) --->
<cfinclude template="../admin/2/inc/generate_nginx_configuration.cfm">

<!--- RESTART NGINX --->
<cfinclude template="../admin/2/inc/restart_nginx.cfm">

<!--- GENERATE SMTP SNI CONFIGURATION --->
<cfinclude template="generate_smtp_sni.cfm">

<!--- GENERATE POSTFIX CONFIGURATION (includes SMTP SNI parameter if enabled) --->
<cfinclude template="../admin/2/inc/generate_postfix_configuration.cfm">

<cfelse>

<cfquery name="insertfailure" datasource="hermes">
update mailbox_sans set dns_result_msg = 'ERROR: #acmeOutput#', dns_result_datetime = '#datenow# #timenow#' where certificate = '#certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<cfoutput>Could not obtain certificate for #theCertname#. Error reported was: #acmeOutput#</cfoutput><br>

<!--- /CFIF FindNoCase("Congratulations", acmeOutput) --->
</cfif>


<cfelse>

<cfquery name="insertsanlimit" datasource="hermes">
update mailbox_sans set dns_result_msg = 'ERROR: SAN limit reached', dns_result_datetime = '#datenow# #timenow#' where certificate = '#certificate#' and ip = 'YES' and dns = 'NO'
</cfquery>

<cfoutput>SAN limit reached for certificate #theCertname#</cfoutput><br>


<!--- /CFIF #totalsubdomain# LT 100 --->
</cfif>

<cfelse>

<cfoutput>No changes to SAN Domains found. Nothing to do. Exiting...</cfoutput><br>

<!--- /CFIF #requestacme# is "1" --->
</cfif>

<!--- /CFIF #create_validated_hash.recordcount# GTE 1 --->
</cfif>

<!--- /CFLOOP query = "getvalidatedip" --->
</cfloop>


