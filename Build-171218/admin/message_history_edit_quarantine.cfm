<!--
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
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message History Edit Quarantine</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script language="JavaScript">
if(document.images) image1 = new Image(); image1.src = 'ajax-loader.gif';
</script>

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <br><br><br><br><br><br><br><br>
<body style="background-image: url(ajax-loader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

  <table border="0" cellspacing="0" cellpadding="0" width="847">
    <tr valign="top" align="left">
      <td width="30" height="30"></td>
      <td width="817"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="817" id="Text380" class="TextObject">
        <p style="margin-bottom: 0px;">&nbsp;</p>
        <cfoutput>
ACTION: #form.action#<br>
</cfoutput>
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
CHECKBOX:#thefield#<br>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>
MailID: #mailid#<br>
SECRETID: #secretid#<br>


</cfoutput>
</cfif>
</cfloop>

<cfset success=0>
<cfset failure=0>
<cfset action="#form.action#">


<cfif #action# is "Block Sender">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getrid" datasource="#datasource#">
SELECT rid from msgrcpt where mail_id='#mailid#'
</cfquery>

<cfquery name="gettoaddr" datasource="#datasource#">
SELECT email as toAddress FROM maddr where id='#getrid.rid#'
</cfquery>

<cfquery name="getrecipientid" datasource="#datasource#">
select id, recipient from recipients where recipient='#gettoaddr.toAddress#'
</cfquery>

<cfif #getrecipientid.recordcount# GTE 1>

<cfset recipient = #getrecipientid.id#>
<cfelse>
<cflocation url="loading4.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#url.action#&s=#success#&f=#failure#&a=notlocal">
</cfif>

<cfquery name="getsenderid" datasource="#datasource#">
SELECT sid from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfquery name="getsenderemail" datasource="#datasource#">
SELECT email from maddr where id='#getsenderid.sid#'
</cfquery>

<cfset sender="#getsenderemail.email#">

<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#gettoaddr.toAddress#' and sender='#sender#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>


<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='#sender#'
</cfquery>



<cfif #checksenderemail.recordcount# LT 1>


<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('#sender#')
</cfquery>

<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'BLOCK', 'insert', '#gettoaddr.toAddress#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'B')
</cfquery>

<cfset success=#success#+1>


<cfelseif #checksenderemail.recordcount# GTE 1>


<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'BLOCK', 'insert', '#gettoaddr.toAddress#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'B')
</cfquery>

<cfset success=#success#+1>

</cfif>



<cfelseif #checkexists.recordcount# GTE 1>
<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>

<cfelseif #action# is "displayrows">

<cflocation url="loading4.cfm?StartRow=#url.StartRow#&DisplayRows=#form.displayrows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#url.action#">


<cfelseif #action# is "Allow Sender">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getrid" datasource="#datasource#">
SELECT rid from msgrcpt where mail_id='#mailid#'
</cfquery>

<cfquery name="gettoaddr" datasource="#datasource#">
SELECT email as toAddress FROM maddr where id='#getrid.rid#'
</cfquery>

<cfquery name="getrecipientid" datasource="#datasource#">
select id, recipient from recipients where recipient='#gettoaddr.toAddress#'
</cfquery>

<cfif #getrecipientid.recordcount# GTE 1>

<cfset recipient = #getrecipientid.id#>
<cfelse>
<cflocation url="loading4.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#url.action#&s=#success#&f=#failure#&a=virtual">

</cfif>

<cfquery name="getsenderid" datasource="#datasource#">
SELECT sid from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfquery name="getsenderemail" datasource="#datasource#">
SELECT email from maddr where id='#getsenderid.sid#'
</cfquery>

<cfset sender="#getsenderemail.email#">

<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#gettoaddr.toAddress#' and sender='#sender#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>


<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='#sender#'
</cfquery>



<cfif #checksenderemail.recordcount# LT 1>

<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('#sender#')
</cfquery>

<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'ALLOW', 'insert', '#gettoaddr.toAddress#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'W')
</cfquery>



<cfset success=#success#+1>

<cfelseif #checksenderemail.recordcount# GTE 1>


<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'ALLOW', 'insert', '#gettoaddr.toAddress#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'W')
</cfquery>



<cfset success=#success#+1>

</cfif>



<cfelseif #checkexists.recordcount# GTE 1>

<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>



<cfelseif #action# is "Release Msg">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getmsg" datasource="#datasource#">
select * from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfquery name="getrid" datasource="#datasource#">
select rid from msgrcpt where mail_id='#mailid#'
</cfquery>

