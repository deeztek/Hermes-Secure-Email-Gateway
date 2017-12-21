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
<title>External Encryption Users</title>
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
              <td height="557" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 557px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="521">
                              <tr valign="top" align="left">
                                <td width="15" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text369" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">&nbsp;External Recipients Encryption</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/external-recipients-encryption/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="14" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td width="955">

                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="362">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="28">
                                          <tr valign="top" align="left">
                                            <td width="9" height="13"></td>
                                            <td></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td height="19"></td>
                                            <td width="19"><a href="create_recipient.cfm"><img id="Picture40" height="19" width="19" src="./add_encryption.png" border="0" alt="Create External Recipient" title="Create External Recipient"></a></td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="334">
                                          <tr valign="top" align="left">
                                            <td width="5" height="15"></td>
                                            <td width="329"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="329" id="Text441" class="TextObject">
                                              <p style="margin-bottom: 0px;"><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51); font-weight: normal; font-style: normal; text-decoration: none ;" href="create_recipient.cfm">Create External Recipient</a></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td width="1"></td>
                          <td width="951"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="955"><hr id="HRRule6" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="78"></td>
                          <td colspan="3" width="953"><cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "m1" default = ""> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif>

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif>

<cfparam name = "show" default = "manual"> 
<cfif IsDefined("url.show")>
<cfif url.show is not "">
<cfset show = url.show>
<cfelseif url.show is "">
<cfset show = "manual">
</cfif>
</cfif>

<cfif #show# is "manual">
<cfif #filter# is "">


<cfquery name="getextrecipients" datasource="djigzo">
select * from cm_users  where cm_locality = 'manual' order by cm_email asc
</cfquery>


<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>

<cfquery name="getextrecipients" datasource="djigzo">
select * from cm_users  where cm_locality = 'manual' and cm_email like '%#filter#%' order by cm_email asc
</cfquery>

<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>


<cfelseif #show# is "auto">
<cfif #filter# is "">


<cfquery name="getextrecipients" datasource="djigzo">
SELECT * FROM `cm_users` where cm_locality is NULL
</cfquery>


<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>

<cfquery name="getextrecipients" datasource="djigzo">
select * from cm_users  where cm_locality is NULL and cm_email like '%#filter#%' order by cm_email asc
</cfquery>


<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>
</cfif>



<CFPARAM NAME="StartRow" DEFAULT="1">
<CFSET DisplayRows = 10>
<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFIF ToRow GT getextrecipients.RecordCount>
<CFSET ToRow = getextrecipients.RecordCount>
</CFIF>

<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>
                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion21" style="height: 78px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="611">
                                        <table id="Table169" border="0" cellspacing="0" cellpadding="0" width="612" style="height: 4px;">
                                          <tr style="height: 19px;">
                                            <form action="external_encryption_users_filter.cfm" method="post">
                                            <td width="70" id="Cell1066">
                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #show# is "manual">
<cfoutput>
<input type="radio" name="show" value="manual" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show# is not "manual">
<cfoutput>
<input type="radio" name="show" value="manual" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            </form>
                                            <td width="162" id="Cell1067">
                                              <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Manual Users Only</span></p>
                                            </td>
                                            <form action="external_encryption_users_filter.cfm" method="post">
                                            <td width="72" id="Cell1068">
                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #show# is "auto">
<cfoutput>
<input type="radio" name="show" value="auto" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show# is not "auto">
<cfoutput>
<input type="radio" name="show" value="auto" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            </form>
                                            <td width="307" id="Cell1069">
                                              <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Automatic Users Only</span></p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table cellpadding="0" cellspacing="0" border="0" width="619">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td height="10"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="external_encryption_users_filter.cfm" method="post">
                                                <input type="hidden" name="setfilter" value="1">
                                                <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="431" style="height: 25px;">
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
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfoutput>
<input type="hidden" name="show" value="#show#">
</cfoutput>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set Filter" style="height: 24px; width: 87px;">&nbsp;</p>
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
                                            <td width="11" height="10"></td>
                                            <td></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="external_encryption_users_filter.cfm" method="post">
                                                <input type="hidden" name="clearfilter" value="1">
                                                <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="178" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="178" id="Cell868">
                                                      <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfoutput>
