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
<title>Message History & Archive</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">



<cfset datasource="hermes">

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

<script type="text/javascript" language="javascript">// <![CDATA[
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array();
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
// ]]></script>


<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>



<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(192,192,192); background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu2',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu2.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<!--- GET HERMES USERNAME --->
<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfif #get_mysql_username_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_username_hermes.value# is not "">

<cfset mysqlusernamehermes=#get_mysql_username_hermes.value#>

</cfif>

<!--- GET HERMES PASSWORD --->
<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_password_hermes.value# is not "">


<!--- DECRYPT HERMES PASSWORD --->
<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>

</cfif>


<cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "50"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>

<cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">
<cfparam name = "usercount" default = "0">
<cfparam name = "rcptcount" default = "0">

<cfparam name = "s" default = ""> 
<cfif IsDefined("url.s") is "True">
<cfif url.s is not "">
<cfset s = url.s>
</cfif></cfif>

<cfparam name = "f" default = ""> 
<cfif IsDefined("url.f") is "True">
<cfif url.f is not "">
<cfset f = url.f>
</cfif></cfif>

<cfparam name = "a" default = ""> 
<cfif IsDefined("url.a") is "True">
<cfif url.a is not "">
<cfset a = url.a>
</cfif></cfif>


<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "searchtype2" default = ""> 
<cfif IsDefined("session.searchtype2") is "True">
<cfif session.searchtype2 is not "">
<cfset searchtype2 = session.searchtype2>
</cfif></cfif> 


<cfparam name = "searchfor" default = ""> 

<cfif IsDefined("session.searchfor") is "True">
<cfif session.searchfor is not "">
<cfset searchfor = session.searchfor>
</cfif>
</cfif>


<cfparam name = "msgno" default = ""> 
<cfif IsDefined("url.msgno") is "True">
<cfif url.msgno is not "">
<cfset msgno = url.msgno>
</cfif></cfif>  

<cfparam name = "m3" default = ""> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif> 

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif> 

<cfparam name = "m5" default = ""> 
<cfif IsDefined("url.m5") is "True">
<cfif url.m5 is not "">
<cfset m5 = url.m5>
</cfif></cfif>  

<cfparam name = "filter5" default = ""> 
<cfif #action# is "search">
<cfif IsDefined("session.filter5") is "True">
<cfif session.filter5 is not "">
<cfset filter5 = session.filter5>
</cfif>
</cfif>
</cfif>

<cfparam name = "sortby" default = ""> 
<cfif IsDefined("session.sortby") is "True">
<cfif session.sortby is not "">
<cfset sortby = session.sortby>
</cfif></cfif>

