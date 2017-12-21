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
<title>Add SMIME Certificate</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="706" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 706px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="506"></td>
                          <td width="447"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Add Recipient S/MIME Certificate</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="561"></td>
                          <td colspan="2" width="953"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">
<cfparam name="url.id" type="numeric" default=0>

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

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif>

<cfparam name = "autopass" default = "yes"> 
<cfif IsDefined("url.autopass") is "True">
<cfif url.autopass is not "">
<cfset autopass = url.action>
</cfif></cfif>





<cfif NOT IsDefined('url.type')>
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=1>
<cfelseif IsDefined('url.type')>
<cfif #url.type# is not "2">
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=1>
<cfelseif #url.type# is "2">
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, email as recipient from external_recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=2>

</cfif>
</cfif>


<cfif #getrecipientdetails.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>
 

<cfparam name = "show_validity" default = "1825"> 
<cfif IsDefined("form.validity") is "True">
<cfif form.validity is not "">
<cfset show_validity = form.validity>
</cfif></cfif>

<cfparam name = "show_encryption" default = "4096"> 
<cfif IsDefined("form.encryption") is "True">
<cfif form.encryption is not "">
<cfset show_encryption = form.encryption>
</cfif></cfif> 

<cfparam name = "show_algorithm" default = "sha512"> 
<cfif IsDefined("form.algorithm") is "True">
<cfif form.algorithm is not "">
<cfset show_algorithm = form.algorithm>
</cfif></cfif> 

<cfparam name = "show_smime_password1" default = ""> 
<cfif IsDefined("form.password1") is "True">
<cfif form.password1 is not "">
<cfset show_smime_password1 = form.password1>
</cfif></cfif> 

<cfparam name = "show_smime_password2" default = ""> 
<cfif IsDefined("form.password2") is "True">
<cfif form.password2 is not "">
<cfset show_smime_password2 = form.password2>
</cfif></cfif> 

<cfif #autopass# is "yes">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 16
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

<cfset show_smime_password1=#gettrans.customtrans2#>
<cfset show_smime_password2=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>
</cfif>


<cfquery name="getdefaultca" datasource="#datasource#">
select * from ca_settings where default2='1'
</cfquery>

<cfparam name = "show_ca" default = "#getdefaultca.id#"> 
<cfif IsDefined("form.ca") is "True">
<cfif form.ca is not "">
<cfset show_ca = form.ca>
</cfif></cfif>

<cfquery name="getcadetails" datasource="#datasource#">
select * from ca_settings where id='#show_ca#'
</cfquery>


<cfif #action# is "Create Certificate">

<cfset rcpt_name = rereplace(getrecipientdetails.recipient, "[^A-Za-z0-9]+", "", "all")>

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





<cfif #show_smime_password1# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_smime_password1# is not "">
<cfset step=1>
</cfif>


<cfif step is "1">
<cfif NOT ( len(show_smime_password1) GTE 10)>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfif REFind("[a-z]",show_smime_password1) gte 1 and REFind("[A-Z]",show_smime_password1) gte 1 and REFind("[0-9]",show_smime_password1) GTE 1>

<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
</cfif>
</cfif>

<cfif step is "2">
<cfif REFind("[^a-zA-Z0-9]",show_smime_password1) gt 0>
<cfset step=0>
<cfset m=3>
<cfelse>
<cfset step=3>
</cfif>
</cfif>


<cfif step is "3" and #show_smime_password2# is "">
<cfset step=0>
<cfset m=4>
<cfelseif step is "3" and #show_smime_password2# is not "">
<cfset step=4>
</cfif>

