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
<title>Perimeter Configuration</title>
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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="1446" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1446px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="519">
                              <tr valign="top" align="left">
                                <td width="13" height="12"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Perimeter Checks</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="451">
                              <tr valign="top" align="left">
                                <td width="426" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/perimeter-checks/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="980">
                        <tr valign="top" align="left">
                          <td width="15" height="10"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="1296"></td>
                          <td width="965"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif>

<cfquery name="get_postscreen_pipelining_enable_id" datasource="#datasource#">
select id from parameters where parameter='postscreen_pipelining_enable' and child = '2'
</cfquery>

<cfquery name="get_postscreen_pipelining_enable_children" datasource="#datasource#">
select * from parameters where parent='#get_postscreen_pipelining_enable_id.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="get_postscreen_non_smtp_command_enable_id" datasource="#datasource#">
select id from parameters where parameter='postscreen_non_smtp_command_enable' and child = '2'
</cfquery>

<cfquery name="get_postscreen_non_smtp_command_enable_children" datasource="#datasource#">
select * from parameters where parent='#get_postscreen_non_smtp_command_enable_id.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="get_postscreen_bare_newline_enable_id" datasource="#datasource#">
select id from parameters where parameter='postscreen_bare_newline_enable' and child = '2'
</cfquery>

<cfquery name="get_postscreen_bare_newline_enable_children" datasource="#datasource#">
select * from parameters where parent='#get_postscreen_bare_newline_enable_id.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="get_postscreen_dnsbl_threshold_id" datasource="#datasource#">
select id from parameters where parameter='postscreen_dnsbl_threshold' and child = '2'
</cfquery>

<cfquery name="get_postscreen_dnsbl_threshold_children" datasource="#datasource#">
select * from parameters where parent='#get_postscreen_dnsbl_threshold_id.id#' and child = '1' order by order1 asc
</cfquery> 

<cfquery name="get_message_size_limit_id" datasource="#datasource#">
select id from parameters where parameter='message_size_limit' and child = '2' order by order1 asc
</cfquery>

<cfquery name="get_message_size_limit_children" datasource="#datasource#">
select * from parameters where parent='#get_message_size_limit_id.id#' and child = '1' and enabled='1' order by order1 asc
</cfquery>

<cfquery name="get_smtpd_helo_required_id" datasource="#datasource#">
select id from parameters where parameter='smtpd_helo_required' and child = '2'
</cfquery>

<cfquery name="get_smtpd_helo_required_children" datasource="#datasource#">
select * from parameters where parent='#get_smtpd_helo_required_id.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="get_smtpd_recipient_restrictions_id" datasource="#datasource#">
select id from parameters where parameter='smtpd_recipient_restrictions' and child = '2'
</cfquery>

<cfquery name="get_reject_unauth_destination" datasource="#datasource#">
select * from parameters where parameter='reject_unauth_destination' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_unauth_pipelining" datasource="#datasource#">
select * from parameters where parameter='reject_unauth_pipelining' and child = '1'  and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_invalid_hostname" datasource="#datasource#">
select * from parameters where parameter='reject_invalid_hostname' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_non_fqdn_sender" datasource="#datasource#">
select * from parameters where parameter='reject_non_fqdn_sender' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_unknown_sender_domain" datasource="#datasource#">
select * from parameters where parameter='reject_unknown_sender_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_non_fqdn_recipient" datasource="#datasource#">
select * from parameters where parameter='reject_non_fqdn_recipient' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_reject_unknown_recipient_domain" datasource="#datasource#">
select * from parameters where parameter='reject_unknown_recipient_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>

<cfquery name="get_spf" datasource="#datasource#">
select * from parameters where parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>


<cfparam name = "show_postscreen_pipelining_enable" default = "#get_postscreen_pipelining_enable_children.parameter#"> 
<cfif IsDefined("form.postscreen_pipelining_enable") is "True">
<cfif form.postscreen_pipelining_enable is not "">
<cfset show_postscreen_pipelining_enable = form.postscreen_pipelining_enable>
</cfif></cfif> 

