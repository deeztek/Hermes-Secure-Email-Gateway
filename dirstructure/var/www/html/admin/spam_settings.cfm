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
<title>Spam Settings</title>
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
              <td height="843" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 843px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="11" height="21"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antispam Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="453">
                              <tr valign="top" align="left">
                                <td width="428" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/antispam-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="6"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="680"></td>
                          <td width="959"><cfparam name = "m" default = "0"> 
<cfparam name = "m2" default = "0"> 
<cfparam name = "step" default = "0">


<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfset show_action = form.action>
</cfif>

<cfquery name="get_use_bayes" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_bayes' and active = '1'
</cfquery>

<cfquery name="get_bayes_auto_learn" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn' and active = '1'
</cfquery>

<cfquery name="get_bayes_auto_learn_threshold_nonspam" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_nonspam' and active = '1'
</cfquery>

<cfquery name="get_bayes_auto_learn_threshold_spam" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_spam' and active = '1'
</cfquery>

<cfquery name="get_use_dcc" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_dcc' and active = '1'
</cfquery>

<cfquery name="get_use_razor2" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_razor2' and active = '1'
</cfquery>

<cfquery name="get_use_pyzor" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_pyzor' and active = '1'
</cfquery>


<cfquery name="get_sa_spam_subject_tag" datasource="#datasource#">
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
</cfquery>

<cfquery name="get_final_virus_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_banned_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_spam_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_bad_header_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
</cfquery>

<cfparam name = "use_bayes" default = "#get_use_bayes.value#"> 
<cfif IsDefined("form.use_bayes") is "True">
<cfset use_bayes = form.use_bayes>
</cfif>

<cfparam name = "bayes_auto_learn" default = "#get_bayes_auto_learn.value#"> 
<cfif IsDefined("form.bayes_auto_learn") is "True">
<cfset bayes_auto_learn= form.bayes_auto_learn>
</cfif>

<cfparam name = "bayes_auto_learn_threshold_nonspam" default = "#get_bayes_auto_learn_threshold_nonspam.value#"> 
<cfif IsDefined("form.bayes_auto_learn_threshold_nonspam") is "True">
<cfset bayes_auto_learn_threshold_nonspam= form.bayes_auto_learn_threshold_nonspam>
</cfif>

<cfparam name = "bayes_auto_learn_threshold_spam" default = "#get_bayes_auto_learn_threshold_spam.value#"> 
<cfif IsDefined("form.bayes_auto_learn_threshold_spam") is "True">
<cfset bayes_auto_learn_threshold_spam= form.bayes_auto_learn_threshold_spam>
</cfif>

<cfparam name = "use_dcc" default = "#get_use_dcc.value#"> 
<cfif IsDefined("form.use_dcc") is "True">
<cfset use_dcc= form.use_dcc>
</cfif>

<cfparam name = "use_razor2" default = "#get_use_razor2.value#"> 
<cfif IsDefined("form.use_razor2") is "True">
<cfset use_razor2= form.use_razor2>
</cfif>

<cfparam name = "use_pyzor" default = "#get_use_pyzor.value#"> 
<cfif IsDefined("form.use_pyzor") is "True">
<cfset use_pyzor= form.use_pyzor>
</cfif>

<cfparam name = "show_sa_spam_subject_tag" default = "#get_sa_spam_subject_tag.value#"> 
<cfif IsDefined("form.sa_spam_subject_tag") is "True">
<cfset show_sa_spam_subject_tag = form.sa_spam_subject_tag>
</cfif>


<cfparam name = "show_final_virus_destiny" default = "#get_final_virus_destiny.value#"> 
<cfif IsDefined("form.final_virus_destiny") is "True">
<cfset show_final_virus_destiny = form.final_virus_destiny>
</cfif>

<cfparam name = "show_final_banned_destiny" default = "#get_final_banned_destiny.value#"> 
<cfif IsDefined("form.final_banned_destiny") is "True">
<cfset show_final_banned_destiny = form.final_banned_destiny>
</cfif>

<cfparam name = "show_final_spam_destiny" default = "#get_final_spam_destiny.value#"> 
<cfif IsDefined("form.final_spam_destiny") is "True">
<cfset show_final_spam_destiny = form.final_spam_destiny>
</cfif>

