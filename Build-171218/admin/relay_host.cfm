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
<title>Relay Host</title>
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
              <td height="763" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 763px;">
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
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Relay Host Configuration</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/relay-host/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="10" height="3"></td>
                          <td width="961"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="961" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">By default, the system tries to deliver mail directly to the Internet. Depending on your configuration this may not be possible. For example, your system may be behind a firewall, or it may be connected via an ISP who does not allow outbound mail to the Internet. In those cases you need to configure the system to deliver mail&nbsp; via a Relay Host.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td colspan="5" width="959"><cfparam name = "m" default = "0"> 
<cfparam name = "m2" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfset show_action = form.action>
</cfif>

<cfquery name="get_relayhost_id" datasource="#datasource#">
select id from parameters where parameter='relayhost' and child = '2'
</cfquery>

<cfquery name="get_relayhost" datasource="#datasource#">
select name, parameter from parameters where parent='#get_relayhost_id.id#' and child = '1'
</cfquery>

<cfif #get_relayhost.parameter# is "">
<cfset relayhost_enabled=2>
<cfelseif #get_relayhost.parameter# is not "">
<cfset relayhost_enabled=1>
</cfif>

<cfparam name = "show_relay_enabled" default = "#relayhost_enabled#"> 
<cfif IsDefined("form.relay_enabled") is "True">
<cfset show_relay_enabled = form.relay_enabled>
</cfif>

<cfparam name = "show_relayhost" default = "#get_relayhost.name#"> 
<cfif IsDefined("form.relayhost") is "True">
<cfset show_relayhost = form.relayhost>
</cfif>

<cfquery name="get_smtp_sasl_auth_enable" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_auth_enable' and child = '2'
</cfquery>

<cfquery name="get_smtp_sasl_auth_enable_parameter" datasource="#datasource#">
select parameter from parameters where parent='#get_smtp_sasl_auth_enable.id#' and child = '1'
</cfquery>

<cfif #get_smtp_sasl_auth_enable_parameter.parameter# is "no">
<cfset relayhost_authenticate=2>
<cfelseif #get_smtp_sasl_auth_enable_parameter.parameter# is "yes">
<cfset relayhost_authenticate=1>
</cfif>

<cfparam name = "show_relay_authenticate" default = "#relayhost_authenticate#"> 
<cfif IsDefined("form.relay_authenticate") is "True">
<cfif #form.relay_authenticate# is not "">
<cfset show_relay_authenticate = form.relay_authenticate>
</cfif>
</cfif>

<cfif #get_relayhost.name# is not "">
<cfset thePort = #trim(ListGetAt(get_relayhost.parameter, 2, ":"))#>
<cfelseif #get_relayhost.name# is "">
<cfset thePort = 25>
</cfif>

<cfparam name = "show_relayhost_port" default = "#thePort#"> 
<cfif IsDefined("form.relayhost_port") is "True">
<cfif #form.relayhost_port# is not "">
<cfset show_relayhost_port = form.relayhost_port>
</cfif>
</cfif>

<cfquery name="get_relayhost_username_password" datasource="#datasource#">
select name from parameters where parameter='smtp_sasl_password_maps' and child = '2'
</cfquery>

<cfif #get_relayhost_username_password.name# is not "">
<cfset relay_password = listGetAt(get_relayhost_username_password.name, 2, ":")>
<cfset relay_username = listGetAt(get_relayhost_username_password.name, 1, ":")>
<cfelseif #get_relayhost_username_password.name# is "">
<cfset relay_password = "">
<cfset relay_username = "">
</cfif>


<cfparam name = "show_relayhost_username" default = "#relay_username#"> 
<cfif IsDefined("form.relayhost_username") is "True">
<cfif #form.relayhost_username# is not "">
<cfset show_relayhost_username = form.relayhost_username>
</cfif>
</cfif>

<cfparam name = "show_relayhost_password" default = "#relay_password#"> 
<cfif IsDefined("form.relayhost_password") is "True">
<cfif #form.relayhost_password# is not "">
<cfset show_relayhost_password = form.relayhost_password>
</cfif>
</cfif>

<cfif #action# is "edit">
<cfif #show_relay_enabled# is "1">
<cfif #show_relay_authenticate# is "1">

