<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif><!--
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
<title>View User Message</title>
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
                          <td width="755"><!--<img id="AllWebMenusComponent1" height="19" width="755" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu_users.js' AWMJSPATH='./hermes_seg_menu_users.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu_users'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="531" width="988"><cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif>

<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({selector:'textarea#viewmsg',
readonly: true,
  toolbar: false,
  menubar: false,
  statusbar: false
});
</script>

<cfset mailid = "#url.mid#">

<cfquery name="checkq" datasource="#datasource#">
select archive, quar_loc from msgs where mail_id like binary '#mailid#'
</cfquery>

<cfif #checkq.archive# is "N">
<cfset quarfile="/mnt/data/amavis/#checkq.quar_loc#">
<cfelseif #checkq.archive# is "Y">
<cfquery name="getarchive" datasource="#datasource#">
select * from archive_jobs limit 1
</cfquery>

<cfif #getarchive.recordcount# GTE 1>
<cfset quarfile="/mnt/hermesemail_archive/mnt/data/amavis/#checkq.quar_loc#">
<cfelseif #getarchive.recordcount# LT 1>
<cflocation
 url="loading.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.
starttime#&endtime=#url.endtime#&action=#action#&m3=5">
</cfif>
</cfif>

<cfif NOT fileExists(quarfile)> 
<cfif #checkq.archive# is "N">

<cflocation
 url="loading.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.
starttime#&endtime=#url.endtime#&action=#action#&m3=4">

<cfelseif #checkq.archive# is "Y">

<cflocation
 url="loading.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.
starttime#&endtime=#url.endtime#&action=#action#&m3=5">

</cfif>

<cfelseif fileExists(quarfile)>

<cfquery name="getmsgother" datasource="#datasource#">
SELECT * FROM msgs where mail_id like binary '#mailid#'
</cfquery>

<cfset secretid = "#getmsgother.secret_id#">

<cfset popAccount = createObject("component", "pop").init()>
<cfset message = popAccount.loadFromFile("#quarfile#")>

<!---<cfset email = CreateObject('component', 'emailParse').init('#FileData#') /> --->

<cfset date=#DateFormat(getmsgother.time_iso,"mm/dd/yyyy")#>
<cfset time="#TimeFormat(getmsgother.time_iso, "hh:mm:ss tt")#">


<cfset bodyNOHTML = REReplace("#message.HTMLBODY#","(<a.*?>)(.*?)(</a>)","\2","ALL")>
<cfset htmlbody = "#message.htmlbody#">
<cfset textbody = "#message.textbody#">


<cfset from2 = "#message.FROMEMAILADDRESS#">
<cfset to2 = "#message.TOEMAILADDRESS#">

<cfquery name="getsid" datasource="#datasource#">
select sid from msgs where mail_id = '#mailid#'
</cfquery>

<cfquery name="getfromaddr" datasource="#datasource#">
SELECT email as fromAddress FROM maddr where id='#getsid.sid#'
</cfquery>

<cfquery name="gettoaddr" datasource="#datasource#">
SELECT msgrcpt.rid,maddr.email as toAddress FROM msgrcpt INNER JOIN maddr ON msgrcpt.rid = maddr.id where mail_id like binary '#mailid#'
</cfquery>

<cfset from = "#getfromaddr.fromAddress#">
<cfset to = "#gettoaddr.toAddress#">

<cfset subject = "#message.subject#">
<cfset header = "#message.header#">
<cfset cc = "#message.CCEMAILADDRESS#">

<cfparam name = "show_msg_mode" default = "html"> 
<cfif IsDefined("form.msg_mode") is "True">
<cfset show_msg_mode = form.msg_mode>
</cfif>
</cfif>



                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion20" style="background-image: url('./middle_988.png'); height: 531px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="938">
                              <tr valign="top" align="left">
                                <td width="13" height="11"></td>
                                <td width="1"></td>
                                <td width="264"></td>
                                <td width="660"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="924" id="Text463" class="TextObject">
                                  <p style="margin-bottom: 0px;"><cfquery name="getusertrainfilter" datasource="#datasource#">
select value from spam_settings where parameter = 'user_portal_spam_training'
</cfquery>