<cfparam name = "show_postscreen_non_smtp_command_enable" default = "#get_postscreen_non_smtp_command_enable_children.parameter#"> 
<cfif IsDefined("form.postscreen_non_smtp_command_enable") is "True">
<cfif form.postscreen_non_smtp_command_enable is not "">
<cfset show_postscreen_non_smtp_command_enable = form.postscreen_non_smtp_command_enable>
</cfif></cfif> 


<cfparam name = "show_postscreen_bare_newline_enable" default = "#get_postscreen_bare_newline_enable_children.parameter#"> 
<cfif IsDefined("form.postscreen_bare_newline_enable") is "True">
<cfif form.postscreen_bare_newline_enable is not "">
<cfset show_postscreen_bare_newline_enable = form.postscreen_bare_newline_enable>
</cfif></cfif> 

<cfparam name = "show_smtpd_helo_required" default = "#get_smtpd_helo_required_children.enabled#"> 
<cfif IsDefined("form.smtpd_helo_required") is "True">
<cfif form.smtpd_helo_required is not "">
<cfset show_smtpd_helo_required = form.smtpd_helo_required>
</cfif></cfif> 

<cfparam name = "show_reject_unauth_destination" default = "#get_reject_unauth_destination.enabled#"> 
<cfif IsDefined("form.reject_unauth_destination") is "True">
<cfif form.reject_unauth_destination is not "">
<cfset show_reject_unauth_destination = form.reject_unauth_destination>
</cfif></cfif> 

<cfparam name = "show_reject_unauth_pipelining" default = "#get_reject_unauth_pipelining.enabled#"> 
<cfif IsDefined("form.reject_unauth_pipelining") is "True">
<cfif form.reject_unauth_pipelining is not "">
<cfset show_reject_unauth_pipelining = form.reject_unauth_pipelining>
</cfif></cfif> 

<cfparam name = "show_reject_invalid_hostname" default = "#get_reject_invalid_hostname.enabled#"> 
<cfif IsDefined("form.reject_invalid_hostname") is "True">
<cfif form.reject_invalid_hostname is not "">
<cfset show_reject_invalid_hostname = form.reject_invalid_hostname>
</cfif></cfif> 

<cfparam name = "show_reject_non_fqdn_sender" default = "#get_reject_non_fqdn_sender.enabled#"> 
<cfif IsDefined("form.reject_non_fqdn_sender") is "True">
<cfif form.reject_non_fqdn_sender is not "">
<cfset show_reject_non_fqdn_sender = form.reject_non_fqdn_sender>
</cfif></cfif> 

<cfparam name = "show_reject_unknown_sender_domain" default = "#get_reject_unknown_sender_domain.enabled#"> 
<cfif IsDefined("form.reject_unknown_sender_domain") is "True">
<cfif form.reject_unknown_sender_domain is not "">
<cfset show_reject_unknown_sender_domain = form.reject_unknown_sender_domain>
</cfif></cfif> 

<cfparam name = "show_reject_non_fqdn_recipient" default = "#get_reject_non_fqdn_recipient.enabled#"> 
<cfif IsDefined("form.reject_non_fqdn_recipient") is "True">
<cfif form.reject_non_fqdn_recipient is not "">
<cfset show_reject_non_fqdn_recipient = form.reject_non_fqdn_recipient>
</cfif></cfif> 


<cfparam name = "show_reject_unknown_recipient_domain" default = "#get_reject_unknown_recipient_domain.enabled#"> 
<cfif IsDefined("form.reject_unknown_recipient_domain") is "True">
<cfif form.reject_unknown_recipient_domain is not "">
<cfset show_reject_unknown_recipient_domain = form.reject_unknown_recipient_domain>
</cfif></cfif> 

<cfparam name = "show_spf" default = "#get_spf.enabled#"> 
<cfif IsDefined("form.spf") is "True">
<cfif form.spf is not "">
<cfset show_spf = form.spf>
</cfif></cfif> 

<cfparam name = "show_postscreen_dnsbl_threshold" default = "#get_postscreen_dnsbl_threshold_children.parameter#"> 
<cfif IsDefined("form.postscreen_dnsbl_threshold") is "True">
<cfif form.postscreen_dnsbl_threshold is not "">
<cfset show_postscreen_dnsbl_threshold = form.postscreen_dnsbl_threshold>
</cfif></cfif>

