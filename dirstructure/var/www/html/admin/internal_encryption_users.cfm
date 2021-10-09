<!---
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
    --->
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Internal Encryption Users</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="401" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 401px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="892">
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="3" width="879" id="Text500" class="TextObject" style="background-color: rgb(102,153,51);">
                                  <p style="margin-bottom: 0px;"><b><span style="color: rgb(255,255,255);">This page has been upgraded to our 2.0 interface. Please click <a href="/admin/2/view_internal_recipients.cfm">here</a> to use the new version</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="13" height="34"></td>
                                <td width="2"></td>
                                <td width="506"></td>
                                <td width="371"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td width="506" id="Text369" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="color: rgb(0,51,153);">Internal Recipients Encryption</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="78">
                              <tr valign="top" align="left">
                                <td width="53" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/internal-recipients-encryption/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="16" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="74"></td>
                          <td width="951"><cfparam name = "filter" default = ""> 
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

<cfparam name = "show" default = "disabled"> 
<cfif IsDefined("url.show") is "True">
<cfif url.show is "enabled">
<cfset show = "enabled">
<cfelse>
<cfset show = "disabled">
</cfif>
</cfif>

<cfif #show# is "enabled">
<cfif #filter# is "">
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where domain is NULL order by recipient asc
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where recipient like '%#filter#%' and domain is NULL order by recipient asc
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>
</cfif>


<cfelseif #show# is "disabled">
<cfif #filter# is "">
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where domain is NULL order by recipient asc
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where recipient like '%#filter#%' and domain is NULL order by recipient asc
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
<CFIF ToRow GT getintrecipients.RecordCount>
<CFSET ToRow = getintrecipients.RecordCount>
</CFIF>

<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>
                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion21" style="height: 74px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="621">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td height="9"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="internal_encryption_users_filter.cfm" method="post">
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
                                            <td width="13" height="9"></td>
                                            <td></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="internal_encryption_users_filter.cfm" method="post">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="610">
                                    <tr valign="top" align="left">
                                      <td width="610" height="10"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="610" id="Text381" class="TextObject">
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
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="2"></td>
                          <td width="947"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="950"><hr id="HRRule14" width="950" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="128"></td>
                          <td colspan="2" width="949">



                            <table border="0" cellspacing="0" cellpadding="0" width="949" id="LayoutRegion15" style="height: 128px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <table id="Table70" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="451" id="Cell370">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="internal_encryption_users.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Recipients</SPAN></b></P>
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
                                            <td width="488" id="Cell372">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getintrecipients.RecordCount>
<A HREF="internal_encryption_users.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getintrecipients.RecordCount - Next) LT DisplayRows>
      #Evaluate((getintrecipients.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Recipients&nbsp; &gt;&gt;</SPAN></b></P></A>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="949">
                                    <tr valign="top" align="left">
                                      <td width="949" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="949" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getintrecipients.recordcount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getintrecipients.recordcount# total internal recipients</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="949">
                                    <tr valign="top" align="left">
                                      <td width="949" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="949" id="Text375" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><cfif #getintrecipients.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Internal Recipients were found with the filter criteria you specified or you do not have any internal recipients added to the system...</span></i></b></p>

<cfelseif #getintrecipients.recordcount# GTE 1>

<table id="Table155" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 28px;">
    <td width="229" style="background-color: rgb(241,236,236);" id="Cell977">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-size: 12px;">Recipient</span></b></p>
    </td>
    <td width="208" style="background-color: rgb(241,236,236);" id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Encryption Status</span></b></p>
    </td>
    <td width="92" style="background-color: rgb(241,236,236);" id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">S/MIME Cert(s)</span></b></p>
    </td>
<td width="92" style="background-color: rgb(241,236,236);" id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">PGP Keyring(s)</span></b></p>
    </td>

    <td width="70" style="background-color: rgb(241,236,236);" id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Configure Encryption</span></b></p>
    </td>
  </tr>
<cfoutput query="getintrecipients" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">
  <tr style="height: 26px;">
    <td id="Cell981">
      <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">#recipient#</span></p>
    </td>
    <td id="Cell982">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table id="Table156" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
              <tr style="height: 12px;">
                <td width="41" id="Cell985">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">PDF</span></b></p>
                </td>
                <td width="47" id="Cell986">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">S/MIME</span></b></p>
                </td>
                <td width="44" id="Cell987">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Mode</span></b></p>
                </td>
                <td width="38" id="Cell988">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Sign All</span></b></p>
                </td>
