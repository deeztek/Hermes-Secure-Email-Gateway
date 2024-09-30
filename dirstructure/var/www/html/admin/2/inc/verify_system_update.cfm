  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- DELETE /opt/hermes/updates/verify_system_update.txt --->
<cfset deletefile="/opt/hermes/updates/verify_system_update.txt">
<cfif fileExists(deletefile)>

<cffile action = "delete" file = "#deletefile#">

<!-- /CFIF fileExists(deletefile)> -->
</cfif>


 <cfparam name = "theFile" default = ""> 

 <cfif StructKeyExists(url, "file")>
 
   <cfif url.file is not "">
     <cfset theFile = url.file>


   <cfelse>

         <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
         <cffile action = "write"
         file = "/opt/hermes/updates/verify_system_update.txt"
         output = "FILEBLANK" addnewline="no">

     <cfset m="/inc/verify_system_update.cfm: url.file is blank">
     <cfinclude template="error.cfm">
   
     <cfabort>
     
   <!--- /CFIF url.file is --->
   </cfif>

 <cfelse>

     <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
     <cffile action = "write"
     file = "/opt/hermes/updates/verify_system_update.txt"
     output = "FILENOTEXIST" addnewline="no">

   <cfset m="/inc/verify_system_update.cfm: url.file does not exist">
   <cfinclude template="error.cfm">

     <cfabort>
   
 <!--- /CFIF StructKeyExists(form, "file")--->  
 </cfif>

        
  <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm"> 

<!--- Substitute the file name in shasum.sh template and save to /opt/hermes/tmp as temp #customtrans3#_shasum.sh --->
<cffile action="read" file="/opt/hermes/scripts/shasum.sh" variable="shasum">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_shasum.sh"
output = "#REReplace("#shasum#","THE-FILE","#theFile#","ALL")#" addnewline="no">

<!--- Make temp #customtrans3#_shasum.sh executable --->
<cftry>


  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_shasum.sh"
  timeout = "60">
  </cfexecute>

  <cfcatch type="any">

      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->

      <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
      <cffile action = "write"
      file = "/opt/hermes/updates/verify_system_update.txt"
      output = "ERRORMAKINGEXECUTABLE" addnewline="no">

      <cfset m="/inc/verify_system_update.cfm: Error making /opt/hermes/tmp/#customtrans3#_shasum.sh executable">
      <cfinclude template="error.cfm">

      <cfabort>
  
    </cfcatch>
  
  </cftry>

 <!--- Run Dos2Unix on /opt/hermes/updates/#theFile#.hash --->
<cftry>  
   
    <cfexecute name = "/usr/bin/dos2unix"
    arguments="/opt/hermes/updates/#theFile#.hash"
    timeout = "60">
    </cfexecute>

  <cfcatch type="any">

      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->

            <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
     <cffile action = "write"
     file = "/opt/hermes/updates/verify_system_update.txt"
     output = "ERROREXECUTINGDOS2UNIX" addnewline="no">

      <cfset m="/inc/verify_system_update.cfm: Error running /usr/bin/dos2unix on /opt/hermes/updates/#theFile#.hash">
      <cfinclude template="error.cfm">

      <cfabort>
  
    </cfcatch>
  
  </cftry>




<!--- verify update file checksum --->
  <cftry>

      <cfexecute name = "/opt/hermes/tmp/#customtrans3#_shasum.sh"
      timeout = "240"
      outputfile ="/dev/null"
      arguments="-inputformat none"
      variable="shasumresult">
      </cfexecute>
  
  <cfcatch type="any">
  
      <!--- DEBUG --->
  <!---
    <cfdump var="#cfcatch#">
  --->

        <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
        <cffile action = "write"
        file = "/opt/hermes/updates/verify_system_update.txt"
        output = "ERROREXECUTINGSHASUM" addnewline="no">

  <cfset m="/inc/verify_system_update.cfm: Error running /opt/hermes/tmp/#customtrans3#_shasum.sh">
  <cfinclude template="error.cfm">

  <cfabort>
  
    </cfcatch>

    <!--- If result is empty then checksum has failed and update file is corrupt  --->
  <cfif #shasumresult# is "">

           <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
           <cffile action = "write"
           file = "/opt/hermes/updates/verify_system_update.txt"
           output = "CHECKSUMNOTMATCH" addnewline="no">

    <cfset m="/inc/verify_system_update.cfm: Error running /opt/hermes/tmp/#customtrans3#_shasum.sh">
    <cfinclude template="error.cfm">
  
    <cfabort>


  <!--- Delete Update File --->
 
  <cfset FiletoDelete="/opt/hermes/updates/#theFile#">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">
  
  <!--- /CFIF FiletoDelete --->
  </cfif>


    <!--- Delete Update Hash File --->
 

    <cfset FiletoDelete="/opt/hermes/updates/#theFile#.hash">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>

  <cfelse>

        <!--- WRITE VERIFY STATUS TO /opt/hermes/updates/verify_system_update.txt --->
        <cffile action = "write"
        file = "/opt/hermes/updates/verify_system_update.txt"
        output = "SUCCESS" addnewline="no">

  <!--- If result is NOT empty then checksum is valid and update file is good --->
  </cfif>

      
  </cftry>


  
    <!--- Delete /opt/hermes/tmp/#customtrans3#_shasum.sh File --->
 

    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_shasum.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>
