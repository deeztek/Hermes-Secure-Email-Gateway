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
<title>Edit Firewall</title>
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
        <p style="margin-bottom: 0px;"><cfset action="#form.action#">

<cfif #action# is "delete">
<cfif NOT IsDefined ("form.ip")>
<cflocation url="firewall_settings.cfm?m3=1">

<cfelseif IsDefined("form.ip")>

<cfset compare_ip = Compare(#form.ip#, #GetHttpRequestData().headers['X-Forwarded-For']#)>

<cfif #compare_ip# is "1">

<cfquery name="delete" datasource="#datasource#">
delete from firewall where ip = '#form.ip#'
</cfquery>
<cflocation url="firewall_settings.cfm?m3=3">

<cfelseif #compare_ip# is "-1">
<cfquery name="delete" datasource="#datasource#">
delete from firewall where ip = '#form.ip#'
</cfquery>
<cflocation url="firewall_settings.cfm?m3=3">

<cfelseif #compare_ip# is "0">
<cflocation url="firewall_settings.cfm?m3=2">
</cfif>


</cfif>

<cfelseif #action# is "edit">
<cfif #form.firewall_status# is "enabled">
<cfquery name="checkcurrent" datasource="#datasource#">
select ip from firewall where ip='#GetHttpRequestData().headers['X-Forwarded-For']#'
</cfquery>

<cfif #checkcurrent.recordcount# LT 1>
<cflocation url="firewall_settings.cfm?m=1">

<cfelseif #checkcurrent.recordcount# GTE 1>
<cfquery name="updatestatus" datasource="#datasource#">
update parameters2 set value2='#form.firewall_status#' where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>
<cflocation url="firewall_settings.cfm?m=2">
</cfif>

<cfelseif #form.firewall_status# is "disabled">
<cfquery name="updatestatus" datasource="#datasource#">
update parameters2 set value2='#form.firewall_status#' where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>
<cflocation url="firewall_settings.cfm?m=3">
</cfif>

</cfif>

&nbsp;</p>
      </td>
    </tr>
  </table>
  

</body>
</html>
   