<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>
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
<title>System Logs</title>
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
              <td height="564" width="988"><CFPARAM NAME="StartRow" DEFAULT="1">
<CFSET DisplayRows = 100>
<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>


<cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">
<cfparam name = "usercount" default = "0">
<cfparam name = "rcptcount" default = "0">

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif> 

<cfparam name = "m5" default = ""> 
<cfif IsDefined("url.m5") is "True">
<cfif url.m5 is not "">
<cfset m5 = url.m5>
</cfif></cfif>  

<cfparam name = "m6" default = ""> 
<cfif IsDefined("url.m6") is "True">
<cfif url.m6 is not "">
<cfset m6 = url.m6>
</cfif></cfif> 

<cfparam name = "filter" default = ""> 
<cfif IsDefined("session.filter") is "True">
<cfif session.filter is not "">
<cfset filter = session.filter>
</cfif></cfif>

<cfparam name = "filter3" default = ""> 
<cfif IsDefined("session.filter3") is "True">
<cfif session.filter3 is not "">
<cfset filter3 = session.filter3>
</cfif></cfif>


<cfparam name = "filter4" default = ""> 
<cfif IsDefined("session.filter4") is "True">
<cfif session.filter4 is not "">
<cfset filter4 = session.filter4>
</cfif></cfif>

<cfparam name = "searchtype" default = "basic"> 
<cfif IsDefined("session.searchtype") is "True">
<cfif session.searchtype is not "">
<cfset searchtype = session.searchtype>
</cfif></cfif>

<cfparam name = "andor" default = ""> 
<cfif IsDefined("session.andor") is "True">
<cfif session.andor is not "">
<cfset andor = session.andor>
</cfif></cfif>