<cfparam name = "show_final_bad_header_destiny" default = "#get_final_bad_header_destiny.value#"> 
<cfif IsDefined("form.final_bad_header_destiny") is "True">
<cfset show_final_bad_header_destiny = form.final_bad_header_destiny>
</cfif>

<cfif #action# is "edit">

<cfset step=1>

<cfif step is "1">

<cfset step=2>


<!--- /CFIF FOR STEP 1 --->
</cfif>

<cfif #step# is "2">

<cfset step=3>


<!--- /CFIF STEP 2 --->
</cfif>

<cfif #step# is "3">

<cfif #show_sa_spam_subject_tag# is not "">
<cfset step=4>
<cfelseif #show_sa_spam_subject_tag# is "">
<cfset step=0>
<cfset m=2>
</cfif>

<!--- /CFIF STEP 3 --->
</cfif>

<cfif #step# is "4">

<cfif #bayes_auto_learn_threshold_spam# is not "">
<cfif IsValid("float", bayes_auto_learn_threshold_spam)>
<cfif #bayes_auto_learn_threshold_spam# GT 0 and #bayes_auto_learn_threshold_spam# LTE 999>
<cfset step=5>
<cfelse>
<cfset step=0>
<cfset m=4>

<!-- /CFIF for #bayes_auto_learn_threshold_spam# GT 0 and LTE 999 -->
</cfif>

<cfelseif NOT IsValid("float", bayes_auto_learn_threshold_spam)>
<cfset step=0>
<cfset m=5>

<!-- /CFIF for IsValid("float", bayes_auto_learn_threshold_spam)-->
</cfif>

<cfelseif #bayes_auto_learn_threshold_spam# is "">
<cfset step=0>
<cfset m=3>

<!-- /CFIF for #bayes_auto_learn_threshold_spam# is not "" -->
</cfif>

<!-- /CFIF for step 4 -->
</cfif>

<cfif #step# is "5">

<cfif #bayes_auto_learn_threshold_nonspam# is not "">
<cfif IsValid("float", bayes_auto_learn_threshold_nonspam)>
<cfif #bayes_auto_learn_threshold_nonspam# LT 0 and #bayes_auto_learn_threshold_nonspam# GTE -999>
<cfset step=6>
<cfelse>
<cfset step=0>
<cfset m=8>

<!-- /CFIF for auto_learn_threshold_nonspam# LT 0 and GTE -999 -->
</cfif>

<cfelseif NOT IsValid("float", bayes_auto_learn_threshold_nonspam)>
<cfset step=0>
<cfset m=10>

<!-- /CFIF for IsValid("float", bayes_auto_learn_threshold_nonspam)-->
</cfif>

<cfelseif #bayes_auto_learn_threshold_nonspam# is "">
<cfset step=0>
<cfset m=7>

<!-- /CFIF for #bayes_auto_learn_threshold_nonspam# is not "" -->
</cfif>

<!-- /CFIF for step 5 -->
</cfif>

<cfif #step# is "6">


<cfquery name="update_sa_spam_subject_tag" datasource="#datasource#">
update spam_settings set value='#show_sa_spam_subject_tag#', applied='2' where parameter='sa_spam_subject_tag'
</cfquery>

<cfquery name="update_final_virus_destiny" datasource="#datasource#">
update spam_settings set value='#show_final_virus_destiny#', applied='2' where parameter='final_virus_destiny'
</cfquery>

<cfquery name="update_final_banned_destiny" datasource="#datasource#">
update spam_settings set value='#show_final_banned_destiny#', applied='2' where parameter='final_banned_destiny'
</cfquery>

<cfquery name="update_final_spam_destiny" datasource="#datasource#">
update spam_settings set value='#show_final_spam_destiny#', applied='2' where parameter='final_spam_destiny'
</cfquery>

<cfquery name="update_final_bad_header_destiny" datasource="#datasource#">
update spam_settings set value='#show_final_bad_header_destiny#', applied='2' where parameter='final_bad_header_destiny'
</cfquery>

<cfquery name="update_use_bayes" datasource="#datasource#">
update spam_settings set value='#use_bayes#', applied='2' where parameter='use_bayes'
</cfquery>

<cfquery name="update_bayes_auto_learn" datasource="#datasource#">
update spam_settings set value='#bayes_auto_learn#', applied='2' where parameter='bayes_auto_learn'
</cfquery>

