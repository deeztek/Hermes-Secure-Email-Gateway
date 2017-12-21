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
<title>Import SMIME Certificate</title>
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
              <td height="495" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 495px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="11" height="18"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                          <td width="506"></td>
                          <td width="447"></td>
                          <td width="3"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Import Recipient S/MIME Certificate</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="7"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="248"></td>
                          <td colspan="4" width="958"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">


<cfparam name="url.id" type="numeric" default=0>
<CFPARAM NAME="File.ServerFile" DEFAULT="">
<CFPARAM NAME="cffile.serverFileExt" DEFAULT="">



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
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "ctl" default = "1"> 
<cfif IsDefined("form.ctl") is "True">
<cfif form.ctl is not "">
<cfset ctl = form.ctl>
</cfif></cfif>

<cfparam name = "expired" default = "2"> 
<cfif IsDefined("form.expired") is "True">
<cfif form.expired is not "">
<cfset expired = form.expired>
</cfif></cfif>


<cfparam name = "localfile" default = ""> 
<cfif IsDefined("form.pfx") is "True">
<cfif form.pfx is not "">
<cfset localfile = form.pfx>
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

<cfset theRecipient="#getrecipientdetails.recipient#">

<cfquery name="getcertcount" datasource="djigzo">
select count(cm_certificates_id) as certcount from cm_certificates_email where cm_email='#theRecipient#'
</cfquery>

<cfset certcount=#getcertcount.certcount#>



<cfif #getrecipientdetails.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>
 
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


<cfif #action# is "import">
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

<cfif #localfile# is "">
<cfset step=0>
<cfset m=7>
<cfelseif #localfile# is not "">
<cfif #show_smime_password1# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_smime_password1# is not "">
<cfset step=2>
</cfif>
</cfif>



<cfif step is "2">
<cftry>
  <cffile action="upload"
     fileField="pfx"
     destination="/opt/hermes/tmp"
     nameconflict="makeunique">
     
<cfset OriginalFileName = #cffile.serverFile# />
<cfset NewFileName = rereplace(OriginalFileName, "[^A-Za-z0-9._]+", "", "all")>
<cffile action="rename" 
source="/opt/hermes/tmp/#OriginalFileName#" 
destination="/opt/hermes/tmp/#NewFileName#">
   
<cfcatch>

<cfif FindNoCase("not accepted", cfcatch.Message)>
<cfset step=0>
<cfset m=6>
<cfdump var="#cfcatch#" abort />
<cfelseif FindNoCase("doesn't exist", cfcatch.Message)>
<cfset step=0>
<cfset m=7>
<cfdump var="#cfcatch#" abort />
<!--- looks like non-MIME error, handle separately  
<cfdump var="#cfcatch#" abort /> --->

</cfif>

</cfcatch>


</cftry>

<cfif #cffile.serverFileExt# is not "pfx">
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>
<cfset m=6>
<cfset step=0>
<cfelse>
<cfset step=3>
</cfif>


</cfif>


<cfif #step# is "3">

<cfquery name="getdjigzocertificates" datasource="djigzo">
select * from cm_certificates_email where cm_email='#theRecipient#'
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



<cffile action="read" file="/opt/hermes/scripts/import_pfx_file.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_import_pfx_file.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#show_smime_password1#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_import_pfx_file.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_import_pfx_file.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_import_pfx_file.sh"
timeout = "60">
</cfexecute>

<cftry>
<cfexecute name = "/opt/hermes/scripts/#customtrans3#_import_pfx_file.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cfcatch>

<cfif FindNoCase("wrong password or corrupted file", cfcatch.Detail)>
<cfset step=0>
<cfset m=4>
</cfif>
</cfcatch>
</cftry>

<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_import_pfx_file.sh">

<cfscript> 
thread = CreateObject("java", "java.lang.Thread"); 
thread.sleep(5000); 
</cfscript>

<cfquery name="getcertcount2" datasource="djigzo">
select count(cm_certificates_id) as certcount2 from cm_certificates_email where cm_email='#theRecipient#'
</cfquery>

<cfset nextcount=#getcertcount2.certcount2#>

<cfif #nextcount# GT #certcount#>

<cfexecute name = "/bin/mv"
arguments="/opt/hermes/tmp/#NewFileName# /opt/hermes/HermesExternalCACerts/#customtrans3#_#rcpt_name#.pfx"
timeout = "60">
</cfexecute>

<cfquery name="getdjigzocertificates2" datasource="djigzo">
select * from cm_certificates_email where cm_email='#theRecipient#'
</cfquery>

<cfloop query="getdjigzocertificates2">

<cfquery name="exists" datasource="#datasource#">
select djigzo_certificate_id, recipient_id, session_id from temp_table where session_id='#customtrans3#' 
and recipient_id='#url.id#' and djigzo_certificate_id='#cm_certificates_id#'
</cfquery>

