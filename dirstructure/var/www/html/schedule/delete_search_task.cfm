<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete Search Task</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="548">
    <tr valign="top" align="left">
      <td width="24" height="32"></td>
      <td width="524"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="524" id="Text499" class="TextObject">
        <p style="margin-bottom: 0px;"><cfoutput>
<cfschedule
action = "delete"
task = "search_#form.trans#">

the Trans: #form.trans#<br>
the task: search_#form.trans#
</cfoutput>






<cfset testfile="/opt/hermes/tmp/#form.trans#_grepmail.sh">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>

<cfset testfile="/opt/hermes/tmp/#form.trans#_results.txt">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>


<cfset testfile="/var/www/html/schedule/#form.trans#_search_task.cfm">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>


<!--- TRIM RECORDS --->
<cfquery name="gettotalrecords" datasource="#datasource#">
select count(customtrans)as theTotal from body_temp where customtrans = '#form.trans#'
</cfquery>

<cfif #gettotalrecords.theTotal# GT 500>
<cfquery name="trimrecords" datasource="#datasource#">
DELETE FROM `body_temp` WHERE id NOT IN (SELECT id FROM (SELECT id, customtrans FROM `body_temp` where customtrans = '#form.trans#' ORDER BY id DESC LIMIT 500) foo)
</cfquery>
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   