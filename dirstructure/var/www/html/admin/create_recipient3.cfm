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
<title>Create Recipient3</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="828">
    <tr valign="top" align="left">
      <td width="38" height="58"></td>
      <td width="790"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="790" id="Text500" class="TextObject"><cfif NOT IsDefined('session.ext_recipient')>
<cflocation url="create_recipient.cfm">
<cfelseif IsDefined('session.ext_recipient')>
<cfif #session.ext_recipient# is "">
<cflocation url="create_recipient.cfm">
</cfif>
</cfif>

<cfif NOT IsDefined('session.encryption_mode')>
<cflocation url="create_recipient.cfm">
<cfelseif IsDefined('session.encryption_mode')>
<cfif #session.encryption_mode# is "">
<cflocation url="create_recipient.cfm">
</cfif>
</cfif>

<CFPARAM NAME="StartRow" DEFAULT="1">
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<CFPARAM NAME="DisplayRows" DEFAULT="10">
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

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


<!--- CREATE RECIPIENT IN DJIGZO --->
<cffile action="read" file="/opt/hermes/scripts/create_extrecipient.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_extrecipient.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_create_extrecipient.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_create_extrecipient.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_create_extrecipient.sh">


<!--- IF ENCYPTION IS sMIME MANDATORY--->

<cfif #session.encryption_mode# is "smime_mandatory">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_smime_mandatory.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_mandatory.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_mandatory.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_mandatory.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_mandatory.sh">

<!--- IF ENCYPTION IS sMIME BY SUBJECT--->

<cfelseif #session.encryption_mode# is "smime_by_subject">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_smime_by_subject.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_by_subject.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_by_subject.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_by_subject.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_smime_by_subject.sh">


</cfif>



<cfif #session.mode# is "insert">
<cfquery name="insertrecipient" datasource="#datasource#">
insert into external_recipients
(email,
encryption_mode,
smime,
pdf)
values
('#session.ext_recipient#',
'#session.encryption_mode#',
'1',
'2')
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='manual'
where
cm_email = '#session.ext_recipient#'
</cfquery>

<cfelseif #session.mode# is "edit">
<cfquery name="insertrecipient" datasource="#datasource#">
update external_recipients
set 
encryption_mode='#session.encryption_mode#',
smime='1',
pdf='2'
where email='#session.ext_recipient#'
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='manual'
where
cm_email = '#session.ext_recipient#'
</cfquery>

</cfif>



<cfset session.encryption_mode="">
<cfset session.ext_recipient="">
<cfset session.mode="">

<cfoutput>
<cflocation url="external_encryption_users.cfm?m2=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
        <p style="margin-bottom: 0px;">&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   