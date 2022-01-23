<script language="JavaScript">
  if(document.images) image1 = new Image(); image1.src = '/dist/img/hermes_preloader.gif';
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
      <title>Hermes SEG | View Message</title>


</head>



    <cfparam name = "startdate" default = ""> 
    <cfif IsDefined("url.startdate") is "True">
    <cfif url.startdate is not "">
    <cfif isValid("date", #url.startdate#)> 
    <cfset startdate = url.startdate>
    <cfelseif NOT isValid("date", #url.startdate#)>

    <cfset m="View Message Preloader: url.startdate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.startdate#) --->
     </cfif>

     <cfelseif url.startdate is "">

     <cfset m="View Message Preloader: url.startdate is empty">
     <cfinclude template="./inc/error.cfm">
     <cfabort>

    <!--- /CFIF url.startdate is "" --->
    </cfif>

  <cfelse>

    
    <cfset m="View Message Preloader: url.startdate is undefined">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

     <!--- /CFIF IsDefined("url.startdate") --->
    </cfif>
    
    <cfparam name = "enddate" default = ""> 
    <cfif IsDefined("url.enddate") is "True">
    <cfif url.enddate is not "">
    <cfif isValid("date", #url.enddate#)> 
    <cfset enddate = url.enddate>
    <cfelseif NOT isValid("date", #url.enddate#)>
    
    <cfset m="View Message Preloader: url.enddate is invalid">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF NOT isValid("date", #url.enddate#) --->
     </cfif>

    <cfelseif url.enddate is "">

      <cfset m="View Message Preloader: url.enddate is empty">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

    <!--- /CFIF url.enddate is "" --->
    </cfif>

  <cfelse>

    <cfset m="View Message Preloader: url.enddate is undefined">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

     <!--- /CFIF IsDefined("url.enddate") --->
    </cfif>

    <cfparam name = "limit" default = "">

    <cfif IsDefined("url.limit") is "True">

    <cfif url.limit is not "">

    <cfif #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000"> 

    <cfset limit = url.limit>

    <cfelse>
 
    <cfset m="View Message Preloader: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000" --->
     </cfif>

    <cfelseif #limit# is "">

    <cfset m="View Message Preloader: url.limit is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF url.limit is "" --->
    </cfif>

  <cfelse>

    <cfset m="View Message Preloader: url.limit is undefined">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

     <!--- /CFIF IsDefined("url.limit") --->
    </cfif>


<body style="background-image: url(/dist/img/hermes_preloader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

<cfoutput>
<meta http-equiv="refresh" content="3;url=view_message.cfm?mid=#url.mid#&startdate=#url.startdate#&enddate=#url.enddate#&limit=#url.limit#">
</cfoutput>

