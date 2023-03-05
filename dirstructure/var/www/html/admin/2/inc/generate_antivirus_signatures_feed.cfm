
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- GET ANTIVIRUS SIGNATURE VARIABLES TO BE USED BELOW --->
<cfinclude template="get_antivirus_signature_feed.cfm">

<!--- GENERATE ANTIVIRUS_SIGNATURE_FEED STARTS HERE --->

<cffile action="read" file="/opt/hermes/templates/antivirus_signature_feed" variable="feed">
 
<!--- WRITE FEED NAME STARTS HERE --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_antivirus_signature_feed"
output = "#REReplace("#feed#","feed_name","#getantivirusfeed.name#","ALL")#" addnewline="no">

<!--- WRITE FEED NAME ENDS HERE --->

<!--- GENERATE FEED VARIABLES TEMP FILE STARTS HERE --->

<cfif #getvirusfeedvariables.recordcount# GTE 1>
    
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_feedvariables"
  output = ""
  addNewLine = "no">
  
  <cfloop query="getantivirusfeedvariables">
  
  <cffile action = "append"
  file = "/opt/hermes/tmp/#customtrans3#_feedvariables"
  output = "#name#=#value#"
  addNewLine = "yes">
  
  </cfloop>
  
  
  <!--- CONVERT TO UNIX --->
  <cftry>
  <cfexecute name="/usr/bin/dos2unix"
  arguments="/opt/hermes/tmp/#customtrans3#_feedvariables"
  timeout="10" />
          
  <cfcatch type="any">
      
  <cfset m="Generate Antivirus Signature Feed Variables: There was an error executing /usr/bin/dos2unix">
  <cfinclude template="error.cfm">
  <cfabort>   
      
  </cfcatch>
  </cftry>

  <!--- GENERATE FEED VARIABLES TEMP FILE ENDS HERE --->


<!--- Read the /opt/hermes/tmp/#customtrans3#_feedvariables file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_feedvariables" variable="feedvariables">

<!--- Read the #customtrans3#_antivirus_signature_feed file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_antivirus_signature_feed" variable="feed">

<!--- Replace #feed_variables with the contents of the /opt/hermes/tmp/#customtrans3#_feedvariables file --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_antivirus_signature_feed"
output = "#REReplace("#feed#","##feed_variables","#feedvariables#","ALL")#" addnewline="no">

<!--- delete /opt/hermes/tmp/#customtrans3#_feedvariables file
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_feedvariables")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_feedvariables">
</cfif>
--->

<!--- GENERATE FEED DATABASES TEMP FILE STARTS HERE --->

<cfif #getantivirusfeeddatabases.recordcount# GTE 1>
    
  <cffile action = "write"
  file = "/opt/hermes/tmp/#customtrans3#_feeddatabases"
  output = ""
  addNewLine = "no">
  
  <cfloop query="getantivirusfeeddatabases">

  <cfif #filename# is "">
  
  <cffile action = "append"
  file = "/opt/hermes/tmp/#customtrans3#_feeddatabases"
  output = "wget #getantivirusfeedurl.value##name# -O /var/lib/fangfrisch/signatures/#name#"
  addNewLine = "yes">

  <cfelse>

    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_feeddatabases"
    output = "wget #getantivirusfeedurl.value##name# -O /var/lib/fangfrisch/signatures/#filename#"
    addNewLine = "yes">

  <!--- /CFIF #filename# is --->
</cfif>
  
  </cfloop>
  
  
  <!--- CONVERT TO UNIX --->
  <cftry>
  <cfexecute name="/usr/bin/dos2unix"
  arguments="/opt/hermes/tmp/#customtrans3#_feeddatabases"
  timeout="10" />
          
  <cfcatch type="any">
      
  <cfset m="Generate Antivirus Signature Feed Databases: There was an error executing /usr/bin/dos2unix">
  <cfinclude template="error.cfm">
  <cfabort>   
      
  </cfcatch>
  </cftry>

  <!--- GENERATE FEED DATABASES TEMP FILE ENDS HERE --->


<!--- Read the /opt/hermes/tmp/#customtrans3#_feeddatabases file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_feeddatabases" variable="feeddatabases">

<!--- Read the #customtrans3#_antivirus_signature_feed file --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_antivirus_signature_feed" variable="feed">

<!--- Replace #feed_variables with the contents of the /opt/hermes/tmp/#customtrans3#_feedvariables file --->
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_antivirus_signature_feed"
output = "#REReplace("#feed#","feed_databases","#feeddatabases#","ALL")#" addnewline="no">

<!--- delete /opt/hermes/tmp/#customtrans3#_feeddatabases file
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_feeddatabases")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_feeddatabases">
</cfif>
--->





