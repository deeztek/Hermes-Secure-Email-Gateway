<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SPF Configuration</title>
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
<body style="background-color: rgb(192,192,192); background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./top_blue_3.png'); height: 131px;">
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
              <td height="774" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 774px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="514">
                              <tr valign="top" align="left">
                                <td width="8" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">SPF Configuration</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="456">
                              <tr valign="top" align="left">
                                <td width="431" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/spf-configuration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="960">
                        <tr valign="top" align="left">
                          <td width="9" height="6"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>SPF</b> (<b>Sender Policy Framework Checks)</b> is set to <b>enabled</b> under <a href="./perimeter_configuration.cfm"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="9" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="957"><hr id="HRRule4" width="957" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="8" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="556"></td>
                          <td width="961"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif>

<cfquery name="get_debugLevel" datasource="#datasource#">
select value2 from parameters2 where parameter='debugLevel' and module = 'spf'
</cfquery>

<cfquery name="get_TestOnly" datasource="#datasource#">
select value2 from parameters2 where parameter='TestOnly' and module = 'spf'
</cfquery>


<cfquery name="get_HELO_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='HELO_reject' and module = 'spf'
</cfquery>

<cfquery name="get_Mail_From_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='Mail_From_reject' and module = 'spf'
</cfquery>

<cfquery name="get_PermError_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='PermError_reject' and module = 'spf'
</cfquery>

<cfquery name="get_TempError_Defer" datasource="#datasource#">
select value2 from parameters2 where parameter='TempError_Defer' and module = 'spf'
</cfquery>

<cfparam name = "debugLevel" default = "#get_debugLevel.value2#"> 
<cfif IsDefined("form.debugLevel") is "True">
<cfif form.debugLevel is not "">
<cfset debugLevel = form.debugLevel>
</cfif></cfif> 

<cfparam name = "TestOnly" default = "#get_TestOnly.value2#"> 
<cfif IsDefined("form.TestOnly") is "True">
<cfif form.TestOnly is not "">
<cfset TestOnly = form.TestOnly>
</cfif></cfif> 


<cfparam name = "HELO_reject" default = "#get_HELO_reject.value2#"> 
<cfif IsDefined("form.HELO_reject") is "True">
<cfif form.HELO_reject is not "">
<cfset HELO_reject = form.HELO_reject>
</cfif></cfif> 

<cfparam name = "Mail_From_reject" default = "#get_Mail_From_reject.value2#"> 
<cfif IsDefined("form.Mail_From_reject") is "True">
<cfif form.Mail_From_reject is not "">
<cfset Mail_From_reject = form.Mail_From_reject>
</cfif></cfif> 

<cfparam name = "PermError_reject" default = "#get_PermError_reject.value2#"> 
<cfif IsDefined("form.PermError_reject") is "True">
<cfif form.PermError_reject is not "">
<cfset PermError_reject = form.PermError_reject>
</cfif></cfif> 

<cfparam name = "TempError_Defer" default = "#get_TempError_Defer.value2#"> 
<cfif IsDefined("form.TempError_Defer") is "True">
<cfif form.TempError_Defer is not "">
<cfset TempError_Defer = form.TempError_Defer>
</cfif></cfif> 

<cfif #show_action# is "edit">


<cfquery name="updatedebugLevel" datasource="#datasource#">
update parameters2 set 
value2='#debugLevel#',
applied='2'
where
parameter='debugLevel' and module = 'spf'
</cfquery>


<cfquery name="updateTestOnly" datasource="#datasource#">
update parameters2 set 
value2='#TestOnly#',
applied='2'
where
parameter='TestOnly' and module = 'spf'
</cfquery>


<cfquery name="updateHELO_reject" datasource="#datasource#">
update parameters2 set 
value2='#HELO_reject#',
applied='2'
where
parameter='HELO_reject' and module = 'spf'
</cfquery>

<cfquery name="updateMail_From_reject" datasource="#datasource#">
update parameters2 set 
value2='#Mail_From_reject#',
applied='2'
where
parameter='Mail_From_reject' and module = 'spf'
</cfquery>

