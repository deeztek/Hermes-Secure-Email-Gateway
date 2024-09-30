  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


  
  <!--- DELETE /opt/hermes/updates/download_system_update_http_status.txt --->
 <cfset deletefile="/opt/hermes/updates/download_system_update_http_status.txt">
 <cfif fileExists(deletefile)>
 
 <cffile action = "delete" file = "#deletefile#">
 
 <!-- /CFIF fileExists(deletefile)> -->
 </cfif>

  <!--- DELETE /opt/hermes/updates/download_system_update.txt --->
  <cfset deletefile="/opt/hermes/updates/download_system_update.txt">
  <cfif fileExists(deletefile)>
  
  <cffile action = "delete" file = "#deletefile#">
  
  <!-- /CFIF fileExists(deletefile)> -->
  </cfif>

  <cfparam name = "theFile" default = ""> 

  <cfif StructKeyExists(url, "file")>
  
    <cfif url.file is not "">
      <cfset theFile = url.file>


    <cfelse>

      <cfset m="/inc/download_system_update.cfm: url.file is blank">
      <cfinclude template="error.cfm">
    

      <!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
      <cffile action = "write"
      file = "/opt/hermes/updates/download_system_update_http_status.txt"
      output = "FILEBLANK" addnewline="no">

      <cfabort>
      
    <!--- /CFIF url.file is --->
    </cfif>

  <cfelse>

    <cfset m="/inc/download_system_update.cfm: url.file does not exist">
    <cfinclude template="error.cfm">

      <!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
      <cffile action = "write"
      file = "/opt/hermes/updates/download_system_update_http_status.txt"
      output = "FILENOTEXIST" addnewline="no">

      <cfabort>
    
  <!--- /CFIF StructKeyExists(form, "file")--->  
  </cfif>

  
      
        <cfquery name="getlatestlocal" datasource="hermes">
        SELECT * FROM system_updates where status = '1' order by install_order desc limit 1
        </cfquery>


        
  <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">
        
        
<!--- GENERATE/ENCRYPT UPDATEFILE WITH PUBLIC KEY STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_updatefile"
output = "#getlatestlocal.build##chr(64)##theFile#" addnewline="no">
  

  <cftry> 

  <cfexecute name = "/usr/bin/openssl"
    arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_updatefile -out /opt/hermes/tmp/#customtrans3#_updatefile.ssl"
    timeout = "60">
    </cfexecute>
    
    <cfcatch type="any">
 
        <cfset m="/inc/check_system_update.cfm: Error running /usr/bin/openssl">
        <cfinclude template="error.cfm">
        <cfabort>


    </cfcatch>
    </cftry>

<!--- GENERATE/ENCRYPT UPDATEFILE WITH PUBLIC KEY ENDS HERE --->

<cftry>

<!--- GET TO UPDATE SERVER STARTS HERE --->

<CFHTTP METHOD="POST" URL="https://updates.deeztek.com/download_comm.cfm" timeout="60" resolveurl="false" redirect="false" path="/opt/hermes/updates/" file="#theFile#">
      
  <CFHTTPPARAM TYPE="File"
          NAME="#customtrans3#_updatefile.ssl"
          FILE="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">
          
  <CFHTTPPARAM TYPE="Formfield"
          VALUE="#customtrans3#"
          NAME="customtrans">
          
  </CFHTTP>
  
  <cfcatch type="any">

    <cfif #cfcatch.message# contains "invalid call of the function listGetAt">

<!--- WRITE UPDATE HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "#trim(cfcatch.message)#" addnewline="no">
    
    <cfoutput>
      <cfset m="/inc/download_system_update.cfm: Error reaching update server. Error was: #cfcatch.message#. Ensure updates.deeztek.com is accessible via ports 80 and 443 with no SSL interception.">
    </cfoutput>
      <cfinclude template="error.cfm">
      <cfabort>
    
    <!-- /CFIF cfcatch.message -->
    </cfif>
    
    
    </cfcatch>
    
    
    </cftry>



      <!--- POST TO UPDATE SERVER ENDS HERE --->
      
     <!--- PARSE HTTP STATUS CODE STARTS HERE --->

      <cfif #cfhttp.statuscode# contains "200">

        <!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">


      <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile --->
      <cfset updatefile="/opt/hermes/tmp/#customtrans3#_updatefile">

      <cfif fileExists(updatefile)>
      
        
      <cffile action = "delete" file = "#updatefile#">
      
      
      <!--- /CFIF fileExists(updatefile)> --->
      </cfif>
      
  

   
      <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile.ssl --->
      <cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">

      <cfif fileExists(updatefile_ssl)>
      
      
      <cffile action = "delete" file = "#updatefile_ssl#">
      
      
      <!--- /CFIF fileExists(updatefile_ssl)> --->
      </cfif>

   
     <cfelse>

 <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile --->
 <cfset updatefile="/opt/hermes/tmp/#customtrans3#_updatefile">

 <cfif fileExists(updatefile)>
 
  <!---
 <cffile action = "delete" file = "#updatefile#">
  --->
 
 <!--- /CFIF fileExists(updatefile)> --->
 </cfif>
 
 <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile.ssl --->
 <cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">

 <cfif fileExists(updatefile_ssl)>
 
  
 <cffile action = "delete" file = "#updatefile_ssl#">
  

 <!--- /CFIF fileExists(updatefile_ssl)> --->
 </cfif>
  
<!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">

<cfoutput>
  <cfset m="/inc/download_system_update.cfm: HTTP Status Code: #cfhttp.statuscode#">
</cfoutput>

  <cfinclude template="error.cfm">

  <cfabort>  



      <!--- /CFIF #cfhttp.statuscode# --->
      </cfif>


      

<!--- PARSE HTTP STATUS CODE ENDS HERE --->



<cfif #cfhttp.filecontent# contains 'NOTFOUND'>

<!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">

<cfset session.m=1>

<cfelseif #cfhttp.filecontent# contains 'INVALID'>

  <!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">
      
<cfset session.m=2>
      
<cfelse>



<cfoutput>
  <cfset updatepath="/opt/hermes/updates/#theFile#">
  </cfoutput>

 <cfif fileExists(updatepath)>

<!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/download_system_update_http_status.txt"
output = "SUCCESS" addnewline="no">


  <cfelse>

    <!--- WRITE DOWNLOAD HTTP STATUS TO /opt/hermes/updates/download_system_update_http_status.txt --->
    <cffile action = "write"
    file = "/opt/hermes/updates/download_system_update_http_status.txt"
    output = "ERROR" addnewline="no">

    <cfset session.m=4>
    <cfset action="">

  <!--- /CFIF fileExists(updatepath) --->
  </cfif>


<!--- /CFIF #cfhttp.filecontent# --->
      </cfif>





    


      