<input type="hidden" name="show" value="#show#">
</cfoutput>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear Filter" style="height: 24px; width: 105px;">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td width="953" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953" id="Text381" class="TextObject">
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

<cfif #action# is "add">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient encryption options set.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "none">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;No changes were made to the External Recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "edit">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient encryption options set</span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "deletedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "addedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate created</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "sentcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate sent</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "portalpassword">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Portal Password Reset</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "pdfpassword">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient PDF Password Reset</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Configured</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Configured</span></i></b></p>
</cfoutput>

<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have selected S/MIME Encryption for this recipient. In order for S/MIME Encryption to work, you must create and/or import an S/MIME Certificate for this recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Deleted</span></i></b></p>
</cfoutput>
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;NOTE: If you had set a Sender Checks Bypass mapping for this External Recipient you just deleted, you must re-create the mapping under the Sender Checks Bypass section.</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="953"><hr id="HRRule1" width="953" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="88"></td>
                          <td colspan="2" width="952">



                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion15" style="height: 88px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <table id="Table70" border="0" cellspacing="0" cellpadding="0" width="952" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="452" id="Cell370">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="external_encryption_users.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&show=#show#"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# External Recipients</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            <td width="9" id="Cell371">
                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                            </td>
                                            <td width="490" id="Cell372">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getextrecipients.RecordCount>
<A HREF="external_encryption_users.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&show=#show#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getextrecipients.RecordCount - Next) LT DisplayRows>
      #Evaluate((getextrecipients.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>External Recipients&nbsp; &gt;&gt;</SPAN></b></P></A>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getextrecipients.recordcount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getextrecipients.recordcount# total external recipients</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text375" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><cfif #getextrecipients.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No External Recipients were found with the filter criteria you specified or you do not have any external recipients added to the system...</span></i></b></p>

<cfelseif #getextrecipients.recordcount# GTE 1>

<table id="Table155" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 28px;">
    <td style="background-color: rgb(241,236,236);" id="Cell977">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-size: 12px;">Recipient</span></b></p>
    </td>
    <td style="background-color: rgb(241,236,236);" id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Encryption Status</span></b></p>
    </td>
    <td style="background-color: rgb(241,236,236);" id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">S/MIME Cert(s)</span></b></p>
    </td>

<td width="92" style="background-color: rgb(241,236,236);" id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">PGP Keyring(s)</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Configure</span></b></p>
    </td>
<td style="background-color: rgb(241,236,236);" id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">PDF Passwd</span></b></p>
    </td>
<td style="background-color: rgb(241,236,236);" id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Portal Passwd</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Delete</span></b></p>
    </td>
  </tr>
<cfoutput query="getextrecipients" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">

<cfquery name="getrecdetails" datasource="#datasource#">
select * from external_recipients where email = '#cm_email#'
</cfquery>

<cfif #getrecdetails.recordcount# GTE 1 and #show# is "manual">

  <tr style="height: 26px;">
    <td id="Cell981">
      <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">#cm_email#</span></p>
    </td>
    <td id="Cell982">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table id="Table156" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
              <tr style="height: 12px;">
                <td id="Cell985">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">PDF</span></b></p>
                </td>
<td id="Cell985">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">PDF Mode</span></b></p>
                </td>

                <td id="Cell986">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">S/MIME</span></b></p>
                </td>

           <td width="38" id="Cell988">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">PGP</span></b></p>
                </td>     
                
              </tr>
              <tr style="height: 14px;">
<cfif #getrecdetails.pdf# is "1">
<cfif #getrecdetails.encryption_mode# is "pdf_mandatory">
                <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Mandatory</span></p>
                </td>
<cfelseif #getrecdetails.encryption_mode# is "pdf_by_subject">

                <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Subject</span></p>
                </td>
</cfif>
<cfelse>
  <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>
<cfif #getrecdetails.pdf# is "1">
<td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">#getrecdetails.pdf_mode#</span></p>
                </td>
<cfelse>
<td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">N/A</span></p>
                </td>
</cfif>

<cfif #getrecdetails.smime# is "1">
<cfif #getrecdetails.encryption_mode# is "smime_mandatory">
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Mandatory</span></p>
                </td>
<cfelseif #getrecdetails.encryption_mode# is "smime_by_subject">
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Subject</span></p>
                </td>
