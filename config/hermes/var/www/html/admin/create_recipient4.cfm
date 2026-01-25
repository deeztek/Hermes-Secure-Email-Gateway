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
<title>Create Recipient4</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="827">
    <tr valign="top" align="left">
      <td width="40" height="62"></td>
      <td width="787"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="787" id="Text499" class="TextObject"><cfif NOT IsDefined('session.ext_recipient')>
<cflocation url="create_recipient.cfm">
<cfelseif IsDefined('session.ext_recipient')>
<cfif #session.ext_recipient# is "">
<cflocation url="create_recipient.cfm">
</cfif>
</cfif>

<cfif NOT IsDefined('session.pdf_mode')>
<cflocation url="create_recipient.cfm">
<cfelseif IsDefined('session.pdf_mode')>
<cfif #session.pdf_mode# is "">
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


<!--- IF ENCYPTION IS PDF MANDATORY--->

<cfif #session.encryption_mode# is "pdf_mandatory">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_pdf_mandatory.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_mandatory.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_mandatory.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_mandatory.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_mandatory.sh">

<cfelseif #session.encryption_mode# is "pdf_by_subject">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_pdf_by_subject.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_by_subject.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_by_subject.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_by_subject.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_by_subject.sh">


</cfif>


<cfif #session.pdf_mode# is "static">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_pdf_static.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#session.pdf_password#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_static.sh">


<cfelseif #session.pdf_mode# is "random">

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_pdf_random.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_random.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_random.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_random.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_random.sh">


<cfelseif #session.pdf_mode# is "backtosender">

<cfset passwordage=#session.pdf_password_age#*60000>

<cffile action="read" file="/opt/hermes/scripts/enable_extrecipient_pdf_backtosender.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#session.ext_recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh"
    output = "#REReplace("#temp#","PASSWORD-AGE","#passwordage#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh"
    output = "#REReplace("#temp#","PASSWORD-LENGTH","#session.pdf_password_length#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_extrecipient_pdf_backtosender.sh">


</cfif>


<cfif #session.mode# is "insert">
<cfif #session.pdf_mode# is "static">

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(session.pdf_password, #theKey#, "AES", "Base64")>

<cfquery name="insertrecipient" datasource="#datasource#">
insert into external_recipients
(email,
encryption_mode,
smime,
pdf, 
pdf_mode,
pdf_password)
values
('#session.ext_recipient#',
'#session.encryption_mode#',
'2',
'1',
'#session.pdf_mode#',
'#encryptedPassword#')
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='manual'
where
cm_email = '#session.ext_recipient#'
</cfquery>

<cfelse>
<cfquery name="insertrecipient" datasource="#datasource#">
insert into external_recipients
(email,
encryption_mode,
smime,
pdf, 
pdf_mode)
values
('#session.ext_recipient#',
'#session.encryption_mode#',
'2',
'1',
'#session.pdf_mode#')
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='manual'
where
cm_email = '#session.ext_recipient#'
</cfquery>

</cfif>

<cfelseif #session.mode# is "edit">

<cfif #session.pdf_mode# is "static">

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<cfif #theKey# is "">

<!-- GENERATE SECRET KEY -->
<cfset theKey=generateSecretKey("AES", 256)>
<cffile action = "write"
file = "/opt/hermes/keys/hermes.key"
output = "#theKey#">

<!-- READ SECRET KEY -->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(session.pdf_password, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(session.pdf_password, #theKey#, "AES", "Base64")>
</cfif>


<cfquery name="editrecipient" datasource="#datasource#">
update external_recipients
set
encryption_mode='#session.encryption_mode#',
smime='2',
pdf='1',
pdf_mode='#session.pdf_mode#',
pdf_password='#encryptedPassword#'
where email='#session.ext_recipient#'
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='manual'
where
cm_email = '#session.ext_recipient#'
</cfquery>


<cfelse>
<cfquery name="editrecipient" datasource="#datasource#">
update external_recipients
set
encryption_mode='#session.encryption_mode#',
smime='2',
pdf='1',
pdf_mode='#session.pdf_mode#'
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

</cfif>



<cfset session.pdf_mode="">
<cfset session.encryption_mode="">
<cfset session.pdf_password="">
<cfset session.ext_recipient="">
<cfset session.mode="">

<cfoutput>
<cflocation url="external_encryption_users.cfm?m2=1&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
        <p style="margin-bottom: 0px;">&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   