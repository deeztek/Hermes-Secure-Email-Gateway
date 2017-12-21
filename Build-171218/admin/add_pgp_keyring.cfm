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
<title>Add PGP Keyring</title>
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
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Add Recipient PGP Keyring</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="338"></td>
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

<cfparam name = "show_realname" default = ""> 
<cfif IsDefined("form.realname") is "True">
<cfif form.realname is not "">
<cfset show_realname = form.realname>
</cfif></cfif> 
 
<cfparam name = "show_encryption" default = "4096"> 
<cfif IsDefined("form.encryption") is "True">
<cfif form.encryption is not "">
<cfset show_encryption = form.encryption>
</cfif></cfif> 

<cfparam name = "show_pgp_password1" default = ""> 
<cfif IsDefined("form.password1") is "True">
<cfif form.password1 is not "">
<cfset show_pgp_password1 = form.password1>
</cfif></cfif> 

<cfparam name = "show_pgp_password2" default = ""> 
<cfif IsDefined("form.password2") is "True">
<cfif form.password2 is not "">
<cfset show_pgp_password2 = form.password2>
</cfif></cfif> 

<cfif #autopass# is "yes">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 30
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

<cfset show_pgp_password1=#gettrans.customtrans2#>
<cfset show_pgp_password2=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>
</cfif>

<cfif #action# is "Create Keyring">

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

<cfif #show_realname# is "">
<cfset step=0>
<cfset m=6>
<cfelseif #show_realname# is not "">
<cfset step=1>
</cfif>


<cfif step is "1">
<cfif #show_pgp_password1# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_pgp_password1# is not "">
<cfset step=2>
</cfif>
</cfif>


<cfif step is "2">
<cfif NOT ( len(show_pgp_password1) GTE 10)>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfif REFind("[a-z]",show_pgp_password1) gte 1 and REFind("[A-Z]",show_pgp_password1) gte 1 and REFind("[0-9]",show_pgp_password1) GTE 1>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
</cfif>
</cfif>

<cfif step is "3" and #show_pgp_password2# is "">
<cfset step=0>
<cfset m=4>
<cfelseif step is "3" and #show_pgp_password2# is not "">
<cfset step=4>
</cfif>

<cfif step is "4" and #show_pgp_password1# is not "" and #show_pgp_password2# is not "">
<cfset compare_password = Compare(#show_pgp_password1#, #show_pgp_password2#)>
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

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>

<!-- CREATE GPG TEMPLATE STARTS HERE -->

<cffile action="read" file="/opt/hermes/templates/gpg_template" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","KEY_LENGTH","#show_encryption#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","NAME_REAL","#show_realname#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","NAME_EMAIL","#getrecipientdetails.recipient#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","PASS_PHRASE","#show_pgp_password1#","ALL")#" addnewline="no">
    
<!-- CREATE GPG TEMPLATE ENDS HERE -->

<!-- CREATE_PGP_KEY SCRIPT STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/create_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
    output = "#REReplace("#temp1#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
outputfile ="/opt/hermes/tmp/#customtrans3#_gpg_output"
timeout = "240"
arguments="-inputformat none">
</cfexecute>

<!-- DELETE CREATE_PGP_KEY -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- DELETE GPG_TEMPLATE -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_gpg_template">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>
    
<!-- CREATE GPG SCRIPT ENDS HERE -->

<!-- CREATE_PGP_KEY SCRIPT ENDS HERE -->

<!-- EXPORT_IMPORT_PGP_KEY SCRIPT STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/export_import_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
    output = "#REReplace("#temp1#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
    output = "#REReplace("#temp1#","THE-PASSWORD","#show_pgp_password1#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
outputfile ="/dev/null"
timeout = "240"
arguments="-inputformat none">
</cfexecute>

<!-- DELETE EXPORT_IMPORT_PGP_KEY -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- DELETE public.key THAT THE EXPORT_IMPORT_PGP_KEY.SH SCRIPT CREATES -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_public.key">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- DELETE private.key THAT THE EXPORT_IMPORT_PGP_KEY.SH SCRIPT CREATES -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_private.key">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- EXPORT_IMPORT_PGP_KEY SCRIPT ENDS HERE -->

<!-- READ KEYID FROM _GPG_OUTPUT FILE -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_output" variable="theKeyID2">
<cfset theKeyID = #TRIM(theKeyID2)#>

<!-- DELETE _GPG_OUTPUT FILE -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_gpg_output">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfquery name="getparentdjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_keyidhex='#theKeyID#' and cm_master='1'
</cfquery>

<cfquery name="getchilddjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_parentid='#getparentdjigzokeyring.cm_id#' and cm_master='0'
</cfquery>

<!-- INSERT PARENT AND CHILD KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES STARTS HERE -->
<cfoutput>
<cfquery name="insertctlmaster" datasource="djigzo">
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#getparentdjigzokeyring.cm_sha256fingerprint#')
</cfquery>

<cfquery name="getctlmaster" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfquery name="insertctlmasternamevalues" datasource="djigzo">
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctlmaster.cm_id#', 'trusted','status')
</cfquery>

</cfoutput>



<cfloop query="getchilddjigzokeyring">
<cfoutput>
<cfquery name="insertctlchild" datasource="djigzo">
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#cm_sha256fingerprint#')
</cfquery>

<cfquery name="getctlchild" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint='#cm_sha256fingerprint#'
</cfquery>

<cfquery name="insertctlchildnamevalues" datasource="djigzo">
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctlchild.cm_id#', 'trusted','status')
</cfquery>

</cfoutput>
</cfloop>

<!-- INSERT PARENT AND CHILD KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES ENDS HERE -->

<!-- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE STARTS HERE -->
<cfif #getparentdjigzokeyring.cm_expiration_date# is not "">
<cfset pgp_keystore_expiration_date = #DateFormat(getparentdjigzokeyring.cm_expiration_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_expiration_time = #TimeFormat(getparentdjigzokeyring.cm_expiration_date, "HH:mm:ss")#>
<cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">
<cfelseif #getparentdjigzokeyring.cm_expiration_date# is "">
<cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
</cfif>

<cfset pgp_keystore_creation_date = #DateFormat(getparentdjigzokeyring.cm_creation_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_creation_time = #TimeFormat(getparentdjigzokeyring.cm_creation_date, "HH:mm:ss")#>
<cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">

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
<cfset encryptedPassword=encrypt(show_pgp_password1, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_pgp_password1, #theKey#, "AES", "Base64")>
</cfif>

<cfif #type# is "1">

<cfif #pgp_keystore_expiration # is not "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA',
 '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '1')
</cfquery>
</cfoutput>

</cfif>

<cfquery name="getparentid" datasource="#datasource#">
select * from recipient_keystores where master='1' and pgp_fingerprint_sha256='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfloop query="getchilddjigzokeyring">
<cfif #pgp_keystore_expiration # is not "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, parent)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA',
 '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#')
</cfquery>
</cfoutput>
</cfif>

</cfloop>

<cfelseif #type# is "2">
<cfif #pgp_keystore_expiration # is not "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, external)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '#getparentdjigzokeyring.cm_master#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA',
 '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '#getparentdjigzokeyring.cm_master#', '1')
</cfquery>
</cfoutput>
</cfif>


<cfquery name="getparentid" datasource="#datasource#">
select * from recipient_keystores where master='1' and pgp_fingerprint_sha256='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfloop query="getchilddjigzokeyring">
<cfif #pgp_keystore_expiration # is not "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">
<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#show_realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#show_encryption#', 'RSA',
 '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#', '1')