<cfset message_size1=#get_message_size_limit_children.parameter#/1024>
<cfset message_size2=#message_size1#/1024>
<cfparam name = "show_message_size_limit" default = "#message_size2#"> 
<cfif IsDefined("form.message_size_limit") is "True">
<cfif form.message_size_limit is not "">
<cfset show_message_size_limit = form.message_size_limit>
</cfif></cfif>  


<cfif #show_action# is "edit">

<cfif #show_postscreen_dnsbl_threshold# is not "">
<cfif IsValid("integer", show_postscreen_dnsbl_threshold)>
<cfquery name="show_postscreen_dnsbl" datasource="#datasource#">
update parameters set 
parameter='#show_postscreen_dnsbl_threshold#'
where
parent='#get_postscreen_dnsbl_threshold_id.id#' and child = '1' and enabled='1'
</cfquery>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m=2>
</cfif>
<cfelseif #show_postscreen_dnsbl_threshold# is "">>
<cfset step=0>
<cfset m=2>
</cfif>

<cfif #step# is "2">
<cfif IsValid("float", show_message_size_limit)>
<cfif #show_message_size_limit# GT 0>
<cfset message_size_limit1=#show_message_size_limit#*1024>
<cfset message_size_limit2=#message_size_limit1#*1024>
<cfquery name="message_size_limit" datasource="#datasource#">
update parameters set 
parameter='#message_size_limit2#'
where
parent='#get_message_size_limit_id.id#' and child = '1' and enabled='1'
</cfquery>
<cfset step=3>
<cfelseif #show_message_size_limit# LTE 0>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif NOT IsValid("float", show_message_size_limit)>
<cfset step=0>
<cfset m=1>
</cfif>
</cfif>






<cfif #step# is "3">

<cfif #show_postscreen_pipelining_enable# is "yes">
<cfquery name="postscreen_pipelining_enable" datasource="#datasource#">
update parameters set 
parameter='yes',
applied='2'
where
parent='#get_postscreen_pipelining_enable_id.id#' and child = '1'
</cfquery>

<cfelseif #show_postscreen_pipelining_enable# is "no">
<cfquery name="postscreen_pipelining_enable" datasource="#datasource#">
update parameters set 
parameter='no',
applied='2'
where
parent='#get_postscreen_pipelining_enable_id.id#' and child = '1'
</cfquery>
</cfif>

<cfif #show_postscreen_non_smtp_command_enable# is "yes">
<cfquery name="postscreen_non_smtp_command_enable" datasource="#datasource#">
update parameters set 
parameter='yes',
applied='2'
where
parent='#get_postscreen_non_smtp_command_enable_id.id#' and child = '1'
</cfquery>

<cfelseif #show_postscreen_non_smtp_command_enable# is "no">
<cfquery name="postscreen_non_smtp_command_enable" datasource="#datasource#">
update parameters set 
parameter='no',
applied='2'
where
parent='#get_postscreen_non_smtp_command_enable_id.id#' and child = '1'
</cfquery>
</cfif>

<cfif #show_postscreen_bare_newline_enable# is "yes">
<cfquery name="postscreen_bare_newline_enable" datasource="#datasource#">
update parameters set 
parameter='yes',
applied='2'
where
parent='#get_postscreen_bare_newline_enable_id.id#' and child = '1'
</cfquery>

<cfelseif #show_postscreen_bare_newline_enable# is "no">
<cfquery name="postscreen_bare_newline_enable" datasource="#datasource#">
update parameters set 
parameter='no',
applied='2'
where
parent='#get_postscreen_bare_newline_enable_id.id#' and child = '1'
</cfquery>
</cfif>


<cfif #show_smtpd_helo_required# is "1">
<cfquery name="smtpd_helo_required" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parent='#get_smtpd_helo_required_id.id#' and child = '1'
</cfquery>
<cfelseif #show_smtpd_helo_required# is not "1">
<cfquery name="smtpd_helo_required" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parent='#get_smtpd_helo_required_id.id#' and child = '1'
</cfquery>
</cfif>


