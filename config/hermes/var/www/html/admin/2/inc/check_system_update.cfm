  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- DOCKER PATH (#218). Docker installs use GitHub Releases as the
     source of truth. The daily Ofelia job invokes
     /schedule/check_for_update.cfm which polls the GitHub Releases API,
     writes the result to /opt/hermes/updates/check_system_update.txt,
     and emails the admin when a new build is available. This file
     is now just a thin cache-reader for the dashboard widget -- no
     network call, no auth dance, no per-page-load API hit. --->
<cfquery name="getVersionTrain" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'version_no'
</cfquery>
<cfif getVersionTrain.recordCount AND getVersionTrain.value EQ 'Docker'>
    <cfset cacheFile = "/opt/hermes/updates/check_system_update.txt">
    <cfif fileExists(cacheFile)>
        <cffile action="read" file="#cacheFile#" variable="cachedContent">
        <cfset cachedContent = trim(cachedContent)>
        <cfif Len(cachedContent) GT 0>
            <cfset status = ListGetAt(cachedContent, 1, chr(64))>
            <cfif status EQ "SUCCESS">
                <cfif ListLen(cachedContent, chr(64)) GE 2>
                    <cfset build = ListGetAt(cachedContent, 2, chr(64))>
                </cfif>
                <cfif ListLen(cachedContent, chr(64)) GE 3>
                    <cfset released = ListGetAt(cachedContent, 3, chr(64))>
                </cfif>
                <cfif ListLen(cachedContent, chr(64)) GE 5>
                    <cfset releasenote = ListGetAt(cachedContent, 5, chr(64))>
                </cfif>
                <cfset hermesupdate = "UPDATEFOUND">
            <cfelseif status EQ "NOUPDATE">
                <cfset hermesupdate = "LATEST VERSION">
            <cfelse>
                <!--- "UPDATE CHECK UNAVAILABLE" passes through verbatim --->
                <cfset hermesupdate = status>
            </cfif>
        <cfelse>
            <cfset hermesupdate = "UPDATE CHECK UNAVAILABLE">
        </cfif>
    <cfelse>
        <!--- Cache file not yet written; first Ofelia run hasn't happened. --->
        <cfset hermesupdate = "UPDATE CHECK PENDING">
    </cfif>
    <cfexit method="exitTemplate">
</cfif>

<cfif StructKeyExists(url, "sendemail")>

<cfif IsValid("integer", #url.sendemail#)>

<cfif url.sendemail is "1">    

<cfset sendemail = 1>

<cfelse>

<cfset sendemail = 0>

<!--- /CFIF url.sendemail is  --->
</cfif>

<cfelseif NOT IsValid("integer", #url.sendemail#)>

  <cfset m="/inc/check_system_update: url.sendemail is not valid integer">
  <cfinclude template="error.cfm">
  <cfabort>  

  <!--- /CFIF IsValid("integer", #url.sendemail#) --->
</cfif>

<cfelse>

<cfset sendemail = 0>

<!--- /CFIF StructKeyExists(url, "sendemail") --->
</cfif>


<cfif StructKeyExists(url, "dev")>

  <cfif IsValid("integer", #url.dev#)>
  
  <cfif url.dev is "1">    
  
  <cfset dev = 1>
  
  <cfelse>
  
  <cfset dev = 2>
  
  <!--- /CFIF url.dev is  --->
  </cfif>
  
  <cfelseif NOT IsValid("integer", #url.dev#)>
  
    <cfset m="/inc/check_system_update: url.dev is not valid integer">
    <cfinclude template="error.cfm">
    <cfabort>  
  
    <!--- /CFIF IsValid("integer", #url.dev#) --->
  </cfif>
  
  <cfelse>
  
  <cfset dev = 2>
  
  <!--- /CFIF StructKeyExists(url, "dev") --->
  </cfif>



 <!--- DELETE /opt/hermes/updates/check_system_update_http_status.txt --->
 <cfset deletefile="/opt/hermes/updates/check_system_update_http_status.txt">
 <cfif fileExists(deletefile)>
 
 <cffile action = "delete" file = "#deletefile#">
 
 <!-- /CFIF fileExists(deletefile)> -->
 </cfif>

  <!--- DELETE /opt/hermes/updates/check_system_update.txt --->
  <cfset deletefile="/opt/hermes/updates/check_system_update.txt">
  <cfif fileExists(deletefile)>
  
  <cffile action = "delete" file = "#deletefile#">
  
  <!-- /CFIF fileExists(deletefile)> -->
  </cfif>


  <cfquery name="getlatestlocal" datasource="hermes">
    SELECT build FROM system_updates where status = '1' order by install_order desc limit 1
    </cfquery>
        
  <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">
        
        
<!--- GENERATE/ENCRYPT UPDATEFILE WITH PUBLIC KEY STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_updatefile"
output = "#getlatestlocal.build##chr(64)##dev#" addnewline="no">
  

  <cfset opensslEncryptFailed = false>

  <cftry>

  <cfexecute name = "/usr/bin/openssl"
    arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_updatefile -out /opt/hermes/tmp/#customtrans3#_updatefile.ssl"
    timeout = "60">
    </cfexecute>

    <cfcatch type="any">

        <cfset opensslEncryptFailed = true>
        <cflog file="hermes_update_check" type="error"
          text="check_system_update.cfm openssl rsautl failure: #cfcatch.message#">

    </cfcatch>
    </cftry>

<!--- GENERATE/ENCRYPT UPDATEFILE WITH PUBLIC KEY ENDS HERE --->

<!--- An error reaching the update server must NOT break the dashboard.
     Any failure (DNS/TLS/HTTP) is treated as a degraded state: cache the
     diagnostic message for operator visibility, log it, and let the page
     continue to render with hermesupdate = "UPDATE CHECK UNAVAILABLE". --->
<cfset updateCheckFailed = opensslEncryptFailed>

<cfif opensslEncryptFailed>
  <cffile action = "write"
    file = "/opt/hermes/updates/check_system_update_http_status.txt"
    output = "openssl rsautl encrypt failed (see hermes_update_check log)" addnewline="no">
</cfif>

<cftry>

<!--- POST TO UPDATE SERVER STARTS HERE. Skip the POST entirely if the
     encrypted request payload could not be produced. --->

<cfif NOT opensslEncryptFailed>

<CFHTTP METHOD="Post" URL="https://updates.deeztek.com/update_comm.cfm" timeout="60">

  <CFHTTPPARAM TYPE="File"
          NAME="#customtrans3#_updatefile.ssl"
          FILE="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">

  <CFHTTPPARAM TYPE="Formfield"
          VALUE="#customtrans3#"
          NAME="customtrans">

  </CFHTTP>

</cfif>

  <cfcatch type="any">

    <cfset updateCheckFailed = true>

    <cffile action = "write"
      file = "/opt/hermes/updates/check_system_update_http_status.txt"
      output = "#trim(cfcatch.message)#" addnewline="no">

    <cflog file="hermes_update_check" type="error"
      text="check_system_update.cfm CFHTTP exception: #cfcatch.message#">

    </cfcatch>


    </cftry>



      <!--- POST TO UPDATE SERVER ENDS HERE --->

<!--- Always clean up the encrypted request payload and its plaintext
     sibling, regardless of outcome. --->
<cfset updatefile="/opt/hermes/tmp/#customtrans3#_updatefile">
<cfif fileExists(updatefile)>
  <cffile action = "delete" file = "#updatefile#">
</cfif>
<cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">
<cfif fileExists(updatefile_ssl)>
  <cffile action = "delete" file = "#updatefile_ssl#">
</cfif>

     <!--- PARSE HTTP STATUS CODE STARTS HERE --->

<cfif updateCheckFailed>

  <!--- CFHTTP threw — status file was already written in the catch. --->
  <cfset hermesupdate = "UPDATE CHECK UNAVAILABLE">

<cfelseif #cfhttp.status_code# EQ "200">

  <cffile action = "write"
    file = "/opt/hermes/updates/check_system_update_http_status.txt"
    output = "#cfhttp.statuscode#" addnewline="no">

<cfelse>

  <cffile action = "write"
    file = "/opt/hermes/updates/check_system_update_http_status.txt"
    output = "#cfhttp.statuscode#" addnewline="no">

  <cflog file="hermes_update_check" type="error"
    text="check_system_update.cfm non-200 from updates server: #cfhttp.statuscode#">

  <cfset updateCheckFailed = true>
  <cfset hermesupdate = "UPDATE CHECK UNAVAILABLE">

  <!--- /CFIF #cfhttp.status_code# --->
  </cfif>


      

<!--- PARSE HTTP STATUS CODE ENDS HERE --->


<!--- Only parse the server response body when we actually got a 200.
     On any failure we've already set hermesupdate = "UPDATE CHECK
     UNAVAILABLE" above and must not touch cfhttp.FileContent (which
     may be empty or undefined). --->
<cfif NOT updateCheckFailed>

<!--- SET STATUS VARIABLE --->

<cfset status = "#trim(ListGetAt(cfhttp.FileContent, 1, "#chr(64)#"))#">
        
<!--- IF STATUS CONTAINS SUCCESS SET THE REST OF THE VARIABLES --->

<cfif #status# contains 'SUCCESS'>




  <cfset build = "#trim(ListGetAt(cfhttp.FileContent, 2, "#chr(64)#"))#">
        <cfset released = "#trim(ListGetAt(cfhttp.FileContent, 3, "#chr(64)#"))#">
        <cfset filename = "#trim(ListGetAt(cfhttp.FileContent, 4, "#chr(64)#"))#">
        <cfset releasenote = "#trim(ListGetAt(cfhttp.FileContent, 5, "#chr(64)#"))#">
        <cfset releasenotefile = "#trim(ListGetAt(cfhttp.FileContent, 6, "#chr(64)#"))#">
        <cfset mysqlroot = "#trim(ListGetAt(cfhttp.FileContent, 7, "#chr(64)#"))#">
        <cfset dev = "#trim(ListGetAt(cfhttp.FileContent, 8, "#chr(64)#"))#">

<!--- ENABLE BELOW FOR DEBUG ONLY --->
<!---
<cfoutput>
Status: #status#<br>
Build: #build#
Released: #released#<br>
filename: #filename#<br>
releasenote: #releasenote#<br>
releasenotefile: #releasenotefile#<br>
mysqlroot: #mysqlroot#<br>
dev: #dev#<br>
</cfoutput>
--->


  <!--- WRITE UPDATE STATUS TO /opt/hermes/updates/check_system_update.txt --->
  <cffile action = "write"
  file = "/opt/hermes/updates/check_system_update.txt"
  output = "#status##chr(64)##build##chr(64)##released##chr(64)##filename##chr(64)##releasenote##chr(64)##releasenotefile##chr(64)##mysqlroot##chr(64)##dev#" addnewline="no">


<cfif #sendemail# is "1">
    <cfquery name="getpostmaster" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>
      
      <cfquery name="getadmin" datasource="hermes">
        select parameter, value from system_settings where parameter='admin_email'
        </cfquery>

<cfquery name="getconsolehost" datasource="hermes">
  select parameter, value2 from parameters2 where parameter='console.host' and module='console'
  </cfquery>


      <cfmail from="#getpostmaster.value#" to="#getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Update build: #build# Notification" port="10026" type="html">

        <div align="center">

    <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
        
       <h2>Hermes SEG Update Notification</h2>
       
       Hermes SEG Update Build: <a href="https://updates.deeztek.com/releasenotes/hermes-#build#-release.html">#build#</a> is available. Please download and install this update in order to get the latest features and fixes. <a href="https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/system-update">Click here</a> to learn how to run System Update or click the link below:<br><br>
       
       https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/system-update
       
        </div>
        
        
        </cfmail>

        <!--- /CFIF #sendemail# is "1" --->
      </cfif>

  <cfset hermesupdate = "UPDATEFOUND">

     
      
      <cfelseif #status# contains 'Connection'>

<!--- WRITE UPDATE STATUS TO /opt/hermes/updates/check_system_update.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update.txt"
output = "#status##chr(64)#" addnewline="no">

      
      <cfset hermesupdate = "UPDATE PROBLEM">
      
      
      <cfelseif #status# contains 'NOUPDATE'>

        <!--- WRITE UPDATE STATUS TO /opt/hermes/updates/check_system_update.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update.txt"
output = "#status##chr(64)#" addnewline="no">

      <cfset hermesupdate = "LATEST VERSION">

    <cfelseif #status# contains 'INVALIDREQUEST'>

      <!--- WRITE UPDATE STATUS TO /opt/hermes/updates/check_system_update.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update.txt"
output = "#status##chr(64)#" addnewline="no">

      <cfset hermesupdate = "INVALID REQUEST">

<!--- /CFIF #status# --->
      </cfif>

<!--- /CFIF NOT updateCheckFailed (response-body parse guard) --->
</cfif>


    


      



