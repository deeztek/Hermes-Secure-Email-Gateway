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
<title>Mail Queue Management Edit</title>
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

  <table border="0" cellspacing="0" cellpadding="0" width="846">
    <tr valign="top" align="left">
      <td width="22" height="30"></td>
      <td width="824"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="824" id="Text381" class="TextObject">
        <p style="margin-bottom: 0px;"><cfif NOT structKeyExists(form, "action")>
<cflocation url="error.cfm" addtoken="no">
<cfelseif structKeyExists(form, "action")>

<cfoutput>
thefields: #form.fieldnames#<br>
ACTION: #form.action#<br>
</cfoutput>
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
CHECKBOX:#thefield#<br>
<cfset mailid = listGetAt(form[thefield], 2, "_")>
MailID: #mailid#<br>


</cfoutput>
</cfif>
</cfloop>

<cfif #form.fieldnames# contains 'cbox'>
it contains cbox
<cfelseif #form.fieldnames# does not contain 'cbox'>
it does NOT contain cbox
</cfif>


<cfif #action# is "Requeue Msg">

<cfif #form.fieldnames# contains 'cbox'>

<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfset mailid = listGetAt(form[thefield], 2, "_")>

<cfoutput>
<cfexecute name = "/usr/sbin/postsuper"
timeout = "240"
variable="requeueResults"
arguments="-r #mailid#">
</cfexecute>
</cfoutput>



<!-- /CFIF FOR thefield contains 'cbox' -->
</cfif>
</cfloop>

<cflocation url="loading_queue.cfm?m1=1" addtoken="no">

<cfelseif #form.fieldnames# does not contain 'cbox'>
<cflocation url="loading_queue.cfm?m1=3" addtoken="no">

<!-- /CFIF FOR form.fieldnames contains 'cbox' -->
</cfif>




<cfelseif #action# is "Hold Msg">

<cfif #form.fieldnames# contains 'cbox'>

<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfset mailid = listGetAt(form[thefield], 2, "_")>

<cfoutput>
<cfexecute name = "/usr/sbin/postsuper"
timeout = "240"
variable="requeueResults"
arguments="-h #mailid#">
</cfexecute>
</cfoutput>



<!-- /CFIF FOR thefield contains 'cbox' -->
</cfif>
</cfloop>

<cflocation url="loading_queue.cfm?m1=2" addtoken="no">

<cfelseif #form.fieldnames# does not contain 'cbox'>
<cflocation url="loading_queue.cfm?m1=3" addtoken="no">

<!-- /CFIF FOR form.fieldnames contains 'cbox' -->
</cfif>


<cfelseif #action# is "Delete Msg">

<cfif #form.fieldnames# contains 'cbox'>

<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfset mailid = listGetAt(form[thefield], 2, "_")>

<cfoutput>
<cfexecute name = "/usr/sbin/postsuper"
timeout = "240"
variable="requeueResults"
arguments="-d #mailid#">
</cfexecute>
</cfoutput>



<!-- /CFIF FOR thefield contains 'cbox' -->
</cfif>
</cfloop>

<cflocation url="loading_queue.cfm?m1=4" addtoken="no">

<cfelseif #form.fieldnames# does not contain 'cbox'>
<cflocation url="loading_queue.cfm?m1=3" addtoken="no">

<!-- /CFIF FOR form.fieldnames contains 'cbox' -->
</cfif>


<cfelseif #action# is "Set Queue">

<cfquery name="get_bounce_queue_lifetime" datasource="#datasource#">
select id from parameters where parameter='bounce_queue_lifetime' and child = '2'
</cfquery>

<cfquery name="get_bounce_queue_lifetime_children" datasource="#datasource#">
select * from parameters where parent='#get_bounce_queue_lifetime.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="update_bounce_queue_lifetime_children" datasource="#datasource#">
update parameters set 
parameter='#form.bouncequeue#',
applied='2'
where
parent='#get_bounce_queue_lifetime.id#' and child = '1'
</cfquery>

<cfquery name="get_maximal_queue_lifetime" datasource="#datasource#">
select id from parameters where parameter='maximal_queue_lifetime' and child = '2'
</cfquery>

<cfquery name="get_maximal_queue_lifetime_children" datasource="#datasource#">
select * from parameters where parent='#get_maximal_queue_lifetime.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="update_maximal_queue_lifetime_children" datasource="#datasource#">
update parameters set 
parameter='#form.maxqueue#',
applied='2'
where
parent='#get_maximal_queue_lifetime.id#' and child = '1'
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

<cfquery name="getmainparams" datasource="#datasource#">
select distinct(parameter), id, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
</cfquery>

<cfloop query="getmainparams">
<cfoutput>
<cfquery name="getchildren" datasource="#datasource#">
select * from parameters where child='1' and parent = '#getmainparams.id#' and enabled = '1' order by order1 asc
</cfquery>

<cfquery name="insert" datasource="#datasource#">
insert into command 
(command, trans_id)
values
('/usr/sbin/postconf -e "#getmainparams.parameter# = #ValueList(getchildren.parameter,", ")#"#chr(10)#', '#customtrans3#')
</cfquery>

</cfoutput>
</cfloop> 

<cfquery name="getcommand" datasource="#datasource#">
select * from command where trans_id = '#customtrans3#'
</cfquery>

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cfoutput query="getcommand">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "#command#"
addnewline="no">

</cfoutput>

<cfquery name="deletecommand" datasource="#datasource#">
delete from command where trans_id = '#customtrans3#'
</cfquery>

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/usr/sbin/postfix reload#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">    

<cfquery name="updateparams" datasource="#datasource#">
update parameters set applied='1' where applied = '2'
</cfquery>

<cflocation url="loading_queue.cfm?m1=5" addtoken="no">


<!-- /CFIF FOR ACTION -->
</cfif>

<!-- /CFIF structKeyExists(form, "action")> -->
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   