<cfif step is "4" and #show_smime_password1# is not "" and #show_smime_password2# is not "">
<cfset compare_password = Compare(#show_smime_password1#, #show_smime_password2#)>
<cfif #compare_password# is "1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=5>
</cfif>
</cfif>

</cfif>

<cfif step is "5">

<cfquery name="getdjigzocertificates" datasource="djigzo">
select * from cm_certificates_email where cm_email='#getrecipientdetails.recipient#'
</cfquery>

<cfif #getdjigzocertificates.recordcount# GTE 1>
<cfloop query="getdjigzocertificates">
<cfoutput>
<cfquery name="insertcerts" datasource="#datasource#">
insert into temp_table 
(session_id, djigzo_certificate_id, recipient_id)
values
('#customtrans3#', '#cm_certificates_id#', '#url.id#')
</cfquery>
</cfoutput>
</cfloop>
</cfif>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset certexpires = DateAdd('d', #show_validity#, #datenow#)>
<cfset certexpires =#DateFormat(certexpires,"yyyy-mm-dd")#>

<cffile action="read" file="/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/serial" variable="currentserial2">
<cfset currentserial = rereplace(currentserial2, "[[:space:]]", "", "all")>

<cfset rcpt_name = rereplace(getrecipientdetails.recipient, "[^A-Za-z0-9]+", "", "all")>


<cffile action="read" file="/opt/hermes/scripts/create_smime_certficate.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","CA-DIRECTORY","#getcadetails.ca_directory#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-ENCRYPTION","#show_encryption#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-ALGORITHM","#show_algorithm#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-VALIDITY","#show_validity#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#show_smime_password1#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","RCPT-NAME","#rcpt_name#_#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_create_smime_certficate.sh">
    
<cfset filelocation  = "/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/newcerts/#currentserial#.pem">
    
<cfif fileExists(filelocation)>
<cffile 
action = "delete"
file = "#filelocation#">
<cfelse>
</cfif>


<cfquery name="getdjigzocertificates2" datasource="djigzo">
select * from cm_certificates_email where cm_email='#getrecipientdetails.recipient#'
</cfquery>

<cfloop query="getdjigzocertificates2">

<cfquery name="exists" datasource="#datasource#">
select djigzo_certificate_id, recipient_id, session_id from temp_table where session_id='#customtrans3#' 
and recipient_id='#url.id#' and djigzo_certificate_id='#cm_certificates_id#'
</cfquery>

<cfif #exists.recordcount# LT 1>
<cfquery name="getcertprint" datasource="djigzo">
select cm_id, cm_thumbprint from cm_certificates where cm_id='#cm_certificates_id#'
</cfquery>
<cfset thumbprint="#getcertprint.cm_thumbprint#">
<cfset djigzo_certificate_id="#getcertprint.cm_id#">
</cfif>
</cfloop>

<cfquery name="getmax" datasource="djigzo">
SELECT max(cm_id) as maxid FROM cm_ctl
</cfquery>

<cfif #getmax.maxid# is "">
<cfset maxid2=0>
<cfset nextid=#maxid2#+1>
<cfelseif #getmax.maxid# is not "">
<cfset nextid=#getmax.maxid#+1>
</cfif>

<cfquery name="insertctl" datasource="djigzo">
insert into cm_ctl (cm_id, cm_name, cm_thumbprint) values ('#nextid#', 'global', '#thumbprint#')
</cfquery>

<cfquery name="insertctlnamewhitelisted" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'whitelisted', 'status')
</cfquery>

<cfquery name="insertctlnameexpired" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'false', 'allowExpired')
</cfquery>