<cfquery name="getrec" datasource="#datasource#">
select email from maddr where id='#getrid.rid#'
</cfquery>

<cfif #getmsg.recordcount# GTE 1>
<cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">
<cfif fileExists(quarfile)> 

<cfexecute name = "/usr/sbin/amavisd-release"
timeout = "240"
outputfile ="/dev/null"
arguments="#getmsg.quar_loc# #secretid# #getrec.email#">
</cfexecute>

<cfset success=#success#+1>

<cfelseif NOT fileExists(quarfile)> 
<cfset failure=#failure#+1>
</cfif>

<cfelseif #getmsg.recordcount# LT 1>
<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>


<cfelseif #action# is "Delete Msg">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getmsg" datasource="#datasource#">
select * from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfif #getmsg.recordcount# GTE 1>
<cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">
<cfif fileExists(quarfile)> 


<cffile 
action = "delete"
file = "#quarfile#">

<cfset success=#success#+1>

<cfelseif NOT fileExists(quarfile)> 
<cfset failure=#failure#+1>
</cfif>

<cfelseif #getmsg.recordcount# LT 1>
<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>


<cfelseif #action# is "Train as Spam">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getmsg" datasource="#datasource#">
select * from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfif #getmsg.recordcount# GTE 1>
<cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">
<cfif fileExists(quarfile)> 

<cffile action = "copy" source = "#quarfile#" 
    destination = "/opt/hermes/sa-learn/LEARNSPAM/#mailid#">

<cfexecute name = "/usr/bin/sa-learn"
timeout = "240"
outputfile ="/opt/hermes/sa-learn/LEARNSPAM/result_#mailid#"
arguments="--no-sync --spam /opt/hermes/sa-learn/LEARNSPAM/">
</cfexecute>

<cffile action="read" file="/opt/hermes/sa-learn/LEARNSPAM/result_#mailid#" variable="check">

<cfif FindNoCase("Learned tokens from 1 message", check)>

<cfset success=#success#+1>


    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNSPAM/#mailid#">
    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNSPAM/result_#mailid#">



<cfelse>

<cfset failure=#failure#+1>
    


<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNSPAM/#mailid#">
    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNSPAM/result_#mailid#">


</cfif>


<cfelseif NOT fileExists(quarfile)> 
<cfset failure=#failure#+1>
</cfif>

<cfelseif #getmsg.recordcount# LT 1>
<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>

<cftry>
<cfexecute name = "/opt/hermes/scripts/bayes_chown_amavis.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cfcatch type="any">
</cfcatch>
</cftry>

<cfelseif #action# is "Train as NOT Spam">
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset secretid = listGetAt(form[thefield], 2, "_")>
<cfset mailid = listGetAt(form[thefield], 1, "_")>

<cfquery name="getmsg" datasource="#datasource#">
select * from msgs where mail_id='#mailid#' and secret_id='#secretid#'
</cfquery>

<cfif #getmsg.recordcount# GTE 1>
<cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">
<cfif fileExists(quarfile)> 

<cffile action = "copy" source = "#quarfile#" 
    destination = "/opt/hermes/sa-learn/LEARNHAM/#mailid#">

<cfexecute name = "/usr/bin/sa-learn"
timeout = "240"
outputfile ="/opt/hermes/sa-learn/LEARNHAM/result_#mailid#"
arguments="--no-sync --ham /opt/hermes/sa-learn/LEARNHAM/">
</cfexecute>

<cffile action="read" file="/opt/hermes/sa-learn/LEARNHAM/result_#mailid#" variable="check">

<cfif FindNoCase("Learned tokens from 1 message", check)>

<cfset success=#success#+1>


    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNHAM/#mailid#">
    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNHAM/result_#mailid#">


<cfelse>

<cfset failure=#failure#+1>
    


<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNHAM/#mailid#">
    
<cffile
    action = "delete"
    file = "/opt/hermes/sa-learn/LEARNHAM/result_#mailid#">


</cfif>


<cfelseif NOT fileExists(quarfile)> 
<cfset failure=#failure#+1>
</cfif>

<cfelseif #getmsg.recordcount# LT 1>
<cfset failure=#failure#+1>

</cfif>

</cfoutput>
</cfif>
</cfloop>

<cftry>
<cfexecute name = "/opt/hermes/scripts/bayes_chown_amavis.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cfcatch type="any">
</cfcatch>
</cftry>


</cfif>



<cfoutput>
<cflocation url="loading4.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#url.action#&s=#success#&f=#failure#&a=#action#">
</cfoutput></td>
    </tr>
  </table>
</body>
</html>
   