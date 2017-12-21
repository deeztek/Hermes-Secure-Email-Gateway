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
<title>Spam Filter Tests</title>
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
        <td><style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted
 black;padding:5px; }
</style>



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
              <td height="920" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm">
</cfif>
</cfif>

<cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">

<cfparam name = "m3" default = "0">
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif> 

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif>  

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion27" style="background-image: url('./middle_988.png'); height: 920px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="521">
                              <tr valign="top" align="left">
                                <td width="14" height="15"></td>
                                <td width="1"></td>
                                <td width="505"></td>
                                <td width="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text485" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Custom Spam Filter Tests</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="10"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text486" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Custom Spam Filter Test</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/custom-antispam-filter-tests/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="14" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="188"></td>
                          <td width="954"><cfparam name = "parameter" default = ""> 
<cfif IsDefined("form.parameter") is "True">
<cfif form.parameter is not "">
<cfset parameter = form.parameter>
</cfif></cfif> 

<cfparam name = "value" default = ""> 
<cfif IsDefined("form.value") is "True">
<cfif form.value is not "">
<cfset value = form.value>
</cfif></cfif> 

<cfparam name = "description" default = ""> 
<cfif IsDefined("form.description") is "True">
<cfif form.description is not "">
<cfset description = form.description>
</cfif></cfif> 

<cfif #action# is "add">
<cfif #parameter# is "">
<cfset step=0>
<cfset m1=1>
<cfelseif #parameter# is not "">
<cfset step=1>
</cfif>

<cfif #step# is "1">
<cfquery name="checkparameter" datasource="#datasource#">
select parameter from spam_settings where parameter = '#parameter#' and spamfilter='1'
</cfquery>

<cfif #checkparameter.recordcount# LT 1>
<cfset step=2>
<cfelseif #checkparameter.recordcount# GTE 1>
<cfset step=0>
<cfset m1=2>
</cfif>

<!-- /cfif for step 1 -->
</cfif>

<cfif #step# is "2">

<cfif #value# is "">
<cfset step=0>
<cfset m1=3>
<cfelseif #value# is not "">
<cfset step=3>
</cfif>

<!-- /cfif for step 2 -->
</cfif>



<cfif #step# is "3">
<cfif IsValid("float", value)>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m1=7>

<!-- /cfif for IsValid float -->
</cfif>

<!-- /cfif for step 3 -->
</cfif>

<cfif #step# is "4">
<cfif #value# LT -999>
<cfset step=0>
<cfset m1=4>
<cfelseif #value# GT 999>
<cfset step=0>
<cfset m1=5>
<cfelse>
<cfset step=5>

<!-- /cfif for value -->
</cfif>

<!-- /cfif for step 4 -->
</cfif>




<cfif #step# is "5">
<cfquery name="insert" datasource="#datasource#">
insert into spam_settings
(parameter, value, description, spamfilter, active, applied)
values
('#parameter#', '#value#', '#description#', '1', '1', '2')
</cfquery>
<cfset step=0>
<cfset m1=6>
<cfset parameter="">
<cfset value="">
<cfset description="">
<cfset action="">

<!-- /cfif for step 2 -->
</cfif>

<!-- /cfif for action -->
</cfif> 




                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion5" style="height: 188px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion5FORM" action="spam_filter_tests.cfm" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="954">
                                          <table id="Table156" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 102px;">
                                            <tr style="height: 17px;">
                                              <td width="954" id="Cell941">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Parameter</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell942">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField39" name="parameter" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#parameter#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell943">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Value</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell944">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField42" name="value" size="8" maxlength="8" style="width: 60px; white-space: pre;" value="#value#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell945">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Description</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell946">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField43" name="description" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#description#"></cfoutput></p>
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
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="954">
                                      <tr valign="top" align="left">
                                        <td width="954" height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954" id="Text351" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Parameter field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Parameter you are trying to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be less than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be greater than 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Spam Filter Test added. Please click the Apply Settings button below to apply your new settings.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field must be a valid integer between -999 and 999</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="13" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="441"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="6" valign="middle" width="951"><hr id="HRRule1" width="951" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td width="506" id="Text501" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Edit/Delete Custom Spam Filter Test(s)</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="42"></td>
                          <td colspan="7" width="952"><cfquery name="getusebayes" datasource="#datasource#">
select value from spam_settings where parameter='use_bayes'
</cfquery>