</cfquery>
</cfoutput>
</cfif>

</cfloop>

<!-- /CFIF for type -->
</cfif>

<!-- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE ENDS HERE -->

<cfif #type# is "1">
<cflocation url="internal_encryption_users.cfm?id=#url.id#&action=addedpgp&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#" addtoken="no">
<cfelseif #type# is "2">
<cflocation url="external_encryption_users.cfm?id=#url.id#&action=addedpgp&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#" addtoken="no">
</cfif>

</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion17" style="height: 338px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>add_pgp_keyring.cfm?id=#url.id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="549">
                                      <tr valign="top" align="left">
                                        <td width="549" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PGP Secret Key Password cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;PGP Secret Key Password must be at least 10 characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;PGP Secret Key Password must upper, lowercase case characters, numbers and it must NOT contain any special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;PGP Secret Key Password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;PGP Secret Key Passwords you entered  do not match</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Recipient Real Name field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "100">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved</span></i></b></p><br>

<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must click the Apply Settings button for your changes to take effect. Please allow approximately 30 seconds for the changes to propagate accross our systems</span></i></b></p>
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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
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
                                        <td height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="590">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 182px;">
                                            <tr style="height: 14px;">
                                              <td width="586" id="Cell1033">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"><b>Recipient Real Name </b><span style="font-weight: normal;">(e.g. John Doe)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1032">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField5" name="realname" size="30" maxlength="255" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_realname#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell886">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Keyring Size</span></b></p>
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
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Auto-Generate PGP Secret Key Password</span></b></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Secret Key Password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell891">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #autopass# is "yes">
<cfoutput>
<input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password1#" disabled="disabled">
</cfoutput>

<cfelseif #autopass# is "no">
<cfoutput>
<input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password1#">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell892">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Verify PGP Secret Key Password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell893">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #autopass# is "yes">
<cfoutput>
<input type="password" id="FormsEditField20" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password2#" disabled="disabled">
</cfoutput>
<cfelseif #autopass# is "no">
<cfoutput>
<input type="password" id="FormsEditField20" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password2#">
</cfoutput>
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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="10"></td>
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
                                                            <p style="margin-bottom: 0px;"><input type="submit" name="action" value="Create Keyring" style="height: 24px; width: 133px;">
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
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="953"><hr id="HRRule5" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
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