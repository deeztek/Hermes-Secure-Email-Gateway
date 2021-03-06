<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete SMIME Certificate2</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="825">
    <tr valign="top" align="left">
      <td width="40" height="35"></td>
      <td width="785"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="785" id="Text438" class="TextObject">
        <p style="margin-bottom: 0px;">
<CFPARAM NAME="theID" DEFAULT="">
<cfif IsDefined("url.id") is "True">
<cfif url.id is not "">
<cfset theID = url.id>
</cfif>
<cfelseif NOT IsDefined("url.id")>
<cflocation url="error.cfm" addToken = "no">
</cfif>

<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif>
<cfelseif NOT IsDefined("url.show")>
<cflocation url="error.cfm" addToken = "no">
</cfif>

<CFPARAM NAME="StartRow" DEFAULT="1">
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<CFPARAM NAME="DisplayRows" DEFAULT="10">
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>


<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfif IsDefined("form.delete") is "True">
<cfset delete = 1>
<cfelseif IsDefined("form.delete") is "False">
<cfset delete = 2>
</cfif>

<cfif #delete# is "2">

<cfoutput>
<cflocation url="delete_smime_certificate.cfm?m=1&id=#theID#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#" addToken = "no">
</cfoutput>

<cfelseif #delete# is "1">
<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where id=<cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getcerts.recordcount# GTE 1>

<!-- DELETE CERTIFICATE AND KEYSTORE FROM DJIGZO STARTS HERE -->


<cfquery name="getthumbprint" datasource="djigzo">
select cm_id, cm_thumbprint, cm_key_alias from cm_certificates where cm_id='#getcerts.djigzo_certificate_id#'
</cfquery>

<cfquery name="delete1" datasource="djigzo">
delete from cm_certificates_email where cm_certificates_id='#getcerts.djigzo_certificate_id#'
</cfquery>

<cfquery name="delete2" datasource="djigzo">
delete from cm_certificates where cm_id='#getcerts.djigzo_certificate_id#'
</cfquery>

<cfquery name="getctl" datasource="djigzo">
select * from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
</cfquery>

<cfif #getctl.recordcount# GTE 1>
<cfquery name="delete4" datasource="djigzo">
delete from cm_ctl_cm_name_values where cm_ctl='#getctl.cm_id#'
</cfquery>

<cfquery name="delete3" datasource="djigzo">
delete from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
</cfquery>

<!-- /CFIF for getctl.recordcount -->
</cfif>

<cfquery name="getkeystore" datasource="djigzo">
select * from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
</cfquery>

<cfif #getkeystore.recordcount# GTE 1>
<cfquery name="delete5" datasource="djigzo">
delete from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
</cfquery>

<!-- /CFIF for getkeystore.recordcount -->
</cfif>


<!-- DELETE CERTIFICATE AND KEYSTORE FROM DJIGZO ENDS HERE -->

<!-- DELETE FROM HERMES CERTITIFCATE STORE STARTS HERE -->

<cfif #getcerts.external_ca# is not "1">
<cfoutput>
<cfquery name="getca" datasource="#datasource#">
select ca_directory from ca_settings where id='#getcerts.ca_id#'
</cfquery>

<cfset smime_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/newcerts/#getcerts.smime_certificate_name#">
<cfif fileExists(smime_certificate_name2)> 
<cffile 
action = "delete"
file = "#smime_certificate_name2#">
</cfif>

<cfset smime_certificate_request2="/opt/hermes/CA/#getca.ca_directory#/root_ca/requests/#getcerts.smime_certificate_request#">  
<cfif fileExists(smime_certificate_request2)>    
<cffile
    action = "delete"
    file = "#smime_certificate_request2#">
</cfif>
    
<cfset smime_certificate_key2="/opt/hermes/CA/#getca.ca_directory#/root_ca/private/#getcerts.smime_certificate_key#">   
<cfif fileExists(smime_certificate_key2)>  
<cffile
    action = "delete"
    file = "#smime_certificate_key2#">
</cfif>
    
<cfset pfx_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/PFX/#getcerts.pfx_certificate_name#">    
<cfif fileExists(pfx_certificate_name2)>     
<cffile
    action = "delete"
    file = "#pfx_certificate_name2#">
</cfif>  
</cfoutput>

<cfelseif #getcerts.external_ca# is "1">
<cfoutput>
<cfset pfx_certificate_name2="/opt/hermes/HermesExternalCACerts/#getcerts.pfx_certificate_name#">    
<cfif fileExists(pfx_certificate_name2)>     
<cffile
    action = "delete"
    file = "#pfx_certificate_name2#">
</cfif> 
</cfoutput>

<!-- /CFIF for getcerts.external_ca -->
</cfif>

<cfquery name="deletecert" datasource="#datasource#">
delete from recipient_certificates where id='#theID#'
</cfquery>

<!-- DELETE FROM HERMES CERTITIFCATE STORE ENDS HERE --> 
  
<cfif #type# is "1">
<cflocation url="internal_encryption_users.cfm?id=#theID#&action=deletedcertificate&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"
 addtoken="no">
<cfelseif #type# is "2">
<cflocation url="external_encryption_users.cfm?id=#theID#&action=deletedcertificate&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"
 addtoken="no">
</cfif>


<cfelseif #getcerts.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getcerts.recordcount -->
</cfif>

<!-- /CFIF for delete is 1 -->
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   