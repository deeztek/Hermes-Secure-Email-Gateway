<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script><!--
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
<title>User Quarantine New</title>
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
        <td><cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "50"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

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

<cfparam name = "s" default = ""> 
<cfif IsDefined("url.s") is "True">
<cfif url.s is not "">
<cfset s = url.s>
</cfif></cfif>

<cfparam name = "f" default = ""> 
<cfif IsDefined("url.f") is "True">
<cfif url.f is not "">
<cfset f = url.f>
</cfif></cfif>

<cfparam name = "a" default = ""> 
<cfif IsDefined("url.a") is "True">
<cfif url.a is not "">
<cfset a = url.a>
</cfif></cfif>


<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "searchtype2" default = ""> 
<cfif IsDefined("session.searchtype2") is "True">
<cfif session.searchtype2 is not "">
<cfset searchtype2 = session.searchtype2>
</cfif></cfif> 


<cfparam name = "searchfor" default = ""> 

<cfif IsDefined("session.searchfor") is "True">
<cfif session.searchfor is not "">
<cfset searchfor = session.searchfor>
</cfif>
</cfif>


<cfparam name = "msgno" default = ""> 
<cfif IsDefined("url.msgno") is "True">
<cfif url.msgno is not "">
<cfset msgno = url.msgno>
</cfif></cfif>  

<cfparam name = "m3" default = ""> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
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

<cfparam name = "filter5" default = ""> 
<cfif #action# is "search">
<cfif IsDefined("session.filter5") is "True">
<cfif session.filter5 is not "">
<cfset filter5 = session.filter5>
</cfif>
</cfif>
</cfif>

<cfparam name = "sortby" default = ""> 
<cfif IsDefined("session.sortby") is "True">
<cfif session.sortby is not "">
<cfset sortby = session.sortby>
</cfif></cfif>

