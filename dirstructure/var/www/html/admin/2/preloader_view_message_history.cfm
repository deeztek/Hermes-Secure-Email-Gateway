<script language="JavaScript">
  if(document.images) image1 = new Image(); image1.src = 'dist/img/hermes_preloader.gif';
  </script>
  
<!DOCTYPE html>

  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
<html lang="en">

    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Hermes SEG | Message History</title>

 

</head>

    

<cfset defaultenddate2=#DateFormat(Now(),"yyyy-mm-dd")#>
  <cfset defaultendtime="23:59:59">
  <cfset defaultenddate="#defaultenddate2# #defaultendtime#">
  <cfset defaultstartdate=#DateAdd("h", -24, defaultenddate2)#>
  <cfset defaultstartdate=#DateFormat(defaultstartdate,"yyyy-mm-dd")#>
  <cfset defaultstarttime="00:00:00">
  <cfset defaultstartdate="#defaultstartdate# #defaultstarttime#">


  <!--- DEBUG ENABLE BELOW --->
<!---
  <cfoutput>Startdate: #defaultstartdate#<br>
  Enddate: #defaultenddate#</cfoutput>
 --->



    <cfparam name = "startdate" default = "#defaultstartdate#"> 
    <cfif IsDefined("url.startdate") is "True">
    <cfif url.startdate is not "">
    <cfif isValid("date", #url.startdate#)> 
    <cfset startdate = url.startdate>
    <cfelseif NOT isValid("date", #url.startdate#)>

    <cfset m="Message History Preloader: url.startdate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.startdate#) --->
     </cfif>

     <cfelseif url.startdate is "">

     <cfset m="Message History Preloader: url.startdate is empty">
     <cfinclude template="./inc/error.cfm">
     <cfabort>

    <!--- /CFIF url.startdate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.startdate") --->
    </cfif>
    
    <cfparam name = "enddate" default = "#defaultenddate#"> 
    <cfif IsDefined("url.enddate") is "True">
    <cfif url.enddate is not "">
    <cfif isValid("date", #url.enddate#)> 
    <cfset enddate = url.enddate>
    <cfelseif NOT isValid("date", #url.enddate#)>
    
    <cfset m="Preloader: url.enddate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.enddate#) --->
     </cfif>

    <cfelseif url.enddate is "">

      <cfset m="Message History Preloader: url.enddate is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <!--- /CFIF url.enddate is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.enddate") --->
    </cfif>

    <cfparam name = "limit" default = "1000">

    <cfif IsDefined("url.limit") is "True">

    <cfif url.limit is not "">

    <cfif #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000"> 

    <cfset limit = url.limit>

    <cfelse>
 
    <cfset m="Preloader: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000" --->
     </cfif>

    <cfelseif #limit# is "">

    <cfset m="Message History Preloader: url.limit is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF url.limit is "" --->
    </cfif>

     <!--- /CFIF IsDefined("url.limit") --->
    </cfif>


<body style="background-image: url(dist/img/hermes_preloader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

<cfoutput>
<meta http-equiv="refresh" content="3;url=view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#">
</cfoutput>

