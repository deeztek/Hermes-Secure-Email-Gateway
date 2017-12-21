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
<title>SVF Policies</title>
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
              <td height="477" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 477px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="520">
                              <tr valign="top" align="left">
                                <td width="14" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text483" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">SVF Policies</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">SVF System Policies</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/svf-policies/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="14" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td width="953"><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif> 
                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion11" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td width="953" id="Text280" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="getsystempolicies" datasource="#datasource#">
select * from spam_policies where system='1' order by policy_name asc
</cfquery>

<table id="Table97" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(219,217,217); border-left-style: solid;
 border-top-color:  rgb(219,217,217); border-top-style: solid; border-right-color:  rgb(219,217,217); border-right-style: solid; border-bottom-color:
  rgb(219,217,217); border-bottom-style: solid; height: 45px;">
 <tr style="height: 28px;">
  <td width="253" style="background-color: rgb(241,236,236);" id="Cell595">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Policy Name</span></b></p>
  </td>
  <td width="93" style="background-color: rgb(241,236,236);" id="Cell596">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">System Policy</span></b></p>
  </td>
  <td width="85" style="background-color: rgb(241,236,236);" id="Cell597">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Spam Tag Score</span></b></p>
  </td>
  <td width="84" style="background-color: rgb(241,236,236);" id="Cell598">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Spam Quarantine Score</span></b></p>
  </td>
  <td width="84" style="background-color: rgb(241,236,236);" id="Cell598">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">File Rule</span></b></p>
  </td>
  <td width="111" style="background-color: rgb(241,236,236);" id="Cell607">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Actions</span></b></p>
  </td>
 </tr>

<cfoutput query="getsystempolicies">
<cfquery name="getpolicysettings" datasource="#datasource#">
select * from policy where id='#policy_id#'
</cfquery>

 <tr style="height: 21px;">
  <td id="Cell599">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#policy_name#</span></p>
  </td>
  <td id="Cell601">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">Yes</span></p>
  </td>

  <td id="Cell605">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 9px; color:
 rgb(128,128,128);">#Numberformat (getpolicysettings.spam_tag2_level, '____.__')#</span></p>
  </td>
  <td id="Cell606">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#Numberformat (getpolicysettings.spam_kill_level, '____.__')#</span></p>
  </td>
  <td id="Cell606">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#getpolicysettings.banned_rulenames#</span></p>
  </td>
  <td id="Cell608">
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
     <td align="center">
      <table id="Table99" border="0" cellspacing="0" cellpadding="0" width="80" style="height: 21px;">
       <tr style="height: 21px;">
        <td width="28" id="Cell602">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="copy_policy.cfm?id=#policy_id#"><img id="Picture70" height="19" width="19"
 src="copy_icon.png" border="0" alt="Copy
 Policy" title="Copy Policy"/></a></td>
          </tr>
         </table>
        </td>
        <td width="29" id="Cell603">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="view_policy.cfm?id=#policy_id#"><img id="Picture38" height="19" width="17"
 src="view_icon.png" border="0" alt="View
 Policy" title="View Policy"/></a></td>
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
</cfoutput>
</table>&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953" id="Text459" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">
<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you cannot delete a system policy</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Policy added. Please assign users to it below</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Policy updated</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon">&nbsp;you cannot delete a policy that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon">&nbsp;policy does not exist or you are attempting to edit a policy that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon">&nbsp;you cannot delete a policy that's already assigned to users. Assign users to a different policy and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Policy Successfully Deleted!!</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Policy Changes Successfully Saved!!</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="14" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="503"></td>
                          <td width="3"></td>
                          <td width="442"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="8" valign="middle" width="953"><hr id="HRRule25" width="953" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="4" width="506" id="Text443" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">SVF Custom Policies</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="25"></td>
                          <td colspan="7" width="952">
                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion22" style="height: 25px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="952">
                                    <tr valign="top" align="left">
                                      <td width="952" id="Text438" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="getuserpolicies" datasource="#datasource#">
select * from spam_policies where custom='1' and system<>'1' order by policy_name asc
</cfquery>

