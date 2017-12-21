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
<title>Delete Key</title>
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
              <td height="483" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 483px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="8" height="18"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="448"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Delete Recipient PGP Key</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="139"></td>
                          <td colspan="4" width="957"><cfparam name = "m" default = "0">

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "10"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>


<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<CFPARAM NAME="action" DEFAULT="">
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfif NOT IsDefined('url.type')>
<cfquery name="getkeys" datasource="#datasource#">
select * from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getkeys.recordcount# GTE 1>

<cfquery name="getinfo" datasource="#datasource#">
select * from recipients where id='#getkeys.user_id#'
</cfquery>

<cfif #getinfo.recordcount# GTE 1>

<cfif #getkeys.master# is "1">
<cfset thekeytype="master">
<cfelseif #getkeys.master# is "0">
<cfset thekeytype="sub">
</cfif>

<cfset type=1>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getkeys.pgp_keystore_password, #theKey#, "AES", "Base64")>

<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeys.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getkeys.recordcount -->
</cfif>

<cfelseif IsDefined('url.type')>

<cfif #url.type# is not "2">
<cfquery name="getkeys" datasource="#datasource#">
select * from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getkeys.recordcount# GTE 1>

<cfquery name="getinfo" datasource="#datasource#">
select * from recipients where id='#getkeys.user_id#'
</cfquery>

<cfif #getinfo.recordcount# GTE 1>

<cfif #getkeys.master# is "1">
<cfset thekeytype="master">
<cfelseif #getkeys.master# is "0">
<cfset thekeytype="sub">
</cfif>

<cfset type=1>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getkeys.pgp_keystore_password, #theKey#, "AES", "Base64")>

<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeys.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getkeys.recordcount -->
</cfif>

<cfelseif #url.type# is "2">

<cfquery name="getkeys" datasource="#datasource#">
select * from recipient_keystores where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and external='1'
</cfquery>

<cfif #getkeys.recordcount# GTE 1>

<cfquery name="getinfo" datasource="#datasource#">
select id, email as recipient from external_recipients where id='#getkeys.user_id#'
</cfquery>

<cfif #getinfo.recordcount# GTE 1>

<cfif #getkeys.master# is "1">
<cfset thekeytype="master">
<cfelseif #getkeys.master# is "0">
<cfset thekeytype="sub">
</cfif>

<cfset type=2>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getkeys.pgp_keystore_password, #theKey#, "AES", "Base64")>

<cfelseif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">
<!-- /CFIF for getinfo.recordcount -->
</cfif>

<cfelseif #getkeys.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">

<!-- /CFIF for getkeys.recordcount -->
</cfif>

<!-- /CFIF for url.type -->
</cfif>

<!-- /CFIF for IsDefined('url.type') -->
</cfif>


<cfif #action# is "delete">

<cfif #thekeytype# is "master">

<cfquery name="getkeystoredetails" datasource="#datasource#">
select id, pgp_fingerprint, pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#url.id#'
</cfquery>

<cfquery name="getchildren" datasource="#datasource#">
select id, pgp_fingerprint,  pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where parent  = '#getkeystoredetails.id#'
</cfquery>

<cfloop query="getchildren">

<cfquery name="getchildkeystoredetails" datasource="#datasource#">
select id, pgp_fingerprint,  pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#id#'
</cfquery>

<cfquery name="getpgpcmid" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletepgpnamevalues" datasource="djigzo">
delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
</cfquery>

<cfquery name="deletetrustlist" datasource="djigzo">
delete from cm_pgp_trust_list where cm_fingerprint = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletekeystore" datasource="djigzo">
delete from cm_keystore where cm_alias = 'PGP:#getchildkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletecmkeyringuserid" datasource="djigzo">
delete from cm_keyring_userid where cm_keyring_id = '#getchildkeystoredetails.djigzo_keystore_id#'
</cfquery>


<cfquery name="deletecmkeyringemail" datasource="djigzo">
delete from cm_keyring_email where cm_keyring_id = '#getchildkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deletecmkeyring" datasource="djigzo">
delete from cm_keyring where cm_id = '#getchildkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deleterecipientkeystore" datasource="#datasource#">
delete from recipient_keystores where pgp_fingerprint_sha256 = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

</cfloop>

<cfquery name="getpgpcmid" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletepgpnamevalues" datasource="djigzo">
delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
</cfquery>

<cfquery name="deletetrustlist" datasource="djigzo">
delete from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletekeystore" datasource="djigzo">
delete from cm_keystore where cm_alias = 'PGP:#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletecmkeyringuserid" datasource="djigzo">
delete from cm_keyring_userid where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>


<cfquery name="deletecmkeyringemail" datasource="djigzo">
delete from cm_keyring_email where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deletecmkeyring" datasource="djigzo">
delete from cm_keyring where cm_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deleterecipientkeystore" datasource="#datasource#">
delete from recipient_keystores where pgp_fingerprint_sha256 = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<!-- DELETE FROM GNUPG STARTS HERE -->

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


<cffile action="read" file="/opt/hermes/scripts/delete_gpg_master_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
    output = "#REReplace("#temp#","THE_KEY","#getkeystoredetails.pgp_fingerprint#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
timeout = "240"
variable="thekeyemail2"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- DELETE FROM GNUPG ENDS HERE -->

<cfelseif #thekeytype# is "sub">

<cfquery name="getkeystoredetails" datasource="#datasource#">
select id, pgp_fingerprint, pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#url.id#'
</cfquery>