<cfquery name="updatePermError_reject" datasource="#datasource#">
update parameters2 set 
value2='#PermError_reject#',
applied='2'
where
parameter='PermError_reject' and module = 'spf'
</cfquery>


<cfquery name="updateTempError_Defer" datasource="#datasource#">
update parameters2 set 
value2='#TempError_Defer#',
applied='2'
where
parameter='TempError_Defer' and module = 'spf'
</cfquery>




<cfset m=3>

<!-- /CFIF FOR ACTION -->
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion11" style="height: 556px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="3"></td>
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 424px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1044">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Logging Level</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 114px;">
                                              <td id="Cell1042">
                                                <table width="923" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table163" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 119px;">
                                                        <tr style="height: 19px;">
                                                          <td width="57" id="Cell1021">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "1">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "1">
<cfoutput>
<input type="radio" name="debugLevel" value="1" style="height: 13px; width: 13px;">
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
                                                          <td width="866" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Level 1</span> <span style="font-weight: normal;">( </span>Default<span style="font-weight: normal;">. Log only basic policy results and errors)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1023">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "2">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "2">
<cfoutput>
<input type="radio" name="debugLevel" value="2" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 2 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1104">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "3">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="3" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "3">
<cfoutput>
<input type="radio" name="debugLevel" value="3" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1105">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 3 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1106">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "4">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="4" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "4">
<cfoutput>
<input type="radio" name="debugLevel" value="4" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1107">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 4 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs the complete data set received by SMTP server)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1110">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "0">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="0" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "0">
<cfoutput>
<input type="radio" name="debugLevel" value="0" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1111">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 0 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs only errors)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1112">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #debugLevel# is "-1">
<cfoutput>
<input type="radio" checked="checked" name="debugLevel" value="-1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #debugLevel# is not "-1">
<cfoutput>
<input type="radio" name="debugLevel" value="-1" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1113">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>No Logging </b><span style="color: rgb(128,128,128); font-weight: normal;">(Disables logging. Do not use unless necessary)</span></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1045">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Test Mode</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1041">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table164" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1027">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #TestOnly# is "2">
<cfoutput>
<input type="radio" checked="checked" name="TestOnly" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #TestOnly# is not "2">
<cfoutput>
<input type="radio" name="TestOnly" value="2" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">No</span> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> SPF Server Normal Operation)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #TestOnly# is "1">
<cfoutput>
<input type="radio" checked="checked" name="TestOnly" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #TestOnly# is not "1">
<cfoutput>
<input type="radio" name="TestOnly" value="1" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Yes&nbsp; </b><span style="color: rgb(128,128,128); font-weight: normal;">(Run SPF Server in test mode to see potential impact of SPF checking without rejecting email)</span></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1040">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">HELO Check Rejection Policy</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 102px;">
                                              <td id="Cell1039">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1034">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "Fail">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="Fail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "Fail">
<cfoutput>
<input type="radio" name="HELO_reject" value="Fail" style="height: 13px; width: 13px;">
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
                                                          <td width="541" id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Fail</span> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Reject only on HELO Fail)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1036">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "SPF_Not_Pass">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "SPF_Not_Pass">
<cfoutput>
<input type="radio" name="HELO_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SPF Not Pass </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result is Fail, Softfail, Neutral or PermError)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1114">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "Softfail">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="Softfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "Softfail">
<cfoutput>
<input type="radio" name="HELO_reject" value="Softfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1115">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SoftFail </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result is Softfail or Fail)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1116">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "Null">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="Null" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "Null">
<cfoutput>
<input type="radio" name="HELO_reject" value="Null" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1117">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Null </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject only HELO for Null Sender. Do not use unless necessary)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1118">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "False">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="False" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "False">
<cfoutput>
<input type="radio" name="HELO_reject" value="False" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1119">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never reject on HELO, append header only)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1120">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HELO_reject# is "No_Check">
<cfoutput>
<input type="radio" checked="checked" name="HELO_reject" value="No_Check" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #HELO_reject# is not "No_Check">
<cfoutput>
<input type="radio" name="HELO_reject" value="No_Check" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1121">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>No Check </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never check HELO)</span></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1038">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Mail From Check Rejection Policy</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell565">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell604">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #Mail_From_reject# is "Fail">
<cfoutput>
<input type="radio" checked="checked" name="Mail_From_reject" value="Fail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #Mail_From_reject# is not "Fail">
<cfoutput>
<input type="radio" name="Mail_From_reject" value="Fail" style="height: 13px; width: 13px;">
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
                                                          <td width="542" id="Cell605">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Fail</b><b><span style="color: rgb(128,128,128);"> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Reject on Mail From Fail)</span></span></b></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell606">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #Mail_From_reject# is "SPF_Not_Pass">
