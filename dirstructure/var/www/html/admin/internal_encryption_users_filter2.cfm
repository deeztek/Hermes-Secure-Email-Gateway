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
<title>Internal Encryption Users Filter2</title>
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
        <p style="margin-bottom: 0px;"><cfparam name = "m1" default = "0"> 

<cfparam name = "enabled" default = "no"> 
<cfif IsDefined("form.enabled") is "True">
<cfif form.enabled is not "">
<cfset enabled = "yes">
</cfif></cfif>

<cfparam name = "disabled" default = "no"> 
<cfif IsDefined("form.disabled") is "True">
<cfif form.disabled is not "">
<cfset disabled = "yes">
</cfif></cfif>

<cfparam name = "setfilter" default = ""> 
<cfif IsDefined("form.setfilter") is "True">
<cfif form.setfilter is not "">
<cfset setfilter = "form.setfilter">
</cfif></cfif>

<cfparam name = "clearfilter" default = ""> 
<cfif IsDefined("form.clearfilter") is "True">
<cfif form.clearfilter is not "">
<cfset clearfilter = "form.clearfilter">
</cfif></cfif>

<cfif #setfilter# is "1">
<cfif #form.filter# is "">
<cfset m1=1>
<cfelseif #form.filter# is not "">
<cfset session.filter="#form.filter#">
</cfif>
</cfif>

<cfif #clearfilter# is "1">
<cfset session.filter="">
</cfif>

<cfoutput>
Enabled: #enabled#<br>
Disabled: #disabled#<br>
SetFilter: #setfilter#<br>
clearFilter: #clearfilter#<br>
<cfif #setfilter# is 1>
Filter: #session.filter#
</cfif>
m1=#m1#
</cfoutput>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   