</cfif>
<cfelse>
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>

<cfif #getrecdetails.pgp# is "1">
<cfif #getrecdetails.encryption_mode# is "pgp_mandatory">
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Mandatory</span></p>
                </td>
<cfelseif #getrecdetails.encryption_mode# is "pgp_by_subject">
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">Subject</span></p>
                </td>
</cfif>
<cfelse>
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>




              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>



    <td id="Cell983">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where user_id='#getrecdetails.id#' and external='1'
</cfquery>
<cfif #getcerts.recordcount# GTE 1>
<td align="center"><a href="view_smime_certificates.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="certificate_icon.png" border="0" alt="Recipient Certificate(s)" title="Recipient Certificate(s)"></a></td>
<cfelse>
<td align="center"><img id="Picture36" height="19" width="19" src="certificate_icon_off.png" border="0" alt="No S/MIME Certificate(s) Found" title="No S/MIME Certificate(s) Found"></td>
</cfif>



<td align="center"><a href="add_smime_certificate.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="add_encryption.png" border="0" alt="Add S/MIME Certificate" title="Add S/MIME Certificate"></td>



<td align="center"><a href="import_smime_certificate.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="import_certificate.png" border="0" alt="Import S/MIME Certificate" title="Import S/MIME Certificate"></td>

</tr>

      </table>
    </td>




<td id="Cell983">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>


<cfquery name="getkeyrings" datasource="#datasource#">
select * from recipient_keystores where user_id='#getrecdetails.id#' and external='1'
</cfquery>


<cfif #getkeyrings.recordcount# GTE 1>
<td align="center"><a href="view_pgp_keyrings.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="keyring_on.png" border="0" alt="Recipient Keyring(s)" title="Recipient Keyring(s)"></a></td>
<cfelse>
<td align="center"><img id="Picture36" height="19" width="19" src="keyring_off.png" border="0" alt="No PGP Keyring(s) Found" title="No PGP Keyring(s) Found"></td>
</cfif>



<td align="center"><a href="add_pgp_keyring.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="add_encryption.png" border="0" alt="Add PGP Keyring" title="Add PGP Keyring"></td>



<td align="center"><a href="import_pgp_key.cfm?id=#getrecdetails.id#&type=2&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture36" height="19" width="19" src="import_certificate.png" border="0" alt="Import PGP Certificate" title="Import PGP Certificate"></td>

</tr>

      </table>
    </td>





    <td id="Cell984">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<td align="center"><a href="edit_external_recipient.cfm?id=#getrecdetails.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="configure_icon.png" border="0" alt="Configure" title="Configure"></a></td>
</tr>
</table>

<cfif #getrecdetails.pdf# is "1">
<cfif #getrecdetails.pdf_mode# is "static">
<td align="center"><a href="reset_pdf_password.cfm?id=#getrecdetails.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="pdf_icon.png" border="0" alt="View/Reset PDF Password" title="View/Reset PDF Password"></a></td>
<cfelse>
<td align="center"><img id="Picture37" height="21" width="21" src="pdf_icon_off.png" border="0" alt="Static PDF Mode not enabled" title="Static PDF Mode not enabled"></td>
</cfif>
<cfelseif #getrecdetails.pdf# is not "1">
<td align="center"><img id="Picture37" height="21" width="21" src="pdf_icon_off.png" border="0" alt="Static PDF Mode not enabled" title="Static PDF Mode not enabled"></td>
</cfif>

<cfif #getrecdetails.pdf# is "1">
<cfif #getrecdetails.pdf_mode# is "random">
<td align="center"><a href="reset_portal_password.cfm?id=#getrecdetails.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="padlock_icon.png" border="0" alt="Reset Portal Password" title="Reset Portal Password"></a></td>
<cfelse>
<td align="center"><img id="Picture37" height="21" width="21" src="padlock_icon_off.png" border="0" alt="Random PDF Mode not enabled" title="Random PDF Mode not enabled"></td>
</cfif>
<cfelseif #getrecdetails.pdf# is not "1">
<td align="center"><img id="Picture37" height="21" width="21" src="padlock_icon_off.png" border="0" alt="Random PDF Mode not enabled" title="Random PDF Mode not enabled"></td>
</cfif>