<cfparam name = "usebayes" default = "#getusebayes.value#"> 

<cfif #filter# is "">
<cfquery name="gettests" datasource="#datasource#">
select * from spam_settings where spamfilter = '1' order by parameter asc
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
<cfquery name="gettests" datasource="#datasource#">
select * from spam_settings where parameter like '%#filter#%' and spamfilter = '1' order by parameter asc
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion21" style="height: 42px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="624">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="spam_filter_tests_filter.cfm#mappings" method="post">
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
                                            <td width="16"></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="spam_filter_tests_filter.cfm#mappings" method="post">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text381" class="TextObject">
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
                          <td colspan="10" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="949"><hr id="HRRule2" width="949" size="1"></td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="127"></td>
                          <td colspan="5" width="950"><CFPARAM NAME="StartRow" DEFAULT="1">
<CFSET DisplayRows = 50>
<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFIF ToRow GT gettests.RecordCount>
<CFSET ToRow = gettests.RecordCount>
</CFIF>

<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>
                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion23" style="height: 127px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text446" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text445" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">The custom Spam Filter&nbsp; tests that you have specified are displayed below. Setting a value of a test&nbsp; to 0 (zero) will disable that test. After you finish making your changes click on the <b>Apply Settings</b> button below&nbsp; to apply your changes.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="1" height="4"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="949">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="451" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="spam_filter_tests.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows###mappings"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# tests</SPAN></b></P>
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
<CFIF Next LTE gettests.RecordCount>
<A HREF="spam_filter_tests.cfm?StartRow=#Next#&DisplayRows=#DisplayRows###mappings"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (gettests.RecordCount - Next) LT DisplayRows>
      #Evaluate((gettests.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>tests&nbsp; &gt;&gt;</SPAN></b></P></A>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #gettests.recordcount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #gettests.recordcount# total tests</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text284" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #gettests.recordcount# LT 1>
<br>
<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">You have not added any custom filter tests added.</span></b></p>

<cfelse>


<table id="Table78" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(255,255,255); border-left-style: solid;
 border-top-color:  rgb(255,255,255); border-top-style: solid; border-right-color:  rgb(255,255,255); border-right-style: solid; border-bottom-color:
  rgb(255,255,255); border-bottom-style: solid; height: 13px;">
 <tr style="height: 14px;">
  
  <td width="100" style="background-color: rgb(241,236,236);" id="Cell482">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Test</span></b></p>
  </td>
  <td width="50" style="background-color: rgb(241,236,236);" id="Cell482">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Value</span></b></p>
  </td>
  <td width="421" style="background-color: rgb(241,236,236);" id="Cell628">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Description (Default Value)</span></b></p>
  </td>
<td width="50" style="background-color: rgb(241,236,236);" id="Cell628">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Edit</span></b></p>
  </td>
<td width="50" style="background-color: rgb(241,236,236);" id="Cell628">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Delete</span></b></p>
  </td>

 </tr>

<cfoutput query="gettests" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">

 <tr style="height: 27px;">

  <td>
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#TRIM(parameter)#</span></p>
  </td>


<td>
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#TRIM(value)#</span></p>
  </td>




<td>
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#TRIM(description)#</span></p>
  </td>


  

<td>
      <form name="edit" action="edit_spam_filter_test.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#" method="post">
<input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<td align="center"><input type="image" name="FormsButton1" src="configure_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>

          </tr>
        </table>
      </form>
    </td>

<td>
      <form name="edit" action="delete_spam_filter_test.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#" method="post">
<input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<td align="center"><input type="image" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>

          </tr>
        </table>
      </form>
    </td>



 </tr>
 </cfoutput>



</table>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text185" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Spam Filter Test edited. Please click the Apply Settings button below to apply your new settings.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Spam Filter Test deleted. Please click the Apply Settings button below to apply your new settings.</span></i></b></p>
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
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="5" valign="middle" width="950"><hr id="HRRule7" width="950" size="1"></td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="10" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="48"></td>
                          <td colspan="7" width="952"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

<cfquery name="get_use_bayes" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_bayes' and active = '1'
</cfquery>


<cfquery name="get_bayes_auto_learn" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn' and active = '1'
</cfquery>

<cfquery name="get_bayes_auto_learn_threshold_spam" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_spam' and active = '1'
</cfquery>

<cfquery name="get_bayes_auto_learn_threshold_nonspam" datasource="#datasource#">
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_nonspam' and active = '1'
</cfquery>

