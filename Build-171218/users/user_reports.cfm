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
<title>Report Settings</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({selector:'textarea',
readonly: true,
  toolbar: false,
  menubar: false,
  statusbar: false
});
</script>

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

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
var popupWidth = 800;
var popupHeight = 600;
var popupTop = 300;
var popupLeft = 300;
var isFullScreen = false;
var isAutoCenter = true;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=1";

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
<body style="background-color: rgb(192,192,192); background-image: none; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu_users',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu_users.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="130" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./top_blue_3.png'); height: 130px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="887">
                        <tr valign="top" align="left">
                          <td width="132" height="101"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="19"></td>
                          <td width="755"><!--<img id="AllWebMenusComponent1" height="19" width="755" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu_users.js' AWMJSPATH='./hermes_seg_menu_users.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu_users'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="435" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion12" style="background-image: url('./middle_988.png'); height: 435px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="927">
                              <tr valign="top" align="left">
                                <td width="15" height="16"></td>
                                <td width="912"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="912" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Quarantine Report Settings for #session.email#</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="40">
                              <tr valign="top" align="left">
                                <td width="15" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/report-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="15" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule7" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="955"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955" id="Text440" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">You can adjust your report settings to be sent on a <b>Daily Basis</b>, every<b> 8 Hours</b>, every <b>4 Hours</b> or alternatively, you can completely disable the reports. The Daily Report will be sent once a day and it will include any quarantined messages from the previous day. The 8 Hour or the 4 Hour report will include any quarantined messages from the current day only. Please note, no matter which option you choose, reports will only be sent if there are quarantined messages available. If there are no quarantined messages available, the report will not be sent.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="15" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule8" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="14" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955">
                            <form name="Table99FORM" action="<cfoutput>user_reports.cfm?m=1</cfoutput>" method="post">
                              <input type="hidden" name="action" value="update">
                              <table id="Table99" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 220px;">
                                <tr style="height: 203px;">
                                  <td width="955" id="Cell562">
                                    <table width="955" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfquery name="getsettings" datasource="#datasource#">
select report_enabled, report_frequency from user_settings where id='#session.uid#'
</cfquery>

<cfparam name = "frequency" default = "#getsettings.report_frequency#"> 
<cfif IsDefined("form.frequency") is "True">
<cfif form.frequency is not "">
<cfset frequency = #form.frequency#>
</cfif></cfif>

<cfparam name = "enabled" default = "#getsettings.report_enabled#">
<cfif IsDefined("form.enabled") is "True">
<cfif form.enabled is not "">
<cfset enabled = "#form.enabled#">
</cfif> 
</cfif>

<cfif #action# is "update">
<cfquery name="updatesettings" datasource="#datasource#">
update user_settings set
report_enabled='#enabled#',
report_frequency='#frequency#'
where id = '#session.uid#'
</cfquery>
</cfif>



                                          <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion11" style="height: 203px;">
                                            <tr align="left" valign="top">
                                              <td>
                                                <table border="0" cellspacing="0" cellpadding="0">
                                                  <tr valign="top" align="left">
                                                    <td width="7"></td>
                                                    <td width="948">
                                                      <table id="Table160" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 156px;">
                                                        <tr style="height: 14px;">
                                                          <td width="940" id="Cell889">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enable Quarantine Reports</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 51px;">
                                                          <td id="Cell890">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                              <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td>
                                                                    <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                                      <tr style="height: 17px;">
                                                                        <td width="51" id="Cell411">
                                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                            <tr>
                                                                              <td class="TextObject">
                                                                                <p style="margin-bottom: 0px;"><cfif #enabled# is "YES">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="YES" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "YES">
<cfoutput>
<input type="radio" name="enabled" value="YES" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                          &nbsp;</td>
                                                                        <td width="480" id="Cell412">
                                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES <span style="color: rgb(51,51,51); font-weight: normal;">(Only if quarantined messages exist)</span></span></b></p>
                                                                        </td>
                                                                      </tr>
                                                                      <tr style="height: 17px;">
                                                                        <td id="Cell1017">
                                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                            <tr>
                                                                              <td class="TextObject">
                                                                                <p style="margin-bottom: 0px;"><cfif #enabled# is "ALL">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="ALL" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "ALL">
<cfoutput>
<input type="radio" name="enabled" value="ALL" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                          &nbsp;</td>
                                                                        <td id="Cell1016">
                                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES <span style="color: rgb(51,51,51); font-weight: normal;">(Regardless if quarantined messages exist)</span></span></b></p>
                                                                        </td>
                                                                      </tr>
                                                                      <tr style="height: 17px;">
                                                                        <td id="Cell413">
                                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                            <tr>
                                                                              <td class="TextObject">
                                                                                <p style="margin-bottom: 0px;"><cfif #enabled# is "NO">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="NO" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "NO">
<cfoutput>
<input type="radio" name="enabled" value="NO" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                              </td>
                                                                            </tr>
                                                                          </table>
                                                                          &nbsp;</td>
                                                                        <td id="Cell414">
                                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No</span></b></p>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              </b></td>
                                                          </tr>
                                                          <tr style="height: 14px;">
                                                            <td id="Cell891">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Quarantine Report Frequency</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 24px;">
                                                            <td id="Cell892">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                                <table width="209" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;"><cfif #enabled# is "YES">

<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
 <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


</cfif>

<cfelseif #enabled# is "NO">
<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

</cfif>


<cfelseif #enabled# is "ALL">
<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

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
                                                                            <p style="text-align: left; margin-bottom: 0px;">
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
                                                    <table border="0" cellspacing="0" cellpadding="0" width="955">
                                                      <tr valign="top" align="left">
                                                        <td width="6" height="6"></td>
                                                        <td width="949"></td>
                                                      </tr>
                                                      <tr valign="top" align="left">
                                                        <td></td>
                                                        <td width="949" id="Text185" class="TextObject">
                                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Report Settings Updated</span></i></b></p>
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
                                    <tr style="height: 17px;">
                                      <td id="Cell567">
                                        <p style="margin-bottom: 0px;">&nbsp;</p>
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
                  <td height="49" width="988">
                    <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./bottom_988.png'); height: 49px;">
                      <tr align="left" valign="top">
                        <td>
                          <table border="0" cellspacing="0" cellpadding="0" width="979">
                            <tr valign="top" align="left">
                              <td width="979" height="13"></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td width="979" id="Text464" class="TextObject">
                                <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,255,255);"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfoutput>
<span style="font-size: 12px; color: rgb(255,255,255);">Hermes Secure Email Gateway #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved.</span></cfoutput></span>&nbsp;</p>
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