<cfoutput>
<input type="radio" checked="checked" name="Mail_From_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #Mail_From_reject# is not "SPF_Not_Pass">
<cfoutput>
<input type="radio" name="Mail_From_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell607">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SPF Not Pass </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result not Pass/None/Tempfail. Do not use this option unless necessary)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1048">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #Mail_From_reject# is "Softfail">
<cfoutput>
<input type="radio" checked="checked" name="Mail_From_reject" value="Softfail" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #Mail_From_reject# is not "Softfail">
<cfoutput>
<input type="radio" name="Mail_From_reject" value="Softfail" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1049">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>SoftFail </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject on Mail From Softfail or Fail. Do not use this option unless necessary)</span></span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1050">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #Mail_From_reject# is "False">
<cfoutput>
<input type="radio" checked="checked" name="Mail_From_reject" value="False" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #Mail_From_reject# is not "False">
<cfoutput>
<input type="radio" name="Mail_From_reject" value="False" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1051">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never reject Mail From, append headers only)</span></span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1052">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #Mail_From_reject# is "No_Check">
<cfoutput>
<input type="radio" checked="checked" name="Mail_From_reject" value="No_Check" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #Mail_From_reject# is not "No_Check">
<cfoutput>
<input type="radio" name="Mail_From_reject" value="No_Check" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1053">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>No Check </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never check Mail From)</span></span></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell609">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Permanent Error Processing</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell611">
                                                <table width="659" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1054">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #PermError_reject# is "False">
<cfoutput>
<input type="radio" checked="checked" name="PermError_reject" value="False" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #PermError_reject# is not "False">
<cfoutput>
<input type="radio" name="PermError_reject" value="False" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="604" id="Cell1055">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(<b>Default.</b> Treat PermError the same as no SPF record at all)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1056">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PermError_reject# is "True">
<cfoutput>
<input type="radio" checked="checked" name="PermError_reject" value="True" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #PermError_reject# is not "True">
<cfoutput>
<input type="radio" name="PermError_reject" value="True" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1057">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>True</b><b><span style="color: rgb(128,128,128);"> <span style="font-weight: normal;">(Reject mail if the SPF result (HELO Check or Mail From Check) is PermError)</span></span></b></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell749">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Temporary Error Processing</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell751">
                                                <table width="661" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table167" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="56" id="Cell1064">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #TempError_Defer# is "False">
<cfoutput>
<input type="radio" checked="checked" name="TempError_Defer" value="False" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #TempError_Defer# is not "False">
<cfoutput>
<input type="radio" name="TempError_Defer" value="False" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>



&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="605" id="Cell1065">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(128,128,128);"></span>False </b><b><span style="color: rgb(128,128,128);"><span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Treat TempError the same as no SPF record at all. </span></span></b></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1066">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #TempError_Defer# is "True">
<cfoutput>
<input type="radio" checked="checked" name="TempError_Defer" value="True" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #TempError_Defer# is not "True">
<cfoutput>
<input type="radio" name="TempError_Defer" value="True" style="height: 13px; width: 13px;">
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
                                                          <td id="Cell1067">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>True </b><span style="color: rgb(128,128,128); font-weight: normal;">(Defer the message of the SPF result (HELO check or Mail From Check) is TempError)</span></span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        <td width="956" height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Message Size Limit</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid RBL Block Score</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Message Size Limit must be greater than 0</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
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
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="8" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="957"><hr id="HRRule3" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