<cfparam name = "startdate" default = ""> 
<cfif IsDefined("url.startdate") is "True">
<cfif url.startdate is not "">
<cfif isValid("date", #url.startdate#)> 
<cfset startdate = url.startdate>
<cfelseif NOT isValid("date", #url.startdate#)>
<cfset session.theError = "URL.STARTDATE INVALID DATE">
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("url.enddate") is "True">
<cfif url.enddate is not "">
<cfif isValid("date", #url.enddate#)> 
<cfset enddate = url.enddate>
<cfelseif NOT isValid("date", #url.enddate#)>
<cfset session.theError = "URL.ENDDATE INVALID DATE">
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>

<cfparam name = "starttime" default = ""> 
<cfif IsDefined("url.starttime") is "True">
<cfif url.starttime is not "">
<cfif isValid("time", #url.starttime#)> 
<cfset starttime = url.starttime>
<cfelseif NOT isValid("time", #url.starttime#)>
<cfset session.theError = "URL.STARTTIME INVALID TIME">
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>

<cfparam name = "endtime" default = ""> 
<cfif IsDefined("url.endtime") is "True">
<cfif url.endtime is not "">
<cfif isValid("time", #url.endtime#)> 
<cfset endtime = url.endtime>
<cfelseif NOT isValid("time", #url.endtime#)>
<cfset session.theError = "URL.ENDTIME INVALID TIME">
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>

<cfif #action# is "search">

<cfif #searchtype# is "basic">

<cfif #filter# is "">

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>

<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents order by ReceivedAt desc limit #StartRow#, #DisplayRows#
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",filter) gt 0>
<cfset session.theError = "FILTER INVALID CHARACTERS">
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents where Message like '%#filter#%'
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>


<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents where Message like '%#filter#%' order by ReceivedAt desc limit #StartRow#,
 #DisplayRows#
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cfset session.theError = "FILTER BANNED KEYWORDS">
<cflocation url="error.cfm">
</cfif>
</cfif>


<cfelseif #searchtype# is "advanced">

<cfif #andor# is "AND">

<cfif REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",filter3) gt 0 OR REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",filter4) gt 0>
<cfset session.theError = "FILTER3 OR FILTER4 INVALID CHARACTERS">
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter3#') and banned='1' OR keyword IN ('#filter4#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>
<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents where Message like '%#filter3#%' AND Message like '%#filter4#%' and ReceivedAt
 between '#startdate2# #starttime#' and '#enddate2# #endtime#'
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>

<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents where Message like '%#filter3#%' AND Message like '%#filter4#%' and ReceivedAt
 between '#startdate2# #starttime#' and '#enddate2# #endtime#' order by ReceivedAt desc limit #StartRow#, #DisplayRows#
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cfset session.theError = "FILTER3 OR FILTER4 BANNED KEYWORDS">
<cflocation url="error.cfm">
</cfif>



<cfelseif #andor# is "OR">

<cfif REFind("[^A-Za-z0-9\_\,\.\-\@\[\]\(\)\:\+ ]",filter3) gt 0>
<cfset session.theError = "FILTER3 INVALID CHARACTERS">
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter3#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>
<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents where Message like '%#filter3#%' and ReceivedAt between '#startdate2# #starttime#'
 and '#enddate2# #endtime#'
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>

<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents where Message like '%#filter3#%' and ReceivedAt between '#startdate2#
 #starttime#' and '#enddate2# #endtime#' order by ReceivedAt desc limit #StartRow#, #DisplayRows#
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cfset session.theError = "FILTER3 BANNED KEYWORDS">
<cflocation url="error.cfm">
</cfif>




<cfelseif #andor# is "">

<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents where ReceivedAt between '#startdate2# #starttime#' and '#enddate2# #endtime#'
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>

<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents where ReceivedAt between '#startdate2# #starttime#' and '#enddate2# #endtime#'
 order by ReceivedAt desc limit #StartRow#, #DisplayRows#
</cfquery>


</cfif>


</cfif>

<cfelse>

<cfquery name="gettotalevents" datasource="SysLog">
SELECT count(id) as totalevents from SystemEvents 
</cfquery>
<cfset totalevents=#gettotalevents.totalevents#>

<cfquery name="getlogs" datasource="syslog">
select ReceivedAt, Message, SysLogTag from SystemEvents order by ReceivedAt desc limit #StartRow#, #DisplayRows#
</cfquery>
</cfif>



<CFIF ToRow GT totalevents>
<CFSET ToRow = totalevents>
</CFIF>


<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 564px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="446">
                              <tr valign="top" align="left">
                                <td width="13" height="22"></td>
                                <td width="433"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="433" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">System Logs</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="524">
                              <tr valign="top" align="left">
                                <td width="499" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/system-logs/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="14" height="3"></td>
                          <td width="950"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="950" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">In this page, you can you can view and search system logs. Performing a Simple Search will search all logs for the Search Text you entered. An advanced search will enable you to perform a search for two Search Texts or perform a search by a Date/Time Range. System Log Retention defaults to 30 days. Set to a higher retention period as necessary. <b>Note: setting high retention periods can increase search times significantly</b>. The <b>Clear All Searches</b> button will clear all search filters and refresh the page.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule36" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="521">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td width="506"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text534" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">System Log Retention</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="15" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="505">
                            <form name="Table145FORM" action="set_system_log_retention.cfm" method="post">
                              <table id="Table148" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                <tr style="height: 24px;">
                                  <td width="505" id="Cell872">
                                    <table width="415" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getlogretention" datasource="#datasource#">
select parameter, value2, module from parameters2 where parameter = 'system_log_retention'
</cfquery>


<cfparam name = "logretention" default = "#getlogretention.value2#"> 
<cfif IsDefined("form.logretention") is "True">
<cfset logretention = form.logretention>
</cfif>

<table>
<tr>
<td align="left" size="10">
  <cfoutput>

<cfif #logretention# is "30">
<select name="logretention" style="height: 24px;">
<option value="30" selected="selected">30 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="120">120 Days</option>
  <option value="180">180 Days</option>
  </select>

<cfelseif #logretention# is "60">
<select name="logretention" style="height: 24px;">
<option value="60" selected="selected">60 Days</option>
  <option value="30">30 Days</option>
  <option value="90">90 Days</option>
  <option value="120">120 Days</option>
  <option value="180">180 Days</option>
  </select>

<cfelseif #logretention# is "90">
<select name="logretention" style="height: 24px;">
<option value="90" selected="selected">90 Days</option>
  <option value="30">30 Days</option>
  <option value="60">60 Days</option>
  <option value="120">120 Days</option>
  <option value="180">180 Days</option>
  </select>

<cfelseif #logretention# is "120">
<select name="logretention" style="height: 24px;">
<option value="120" selected="selected">120 Days</option>
  <option value="30">30 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>
  </select>

<cfelseif #logretention# is "180">
<select name="logretention" style="height: 24px;">
<option value="180" selected="selected">180 Days</option>
  <option value="30">30 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="120">120 Days</option>
  </select>


</cfif>

</cfoutput>
    </td>

<td>

<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" value="Set" style="height: 24px; width: 133px;">
</td>
</tr>
</table>&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule40" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="15"></td>
                          <td width="178">
                            <form name="Table145FORM" action="system_logs_filter.cfm" method="post">
                              <input type="hidden" name="clearfilter" value="1">
                              <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                <tr style="height: 24px;">
                                  <td width="178" id="Cell868">
                                    <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" value="Clear All Searches" style="height: 24px; width: 133px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule37" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="442"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="949" id="Text381" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Simple Search Search Text field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m4# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Simple Search Search Text field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Simple Search Search Text field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Advanced Search Search Text field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Advanced Search Search Text 1 field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Advanced Search Search Text 1 field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you have entered an invalid Start Date</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Start Date field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you have entered an invalid End Date</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the End Date field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select NEITHER in the Search Mode field, ensure both Keyword1 and Keyword2 fields are blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select KEYWORD1 in the Search Mode field, ensure Keyword1 field is NOT blank and Keyword2 field IS blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select BOTH in the Search Mode field, ensure both Search Text 1 and Search Text 2 fields are NOT blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m6# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! System Log Retention Set. System Logs will not be pruned until next scheduled interval</span></i></b></p>
</cfoutput>
</cfif>










&nbsp;</p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text482" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Simple Search</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="949" id="Text531" class="TextObject">
                            <p style="margin-bottom: 0px;"><form name="Table144FORM" action="system_logs_filter.cfm" method="post">
  <input type="hidden" name="setfilter" value="1">
<table>
  <tr>

    <td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Search Text</span></b></p>
    </td>
    
<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"></span></b></p>
    </td>



  </tr>



  <tr style="height: 19px;">



  <td align="left">
  <cfoutput>
<input type="text" name="filter" size="55" maxlength="255" white-space: pre;" value="#filter#">
</cfoutput>
    </td>





<td align="left">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Go" style="height: 24px;">
</td>



  </tr>


</table>
</form>&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule38" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="444"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text532" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Advanced Search</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="949" id="Text533" class="TextObject">
                            <p style="margin-bottom: 0px;"><form name="advanced" action="system_logs_filter_advanced.cfm" method="post">
  <input type="hidden" name="setfilter2" value="1">
<table>

  <tr>

 <td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Search Mode</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Search Text 1</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Search Text 2</span></b></p>
    </td>

</tr>

<tr>

<td>
  <cfoutput>

<cfif #andor# is "">
<select id="FormsComboBox1" name="andor" style="height: 24px;">
  <option value="AND">BOTH SEARCH TEXT 1 AND 2</option>
  <option value="OR">SEARCH TEXT 1 ONLY</option>
  <option value="" selected="selected">DATE/TIME ONLY</option>
</select>

<cfelseif #andor# is "AND">
<select id="FormsComboBox1" name="andor" style="height: 24px;">
  <option value="">DATE/TIME ONLY</option>
  <option value="OR">SEARCH TEXT 1 ONLY</option>
  <option value="AND" selected="selected">BOTH SEARCH TEXT 1 AND 2</option>
</select>

<cfelseif #andor# is "OR">
<select id="FormsComboBox1" name="andor" style="height: 24px;">
  <option value="">DATE/TIME ONLY</option>
  <option value="AND">BOTH SEARCH TEXT 1 AND 2</option>
  <option value="OR" selected="selected">SEARCH TEXT 1 ONLY</option>
</select>
</cfif>

</cfoutput>
    </td>

  <td>
  <cfoutput>
<input type="text" name="filter3" maxlength="255" value="#filter3#">
</cfoutput>
    </td>

  <td>
  <cfoutput>
<input type="text" name="filter4" maxlength="255" value="#filter4#">
</cfoutput>
    </td>

</tr>

    
<tr>



<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Start Date</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Start Time</span></b></p>
    </td>



<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">End Date</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">End Time</span></b></p>
    </td>


<td style="background-color: rgb(241,236,236);">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"></span></b></p>
    </td>


  </tr>




<tr>



<td>
<a href="javascript:ShowCalendar('advanced',%20'startdate')"><img src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>
<cfoutput>
<input type="text" name="startdate" maxlength="10" value="#startdate#">
</cfoutput>
</td>

<td>
<cfset stime = CreateTime(01,0,0)> 
<cfset etime = CreateTime(24,45,0)>
 
<cfif #starttime# is "">
<select name="start" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
<option value="00:00:00" SELECTED>12:00:00 AM</option>

</select>

<cfelseif #starttime# is not "">
<cfset starttime2=#TimeFormat(starttime, "hh:mm tt")#>
<select name="start" style="height: 22px;">
<cfoutput>
<option value="#starttime#" SELECTED>#starttime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
</select>

</cfif>

</td>



<td>
<a href="javascript:ShowCalendar('advanced',%20'enddate')"><img id="Picture50" height="22" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>
<cfoutput>
<input type="text" name="enddate" maxlength="10" value="#enddate#">
</cfoutput>
</td>

<td>
<cfif #endtime# is "">
<select name="end" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59" SELECTED>11:59:59 PM</option>

</select>

<cfelseif #endtime# is not "">
<cfset endtime2=#TimeFormat(endtime, "hh:mm tt")#>
<select name="end" style="height: 22px;">
<cfoutput>
<option value="#endtime#" SELECTED>#endtime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfoutput>
</cfloop>
<option value="23:59:59">11:59:59 PM</option>
</select>

</cfif>
</td>

<td>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Go" style="height: 24px;">
</td>



  </tr>


</table>
</form>&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="16" height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule39" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953">
                            <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                              <tr style="height: 17px;">
                                <td width="269" id="Cell869">
                                  <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="system_logs.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&filter=#filter#&filter3=#filter3#&filter4=#filter4#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Entries</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                <td width="397" id="Cell870">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center">
                                        <table width="242" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="margin-bottom: 0px;"><cfif #totalevents# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #totalevents# total Entries.</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="287" id="Cell871">
                                  <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE totalevents>
<A HREF="system_logs.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&filter=#filter#&filter3=#filter3#&filter4=#filter4#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (totalevents - Next) LT DisplayRows>
      #Evaluate((totalevents - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Entries&nbsp; &gt;&gt;</SPAN></b></P></A>
<CFELSE>
  
</CFIF>
</CFOUTPUT>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td width="952"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952" id="Text226" class="TextObject">
                            <p style="margin-bottom: 0px;">
<table id="Table163" border="0" cellspacing="11" cellpadding="2" width="100%" style="height: 25px;" class="bottomBorder">
  <tr style="height: 14px;">
    <td width="150" id="Cell1017">
      <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Date/Time</span></b></p>
    </td>
    <td width="780" id="Cell1018">
      <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Message</span></b></p>
    </td>
    <td width="82" id="Cell1019">
      <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Facility</span></b></p>
    </td>
  </tr>
<cfoutput query="getlogs">

<cfset date = #DateFormat(ReceivedAt, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(ReceivedAt, "HH:mm:ss")#>
  <tr style="height: 13px;">
    <td id="Cell1020">
      <p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">#date# #time#</span></p>
    </td>
    <td id="Cell1021">
      <p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">#Message#</span></p>
    </td>
    <td id="Cell1022">
<cfif #SysLogTag# contains 'kernel'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SYSTEM</span></p>

<cfelseif #SysLogTag# contains 'rsyslogd'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">LOGGING SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/qmgr'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">QUEUE SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/smtpd['>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SMTP SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/smtp'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SMTP CLIENT</span></p>

<cfelseif #SysLogTag# contains 'amavis'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">ANTI SPAM/VIRUS FILTER</span></p>

<cfelseif #SysLogTag# contains 'postfix/postscreen'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">PERIMETER CHECK SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/dnsblog'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">RBL SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/master'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SMTP MASTER</span></p>

<cfelseif #SysLogTag# contains 'postfix/tlsmgr'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">TLS SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/policy-spf'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SPF SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/cleanup'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SMTP CLEANUP SERVICE</span></p>

<cfelseif #SysLogTag# contains 'postfix/anvil'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SMTP THROTTLE SERVICE</span></p>

<cfelseif #SysLogTag# contains 'CRON'>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;">SYSTEM SCHEDULER</span></p>

<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: 'Courier New', 'Lucida Console', Courier, Monaco, Monospace; font-size: 8pt;"></span></p>
</cfif>

    </td>
  </tr>
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