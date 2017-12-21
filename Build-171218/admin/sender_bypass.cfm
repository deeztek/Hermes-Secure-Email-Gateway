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
<title>Sender Checks Bypass</title>
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
              <td height="920" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion27" style="background-image: url('./middle_988.png'); height: 920px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="520">
                              <tr valign="top" align="left">
                                <td width="14" height="15"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text485" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Sender Check Bypass</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text486" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Sender Check Bypass</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="450">
                              <tr valign="top" align="left">
                                <td width="425" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/sender-checks-bypass/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="13" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="317"></td>
                          <td width="954"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "m4" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "show_type" default = "block"> 
<cfif IsDefined("form.type") is "True">
<cfif form.type is not "">
<cfset show_type = form.type>
</cfif></cfif> 

<cfparam name = "sendertype" default = ""> 

<cfparam name = "sender" default = ""> 
<cfif IsDefined("form.sender") is "True">
<cfif form.sender is not "">
<cfset sender = form.sender>
</cfif></cfif> 

<cfparam name = "recipient" default = ""> 
<cfif IsDefined("form.recipient") is "True">
<cfif form.recipient is not "">
<cfset recipient = form.recipient>
</cfif></cfif> 


<cfif #action# is "canceladd">
<cfquery name="canceladd" datasource="#datasource#">
delete from mailaddr_temp where action='insert' and applied='2'   
</cfquery>
<cflocation url="sender_bypass.cfm?m2=7">

<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
update mailaddr_temp set action='NONE', applied='1' where action='delete' and applied='2'  
</cfquery>
<cflocation url="sender_bypass.cfm?m1=5##delete">
</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion5" style="height: 317px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td height="195" width="954"><cfif #show_type# is "block">
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
<cfquery name="getrecemail" datasource="#datasource#">
select recipient, domain from recipients where id='#recipient#'
</cfquery>
<cfset senderdomainpart = #trim(ListGetAt("#sender#", 2, "@"))#>
<cfif #getrecemail.domain# is not "1">
<cfset domainpart = #trim(ListGetAt("#getrecemail.recipient#", 2, "@"))#>
<cfelseif #getrecemail.domain# is "1">
<cfset domainpart = #REReplace("#getrecemail.recipient#","@","","ALL")#>
</cfif>

