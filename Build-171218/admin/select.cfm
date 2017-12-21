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
<title>Relay IPs and Networks</title>
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
              <td height="802" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion25" style="background-image: url('./middle_988.png'); height: 802px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="521">
                              <tr valign="top" align="left">
                                <td width="15" height="11"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Relay IPs/Networks</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text482" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Relay IPs/Networks</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="449">
                              <tr valign="top" align="left">
                                <td width="424" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/relay-ips-networks/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td width="2"></td>
                          <td width="956"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="245"></td>
                          <td colspan="2" rowspan="2" width="958"><script>

/*
Auto tabbing script- By JavaScriptKit.com
http://www.javascriptkit.com
This credit MUST stay intact for use
*/

function autotab(original,destination){
if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
destination.focus()
}

</script>

<cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "show_type" default = "ip"> 
<cfif IsDefined("url.type") is "True">
<cfif url.type is not "">
<cfset show_type = url.type>
</cfif></cfif> 

<cfparam name = "octet1" default = ""> 
<cfif IsDefined("form.octet1") is "True">
<cfif form.octet1 is not "">
<cfset octet1 = form.octet1>
</cfif></cfif> 

<cfparam name = "octet2" default = ""> 
<cfif IsDefined("form.octet2") is "True">
<cfif form.octet2 is not "">
<cfset octet2 = form.octet2>
</cfif></cfif> 

<cfparam name = "octet3" default = ""> 
<cfif IsDefined("form.octet3") is "True">
<cfif form.octet3 is not "">
<cfset octet3 = form.octet3>
</cfif></cfif> 

<cfparam name = "octet4" default = ""> 
<cfif IsDefined("form.octet4") is "True">
<cfif form.octet4 is not "">
<cfset octet4 = form.octet4>
</cfif></cfif> 

<cfparam name = "note" default = ""> 
<cfif IsDefined("form.note") is "True">
<cfif form.note is not "">
<cfset note = form.note>
</cfif></cfif> 

<cfquery name="get_mynetworks_id" datasource="#datasource#">
select id from parameters where parameter='mynetworks' and child = '2'
</cfquery>

<cfif #action# is "canceladd">
<cfquery name="canceladd" datasource="#datasource#">
delete from parameters where action='insert' and applied='2' and parent='#get_mynetworks_id.id#'  
</cfquery>
<cflocation url="select.cfm?m2=7">

<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
delete from parameters where action='delete' and applied='2' and parent='#get_mynetworks_id.id#' 
</cfquery>
<cflocation url="select.cfm?m1=3##delete">
</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion5" style="height: 275px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text273" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select the type of entry (<b>IP Address</b> or<b> Network</b>) you wish to add below and proceed adding your entry into the Permitted Relay IPs/Networks. </span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="608">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="select.cfm?type=ip" method="post">
                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<cfoutput>
<input type="radio" name="type" value="ip" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="ip" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">IP Address</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="select.cfm?type=network" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<cfoutput>
<input type="radio" name="type" value="network" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="network" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Network</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="41" width="951"><cfif #show_type# is "ip">
<cfif #action# is "add">

<cfif #octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #octet1# GTE #octet_first# AND #octet1# LTE #octet_last#>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet1# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "1">

<cfif #octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #octet2# GTE #octet2_first# AND #octet2# LTE #octet2_last#>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet2# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "2">

<cfif #octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #octet3# GTE #octet3_first# AND #octet3# LTE #octet3_last#>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet3# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "3">

<cfif #octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #octet4# GTE #octet4_first# AND #octet4# LTE #octet4_last#>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet4# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "4">
<cfif #octet1# is "0">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "127">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "169" and #octet2# is "254">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "192" and #octet2# is "0" and #octet3# is "2">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet4# is "0">
<cfset step=0>
<cfset m2=3>
<cfelse>
<cfset step=5>
</cfif>
</cfif>

<cfif step is "5">
<cfif #note# is "">
<cfset step=0>
<cfset m2=8>
<cfelseif #note# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",note) gt 0>
<cfset step=0>
<cfset m2=9>
<cfelse>
<cfset step=6>
</cfif>
</cfif>
</cfif>



<cfif step is "6">
<cfset theAddress="#numberFormat(octet1,0)#.#numberFormat(octet2,0)#.#numberFormat(octet3,0)#.#numberFormat(octet4,0)#">


<cfquery name="checkexists" datasource="#datasource#">
select * from parameters where parameter='#theAddress#' and parent='#get_mynetworks_id.id#' and child='1'
</cfquery>

<cfif #checkexists.recordcount# LT 1>
<cfquery name="getmaxorder" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_mynetworks_id.id#' and child='1'
</cfquery>

