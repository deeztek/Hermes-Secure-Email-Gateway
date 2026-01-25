
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfif NOT StructKeyExists(form, "serial_number")>

<cfset m="Add Serial Number: form.serial_number does not exist">
<cfinclude template="error.cfm">
<cfabort>

<cfelseif StructKeyExists(form, "serial_number")>
  
  <cfif #form.serial_number# is "">

    <cfset step=0>
    <cfset session.m=9>
            
    <cfoutput>
    <cflocation url="view_system_settings.cfm" addtoken="no">
    </cfoutput>
  
  <cfelseif #form.serial_number# is not "">
      
    <cfif REFind("[^a-zA-Z0-9]",form.serial_number) gt 0>

      <cfset step=0>
      <cfset session.m=10>
              
      <cfoutput>
      <cflocation url="view_system_settings.cfm" addtoken="no">
      </cfoutput>
      
    <cfelse>

    <cfset step=1>

<!--- /CFIF REFind("[^a-zA-Z0-9]",form.serial_number) gt 0 --->
</cfif>
  
<!--- /CFIF  #form.serial_number# is --->
</cfif>
    
<!--- /CFIF StructKeyExists(form, "serial_number") --->
</cfif>

<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "tos")>

    <cfset step=0>
    <cfset session.m=11>
            
    <cfoutput>
    <cflocation url="view_system_settings.cfm" addtoken="no">
    </cfoutput>
    
    <cfelseif StructKeyExists(form, "tos")>
      
      <cfif #form.tos# is "">
    
        <cfset step=0>
        <cfset session.m=11>
                
        <cfoutput>
        <cflocation url="view_system_settings.cfm" addtoken="no">
        </cfoutput>
      
      <cfelseif #form.tos# is not "">
    
    <cfset step=2>
      
    <!--- /CFIF  #form.tos# is --->
    </cfif>
        
    <!--- /CFIF StructKeyExists(form, "tos") --->
    </cfif>

<!--- /CFIF step is 1 --->
</cfif>


<cfif #step# is "2">

  <cfset theSerial=#TRIM(form.serial_number)#>

  <!--- GET UUID --->
  <cfinclude template="dmi_decode.cfm">
  
  <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">
  
<!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_activatefile"
output = "#TRIM(theUuid)##chr(64)##theSerial#" addnewline="no">
  

  <cftry> 

  <cfexecute name = "/usr/bin/openssl"
    arguments="rsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/#customtrans3#_activatefile -out /opt/hermes/tmp/#customtrans3#_activatefile.ssl"
    timeout = "60">
    </cfexecute>
    
    <cfcatch type="any">
 
        <cfset m="/inc/add_serial_number.cfm: Error running /usr/bin/openssl">
        <cfinclude template="error.cfm">
        <cfabort>


    </cfcatch>
    </cftry>
    
 <!--- GENERATE/ENCRYPT ACTIVATEFILE WITH PUBLIC KEY ENDS HERE --->
  
  <cfset step=3>
  
  
  <!--- /CFIF for step 2 --->
  </cfif>


  <cfif #step# is "3">




      <CFHTTP METHOD="Post" URL="https://activate.hermesseg.io" timeout="60">
      
      <CFHTTPPARAM TYPE="File"
              NAME="#customtrans3#_activatefile.ssl"
              FILE="/opt/hermes/tmp/#customtrans3#_activatefile.ssl">
              
      <CFHTTPPARAM TYPE="Formfield"
              VALUE="#customtrans3#"
              NAME="customtrans">
              
      </CFHTTP>
      
      
      <cfif #cfhttp.status_code# EQ "200">

      <cfset activatefile="/opt/hermes/tmp/#customtrans3#_activatefile">
      <cfif fileExists(activatefile)>
      <cffile action = "delete" file = "#activatefile#">
      
      <!--- /CFIF fileExists(activatefile)> --->
      </cfif>
    

      <cfset activatefile_ssl="/opt/hermes/tmp/#customtrans3#_activatefile.ssl">
      <cfif fileExists(activatefile_ssl)>
      <cffile action = "delete" file = "#activatefile_ssl#">
      
      <!-- /CFIF fileExists(activatefile_ssl)> -->
      </cfif>

      <cfset step=4>

      <cfelse>

      <cfset activatefile="/opt/hermes/tmp/#customtrans3#_activatefile">
      <cfif fileExists(activatefile)>  
      <cffile action = "delete" file = "#activatefile#">
      
      <!-- /CFIF fileExists(activatefile)> -->
      </cfif>
      
      <cfset activatefile_ssl="/opt/hermes/tmp/#customtrans3#_activatefile.ssl">
      <cfif fileExists(activatefile_ssl)>
      <cffile action = "delete" file = "#activatefile_ssl#">
      
      <!-- /CFIF fileExists(activatefile_ssl)> -->
      </cfif>
      

      <cfset step=0>
      <cfset session.m=12>

    <cfoutput>
    <cfset session.errordetail="#cfhttp.statuscode#">
   <cflocation url="view_system_settings.cfm" addtoken="no">
    </cfoutput>


      <!-- /CFIF #cfhttp.status_code# -->
      </cfif>
      
      
    
    <!--- /CFIF for step 3 --->
    </cfif>
  
  

