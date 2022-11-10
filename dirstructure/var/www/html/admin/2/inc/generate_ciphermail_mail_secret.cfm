
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

 <!--- GENERATE CLIENTKEYWORD --->
<cfquery name="customtrans" datasource="hermes" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 103
  </cfquery>
  
  <cfquery name="inserttrans" datasource="hermes" result="stResult">
  insert into salt
  (salt)
  values
  ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
  </cfquery>
  
  <cfquery name="gettrans" datasource="hermes">
  select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>
  

  <cfquery name="deletetrans" datasource="hermes">
  delete from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>

<cfset theMailKeyword = #LCase(gettrans.customtrans2)#>

<!--- ENCRYPT CLIENTKEYWORD --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset encrypted_mailkeyword=encrypt(theMailKeyword, #hermeskey#, "AES", "Base64")>

<!--- UPDATE CLIENTKEYWORD --->
<cfquery name="update" datasource="hermes">
update encryption_settings set value='#encrypted_mailkeyword#' where property='user.systemMailSecret'
</cfquery>

    