<cfparam name = "startdate" default = ""> 
<cfif IsDefined("url.startdate") is "True">
<cfif url.startdate is not "">
<cfif isValid("date", #url.startdate#)> 
<cfset startdate = url.startdate>
<cfelseif NOT isValid("date", #url.startdate#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("url.enddate") is "True">
<cfif url.enddate is not "">
<cfif isValid("date", #url.enddate#)> 
<cfset enddate = url.enddate>
<cfelseif NOT isValid("date", #url.enddate#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "starttime" default = ""> 
<cfif IsDefined("url.starttime") is "True">
<cfif url.starttime is not "">
<cfif isValid("time", #url.starttime#)> 
<cfset starttime = url.starttime>
<cfelseif NOT isValid("time", #url.starttime#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "endtime" default = ""> 
<cfif IsDefined("url.endtime") is "True">
<cfif url.endtime is not "">
<cfif isValid("time", #url.endtime#)> 
<cfset endtime = url.endtime>
<cfelseif NOT isValid("time", #url.endtime#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

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

<cfif #action# is "search">

<cfif #searchtype2# is "advanced">

<cfif #sortby# is "">


<cfif #searchfor# is "from_addr" OR #searchfor# is "subject" OR #searchfor# is "client_addr">

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, subject, from_addr, client_addr FROM msgs where #searchfor# Collate utf8_general_ci like '%#filter5#%'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

</cfif>

<cfelseif #searchfor# is "body">

<cfquery name="getsearches" datasource="#datasource#">
select * from searches where status='pending'
</cfquery>

<cfif #getsearches.recordcount# GTE 1>
<cfset session.searchfor="">
<cfset searchfor="">
<cflocation url="message_history_new.cfm?m5=16" addtoken="no">
</cfif>

<cfset totalevents=0>
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">
<cfset timenow2="#TimeFormat(now(), "HH:mm:ss")#">

<cfquery name="insertsearch" datasource="#datasource#">
insert into searches
(customtrans,
started,
searchfor,
status)
values
('#customtrans3#', 
'#datenow# #timenow2#', 
'#filter5#', 
'pending')
</cfquery>


<cffile action="read" file="/opt/hermes/scripts/grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","MYSQL-USER","#mysqlusernamehermes#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","MYSQL-PASSWORD","#mysqlpasswordhermes#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","SEARCH-STRING","#filter5#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_grepmail.sh"
timeout = "60">
</cfexecute>

<cffile action="read" file="/opt/hermes/templates/search_task.cfm" variable="restoretask">

<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>



<cffile action = "write"
    file = "/var/www/html/schedule/#customtrans3#_search_task.cfm"
    output = "#REReplace("#restoretask#","THE-TRANSACTION","#customtrans3#","ALL")#"> 


<!---
<cfset datenow=#DateFormat(Now(),"mm/dd/yyyy")#>
<cfset timenow="#TimeFormat(now(), "HH:mm")#">
<cfset theStamp="#datenow# #timenow#">
<cfset past=#DateAdd("d", -5, theStamp)#> 
<cfset date1="#dateformat(past, "yyyy-mm-dd")#">
<cfset time1="#timeformat(past, "HH:mm")#">


<cfschedule action="update"
task="search_#customtrans3#"
operation="HTTPRequest"
startdate="#date1#"
starttime="#time1#"
requesttimeout="7200"
url="http://localhost:8888/schedule/#customtrans3#_search_task.cfm"
interval="once">

<cfschedule  
action = "run"  
task = "search_#customtrans3#"> 

--->

<cfexecute name = "/usr/bin/curl"
arguments="--silent http://localhost:8888/schedule/#customtrans3#_search_task.cfm"
timeout = "0">
</cfexecute>

<cfset session.searchfor="">
<cfset searchfor="">

<cflocation url="message_history_new.cfm?m5=14" addtoken="no">



<cfelseif #searchfor# is "bodyresults">

<cfset totalevents=#session.totalevents#>


<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr, body_temp.quar_loc, body_temp.customtrans from body_temp LEFT JOIN msgs ON msgs.quar_loc = body_temp.quar_loc INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where body_temp.customtrans = '#session.customtrans#'  order by msgs.time_iso desc
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>


<cfelseif #searchfor# is "to_addr">
<cfquery name="getevents" datasource="#datasource#">
SELECT count(msgs.mail_id) as count, msgrcpt.rid, msgrcpt.mail_id, maddr.email as toEmail, maddr.id from msgs INNER JOIN msgrcpt ON
 msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.rid, msgrcpt.mail_id, msgrcpt.ds, maddr.email as toEmail, maddr.id, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.rid, msgrcpt.mail_id, msgrcpt.ds, maddr.email as toEmail, maddr.id, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

</cfif>


<cfelseif #searchfor# is "sid">

<cfquery name="emailexists" datasource="#datasource#">
select id, email from maddr where email='#filter5#'
</cfquery>

<cfif #emailexists.recordcount# GTE 1>

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count FROM msgs where  #searchfor# = '#emailexists.id#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# = '#emailexists.id#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# = '#emailexists.id#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

</cfif>

<cfelseif #emailexists.recordcount# LT 1>

<cfset totalevents=0>

<!-- /CFIF for emailexists.recordcount -->
</cfif>

<cfelseif #searchfor# is "none">
<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset starttime2 = #TimeFormat(starttime, "HH:mm:ss")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>
<cfset endtime2 = #TimeFormat(endtime, "HH:mm:ss")#>

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, time_iso FROM msgs where time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#'  
</cfquery>
 
<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows# 
</cfquery>

</cfif>


<!-- /CFIF for searchfor -->
</cfif>

<cfelseif #sortby# is not "">

<cfif #searchfor# is "from_addr" OR #searchfor# is "subject" or #searchfor# is "client_addr">

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, subject, from_addr, content, client_addr FROM msgs where #searchfor# Collate utf8_general_ci like '%#filter5#%'
 and content like binary '#sortby#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit 0, #DisplayRows# 
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows# 
</cfquery>

</cfif>

<cfelseif #searchfor# is "body">

<cfquery name="getsearches" datasource="#datasource#">
select * from searches where status='pending'
</cfquery>

<cfif #getsearches.recordcount# GTE 1>
<cfset session.searchfor="">
<cfset searchfor="">
<cflocation url="message_history_new.cfm?m5=16" addtoken="no">
</cfif>

<cfset totalevents=0>
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">
<cfset timenow2="#TimeFormat(now(), "HH:mm:ss")#">


<cfquery name="insertsearch" datasource="#datasource#">
insert into searches
(customtrans,
started,
searchfor,
status)
values
('#customtrans3#', 
'#datenow# #timenow2#', 
'#filter5#', 
'pending')
</cfquery>


<cffile action="read" file="/opt/hermes/scripts/grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","MYSQL-USER","#mysqlusernamehermes#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","MYSQL-PASSWORD","#mysqlpasswordhermes#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","SEARCH-STRING","#filter5#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_grepmail.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_grepmail.sh"
    output = "#REReplace("#temp#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_grepmail.sh"
timeout = "60">
</cfexecute>

<cffile action="read" file="/opt/hermes/templates/search_task.cfm" variable="restoretask">

<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>



<cffile action = "write"
    file = "/var/www/html/schedule/#customtrans3#_search_task.cfm"
    output = "#REReplace("#restoretask#","THE-TRANSACTION","#customtrans3#","ALL")#"> 


<!---
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm")#">
<cfset theStamp="#datenow# #timenow#">
<cfset past=#DateAdd("d", -5, theStamp)#> 
<cfset date1="#dateformat(past, "yyyy-mm-dd")#">
<cfset time1="#timeformat(past, "HH:mm")#">

<cfschedule action="update"
task="search_#customtrans3#"
operation="HTTPRequest"
startdate="#date1#"
starttime="#time1#"
requesttimeout="7200"
url="http://localhost:8888/schedule/#customtrans3#_search_task.cfm"
interval="once">


<cfschedule  
action = "run"  
task = "search_#customtrans3#">

---> 

<cfexecute name = "/usr/bin/curl"
arguments="--silent http://localhost:8888/schedule/#customtrans3#_search_task.cfm"
timeout = "0">
</cfexecute>

<cfset session.searchfor="">
<cfset searchfor="">

<cflocation url="message_history_new.cfm?m5=14" addtoken="no">


<cfelseif #searchfor# is "bodyresults">

<cfset totalevents=#session.totalevents#>

<cfif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr, body_temp.quar_loc, body_temp.customtrans from body_temp LEFT JOIN msgs ON msgs.quar_loc = body_temp.quar_loc INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where body_temp.customtrans = '#session.customtrans#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>



<cfelseif #totalevents# EQ 1>
<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr, body_temp.quar_loc, body_temp.customtrans from body_temp LEFT JOIN msgs ON msgs.quar_loc = body_temp.quar_loc INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where body_temp.customtrans = '#session.customtrans#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

</cfif>

<cfelseif #searchfor# is "to_addr">

<cfquery name="getevents" datasource="#datasource#">
SELECT count(msgs.mail_id) as count, msgrcpt.rid, msgrcpt.mail_id, maddr.email as toEmail, maddr.id, msgs.content from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%' and msgs.content like binary '#sortby#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.rid, msgrcpt.mail_id, msgrcpt.ds, maddr.email as toEmail, maddr.id, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.rid, msgrcpt.mail_id, msgrcpt.ds, maddr.email as toEmail, maddr.id, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id INNER JOIN maddr ON msgrcpt.rid = maddr.id where maddr.email like '%#filter5#%' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

</cfif>

<cfelseif #searchfor# is "sid">

<cfquery name="emailexists" datasource="#datasource#">
select id, email from maddr where email='#filter5#'
</cfquery>

<cfif #emailexists.recordcount# GTE 1>

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count FROM msgs where  #searchfor# = '#emailexists.id#' and content like binary '#sortby#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
select msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# = '#emailexists.id#' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit 0, #DisplayRows# 
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
select msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.#searchfor# = '#emailexists.id#' and msgs.content like binary '#sortby#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows# 
</cfquery>

</cfif>

<cfelseif #emailexists.recordcount# LT 1>

<cfset totalevents=0>

<!-- /CFIF for emailexists.recordcount -->
</cfif>

<cfelseif #searchfor# is "none">
<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset starttime2 = #TimeFormat(starttime, "HH:mm:ss")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>
<cfset endtime2 = #TimeFormat(endtime, "HH:mm:ss")#>

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, time_iso, content FROM msgs where content like binary
 '#sortby#' and time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.content like binary '#sortby#' and msgs.time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.content like binary '#sortby#' and msgs.time_iso between '#startdate2# #starttime2#' and '#enddate2# #endtime2#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
 </cfquery>

</cfif>

<!-- /CFIF for searchfor -->
</cfif>

<!-- /CFIF for sortby -->
</cfif>

<!-- /CFIF for searchtype2 -->
</cfif>

<cfelse>
<cfif #sortby# is "">

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, time_iso FROM msgs
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
 </cfquery>

</cfif>

<cfelseif #sortby# is not "">

<cfquery name="getevents" datasource="#datasource#">
SELECT count(sid) as count, time_iso, content FROM msgs where content like binary '#sortby#'
</cfquery>

<cfset totalevents=#getevents.count#>

<cfif #totalevents# EQ 1>

<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.content like binary '#sortby#' order by msgs.time_iso desc limit 0, #DisplayRows#
</cfquery>

<cfelseif #totalevents# GT 1>
<cfquery name="getmsgs" datasource="#datasource#">
SELECT msgrcpt.mail_id, msgrcpt.ds, msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgs.archive, msgs.client_addr FROM msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.content like binary '#sortby#' order by msgs.time_iso desc limit #StartRow#, #DisplayRows# 
 </cfquery>

</cfif>

<!-- /CFIF for sortby-->
</cfif>

<!-- /CFIF for emailexists.recordcount -->
</cfif>

<CFIF ToRow GT totalevents>
<CFSET ToRow = totalevents>
</CFIF>




          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./top_blue_3.png'); height: 131px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="709">
                        <tr valign="top" align="left">
                          <td width="45" height="92"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="13"></td>
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="555" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion31" style="background-image: url('./middle_988.png'); height: 555px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="421">
                              <tr valign="top" align="left">
                                <td width="17" height="17"></td>
                                <td width="404"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="404" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Message&nbsp; History &amp; Archive</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="513">
                              <tr valign="top" align="left">
                                <td width="168"></td>
                                <td width="137"></td>
                                <td width="208" id="Text463" class="TextObject">
                                  <p style="text-align: right; margin-bottom: 0px;"><cfquery name="getsearches" datasource="#datasource#">
select * from searches where status='pending'
</cfquery>

<cfif #getsearches.recordcount# GTE 1>

<a href="search_progress.cfm"><img id="Picture49" height="15" width="15" src="search_progress.png" border="0" alt="Search in Progress..." title="Search in Progress..."></a>

<cfelseif #getsearches.recordcount# LT 1>

<cfquery name="getsearches2" datasource="#datasource#">
select * from searches where status='completed'
</cfquery>

<cfif #getsearches2.recordcount# GTE 1>

<a href="search_progress.cfm"><img id="Picture49" height="15" width="15" src="search_complete.png" border="0" alt="Search is Complete" title="Search is Complete"></a>

</cfif>
</cfif>&nbsp;</p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="345" id="Text455" class="TextObject"><cfquery name="getearliest" datasource="#datasource#">
SELECT time_iso FROM `msgs` order by time_iso asc limit 1
</cfquery>
<cfset earliestdate = #DateFormat(getearliest.time_iso, "mm/dd/yyyy")#>
<cfset earliesttime = #TimeFormat(getearliest.time_iso, "HH:mm:ss")#>

<cfoutput>
                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;"><b><span style="font-size: 12px;">Earliest Message Date/Time:</span></b> #earliestdate# #earliesttime#</span></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="36">
                              <tr valign="top" align="left">
                                <td width="11" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="17" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="948"><hr id="HRRule18" width="948" size="1"></td>
                        </tr>
                      </table>
                      <table cellpadding="0" cellspacing="0" border="0" width="964">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="17" height="2"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="579">
                                  <form name="Table144FORM" action="<cfoutput>message_history_filter.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                                    <input type="hidden" name="setfilter" value="1">
                                    <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                      <tr style="height: 25px;">
                                        <td width="235" id="Cell865">
                                          <table width="212" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfquery name="msg_types" datasource="#datasource#">
select * from msg_content_type where user='1' order by description asc
</cfquery>
<cfif #sortby# is "">
<select name="sortby" style="height: 24px;">
  <option value="" selected="selected">ALL</option>
  <cfoutput query="msg_types">
 <option value="#content_type#">#description#</option>
</cfoutput>
</select>
<cfelseif #sortby# is not "">
<select name="sortby" style="height: 24px;">
<cfquery name="getdesc" datasource="#datasource#">
select description from msg_content_type where content_type like binary '#sortby#'
</cfquery>
<cfoutput>
  <option value="#sortby#" selected="selected">#getdesc.description#</option>
</cfoutput>
  <cfoutput query="msg_types">
 <option value="#content_type#">#description#</option>
</cfoutput>
<option value="">ALL</option>
</select>
</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td width="344" id="Cell866">
                                          <table width="276" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear & Sort" style="height: 24px; width: 175px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="22" height="2"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="346">
                                  <form name="Table167FORM" action="<cfoutput>message_history_edit_quarantine.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="displayrows">
                                    <table id="Table167" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 2px;">
                                      <tr style="height: 24px;">
                                        <td width="185" id="Cell1047">
                                          <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">No of Msgs to display</span></p>
                                        </td>
                                        <td width="85" id="Cell1048">
                                          <table width="72" border="0" cellspacing="0" cellpadding="0" align="right">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #DisplayRows# is "50">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="50" selected="selected">50</option>
    
  <option value="100">100</option>
  </select>

<cfelseif #DisplayRows# is "100">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="100" selected="selected">100</option>
  <option value="50">50</option>

  </select>

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td width="76" id="Cell1049">
                                          <table width="63" border="0" cellspacing="0" cellpadding="0" align="right">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" value="Go" style="height: 24px; width: 48px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="17" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="947"><hr id="HRRule19" width="947" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="17" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="947">
                            <form name="advanced" action="<cfoutput>message_history_filter_advanced.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                              <input type="hidden" name="setfilter2" value="1">
                              <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 45px;">
                                <tr style="height: 21px;">
                                  <td width="160" id="Cell1036">
                                    <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 12px;">Search Phrase</span></p>
                                  </td>
                                  <td width="94" id="Cell1035">
                                    <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 12px;">Search Field(s)</span></p>
                                  </td>
                                  <td width="33" id="Cell1033">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                  <td width="97" id="Cell1032">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Start Date</span></p>
                                  </td>
                                  <td width="101" id="Cell1042">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Start Time</span></p>
                                  </td>
                                  <td width="33" id="Cell1044">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                  <td width="99" id="Cell1031">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">End Date</span></p>
                                  </td>
                                  <td width="101" id="Cell1038">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">End Time</span></p>
                                  </td>
                                  <td width="229" id="Cell1028">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                </tr>
                                <tr style="height: 24px;">
                                  <td id="Cell1018">
                                    <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField42" name="filter5" size="15" maxlength="255" style="width: 116px; white-space: pre;" value="#filter5#">
</cfoutput>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1021">
                                    <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #searchfor# is "">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
  <option value="none" selected="selected">DATE ONLY</option>
  <option value="from_addr">FROM</option>
  <option value="sid">RETURN-PATH</option>
  <option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
  <option value="body">BODY/HEADERS</option>
<option value="client_addr">SENDER IP</option>

</select>

<cfelseif #searchfor# is "from_addr">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="from_addr" selected="selected">FROM</option>
</cfoutput>
<option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
<option value="sid">RETURN-PATH</option>
<option value="none">DATE ONLY</option>
<option value="body">BODY/HEADERS</option>
<option value="client_addr">SENDER IP</option>

</select>

<cfelseif #searchfor# is "sid">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="sid" selected="selected">RETURN-PATH</option>
</cfoutput>
<option value="from_addr">FROM</option>

<option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
<option value="none">DATE ONLY</option>
<option value="body">BODY/HEADERS</option>
<option value="client_addr">SENDER IP</option>

</select>


<cfelseif #searchfor# is "subject">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="subject" selected="selected">SUBJECT</option>
</cfoutput>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
<option value="to_addr">TO</option>
<option value="none">DATE ONLY</option>
<option value="body">BODY/HEADERS</option>
<option value="client_addr">SENDER IP</option>

</select>

<cfelseif #searchfor# is "body">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="body" selected="selected">BODY/HEADERS</option>
</cfoutput>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
<option value="to_addr">TO</option>
<option value="none">DATE ONLY</option>
<option value="subject">SUBJECT</option>
<option value="client_addr">SENDER IP</option>

</select>

<cfelseif #searchfor# is "to_addr">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="to_addr" selected="selected">TO</option>
</cfoutput>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
  <option value="body">BODY/HEADERS</option>
<option value="none">DATE ONLY</option>
<option value="subject">SUBJECT</option>
<option value="client_addr">SENDER IP</option>

<cfelseif #searchfor# is "bodyresults">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
   <option value="none" selected="selected">DATE ONLY</option>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
  <option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
  <option value="body">BODY/HEADERS</option>
   <option value="client_addr">SENDER IP</option>

<cfelseif #searchfor# is "client_addr">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
   <option value="client_addr" selected="selected">SENDER IP</option>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
  <option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
  <option value="body">BODY/HEADERS</option>
  <option value="none">DATE ONLY</option>




</select>





<cfelseif #searchfor# is "none">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="none" selected="selected">DATE ONLY</option>
</cfoutput>
  <option value="from_addr">FROM</option>
<option value="sid">RETURN-PATH</option>
<option value="to_addr">TO</option>
  <option value="subject">SUBJECT</option>
<option value="body">BODY/HEADERS</option>
<option value="client_addr">SENDER IP</option>

</select>




</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1019">
                                    <table width="20" border="0" cellspacing="0" cellpadding="0" align="right">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('advanced',%20'startdate')"><img id="Picture49" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1026">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="80" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="startdate" size="10" maxlength="10" style="width: 76px; white-space: pre;" value="#startdate#">
</cfoutput>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1043">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="77" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfset stime = CreateTime(01,0,0)> 
<cfset etime = CreateTime(24,45,0)>
 
<cfif #starttime# is "">
<select name="start" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
<option value="00:00:00" SELECTED>12:00:00 AM</option>

</select>

<cfelseif #starttime# is not "">
<cfset starttime2=#TimeFormat(starttime, "hh:mm tt")#>
<select name="start" style="height: 22px;">
<cfoutput>
<option value="#starttime#" SELECTED>#starttime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
</select>

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1045">
                                    <table width="20" border="0" cellspacing="0" cellpadding="0" align="right">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('advanced',%20'enddate')"><img id="Picture50" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1027">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="80" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="enddate" size="10" maxlength="10" style="width: 76px; white-space: pre;" value="#enddate#">
</cfoutput>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1039">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="77" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #endtime# is "">
<select name="end" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59" SELECTED>11:59:59 PM</option>

</select>

<cfelseif #endtime# is not "">
<cfset endtime2=#TimeFormat(endtime, "hh:mm tt")#>
<select name="end" style="height: 22px;">
<cfoutput>
<option value="#endtime#" SELECTED>#endtime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
</select>

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1020">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" value="Advanced Search" style="height: 24px; width: 171px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </form>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="16" height="4"></td>
                          <td width="949"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="949" id="Text441" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m5# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you have entered an invalid Start Date</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Start Date field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you have entered an invalid End Date</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the End Date field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select NONE in the Search Field, ensure Keyword1 field is blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select KEYWORD1 in the Search Mode field, ensure Keyword1 field is NOT blank and Keyword2 field IS blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Search Phrase field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Search Phrase field must contain multiple keywords sepearated by spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! The Body/Header Search you requested is in progress. Body/Header searches can take a considerable amount of time to complete. You will not be able to perform another Body/Header search until this search is complete. When the search is complete, the search status icon on the top right of the page will turn from red to green. You can view completed searches or cancel pending searches by clicking the search status icon on top right of this page.<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">&nbsp;&nbsp;Please Note: Body/Headers search results are limited to a maximum of 500 results</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;a Body/Header search is still in progress. You will not be able to perform any Body/Header searches until all previous searches are complete or cancelled. If you wish to cancel a search in progress, click the search status icon on the top right of this page</span></i></b></p>
</cfoutput>
</cfif>



&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td width="950"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="950" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 10px;"><b><span style="color: rgb(255,0,0);">*</span></b><i><b><span style="color: rgb(255,0,0);">Please note: </span></b>When searches yields no results, ensure that the message type is set to ALL and then perform your search again. The search function takes the message type into consideration when performing searches. For example, if the message type is set to Spam(Quarantined) and you search the subject for a keyword, the system will only search for the keyword in the subject for messages that are of type Spam(Quarantined).</i></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="951"><hr id="HRRule6" width="951" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952">
                            <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                              <tr style="height: 17px;">
                                <td width="272" id="Cell869">
                                  <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m5# is "">
<CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="loading4.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Messages</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                <td width="391" id="Cell870">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center">
                                        <table width="242" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="margin-bottom: 0px;"><cfif #m5# is "">
<cfif #totalevents# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying <cfif #StartRow# is "0">1<cfelseif #StartRow# is NOT "0">#StartRow#</cfif> through #toRow# out of #totalevents# total messages.</span></p>
</cfoutput>
<cfelse>
</cfif>

</cfif>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="289" id="Cell871">
                                  <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="text-align: right; margin-bottom: 0px;"><cfif #m5# is "">
<cfoutput>
<CFIF Next LTE totalevents>
<A HREF="loading4.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (totalevents - Next) LT DisplayRows>
      #Evaluate((totalevents - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Messages&nbsp; &gt;&gt;</SPAN></b></P></A>
<CFELSE>
  
</CFIF>
</CFOUTPUT>

</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text498" class="TextObject">
                            <p style="margin-bottom: 0px;">&nbsp;</p>
                            <cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Message has been released</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to release message. This usually happens if the message does not exist or if the message has been archived. Archived messages cannot be released. They can only
 be viewed or downloaded individually</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="warning_icon" title="warning_icon">&nbsp;the message you are attempting to view does not exist</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to retrieve the archived message you are attempting to view. Ensure that an archive job that points to the correct archived messages share exists and that the
 share is succesfully mounted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Allow Sender">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully allow #s# sender(s). <cfif #f# GTE 1>However it was NOT able to allow #f# sender(s). This is usually
 caused by the fact that the sender(s) already exist</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Block Sender">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully block #s# sender(s). <cfif #f# GTE 1>However it was NOT able to block #f# sender(s). This is usually
 caused by the fact that the sender(s) already exist</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Release Msg">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully release #s# message(s). <cfif #f# GTE 1>However it was NOT able to release #f# message(s). This is
 usually caused by the fact that some of the messages you selected do not exist in quarantine, or they have been archived. Archived messages cannot be released. They can only be viewed or downloaded individually</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Delete Msg">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully delete #s# message(s). <cfif #f# GTE 1>However it was NOT able to delete #f# message(s). This is
 usually caused by the fact that some of the messages you selected were already deleted</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Train as Spam">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system was able to train the Spam/Virus Filter with #s# message(s) as Spam. <cfif #f# GTE 1>However, the system was NOT able to train the Spam/Virus filter with
 #f# message(s). This is usually caused by the fact that some of the messages you selected were already processed. Please note that it may take multiple times for the Spam/Virus filter to start recognizing certain e-mails as Spam</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Forget">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The Spam/Virus Filter was able to forget #s# message(s). <cfif #f# GTE 1>However, the Spam/Virus filter was not able to forget #f# message(s).</cfif>
</span></i></b></p>
</cfoutput>
</cfif>


<cfif #a# is "Train as NOT Spam">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0"
 align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system was able to train the Spam/Virus Filter with #s# message(s) as NOT Spam. <cfif #f# GTE 1>However, the system was NOT able to train the Spam/Virus filter
 with #f# message(s). This is usually caused by the fact that some of the messages you selected were already processed. Please note that it may take multiple times for the Spam/Virus filter to start recognizing certain e-mails as NOT
 Spam</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "notlocal">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to Block/Allow this sender because the recipient is not local</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "virtual">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to Block/Allow this sender because the recipient is virtual</span></i></b></p>
</cfoutput>
</cfif></td>
                        </tr>
                      </table>
                      <table cellpadding="0" cellspacing="0" border="0" width="200">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="104">
                              <tr valign="top" align="left">
                                <td width="15" height="3"></td>
                                <td width="89"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="17"></td>
                                <td width="89" id="Text458" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', true);" href="javascript:void();"><span style="font-size: 10px;">Select All</span></a></b><span style="font-size: 10px;"></span>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="96">
                              <tr valign="top" align="left">
                                <td width="7" height="3"></td>
                                <td width="89"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="89" id="Text462" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', false);" href="javascript:void();"><span style="font-size: 10px;">None</span></a></b>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="962">
                        <tr valign="top" align="left">
                          <td width="14" height="3"></td>
                          <td width="948"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="948" id="Text497" class="TextObject">
                            <p style="margin-bottom: 0px;">&nbsp;</p>
                            <cfif #m5# is "">
<cfif #totalevents# GTE 1>



<form name="edit"
 action="<cfoutput>message_history_edit_quarantine.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&s
tarttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
<hr id="HRRule8" width="977" size="1">

<table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 30px;">
    <td width="138" id="Cell1046">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          
<td><input type="submit" id="FormsButton1" name="action" value="Block Sender" style="height: 24px; width: 153px;"></td>


        </tr>
      </table>
    </td>
    <td width="138" id="Cell1047">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
<td><input type="submit" id="FormsButton1" name="action" value="Allow Sender" style="height: 24px; width: 153px;"></td>

          
        </tr>
      </table>
    </td>
    <td width="138" id="Cell1048">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Release Msg" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
 
<cfquery name="getbayes" datasource="#datasource#">   
SELECT parameter, value FROM spam_settings where parameter = 'use_bayes'
</cfquery>

<cfif #getbayes.value# EQ 1>
<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Train as Spam" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>

<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Train as NOT Spam" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
    
    <td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Forget" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>


<cfelseif #getbayes.value# EQ 0>

<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Train as Spam" disabled="disabled" style="height: 24px; width:
 153px;"></td>
        </tr>
      </table>
    </td>

<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Train as NOT Spam"  disabled="disabled" style="height: 24px; width:
 153px;"></td>
        </tr>
      </table>
    </td>
    
    <td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><input type="submit" id="FormsButton1" name="action" value="Forget"  disabled="disabled" style="height: 24px; width:
 153px;"></td>
        </tr>
      </table>
    </td>





</cfif>


  </tr>
</table>
<hr id="HRRule8" width="977" size="1">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Archived</span></b></p>
    </td>


    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Date/Time</span></b></p>
    </td>
 <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Sender IP</span></b></p>
    </td>

   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Return-Path</span></b></p>
    </td>


   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">From</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">To</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Subject</span></b></p>
    </td>
    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Spam Score</span></b></p>
    </td>
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Action</span></b></p>
    </td>


<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View</span></b></p>
    </td>
  
    
  </tr>


<cfoutput query="getmsgs">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">


     
<td align="center">
<input type="checkbox" name="cbox#mail_id#" value="#mail_id#|#secret_id#" style="height: 13px; width: 13px;">
</td>

    <td id="Cell1055">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#archive# </span></p>
</div>
    </td>


    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#date# #time# </span></p>
</div>
    </td>

    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#client_addr# </span></p>
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="#datasource#">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#getfromaddr.fromAddress#</span></p>
</div>
    </td>



    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#htmlEditFormat(from_addr)#</span></p>
</div>
    </td>

<cfquery name="gettoaddr" datasource="#datasource#">
SELECT msgrcpt.rid,maddr.email as toAddress FROM msgrcpt INNER JOIN maddr ON msgrcpt.rid = maddr.id where mail_id='#mail_id#'
</cfquery>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#gettoaddr.toAddress#</span></p>
</div>
    </td>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#subject#</span></p>
</div>
    </td>

    <td id="Cell1061">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#Numberformat (spam_level, '____.__')#</span></p>
</div>
    </td>




<cfquery name="gettype" datasource="#datasource#">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>


<td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#gettype.description#</span></p>
</div>
    </td>



<cfif #ds# is "P">
<td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Delivered</span></p>
</div>
    </td>

<cfelseif #ds# is "D">

<td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Blocked</span></p>
</div>
    </td>

<cfelseif #ds# is "B">

<td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Blocked</span></p>
</div>
    </td>

<cfelse>

<td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">N/A</span></p>
</div>
    </td>

</cfif>

<td align="center"><a href="loading3.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="view_icon.png" border="0" alt="View Message" title="View Message" </td>





</cfoutput>
        </tr>
      </table>
</form>

<cfelseif #totalevents# LT 1>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(255,0,0);">No Results Found</span></p>
 
</cfif>
      
</cfif></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>
&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
   