<cfif #show_relayhost# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_relayhost# is not "">
<cfset temp_email="bob@#show_relayhost#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif #step# is "1">
<cfif #show_relayhost_port# is "">
<cfset step=0>
<cfset m=3>
<cfelseif #show_relayhost_port# is not "">
<cfif IsValid("integer", show_relayhost_port)>
<cfif #show_relayhost_port# LTE 65535 and #show_relayhost_port# GTE 1>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif not IsValid("integer", show_relayhost_port)>
<cfset step=0>
<cfset m=5>
</cfif>
</cfif>
</cfif>

<cfif #step# is "2">
<cfif #show_relayhost_username# is "">
<cfset step=0>
<cfset m=8>
<cfelseif #show_relayhost_username# is not "">
<cfset step=3>
</cfif>
</cfif>

<cfif #step# is "3">
<cfif #show_relayhost_password# is "">
<cfset step=0>
<cfset m=6>
<cfelseif #show_relayhost_password# is not "">
<cfset step=4>
</cfif>
</cfif>

<cfif #step# is "4">

<cfquery name="updaterelayhost" datasource="#datasource#">
update parameters 
set 
parameter='[#show_relayhost#]:#show_relayhost_port#',
name='#show_relayhost#',
applied='2'
where parent='#get_relayhost_id.id#' 
and child='1' 
</cfquery>

<cfquery name="get_smtp_sasl_auth_enable" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_auth_enable' and child = '2'
</cfquery>

<cfquery name="enableauth" datasource="#datasource#">
update parameters 
set 
parameter='yes',
applied='2'
where parent='#get_smtp_sasl_auth_enable.id#'
and child='1'
</cfquery>

<cfquery name="get_smtp_sasl_password_maps" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_password_maps' and child = '2'
</cfquery>

<cfquery name="updateuserpass" datasource="#datasource#">
update parameters 
set 
name='#show_relayhost_username#:#show_relayhost_password#',
applied='2'
where id='#get_smtp_sasl_password_maps.id#'
</cfquery>

<cfset m=7>

</cfif>


<cfelseif #show_relay_authenticate# is "2">

<cfif #show_relayhost# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_relayhost# is not "">
<cfset temp_email="bob@#show_relayhost#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif #step# is "1">
<cfif #show_relayhost_port# is "">
<cfset step=0>
<cfset m=3>
<cfelseif #show_relayhost_port# is not "">
<cfif IsValid("integer", show_relayhost_port)>
<cfif #show_relayhost_port# LTE 65535 and #show_relayhost_port# GTE 1>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif not IsValid("integer", show_relayhost_port)>
<cfset step=0>
<cfset m=5>
</cfif>
</cfif>
</cfif>

<cfif #step# is "2">

<cfquery name="updaterelayhost" datasource="#datasource#">
update parameters 
set 
parameter='[#show_relayhost#]:#show_relayhost_port#',
name='#show_relayhost#',
applied='2'
where parent='#get_relayhost_id.id#' 
and child='1' 
</cfquery>

<cfquery name="get_smtp_sasl_auth_enable" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_auth_enable' and child = '2'
</cfquery>

<cfquery name="disableauth" datasource="#datasource#">
update parameters 
set 
parameter='no',
applied='2'
where parent='#get_smtp_sasl_auth_enable.id#'
and child='1'
</cfquery>

<cfquery name="get_smtp_sasl_password_maps" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_password_maps' and child = '2'
</cfquery>

<cfquery name="updateuserpass" datasource="#datasource#">
update parameters 
set 
name='',
applied='2'
where id='#get_smtp_sasl_password_maps.id#'
</cfquery>

<cfset m=7>
</cfif>
</cfif>

<cfelseif #show_relay_enabled# is "2">

<cfquery name="updaterelayhost" datasource="#datasource#">
update parameters 
set 
parameter='',
name='',
applied='2'
where parent='#get_relayhost_id.id#' 
and child='1' 
</cfquery>

<cfquery name="get_smtp_sasl_auth_enable" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_auth_enable' and child = '2'
</cfquery>

<cfquery name="disableauth" datasource="#datasource#">
update parameters 
set 
parameter='no',
applied='2'
where parent='#get_smtp_sasl_auth_enable.id#'
and child='1'
</cfquery>

<cfquery name="get_smtp_sasl_password_maps" datasource="#datasource#">
select id from parameters where parameter='smtp_sasl_password_maps' and child = '2'
</cfquery>

<cfquery name="updateuserpass" datasource="#datasource#">
update parameters 
set 
name='',
applied='2'
where id='#get_smtp_sasl_password_maps.id#'
</cfquery>

