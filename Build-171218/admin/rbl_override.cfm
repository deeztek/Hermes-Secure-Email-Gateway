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
<title>IP & Network Override</title>
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
              <td height="841" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion28" style="background-image: url('./middle_988.png'); height: 841px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="523">
                              <tr valign="top" align="left">
                                <td width="17" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text489" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">IP &amp; Network Override</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="4"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text490" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add&nbsp; IP &amp; Network Override</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="447">
                              <tr valign="top" align="left">
                                <td width="422" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/ip-network-override/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="17" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="382"></td>
                          <td width="948"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "rbl_entry" default = ""> 
<cfif IsDefined("form.rbl_override") is "True">
<cfif form.rbl_override is not "">
<cfset rbl_entry = form.rbl_override>
</cfif></cfif> 

<cfparam name = "note" default = ""> 
<cfif IsDefined("form.note") is "True">
<cfif form.note is not "">
<cfset note = form.note>
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

<cfif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from postscreen_access where action2='insert' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=12>
<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
update postscreen_access set action2='NONE', applied='1' where action2='delete' and applied='2'
</cfquery>
<cfset step=0>
<cfset m1=5>
</cfif>

<script>

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
                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion5" style="height: 382px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text273" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Enter a Note identifying the entry,&nbsp; the IP/Network Address you wish to add, select the&nbsp; action to take and click the Add button</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="617">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                      <td width="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form name="LayoutRegion8FORM" action="rbl_override.cfm?type=ip" method="post">
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
                                                  <form name="LayoutRegion8FORM" action="rbl_override.cfm?type=network" method="post">
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
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="12"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "ip">
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
<cfset octet2_last = 255>
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
<cfset octet3_last = 255>
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
<cfset octet4_last = 255>
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
<cfset theAddress="#numberFormat(octet1,0)#.#numberFormat(octet2,0)#.#numberFormat(octet3,0)#.#numberFormat(octet4,0)#">

<cfquery name="checkexists" datasource="#datasource#">
select * from postscreen_access where sender='#theAddress#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into postscreen_access
(sender, action, action2, applied, note)
values
('#theAddress#', '#action2#', 'insert', '2', '#note#')
</cfquery>

<cfset m2=2>

<cfelse>
<cfset m2=1>

</cfif>
</cfif>
</cfif>



                                        <form name="ipaddress" action="rbl_override.cfm?action=add&type=ip" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1027">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1028">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "ip">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
<cfelseif #show_type# is "network">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
</cfif>
</cfoutput>&nbsp;</p>
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
                                              <td height="7"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="544"><cfoutput>
                                                <table id="Table93" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                                  <tr style="height: 17px;">
                                                    <td width="61" id="Cell715">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">IP</span></p>
                                                    </td>
                                                    <td width="10" id="Cell714">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="61" id="Cell713">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="13" id="Cell712">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="60" id="Cell711">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="12" id="Cell710">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="69" id="Cell709">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="90" id="Cell708">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Action</span></p>
                                                    </td>
                                                    <td width="168" id="Cell707">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 24px;">
                                                    <td id="Cell530">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" id="FormsEditField45" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" onKeyup="autotab(this, document.ipaddress.octet2)">
<cfelseif #show_type# is "network">
<input type="text" id="FormsEditField45" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet2)">
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell545">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell531">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" onKeyup="autotab(this, document.ipaddress.octet3)">
<cfelseif #show_type# is "network">
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet3)">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell546">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell532">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" onKeyup="autotab(this, document.ipaddress.octet4)">
<cfelseif #show_type# is "network">
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet4)">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell547">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                                    </td>
                                                    <td id="Cell533">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#">
<cfelseif #show_type# is "network">
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#" disabled="disabled">
</cfif>

&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell706">
                                                      <table width="60" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<select id="FormsComboBox1" name="action2" style="height: 24px;">
<option value="permit" selected="selected">Permit</option>
<option value="reject">Reject</option>
</select>
<cfelseif #show_type# is "network">
<select id="FormsComboBox1" name="action2" style="height: 24px;" disabled="disabled">
<option value="permit" selected="selected">Permit</option>
<option value="reject">Reject</option>
</select>
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell534">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is "network">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
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
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="12"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="82" colspan="2" width="617"><cfif #show_type# is "network">
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
<cfset octet2_last = 255>
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
<cfset octet3_last = 255>
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
<cfset octet4_last = 255>
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
<cfset theAddress="#numberFormat(octet1,0)#.#numberFormat(octet2,0)#.#numberFormat(octet3,0)#.#numberFormat(octet4,0)#">

