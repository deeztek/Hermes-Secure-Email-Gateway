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
<title>Delete Policy</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="803">
    <tr valign="top" align="left">
      <td width="21" height="37"></td>
      <td width="782"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="782" id="Text1" class="TextObject">
        <p style="margin-bottom: 0px;"><cfif IsDefined("URL.ID")>
<cfif #url.id# is not "">

<cfquery name="checksystem" datasource="#datasource#">
select * from spam_policies where policy_id='#url.id#' and system = '1'
</cfquery>

<cfif #checksystem.recordcount# GTE 1>
<cflocation url="spam_policies.cfm?m=6##policies" addtoken="no">
</cfif>


<cfquery name="checkdefault" datasource="#datasource#">
select * from spam_policies where policy_id='#url.id#' and default_policy = '1'
</cfquery>

<cfif #checkdefault.recordcount# GTE 1>
<cflocation url="spam_policies.cfm?m=13##policies" addtoken="no">
</cfif>

<cfquery name="checkowner" datasource="#datasource#">
select * from spam_policies where policy_id='#url.id#'
</cfquery>

<cfif #checkowner.recordcount# LT 1>
<cflocation url="spam_policies.cfm?m=9##policies" addtoken="no">
</cfif>

<cfquery name="checkassigned" datasource="#datasource#">
select * from recipients where policy_id='#url.id#'
</cfquery>

<cfif #checkassigned.recordcount# GTE 1>
<cflocation url="spam_policies.cfm?m=11##policies" addtoken="no">
</cfif>

<cfquery name="delete" datasource="#datasource#">
delete from spam_policies where policy_id='#url.id#'
</cfquery>

<cfquery name="delete2" datasource="#datasource#">
delete from policy where id='#url.id#'
</cfquery>

<cflocation url="spam_policies.cfm?m=12##policies" addtoken="no">

<cfelse>
<cflocation url="spam_policies.cfm?m=8##policies" addtoken="no">
</cfif>

<cfelseif NOT IsDefined("URL.ID")>
<cflocation url="error.cfm" addtoken="no">
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   