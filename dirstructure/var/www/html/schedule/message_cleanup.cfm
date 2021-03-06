<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message Cleanup</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="696">
    <tr valign="top" align="left">
      <td width="24" height="38"></td>
      <td width="672"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="672" id="Text440" class="TextObject">
        <p style="margin-bottom: 0px;"><cfexecute name="/opt/hermes/scripts/disk_space_alert.sh"
variable="diskspace"
timeout="10" />

<cfset diskspace2=TRIM(#REReplace("#diskspace#","%","","ALL")#)>

<cfif #diskspace2# GTE 90>

<cfquery name="getoldest" datasource="#datasource#">
SELECT min(time_iso) as oldest FROM msgs
</cfquery>

<cfset oldest=#DateFormat(getoldest.oldest, "yyyy-mm-dd")#>

<cfset future=#DateFormat(DateAdd('d', 30, oldest),'yyyy-mm-dd')#>

<cfoutput>Oldest: #oldest# - 30 Days Future: #future#<br></cfoutput>

<cfquery name="getmsgs" datasource="#datasource#">
select mail_id, quar_loc from msgs where time_iso < '#future#'
</cfquery>

<cfoutput query="getmsgs">
Mail id: #mail_id# --- #quar_loc#<br>
</cfoutput>


<cfloop query="getmsgs">
<cfoutput>
<cfquery name="clearmsgrcpt" datasource="#datasource#">
delete from msgrcpt where mail_id = '#mail_id#'
</cfquery>
</cfoutput>
</cfloop>

<cfquery name="deletemsgs" datasource="#datasource#">
delete from msgs where time_iso < '#future#'
</cfquery>


<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>



<cfquery name="gettrans" datasource="#datasource#">
select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>


<cffile action="read" file="/opt/hermes/scripts/amavis_delete_files.sh" variable="amavis">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
    output = "#REReplace("#amavis#","THE-DATE","#future#","ALL")#">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
outputfile ="/dev/null"
timeout = "300">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh">


</cfif>

<cfquery name="getlogretention" datasource="#datasource#">
select parameter, value2, module from parameters2 where parameter = 'system_log_retention'
</cfquery>

<cfset TheLogRetention=#getlogretention.value2#>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset datepast=#DateFormat(DateAdd('d', -#TheLogRetention#, datenow),'yyyy-mm-dd')#>
<cfoutput>Date Now: #datenow#</cfoutput><br>

<!---
<cfquery name="syslog" datasource="syslog">
select min(ReceivedAt) as SysOldest from SystemEvents
</cfquery>


<cfif #syslog.SysOldest# is "">
<cfset sysoldest="#datenow#">
<cfelse>
<cfset sysoldest=#DateFormat(syslog.SysOldest, "yyyy-mm-dd")#>
</cfif>

<cfoutput>Syslog Oldest: #sysoldest#</cfoutput><br>
--->


<cfoutput>Syslog #TheLogRetention#: #datepast#</cfoutput><br>
<cfif #datepast# is not "">
<cfquery name="deleteoldlogs" datasource="syslog">
delete from SystemEvents where ReceivedAt < '#datepast#'
</cfquery>
</cfif>


&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   