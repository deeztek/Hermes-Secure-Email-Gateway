  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

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

<!--- POST TO UPDATE SERVER STARTS HERE --->

<CFHTTP METHOD="Post" URL="https://updates.deeztek.com/update_comm.cfm" timeout="60">
      
  <CFHTTPPARAM TYPE="File"
          NAME="#customtrans3#_updatefile.ssl"
          FILE="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">
          
  <CFHTTPPARAM TYPE="Formfield"
          VALUE="#customtrans3#"
          NAME="customtrans">
          
  </CFHTTP>
  
  <cfcatch type="any">

    <cfif #cfcatch.message# contains "invalid call of the function listGetAt">

<!--- WRITE UPDATE HTTP STATUS TO /opt/hermes/updates/check_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update_http_status.txt"
output = "#trim(cfcatch.message)#" addnewline="no">
    
    <cfoutput>
      <cfset m="/inc/check_system_update.cfm: Error reaching update server. Error was: #cfcatch.message#. Ensure updates.deeztek.com is accessible via ports 80 and 443 with no SSL interception.">
    </cfoutput>
      <cfinclude template="error.cfm">
      <cfabort>
    
    <!-- /CFIF cfcatch.message -->
    </cfif>
    
    
    </cfcatch>
    
    
    </cftry>



      <!--- POST TO UPDATE SERVER ENDS HERE --->
      
     <!--- PARSE HTTP STATUS CODE STARTS HERE --->

      <cfif #cfhttp.status_code# EQ "200">

<!--- WRITE UPDATE HTTP STATUS TO /opt/hermes/updates/check_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">

      <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile --->
       <cfset updatefile="/opt/hermes/tmp/#customtrans3#_updatefile">
      <cfif fileExists(updatefile)>
      
      <cffile action = "delete" file = "#updatefile#">
      
      <!-- /CFIF fileExists(updatefile)> -->
      </cfif>
      
      <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile.ssl --->
      <cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">
      <cfif fileExists(updatefile_ssl)>
      
      <cffile action = "delete" file = "#updatefile_ssl#">
      
      <!-- /CFIF fileExists(updatefile_ssl)> -->
      </cfif>

 
     <cfelse>

 <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile --->
 <cfset updatefile="/opt/hermes/tmp/#customtrans3#_updatefile">
 <cfif fileExists(updatefile)>
 
 <cffile action = "delete" file = "#updatefile#">
 
 <!-- /CFIF fileExists(updatefile)> -->
 </cfif>
 
 <!--- DELETE /opt/hermes/tmp/#form.customtrans#_updatefile.ssl --->
 <cfset updatefile_ssl="/opt/hermes/tmp/#customtrans3#_updatefile.ssl">
 <cfif fileExists(updatefile_ssl)>
 
 <cffile action = "delete" file = "#updatefile_ssl#">
 
 <!-- /CFIF fileExists(updatefile_ssl)> -->
 </cfif>
  
<!--- WRITE UPDATE HTTP STATUS TO /opt/hermes/updates/check_system_update_http_status.txt --->
<cffile action = "write"
file = "/opt/hermes/updates/check_system_update_http_status.txt"
output = "#cfhttp.statuscode#" addnewline="no">

<cfoutput>
  <cfset m="/inc/check_system_update.cfm: HTTP Status Code: #cfhttp.statuscode#">
</cfoutput>

  <cfinclude template="error.cfm">

  <cfabort>  



      <!--- /CFIF #cfhttp.status_code# --->
      </cfif>


      

<!--- PARSE HTTP STATUS CODE ENDS HERE --->


        
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


    


      