<cfif #type# is "1">

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
<cfset encryptedPassword=encrypt(show_smime_password1, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_smime_password1, #theKey#, "AES", "Base64")>
</cfif>

<cfquery name="insert" datasource="#datasource#">
insert into recipient_certificates
(user_id, ca_id, validity, encryption, algorithm, smime_certificate_key, smime_certificate_request, smime_certificate_name, pfx_certificate_name, smime_certificate_password, smime_certificate_expiration, serial, thumbprint, djigzo_certificate_id)
values
('#url.id#', '#show_ca#', '#show_validity#', '#show_encryption#', '#show_algorithm#', '#rcpt_name#_#customtrans3#_key.pem', '#rcpt_name#_#customtrans3#.csr', '#rcpt_name#_#customtrans3#_cert.pem', '#rcpt_name#_#customtrans3#.pfx', '#encryptedPassword#', '#certexpires#', '#currentserial#', '#thumbprint#', '#djigzo_certificate_id#')
</cfquery>

<cfelseif #type# is "2">

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
<cfset encryptedPassword=encrypt(show_smime_password1, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_smime_password1, #theKey#, "AES", "Base64")>
</cfif>

<cfquery name="insert" datasource="#datasource#">
insert into recipient_certificates
(user_id, ca_id, validity, encryption, algorithm, smime_certificate_key, smime_certificate_request, smime_certificate_name, pfx_certificate_name, smime_certificate_password, smime_certificate_expiration, serial, thumbprint, djigzo_certificate_id, external)
values
('#url.id#', '#show_ca#', '#show_validity#', '#show_encryption#', '#show_algorithm#', '#rcpt_name#_#customtrans3#_key.pem', '#rcpt_name#_#customtrans3#.csr', '#rcpt_name#_#customtrans3#_cert.pem', '#rcpt_name#_#customtrans3#.pfx', '#encryptedPassword#', '#certexpires#', '#currentserial#', '#thumbprint#', '#djigzo_certificate_id#', '1')
</cfquery>

</cfif>

<cfquery name="deletetemp" datasource="#datasource#">
delete from temp_table where session_id='#customtrans3#'
</cfquery>

<cfif #type# is "1">
<cflocation url="internal_encryption_users.cfm?id=#url.id#&action=addedcertificate&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
<cfelseif #type# is "2">
<cflocation url="external_encryption_users.cfm?id=#url.id#&action=addedcertificate&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfif>

</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion17" style="height: 561px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>add_smime_certificate.cfm?id=#url.id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="595">
                                          <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 14px;">
                                              <td width="595" id="Cell1029">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Internal Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell1030">
                                                <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="#getrecipientdetails.recipient#">
</cfoutput>

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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="590">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 330px;">
                                            <tr style="height: 14px;">
                                              <td width="586" id="Cell908">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certificate Authority</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell909">
                                                <table width="503" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfquery name="getotherca" datasource="#datasource#">
select * from ca_settings where id <> '#show_ca#' order by ca_commonname asc
</cfquery>


<select name="ca" style="height: 24px;">
<cfoutput>
<option value="#show_ca#" selected="selected">#getcadetails.ca_commonname#</option>
</cfoutput>
<cfoutput query="getotherca">
<option value="#id#">#ca_commonname#</option>
</cfoutput>
</select>

&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell884">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Certificate Validity Period</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 95px;">
                                              <td id="Cell885">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table73" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 95px;">
                                                        <tr style="height: 19px;">
                                                          <td width="46" id="Cell423">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1825">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1825">
<cfoutput>
<input type="radio" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="485" id="Cell424">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">5 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell425">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1460">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1460" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1460">
<cfoutput>
<input type="radio" name="validity" value="1460" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell426">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell427">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1095">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1095" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1095">
<cfoutput>
<input type="radio" name="validity" value="1095" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell428">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">3 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell429">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "730">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "730">
<cfoutput>
<input type="radio" name="validity" value="730" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell430">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell431">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "365">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "365">
<cfoutput>
<input type="radio" name="validity" value="365" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>

&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell432">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">1 Year</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell886">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Certificate Encryption Length</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell887">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="51" id="Cell411">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_encryption# is "2048">
<cfoutput>
<input type="radio" checked="checked" name="encryption" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption# is not "2048">
<cfoutput>
<input type="radio" name="encryption" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="480" id="Cell412">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2048-bits <span style="color: rgb(51,51,51); font-weight: normal;">(medium security)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell413">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_encryption# is "4096">
<cfoutput>
<input type="radio" checked="checked" name="encryption" value="4096" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption# is not "4096">
<cfoutput>
<input type="radio" name="encryption" value="4096" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell414">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4096-bits<span style="font-weight: normal;"> <span style="color: rgb(51,51,51);">(high security)</span></span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell888">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Certificate Algorithm</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 57px;">
                                              <td id="Cell889">
                                                <table width="530" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table72" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 57px;">
                                                        <tr style="height: 19px;">
                                                          <td width="51" id="Cell415">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_algorithm# is "sha1">
<cfoutput>
<input type="radio" checked="checked" name="algorithm" value="sha1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_algorithm# is not "sha1">
<cfoutput>
<input type="radio" name="algorithm" value="sha1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="479" id="Cell416">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">RSA-SHA-1 <span style="color: rgb(51,51,51); font-weight: normal;">(least secure, most compatible)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell417">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_algorithm# is "sha256">
<cfoutput>
<input type="radio" checked="checked" name="algorithm" value="sha256" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_algorithm# is not "sha256">
<cfoutput>
<input type="radio" name="algorithm" value="sha256" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell418">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><span style="color: rgb(128,128,128);"><b>RSA-SHA-256</b><span style="font-weight: normal;"> </span></span><span style="color: rgb(51,51,51); font-weight: normal;">(mostly secure, mostly compatible)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell419">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_algorithm# is "sha512">
<cfoutput>
<input type="radio" checked="checked" name="algorithm" value="sha512" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_algorithm# is not "sha512">
<cfoutput>
<input type="radio" name="algorithm" value="sha512" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell420">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">RSA-SHA-512<span style="font-weight: normal;"> <span style="color: rgb(51,51,51);">(most secure, least compatible)</span></span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Auto-Generate S/MIME Certificate and Private Key PFX password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1022">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="51" id="Cell1023">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #autopass# is "yes">
<cfoutput>
<input type="radio" checked="checked" name="autopass" value="yes" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #autopass# is not "yes">
<cfoutput>
<input type="radio" name="autopass" value="yes" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="480" id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell1025">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #autopass# is "no">
<cfoutput>
<input type="radio" checked="checked" name="autopass" value="no" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #autopass# is not "no">
<cfoutput>
<input type="radio" name="autopass" value="no" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1026">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Certificate and Private Key PFX password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell891">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #autopass# is "yes">
<cfoutput>
<input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_smime_password1#" disabled="disabled">
</cfoutput>

<cfelseif #autopass# is "no">
<cfoutput>
<input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_smime_password1#">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell892">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Verify S/MIME Certificate and Private Key PFX password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell893">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #autopass# is "yes">
<cfoutput>
<input type="password" id="FormsEditField20" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_smime_password2#" disabled="disabled">
</cfoutput>
<cfelseif #autopass# is "no">
<cfoutput>
<input type="password" id="FormsEditField20" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_smime_password2#">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1028">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1027">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="133" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" name="action" value="Create Certificate" style="height: 24px; width: 133px;">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="953">
                                      <tr valign="top" align="left">
                                        <td width="953" height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password must be at least 10 characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password must contain both upper and lowercase characters, numbers and it must <b>NOT</b> contain special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must verify the PFX Certificate password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate password you entered  do not match</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "100">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved</span></i></b></p><br>

<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must click the Apply Settings button for your changes to take effect. Please allow approximately 30 seconds for the changes to propagate accross our systems</span></i></b></p>
</cfoutput>

</cfif>


<cfif #m# is "101">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! The changes are in the process of being applied accross our systems. Please allow approximately 30 seconds for the changes to take effect</span></i></b></p><br>
</cfoutput>
</cfif>

<cfif #m# is "102">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved and sender S/MIME certificate created</span></i></b></p><br>

<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must click the Apply Settings button for your changes to take effect. Please allow approximately 30 seconds for the changes to propagate accross our systems</span></i></b></p>
</cfoutput>

</cfif>


&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="953"><hr id="HRRule5" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td colspan="3" width="954">

                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="10"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <table id="Table190" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="954" id="Cell1019">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="635" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><cfif #type# is "1">
<form name="apply_settings" action="<cfoutput>internal_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;"><cfif #type# is "1">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
<cfelseif #type# is "2">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
</cfif>
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
  


</form>

<cfelseif #type# is "2">

<form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;"><cfif #type# is "1">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
<cfelseif #type# is "2">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
</cfif>
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
  


</form>
</cfif>&nbsp;</p>
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
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
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