<cfset nextup=#getmaxorder.maximum#+1>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, applied, action, note)
values
('#theAddress#', 'postfix', '1', 'main.cf', '#get_mynetworks_id.id#', '1', '#nextup#', '1', '2', 'insert', '#note#')
</cfquery>

<cfset m2=2>
<cflocation url="select.cfm?m2=2">

<cfelse>
<cfset m2=1>
</cfif>
</cfif>
</cfif>


                                        <form name="ip_form" action="select.cfm?action=add&type=ip" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="936"><cfoutput>
                                                <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                                  <tr style="height: 17px;">
                                                    <td width="79" id="Cell1074">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">IP</span></p>
                                                    </td>
                                                    <td width="9" id="Cell1073">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="79" id="Cell1072">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="9" id="Cell1071">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="79" id="Cell1070">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="9" id="Cell1069">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="79" id="Cell1068">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="10" id="Cell1077">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="109" id="Cell1066">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                    <td width="22" id="Cell1079">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="452" id="Cell1065">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 24px;">
                                                    <td id="Cell1055">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" id="FormsEditField45" name="octet1" size="6" onKeyup="autotab(this, document.ip_form.octet2)"  maxlength="3" value="#octet1#">
<cfelseif #show_type# is "network">
<input type="text" id="FormsEditField45" name="octet1" size="6" onKeyup="autotab(this, document.ip_form.octet2)"  maxlength="3" value="#octet1#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1056">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell1057">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet2" size="6" onKeyup="autotab(this, document.ip_form.octet3)" maxlength="3" value="#octet2#">
<cfelseif #show_type# is "network">
<input type="text" name="octet2" size="6" onKeyup="autotab(this, document.ip_form.octet3)" maxlength="3" value="#octet2#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1058">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell1059">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet3" size="6" onKeyup="autotab(this, document.ip_form.octet4)" maxlength="3" value="#octet3#">
<cfelseif #show_type# is "network">
<input type="text" name="octet3" size="6" onKeyup="autotab(this, document.ip_form.octet4)" maxlength="3" value="#octet3#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1060">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell1061">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet4" size="6" maxlength="3" value="#octet4#">
<cfelseif #show_type# is "network">
<input type="text" name="octet4" size="6" maxlength="3" value="#octet4#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1078">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td id="Cell1063">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="note" size="25" maxlength="255" value="#note#">
<cfelseif #show_type# is "network">
<input type="text" name="note" size="25" maxlength="255" value="#note#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1080">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td id="Cell1064">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #show_type# is "network">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="52" width="950"><cfif #show_type# is "network">
<cfif #action# is "add">


<cfif #octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #octet1# GTE #octet_first# AND #octet1# LTE #octet_last#>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m3=3>
</cfif>
<cfelseif #octet1# is "">
<cfset step=0>
<cfset m3=5>
</cfif>
</cfif>

<cfif step is "1">

<cfif #octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #octet2# GTE #octet2_first# AND #octet2# LTE #octet2_last#>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m3=3>
</cfif>
<cfelseif #octet2# is "">
<cfset step=0>
<cfset m3=5>
</cfif>
</cfif>

<cfif step is "2">
<cfif #octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #octet3# GTE #octet3_first# AND #octet3# LTE #octet3_last#>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m3=3>
</cfif>
<cfelseif #octet3# is "">
<cfset step=0>
<cfset m3=5>
</cfif>
</cfif>

<cfif step is "3">

<cfif #octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #octet4# GTE #octet4_first# AND #octet4# LTE #octet4_last#>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m3=3>
</cfif>
<cfelseif #octet4# is "">
<cfset step=0>
<cfset m3=5>
</cfif>
</cfif>


<cfif step is "4">
<cfif #octet1# is "0">
<cfset step=0>
<cfset m3=3>
<cfelseif #octet1# is "127">
<cfset step=0>
<cfset m3=3>
<cfelseif #octet1# is "169" and #octet2# is "254">
<cfset step=0>
<cfset m3=3>
<cfelseif #octet1# is "192" and #octet2# is "0" and #octet3# is "2">
<cfset step=0>
<cfset m3=3>
<cfelse>
<cfset step=5>
</cfif>
</cfif>

<cfif step is "5">
<cfif #note# is "">
<cfset step=0>
<cfset m2=8>
<cfelseif #note# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",note) gt 0>
<cfset step=0>
<cfset m2=9>
<cfelse>
<cfset step=6>
</cfif>
</cfif>
</cfif>



<cfif step is "6">
<cfset theAddress="#numberFormat(octet1,0)#.#numberFormat(octet2,0)#.#numberFormat(octet3,0)#.#numberFormat(octet4,0)#">