<cfparam name = "startdate" default = ""> 
<cfif IsDefined("url.startdate") is "True">
<cfif url.startdate is not "">
<cfif isValid("date", #url.startdate#)> 
<cfset startdate = url.startdate>
<cfelseif NOT isValid("date", #url.startdate#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("url.enddate") is "True">
<cfif url.enddate is not "">
<cfif isValid("date", #url.enddate#)> 
<cfset enddate = url.enddate>
<cfelseif NOT isValid("date", #url.enddate#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "starttime" default = ""> 
<cfif IsDefined("url.starttime") is "True">
<cfif url.starttime is not "">
<cfif isValid("time", #url.starttime#)> 
<cfset starttime = url.starttime>
<cfelseif NOT isValid("time", #url.starttime#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "endtime" default = ""> 
<cfif IsDefined("url.endtime") is "True">
<cfif url.endtime is not "">
<cfif isValid("time", #url.endtime#)> 
<cfset endtime = url.endtime>
<cfelseif NOT isValid("time", #url.endtime#)>
<cflocation url="error.cfm" addtoken="no">
</cfif>
</cfif>
</cfif>

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

<cfif #action# is "search">

<cfif #searchtype2# is "advanced">

<cfif #sortby# is "">


<cfif #searchfor# is "from_addr" OR #searchfor# is "subject">

<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive,  msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' group
 by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>


<cfelseif #searchfor# is "none">

<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset starttime2 = #TimeFormat(starttime, "HH:mm:ss")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>
<cfset endtime2 = #TimeFormat(endtime, "HH:mm:ss")#>


<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive,  msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.time_iso between
 '#startdate2# #starttime2#' and '#enddate2# #endtime2#' 
group by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>

<!-- /CFIF for searchfor -->
</cfif>

<cfelseif #sortby# is not "">

<cfif #searchfor# is "from_addr" OR #searchfor# is "subject">

<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive,  msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.#searchfor# Collate utf8_general_ci like '%#filter5#%' and msgs.content like binary '#sortby#' group
 by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>


<cfelseif #searchfor# is "none">

<cfset startdate2 = #DateFormat(startdate, "yyyy-mm-dd")#>
<cfset starttime2 = #TimeFormat(starttime, "HH:mm:ss")#>
<cfset enddate2 = #DateFormat(enddate, "yyyy-mm-dd")#>
<cfset endtime2 = #TimeFormat(endtime, "HH:mm:ss")#>


<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.time_iso between '#startdate2# #starttime2#' and '#enddate2#
 #endtime2#' group by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>

<!-- /CFIF for searchfor -->
</cfif>

<!-- /CFIF for sortby -->
</cfif>

<!-- /CFIF for searchtype2 -->
</cfif>

<cfelse>

<cfif #sortby# is "">


<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive,  msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' group by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#,
 #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>

<cfelseif #sortby# is not "">


<cfquery name="getmsgs" datasource="#datasource#">
SELECT SQL_CALC_FOUND_ROWS msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr,
 msgs.content, msgs.archive,  msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.content like binary '#sortby#' 
group by msgrcpt.mail_id order by msgs.time_iso desc limit #StartRow#, #DisplayRows#
</cfquery>

<cfquery name="getevents" datasource="#datasource#">
SELECT FOUND_ROWS() as count
</cfquery>

<cfset totalevents=#getevents.count#>

<!-- /CFIF for sortby-->
</cfif>

<!-- /CFIF for emailexists.recordcount -->
</cfif>

<CFIF ToRow GT totalevents>
<CFSET ToRow = totalevents>
</CFIF>



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
                          <td width="755"><!--<img id="AllWebMenusComponent1" height="19" width="755" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu_users.js' AWMJSPATH='./hermes_seg_menu_users.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu_users'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="428" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion9" style="background-image: url('./middle_988.png'); height: 428px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="11"></td>
                                <td width="460">
                                  <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 30px;">
                                    <tr style="height: 30px;">
                                      <td width="460" id="Cell1049">
                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="613">
                              <tr valign="top" align="left">
                                <td width="13" height="1"></td>
                                <td width="600"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="600" id="Text462" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">History &amp; Archive for&nbsp; #session.email#</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="354">
                              <tr valign="top" align="left">
                                <td width="9" height="6"></td>
                                <td width="320"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/history-archive/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="4"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="345" id="Text455" class="TextObject"><cfquery name="getrid" datasource="#datasource#">
select id, email from maddr where email='#session.email#'
</cfquery>

<cfquery name="getearliest" datasource="#datasource#">
SELECT msgs.sid, msgs.mail_id, msgs.time_iso as earliest, msgrcpt.mail_id from msgrcpt RIGHT JOIN msgs 
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#getrid.id#' order by msgs.time_iso asc limit 1 
</cfquery>
<cfset earliestdate = #DateFormat(getearliest.earliest, "mm/dd/yyyy")#>
<cfset earliesttime = #TimeFormat(getearliest.earliest, "HH:mm:ss")#>

<cfoutput>
                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;"><b><span style="font-size: 12px;">Earliest Message Date/Time:</span></b> #earliestdate# #earliesttime#</span></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule7" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="14" height="3"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="596">
                                  <form name="Table144FORM" action="<cfoutput>user_quarantine_filter.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                                    <input type="hidden" name="setfilter" value="1">
                                    <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                      <tr style="height: 25px;">
                                        <td width="250" id="Cell865">
                                          <table width="212" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfquery name="msg_types" datasource="#datasource#">
select * from msg_content_type where user='1' order by description asc
</cfquery>
<cfif #sortby# is "">
<select name="sortby" style="height: 24px;">
  <option value="" selected="selected">ALL</option>
  <cfoutput query="msg_types">
 <option value="#content_type#">#description#</option>
</cfoutput>
</select>
<cfelseif #sortby# is not "">
<select name="sortby" style="height: 24px;">
<cfquery name="getdesc" datasource="#datasource#">
select description from msg_content_type where content_type like binary '#sortby#'
</cfquery>
<cfoutput>
  <option value="#sortby#" selected="selected">#getdesc.description#</option>
</cfoutput>
  <cfoutput query="msg_types">
 <option value="#content_type#">#description#</option>
</cfoutput>
<option value="">ALL</option>
</select>
</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td width="346" id="Cell866">
                                          <table width="276" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear & Sort" style="height: 24px; width: 175px;">&nbsp;</p>
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
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="11" height="3"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="346">
                                  <form name="Table167FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                                    <input type="hidden" name="todo" value="displayrows">
                                    <table id="Table167" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 2px;">
                                      <tr style="height: 24px;">
                                        <td width="185" id="Cell1047">
                                          <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">No of Msgs to display</span></p>
                                        </td>
                                        <td width="85" id="Cell1048">
                                          <table width="72" border="0" cellspacing="0" cellpadding="0" align="right">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #DisplayRows# is "25">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="25" selected="selected">25</option>
  <option value="50">50</option>
  <option value="75">75</option>
  <option value="100">100</option>
  </select>

<cfelseif #DisplayRows# is "50">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="50" selected="selected">50</option>
  <option value="25">25</option>
  <option value="75">75</option>
  <option value="100">100</option>
  </select>

<cfelseif #DisplayRows# is "75">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="75" selected="selected">75</option>
  <option value="25">25</option>
  <option value="50">50</option>
  <option value="100">100</option>
  </select>

<cfelseif #DisplayRows# is "100">
<select id="FormsComboBox1" name="displayrows" style="height: 24px;">
  <option value="100" selected="selected">100</option>
  <option value="25">25</option>
  <option value="50">50</option>
  <option value="75">75</option>
  </select>

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td width="76" id="Cell1051">
                                          <table width="63" border="0" cellspacing="0" cellpadding="0" align="right">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" value="Go" style="height: 24px; width: 48px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="14" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955">
                            <form name="advanced" action="<cfoutput>user_quarantine_filter_advanced.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
                              <input type="hidden" name="setfilter2" value="1">
                              <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 45px;">
                                <tr style="height: 17px;">
                                  <td width="161" id="Cell1036">
                                    <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 12px;">Search Phrase</span></p>
                                  </td>
                                  <td width="96" id="Cell1035">
                                    <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 12px;">Search Field(s)</span></p>
                                  </td>
                                  <td width="34" id="Cell1033">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                  <td width="98" id="Cell1032">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Start Date</span></p>
                                  </td>
                                  <td width="103" id="Cell1042">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Start Time</span></p>
                                  </td>
                                  <td width="33" id="Cell1044">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                  <td width="99" id="Cell1031">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">End Date</span></p>
                                  </td>
                                  <td width="102" id="Cell1038">
                                    <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">End Time</span></p>
                                  </td>
                                  <td width="229" id="Cell1028">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                </tr>
                                <tr style="height: 28px;">
                                  <td id="Cell1018">
                                    <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField42" name="filter5" size="15" maxlength="255" style="width: 116px; white-space: pre;" value="#filter5#">
</cfoutput>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1021">
                                    <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #searchfor# is "">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
  <option value="none" selected="selected">DATE</option>
  <option value="from_addr">FROM</option>
  <option value="subject">SUBJECT</option>
  

</select>

<cfelseif #searchfor# is "from_addr">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="from_addr" selected="selected">FROM </option>
</cfoutput>
  <option value="subject">SUBJECT </option>

<option value="none">DATE</option>
  

</select>


<cfelseif #searchfor# is "subject">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="subject" selected="selected">SUBJECT </option>
</cfoutput>
  <option value="from_addr">FROM </option>

<option value="none">DATE</option>
  

</select>



<cfelseif #searchfor# is "none">
<select id="FormsComboBox1" name="searchfor" style="height: 24px;">
<cfoutput>
  <option value="none" selected="selected">DATE </option>
</cfoutput>
  <option value="from_addr">FROM </option>

  <option value="subject">SUBJECT </option>
  


</select>


</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1019">
                                    <table width="20" border="0" cellspacing="0" cellpadding="0" align="right">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('advanced',%20'startdate')"><img id="Picture49" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1026">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="80" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="startdate" size="10" maxlength="10" style="width: 76px; white-space: pre;" value="#startdate#">
</cfoutput>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1043">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="77" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfset stime = CreateTime(01,0,0)> 
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

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1045">
                                    <table width="20" border="0" cellspacing="0" cellpadding="0" align="right">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('advanced',%20'enddate')"><img id="Picture50" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1027">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="80" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="enddate" size="10" maxlength="10" style="width: 76px; white-space: pre;" value="#enddate#">
</cfoutput>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1039">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="77" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #endtime# is "">
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

</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1020">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" value="Advanced Search" style="height: 24px; width: 171px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="15" height="1"></td>
                          <td width="953"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953" id="Text441" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m5# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
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
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select NONE in the Search Field, ensure Keyword1 field is blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;when you select KEYWORD1 in the Search Mode field, ensure Keyword1 field is NOT blank and Keyword2 field IS blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m5# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the keyword field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "notfound">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the message you attempted to view was not found. This is usually due to the fact that the message was either released and/or deleted by the user and/or the system</span></i></b></p>
</cfoutput>
</cfif>



&nbsp;</p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b><span style="color: rgb(255,0,0);">*</span></b><i><b><span style="color: rgb(255,0,0);">Please note:</span></b> When performing searches yields no results, ensure that the message type is set to ALL and then perform your search again. The search function takes the message type into consideration when performing searches. For example, if the message type is set to Spam(Quarantined) and you search the body for a keyword, the system will only search for the keyword in the body for messages that are of type Spam(Quarantined).</i></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule6" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="954">
                            <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                              <tr style="height: 17px;">
                                <td width="262" id="Cell869">
                                  <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m5# is "">
<CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="loading.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Messages</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                <td width="416" id="Cell870">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center">
                                        <table width="242" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="margin-bottom: 0px;"><cfif #m5# is "">
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #totalevents# total messages.</span></p>
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
                                <td width="276" id="Cell871">
                                  <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="text-align: right; margin-bottom: 0px;"><cfif #m5# is "">
<cfoutput>
<CFIF Next LTE totalevents>
<A HREF="loading.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (totalevents - Next) LT DisplayRows>
      #Evaluate((totalevents - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Messages&nbsp; &gt;&gt;</SPAN></b></P></A>
<CFELSE>
  
</CFIF>
</CFOUTPUT>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td width="956"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="956" id="Text453" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Message has been released</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to release message. This usually happens if the message does not exist or if the message has been archived. Archived messages cannot be released. They can only be viewed or downloaded individually</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the message you are attempting to view does not exist</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the system was unable to retrieve the archived message you are attempting to view. Ask your administrator to ensure that an archive job that points to the correct archived messages share exists and that the share is succesfully mounted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Allow Sender">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully allow #s# sender(s). <cfif #f# GTE 1>However it was NOT able to allow #f# sender(s). This is usually caused by the fact that the sender(s) already exist</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Block Sender">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully block #s# sender(s). <cfif #f# GTE 1>However it was NOT able to block #f# sender(s). This is usually caused by the fact that the sender(s) already exist</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Release Msg">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully release #s# message(s). <cfif #f# GTE 1>However it was NOT able to release #f# message(s). This is usually caused by the fact that some of the messages you selected were not quarantined or they were already released or they were archived. Archived messages cannot be released. They can only be viewed or downloaded individually</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Delete Msg">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system processed your request and it was able to successfully delete #s# message(s). <cfif #f# GTE 1>However it was NOT able to delete #f# message(s). This is usually caused by the fact that some of the messages you selected were already deleted</cfif>
</span></i></b></p>
</cfoutput>
</cfif>

<cfif #a# is "Train as Spam">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system was able to train the Spam/Virus Filter with #s# message(s) as Spam. <cfif #f# GTE 1>However, the system was NOT able to train the Spam/Virus filter with #f# message(s). This is usually caused by the fact that some of the messages you selected were already processed, or they have been archived. Archived messages cannot be used to train the Spam/Virus filter. Please note that it may take multiple times for the Spam/Virus filter to start recognizing certain e-mails as Spam</cfif>
</span></i></b></p>
</cfoutput>
</cfif>


<cfif #a# is "Train as NOT Spam">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;The system was able to train the Spam/Virus Filter with #s# message(s) as NOT Spam. <cfif #f# GTE 1>However, the system was NOT able to train the Spam/Virus filter with #f# message(s). This is usually caused by the fact that some of the messages you selected were already processed, or they have been archived. Archived messages cannot be used to train the Spam/Virus filter.  Please note that it may take multiple times for the Spam/Virus filter to start recognizing certain e-mails as NOT Spam</cfif>
</span></i></b></p>
</cfoutput>
</cfif>
&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td width="953"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953" id="Text465" class="TextObject">
                            <p style="margin-bottom: 0px;">&nbsp;</p>
                            <cfif #m5# is "">
<cfif #totalevents# GTE 1>
<form name="edit" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#</cfoutput>" method="post">
<hr id="HRRule8" width="955" size="1">

<table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 30px;">
    <td width="138" id="Cell1046">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          
<td><input type="submit" id="FormsButton1" name="todo" value="Block Sender" style="height: 24px; width: 153px;"></td>


        </tr>
      </table>
    </td>
    <td width="138" id="Cell1047">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
<td><input type="submit" id="FormsButton1" name="todo" value="Allow Sender" style="height: 24px; width: 153px;"></td>

          
        </tr>
      </table>
    </td>
    <td width="138" id="Cell1048">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Release Msg" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
<cfquery name="getusertrainfilter" datasource="#datasource#">
select value from spam_settings where parameter = 'user_portal_spam_training'
</cfquery>

<cfif #session.train_bayes# EQ 1> 

<cfquery name="getbayes" datasource="#datasource#">   
SELECT parameter, value FROM spam_settings where parameter = 'use_bayes'
</cfquery>

<cfif #getbayes.value# EQ 1>  

<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as Spam" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as NOT Spam" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>

<cfelseif #getbayes.value# EQ 0> 

<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as Spam" disabled="disabled" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as NOT Spam" disabled="disabled" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>

</cfif>

<cfelseif #session.train_bayes# EQ 0>  
<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as Spam" disabled="disabled" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>
<td width="138" id="Cell1049">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="left">
        <tr>
          <td><input type="submit" id="FormsButton1" name="todo" value="Train as NOT Spam" disabled="disabled" style="height: 24px; width: 153px;"></td>
        </tr>
      </table>
    </td>

</cfif>


  </tr>
</table>
<hr id="HRRule8" width="955" size="1">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Archived</span></b></p>
    </td>

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Date/Time</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">From</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Subject</span></b></p>
    </td>
    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Spam Score</span></b></p>
    </td>
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type(Action)</span></b></p>
    </td>


<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View</span></b></p>
    </td>
  
    
  </tr>
<cfoutput query="getmsgs">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">


     
<td align="center">
<input type="checkbox" name="cbox#mail_id#" value="#mail_id#|#secret_id#" style="height: 13px; width: 13px;">
</td>


 <td id="Cell1055">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#archive# </span></p>
</div>
    </td>


    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#date# #time# </span></p>
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="#datasource#">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#getfromaddr.fromAddress#</span></p>
</div>
    </td>
    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#subject#</span></p>
</div>
    </td>

    <td id="Cell1061">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#Numberformat (spam_level, '____.__')#</span></p>
</div>
    </td>




<cfquery name="gettype" datasource="#datasource#">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>



    <td id="Cell1062">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#gettype.description#</span></p>
</div>
    </td>


<td align="center"><a href="loading2.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="view_icon.png" border="0" alt="View Message" title="View Message"></td>
        

</cfoutput>
        </tr>
      </table>
</form>

<cfelseif #totalevents# LT 1>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(255,0,0);">No Results Found</span></p>
 
</cfif>
      
</cfif></td>
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
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput></span>&nbsp;</p>
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