<cfquery name="checkexists" datasource="#datasource#">
select * from postscreen_access where sender='#theAddress#/#form.subnet#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="add" datasource="#datasource#">
insert into postscreen_access
(sender, action, action2, applied, note)
values
('#theAddress#/#form.subnet#', '#action2#', 'insert', '2', '#note#')
</cfquery>

<cfset m3=2>

<cfelse>
<cfset m3=1>
</cfif>
</cfif>
</cfif>

                                        <form name="network" action="rbl_override.cfm?action=add&type=network" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="544">
                                                <table id="Table186" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  <tr style="height: 12px;">
                                                    <td width="544" id="Cell1031">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Note</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1032">
                                                      <table width="519" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfoutput>
<cfif #show_type# is "ip">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#" disabled="disabled">
<cfelseif #show_type# is "network">
<input type="text" id="formnote" name="note" size="40" maxlength="40" style="width: 375px; white-space: pre;" value="#note#">
</cfif>
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
                                              <td height="7"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="547"><cfoutput>
                                                <table id="Table98" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                                  <tr style="height: 17px;">
                                                    <td width="49" id="Cell724">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Network</span></p>
                                                    </td>
                                                    <td width="7" id="Cell723">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="49" id="Cell722">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="9" id="Cell721">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="48" id="Cell720">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="8" id="Cell719">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="57" id="Cell718">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                    <td width="164" id="Cell717">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Subnet</span></p>
                                                    </td>
                                                    <td width="83" id="Cell716">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Action</span></p>
                                                    </td>
                                                    <td width="73" id="Cell725">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 24px;">
                                                    <td id="Cell550">
                                                      <table width="48" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="text" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" onKeyup="autotab(this, document.network.octet2)">
<cfelseif #show_type# is "ip">
<input type="text" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" disabled="disabled" onKeyup="autotab(this, document.network.octet2)">
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
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" onKeyup="autotab(this, document.network.octet3)">
<cfelseif #show_type# is "ip">
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" disabled="disabled" onKeyup="autotab(this, document.network.octet3)">
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
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" onKeyup="autotab(this, document.network.octet4)">
<cfelseif #show_type# is "ip">
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" disabled="disabled" onKeyup="autotab(this, document.network.octet4)">
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
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#">
<cfelseif #show_type# is "ip">
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#" disabled="disabled">
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell557">
                                                      <table width="150" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfquery name="getsubnet" datasource="#datasource#">
select * from subnet order by value2 asc
</cfquery>

<cfif #show_type# is "network">
<select name="subnet" style="height: 24px;">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
<cfelseif #show_type# is "ip">
<select name="server_subnet" style="height: 24px;" disabled="disabled">
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell558">
                                                      <table width="60" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<select id="FormsComboBox1" name="action2" style="height: 24px;">
<option value="permit" selected="selected">Permit</option>
<option value="reject">Reject</option>
</select>
<cfelseif #show_type# is "ip">
<select id="FormsComboBox1" name="action2" style="height: 24px;" disabled="disabled">
<option value="permit" selected="selected">Permit</option>
<option value="reject">Reject</option>
</select>
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell726">
                                                      <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "network">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="948"><hr id="HRRule5" width="948" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="531">
                                    <tr valign="top" align="left">
                                      <td width="531" height="14"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="531" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">IP &amp; Network Address(es)&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="948" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_rbloverride" datasource="#datasource#">
select * from postscreen_access where action2='insert' and applied='2' order by sender asc
</cfquery>
<cfif #get_rbloverride.recordcount# GTE 1>
<select name="rbloverride" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_rbloverride">
<option value="#id#">#sender# ---> #note# --> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No IP/Network Addresses found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <form name="Table127FORM" action="rbl_override.cfm?action=canceladd" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="948" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_rbloverride.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_rbloverride.recordcount# LT 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text277" class="TextObject">
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
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;IP Address ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Network Address ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid (LT7)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid (LT7)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address you attempting to add is not valid(GT15)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address you attempting to add is not valid(GT15)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the IP address field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Network address field cannot be empty</span></i></b></p>
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

<cfif #m2# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
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
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="439"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="947"><hr id="HRRule14" width="947" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text419" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete&nbsp; IP &amp; Network Override</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="189"></td>
                          <td colspan="5" width="948"><cfif #action# is "delete">