<cfquery name="update_use_dcc" datasource="#datasource#">
update spam_settings set value='#use_dcc#', applied='2' where parameter='use_dcc'
</cfquery>

<cfquery name="update_use_razor2" datasource="#datasource#">
update spam_settings set value='#use_razor2#', applied='2' where parameter='use_razor2'
</cfquery>

<cfquery name="update_use_pyzor" datasource="#datasource#">
update spam_settings set value='#use_pyzor#', applied='2' where parameter='use_pyzor'
</cfquery>

<cfset m=27>

<!-- /cfif for step 6 -->
</cfif>

<!-- /cfif for action -->
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion11" style="height: 680px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="spam_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0" width="959">
                                      <tr valign="top" align="left">
                                        <td width="959" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">
<cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the User Portal Address cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Spam Message Modified Subject String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String must be greater than 0 and less than or equal to 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String must be a valid integer</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String must be less than 0 and greater than or equal ot -999</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String must be an integer</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Username is not defined. Please navigate to <b>System --> System Settings</b> and specify a username for the Hermes MySQL Database </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Password is not defined. Please navigate to <b>System --> System Settings</b> and specify a password for the Hermes MySQL Database </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to apply your settings because the Hermes MySQL Database credentials are not defined or are incorrect. Please navigate to <b>System --> System Settings</b> and specify the correct credentials for the Hermes MySQL Database </span></i></b></p>
</cfoutput>
</cfif>



<cfif #m# is "27">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 640px;">
                                            <tr style="height: 14px;">
                                              <td width="959" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Distributed Checksum Clearninghouse (DCC)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 40px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table180" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1120">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_dcc# is "1">
<cfoutput>
<input type="radio" name="use_dcc" value="1" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_dcc# is not "1">
<cfoutput>
<input type="radio" name="use_dcc" value="1" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1121">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1122">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_dcc# is "0">
<cfoutput>
<input type="radio" name="use_dcc" value="0" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_dcc# is not "0">
<cfoutput>
<input type="radio" name="use_dcc" value="0" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1123">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1091">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Vipul&#8217;s Razor v2</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell1092">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table181" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1124">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_razor2# is "1">
<cfoutput>
<input type="radio" name="use_razor2" value="1" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_razor2# is not "1">
<cfoutput>
<input type="radio" name="use_razor2" value="1" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1125">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1126">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_razor2# is "0">
<cfoutput>
<input type="radio" name="use_razor2" value="0" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_razor2# is not "0">
<cfoutput>
<input type="radio" name="use_razor2" value="0" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1127">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1143">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Pyzor</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell1144">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table182" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1128">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_pyzor# is "1">
<cfoutput>
<input type="radio" name="use_pyzor" value="1" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_pyzor# is not "1">
<cfoutput>
<input type="radio" name="use_pyzor" value="1" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1129">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1130">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #use_pyzor# is "0">
<cfoutput>
<input type="radio" name="use_pyzor" value="0" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_pyzor# is not "0">
<cfoutput>
<input type="radio" name="use_pyzor" value="0" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1131">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1105">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Message Modified Subject String</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 23px;">
                                                <td id="Cell1099">
                                                  <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject"><cfoutput>
<input type="text" name="sa_spam_subject_tag" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="#show_sa_spam_subject_tag#" >
</cfoutput>

                                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1100">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Virus Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell1109">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1060">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_virus_destiny# is "D_DISCARD">
<cfoutput>
<input type="radio" name="final_virus_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_virus_destiny# is not "D_DISCARD">
<cfoutput>
<input type="radio" name="final_virus_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1061">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1062">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_virus_destiny# is "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_virus_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_virus_destiny# is not "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_virus_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1063">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1110">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Banned File Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell1111">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1078">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_banned_destiny# is "D_DISCARD">
<cfoutput>
<input type="radio" name="final_banned_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_banned_destiny# is not "D_DISCARD">
<cfoutput>
<input type="radio" name="final_banned_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1079">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1080">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_banned_destiny# is "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_banned_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_banned_destiny# is not "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_banned_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1081">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell1047">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1082">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_spam_destiny# is "D_DISCARD">
<cfoutput>
<input type="radio" name="final_spam_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_spam_destiny# is not "D_DISCARD">
<cfoutput>
<input type="radio" name="final_spam_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1083">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1084">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_final_spam_destiny# is "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_spam_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_spam_destiny# is not "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_spam_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1085">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Bad-Header Messages Action to take</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 40px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td>
                                                          <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                            <tr style="height: 19px;">
                                                              <td width="58" id="Cell1086">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;"><cfif #show_final_bad_header_destiny# is "D_DISCARD">
