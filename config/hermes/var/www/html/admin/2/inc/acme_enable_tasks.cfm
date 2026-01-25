 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfquery name="checkifactive" datasource="hermes">
  select active from ofelia_jobs where type = 'certbot' and active='2'
  </cfquery>

<cfif #checkifactive.recordcount# GTE "1">

<!--- Enable for debug

<cfoutput>Not active</cfoutput>

--->
  
<!--- Not needed if called from acme_request_certificate.cfm template

  <cfinclude template="generate_customtrans.cfm">
  
  <cfinclude template="docker_get_directory.cfm">

--->

 
 <!--- Generate renew_acme_certificate.sh --->

<cffile action="read" file="/opt/hermes/templates/renew_acme_certificate.sh" variable="AcmeCert">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_renew_acme_certificate.sh"
output = "#REReplace("#AcmeCert#","DOCKER-DIR","#DockerDir#","ALL")#" addnewline="no">

 <cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_renew_acme_certificate.sh" destination = "/opt/hermes/schedule/renew_acme_certificate.sh">


 <cftry>

<!-- Make it executable -->
 <cfexecute name = "/bin/chmod"
 arguments="+x /opt/hermes/schedule/renew_acme_certificate.sh"
timeout = "240">
</cfexecute>


<cfcatch type="any">


  <cfset m="acme_enable_tasks.cfm: #cfcatch.detail#">
  <cfinclude template="error.cfm">
  <cfabort>



  </cfcatch>


 </cftry>

 <cfquery name="activatecertbotjobs" datasource="hermes">
  update ofelia_jobs set active = '1' where type = 'certbot'
  </cfquery>


<!--- /CFIF checkifactive.recordcount --->
</cfif>