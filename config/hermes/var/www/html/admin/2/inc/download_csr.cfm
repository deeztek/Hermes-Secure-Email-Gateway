
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->
  
<cfparam name = "customtrans" default = "">

<cfif NOT StructKeyExists(url, "customtrans")>
  
<cfset m="dowload_csr.cfm: url.customtrans does not exist">
<cfinclude template="error.cfm">
<cfabort>
  
<cfelse>

<cfif #customtrans# is "">

<cfset m="dowload_csr.cfm: url.customtrans is blank">
<cfinclude template="error.cfm">
<cfabort>

<cfelse>

<cfoutput>
<cfset rar="/opt/hermes/tmp/#customtrans#_csr_key.rar">
</cfoutput>

<cfif fileExists(rar)>
    
<cfoutput>
<cfheader name="Content-disposition" value="attachment;filename=#customtrans#_csr_key.rar">
<CFCONTENT FILE="/opt/hermes/tmp/#customtrans#_csr_key.rar" type="application/unknown" DELETEFILE="Yes">
</cfoutput>

<cfelse>

<cfset m="dowload_csr.cfm: rar file does not exist">
<cfinclude template="error.cfm">
<cfabort>
    
<!--- /CFIF fileExists(rar) --->
</cfif>

<!--- /CFIF #customtrans# is "" --->
</cfif>

<!--- /CFIF StructKeyExists(url, "customtrans") --->
</cfif>

 