<cfquery name="get_use_dcc" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_dcc' and active = '1'
</cfquery>

<cfquery name="get_use_razor2" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_razor2' and active = '1'
</cfquery>

<cfquery name="get_use_pyzor" datasource="#datasource#">
select parameter, value from spam_settings where parameter='use_pyzor' and active = '1'
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



<!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF BELOW --->

<cffile action="read" file="/opt/hermes/conf_files/local.cf.HERMES" variable="local">

<cfif #get_use_dcc.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-DCC","use_dcc 1","ALL")#">

<cfelseif #get_use_dcc.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-DCC","use_dcc 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cfif #get_use_pyzor.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-PYZOR","use_pyzor 1","ALL")#">

<cfelseif #get_use_pyzor.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-PYZOR","use_pyzor 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cfif #get_use_razor2.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-RAZOR2","use_razor2 1","ALL")#">

<cfelseif #get_use_razor2.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-RAZOR2","use_razor2 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cfif #get_use_bayes.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-BAYES","use_bayes 1","ALL")#">

<cfelseif #get_use_bayes.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","USE-BAYES","use_bayes 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cfif #get_bayes_auto_learn.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","BAYES-AUTO-LEARN","bayes_auto_learn 1","ALL")#">

<cfelseif #get_bayes_auto_learn.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","BAYES-AUTO-LEARN","bayes_auto_learn 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","BAYESAUTOLEARN-SPAM","bayes_auto_learn_threshold_spam #get_bayes_auto_learn_threshold_spam.value#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","BAYESAUTOLEARN-HAM","bayes_auto_learn_threshold_nonspam #get_bayes_auto_learn_threshold_nonspam.value#","ALL")#">

<!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM TESTS BELOW --->

<cfquery name="gettests" datasource="#datasource#">
SELECT * FROM spam_settings where spamfilter='1' and active = '1' order by parameter asc
</cfquery>

<cfif #gettests.recordcount# GTE 1>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
    output = ""
    addNewLine = "no">

<cfloop query="gettests">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_sa_tests"
    output = "score #parameter# #value#"
    addNewLine = "yes">
</cfloop>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_sa_tests" variable="theTests">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","##CUSTOM-TESTS","#theTests#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_sa_tests")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_sa_tests">
</cfif>


</cfif>

<!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM TESTS ABOVE --->

<!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM MESSAGE RULES BELOW --->

<cfquery name="getmessagerules" datasource="#datasource#">
SELECT * FROM message_rules order by rule_name asc
</cfquery>

<cfif #getmessagerules.recordcount# GTE 1>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_message_rules"
    output = ""
    addNewLine = "no">

<cfloop query="getmessagerules">

<cfif #rule_type# is not "header">
<cfif #rule_desc# is not "">
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_message_rules"
    output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
    addNewLine = "yes">
<cfelseif #rule_desc# is "">
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_message_rules"
    output = "#rule_type# #rule_name# #regex##chr(10)#score #rule_name# #score##chr(10)#"
    addNewLine = "yes">
</cfif>
<cfelseif #rule_type# is "header">
<cfif #rule_desc# is not "">
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_message_rules"
    output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#describe #rule_name# #rule_desc##chr(10)#"
    addNewLine = "yes">
<cfelseif #rule_desc# is "">
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_message_rules"
    output = "#rule_type# #rule_name# #header# =#regex##chr(10)#score #rule_name# #score##chr(10)#"
    addNewLine = "yes">
</cfif>
</cfif>
</cfloop>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_message_rules" variable="theRules">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="local">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#local#","##CUSTOM-MESSAGE-RULES","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_message_rules")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_message_rules">
</cfif>


</cfif>

<!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM MESSAGE RULES ABOVE --->


<!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF ABOVE --->

<cffile action = "write" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.cf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#local.cf.HERMES /etc/spamassassin/local.cf#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/var/www/tasks/#customtrans3#_apply.sh" 
output = "/etc/init.d/amavis restart#chr(10)#/etc/init.d/postfix restart"
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
update spam_settings set applied='1' where applied = '2' and spamfilter = '1'
</cfquery> 
    
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion13" style="height: 48px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="952">
                                        <form name="apply_settings" action="spam_filter_tests.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="952" id="Cell753">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from spam_settings where applied='2' and spamfilter = '1' and active = '1'
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text500" class="TextObject">
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