<cfif #show_reject_unauth_destination# is "1">
<cfquery name="reject_unauth_destination" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unauth_destination' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_unauth_destination# is not "1">
<cfquery name="reject_unauth_destination" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unauth_destination' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_unauth_pipelining# is "1">
<cfquery name="reject_unauth_pipelining" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unauth_pipelining' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_unauth_pipelining# is not "1">
<cfquery name="reject_unauth_pipelining" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unauth_pipelining' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_invalid_hostname# is "1">
<cfquery name="reject_invalid_hostname" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_invalid_hostname' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_invalid_hostname# is not "1">
<cfquery name="reject_invalid_hostname" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_invalid_hostname' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_non_fqdn_sender# is "1">
<cfquery name="reject_non_fqdn_sender" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_non_fqdn_sender' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_non_fqdn_sender# is not "1">
<cfquery name="reject_non_fqdn_sender" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_non_fqdn_sender' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_unknown_sender_domain# is "1">
<cfquery name="reject_unknown_sender_domainr" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unknown_sender_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_unknown_sender_domain# is not "1">
<cfquery name="reject_unknown_sender_domain" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unknown_sender_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_non_fqdn_recipient# is "1">
<cfquery name="reject_non_fqdn_recipient" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_non_fqdn_recipient' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_non_fqdn_recipient# is not "1">
<cfquery name="reject_non_fqdn_recipient" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_non_fqdn_recipient' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_reject_unknown_recipient_domain# is "1">
<cfquery name="reject_unknown_recipient_domain" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unknown_recipient_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_reject_unknown_recipient_domain# is not "1">
<cfquery name="reject_unknown_recipient_domain" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unknown_recipient_domain' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>

<cfif #show_spf# is "1">
<cfquery name="spf" datasource="#datasource#">
update parameters set 
enabled='1',
applied='2'
where
parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
<cfelseif #show_spf# is not "1">
<cfquery name="spf" datasource="#datasource#">
update parameters set 
enabled='2',
applied='2'
where
parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='#get_smtpd_recipient_restrictions_id.id#'
</cfquery>
</cfif>
<cfset m=3>

</cfif>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="965" id="LayoutRegion11" style="height: 1296px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 1227px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1043">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Initital Connection Deep Protocol Tests</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 56px;">
                                              <td id="Cell563">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">The following three settings comprise the Initital Connection Deep Protocl Tests. If they are all enabled they are very useful in refusing SMTP connections by zombie senders by performing a series of tests before the sender is allowed to talk to the SMTP service. However, this setting introduces a delay (graylisting) in e-mail delivery and certain legitimate but <b><u>incorrectly configured</u></b> e-mail servers do not try to reconnect to deliver their email.. If you have problems receiving emails from legitimate servers, disable <b>ALL three settings</b> below.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1047">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1044">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Pipelining Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1042">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table163" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1021">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_pipelining_enable# is "yes">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_pipelining_enable" value="yes" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_pipelining_enable# is not "yes">
<cfoutput>
<input type="radio" name="postscreen_pipelining_enable" value="yes" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1023">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_pipelining_enable# is "no">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_pipelining_enable" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_pipelining_enable# is not "no">
<cfoutput>
<input type="radio" name="postscreen_pipelining_enable" value="no" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1045">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Non SMTP Commands Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1041">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table164" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1027">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_non_smtp_command_enable# is "yes">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_non_smtp_command_enable" value="yes" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_non_smtp_command_enable# is not "yes">
<cfoutput>
<input type="radio" name="postscreen_non_smtp_command_enable" value="yes" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_non_smtp_command_enable# is "no">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_non_smtp_command_enable" value="no" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_non_smtp_command_enable# is not "no">
<cfoutput>
<input type="radio" name="postscreen_non_smtp_command_enable" value="no" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1040">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Bare New Line Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1039">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1034">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_bare_newline_enable# is "yes">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_bare_newline_enable" value="yes" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_bare_newline_enable# is not "yes">
<cfoutput>
<input type="radio" name="postscreen_bare_newline_enable" value="yes" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1036">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_postscreen_bare_newline_enable# is "no">
<cfoutput>
<input type="radio" checked="checked" name="postscreen_bare_newline_enable" value="no" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_postscreen_bare_newline_enable# is not "no">
<cfoutput>
<input type="radio" name="postscreen_bare_newline_enable" value="no" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1046">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1038">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Require HELO</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell564">
                                                <table width="958" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting requires for the incoming email system to start the SMTP session by first sending the HELO or EHLO command before sending the MAIL FROM or ETRN command. Set this setting to Disabled if it starts creating problems with certain homegrown email systems. Otherwise, it is recommended to be set to Enabled.</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell565">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell604">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_smtpd_helo_required# is "1">
