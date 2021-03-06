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
<title>System Logs Filter Advanced</title>
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
        <p style="margin-bottom: 0px;"><cfparam name = "m5" default = "0"> 

<cfoutput>
<cfparam name = "startdate" default = ""> 
<cfif IsDefined("form.startdate") is "True">
<cfif #form.startdate# is not "">
<cfif isValid("date", #form.startdate#)>
<cfset startdate = #form.startdate#>
<cfelseif NOT isValid("date", #form.startdate#)>
<cfset m5=6>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
<cfelseif #form.startdate# is "">
<cfset m5=7>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
</cfif>  

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("form.enddate") is "True">
<cfif #form.enddate# is not "">
<cfif isValid("date", #form.enddate#)>
<cfset enddate = #form.enddate#>
<cfelseif NOT isValid("date", #form.enddate#)>
<cfset m5=8>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
<cfelseif #form.enddate# is "">
<cfset m5=9>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif></cfif> 

</cfoutput>

<cfoutput>
<cfset starttime = #form.start#>
<cfset endtime = #form.end#>

#startdate# #starttime#<br>
#enddate# #endtime#
</cfoutput>

<cfparam name = "setfilter2" default = ""> 
<cfif IsDefined("form.setfilter2") is "True">
<cfset setfilter2 = #form.setfilter2#>
</cfif>

<cfparam name = "clearfilter2" default = ""> 
<cfif IsDefined("form.clearfilter2") is "True">
<cfset clearfilter2 = #form.clearfilter2#>
</cfif>

<cfparam name = "andor" default = ""> 
<cfif IsDefined("form.andor") is "True">
<cfif form.andor is not "">
<cfset andor = #form.andor#>
<cfelseif form.andor is "">
<cfset andor="">
</cfif></cfif>  

<cfoutput>ANDOR: #andor#</cfoutput>


<cfif #andor# is "AND">

<cfif #setfilter2# is "1">
<cfif #form.filter3# is "" OR #form.filter4# is "">
<cfset m5=12>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
<cfelseif #form.filter3# is not "" AND #form.filter3# is not "">
<cfif REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",form.filter3) gt 0 OR REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",form.filter4) gt 0 >
<cfset m5=2>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#form.filter3#') OR keyword IN ('#form.filter4#') and banned='1'
</cfquery>
<cfif #checkkeywords.recordcount# LT 1>
<cfset session.andor="#andor#">
<cfset session.searchtype="advanced">
<cfset session.filter3="#form.filter3#">
<cfset session.filter4="#form.filter4#">
<cfoutput>
<cflocation url="system_logs.cfm?m5=#m5#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=search" addtoken="no">
</cfoutput>

<cfelseif #checkkeywords.recordcount# GTE 1>

<cfset m5=3>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
</cfif>
</cfif>
</cfif>



<cfelseif #andor# is "OR">

<cfif #setfilter2# is "1">
<cfif #form.filter3# is "" OR #form.filter4# is not "">
<cfset m5=11>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
<cfelseif #form.filter3# is not "">
<cfif REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",form.filter3) gt 0>
<cfset m5=2>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#form.filter3#') and banned='1'
</cfquery>
<cfif #checkkeywords.recordcount# LT 1>
<cfset session.andor="#andor#">
<cfset session.searchtype="advanced">
<cfset session.filter3="#form.filter3#">
<cfoutput>
<cflocation url="system_logs.cfm?m5=#m5#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=search" addtoken="no">
</cfoutput>

<cfelseif #checkkeywords.recordcount# GTE 1>

<cfset m5=3>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
</cfif>
</cfif>
</cfif>








<cfelseif #andor# is "">

<cfif #setfilter2# is "1">
<cfif #form.filter3# is "">
<cfset session.andor="">
<cfset session.searchtype="advanced">
<cfoutput>
<cflocation url="system_logs.cfm?m5=#m5#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=search" addtoken="no">
</cfoutput>
<cfelseif #form.filter3# is not "" OR #form.filter4# is not "">
<cfset m5=10>
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>
</cfif>


</cfif>


<cfif #clearfilter2# is "1">
<cflocation url="system_logs.cfm?m5=#m5#" addtoken="no">
</cfif>

&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   