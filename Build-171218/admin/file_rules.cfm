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
<title>File Rules</title>
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
              <td height="573" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 573px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="516">
                              <tr valign="top" align="left">
                                <td width="9" height="23"></td>
                                <td width="1"></td>
                                <td width="505"></td>
                                <td width="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">File Rules</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="4"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text484" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">System File Rules</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="454">
                              <tr valign="top" align="left">
                                <td width="429" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/file-rules/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="7" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="46"></td>
                          <td width="962"><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif> 
                            <table border="0" cellspacing="0" cellpadding="0" width="962" id="LayoutRegion11" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="perimeter_configuration.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="962">
                                      <tr valign="top" align="left">
                                        <td colspan="2" width="962" id="Text280" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfquery name="getrules" datasource="#datasource#">
select distinct(rule_id), system, rule_name from file_rule_components where system='1' order by rule_name asc
</cfquery>

<table id="Table97" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(219,217,217); border-left-style: solid;
 border-top-color:  rgb(219,217,217); border-top-style: solid; border-right-color:  rgb(219,217,217); border-right-style: solid; border-bottom-color:
  rgb(219,217,217); border-bottom-style: solid; height: 45px;">
 <tr style="height: 28px;">
  <td width="253" style="background-color: rgb(241,236,236);" id="Cell595">
   <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Rule Name</span></b></p>
  </td>
  <td width="93" style="background-color: rgb(241,236,236);" id="Cell596">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">System Rule</span></b></p>
  </td>
  
  <td width="111" style="background-color: rgb(241,236,236);" id="Cell607">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Actions</span></b></p>
  </td>
 </tr>

<cfoutput query="getrules">

 <tr style="height: 21px;">
  <td id="Cell599">
   <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#rule_name#</span></p>
  </td>
  <td id="Cell601">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">Yes</span></p>
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
           <td align="center"><a href="copy_rule.cfm?id=#rule_id#"><img id="Picture70" height="19" width="19"
 src="copy_icon.png" border="0" alt="Copy
 Rule" title="Copy Rule"/></a></td>
          </tr>
         </table>
        </td>
        <td width="29" id="Cell603">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="view_rule.cfm?id=#rule_id#"><img id="Picture38" height="19" width="17"
 src="view_icon.png" border="0" alt="View
 Rule" title="View Rule"/></a></td>
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
                                        <td width="638" height="12"></td>
                                        <td width="324"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="638" id="Text458" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;All File Rule operations cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a system File Rule</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! File Rule added. Please assign rule to a policy under Content Checks >> Spam/Virus/File Policies</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! File Rule updated</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a File Rule that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;File Rule does not exist or you are attempting to edit a File Rule that is not managed by you</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you cannot delete a File rule that's already assigned to a Spam/Virus/File Policy. Remove the File Rule assignment by going to Content Checks >> Spam/Virus/File Policy and then delete the File Rule</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;File Rule Successfully Deleted!!</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;File Rule Changes Successfully Saved!!</span></i></b></p>
</cfoutput>
</cfif>



&nbsp;</p>
                                        </td>
                                        <td></td>
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
                          <td width="6" height="2"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="452"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="960"><hr id="HRRule20" width="960" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text443" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Custom File Rules</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="4" width="960">
                            <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion22" style="height: 30px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion22FORM" action="perimeter_configuration.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="960">
                                      <tr valign="top" align="left">
                                        <td width="960" id="Text438" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfquery name="getuserrules" datasource="#datasource#">
select distinct(rule_id), system, rule_name from file_rule_components where system='2' order by rule_name asc
</cfquery>

<cfif #getuserrules.recordcount# LT 1>
<br>
<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">You do not have any custom file rules defined. The easiest way to create a custom file rule is to click the Copy Rule button from the System File Rules above in order create a copy of one of the existing system file rules and then customize it and then assign it to Spam/Virus/File Policies. Alternatively, you can create a new file rule from scratch by clicking the button below</span></b></p>

<cfelse>

<table id="Table100" border="0" cellspacing="4" cellpadding="0" width="100%" style="border-left-color:  rgb(219,217,217); border-left-style: solid;
 border-top-color:  rgb(219,217,217); border-top-style: solid; border-right-color:  rgb(219,217,217); border-right-style: solid; border-bottom-color:
  rgb(219,217,217); border-bottom-style: solid; height: 45px;">
 <tr style="height: 28px;">
  <td width="253" style="background-color: rgb(241,236,236);" id="Cell609">
   <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Rule Name</span></b></p>
  </td>
  <td width="93" style="background-color: rgb(241,236,236);" id="Cell610">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">System Rule</span></b></p>
  </td>
  
  <td width="111" style="background-color: rgb(241,236,236);" id="Cell613">
   <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(51,51,51);">Actions</span></b></p>
  </td>
 </tr>
 <cfoutput query="getuserrules">

 <tr style="height: 21px;">
  <td id="Cell614">
   <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">#rule_name#</span></p>
  </td>
  <td id="Cell615">
   <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(128,128,128);">No</span></p>
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
           <td align="center"><a href="copy_rule.cfm?id=#rule_id#"><img id="Picture71" height="19" width="19"
 src="copy_icon.png" border="0" alt="Copy
 Rule" title="Copy Policy"/></a></td>
          </tr>
         </table>
        </td>
        <td width="30" id="Cell621">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="copy_rule2.cfm?id=#rule_id#"><img id="Picture67" height="21" width="21"
 src="configure_icon.png" border="0"
 alt="Edit/View Rule" title="Edit/View Rule"/></a></td>
          </tr>
         </table>
        </td>
       
        <td width="24" id="Cell625">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td align="center"><a href="delete_rule.cfm?id=#rule_id#"><img id="Picture69" height="19" width="19"
 src="delete_icon.png" border="0" alt="Delete
 Rule" title="Delete Rule"/></a></td>
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
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="959" id="Text440" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><form name="create_rule" action="create_file_rule.cfm" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Create Custom File Rule" style="height: 24px; width: 357px;">


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

&nbsp;</p>
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