<cfoutput>
<input type="radio" checked="checked" name="smtpd_helo_required" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_smtpd_helo_required# is not "1">
<cfoutput>
<input type="radio" name="smtpd_helo_required" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell605">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell606">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_smtpd_helo_required# is "2">
<cfoutput>
<input type="radio" checked="checked" name="smtpd_helo_required" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_smtpd_helo_required# is not "2">
<cfoutput>
<input type="radio" name="smtpd_helo_required" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell607">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell566">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell609">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Unauthorized Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell610">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email that is destined for a recipient domain or subdomain thereof&nbsp; that the system does not handle i.e. any domain that is not listed in the Relay Domains (See General Options Above). It is recommended that this settings is set to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell611">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table107" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell612">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unauth_destination# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_unauth_destination" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unauth_destination# is not "1">
<cfoutput>
<input type="radio" name="reject_unauth_destination" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="542" id="Cell613">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell614">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unauth_destination# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_unauth_destination" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unauth_destination# is not "2">
<cfoutput>
<input type="radio" name="reject_unauth_destination" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell615">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell608">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell749">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Sender Policy Framework (SPF) Checks</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell752">
                                                <table width="951" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enable/Disable SPF checks on the system. When enabled the system will attempt to identify email spam by detecting whether or not the email is spoofed by verifying that the sender IP address is authorized to send email on behalf of the senders domain.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell751">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table103" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="49" id="Cell579">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_spf# is "1">
<cfoutput>
<input type="radio" checked="checked" name="spf" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_spf# is not "1">
<cfoutput>
<input type="radio" name="spf" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="546" id="Cell580">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell581">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_spf# is "2">
<cfoutput>
<input type="radio" checked="checked" name="spf" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_spf# is not "2">
<cfoutput>
<input type="radio" name="spf" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell582">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell750">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell617">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid HELO Hostname</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell618">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server that sends the HELO or EHLO command along with a malformed hostname. It is recommended that this settings is set to Enabled. For best effect of this setting, ensure the Required HELO setting above is also set to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell616">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table108" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell619">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_invalid_hostname# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_invalid_hostname" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_invalid_hostname# is not "1">
<cfoutput>
<input type="radio" name="reject_invalid_hostname" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="540" id="Cell620">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell621">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_invalid_hostname# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_invalid_hostname" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_invalid_hostname# is not "2">
<cfoutput>
<input type="radio" name="reject_invalid_hostname" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell622">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell623">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell625">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Pipelining</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell626">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server that sends SMTP commands where it is not allowed or without waiting for confirmation that the system supports ESMTP commands. This is used by spammers in order to try to speed up delivery of spam email. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell624">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table109" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell627">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unauth_pipelining# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_unauth_pipelining" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unauth_pipelining# is not "1">
<cfoutput>
<input type="radio" name="reject_unauth_pipelining" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="542" id="Cell628">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell629">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unauth_pipelining# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_unauth_pipelining" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unauth_pipelining# is not "2">
<cfoutput>
<input type="radio" name="reject_unauth_pipelining" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell630">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell631">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell633">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Non-FQDN Sender Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell634">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server without a FQDN (Fully Qualified Domain Name). Example of a Non-FQDN domain would be: domain.local. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell632">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table110" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell635">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_non_fqdn_sender# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_non_fqdn_sender" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_non_fqdn_sender# is not "1">
<cfoutput>
<input type="radio" name="reject_non_fqdn_sender" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="542" id="Cell636">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell637">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_non_fqdn_sender# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_non_fqdn_sender" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_non_fqdn_sender# is not "2">
<cfoutput>
<input type="radio" name="reject_non_fqdn_sender" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell638">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell639">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell641">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid Sender Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell642">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server whose domain as sent in the MAIL FROM command during the SMTP session does not have a DNS A or MX record or has an invalid MX record. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell640">
                                                <table width="598" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table112" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell647">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unknown_sender_domain# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_unknown_sender_domain" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unknown_sender_domain# is not "1">
