
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

  <cfif #authkey# is "">

 <!-- GENERATE SECRET KEY -->
 <cfset authkey=generateSecretKey("AES", 256)>
 <cffile action = "write"
 file = "/opt/hermes/keys/hermes.key"
 output = "#authkey#">
 
 <!-- READ SECRET KEY -->
 <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
 
 <!-- /CFIF #authkey# is "" -->
 </cfif>