<table id="Table165" border="0" cellspacing="4" cellpadding="2" width="100%" style="height: 36px;">
  <tr style="height: 24px;">



    <td width="125" id="Cell1018">
      <form name="Cell1018FORM" action="<cfoutput>loading.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="submit" id="FormsButton2" name="FormsButton2" value="BACK" style="height: 24px; width: 61px;"></td>
          </tr>
        </table>
      </form>
    </td>



<!--
<td width="125" id="Cell1018">
     
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><button onclick="self.close()">Close</button></td>
          </tr>
        </table>
      
    </td>

-->

    <td width="122" id="Cell1040">
      <form name="Cell1040FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <input type="hidden" name="todo" value="Block Sender"><input type="hidden" name="<cfoutput>cbox#mailid#</cfoutput>" value="<cfoutput>#mailid#_#secretid#</cfoutput>">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="submit" id="FormsButton3" value="Block" style="height: 24px; width: 60px;"></td>
          </tr>
        </table>
      </form>
    </td>
    <td width="116" id="Cell1041">
      <form name="Cell1041FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <input type="hidden" name="<cfoutput>cbox#mailid#</cfoutput>" value="<cfoutput>#mailid#_#secretid#</cfoutput>"><input type="hidden" name="todo" value="Allow Sender">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="submit" id="FormsButton4" value="Allow" style="height: 24px; width: 57px;"></td>
          </tr>
        </table>
      </form>
    </td>
    <td width="179" id="Cell1054">
      <form name="Cell1054FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <input type="hidden" name="<cfoutput>cbox#mailid#</cfoutput>" value="<cfoutput>#mailid#_#secretid#</cfoutput>"><input type="hidden" name="todo" value="Release Msg">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="submit" id="FormsButton5" value="Release" style="height: 24px; width: 87px;"></td>
          </tr>
        </table>
      </form>
    </td>


    <td width="129" id="Cell1055">
      <form name="Cell1055FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <input type="hidden" name="<cfoutput>cbox#mailid#</cfoutput>" value="<cfoutput>#mailid#_#secretid#</cfoutput>"><input type="hidden" name="todo" value="Train as Spam">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<cfif #session.train_bayes# EQ 1>   

<td align="center"><input type="submit" id="FormsButton6" value="Spam" style="height: 24px; width: 63px;"></td>

<cfelseif #session.train_bayes# NEQ 1> 

<td align="center"><input type="submit" id="FormsButton6" value="Spam" disabled="disabled" style="height: 24px; width: 63px;"></td> 

</cfif>

          </tr>
        </table>
      </form>
    </td>
    <td width="228" id="Cell1056">
      <form name="Cell1056FORM" action="<cfoutput>user_edit_quarantine.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#</cfoutput>" method="post">
        <input type="hidden" name="<cfoutput>cbox#mailid#</cfoutput>" value="<cfoutput>#mailid#_#secretid#</cfoutput>"><input type="hidden" name="todo" value="Train as NOT Spam">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>

<cfif #session.train_bayes# EQ 1>  

<td align="center"><input type="submit" id="FormsButton7" value="NOT Spam" style="height: 24px; width: 111px;"></td>

<cfelseif #session.train_bayes# NEQ 1> 
<td align="center"><input type="submit" id="FormsButton7" value="NOT Spam" disabled="disabled" style="height: 24px; width: 111px;"></td>

</cfif>


          </tr>
        </table>
      </form>
    </td>
  </tr>
</table>&nbsp;</p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="265" id="Text458" class="TextObject">
                                  <p style="text-align: left; margin-bottom: 0px;"><cfif #session.download_msg# EQ 1>
<p style="text-align: left; margin-bottom: 0px;"><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"
href="<cfoutput>user_download_message.cfm?StartRow=#url.StartRow#&DisplayRows=#url.DisplayRows#&startdate=#url.startdate#&enddate=#url.enddate#&starttime=#url.starttime#&endtime=#url.endtime#&action=#action#&mid=#URLEncodedFormat(Trim(mailid))#</cfoutput>">Download
 Message</a></p>