<cfquery name="checkexists" datasource="#datasource#">
select * from parameters where parameter='#theAddress#/#form.subnet#' and parent='#get_mynetworks_id.id#' and child='1'
</cfquery>

<cfif #checkexists.recordcount# LT 1>
<cfquery name="getmaxorder" datasource="#datasource#">
SELECT max(order1) as maximum FROM `parameters` where parent='#get_mynetworks_id.id#' and child='1'
</cfquery>

<cfset nextup=#getmaxorder.maximum#+1>

<cfquery name="add" datasource="#datasource#">
insert into parameters 
(parameter, module, editable, conf_file, parent, child, order1, enabled, applied, action, network_entry, note)
values
('#theAddress#/#form.subnet#', 'postfix', '1', 'main.cf', '#get_mynetworks_id.id#', '1', '#nextup#', '1', '2', 'insert', '1', '#note#')
</cfquery>

<cfset m3=2>
<cflocation url="select.cfm?m3=2">

<cfelse>
<cfset m3=1>
</cfif>
</cfif>
</cfif>


                                        <form name="network_form" action="select.cfm?action=add&type=network" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="938"><cfoutput>
                                                <table id="Table98" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 52px;">
                                                  <tr style="height: 28px;">
                                                    <td width="58" id="Cell1089">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Network</span></p>
                                                    </td>
                                                    <td width="33" id="Cell1088">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="61" id="Cell1087">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="26" id="Cell1086">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="67" id="Cell1085">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="21" id="Cell1084">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="71" id="Cell1083">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="41" id="Cell1094">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="97" id="Cell1082">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Network Mask</span></p>
                                                    </td>
                                                    <td width="25" id="Cell1096">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="78" id="Cell1090">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                    <td width="13" id="Cell1092">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="347" id="Cell1081">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 24px;">
                                                    <td id="Cell550">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="octet1" size="6" onKeyup="autotab(this, document.network_form.octet2)"  maxlength="3" value="#octet1#">
<cfelseif #show_type# is "ip">
<input type="text" name="octet1" size="6" onKeyup="autotab(this, document.network_form.octet2)"  maxlength="3" value="#octet1#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell551">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell552">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="octet2" size="6" onKeyup="autotab(this, document.network_form.octet3)"  maxlength="3" value="#octet2#">
<cfelseif #show_type# is "ip">
<input type="text" name="octet2" size="6" onKeyup="autotab(this, document.network_form.octet3)"  maxlength="3" value="#octet2#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell553">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell554">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="octet3" size="6" onKeyup="autotab(this, document.network_form.octet4)"  maxlength="3" value="#octet3#">
<cfelseif #show_type# is "ip">
<input type="text" name="octet3" size="6" onKeyup="autotab(this, document.network_form.octet4)"  maxlength="3" value="#octet3#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell555">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell556">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="octet4" size="6" maxlength="3" value="#octet4#">
<cfelseif #show_type# is "ip">
<input type="text" name="octet4" size="6" maxlength="3" value="" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1095">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td id="Cell557">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfquery name="getsubnet" datasource="#datasource#">
select * from subnet order by value2 asc
</cfquery>

<cfif #show_type# is "network">
<select name="subnet">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
<cfelseif #show_type# is "ip">
<select name="server_subnet" disabled="disabled">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1097">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td id="Cell1091">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="note" size="25" maxlength="255" value="#note#">
<cfelseif #show_type# is "ip">
<input type="text" name="note" size="25" maxlength="255" value="#note#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell1093">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td id="Cell558">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                </cfoutput></td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="951"><hr id="HRRule1" width="951" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Permitted Relay IPs/Networks&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="951" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters2" datasource="#datasource#">
select * from parameters where action='insert' and applied='2' and parent='#get_mynetworks_id.id#' order by parameter asc
</cfquery>
<cfif #get_parameters2.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters2">
<option value="#id#">#parameter# ---> #note# --> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No IP/Network Address found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <form name="Table127FORM" action="select.cfm?action=canceladd" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="951" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_parameters2.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_parameters2.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" disabled="disabled">
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
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="0"><hr id="HRRule5" width="0" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="442"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="5" width="951" id="Text277" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;IP Address ready to be added. Please click the Apply Settings to add the IP Address to the system and apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Network Address ready to be added. Please click the Apply Settings to add the Network Address to the system and apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address fields cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address fields cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid. An valid IP address is in the form: 192.168.0.23</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid. An valid IP address is in the form: 192.168.0.23</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Note field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Note field must ONLY contain upper/locate case letters, number dashes (-), underscores (_) and periods (.)</span></i></b></p>
</cfoutput>
</cfif>
&nbsp;</p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="949"><hr id="HRRule6" width="949" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="506" id="Text411" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Relay IPs/Networks</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="200"></td>
                          <td colspan="5" width="951"><cfparam name = "network_entry" default = ""> 
