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
<title>Sender Filters</title>
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
              <td height="606" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion11" style="background-image: url('./middle_988.png'); height: 606px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="821">
                              <tr valign="top" align="left">
                                <td width="13" height="15"></td>
                                <td width="808"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="808" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Sender Filters for #session.email#</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="146">
                              <tr valign="top" align="left">
                                <td width="121" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/sender-filters/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule7" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="13" height="2"></td>
                          <td width="954"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="954" id="Text440" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enter an e-mail address or a domain in the <b>Sender Domain or Email Address</b> field below, select whether you wish to <b>Block (Blacklist)</b> or <b>Allow (Whitelist)</b> and click the <b>Add</b> button. If you wish to add an entire domain and all of&nbsp; its sub-domains, enter <b>.domain.tld</b> where domain.tld is the domain you wish to add. Note the &#8220;<b>.</b>&#8221; in front of the domain. <b>It is HIGHLY recommended NOT to allow entire domains such as gmail.com or your mailbox will be inundated with spam.</b></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule13" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="12" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953">
                            <table id="Table3" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 193px;">
                              <tr style="height: 176px;">
                                <td width="953" id="Cell12">
                                  <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfparam name = "show_type" default = "block"> 
<cfif IsDefined("form.type") is "True">
<cfif form.type is not "">
<cfset show_type = form.type>
</cfif></cfif> 





                                        <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion5" style="height: 176px;">
                                          <tr align="left" valign="top">
                                            <td>
                                              <table border="0" cellspacing="0" cellpadding="0" width="953">
                                                <tr valign="top" align="left">
                                                  <td width="7" height="7"></td>
                                                  <td></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td height="138"></td>
                                                  <td width="946"><cfparam name = "sendertype" default = ""> 

<cfquery name="getrecipientid" datasource="#datasource#">
select id, recipient from recipients where recipient='#session.email#'
</cfquery>
<cfset recipient = #getrecipientid.id#>

<cfif #show_type# is "block">
<cfif #action# is "add">

<cfif #sender# is not "">
<cfif REFIND("[@]",sender) gt 0>
<cfset step=1>
<cfset sendertype="email">
<cfelse>
<cfset step=2>
<cfset sendertype="domain">
</cfif>
<cfelseif #sender# is "">
<cfset step=0>
<cfset m2=1>
</cfif>


<cfif step is "1">
<cfif IsValid("email", sender)>
<cfset compare_email = Compare(session.email, sender)>
<cfif #compare_email# is "1">
<cfset step=3>

<cfelseif #compare_email# is "-1">
<cfset step=3>

<cfelseif #compare_email# is "0">
<cfset m2=5>
<cfset step=0>
</cfif>
<cfelseif not IsValid("email", sender)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>