<td width="38" id="Cell988">
                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">PGP</span></b></p>
                </td>

              </tr>
              <tr style="height: 14px;">
<cfif #pdf_enabled# is "1">
                <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Yes</span></p>
                </td>
<cfelse>
  <td id="Cell989">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>
<cfif #smime_enabled# is "1">
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Yes</span></p>
                </td>
<cfelse>
                <td id="Cell990">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>
<cfif #smime_mode# is "1">
                <td id="Cell991">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Normal</span></p>
                </td>
<cfelse>
 <td id="Cell991">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Paranoid</span></p>
                </td>
</cfif>
<cfif #digital_sign# is "1">
                <td id="Cell992">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Yes</span></p>
                </td>
<cfelse>
 <td id="Cell992">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">No</span></p>
                </td>
</cfif>

<cfif #pgp_enabled# is "1">
                <td id="Cell992">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Yes</span></p>
                </td>
<cfelse>
 <td id="Cell992">
                  <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">No</span></p>
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
select * from recipient_certificates where user_id='#id#'
</cfquery>
<cfif #getcerts.recordcount# GTE 1>
<td align="center"><a href="view_smime_certificates.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#"><img id="Picture36" height="19" width="19" src="certificate_icon.png" border="0" alt="Recipient Certificate(s)" title="Recipient Certificate(s)"></a></td>
<cfelse>
<td align="center"><img id="Picture36" height="19" width="19" src="certificate_icon_off.png" border="0" alt="No S/MIME Certificate(s) Found" title="No S/MIME Certificate(s) Found"></td>
</cfif>

<td align="center"><a href="add_smime_certificate.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#"><img id="Picture36" height="19" width="19" src="add_encryption.png" border="0" alt="Add S/MIME Certificate" title="Add S/MIME Certificate"></td>

<td align="center"><a href="import_smime_certificate.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&rec=#recipient#"><img id="Picture36" height="19" width="19" src="import_certificate.png" border="0" alt="Import S/MIME Certificate" title="Import S/MIME Certificate"></td>


</tr>

      </table>
    </td>




    <td id="Cell984">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
<cfquery name="getkeyrings" datasource="#datasource#">
select * from recipient_keystores where user_id='#id#'
</cfquery>
<cfif #getkeyrings.recordcount# GTE 1>
<td align="center"><a href="view_pgp_keyrings.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#"><img id="Picture36" height="19" width="19" src="keyring_on.png" border="0" alt="Recipient Keyring(s)" title="Recipient Keyring(s)"></a></td>
<cfelse>
<td align="center"><img id="Picture36" height="19" width="19" src="keyring_off.png" border="0" alt="No PGP Keyring(s) Found" title="No PGP Keyring(s) Found"></td>
</cfif>

<td align="center"><a href="add_pgp_keyring.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#"><img id="Picture36" height="19" width="19" src="add_encryption.png" border="0" alt="Add PGP Keyring" title="Add PGP Keyring"></td>

<td align="center"><a href="import_pgp_key.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&rec=#recipient#"><img id="Picture36" height="19" width="19" src="import_certificate.png" border="0" alt="Import PGP Key" title="Import PGP Key"></td>


</tr>

      </table>
    </td>




    <td id="Cell985">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center"><a href="add_internal_user_encryption.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#"><img id="Picture37" height="21" width="21" src="configure_icon.png" border="0" alt="Configure Encryption" title="Configure Encryption"></a></td>
        </tr>
      </table>
    </td>
  </tr>
</cfoutput>
</table>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="949" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #action# is "add">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient encryption options set.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "none">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;No changes were made to the Internal Recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "edit">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient encryption options set</span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "deletedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient S/MIME Certificate deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "deletedkey">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient PGP Key deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "addedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient S/MIME Certificate created</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "sentcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient S/MIME Certificate sent</span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "addedpgp">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient PGP Keyring created</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "sentpgp">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Internal Recipient Keyring sent</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
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
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>
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
  </div>
</body>
</html>
   