<cfif #exists.recordcount# LT 1>
<cfquery name="getcertprint" datasource="djigzo">
select * from cm_certificates where cm_id='#cm_certificates_id#'
</cfquery>
<cfset thumbprint="#getcertprint.cm_thumbprint#">
<cfset djigzo_certificate_id="#getcertprint.cm_id#">
</cfif>
</cfloop>

<cfif #ctl# is "1">
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

</cfif>


<!---
<cfquery name="deletetemp" datasource="#datasource#">
delete from temp_table where session_id='#customtrans3#'
</cfquery>
--->

<cfset issuerfriendlyCN = rereplace(getcertprint.cm_issuer_friendly, "CN=", "", "all")>
<cfset issuerfriendlyOU = rereplace(issuerfriendlyCN, "OU=", "", "all")>
<cfset issuerfriendlyO = rereplace(issuerfriendlyOU, "O=", "", "all")>
<cfset external_ca_name = rereplace(issuerfriendlyO, "C=", "", "all")>
<cfset smime_certificate_expiration = #DateFormat(getcertprint.cm_not_after, "yyyy-mm-dd")#>

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

<cfif #type# is "1">
<cfquery name="insert" datasource="#datasource#">
insert into recipient_certificates
(user_id, external_ca, pfx_certificate_name, smime_certificate_password, external_ca_name, smime_certificate_expiration, thumbprint, djigzo_certificate_id)
values
('#url.id#', '1', '#customtrans3#_#rcpt_name#.pfx', '#encryptedPassword#', '#external_ca_name#', '#smime_certificate_expiration#', '#getcertprint.cm_thumbprint#', '#getcertprint.cm_id#')
</cfquery>

<cfelseif #type# is "2">
<cfquery name="insert" datasource="#datasource#">
insert into recipient_certificates
(user_id, external_ca, pfx_certificate_name, smime_certificate_password, external_ca_name, smime_certificate_expiration, thumbprint, djigzo_certificate_id, external)
values
('#url.id#', '1', '#customtrans3#_#rcpt_name#.pfx', '#encryptedPassword#', '#external_ca_name#', '#smime_certificate_expiration#', '#getcertprint.cm_thumbprint#', '#getcertprint.cm_id#', '1')
</cfquery>
</cfif>

<cfset m=8>
<cfset show_smime_password1="">
<cfset encryptedPassword="">

<cfelseif #nextcount# LTE #certcount#>
<cfset step=0>
<cfset m=10>

<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

</cfif>


</cfif>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion17" style="height: 248px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" enctype="multipart/form-data" action="<cfoutput>import_smime_certificate.cfm?id=#id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="import">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="622">
                                          <table id="Table143" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 14px;">
                                              <td width="622" id="Cell932">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell933">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="#theRecipient#"></cfoutput></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table186" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 175px;">
                                            <tr style="height: 14px;">
                                              <td width="954" id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select PFX file <span style="font-weight: normal;">(.pfx files only)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1022">
                                                <table width="567" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><input type="file" name="pfx">
<input type="hidden" name="fileupload">












&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1023">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PFX file password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1024">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_smime_password1#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1025">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Add to Certificate Trust List</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1026">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 2px;">
                                                        <tr style="height: 17px;">
                                                          <td width="71" id="Cell1027">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #ctl# is "1">
<cfoutput>
<input type="radio" checked="checked" name="ctl" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #ctl# is not "1">
<cfoutput>
<input type="radio" name="ctl" value="1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="460" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #ctl# is "2">
<cfoutput>
<input type="radio" checked="checked" name="ctl" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #ctl# is not "2">
<cfoutput>
<input type="radio" name="ctl" value="2" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">NO</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                                  <tr style="height: 17px;">
                                                    <td width="954" id="Cell1033">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="133" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Importing, please wait...';this.form.submit();" name="savechanges" value="Import Certificate" style="height: 24px; width: 160px;">
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
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="958">
                                      <tr valign="top" align="left">
                                        <td width="958" height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="958" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password must be at least 8 characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PFX Certificate Password must contain letters, numbers and special characters</span></i></b></p>
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

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;You have attempted to upload an invalid file type. The file type must be a .pfx</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must select a .pfx file to upload</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! PFX file has been imported to the system</span></i></b></p><br>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the .pfx file name must not contain any special characters or spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the .pfx file was not successfully imported. You have either entered an incorrect password or the .pfx file has already been imported</span></i></b></p>
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
                          <td colspan="8" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="6" valign="middle" width="960"><hr id="HRRule4" width="960" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="45"></td>
                          <td colspan="5" width="957">

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion18" style="height: 45px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="17"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="957">
                                        <table id="Table189" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="957" id="Cell1034">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="635" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><cfif #type# is "1">
<form name="apply_settings" action="<cfoutput>internal_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
  


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

<form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
  


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
                          <td colspan="2"></td>
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