<!-- GENERATE CUSTOM TRANSACTION STARTS HERE -->

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

<!-- GENERATE CUSTOM TRANSACTION ENDS HERE -->

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE STARTS HERE -->
<cfquery name="get_debugLevel" datasource="#datasource#">
select value2 from parameters2 where parameter='debugLevel' and module = 'spf'
</cfquery>

<cfquery name="get_TestOnly" datasource="#datasource#">
select value2 from parameters2 where parameter='TestOnly' and module = 'spf'
</cfquery>


<cfquery name="get_HELO_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='HELO_reject' and module = 'spf'
</cfquery>

<cfquery name="get_Mail_From_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='Mail_From_reject' and module = 'spf'
</cfquery>

<cfquery name="get_PermError_reject" datasource="#datasource#">
select value2 from parameters2 where parameter='PermError_reject' and module = 'spf'
</cfquery>

<cfquery name="get_TempError_Defer" datasource="#datasource#">
select value2 from parameters2 where parameter='TempError_Defer' and module = 'spf'
</cfquery>

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE ENDS HERE -->

<!-- UPDATE SPF CONFIGURATION PARAMETERS IN policyd-spf.conf FILE STARTS HERE -->

<!-- READ /OPT/HERMES/TEMPLATES/POLICYD-SPF.CONF.HERMES TEMPLATE FILE -->

<cffile action="read" file="/opt/hermes/templates/policyd-spf.conf.HERMES" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","DEBUG-LEVEL","#get_debugLevel.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","TEST-ONLY","#get_TestOnly.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","HELO-REJECT","#get_HELO_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","MAIL-FROM-REJECT","#get_Mail_From_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","PERMERROR-REJECT","#get_PermError_reject.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="policydfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#policydfile#","TEMPERROR-REJECT","#get_TempError_Defer.value2#","ALL")#">

<!-- UPDATE SPF CONFIGURATION PARAMETERS ENDS HERE -->

<!-- ADD SPF BYPASS PARAMETERS HERE -->

<!-- RESET ALL APPLIED TO 2 -->
<cfquery name="resetall" datasource="#datasource#">
update spf_bypass set applied='2'
</cfquery>

<!-- GET ALL ADD IP ACTIONS -->
<cfquery name="getaddip" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='ip'
</cfquery>

<!-- GET ALL ADD NETWORK ACTIONS -->
<cfquery name="getaddnetwork" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='network'
</cfquery>

<!-- GET ALL ADD HELO ACTIONS -->
<cfquery name="getaddhelo" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='helo'
</cfquery>

<!-- GET ALL ADD DOMAIN ACTIONS -->
<cfquery name="getadddomain" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='domain'
</cfquery>

<!-- GET ALL ADD PTR ACTIONS -->
<cfquery name="getaddptr" datasource="#datasource#">
select * from spf_bypass where action='add' and entry_type='ptr'
</cfquery>


<!-- CREATE FILEDATAADDIP VARIABLE AND INSERT ADD IP ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddIp = "">
<cfloop query="getaddip">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddip.currentrow# NEQ #getaddip.recordcount#> 
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA NORMALLY, BUT SINCE THE IP AND NETWORK GO ON THE SAME LINE, WE ADD A COMMA HERE BECAUSE NETWORK
 ADDRESSES WILL FOLLOW -->
<cfelseif #getaddip.currentrow# EQ #getaddip.recordcount#>
<cfset FileDataAddIp = FileDataAddIp & getaddip.entry & #Chr(44)#>

<!-- /CFIF FOR GETADDIP.CURRENTROW -->
</cfif>

</cfloop>


<!-- CREATE FILEDATAADDNETWORK VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddNetwork = "">
<cfloop query="getaddnetwork">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddnetwork.currentrow# NEQ #getaddnetwork.recordcount#> 
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddnetwork.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddnetwork.currentrow# EQ #getaddnetwork.recordcount#>
<cfset FileDataAddNetwork = FileDataAddNetwork & getaddNetwork.entry>

