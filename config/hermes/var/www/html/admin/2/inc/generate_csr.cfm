
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

 <!--- GENERATE CUSTOMTRANS --->
 <cfinclude template="generate_customtrans.cfm"> 

  <cffile action="read" file="/opt/hermes/scripts/generate_csr.sh" variable="temp">

  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","SHA-TYPE","#form.algorithm#","ALL")#" addnewline="no">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","KEY-LENGTH","#form.encryption#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","SESSION","#customtrans3#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","COUNTRY","#form.country#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","STATE","#form.state#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","LOCALITY","#form.locality#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","ORGANIZATION","#form.organization#","ALL")#" addnewline="no">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","DEPARTMENT","#form.department#","ALL")#" addnewline="no">


  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_csr.sh" variable="temp">
  
  <cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
output = "#REReplace("#temp#","COMMON-NAME","#form.commonname#","ALL")#" addnewline="no">
  
  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_generate_csr.sh"
  timeout = "60">
  </cfexecute>
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_generate_csr.sh"
  timeout = "240"
  outputfile ="/dev/null"
  arguments="-inputformat none">
  </cfexecute>
  
  <cfset rar="/opt/hermes/tmp/#customtrans3#_csr_key.rar">
  <cfif NOT fileExists(rar)>


<cfset step=0>
<cfset session.m="There was an error creating the certificate request">
<cfset session.alerttype="error">

  <cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

  <cfelseif fileExists(rar)>
  
  <cfoutput>
  <cfset session.customtrans=#customtrans3#>
  </cfoutput>


<cfset session.m="CSR completed successfully. Click Download CSR button below">
<cfset session.alerttype="success">

  <cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

  <!-- /CFIF FOR RAR -->
  </cfif>
  