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
<title>api</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="713">
    <tr valign="top" align="left">
      <td width="62" height="30"></td>
      <td width="651"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="651" id="Text497" class="TextObject">
        <p style="margin-bottom: 0px;"><cfparam name = "authorized" default = "2"> 
<cfparam name = "clearedforaction" default = "2"> 

<cfif IsDefined("url.api_key")>
<cfif REFind("[^A-Za-z0-9]",url.api_key) gt 0>

<cfoutput>
INVALID API KEY (FORMATTING)#chr(64)#
</cfoutput>

<cfelse>
<cfquery name="checkkeywords" datasource="hermes">
SELECT * FROM keywords where keyword IN ('#url.api_key#') and banned='1'
</cfquery>
<cfif #checkkeywords.recordcount# GTE 1>

<cfoutput>
INVALID API KEY (KEYWORDS)#chr(64)#
</cfoutput>


<cfelseif #checkkeywords.recordcount# LT 1> 

<cfquery name="checkapikey" datasource="hermes">
SELECT * FROM api_initiators where api_key like binary '#url.api_key#' 
</cfquery>

<cfif #checkapikey.recordcount# GTE 1>
<cfset authorized=1>
<cfelseif #checkapikey.recordcount# LT 1>

<cfoutput>
INVALID API KEY (UNAUTHORIZED)#chr(64)#
</cfoutput>


<!-- /CFIF checkapikey.recordcount -->
</cfif>


<!-- /CFIF checkkeywords.recordcount -->
</cfif>

<!-- /CFIF REFind("[^A-Za-z0-9]",url.api_key) gt 0 -->
</cfif>

<cfelseif not IsDefined("url.api_key")>

<cfoutput>
INVALID API KEY (EMTPY)#chr(64)#
</cfoutput>


<!-- /CFIF IsDefined("url.api_key") -->
</cfif>

<cfif #authorized# is "1">

<cfif IsDefined("url.action")>
<cfif REFind("[^A-Za-z]",url.action) gt 0>

<cfoutput>
INVALID API KEY (FORMATTING)#chr(64)#
</cfoutput>

