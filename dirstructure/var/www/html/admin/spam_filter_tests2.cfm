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
<title>Spam Filter Tests2</title>
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
        <p style="margin-bottom: 0px;"><cfset success=0>
<cfset failure=0>

<cfquery name="getusebayes" datasource="#datasource#">
select value from spam_settings where parameter='use_bayes'
</cfquery>

<cfparam name = "usebayes" default = "#getusebayes.value#"> 



<CFLOOP index="thefield" list="#FORM.FIELDNAMES#">
<cfoutput>
<cfset theID = REReplaceNoCase(thefield,"the_","","all")>
<cfset theValue = #TRIM(evaluate(thefield))#>
ID:#TRIM(theID)#  VALUE: #TRIM(evaluate(thefield))#

<cfif IsValid("float", theValue)>
<cfif #theValue# LT -999>
<cfset failure=#failure#+1>
<cfelseif #theValue# GT 999>
<cfset failure=#failure#+1>
<cfelse>

<cfif #usebayes# is "1">
<cfquery name="getdefault" datasource="#datasource#">
select default_bayes_network as theDefault from spam_settings where id='#TRIM(theID)#'
</cfquery>

<cfelseif #usebayes# is "0">
<cfquery name="getdefault" datasource="#datasource#">
select default_network as theDefault from spam_settings where id='#TRIM(theID)#'
</cfquery>
</cfif>

<cfif #getdefault.theDefault# is "">
<cfset DefaultValue = 0>
<cfelse>
<cfset DefaultValue = #TRIM(getdefault.theDefault)#>
</cfif>

<cfset compare_value = Compare(#DefaultValue#, #theValue#)>


<cfif #compare_value# is not "0">
<cfquery name="updatetest" datasource="#datasource#">
update spam_settings set value = '#theValue#', active = '1', applied = '2' where id = '#theID#'
</cfquery>
<cfset success=#success#+1>

<cfelseif #compare_value# is "0">
<cfquery name="updatetest" datasource="#datasource#">
update spam_settings set value = '#theValue#', active = '2', applied = '1' where id = '#theID#'
</cfquery>

</cfif>




DEFAULT: #DefaultValue#<br>

</cfif>

<cfelseif NOT IsValid("float", theValue)>
<cfset failure=#failure#+1>
</cfif>


</cfoutput>
</CFLOOP>

<cfoutput>
<cflocation url="spam_filter_tests.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&s=#success#&f=#failure#&filter=#url.filter#&m=12">
</cfoutput>
&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   