<cfoutput>
<input type="radio" name="final_bad_header_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_bad_header_destiny# is not "D_DISCARD">
<cfoutput>
<input type="radio" name="final_bad_header_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td width="429" id="Cell1087">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                              </td>
                                                            </tr>
                                                            <tr style="height: 19px;">
                                                              <td id="Cell1088">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;"><cfif #show_final_bad_header_destiny# is "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_bad_header_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #show_final_bad_header_destiny# is not "D_BOUNCE">
<cfoutput>
<input type="radio" name="final_bad_header_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td id="Cell1089">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><span style="font-size: 12px;"></span><b><span style="font-size: 12px;">Bayes Database <span style="font-size: 10px; font-weight: normal;">(<b><span style="font-size: 12px; color: rgb(255,0,0);">NOTE:</span></b> <span style="font-size: 12px;">Modifying will reset ALL Spam Filter Tests to their DEFAULT values thus erasing any custom values you may have previously set )</span></span></span></b></span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 40px;">
                                                  <td id="Cell912">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table178" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1112">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #use_bayes# is "1">
<cfoutput>
<input type="radio" name="use_bayes" value="1" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_bayes# is not "1">
<cfoutput>
<input type="radio" name="use_bayes" value="1" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1113">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1114">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #use_bayes# is "0">
<cfoutput>
<input type="radio" name="use_bayes" value="0" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #use_bayes# is not "0">
<cfoutput>
<input type="radio" name="use_bayes" value="0" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1115">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      </b></td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1014">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn </b>(Bayes Database must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 40px;">
                                                    <td id="Cell1058">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table179" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1116">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #bayes_auto_learn# is "1">
<cfoutput>
<input type="radio" name="bayes_auto_learn" value="1" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #bayes_auto_learn# is not "1">
<cfoutput>
<input type="radio" name="bayes_auto_learn" value="1" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1117">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1118">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #bayes_auto_learn# is "0">
<cfoutput>
<input type="radio" name="bayes_auto_learn" value="0" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #bayes_auto_learn# is not "0">
<cfoutput>
<input type="radio" name="bayes_auto_learn" value="0" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1119">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1146">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn Spam Threshold Score </b>(Bayes Database Auto Learn must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1147">
                                                      <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject"><cfoutput>
<input type="text" name="bayes_auto_learn_threshold_spam" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="#bayes_auto_learn_threshold_spam#" >
</cfoutput>

                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1148">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn Non-Spam Threshold Score </b>(Bayes Database Auto Learn must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell1149">
                                                      <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject"><cfoutput>
<input type="text" name="bayes_auto_learn_threshold_nonspam" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="#bayes_auto_learn_threshold_nonspam#" >
</cfoutput>

                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1150">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1015">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
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
                              </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="967">
                              <tr valign="top" align="left">
                                <td width="10" height="1"></td>
                                <td></td>
                                <td width="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="30"></td>
                                <td colspan="2" valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="46"></td>
                                <td width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">

<!--- UPDATE AMAVIS CONFIG FILE --->
<cfinclude template="/admin/2/inc/update_amavis_config_files.cfm" />

<!--- UPDATE SPAMASSASSIN CONFIG FILE --->
<cfinclude template="/admin/2/inc/update_amavis_config_files.cfm" />

<!--- RESTART AMAVIS --->
<cfinclude template="/admin/2/inc/restart_amavis.cfm" />

<!--- RESTART SPAMASSASSIN --->
<cfinclude template="/admin/2/inc/restart_spamassassin.cfm" />

<!--- RESTART POSTFIX --->
<cfinclude template="/admin/2/inc/restart_postfix.cfm" />


<!--- /CFIf #action# is --->    
</cfif>


                                  <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 46px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="955">
                                              <form name="apply_settings" action="spam_settings.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="955" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from spam_settings where applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
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
                                              </form>
                                            </td>
                                          </tr>
                                        </table>
                                        <table border="0" cellspacing="0" cellpadding="0" width="955">
                                          <tr valign="top" align="left">
                                            <td width="955" height="5"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="955" id="Text351" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
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
                                <td></td>
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