<cfset m=7>
</cfif>

</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion19" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="959">
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">
<cfoutput>
<input type="radio" name="relay_enabled" value="1" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_relay_enabled# is not "1">
<cfoutput>
<input type="radio" name="relay_enabled" value="1" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Relay Host Enabled</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "2">
<cfoutput>
<input type="radio" name="relay_enabled" value="2" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_relay_enabled# is not "2">
<cfoutput>
<input type="radio" name="relay_enabled" value="2" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Relay Host Disabled</b> (Default)</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td width="351"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" colspan="2" valign="middle" width="959"><hr id="HRRule1" width="959" size="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table168" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form action="relay_host.cfm" method="post">
                                                  <td width="58" id="Cell1053">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">
<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="radio" name="relay_authenticate" value="1" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="#show_relay_enabled#"/>
</cfoutput>
<cfelseif #show_relay_authenticate# is not "1">
<cfoutput>
<input type="radio" name="relay_authenticate" value="1" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="#show_relay_enabled#"/>
</cfoutput>
</cfif>

<cfelseif #show_relay_enabled# is "2">
<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="radio" name="relay_authenticate" value="1" checked="checked" style="height: 19px; width: 19px;" disabled="disabled"/>
</cfoutput>
<cfelseif #show_relay_authenticate# is not "1">
<cfoutput>
<input type="radio" name="relay_authenticate" value="1" style="height: 19px; width: 19px;" disabled="disabled"/>
</cfoutput>
</cfif>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell1054">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Relay Host Authentication Required</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="relay_host.cfm" method="post">
                                                  <td id="Cell1055">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">
<cfif #show_relay_authenticate# is "2">
<cfoutput>
<input type="radio" name="relay_authenticate" value="2" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="#show_relay_enabled#"/>
</cfoutput>
<cfelseif #show_relay_authenticate# is not "2">
<cfoutput>
<input type="radio" name="relay_authenticate" value="2" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="#show_relay_enabled#"/>
</cfoutput>
</cfif>

<cfelseif #show_relay_enabled# is "2">
<cfif #show_relay_authenticate# is "2">
<cfoutput>
<input type="radio" name="relay_authenticate" value="2" checked="checked" style="height: 19px; width: 19px;" disabled="disabled"/>
</cfoutput>
<cfelseif #show_relay_authenticate# is not "2">
<cfoutput>
<input type="radio" name="relay_authenticate" value="2" style="height: 19px; width: 19px;" disabled="disabled"/>
</cfoutput>
</cfif>
</cfif>

&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell1056">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Relay Host Authentication NOT Required</b> (Default)</span></p>
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
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="956"><hr id="HRRule3" width="956" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="204"></td>
                          <td colspan="3" width="957">

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 204px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="relay_host.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="relay_enabled" value="<cfoutput>#show_relay_enabled#</cfoutput>"><input type="hidden" name="relay_authenticate" value="<cfoutput>#show_relay_authenticate#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 178px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Host FQDN</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject"><cfif #show_relay_enabled# is "1">
<cfoutput>
<input type="text" name="relayhost" size="50" maxlength="40" style="width: 396px; white-space: pre;" value="#show_relayhost#" >
</cfoutput>
<cfelseif #show_relay_enabled# is "2">
<cfoutput>
<input type="text" name="relayhost" size="50" maxlength="40" style="width: 396px; white-space: pre;" value="#show_relayhost#" disabled="disabled">
</cfoutput>
</cfif>
                                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Host Port Number <span style="font-weight: normal;">(Defaut is 25. Change only if Relay Host requires different port number)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell1047">
                                                  <table width="80" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">
                                                        <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">
<cfoutput>
<input type="text" id="FormsEditField59" name="relayhost_port" size="10" maxlength="5" style="width: 76px; white-space: pre;" value="#show_relayhost_port#">
</cfoutput>
<cfelseif #show_relay_enabled# is "2">
<cfoutput>
<input type="text" id="FormsEditField59" name="relayhost_port" size="10" maxlength="5" style="width: 76px; white-space: pre;" value="#show_relayhost_port#" disabled="disabled">
</cfoutput>
</cfif>&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Username <span style="font-weight: normal;">(Required only if Relay Host Requires Authentication)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="321" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">

