
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<!--- GENERATE SERVERKEYWORD --->
<cfset _transLength = 103>
<cfinclude template="generate_customtrans.cfm">

<cfset theServerKeyword = #LCase(customtrans3)#>

<!--- ENCRYPT SERVERKEYWORD --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset encrypted_serverkeyword=encrypt(theServerKeyword, #hermeskey#, "AES", "Base64")>

<!--- UPDATE SERVERKEYWORD --->
<cfquery name="update" datasource="hermes">
update encryption_settings set value='#encrypted_serverkeyword#' where property='user.serverSecret'
</cfquery>