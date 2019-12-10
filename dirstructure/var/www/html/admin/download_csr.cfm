<cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Download CSR</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="867">
    <tr valign="top" align="left">
      <td width="47" height="57"></td>
      <td width="820"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="820" id="Text378" class="TextObject">
        <p style="margin-bottom: 0px;"><cfparam name = "customtrans" default = ""> 
<cfif IsDefined("url.customtrans") is "True">
<cfif url.customtrans is not "">
<cfset customtrans = url.customtrans>
</cfif></cfif>

<cfif #customtrans# is "">
<cflocation url="create_csr.cfm?m2=2">
<cfelseif #customtrans# is not "">

<cfset rar="/opt/hermes/tmp/#customtrans#_csr_key.rar">

<cfif NOT fileExists(rar)> 
<cfoutput>
<cflocation url="create_csr.cfm?m2=2">
</cfoutput>

<cfelseif fileExists(rar)>

<cfoutput>
<cfheader name="Content-disposition" value="attachment;filename=#customtrans#_csr_key.rar">
<CFCONTENT FILE="/opt/hermes/tmp/#customtrans#_csr_key.rar" type="application/unknown" DELETEFILE="Yes">
</cfoutput>

</cfif>

<cfset m=0>

</cfif>











&nbsp;</p>
      </td>
    </tr>
  </table>
  

</body>
</html>
   