<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="text" id="FormsEditField42" name="relayhost_username" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_relayhost_username#">
</cfoutput>
<cfelseif #show_relay_authenticate# is "2">
<cfoutput>
<input type="text" id="FormsEditField42" name="relayhost_username" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_relayhost_username#" disabled="disabled">
</cfoutput>
</cfif>
<cfelseif #show_relay_enabled# is "2">
<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="text" id="FormsEditField42" name="relayhost_username" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_relayhost_username#" disabled="disabled">
</cfoutput>
<cfelseif #show_relay_authenticate# is "2">
<cfoutput>
<input type="text" id="FormsEditField42" name="relayhost_username" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_relayhost_username#" disabled="disabled">
</cfoutput>
</cfif>
</cfif>&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Password <span style="font-weight: normal;">(Required only if Relay Host Requires Authentication)</span></span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell912">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="321" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_relay_enabled# is "1">
<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="password" id="FormsEditField61" name="relayhost_password" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_relayhost_password#">
</cfoutput>
<cfelseif #show_relay_authenticate# is "2">
<cfoutput>
<input type="password" id="FormsEditField61" name="relayhost_password" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_relayhost_password#" disabled="disabled">
</cfoutput>
</cfif>

<cfelseif #show_relay_enabled# is "2">
<cfif #show_relay_authenticate# is "1">
<cfoutput>
<input type="password" id="FormsEditField61" name="relayhost_password" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_relayhost_password#" disabled="disabled">
</cfoutput>
<cfelseif #show_relay_authenticate# is "2">
<cfoutput>
<input type="password" id="FormsEditField61" name="relayhost_password" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_relayhost_password#" disabled="disabled">
</cfoutput>
</cfif>
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      </b></td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1014">
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
                                          <table border="0" cellspacing="0" cellpadding="0" width="957">
                                            <tr valign="top" align="left">
                                              <td width="957" height="9"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957" id="Text185" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host FQDN cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host FQDN must be a valid FQDN host name</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Relay Host Port Number cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host Port Number must be a valid number between 1 and 65535</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host Port Number must be a valid number between 1 and 65535</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;if the Relay Host Authentication Required is checked, you must also specifiy a Relay Host Password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;if the Relay Host Authentication Required is checked, you must also specifiy a Relay Host Username</span></i></b></p>
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
                                <td colspan="6" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="30"></td>
                                <td valign="middle" width="955"><hr id="HRRule4" width="955" size="1"></td>
                                <td colspan="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="63"></td>
                                <td colspan="4" width="958"><cfparam name = "show_action2" default = "view"> 
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

<cfquery name="check_smtp_sasl_auth_enable" datasource="#datasource#">
select id, parameter from parameters where parameter='smtp_sasl_auth_enable'
</cfquery>

<cfquery name="check_smtp_sasl_auth_parameter" datasource="#datasource#">
select parameter from parameters where parent='#check_smtp_sasl_auth_enable.id#'
</cfquery>

<cfif #check_smtp_sasl_auth_parameter.parameter# is "yes">

<cfquery name="get_smtp_sasl_password_maps" datasource="#datasource#">
select name from parameters where parameter='smtp_sasl_password_maps'
</cfquery>

<cfset relay_password = listGetAt(get_smtp_sasl_password_maps.name, 2, ":")>
<cfset relay_username = listGetAt(get_smtp_sasl_password_maps.name, 1, ":")>

<cffile action="read" file="/opt/hermes/conf_files/relay_passwd.HERMES" variable="relaypass">


<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#relay_passwd.HERMES"
    output = "#REReplace("#relaypass#","HOST-NAME","#show_relayhost#","ALL")#">




<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#relay_passwd.HERMES" variable="relaypass">



<cffile action = "write"
    file = "/opt/hermes/conf_files/#customtrans3#relay_passwd.HERMES"
    output = "#REReplace("#relaypass#","USER-NAME","#relay_username#","ALL")#">


<cffile action="read" file="/opt/hermes/conf_files/#customtrans3#relay_passwd.HERMES" variable="relaypass">



<cffile action = "write"
    file = "/etc/postfix/relay_passwd"
    output = "#REReplace("#relaypass#","PASS-WORD","#relay_password#","ALL")#">

<cffile
    action = "delete"
    file = "/opt/hermes/conf_files/#customtrans3#relay_passwd.HERMES">


</cfif> 



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


                                  <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion13" style="height: 63px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td height="9"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="958">
                                              <form name="apply_settings" action="relay_host.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="958" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="958">
                                          <tr valign="top" align="left">
                                            <td width="958" height="6"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="958" id="Text351" class="TextObject">
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