<cfquery name="getpgpcmid" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletepgpnamevalues" datasource="djigzo">
delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
</cfquery>

<cfquery name="deletetrustlist" datasource="djigzo">
delete from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletekeystore" datasource="djigzo">
delete from cm_keystore where cm_alias = 'PGP:#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletecmkeyringuserid" datasource="djigzo">
delete from cm_keyring_userid where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>


<cfquery name="deletecmkeyringemail" datasource="djigzo">
delete from cm_keyring_email where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deletecmkeyring" datasource="djigzo">
delete from cm_keyring where cm_id = '#getkeystoredetails.djigzo_keystore_id#'
</cfquery>

<cfquery name="deleterecipientkeystore" datasource="#datasource#">
delete from recipient_keystores where pgp_fingerprint_sha256 = '#getkeystoredetails.pgp_fingerprint_sha256#'
</cfquery>

<!-- SINCE THERE IS NO WAY TO DELETE SUB KEY FROM GNUPG WITHOUT INTERACTIVE PROMPTS, WE DON'T DELETE FROM GNUPG FOR A SUB KEY -->

<!-- /CFIF thekeytype -->
</cfif>

<cfif #type# is "2">

<cfoutput>
<cflocation url="external_encryption_users.cfm?id=#getinfo.id#&action=deletedkey&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#" addToken = "no">
</cfoutput>

<cfelseif #type# is "1">

<cfoutput>
<cflocation url="internal_encryption_users.cfm?id=#getinfo.id#&action=deletedkey&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#" addToken = "no">
</cfoutput>

</cfif>

<!-- /CFIF action -->
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 139px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>delete_key.cfm?id=#url.id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text215" class="TextObject">
                                          <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">The system will delete the PGP Key indicated below. Deleting a key is <b><u>irreversible</u></b>. <b>If you are deleting a Master PGP Key, the system will automatically delete any associated Sub Keys</b>. If you delete the last Key for a PGP enabled recipient, PGP encryption will no longer work until you generate or import another PGP Keyring for this recipient. If you are sure you wish to delete this key, click the <b>Delete Key</b> button. Otherwise, click on the <b>Back to Recipient PGP Keyrings</b> button. </span></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="4"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table9" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 10px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell408">
                                                <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <cfoutput>
                                              <td id="Cell62">
                                                <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center"><cfoutput><input type="text" id="FormsEditField5" name="email" size="35" maxlength="45" disabled="disabled" style="width: 276px; white-space: pre;" value="#getinfo.recipient#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                </cfoutput>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                      <table border="0" cellspacing="0" cellpadding="0" width="954">
                                        <tr valign="top" align="left">
                                          <td width="954" height="2"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="954" id="Text375" class="TextObject">
                                            <p style="text-align: center; margin-bottom: 0px;"><table border="0" cellspacing="4" cellpadding="0" width="954px" style="height: 102px;">
  <tr style="height: 14px;">
    <td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Size</span></b></p>
    </td>


<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Name</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell973">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Created</span></b></p>
    </td>
    <td style="background-color: rgb(241,236,236);" id="Cell974">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Expires</span></b></p>
    </td>
    
        <td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Private Key</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Key ID</span></b></p>
    </td>


    
<td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Parent ID</span></b></p>
    </td>

    
  </tr>

<cfloop query="getkeys">
  <tr style="height: 36px;">

<cfoutput>



<cfif #thekeytype# is "master">

    <td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">MASTER</span></p>
    </td>

<cfelseif #thekeytype# is "sub">

<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">SUB</span></p>
    </td>

</cfif>


<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#encryption#</span></p>
    </td>


<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#user_name#</span></p>
    </td>



    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_creation, "mm/dd/yyyy")#</span></p>
    </td>
<cfif #pgp_keystore_expiration# is not "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_expiration, "mm/dd/yyyy")#</span></p>
    </td>

<cfelseif #pgp_keystore_expiration# is "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">N/A</span></p>
    </td>


</cfif>

<cfquery name="getprivatekeyalias" datasource="djigzo">
select cm_private_key_alias from cm_keyring where cm_sha256fingerprint='#pgp_fingerprint#'
</cfquery>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">
<td id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Not Available</span></p>
    </td>


<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
    <td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Available</span></p>
    </td>
</cfif>

<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#pgp_key_id#</span></p>
    </td>


<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">N/A</span></p>
    </td>



</cfoutput>


</tr>         

</cfloop>
</table>

        
&nbsp;</p>
                                          </td>
                                        </tr>
                                      </table>
                                      <table border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top" align="left">
                                          <td height="3"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="957">
                                            <table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                              <tr style="height: 22px;">
                                                <td width="957" id="Cell435">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="206" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Deleting, please wait...';this.form.submit();" name="FormsButton1" value="Delete Key" style="height: 24px; width: 144px;">&nbsp;</p>
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
                                    </form>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="7" height="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="2" height="30"></td>
                            <td colspan="4" valign="middle" width="957"><hr id="HRRule1" width="957" size="1"></td>
                            <td></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="7" height="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="40"></td>
                            <td colspan="4" width="956">

                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956">
                                          <form name="apply_settings" action="<cfoutput>view_pgp_keyrings.cfm?id=#getkeys.user_id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="956" id="Cell518">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="591" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Recipient PGP Keyrings" style="height: 24px; width: 357px;">
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