<cfif step is "2">
<cfif #trim(left(sender, 1))# EQ "."> 
<cfset temp_email="bob@temp#sender#">
<cfelseif #trim(left(sender, 1))# NEQ "."> 
<cfset temp_email="bob@#sender#">
</cfif>
<cfif IsValid("email", temp_email)>
<cfset domainpart = #trim(ListGetAt(session.email, 2, "@"))#>
<cfset compare_domain = Compare(#sender#, #domainpart#)>
<cfif #compare_domain# is "1">
<cfset step=3>
<cfelseif #compare_domain# is "-1">
<cfset step=3>
<cfelseif #compare_domain# is "0">
<cfset step=0>
<cfset m2=8>
</cfif>

<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>

<cfif step is "3">

<cfif #sendertype# is "email">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#session.email#' and sender='#sender#'
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#session.email#' and sender='@#sender#'
</cfquery>
</cfif>

<cfif #checkexists.recordcount# LT 1>

<cfif #sendertype# is "email">
<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='#sender#'
</cfquery>
<cfelseif #sendertype# is "domain">
<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='@#sender#'
</cfquery>
</cfif>


<cfif #checksenderemail.recordcount# LT 1>

<cfif #sendertype# is "email">
<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('#sender#')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('@#sender#')
</cfquery>
</cfif>

<cfif #sendertype# is "email">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'BLOCK', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'B')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '@#sender#', 'BLOCK', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'B')
</cfquery>
</cfif>

<cfset step=0>
<cfset m2=4>

<cfelseif #checksenderemail.recordcount# GTE 1>

<cfif #sendertype# is "email">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'BLOCK', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'B')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '@#sender#', 'BLOCK', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'B')
</cfquery>

</cfif>

<cfset step=0>
<cfset m2=4>

</cfif>



<cfelseif #checkexists.recordcount# GTE 1>
<cfset step=0>
<cfset m2=3>

</cfif>

</cfif>

</cfif>



<cfelseif #show_type# is "allow">
<cfif #action# is "add">

<cfif #sender# is not "">
<cfif REFIND("[@]",sender) gt 0>
<cfset step=1>
<cfset sendertype="email">
<cfelse>
<cfset step=2>
<cfset sendertype="domain">
</cfif>
<cfelseif #sender# is "">
<cfset step=0>
<cfset m2=1>
</cfif>


<cfif step is "1">
<cfif IsValid("email", sender)>
<cfset compare_email = Compare(session.email, sender)>
<cfif #compare_email# is "1">
<cfset step=3>

<cfelseif #compare_email# is "-1">
<cfset step=3>

<cfelseif #compare_email# is "0">
<cfset m2=5>
<cfset step=0>
</cfif>
<cfelseif not IsValid("email", sender)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>

<cfif step is "2">
<cfif #trim(left(sender, 1))# EQ "."> 
<cfset temp_email="bob@temp#sender#">
<cfelseif #trim(left(sender, 1))# NEQ "."> 
<cfset temp_email="bob@#sender#">
</cfif>
<cfif IsValid("email", temp_email)>
<cfset domainpart = #trim(ListGetAt(session.email, 2, "@"))#>
<cfset compare_domain = Compare(#sender#, #domainpart#)>
<cfif #compare_domain# is "1">
<cfset step=3>
<cfelseif #compare_domain# is "-1">
<cfset step=3>
<cfelseif #compare_domain# is "0">
<cfset step=0>
<cfset m2=8>
</cfif>

<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>

<cfif step is "3">
<!-- UNUSED
<cfquery name="checkexists" datasource="#datasource#">
SELECT wb FROM wblist,mailaddr WHERE (wblist.rid=#recipient#) 
AND (wblist.sid=mailaddr.id) AND (mailaddr.email IN ('#sender#'))
</cfquery>
-->

<cfif #sendertype# is "email">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#session.email#' and sender='#sender#'
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#session.email#' and sender='@#sender#'
</cfquery>
</cfif>

<cfif #checkexists.recordcount# LT 1>

<cfif #sendertype# is "email">
<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='#sender#'
</cfquery>
<cfelseif #sendertype# is "domain">
<cfquery name="checksenderemail" datasource="#datasource#">
select id, email from mailaddr where email='@#sender#'
</cfquery>
</cfif>


<cfif #checksenderemail.recordcount# LT 1>
<cfif #sendertype# is "email">
<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('#sender#')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="insertsender" datasource="#datasource#" result="stSender">
insert into mailaddr
(email)
values
('@#sender#')
</cfquery>
</cfif>

<cfif #sendertype# is "email">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'ALLOW', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'W')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '@#sender#', 'ALLOW', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#stSender.GENERATED_KEY#', 'W')
</cfquery>
</cfif>

<cfset step=0>
<cfset m2=4>

<cfelseif #checksenderemail.recordcount# GTE 1>

<cfif #sendertype# is "email">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'ALLOW', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'W')
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '@#sender#', 'ALLOW', 'insert', '#session.email#', '1')
</cfquery>

<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient#', '#checksenderemail.id#', 'W')
</cfquery>

</cfif>

<cfset step=0>
<cfset m2=4>

</cfif>



<cfelseif #checkexists.recordcount# GTE 1>
<cfset step=0>
<cfset m2=3>

</cfif>

</cfif>


</cfif>
</cfif>







                                                    <form name="block" action="<cfoutput>user_filters.cfm</cfoutput>" method="post">
                                                      <input type="hidden" name="action" value="add">
                                                      <table border="0" cellspacing="0" cellpadding="0" width="472">
                                                        <tr valign="top" align="left">
                                                          <td colspan="2" width="472" id="Text424" class="TextObject">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Sender Domain or Email Address</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td height="2"></td>
                                                          <td width="32"></td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td height="22" width="440"><input type="text" id="FormsEditField39" name="sender" size="55" maxlength="255" style="width: 436px; white-space: pre;"></td>
                                                          <td></td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td colspan="2" height="11"></td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td colspan="2" width="472" id="Text432" class="TextObject">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Select Action</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr valign="top" align="left">
                                                          <td height="1"></td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td width="487">
                                                            <table id="Table154" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell936">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_type# is "block">
<cfoutput>
<input type="radio" name="type" value="block" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="block" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell937">
                                                                  <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Block</span></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell938">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #show_type# is "allow">
<cfoutput>
<input type="radio" name="type" value="allow" checked="checked" style="height: 19px; width: 19px;">
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="allow" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell939">
                                                                  <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Allow</span></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr valign="top" align="left">
                                                          <td height="3"></td>
                                                        </tr>
                                                        <tr valign="top" align="left">
                                                          <td width="946">
                                                            <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                              <tr style="height: 24px;">
                                                                <td width="946" id="Cell934">
                                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td align="center">
                                                                        <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                                          <tr>
                                                                            <td class="TextObject">
                                                                              <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">&nbsp;</p>
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
                                                <tr valign="top" align="left">
                                                  <td colspan="2" height="8"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td></td>
                                                  <td width="946" id="Text277" class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field must be a valid domain or e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Entry successfully added!!</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you cannot use your own e-mail address as the Sender Email Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you cannot use your own e-mail address domain as the Sender Domain</span></i></b></p>
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
                                <td id="Cell15">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule8" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="14" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955" id="Text441" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Select an entry from the list below and click the <b>Delete</b> button to remove from your Sender Domain &amp; E-mail Address Filter</span></p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule12" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="960">
                            <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 119px;">
                              <tr style="height: 102px;">
                                <td width="960" id="Cell9">
                                  <table width="960" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td><cfquery name="getmailaddrtemp" datasource="#datasource#">
select * from mailaddr_temp where applied='1' and receiver='#session.email#' order by sender asc
</cfquery>

<cfparam name = "sender_bypass" default = ""> 
<cfif IsDefined("form.sender_bypass") is "True">
<cfif form.sender_bypass is not "">
<cfset sender_bypass = form.sender_bypass>
</cfif></cfif> 


<cfif #action# is "delete">
<cfif #sender_bypass# is not "">
<cfset step=1>
<cfelseif #sender_bypass# is "">
<cfset step=0>
<cfset m1=1>
</cfif>


<cfif #step# is "1">
<cfquery name="getid" datasource="#datasource#">
select recipient_id, mailaddr_id from mailaddr_temp where id='#sender_bypass#'
</cfquery>

<cfquery name="deletewb" datasource="#datasource#">
delete from wblist where rid='#getid.recipient_id#' and sid='#getid.mailaddr_id#'
</cfquery>

<cfquery name="delete" datasource="#datasource#">
delete from mailaddr_temp where id='#sender_bypass#'
</cfquery>

<cfset m1=2>
<cfoutput>
<cflocation url="user_filters.cfm?m1=2##delete">
</cfoutput>
</cfif>
</cfif>
                                        <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion4" style="height: 102px;">
                                          <tr align="left" valign="top">
                                            <td>
                                              <table border="0" cellspacing="0" cellpadding="0" width="960">
                                                <tr valign="top" align="left">
                                                  <td width="13" height="8"></td>
                                                  <td width="609"></td>
                                                  <td width="338"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td height="50"></td>
                                                  <td colspan="2" width="947">
                                                    <form name="delete" action="user_filters.cfm#delete" method="post">
                                                      <input type="hidden" name="action" value="delete">
                                                      <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr valign="top" align="left">
                                                          <td width="947">
                                                            <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 50px;">
                                                              <tr style="height: 24px;">
                                                                <td width="947" id="Cell7">
                                                                  <table width="529" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.recordcount# GTE 1>
<select name="sender_bypass" style="height: 88px;" size="300">
<cfoutput query="getmailaddrtemp">
<option value="#id#"> #sender# --> #wb#</option>
</cfoutput>
</select>
<cfelse>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No existing Block/Allow Entries Found...</span></i></b></p>
</cfif>
&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 26px;">
                                                                <td id="Cell1">
                                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td align="center">
                                                                        <table width="68" border="0" cellspacing="0" cellpadding="0">
                                                                          <tr>
                                                                            <td class="TextObject">
                                                                              <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #getmailaddrtemp.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" disabled="disabled">
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
                                                    </form>
                                                  </td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="3" height="10"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td></td>
                                                  <td width="609" id="Text276" class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Block/Allow Entry deleted successfully!!</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>
&nbsp;</p>
                                                  </td>
                                                  <td></td>
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
                                <td id="Cell10">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
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