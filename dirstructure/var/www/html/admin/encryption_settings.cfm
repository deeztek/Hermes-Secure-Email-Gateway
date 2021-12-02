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
<title>Encryption Settings</title>
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
<script type="text/javascript">
<!--
var hwndPopup_27b5;
function openpopup_27b5(url){
var popupWidth = 900;
var popupHeight = 780;
var popupTop = 300;
var popupLeft = 300;
var isFullScreen = false;
var isAutoCenter = false;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=0";

if (isFullScreen) {
	popupParams += ", fullscreen=1";
} else if (isAutoCenter) {
	popupTop	= parseInt((window.screen.height - popupHeight)/2);
	popupLeft	= parseInt((window.screen.width - popupWidth)/2);
}

var ua = window.navigator.userAgent;
var isMac = (ua.indexOf("Mac") > -1);

//IE 5.1 PR on OSX 10.0.x does not support relative URLs in pop-ups the way they're handled below w/ document.writeln
if (isMac && url.indexOf("http") != 0) {
  url = location.href.substring(0,location.href.lastIndexOf('\/')) + "/" + url;
}

var isOpera = (ua.indexOf("Opera") > -1);
var operaVersion;
if (isOpera) {
	var i = ua.indexOf("Opera");
	operaVersion = parseFloat(ua.substring(i + 6, ua.indexOf(" ", i + 8)));
	if (operaVersion > 7.00) {
		var isAccessible = false;
		eval("try { isAccessible = ( (hwndPopup_27b5 != null) && !hwndPopup_27b5.closed ); } catch(exc) { } ");
		if (!isAccessible) {
			hwndPopup_27b5 = null;
		}
	}
}
if ( (hwndPopup_27b5 == null) || hwndPopup_27b5.closed ) {
	
	if (isOpera && (operaVersion < 7)) {
		if (url.indexOf("http") != 0) {
			hwndPopup_27b5 = window.open(url,popupTarget,popupParams + ((!isFullScreen) ? ", width=" + popupWidth +", height=" + popupHeight : ""));
			if (!isFullScreen) {
				hwndPopup_27b5.moveTo(popupLeft, popupTop);
			}
			hwndPopup_27b5.focus();
			return;
		}
	}
	if (!(window.navigator.appName == "Netscape" && !document.getElementById)) {
		//not ns4
		popupParams += ", width=" + popupWidth +", height=" + popupHeight + ", left=" + popupLeft + ", top=" + popupTop;
	} else {
		popupParams += ", left=" + popupLeft + ", top=" + popupTop;
	}
	//alert(popupParams);
	hwndPopup_27b5 = window.open("",popupTarget,popupParams);
	if (!isFullScreen) {
		hwndPopup_27b5.resizeTo(popupWidth, popupHeight);
		hwndPopup_27b5.moveTo(popupLeft, popupTop);
	}
	hwndPopup_27b5.focus();
	with (hwndPopup_27b5.document) {
		open();
    		write("<ht"+"ml><he"+"ad><\/he"+"ad><bo"+"dy onLoad=\"window.location.href='" + url + "'\"><\/bo"+"dy><\/ht"+"ml>");
		close();
	}
} else {
	if (isOpera && (operaVersion > 7.00)) {
		eval("try { hwndPopup_27b5.focus();	hwndPopup_27b5.location.href = url; } catch(exc) { hwndPopup_27b5 = window.open(\""+ url +"\",\"" + popupTarget +"\",\""+ popupParams + ", width=" + popupWidth +", height=" + popupHeight +"\"); } ");
	} else {
		hwndPopup_27b5.focus();
		hwndPopup_27b5.location.href = url;
	}
}

}

-->
</script>
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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="630" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 630px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="515">
                              <tr valign="top" align="left">
                                <td width="9" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Encryption Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="455">
                              <tr valign="top" align="left">
                                <td width="430" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/encryption-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="8" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="576"></td>
                          <td width="964"><cfparam name = "m" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 

<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<cfquery name="get_subjectenable" datasource="#datasource#">
select property, value from encryption_settings where property='user.subjectTriggerEnabled'
</cfquery>

<cfquery name="get_subject_trigger" datasource="#datasource#">
select property, value from encryption_settings where property='user.subjectTrigger'
</cfquery>