</cfif>&nbsp;</p>
                                </td>
                                <td></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="29">
                              <tr valign="top" align="left">
                                <td width="4" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/history-archive/#viewdownload')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
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
                          <td valign="middle" width="955"><hr id="HRRule1" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td width="954"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="954" id="Text453" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(45,103,228);">The message along with all the headers is displayed below. Please note all links have been disabled for your protection.<i><span style="color: rgb(255,0,0);"> <span style="font-style: normal;">NOTE: </span><span style="color: rgb(0,102,255);"> <span style="font-style: normal;">If ANY links are still active do NOT click on them or you will run the risk of infecting your computer with malware. If available, do NOT Download a Message unless it&#8217;s from a trusted source.</span></span></span></i></span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule2" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="13" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952">
                            <form name="Table166FORM" action="" method="post">
                              <cfoutput>
                              <table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 175px;">
                                <tr style="height: 25px;">
                                  <td width="223" id="Cell1019">
                                    <p style="font-size: 10px; text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Date&nbsp;&nbsp; </span></b></p>
                                  </td>
                                  <td width="729" id="Cell1020">
                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><input type="text" id="FormsEditField2" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#date#"></span></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1043">
                                    <p style="font-size: 12px; text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Return-Path <span style="font-weight: normal;">(Used by Block/Allow)&nbsp;&nbsp; </span></span></b></p>
                                  </td>
                                  <td id="Cell1042">
                                    <p style="margin-bottom: 0px;"><input type="text" id="FormsEditField1" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#from#"></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1049">
                                    <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">From <span style="font-weight: normal;">(can be forged)&nbsp;&nbsp; </span></span></b></p>
                                  </td>
                                  <td id="Cell1048">
                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><input type="text" id="FormsEditField3" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#from2#"></span></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1021">
                                    <p style="font-size: 12px; text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">X-Envelope-To <span style="font-weight: normal;">(Used by Block/Allow))&nbsp;&nbsp; </span></span></b></p>
                                  </td>
                                  <td id="Cell1022">
                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><input type="text" id="FormsEditField4" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#to#"></span></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1047">
                                    <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">To</span></b></p>
                                  </td>
                                  <td id="Cell1046">
                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><input type="text" id="FormsEditField5" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#to2#"></span></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1045">
                                    <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">CC&nbsp;&nbsp; </span></b></p>
                                  </td>
                                  <td id="Cell1044">
                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><input type="text" id="FormsEditField6" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#cc#"></span></p>
                                  </td>
                                </tr>
                                <tr style="height: 25px;">
                                  <td id="Cell1023">
                                    <p style="font-size: 12px; text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Subject&nbsp;&nbsp; </span></b></p>
                                  </td>
                                  <td id="Cell1024">
                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><input type="text" id="FormsEditField7" name="FormsEditField1" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="#subject#"></span></p>
                                  </td>
                                </tr>
                              </table>
                              </cfoutput>
                            </form>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="12" height="18"></td>
                          <td width="952"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952" id="Text455" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">BODY</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="487">
                            <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                              <tr style="height: 19px;">
                                <form action="" method="post">
                                <td width="58" id="Cell524">
                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #show_msg_mode# is "html">
<cfoutput>
<input type="radio" name="msg_mode" value="html" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_msg_mode# is not "html">
<cfoutput>
<input type="radio" name="msg_mode" value="html" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                </form>
                                <td width="429" id="Cell525">
                                  <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Show Msg Body as HTML</b> (Default)</span></p>
                                </td>
                              </tr>
                              <tr style="height: 19px;">
                                <form action="" method="post">
                                <td id="Cell526">
                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #show_msg_mode# is "text">
<cfoutput>
<input type="radio" name="msg_mode" value="text" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_msg_mode# is not "text">
<cfoutput>
<input type="radio" name="msg_mode" value="text" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                </form>
                                <td id="Cell527">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Show Msg Body as TEXT</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td width="954"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="954" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #show_msg_mode# is "html">
<form name="form1"> 
<textarea name="viewmsg" id="viewmsg" wrap="virtual" rows="25" cols="10">
<cfoutput>
#bodyNOHTML#
</cfoutput>
</textarea>
<cfelseif #show_msg_mode# is "text">
<form name="form1"> 
<textarea name="viewmsg" id="viewmsg" wrap="virtual" rows="25" cols="10">
<cfoutput>
#textbody#
</cfoutput>
</textarea>
</cfif>&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="12" height="16"></td>
                          <td width="953"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="954" id="Text457" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Headers</span></b></p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="953" id="Text456" class="TextObject">
                            <p style="margin-bottom: 0px;"><form name="form1"> 
<textarea name="viewmsg" id="viewmsg" wrap="physical" rows="25" cols="117">
<cfoutput>
#header#
</cfoutput>
</textarea>&nbsp;</p>
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