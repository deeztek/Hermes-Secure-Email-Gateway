<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete Archive Task</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="483">
    <tr valign="top" align="left">
      <td width="30" height="28"></td>
      <td width="453"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="453" id="Text497" class="TextObject">
        <p style="margin-bottom: 0px;"><cfset testfile="/opt/hermes/tmp/#form.trans#_system_archive.sh">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>

<cfset testfile="/opt/hermes/tmp/#form.trans#_rsyncfiles">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>


<cfset testfile="/opt/hermes/tmp/#form.trans#_rsynccheck">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>
&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   