<cfif #rbl_entry# is not "">
<cfset step=1>
<cfelseif #rbl_entry# is "">
<cfset step=0>
<cfset m1=1>
</cfif>

<cfif #step# is 1>
<cfquery name="delete" datasource="#datasource#">
update postscreen_access set action2='delete', applied='2' where id='#rbl_entry#'
</cfquery>




<cfset m1=3>

</cfif>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion4" style="height: 189px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td colspan="2" width="934" id="Text272" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select entry from the list below and click the <b>Delete</b> button to remove them from the RBL Override listing</span></p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="14" height="3"></td>
                                      <td width="599"></td>
                                      <td width="335"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="50" colspan="2" width="613">
                                        <form name="delete" action="rbl_override.cfm?action=delete#delete" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="597">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 50px;">
                                                  <tr style="height: 24px;">
                                                    <td width="597" id="Cell7">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="left">
                                                            <table width="581" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfquery name="get_rbl_override" datasource="#datasource#">
select * from postscreen_access where applied='1'
</cfquery>

<select name="rbl_override" style="height: 88px;" size="60">
<cfoutput query="get_rbl_override">
<cfif #action# is "permit">
<option value="#id#">#sender# ---> #note# --> PERMIT</option>
<cfelseif #action# is "reject">
<option value="#id#">#sender# ---> #note# --> REJECT</option>
</cfif>
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
                                      <td></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="948"><hr id="HRRule7" width="948" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="609">
                                    <tr valign="top" align="left">
                                      <td width="531" height="3"></td>
                                      <td width="78"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="531" id="Text420" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">IP &amp; Network Address(es)&nbsp; to be deleted</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="609" id="Text421" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_rbloverride2" datasource="#datasource#">
select * from postscreen_access where action2='delete' and applied='2' order by sender asc
</cfquery>
<cfif #get_rbloverride2.recordcount# GTE 1>
<select name="rbloverride2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_rbloverride2">
<option value="#id#">#sender# ---> #note# --> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No IP/Network Addresses found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <form name="Table127FORM" action="rbl_override.cfm?action=canceldelete#delete" method="post">
                                          <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="948" id="Cell739">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_rbloverride2.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_rbloverride2.recordcount# LT 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="948">
                                    <tr valign="top" align="left">
                                      <td width="948" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="948" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry to delete before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Entry marked for deletion. Please click the Apply Settings button below to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="4" valign="middle" width="947"><hr id="HRRule15" width="947" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td colspan="3" width="946"><cfif #action# is "apply">

<cfquery name="updateinsert" datasource="#datasource#">
update postscreen_access set applied='1', action2='NONE' where applied='2' and action2='insert'
</cfquery>


<cfquery name="updatedelete" datasource="#datasource#">
delete from postscreen_access where applied='2' and action2='delete'
</cfquery>


<cfquery name="get" datasource="#datasource#">
select sender, action from postscreen_access
</cfquery>

<cfset FileData = "">
<cfloop query="get">
<cfset FileData = FileData & get.sender & #Chr(9)# & get.action & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/postscreen_access.cidr" output = "#FileData#" addnewline="no">

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

<cffile action = "write"
    file = "/var/www/tasks/#customtrans3#_postmap.sh"
    output = "/usr/sbin/postmap /etc/postfix/postscreen_access.cidr" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /var/www/tasks/#customtrans3#_postmap.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/var/www/tasks/#customtrans3#_postmap.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/var/www/tasks/#customtrans3#_postmap.sh">
  
    
<cffile action = "write"
    file = "/var/www/tasks/#customtrans3#_restart_postfix.sh"
    output = "/usr/sbin/service postfix reload#chr(10)#/usr/sbin/service postfix restart" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /var/www/tasks/#customtrans3#_restart_postfix.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/var/www/tasks/#customtrans3#_restart_postfix.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/var/www/tasks/#customtrans3#_restart_postfix.sh">





<cflocation url="rbl_override.cfm?action=applied##apply" addToken = "no">
</cfif>


<cellpadding="0" width="635" id="LayoutRegion17" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 63px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="946" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="946">
                                        <form name="apply_settings" action="rbl_override.cfm?action=apply#apply" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="946" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from postscreen_access where applied='2'
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="946">
                                    <tr valign="top" align="left">
                                      <td width="946" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="946" id="Text330" class="TextObject">
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