<cfif #step# is "4">
  
  <cftry>
    <cfset serverresponse="#trim(ListGetAt(cfhttp.FileContent, 1, "#chr(64)#"))#">
    <cfset expires = "#trim(ListGetAt(cfhttp.FileContent, 2, "#chr(64)#"))#">
    
    <cfcatch type="any">
    
    
    <cfif #cfcatch.message# contains "invalid call of the function listGetAt">
    
    
      <cfset step=0>
      <cfset session.m=12>
              
      <cfoutput>
      <cfset session.errordetail="#cfcatch.message#">
      <cflocation url="view_system_settings.cfm" addtoken="no">
      </cfoutput>
    
    <!-- /CFIF cfcatch.message -->
    </cfif>
    
    
    </cfcatch>
    
    <cfset step="5">
    
    </cftry>

<!--- /CFIF for step 4 --->
</cfif>


<cfif #step# is "5">

  <cfset response="SUCCESS">
  <cfset trial=1>
  <cfset uuid=#TRIM(temp5)#>
  <cfset theHash=Hash(uuid & response & trial, 'SHA-256', 'UTF-8')>
  
  <cfset compare_hash = Compare(#serverresponse#, #theHash#)>
  
  <cfif #compare_hash# is "0">
  <cfset verdict="SUCCESS">
  <cfset lt="1">
  <cfelse>
  <cfset response="">
  
  <!-- /CFIF compare_hash -->
  </cfif>
  
  <cfset response="FAILURE">
  <cfset trial=1>
  <cfset uuid=#TRIM(temp5)#>
  <cfset theHash=Hash(uuid & response & trial, 'SHA-256', 'UTF-8')>
  
  <cfset compare_hash = Compare(#serverresponse#, #theHash#)>
  
  <cfif #compare_hash# is "0">
  <cfset verdict="FAILURE">
  <cfset lt="1">
  <cfelse>
  <cfset response="">
  
  <!-- /CFIF compare_hash -->
  </cfif>
  
  <cfset response="SUCCESS">
  <cfset trial=2>
  <cfset uuid=#TRIM(temp5)#>
  <cfset theHash=Hash(uuid & response & trial, 'SHA-256', 'UTF-8')>
  
  <cfset compare_hash = Compare(#serverresponse#, #theHash#)>
  
  <cfif #compare_hash# is "0">
  <cfset verdict="SUCCESS">
  <cfset lt="2">
  <cfelse>
  <cfset response="">
  
  <!-- /CFIF compare_hash -->
  </cfif>
  
  <cfset response="FAILURE">
  <cfset trial=2>
  <cfset uuid=#TRIM(temp5)#>
  <cfset theHash=Hash(uuid & response & trial, 'SHA-256', 'UTF-8')>
  
  <cfset compare_hash = Compare(#serverresponse#, #theHash#)>
  
  <cfif #compare_hash# is "0">
  <cfset verdict="FAILURE">
  <cfset lt="2">
  <cfelse>
  <cfset response="">
  
  <!-- /CFIF compare_hash -->
  </cfif>
  
  
  <cfif #verdict# is "SUCCESS">
  
  <cffile action = "write"
      file = "/usr/share/UUID2"
      output = "#TRIM(theUuid)#" addnewline="no">
      
  <cfset expires2="#REReplace("#expires#","#chr(10)#","","ALL")#">
  <cfset expires3="#REReplace("#expires2#","#chr(13)#","","ALL")#">
  <cfset expires4="#REReplace("#expires3#","&nbsp;","","ALL")#">
  
  <cfscript>
  function stripHTML(str) {
  return REReplaceNoCase(str,"<[^>]*>-","","ALL");
  }
  </cfscript>
  
  <cfset expires5 = stripHTML(#expires4#)>
      
  <cffile action = "write"
      file = "/usr/share/djigzo/ADDITIONAL-NOTES.TXT"
      output = "#TRIM(expires5)#" addnewline="no">
      
  <cffile action = "write"
      file = "/usr/share/lt"
      output = "#TRIM(lt)#" addnewline="no">
      
  <cfquery name="updateserial" datasource="#datasource#">
  update system_settings set value='#theSerial#' where parameter='serial'
  </cfquery>
  
  <cffile action = "write"
      file = "/usr/share/djigzo/DOCS.TXT"
      output = "9999" addnewline="no">
  
  <cfquery name="updateusers" datasource="#datasource#">
  update system_settings set value='9999' where parameter='users'
  </cfquery>

  
  <cfset session.license="VALID">
  <cfset license="VALID">


      
  <cfset step=0>
  <cfset session.m=15>
          
  <cfoutput>
  <cflocation url="view_system_settings.cfm" addtoken="no">
  </cfoutput>
  
  
  <cfelse>

  <cfset step=0>
  <cfset m=14>
  
  
  
  <!-- /CFIF verdict is -->
  </cfif>
  
  
  <!-- /CFIF step 5 -->
  </cfif>





    
  