<cfset compare_email = Compare(#domainpart#, #senderdomainpart#)>
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
<cfquery name="getrecemail" datasource="#datasource#">
select recipient, domain from recipients where id='#recipient#'
</cfquery>
<cfif #trim(left(sender, 1))# EQ "."> 
<cfset temp_email="bob@temp#sender#">
<cfelseif #trim(left(sender, 1))# NEQ "."> 
<cfset temp_email="bob@#sender#">
</cfif>
<cfif IsValid("email", temp_email)>
<cfif #getrecemail.domain# is not "1">
<cfset domainpart = #trim(ListGetAt("#getrecemail.recipient#", 2, "@"))#>
<cfelseif #getrecemail.domain# is "1">
<cfset domainpart = #REReplace("#getrecemail.recipient#","@","","ALL")#>
</cfif>

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
SELECT receiver, sender from mailaddr_temp where receiver='#getrecemail.recipient#' and sender='#sender#'
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#getrecemail.recipient#' and sender='@#sender#'
</cfquery>
</cfif>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="getrecipientemail" datasource="#datasource#">
select id, recipient from recipients where id='#recipient#'
</cfquery>

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
<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">

<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#stSender.GENERATED_KEY#', '#sender#', 'BLOCK', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'BLOCK', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>


<cfelseif #sendertype# is "domain">

<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#stSender.GENERATED_KEY#', '@#sender#', 'BLOCK', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '@#sender#', 'BLOCK', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>

</cfif>

<cfset step=0>
<cfset m2=4>

<cfelseif #checksenderemail.recordcount# GTE 1>

<cfif #sendertype# is "email">

<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="checkifexists" datasource="#datasource#">
select recipient_id, mailaddr_id from mailaddr_temp where recipient_id = '#rec_id#' and mailaddr_id = '#checksenderemail.id#'
</cfquery>
<cfif #checkifexists.recordcount# LT 1>
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#checksenderemail.id#', '#sender#', 'BLOCK', 'insert', '#rec_email#', '2')
</cfquery>
<cfelse>
</cfif>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'BLOCK', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>

<cfelseif #sendertype# is "domain">
<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#checksenderemail.id#', '@#sender#', 'BLOCK', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '@#sender#', 'BLOCK', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>



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
<cfquery name="getrecemail" datasource="#datasource#">
select recipient, domain from recipients where id='#recipient#'
</cfquery>
<cfset senderdomainpart = #trim(ListGetAt("#sender#", 2, "@"))#>
<cfif #getrecemail.domain# is not "1">
<cfset domainpart = #trim(ListGetAt("#getrecemail.recipient#", 2, "@"))#>
<cfelseif #getrecemail.domain# is "1">
<cfset domainpart = #REReplace("#getrecemail.recipient#","@","","ALL")#>
</cfif>

<cfset compare_email = Compare(#domainpart#, #senderdomainpart#)>
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
<cfquery name="getrecemail" datasource="#datasource#">
select recipient, domain from recipients where id='#recipient#'
</cfquery>
<cfif #trim(left(sender, 1))# EQ "."> 
<cfset temp_email="bob@temp#sender#">
<cfelseif #trim(left(sender, 1))# NEQ "."> 
<cfset temp_email="bob@#sender#">
</cfif>
<cfif IsValid("email", temp_email)>
<cfif #getrecemail.domain# is not "1">
<cfset domainpart = #trim(ListGetAt("#getrecemail.recipient#", 2, "@"))#>
<cfelseif #getrecemail.domain# is "1">
<cfset domainpart = #REReplace("#getrecemail.recipient#","@","","ALL")#>
</cfif>

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
SELECT receiver, sender from mailaddr_temp where receiver='#getrecemail.recipient#' and sender='#sender#'
</cfquery>

<cfelseif #sendertype# is "domain">
<cfquery name="checkexists" datasource="#datasource#">
SELECT receiver, sender from mailaddr_temp where receiver='#getrecemail.recipient#' and sender='@#sender#'
</cfquery>
</cfif>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="getrecipientemail" datasource="#datasource#">
select id, recipient from recipients where id='#recipient#'
</cfquery>

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

<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#stSender.GENERATED_KEY#', '#sender#', 'ALLOW', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'ALLOW', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>

<cfelseif #sendertype# is "domain">
<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#stSender.GENERATED_KEY#', '@#sender#', 'ALLOW', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#stSender.GENERATED_KEY#', '@#sender#', 'ALLOW', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>



</cfif>

<cfset step=0>
<cfset m2=4>

<cfelseif #checksenderemail.recordcount# GTE 1>

<cfif #sendertype# is "email">
<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#checksenderemail.id#', '#sender#', 'ALLOW', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '#sender#', 'ALLOW', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>

<cfelseif #sendertype# is "domain">
<!-- Code to add support for mapping entire recipient domains starts here -->
<cfif #getrecemail.domain# is "1">

<cfquery name="getallrecipientsfordomain" datasource="#datasource#">
select id as rec_id, recipient as rec_email, domain from recipients where recipient like '%#domainpart#%' and domain is null
</cfquery>
<cfloop query="getallrecipientsfordomain">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#rec_id#', '#checksenderemail.id#', '@#sender#', 'ALLOW', 'insert', '#rec_email#', '2')
</cfquery>
</cfloop>
<!-- Code to add support for mapping entire recipient domains ends here -->
<cfelseif #getrecemail.domain# is not "1">
<cfquery name="add" datasource="#datasource#" result="stResult">
insert into mailaddr_temp
(recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
values
('#recipient#', '#checksenderemail.id#', '@#sender#', 'ALLOW', 'insert', '#getrecipientemail.recipient#', '2')
</cfquery>
</cfif>



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









                                        <form name="block" action="sender_bypass.cfm?action=add" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0" width="843">
                                            <tr valign="top" align="left">
                                              <td width="843" id="Text424" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter Sender Domain or Email Address below. If you wish to block/allow an entire domain and all its sub-domains, enter .domain.tld note the &#8220;.&#8221; in front</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="472">
                                            <tr valign="top" align="left">
                                              <td height="2"></td>
                                              <td width="32"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="22" width="440"><input type="text" id="FormsEditField39" name="sender" size="55" maxlength="255" style="width: 436px; white-space: pre;"></td>
                                              <td></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="2" height="14"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="2" width="472" id="Text423" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><span style="font-size: 12px; color: rgb(128,128,128);">Select internal recipient from the drop-down list below</span></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="590">
                                            <tr valign="top" align="left">
                                              <td width="590" height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="21" width="590" id="Text403" class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfquery name="getdomains" datasource="#datasource#">
select id, recipient, domain from recipients where domain = '1' order by recipient asc
</cfquery>

<cfquery name="getrecipients" datasource="#datasource#">
select id, recipient, domain from recipients where domain is NULL order by recipient asc
</cfquery>

<cfif #getrecipients.recordcount# GTE 1 AND #getrecipients.recordcount# GTE 1>
<select name="recipient" style="height: 24px;">
<cfoutput query="getdomains">
<option value="#id#">#recipient#</option>
</cfoutput>
<cfoutput query="getrecipients">
<option value="#id#">#recipient#</option>
</cfoutput>
</select>

<cfelseif #getrecipients.recordcount# GTE 1 AND #getrecipients.recordcount# LT 1>
<select name="recipient" style="height: 24px;">
<cfoutput query="getrecipients">
<option value="#id#">#recipient#</option>
</cfoutput>
</select>

<cfelseif #getrecipients.recordcount# LT 1 AND #getrecipients.recordcount# GTE 1>
<select name="recipient" style="height: 24px;">
<cfoutput query="getdomains">
<option value="#id#">#recipient#</option>
</cfoutput>
</select>

<cfelseif #getrecipients.recordcount# LT 1 AND #getrecipients.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">You do not have any internal recipients added to the system...</span></i></b></p>

</cfif>
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="472">
                                            <tr valign="top" align="left">
                                              <td width="472" height="14"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="472" id="Text432" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Select Action to take below</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="3"></td>
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
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Block Action</span></p>
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
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Allow Action</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="13"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="954">
                                                <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="954" id="Cell934">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><cfif #getrecipients.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #getrecipients.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" disabled="disabled">
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
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="954"><hr id="HRRule1" width="954" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Block/Allow Sender(s)&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="954" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters2" datasource="#datasource#">
select * from mailaddr_temp where action='insert' and applied='2' order by sender asc
</cfquery>
<cfif #get_parameters2.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters2">
<option value="#id#">#sender# --> #receiver# --> #show_type# --> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Block/Allow Sender(s) found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <form name="Table127FORM" action="sender_bypass.cfm?action=canceladd" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="954" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #get_parameters2.recordcount# GTE 1>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field must be a valid e-mail address or a valid domain</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender to Recipient mapping you are attempting to add already exists or is already set to be added</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Entry ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender and the Recipient domains cannot be the same</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender and the Recipient domains cannot be the same</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="442"></td>
                          <td width="1"></td>
                          <td width="3"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="5" valign="middle" width="953"><hr id="HRRule10" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="46"></td>
                          <td colspan="6" width="954"><cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "20"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfif #filter# is "">
<cfquery name="getmailaddrtemp" datasource="#datasource#">
select * from mailaddr_temp where applied='1' order by sender asc
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>
<cfquery name="getmailaddrtemp" datasource="#datasource#">
select * from mailaddr_temp where applied='1' and sender like '%#filter#%'OR receiver like '%#filter#%' order by sender asc
</cfquery>

<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion21" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="623">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="sender_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="setfilter" value="1">
                                                <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                                  <tr style="height: 25px;">
                                                    <td width="56" id="Cell864">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Filter By</span></p>
                                                    </td>
                                                    <td width="258" id="Cell865">
                                                      <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField41" name="filter" size="29" maxlength="29" style="width: 228px; white-space: pre;" value="#filter#"></cfoutput></p>
                                                    </td>
                                                    <td width="116" id="Cell866">
                                                      <table width="110" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set Filter" style="height: 24px; width: 87px;">&nbsp;</p>
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
                                            <td width="15"></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="sender_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="clearfilter" value="1">
                                                <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="178" id="Cell868">
                                                      <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear Filter" style="height: 24px; width: 105px;">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text381" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m4# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
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
                          <td colspan="9" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="4" valign="middle" width="952"><hr id="HRRule12" width="952" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="506" id="Text488" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Sender Check Bypass</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="220"></td>
                          <td colspan="5" width="951"><cfparam name = "sender_bypass" default = ""> 
<cfif IsDefined("form.sender_bypass") is "True">
<cfif form.sender_bypass is not "">
<cfset sender_bypass = form.sender_bypass>
</cfif></cfif> 


<cfif #action# is "delete">
<cfif IsDefined("form.fieldnames")> 
<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cbox'>
<cfoutput>
<cfset theID = "#evaluate(thefield)#">
<cfquery name="delete" datasource="#datasource#">
update mailaddr_temp set applied='2', action='delete' where id='#theID#'
</cfquery>
</cfoutput>
</cfif>
</cfloop>

<cfset m1=2>
<cfoutput>
<cflocation url="sender_bypass.cfm?m1=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete">
 </cfoutput>
<cfelse>
<cfoutput>
<cflocation url="sender_bypass.cfm?m1=1&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete">
 </cfoutput>
</cfif>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion4" style="height: 220px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="452" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="sender_bypass.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&filter=#filter#&action=#action###delete"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Records</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            <td width="9" id="Cell870">
                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                            </td>
                                            <td width="489" id="Cell871">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getmailaddrtemp.RecordCount>
<A HREF="sender_bypass.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&filter=#filter#&action=#action###delete"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getmailaddrtemp.RecordCount - Next) LT DisplayRows>
      #Evaluate((getmailaddrtemp.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Records&nbsp; &gt;&gt;</SPAN></b></P></A>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.RecordCount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getmailaddrtemp.RecordCount# total records.</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table cellpadding="0" cellspacing="0" border="0" width="192">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="89">
                                          <tr valign="top" align="left">
                                            <td width="89" height="3"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td height="17" width="89" id="Text458" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', true);" href="javascript:void();"><span style="font-size: 10px;">Select All</span></a></b><span style="font-size: 10px;"></span>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="103">
                                          <tr valign="top" align="left">
                                            <td width="14" height="3"></td>
                                            <td width="89"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="89" id="Text462" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', false);" href="javascript:void();"><span style="font-size: 10px;">None</span></a></b>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="951" id="Text266" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getmailaddrtemp.recordcount# GTE 1>
<form name="delete" action="<cfoutput>sender_bypass.cfm?action=delete&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete</cfoutput>" method="post">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">From</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">To</span></b></p>
    </td>

  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>
   
  
    
  </tr>


<cfoutput query="getmailaddrtemp" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">


  <tr style="height: 28px;">


     
<cfif #applied# is "1">
     
<td align="center">
<input type="checkbox" name="cbox#id#" value="#id#" style="height: 13px; width: 13px;">
</td>

<cfelseif #applied# is "2">
<td align="center">
<input type="checkbox" name="cbox#id#" value="#id#" style="height: 13px; width: 13px;" disabled="disabled">
</td>
</cfif>



    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#sender# </span></p>
</div>
    </td>
    


    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#receiver#</span></p>
</div>
    </td>


    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#wb#</span></p>
</div>
    </td>

    


</cfoutput>
        </tr>
      </table>

<br><br>
<table id="Table155" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
  <tr style="height: 24px;">
    <td width="951" id="Cell940">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table width="160" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="TextObject">
                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;"
 onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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

</form>

<cfelse>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No existing Block/Allow Sender Check Bypass mappings found...</span></i></b></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="290" height="39"></td>
                                      <td width="660"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text416" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Block/Allow Sender(s)&nbsp; to be deleted</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="950" id="Text417" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_parameters3" datasource="#datasource#">
select * from mailaddr_temp where action='delete' and applied='2' order by sender asc
</cfquery>
<cfif #get_parameters3.recordcount# GTE 1>
<select name="parameters3" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_parameters3">
<option value="#id#">#sender# --> #receiver# --> TO BE DELETED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Block/Allow Sender(s) found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <form name="Table127FORM" action="sender_bypass.cfm?action=canceldelete#delete#" method="post">
                                          <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="951" id="Cell875">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Block/Allow List ready to be deleted. Please click the Apply Settings to apply your changes</span></i></b></p>
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
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="949"><hr id="HRRule13" width="949" size="1"></td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td colspan="4" width="950"><cfif #action# is "apply">
<cfquery name="getinsert" datasource="#datasource#">
select * from mailaddr_temp where action='insert' and applied='2'
</cfquery>

<cfquery name="getdelete" datasource="#datasource#">
select * from mailaddr_temp where action='delete' and applied='2'
</cfquery> 

<cfloop query="getinsert">
<cfoutput>
<cfquery name="insertwb" datasource="#datasource#">
insert into wblist
(rid, sid, wb)
values
('#recipient_id#', '#mailaddr_id#', <cfif #wb# is "ALLOW">'W'<cfelseif #wb# is "BLOCK">'B'</cfif>)
</cfquery>
</cfoutput>
</cfloop>

<cfloop query="getdelete">
<cfoutput>
<cfquery name="deletewb" datasource="#datasource#">
delete from wblist where rid='#recipient_id#' and sid='#mailaddr_id#'
</cfquery>
</cfoutput>
</cfloop>

<cfquery name="applyinsert" datasource="#datasource#">
update mailaddr_temp set applied='1' where applied='2' and action='insert'
</cfquery> 

<cfquery name="applydelete" datasource="#datasource#">
delete from mailaddr_temp where applied='2' and action='delete'
</cfquery> 

<cflocation url="sender_bypass.cfm?action=applied##apply">
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <form name="apply_settings" action="sender_bypass.cfm?action=apply" method="post">
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
select * from mailaddr_temp where applied='2'
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
                                      <td width="950" height="2"></td>
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
                          <td colspan="3"></td>
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