<cfoutput>
<input type="radio" name="reject_unknown_sender_domain" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="543" id="Cell648">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell649">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unknown_sender_domain# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_unknown_sender_domain" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unknown_sender_domain# is not "2">
<cfoutput>
<input type="radio" name="reject_unknown_sender_domain" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell650">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell653">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Non-FQDN Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell654">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email destined for a recipient without a FQDN (Fully Qualified Domain Name) as sent in the RCPT TO command of the SMTP session. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell655">
                                                <table width="598" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table113" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell656">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_non_fqdn_recipient# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_non_fqdn_recipient" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_non_fqdn_recipient# is not "1">
<cfoutput>
<input type="radio" name="reject_non_fqdn_recipient" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="543" id="Cell657">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell658">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_non_fqdn_recipient# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_non_fqdn_recipient" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_non_fqdn_recipient# is not "2">
<cfoutput>
<input type="radio" name="reject_non_fqdn_recipient" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell659">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell652">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell661">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid Recipient Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell662">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email where this system is not the final destination and the email is destined for a recipient domain as specified in the RCPT TO command of the SMTP session that does not have a DNS A or MX Record or an invalid MX record. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell660">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table114" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell663">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unknown_recipient_domain# is "1">
<cfoutput>
<input type="radio" checked="checked" name="reject_unknown_recipient_domain" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unknown_recipient_domain# is not "1">
<cfoutput>
<input type="radio" name="reject_unknown_recipient_domain" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell664">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell665">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_reject_unknown_recipient_domain# is "2">
<cfoutput>
<input type="radio" checked="checked" name="reject_unknown_recipient_domain" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_reject_unknown_recipient_domain# is not "2">
<cfoutput>
<input type="radio" name="reject_unknown_recipient_domain" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell666">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell756">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Realtime Block/Allow Lists Threshold Score</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell757">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">This is the score required for&nbsp; the system to block an incoming mail server&#8217;s IP address that has been listed on Real Time Block/Allow List(s). The final outcome of combining the weights of the Real Time Block/Allow Lists must be <b>less</b> than the number specified below in order for the incoming mail server to be allowed to deliver mail to this system. </span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell876">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField39" name="postscreen_dnsbl_threshold" size="30" maxlength="3" style="width: 236px; white-space: pre;" value="#show_postscreen_dnsbl_threshold#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell877">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell878">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Message Size Limit</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell879">
                                                <table width="952" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter the maximum message size in MB (Megabytes)&nbsp; to be processed by the system. Please note, the larger the limit the more memory required by the system to process the e-mail. Extremely large message sizes can crash the system. Recommended size is 20 MB or lower.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell880">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField38" name="message_size_limit" size="30" maxlength="3" style="width: 236px; white-space: pre;" value="#show_message_size_limit#"></cfoutput></td>
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
                                        <td height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="965">
                                      <tr valign="top" align="left">
                                        <td width="965" height="12"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="965" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Message Size Limit</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid RBL Block Score</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Message Size Limit must be greater than 0</span></i></b></p>
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
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="15" height="4"></td>
                          <td></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="957"><hr id="HRRule3" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

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
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cfoutput query="getcommand">

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "#command#"
addnewline="no">

</cfoutput>

<cfquery name="deletecommand" datasource="#datasource#">
delete from command where trans_id = '#customtrans3#'
</cfquery>

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/usr/sbin/postfix reload#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /var/www/tasks/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/var/www/tasks/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/var/www/tasks/#customtrans3#_apply.sh">    

<cfquery name="updateparams" datasource="#datasource#">
update parameters set applied='1' where applied = '2'
</cfquery>
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="perimeter_configuration.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters where module='postfix' and applied='2'
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
                                      <td width="8" height="4"></td>
                                      <td width="947"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="947" id="Text351" class="TextObject">
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