<td id="Cell984">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<td align="center"><a href="delete_recipient.cfm?id=#getrecdetails.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="delete_icon.png" border="0" alt="Delete" title="Delete"></a></td>

        </tr>

         
      </table>
    </td>
  </tr>

<cfelseif #getrecdetails.recordcount# LT 1>

<tr style="height: 26px;">
    <td id="Cell981">
      <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">#cm_email#</span></p>
    </td>
    <td id="Cell982">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table id="Table156" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
              <tr style="height: 12px;">
                <td id="Cell985">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">PDF</span></b></p>
                </td>
<td id="Cell985">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">PDF Mode</span></b></p>
                </td>

                <td id="Cell986">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 8px;">S/MIME</span></b></p>
                </td>

                
                
              </tr>
              <tr style="height: 14px;">

  <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">No</span></p>
                </td>


<td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">N/A</span></p>
                </td>



                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 8px; color: rgb(128,128,128);">No</span></p>
                </td>




              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>

    <td id="Cell983">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<td align="center"><img id="Picture36" height="19" width="19" src="certificate_icon_off.png" border="0" alt="S/MIME Encryption is not enabled" title="S/MIME Encryption is not enabled"></td>



<td align="center"><img id="Picture36" height="19" width="19" src="add_encryption_off.png" border="0" alt="S/MIME Encryption is not enabled" title="S/MIME Encryption is not enabled"></td>



<td align="center"><img id="Picture36" height="19" width="19" src="import_certificate_off.png" border="0" alt="S/MIME Encryption is not enabled" title="S/MIME Encryption is not enabled"></td>

</tr>

      </table>
    </td>


<td id="Cell983">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<td align="center"><img id="Picture36" height="19" width="19" src="keyring_off.png" border="0" alt="PGP Encryption is not enabled" title="PGP Encryption is not enabled"></td>



<td align="center"><img id="Picture36" height="19" width="19" src="add_encryption_off.png" border="0" alt="PGP Encryption is not enabled" title="PGP Encryption is not enabled"></td>



<td align="center"><img id="Picture36" height="19" width="19" src="import_certificate_off.png" border="0" alt="PGP Encryption is not enabled" title="PGP Encryption is not enabled"></td>

</tr>

      </table>
    </td>



    <td id="Cell984">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<td align="center"><a href="edit_external_recipient_auto.cfm?email=#cm_email#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="configure_icon.png" border="0" alt="Configure" title="Configure"></a></td>
</tr>
</table>


<td align="center"><a href="reset_pdf_password_auto.cfm?email=#cm_email#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="pdf_icon.png" border="0" alt="Reset PDF Password" title="Reset PDF Password"></a></td>



<td align="center"><a href="reset_portal_password_auto.cfm?email=#cm_email#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="padlock_icon.png" border="0" alt="Reset Portal Password" title="Reset Portal Password"></a></td>


<td id="Cell984">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

<td align="center"><a href="delete_recipient_auto.cfm?email=#cm_email#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#"><img id="Picture37" height="21" width="21" src="delete_icon.png" border="0" alt="Delete" title="Delete"></a></td>

        </tr>

         
      </table>
    </td>
  </tr>
  




</cfif>

</cfoutput>
</table>
</cfif>


&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #action# is "add">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient encryption options set.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "none">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;No changes were made to the External Recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "edit">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient encryption options set</span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "deletedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "deletedkey">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient PGP Key deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "addedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate created</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "sentcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient S/MIME Certificate sent</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "portalpassword">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Portal Password Reset</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "pdfpassword">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient PDF Password Reset</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Configured</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Configured</span></i></b></p>
</cfoutput>

<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have selected S/MIME Encryption for this recipient. In order for S/MIME Encryption to work, you must create and/or import a S/MIME Certificate for this recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Deleted</span></i></b></p>
</cfoutput>
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;NOTE: If you had set a Sender Checks Bypass mapping for this External Recipient you just deleted, you must re-create the mapping under the Sender Checks Bypass section.</span></i></b></p>
</cfoutput>

</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! External Recipient Configured</span></i></b></p>
</cfoutput>

<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have selected PGP Encryption for this recipient. In order for PGP Encryption to work, you must create and/or import a PGP Keyring for this recipient</span></i></b></p>
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