<cfif IsDefined("form.mynetworks") is "True">
<cfif form.mynetworks is not "">
<cfset network_entry = form.mynetworks>
</cfif></cfif> 

<cfif #action# is "delete">
<cfif #network_entry# is not "">
<cfset step=1>
<cfelseif #network_entry# is "">
<cfset step=0>
<cfset m1=1>
</cfif>

<cfif #step# is 1>
<cfquery name="delete" datasource="#datasource#">
update parameters set action='delete', applied='2' where id='#network_entry#'
</cfquery>

<cfset m1=2>
<cflocation url="select.cfm?m1=2##delete">
</cfif>
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion4" style="height: 200px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text272" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select entry from the list below and click the <b>Delete</b> button to remove them from the Permitted Relay IPs/Networks.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="610">
                                    <tr valign="top" align="left">
                                      <td height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="50" width="610">
                                        <form name="delete" action="select.cfm?action=delete" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="610">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 50px;">
                                                  <tr style="height: 24px;">
                                                    <td width="610" id="Cell7">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="left">
                                                            <table width="610" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfquery name="get_mynetworks_id" datasource="#datasource#">
select id from parameters where parameter='mynetworks' and child = '2' order by order1 asc
</cfquery>

<cfquery name="get_mynetworks_children" datasource="#datasource#">
select * from parameters where parent='#get_mynetworks_id.id#' and child = '1' and enabled='1' and applied='1' and parameter <> '127.0.0.1' order by order1 asc
</cfquery>

<select name="mynetworks" style="height: 88px;" size="60">
<cfoutput query="get_mynetworks_children">
<option value="#id#">#parameter# --> #note#</option>
</cfoutput>
</select>&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 26px;">
                                                    <td id="Cell1">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="951"><hr id="HRRule3" width="951" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="12"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text412" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Permitted Relay IPs/Networks&nbsp; to be deleted</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="951" id="Text413" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters3" datasource="#datasource#">
select * from parameters where action='delete' and applied='2' and parent='#get_mynetworks_id.id#' order by parameter asc
</cfquery>
<cfif #get_parameters3.recordcount# GTE 1>
<select name="parameters3" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters3">
<option value="#id#">#parameter# ---> #note# --> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No IP/Network Address found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <form name="Table127FORM" action="select.cfm?action=canceldelete" method="post">
                                          <table id="Table149" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="951" id="Cell873">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_parameters3.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_parameters3.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" disabled="disabled">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="609">
                                    <tr valign="top" align="left">
                                      <td width="609" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="609" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;IP/Network Address ready to be deleted. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="950"><hr id="HRRule7" width="950" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="51"></td>
                          <td colspan="4" width="950"><cfif #action# is "apply">
<cfquery name="checkdelete" datasource="#datasource#">
delete from parameters where applied='2' and action='delete'
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
update parameters set applied='1', action='NONE' where applied = '2'
</cfquery>

<!-- THIS QUERY ONLY GETS NETWORKS FOR /ETC/AMAVIS/MYNETWORKS
<cfquery name="getintnetworks" datasource="#datasource#">
select * from parameters where network_entry='1'
</cfquery>
-->

<!-- THE TWO QUERIES BELOW GET BOTH NETWORKS AND IPS FOR ETC/AMAVIS/MYNETWORKS -->
<cfquery name="getmynetworksparent" datasource="#datasource#">
select parameter, id, description, child, editable, enabled, conf_file from parameters where parameter = 'mynetworks' and enabled='1' and child <> '1' and module='postfix'
</cfquery>

<cfquery name="getintnetworks" datasource="#datasource#">
select * from parameters where child='1' and parent = '#getmynetworksparent.id#' and enabled = '1' order by order1 asc
</cfquery>

<cffile action = "delete" 
file = "/etc/amavis/mynetworks">

<cffile action = "write" 
file = "/etc/amavis/mynetworks" 
output = ""
addnewline="no">

<cfloop query="getintnetworks">
<cfoutput>
<cffile action = "APPEND" 
file = "/etc/amavis/mynetworks" 
output = "#parameter##chr(10)#"
addnewline="no">
</cfoutput>
</cfloop>

<cfexecute name = "/etc/init.d/amavis"
outputfile ="/dev/null"
arguments="force-reload"
timeout = "240">
</cfexecute>

<cflocation url="select.cfm?action=applied##apply">
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion17" style="height: 51px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <form name="apply_settings" action="select.cfm?action=apply" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="950" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters where applied='2' and parent='#get_mynetworks_id.id#' 
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "applied">
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