<!-- /CFIF FOR GETADDNETWORK.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDHELO VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddHelo = "">
<cfloop query="getaddhelo">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddhelo.currentrow# NEQ #getaddhelo.recordcount#> 
<cfset FileDataAddHelo = FileDataAddHelo & getaddhelo.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddhelo.currentrow# EQ #getaddhelo.recordcount#>
<cfset FileDataAddHelo = FileDataAddHelo & getaddHelo.entry>

<!-- /CFIF FOR GETADDHELO.CURRENTROW -->
</cfif>

</cfloop>

<!-- CREATE FILEDATAADDDOMAIN VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddDomain = "">
<cfloop query="getadddomain">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getadddomain.currentrow# NEQ #getadddomain.recordcount#> 
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getadddomain.currentrow# EQ #getadddomain.recordcount#>
<cfset FileDataAddDomain = FileDataAddDomain & getadddomain.entry>

<!-- /CFIF FOR GETADDDOMAIN.CURRENTROW -->
</cfif>
</cfloop>

<!-- CREATE FILEDATAADDPTR VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
<cfset FileDataAddPtr = "">
<cfloop query="getaddptr">

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
<cfif #getaddptr.currentrow# NEQ #getaddptr.recordcount#> 
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry & #Chr(44)#>

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
<cfelseif #getaddptr.currentrow# EQ #getaddptr.recordcount#>
<cfset FileDataAddPtr = FileDataAddPtr & getaddptr.entry>

<!-- /CFIF FOR GETADDPTR.CURRENTROW -->
</cfif>

</cfloop>

<!-- READ /OPT/HERMES/TMP/#CUSTOMTRANS3_POLICYD-SPF.CONF FILE CREATED ABOVE -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- CREATE TEMP FILE AND REPLACE IP-NETWORK-WHITELIST PLACEHOLDER WITH IPS AND NETWORK ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","IP-NETWORK-WHITELIST","#FileDataAddIp##FileDataAddNetwork#","ALL")#"> 
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE HELO-WHITELIST PLACEHOLDER WITH HELO ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","HELO-WHITELIST","#FileDataAddHelo#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE DOMAIN-WHITELIST PLACEHOLDER WITH DOMAIN ENTRIES --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","DOMAIN-WHITELIST","#FileDataAddDomain#","ALL")#">
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_policyd-spf.conf" variable="theSPF">
  
<!-- REPLACE PTR-WHITELIST PLACEHOLDER WITH PTR ENTRIES -->  
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_policyd-spf.conf"
    output = "#REReplace("#theSPF#","PTR-WHITELIST","#FileDataAddPtr#","ALL")#">


<!-- ADD SPF BYPASS ENDS HERE -->



<!-- MAKE A BACKUP OF EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE -->

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix-policyd-spf-python/policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">


<!-- CREATE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT AND INSERT MAKE A BACKUP OF EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND -->

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/postfix-policyd-spf-python/policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<!--  APPEND MOVE AND REPLACE EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND WITH ONE WE CREATED ABOVE COMMAND IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH
 SCRIPT CREATED ABOVE -->
<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf#chr(10)#"
addnewline="no">

<!-- APPEND CREATE POSTFIX RESTART COMMAND TO APPLY CHANGES IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT SCRIPT CREATED ABOVE -->

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/systemctl restart postfix #chr(10)#"
addnewline="no">


<!-- MAKE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT EXECUTABLE -->

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>


<!-- EXECUTE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT -->

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<!-- DELETE POSTFIX RESTART SCRIPT TO APPLY CHANGES -->

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">
    
 


<!-- SET ALL SPF PARAMETERS TO APPLIED -->
<cfquery name="completespf" datasource="#datasource#">
update parameters2 set applied='1' where module = 'spf'
</cfquery>

<!-- SET ALL SPF BYPASS TO APPLIED -->
<cfquery name="spfapplied" datasource="#datasource#">
update spf_bypass set applied='1'
</cfquery>

<!-- /CFIF FOR ACTION -->
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="spf_configuration.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters2 where module='spf' and applied='2'
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="955">
                                    <tr valign="top" align="left">
                                      <td width="8" height="4"></td>
                                      <td width="947"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="947" id="Text351" class="TextObject">
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
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