<cfif #getuserpolicies.recordcount# LT 1>
<br>
<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">You do not have any custom policies defined. The best way to create a custom policy is to click the Copy Policy button and a create a new copy of one of the existing custom policies, customize the new policy and assign recipients to it</span></b></p>

<cfelse>

<table id="Table100" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(219,217,217); border-left-style: solid;
 border-top-color:  rgb(219,217,217); border-top-style: solid; border-right-color:  rgb(219,217,217); border-right-style: solid; border-bottom-color:
  rgb(219,217,217); border-bottom-style: solid; height: 45px;">
 <tr style="height: 28px;">
  <td width="246" style="background-color: rgb(241,236,236);" id="Cell609">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Policy Name</span></b></p>
  </td>
  <td width="91" style="background-color: rgb(241,236,236);" id="Cell610">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">System Policy</span></b></p>
  </td>
  <td width="83" style="background-color: rgb(241,236,236);" id="Cell611">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Spam Tag Score</span></b></p>
  </td>
  <td width="82" style="background-color: rgb(241,236,236);" id="Cell612">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Spam Quarantine Score</span></b></p>
  </td>
  <td width="82" style="background-color: rgb(241,236,236);" id="Cell612">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">File Rule</span></b></p>
  </td>
  <td width="124" style="background-color: rgb(241,236,236);" id="Cell613">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Actions</span></b></p>
  </td>
 </tr>
 <cfoutput query="getuserpolicies">
<cfquery name="getpolicysettings" datasource="#datasource#">
select * from policy where id='#policy_id#'
</cfquery>
 <tr style="height: 21px;">
  <td id="Cell614">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#policy_name#</span></p>
  </td>
  <td id="Cell615">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">No</span></p>
  </td>
  <td id="Cell616">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 9px; color:
 rgb(128,128,128);">#Numberformat (getpolicysettings.spam_tag2_level, '____.__')#</span></p>
  </td>
  <td id="Cell617">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#Numberformat (getpolicysettings.spam_kill_level, '____.__')#</span></p>
  </td>
<td id="Cell617">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#getpolicysettings.banned_rulenames#</span></p>
  </td>
  <td id="Cell618">
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
     <td align="center">
      <table id="Table101" border="0" cellspacing="0" cellpadding="0" width="108" style="height: 21px;">
       <tr style="height: 21px;">
        <td width="30" id="Cell620">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="copy_policy.cfm?id=#policy_id#"><img id="Picture71" height="19" width="19"
 src="copy_icon.png" border="0" alt="Copy
 Policy" title="Copy Policy"/></a></td>
          </tr>
         </table>
        </td>
        <td width="30" id="Cell621">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="edit_policy.cfm?id=#policy_id#"><img id="Picture67" height="21" width="21"
 src="configure_icon.png" border="0"
 alt="Edit/View Policy" title="Edit/View Policy"/></a></td>
          </tr>
         </table>
        </td>
       
        <td width="24" id="Cell625">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="delete_policy.cfm?id=#policy_id#"><img id="Picture69" height="19" width="19"
 src="delete_icon.png" border="0" alt="Delete
 Policy" title="Delete Policy"/></a></td>
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
 </cfoutput>
</table>
</cfif>&nbsp;</p>
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
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="6" valign="middle" width="951"><hr id="HRRule26" width="951" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="57"></td>
                          <td colspan="5" width="950"><cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfif #filter# is "">
<cfquery name="getaccountusers" datasource="#datasource#">
select * from recipients where domain is NULL order by recipient asc
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
<cfquery name="getaccountusers" datasource="#datasource#">
select * from recipients where domain is NULL and recipient like '%#filter#%' order by recipient asc
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion21" style="height: 57px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="624">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="policies_filter.cfm#mappings" method="post">
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
                                              <form name="Table145FORM" action="policies_filter.cfm#mappings" method="post">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="15"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text381" class="TextObject">
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
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="4" valign="middle" width="949"><hr id="HRRule27" width="949" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td colspan="2" width="506" id="Text444" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Recipients to Policies Mappings</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="118"></td>
                          <td colspan="4" width="949"><CFPARAM NAME="StartRow" DEFAULT="1">
<CFSET DisplayRows = 50>
<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFIF ToRow GT getaccountusers.RecordCount>
<CFSET ToRow = getaccountusers.RecordCount>
</CFIF>