<cfelse>
<cfquery name="checkkeywords" datasource="hermes">
SELECT * FROM keywords where keyword IN ('#url.action#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# GTE 1>

<cfoutput>
INVALID API KEY (KEYWORDS)#chr(64)#
</cfoutput>

<cfelseif #checkkeywords.recordcount# LT 1>

<cfquery name="checkaction" datasource="hermes">
SELECT action FROM api_actions where action = '#url.action#'
</cfquery>

<cfif #checkaction.action# GTE 1>
<cfset clearedforaction=1>

<cfelseif #checkaction.action# LT 1>

<cfoutput>
INVALID ACTION (UNDEFINED)#chr(64)#
</cfoutput>

<!-- /CFIF checkaction.recordcount -->
</cfif>


<!-- /CFIF checkkeywords.recordcount -->
</cfif>

<!-- /CFIF REFind("[^A-Za-z]",url.action) gt 0 -->
</cfif>

<cfelseif not IsDefined("url.action")>

<cfoutput>
INVALID ACTION (EMPTY)#chr(64)#
</cfoutput>

<!-- /CFIF IsDefined("url.action") -->
</cfif>

<!-- /CFIF authorized -->
</cfif>


<cfif #clearedforaction# is "1">

<cfif #url.action# is "addrecipient">

<!-- ADD MANUAL RECIPIENT STARTS HERE -->

<!-- CHECK IF EMPTY RECIPIENT -->
<cfif #url.recipient# is not "">

<!-- CHECK IF VALID EMAIL ADDRESS -->
<cfif IsValid("email", url.recipient)>
<cfset domainpart = #trim(ListGetAt(url.recipient, 2, "@"))#>

<!-- CHECK IF DOMAIN HERMES RELAY DELIVERS EMAIL FOR -->
<cfquery name="checkdomain" datasource="hermes">
select domain from domains where domain='#domainpart#'
</cfquery>

<cfif #checkdomain.recordcount# GTE 1>
<cfset step=1>

<cfelseif #checkdomain.recordcount# LT 1>
<cfset step=0>

<cfoutput>
INVALID DOMAIN#chr(64)#
</cfoutput>

<!-- /CFIF checkdomain.recordcount -->
</cfif>

<cfelseif not IsValid("email", url.recipient)>
<cfset step=0>

<cfoutput>
INVALID RECIPIENT (EMAIL ADDRESS)#chr(64)#
</cfoutput>


<!-- /CFIF IsValid("email", url.recipient) -->
</cfif>

<cfelseif #url.recipient# is "">
<cfset step=0>

<cfoutput>
EMPTY RECIPIENT (EMAIL ADDRESS)#chr(64)#
</cfoutput>


<!-- /CFIF url.recipient is/is not "" -->
</cfif>



<cfif #step# is "1">

<!-- CHECK IF RECIPIENT EXISTS IN RECIPIENTS TABLE -->
<cfquery name="checkrecipient" datasource="hermes">
select recipient from recipients where recipient='#url.recipient#'
</cfquery>


<cfif #checkrecipient.recordcount# LT 1>

<!-- CHECK IF RECIPIENT EXISTS IN RECIPIENTS_TEMP TABLE -->
<cfquery name="checktemp" datasource="hermes">
select recipient from recipients_temp where recipient='#url.recipient#'
</cfquery>

<cfif #checktemp.recordcount# LT 1>

<!-- GET DEFAULT POLICY -->
<cfquery name="getdefaultpolicy" datasource="hermes">
select policy_id, default_policy from spam_policies where default_policy='1'
</cfquery>

<!-- CHECK IF DEFAULT POLICY EXISTS. PROBABLY UNNECESSARY CHECK BUT WHAT THE HELL -->
<cfif #getdefaultpolicy.recordcount# GTE 1>

<!-- INSERT RECIPIENT IN RECIPIENTS TABLE WITH DEFAULT POLICY ID FROM PREVIOUS CHECK -->
<cfquery name="insertnew" datasource="hermes">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
values
('#getdefaultpolicy.policy_id#', '#url.recipient#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>

<!-- IF DEFAULT POLICY DOESN'T EXIST, INSERT RECORD WITH THE DEFAULT POLICY ID 7 -->
<cfelse>

<!-- INSERT RECIPIENT IN RECIPIENTS TABLE WITH DEFAULT POLICY ID 7 -->
<cfquery name="insertnew" datasource="hermes">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
values
('7', '#url.recipient#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>

<!-- /CFIF getdefaultpolicy.recordcount -->
</cfif>

<!-- CREATE UNIQUE ID FOR RECIPIENT STARTS HERE -->
<cfquery name="userrandom" datasource="hermes" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 24
</cfquery>

<cfquery name="inserttrans" datasource="hermes" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="userrandom">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="hermes">
select salt as userrandom2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset userrandom3=#gettrans.userrandom2#>

<cfquery name="deletetrans" datasource="hermes">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<!-- CREATE UNIQUE ID FOR EACH RECIPIENT ENDS HERE -->

<!-- CREATE USER SETTINGS ENTRY FOR RECIPIENT STARTS HERE -->

<cfquery name="insertreport" datasource="hermes">
insert into user_settings
(id, email, report_enabled, report_frequency, password_set, train_bayes, download_msg)
values
('#userrandom3#', '#url.recipient#', 'ALL', '24', '0', '0', '0')
</cfquery>

<!-- CREATE USER SETTINGS ENTRY FOR RECIPIENT ENDS HERE -->

<!-- STOP POSTFIX AND AMAVIS STARTS HERE -->

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<!-- STOP POSTFIX AND AMAVIS ENDS HERE -->

<!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE STARTS HERE -->

<cfquery name="dropusers" datasource="hermes">
drop table users
</cfquery>

<cfquery name="createusers" datasource="hermes">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="hermes">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="hermes">
alter table users change recipient email VARBINARY(255)
</cfquery>

<!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE ENDS HERE -->

<!-- START POSTFIX AND AMAVIS STARTS HERE -->

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<!-- START POSTFIX AND AMAVIS ENDS HERE -->

<cfoutput>
SUCCESS#chr(64)#
</cfoutput>


<cfelseif #checktemp.recordcount# GTE 1>

<cfoutput>
RECIPIENT EXISTS IN TEMP#chr(64)#
</cfoutput>


<!-- /CFIF checktemp.recordcount -->
</cfif>


<cfelseif #checkrecipient.recordcount# GTE 1>

<cfoutput>
RECIPIENTS EXISTS#chr(64)#
</cfoutput>


<!-- /CFIF checkrecipient.recordcount -->
</cfif>

<!-- /CFIF step 1 -->
</cfif>


<!-- ADD MANUAL RECIPIENT ENDS HERE -->

<!-- /CFIF url.action>
</cfif>

<!-- /CFIF clearedforaction -->
</cfif>
&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   