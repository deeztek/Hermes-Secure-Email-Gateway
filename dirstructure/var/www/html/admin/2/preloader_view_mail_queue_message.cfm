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
      <title>Hermes SEG | View Mail Queue Message</title>


</head>

<cfif NOT StructKeyExists(url, "msg_id")>

  <cfset m="View Mail Queue Message: url.msg_id does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif StructKeyExists(url, "msg_id")>

  <cfif #url.msg_id# is "">

  <cfset m="View Mail Queue Message: url.msg_id is empty">
  <cfinclude template="./inc/error.cfm">
  <cfabort>


<cfelseif #url.msg_id# is not "">      


<cfinclude template="./inc/mail_queue_view_message.cfm">


<!--- /CFIF #url.msg_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "msg_id") --->
</cfif>



<body style="background-image: url(/dist/img/hermes_preloader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

<cfoutput>
<meta http-equiv="refresh" content="3;url=view_mail_queue_message.cfm?msg_id=#url.msg_id#">
</cfoutput>