<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>
                            <table border="0" cellspacing="0" cellpadding="0" width="949" id="LayoutRegion23" style="height: 118px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="948">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="451" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="spam_policies.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows###mappings"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Recipients</SPAN></b></P>
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
                                            <td width="488" id="Cell871">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getaccountusers.RecordCount>
<A HREF="spam_policies.cfm?StartRow=#Next#&DisplayRows=#DisplayRows###mappings"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getaccountusers.RecordCount - Next) LT DisplayRows>
      #Evaluate((getaccountusers.RecordCount - Next)+1)#
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
                                      <td width="949" height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="949" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getaccountusers.recordcount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getaccountusers.recordcount# total internal recipients</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="949">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="40" width="949">
                                        <table border="0" cellspacing="0" cellpadding="0" width="949" id="LayoutRegion28" style="padding-bottom: 29px; height: 40px;">
                                          <tr align="left" valign="top">
                                            <td>
                                              <form name="LayoutRegion28FORM" action="<cfoutput>assign_policies.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                                <table border="0" cellspacing="0" cellpadding="0" width="949">
                                                  <tr valign="top" align="left">
                                                    <td width="949" id="Text284" class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #getaccountusers.recordcount# LT 1>
<br>
<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">You have not added any recipients in the system. Please add some recipients and then return to this section.</span></b></p>

<cfelse>


<table id="Table78" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(255,255,255); border-left-style: solid;
 border-top-color:  rgb(255,255,255); border-top-style: solid; border-right-color:  rgb(255,255,255); border-right-style: solid; border-bottom-color:
  rgb(255,255,255); border-bottom-style: solid; height: 13px;">
 <tr style="height: 14px;">
  
  <td width="318" style="background-color: rgb(241,236,236);" id="Cell482">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">E-mail Address</span></b></p>
  </td>
  <td width="272" style="background-color: rgb(241,236,236);" id="Cell628">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Assigned Policy</span></b></p>
  </td>
 </tr>

<cfoutput query="getaccountusers" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">

 <tr style="height: 27px;">

  <td id="Cell491">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#recipient#</span></p>
  </td>

  <td id="Cell629">
   <p style="text-align: center; margin-bottom: 0px;">


<select name="policy#id#" style="height: 24px;">

<cfquery name="policydetails" datasource="#datasource#">
select id, policy_name as thePolicyName from policy where id='#policy_id#'
</cfquery>
     <option value="#recipient#_#policy_id#" selected="selected">#policydetails.thePolicyName#</option>
<cfquery name="getnotassignedpolicies" datasource="#datasource#">
select * from policy where id<>'#policy_id#'
</cfquery>
     <cfloop query="getnotassignedpolicies">
     <option value="#recipient#_#id#">#policy_name#</option> 
     </cfloop>
    </select>
   </p>
  </td>
 </tr>
 </cfoutput>



</table>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr valign="top" align="left">
                                                    <td height="4"></td>
                                                  </tr>
                                                  <tr valign="top" align="left">
                                                    <td width="949" id="Text287" class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #getaccountusers.recordcount# LT 1>
<p style="margin-bottom: 0px;"><table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
  <tr style="height: 24px;">
   <td width="619" id="Cell435">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
     <tr>
      <td align="center"><input type="submit" id="FormsButton1" name="FormsButton1" value="Submit" disabled="disabled" style="height: 24px; width: 120px;" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();"></input></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>&nbsp;</p>

<cfelseif #getaccountusers.recordcount# GTE 1>

<p style="margin-bottom: 0px;"><table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
  <tr style="height: 24px;">
   <td width="619" id="Cell435">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
     <tr>
      <td align="center"><input type="submit" id="FormsButton1" name="FormsButton1" value="Submit" style="height: 24px; width: 120px;" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();"></input></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>&nbsp;</p>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </form>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="949" id="Text185" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">
<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a system policy</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Policy added. Please assign users to it above</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Policy updated</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a policy that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;policy does not exist or you are attempting to edit a policy that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a policy that's already assigned to users. Assign users to a different policy and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Policy Successfully Deleted!!</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Policy Changes Successfully Saved!!</span></i></b></p>
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