<cfquery name="get_removesubjecttrigger" datasource="#datasource#">
select property, value from encryption_settings where property='user.subjectTriggerRemovePattern'
</cfquery>

<cfquery name="get_portal_url" datasource="#datasource#">
select property, value from encryption_settings where property='user.portal.baseURL'
</cfquery>

<cfquery name="get_pdfreply_sender" datasource="#datasource#">
select property, value from encryption_settings where property='user.pdf.replySender'
</cfquery>



<cfquery name="get_serverkeyword" datasource="#datasource#">
select property, value from encryption_settings where property='user.serverSecret'
</cfquery>

<cfif #get_serverkeyword.value# is "">

<cfset theServerKeyword = #get_serverkeyword.value#>

<cfelse>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<!-- DECRYPT KEYWORD -->
<cfset theServerKeyword = decrypt(get_serverkeyword.value, #hermeskey#, "AES", "Base64")>


<!-- /CFIF #get_serverkeyword.value# is ""  -->
</cfif>


<cfquery name="get_clientkeyword" datasource="#datasource#">
select property, value from encryption_settings where property='user.clientSecret'
</cfquery>

<cfif #get_clientkeyword.value# is "">

<cfset theClientKeyword = #get_clientkeyword.value#>

<cfelse>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<!-- DECRYPT KEYWORD -->
<cfset theClientKeyword = decrypt(get_clientkeyword.value, #hermeskey#, "AES", "Base64")>


<!-- /CFIF #get_clientkeyword.value# is ""  -->
</cfif>

<cfquery name="get_mailkeyword" datasource="#datasource#">
select property, value from encryption_settings where property='user.systemMailSecret'
</cfquery>

<cfif #get_mailkeyword.value# is "">

<cfset theMailKeyword = #get_mailkeyword.value#>

<cfelse>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<!-- DECRYPT KEYWORD -->
<cfset theMailKeyword = decrypt(get_mailkeyword.value, #hermeskey#, "AES", "Base64")>


<!-- /CFIF #get_mailkeyword.value# is ""  -->
</cfif>


<cfparam name = "show_subjectenable" default = "#get_subjectenable.value#"> 
<cfif IsDefined("form.subjectenable") is "True">
<cfset show_subjectenable = form.subjectenable>
</cfif>


<cfparam name = "show_subject_trigger" default = "#get_subject_trigger.value#"> 
<cfif IsDefined("form.subject_trigger") is "True">
<cfset show_subject_trigger = form.subject_trigger>
</cfif> 


<cfparam name = "show_removesubjecttrigger" default = "#get_removesubjecttrigger.value#"> 
<cfif IsDefined("form.removesubjecttrigger") is "True">
<cfset show_removesubjecttrigger = form.removesubjecttrigger>
</cfif>


<cfparam name = "show_portal_url" default = "#get_portal_url.value#"> 
<cfif IsDefined("form.portal_url") is "True">
<cfset show_portal_url = form.portal_url>
</cfif>


<cfparam name = "show_pdfreply_sender" default = "#get_pdfreply_sender.value#"> 
<cfif IsDefined("form.pdfreply_sender") is "True">
<cfset show_pdfreply_sender = form.pdfreply_sender>
</cfif>

<cfparam name = "show_serverkeyword" default = "#theServerKeyword#"> 
<cfif IsDefined("form.serverkeyword") is "True">
<cfset show_serverkeyword = form.serverkeyword>
</cfif>

<cfparam name = "show_clientkeyword" default = "#theClientKeyword#"> 
<cfif IsDefined("form.clientkeyword") is "True">
<cfset show_clientkeyword = form.clientkeyword>
</cfif>


<cfparam name = "show_mailkeyword" default = "#theMailKeyword#"> 
<cfif IsDefined("form.mailkeyword") is "True">
<cfset show_mailkeyword = form.mailkeyword>
</cfif>



<cfif #action# is "Generate Server Keyword">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 103
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

<cfset show_serverkeyword=#LCase(gettrans.customtrans2)#>



<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

</cfif>

<cfif #action# is "Generate Client Keyword">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 103
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

<cfset show_clientkeyword=#LCase(gettrans.customtrans2)#>



<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

</cfif>

<cfif #action# is "Generate Mail Keyword">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 103
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

<cfset show_mailkeyword=#LCase(gettrans.customtrans2)#>



<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

</cfif>

<cfif #action# is "Save Settings">

<cfif #show_subject_trigger# is not "">
<cfset step=1>
<cfelseif #show_subject_trigger# is "">
<cfset step=0>
<cfset m=4>
</cfif>

<cfif #step# is "1">
<cfif #show_portal_url# is not "">
<cfset step=2>
<cfelseif #show_portal_url# is "">
<cfset step=0>
<cfset m=1>
</cfif>
</cfif>

<cfif #step# is "2">
<cfif #show_pdfreply_sender# is not "">
<cfif IsValid("email", show_pdfreply_sender)>
<cfset step=3>
<cfelseif not IsValid("email", show_pdfreply_sender)>
<cfset step=0>
<cfset m=2>
</cfif>
<cfelseif #show_pdfreply_sender# is "">
<cfset step=0>
<cfset m=3>
</cfif>
</cfif>

<cfif step is "3">
<cfif NOT ( len(show_serverkeyword) GTE 10)>
<cfset step=0>
<cfset m=8>
<cfelse>
<cfif REFind("[a-z]",show_serverkeyword) gte 1 and REFind("[0-9]",show_serverkeyword) GTE 1>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m=8>
</cfif>
</cfif>
</cfif>

<cfif step is "4">
<cfif NOT ( len(show_clientkeyword) GTE 10)>
<cfset step=0>
<cfset m=8>
<cfelse>
<cfif REFind("[a-z]",show_clientkeyword) gte 1 and REFind("[0-9]",show_clientkeyword) GTE 1>
<cfset step=5>
<cfelse>
<cfset step=0>
<cfset m=9>
</cfif>
</cfif>
</cfif>

<cfif step is "5">
<cfif NOT ( len(show_mailkeyword) GTE 10)>
<cfset step=0>
<cfset m=8>
<cfelse>
<cfif REFind("[a-z]",show_mailkeyword) gte 1 and REFind("[0-9]",show_mailkeyword) GTE 1>
<cfset step=6>
<cfelse>
<cfset step=0>
<cfset m=10>
</cfif>
</cfif>
</cfif>

<cfif #step# is "6">
<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#show_pdfreply_sender#' where property='user.pdf.replySender'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#show_portal_url#' where property='user.portal.baseURL'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#show_subject_trigger#' where property='user.subjectTrigger'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#show_subjectenable#' where property='user.subjectTriggerEnabled'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#show_removesubjecttrigger#' where property='user.subjectTriggerRemovePattern'
</cfquery>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset encrypted_serverkeyword=encrypt(show_serverkeyword, #hermeskey#, "AES", "Base64")>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#encrypted_serverkeyword#' where property='user.serverSecret'
</cfquery>

<cfset encrypted_clientkeyword=encrypt(show_clientkeyword, #hermeskey#, "AES", "Base64")>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#encrypted_clientkeyword#' where property='user.clientSecret'
</cfquery>

<cfset encrypted_mailkeyword=encrypt(show_mailkeyword, #hermeskey#, "AES", "Base64")>

<cfquery name="update" datasource="#datasource#">
update encryption_settings set value='#encrypted_mailkeyword#' where property='user.systemMailSecret'
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


<cffile action="read" file="/opt/hermes/scripts/edit_encryption_settings.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","PDFREPLY-SENDER","#show_pdfreply_sender#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","PORTAL-URL","#show_portal_url#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","SUBJECT-TRIGGER","#show_subject_trigger#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","SUBJECT-ENABLE","#show_subjectenable#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","TRIGGER-REMOVE","#show_removesubjecttrigger#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","SERVER-SECRET","#show_serverkeyword#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","CLIENT-SECRET","#show_clientkeyword#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
    output = "#REReplace("#temp#","MAIL-SECRET","#show_mailkeyword#","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_edit_encryption_settings.sh">

<cfset m=7>

</cfif>



</cfif>

<table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion11" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 330px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="964" id="LayoutRegion11" style="height: 576px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="964"><form name="edit" action="encryption_settings.cfm" method="post">
                                        <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 272px;">
                                          <tr style="height: 14px;">
                                            <td width="960" id="Cell469">
                                              <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Trigger encryption by e-mail subject***</span></b></span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 38px;">
                                            <td id="Cell468">
                                              <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td>
                                                    <table id="Table80" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                      <tr style="height: 19px;">
                                                        <td width="45" id="Cell470">
                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="margin-bottom: 0px;"><cfif #show_subjectenable# is "true">
<cfoutput>
<input type="radio" checked="checked" name="subjectenable" value="true" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_subjectenable# is "false">
<cfoutput>
<input type="radio" name="subjectenable" value="true" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                          &nbsp;</td>
                                                        <td width="438" id="Cell471">
                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                        </td>
                                                      </tr>
                                                      <tr style="height: 19px;">
                                                        <td id="Cell472">
                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="margin-bottom: 0px;"><cfif #show_subjectenable# is "true">
<cfoutput>
<input type="radio" name="subjectenable" value="false" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_subjectenable# is "false">
<cfoutput>
<input type="radio" checked="checked" name="subjectenable" value="false" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                          &nbsp;</td>
                                                        <td id="Cell473">
                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled<span style="font-size: 10px; font-weight: normal;"> (Not recommended)</span></span></b></p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell406">
                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Encryption by e-mail subject keyword****</span></b></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 22px;">
                                            <td id="Cell409">
                                              <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject"><cfoutput>
<input type="text" name="subject_trigger" size="30" maxlength="75" style="width: 396px; white-space: pre;" value="#show_subject_trigger#" >
</cfoutput>

                                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell410">
                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Remove e-mail subject keyword after encryption</span></b></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 38px;">
                                            <td id="Cell408">
                                              <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table81" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                        <tr style="height: 19px;">
                                                          <td width="45" id="Cell474">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_removesubjecttrigger# is "true">
<cfoutput>
<input type="radio" checked="checked" name="removesubjecttrigger" value="true" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_removesubjecttrigger# is "false">
<cfoutput>
<input type="radio" name="removesubjecttrigger" value="true" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="438" id="Cell475">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes <span style="font-size: 10px; font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell476">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_removesubjecttrigger# is "false">
<cfoutput>
<input type="radio" checked="checked" name="removesubjecttrigger" value="false" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_removesubjecttrigger# is not "false">
<cfoutput>
<input type="radio" name="removesubjecttrigger" value="false" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell477">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No<span style="font-size: 10px; font-weight: normal;"> </span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1017">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Secure Portal Address<span style="font-weight: normal;"> (Default: https://hermes.domain.tld/web/portal)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1018">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject"><cfoutput>
<input type="text" name="portal_url" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="#show_portal_url#" >
</cfoutput>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1019">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PDF Reply Sender E-mail</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1020">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject"><cfoutput>
<input type="text" name="pdfreply_sender" size="30" maxlength="255" style="width: 396px; white-space: pre;" value="#show_pdfreply_sender#" >
</cfoutput>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1033">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table82" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          <td width="55" id="Cell1036">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Server Keyword"><img src="generate_icon.png" alt="Generate Server Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Server Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Server Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1023">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject"><cfoutput>
<input type="text" name="serverkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="#show_serverkeyword#" >
</cfoutput>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1042">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table83" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          <td width="55" id="Cell1043">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Client Keyword"><img src="generate_icon.png" alt="Generate Client Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1044">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Client Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1035">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Client Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1022">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject"><cfoutput>
<input type="text" name="clientkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="#show_clientkeyword#" >
</cfoutput>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1045">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table84" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          <td width="55" id="Cell1046">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Mail Keyword"><img src="generate_icon.png" alt="Generate Mail Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1047">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Mail Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1039">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Mail Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1040">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject"><cfoutput>
<input type="text" name="mailkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="#show_mailkeyword#" >
</cfoutput>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1041">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="350" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" name="action" value="Save Settings" onclick="this.form.submit();"  style="height: 24px; width: 133px;">
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
                                          

</form></td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      <tr valign="top" align="left">
                                        <td width="964" height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="964" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Secure Portal Address cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Encryption by e-mail subject keyword field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings updated</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Server Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Client Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Mail Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
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