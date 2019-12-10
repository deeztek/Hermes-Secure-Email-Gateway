<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Firewall Settings</title>
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
              <td height="501" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 501px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="518">
                              <tr valign="top" align="left">
                                <td width="10" height="17"></td>
                                <td width="508"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="508" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Administration Console Firewall Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="422">
                              <tr valign="top" align="left">
                                <td width="5" height="24"></td>
                                <td width="417"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="417" id="Text466" class="TextObject"><cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>



<cfoutput>
<p style="text-align: right; margin-bottom: 0px;"><span style="font-family:
 Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Your IP Address is:
 <b>#GetHttpRequestData().headers['X-Forwarded-For']#</b></span></p>
</cfoutput>


                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="30">
                              <tr valign="top" align="left">
                                <td width="5" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/admin-console-firewall/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="9" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="110"></td>
                          <td width="961"><cfparam name = "m" default = "0">
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif>
</cfif>

<cfparam name = "m2" default = "0">

<cfparam name = "m3" default = "0">
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif>
</cfif>

<cfparam name = "step" default = "0"> 

<cfquery name="checkstatus" datasource="#datasource#">
select value2 from parameters2 where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>

<cfparam name = "firewall_status" default = "#checkstatus.value2#"> 
<cfif IsDefined("form.firewall_status") is "True">
<cfif form.firewall_status is not "">
<cfset firewall_status = form.firewall_status>
</cfif>
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion12" style="height: 110px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion12FORM" action="edit_firewall.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="510">
                                      <tr valign="top" align="left">
                                        <td width="9"></td>
                                        <td width="501" id="Text291" class="TextObject">
                                          <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Firewall Status</span></b></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="600">
                                          <table id="Table79" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                            <tr style="height: 17px;">
                                              <td width="45" id="Cell449">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="left">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #firewall_status# is "enabled">
<cfoutput>
<input type="radio" checked="checked" name="firewall_status" value="enabled" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #firewall_status# is not "enabled">
<cfoutput>
<input type="radio" name="firewall_status" value="enabled" style="height: 13px; width: 13px;">
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
                                              <td width="555" id="Cell450">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enabled<span style="font-weight: normal;"> (Only Specified IP Addresses Allowed. </span><span style="color: rgb(255,0,0);">DO NOT Enable unless your IP Address is allowed</span><span style="font-weight: normal;">)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell451">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="left">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #firewall_status# is "disabled">
<cfoutput>
<input type="radio" checked="checked" name="firewall_status" value="disabled" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #firewall_status# is not "disabled">
<cfoutput>
<input type="radio" name="firewall_status" value="disabled" style="height: 13px; width: 13px;">
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
                                              <td id="Cell452">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled<span style="font-weight: normal;"> (All IP Addresses Allowed)</span></span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961">
                                          <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="961" id="Cell1033">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="961">
                                      <tr valign="top" align="left">
                                        <td width="961" height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961" id="Text467" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Cannot enable firewall unless current IP is in the Allowed IP list</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Firewall Enabled.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Firewall Disabled.</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="9" height="4"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule4" width="960" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td width="960"><cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif> 

<!--- VALIDATE IP ADDRESS REGEX --->
<cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

<cfparam name = "firewall_ip" default = ""> 
<cfif IsDefined("form.firewall_ip") is "True">
<cfset firewall_ip = form.firewall_ip>
</cfif>


<cfif #show_action# is "add">

<cfif #firewall_ip# is not "">
<cfif REFind(pattern,firewall_ip) GT 0>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m2=1>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #firewall_ip# is "">
<cfset step=0>
<cfset m2=2>

<!--- /CFIF #firewall_ip# is --->
</cfif>


<cfif step is "1">
<cfset m2=3>

<cfset ipAddr="#firewall_ip#">

<cfquery name="check" datasource="#datasource#">
select ip from firewall where ip = '#ipAddr#'
</cfquery>

<cfif #check.recordcount# LT 1>
<cfquery name="check" datasource="#datasource#">
insert into firewall
(ip)
values
('#ipAddr#')
</cfquery>

<cfelseif #check.recordcount# GTE 1>
<cfset m2=4>

<!--- /CFIF #check.recordcount# is --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<!--- /CFIF FOR ACTION --->
</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion1" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="ipaddressallowedform" action="firewall_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="615">
                                          <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 52px;">
                                            <tr style="height: 19px;">
                                              <td width="615" id="Cell1048">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">IP Address to be allowed</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 32px;">
                                              <td id="Cell1049">
                                                <table width="610" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
<cfoutput>
                                                      <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                        <tr style="height: 24px;">
                                                          <td width="330" id="Cell1050">
                                                            <table width="302" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="text" name="firewall_ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#firewall_ip#">
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="280" id="Cell1057">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      </cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="960">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="960" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Add IP" style="height: 24px; width: 142px;">&nbsp;</p>
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="960">
                                      <tr valign="top" align="left">
                                        <td width="960" height="16"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="960" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid IP Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The IP Address cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! IP Address Added.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The IP Address you are attempting to add already exists</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="2" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule5" width="960" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="9" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td width="963"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif> 

<cfquery name="server_ip_octet1" datasource="#datasource#">
select * from parameters2 where parameter='server_ip_octet1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_ip_octet1" default = "#server_ip_octet1.value2#"> 
<cfif IsDefined("form.server_ip_octet1") is "True">
<cfset show_server_ip_octet1 = form.server_ip_octet1>
</cfif>


<cfquery name="server_ip_octet2" datasource="#datasource#">
select * from parameters2 where parameter='server_ip_octet2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_ip_octet2" default = "#server_ip_octet2.value2#"> 
<cfif IsDefined("form.server_ip_octet2") is "True">
<cfset show_server_ip_octet2 = form.server_ip_octet2>
</cfif>


<cfquery name="server_ip_octet3" datasource="#datasource#">
select * from parameters2 where parameter='server_ip_octet3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_ip_octet3" default = "#server_ip_octet3.value2#"> 
<cfif IsDefined("form.server_ip_octet3") is "True">
<cfset show_server_ip_octet3 = form.server_ip_octet3>
</cfif>

<cfquery name="server_ip_octet4" datasource="#datasource#">
select * from parameters2 where parameter='server_ip_octet4' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_ip_octet4" default = "#server_ip_octet4.value2#"> 
<cfif IsDefined("form.server_ip_octet4") is "True">
<cfset show_server_ip_octet4 = form.server_ip_octet4>
</cfif>

<cfquery name="server_gateway_octet1" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway_octet1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_gateway_octet1" default = "#server_gateway_octet1.value2#"> 
<cfif IsDefined("form.server_gateway_octet1") is "True">
<cfset show_server_gateway_octet1 = form.server_gateway_octet1>
</cfif>

<cfquery name="server_gateway_octet2" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway_octet2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_gateway_octet2" default = "#server_gateway_octet2.value2#"> 
<cfif IsDefined("form.server_gateway_octet2") is "True">
<cfset show_server_gateway_octet2 = form.server_gateway_octet2>
</cfif>


<cfquery name="server_gateway_octet3" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway_octet3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_gateway_octet3" default = "#server_gateway_octet3.value2#"> 
<cfif IsDefined("form.server_gateway_octet3") is "True">
<cfset show_server_gateway_octet3 = form.server_gateway_octet3>
</cfif>

<cfquery name="server_gateway_octet4" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway_octet4' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_gateway_octet4" default = "#server_gateway_octet4.value2#"> 
<cfif IsDefined("form.server_gateway_octet4") is "True">
<cfset show_server_gateway_octet4 = form.server_gateway_octet4>
</cfif>

<cfquery name="server_dns1_octet1" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1_octet1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns1_octet1" default = "#server_dns1_octet1.value2#"> 
<cfif IsDefined("form.server_dns1_octet1") is "True">
<cfset show_server_dns1_octet1 = form.server_dns1_octet1>
</cfif>

<cfquery name="server_dns1_octet2" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1_octet2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns1_octet2" default = "#server_dns1_octet2.value2#"> 
<cfif IsDefined("form.server_dns1_octet2") is "True">
<cfset show_server_dns1_octet2 = form.server_dns1_octet2>
</cfif>


<cfquery name="server_dns1_octet3" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1_octet3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns1_octet3" default = "#server_dns1_octet3.value2#"> 
<cfif IsDefined("form.server_dns1_octet3") is "True">
<cfset show_server_dns1_octet3 = form.server_dns1_octet3>
</cfif>

<cfquery name="server_dns1_octet4" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1_octet4' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns1_octet4" default = "#server_dns1_octet4.value2#"> 
<cfif IsDefined("form.server_dns1_octet4") is "True">
<cfset show_server_dns1_octet4 = form.server_dns1_octet4>
</cfif>

<cfquery name="server_dns2_octet1" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2_octet1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns2_octet1" default = "#server_dns2_octet1.value2#"> 
<cfif IsDefined("form.server_dns2_octet1") is "True">
<cfset show_server_dns2_octet1 = form.server_dns2_octet1>
</cfif>

<cfquery name="server_dns2_octet2" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2_octet2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns2_octet2" default = "#server_dns2_octet2.value2#"> 
<cfif IsDefined("form.server_dns2_octet2") is "True">
<cfset show_server_dns2_octet2 = form.server_dns2_octet2>
</cfif>


<cfquery name="server_dns2_octet3" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2_octet3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns2_octet3" default = "#server_dns2_octet3.value2#"> 
<cfif IsDefined("form.server_dns2_octet3") is "True">
<cfset show_server_dns2_octet3 = form.server_dns2_octet3>
</cfif>

<cfquery name="server_dns2_octet4" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2_octet4' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns2_octet4" default = "#server_dns2_octet4.value2#"> 
<cfif IsDefined("form.server_dns2_octet4") is "True">
<cfset show_server_dns2_octet4 = form.server_dns2_octet4>
</cfif>

<cfquery name="server_dns3_octet1" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3_octet1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns3_octet1" default = "#server_dns3_octet1.value2#"> 
<cfif IsDefined("form.server_dns3_octet1") is "True">
<cfset show_server_dns3_octet1 = form.server_dns3_octet1>
</cfif>

<cfquery name="server_dns3_octet2" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3_octet2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns3_octet2" default = "#server_dns3_octet2.value2#"> 
<cfif IsDefined("form.server_dns3_octet2") is "True">
<cfset show_server_dns3_octet2 = form.server_dns3_octet2>
</cfif>


<cfquery name="server_dns3_octet3" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3_octet3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns3_octet3" default = "#server_dns3_octet3.value2#"> 
<cfif IsDefined("form.server_dns3_octet3") is "True">
<cfset show_server_dns3_octet3 = form.server_dns3_octet3>
</cfif>

<cfquery name="server_dns3_octet4" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3_octet4' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns3_octet4" default = "#server_dns3_octet4.value2#"> 
<cfif IsDefined("form.server_dns3_octet4") is "True">
<cfset show_server_dns3_octet4 = form.server_dns3_octet4>
</cfif>

<cfquery name="server_name" datasource="#datasource#">
select * from parameters2 where parameter='server_name' and module='network' and active='1'
</cfquery>

<cfparam name = "show_server_name" default = "#server_name.value2#"> 
<cfif IsDefined("form.server_name") is "True">
<cfset show_server_name = form.server_name>
</cfif>

<cfquery name="server_domain" datasource="#datasource#">
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
</cfquery>

<cfparam name = "show_server_domain" default = "#server_domain.value2#"> 
<cfif IsDefined("form.server_domain") is "True">
<cfset show_server_domain = form.server_domain>
</cfif>


<cfquery name="server_subnet" datasource="#datasource#">
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
</cfquery>

<cfparam name = "show_server_subnet" default = "#server_subnet.value2#"> 
<cfif IsDefined("form.server_subnet") is "True">
<cfset show_server_subnet = form.server_subnet>
</cfif>

<cfif #show_action# is "edit" and #show_network_mode# is "static">

<cfif #show_server_ip_octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #show_server_ip_octet1# GTE #octet_first# AND #show_server_ip_octet1# LTE #octet_last#>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m=1>
</cfif>
<cfelseif #show_server_ip_octet1# is "">
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif step is "1">

<cfif #show_server_ip_octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #show_server_ip_octet2# GTE #octet2_first# AND #show_server_ip_octet2# LTE #octet2_last#>
<cfset step=2>
<cfelse>
<cfset step=0>
<cfset m=1>
</cfif>
<cfelseif #show_server_ip_octet2# is "">
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif step is "2">

<cfif #show_server_ip_octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #show_server_ip_octet3# GTE #octet3_first# AND #show_server_ip_octet3# LTE #octet3_last#>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m=1>
</cfif>
<cfelseif #show_server_ip_octet3# is "">
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif step is "3">

<cfif #show_server_ip_octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #show_server_ip_octet4# GTE #octet4_first# AND #show_server_ip_octet4# LTE #octet4_last#>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m=1>
</cfif>
<cfelseif #show_server_ip_octet4# is "">
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif step is "4">
<cfif #show_server_ip_octet1# is "0">
<cfset step=0>
<cfset m=1>
<cfelseif #show_server_ip_octet1# is "127">
<cfset step=0>
<cfset m=1>
<cfelseif #show_server_ip_octet1# is "169" and #show_server_ip_octet2# is "254">
<cfset step=0>
<cfset m=1>
<cfelseif #show_server_ip_octet1# is "192" and #show_server_ip_octet2# is "0" and #show_server_ip_octet3# is "2">
<cfset step=0>
<cfset m=1>
<cfelseif #show_server_ip_octet4# is "0">
<cfset step=0>
<cfset m=1>
<cfelse>
<cfset step=5>
</cfif>
</cfif>


<cfif step is "5" and #show_server_gateway_octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #show_server_gateway_octet1# GTE #octet_first# AND #show_server_gateway_octet1# LTE #octet_last#>
<cfset step=6>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
<cfelseif step is "5" and #show_server_gateway_octet1# is "">
<cfset step=0>
<cfset m=4>
</cfif>


<cfif step is "6">

<cfif #show_server_gateway_octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #show_server_gateway_octet2# GTE #octet2_first# AND #show_server_gateway_octet2# LTE #octet2_last#>
<cfset step=7>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
<cfelseif #show_server_gateway_octet2# is "">
<cfset step=0>
<cfset m=4>
</cfif>
</cfif>

<cfif step is "7">

<cfif #show_server_gateway_octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #show_server_gateway_octet3# GTE #octet3_first# AND #show_server_gateway_octet3# LTE #octet3_last#>
<cfset step=8>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
<cfelseif #show_server_gateway_octet3# is "">
<cfset step=0>
<cfset m=4>
</cfif>
</cfif>

<cfif step is "8">

<cfif #show_server_gateway_octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #show_server_gateway_octet4# GTE #octet4_first# AND #show_server_gateway_octet4# LTE #octet4_last#>
<cfset step=9>
<cfelse>
<cfset step=0>
<cfset m=3>
</cfif>
<cfelseif #show_server_gateway_octet4# is "">
<cfset step=0>
<cfset m=4>
</cfif>
</cfif>

<cfif step is "9">
<cfif #show_server_gateway_octet1# is "0">
<cfset step=0>
<cfset m=3>
<cfelseif #show_server_gateway_octet1# is "127">
<cfset step=0>
<cfset m=3>
<cfelseif #show_server_gateway_octet1# is "169" and #show_server_gateway_octet2# is "254">
<cfset step=0>
<cfset m=3>
<cfelseif #show_server_gateway_octet1# is "192" and #show_server_gateway_octet2# is "0" and #show_server_gateway_octet3# is "2">
<cfset step=0>
<cfset m=3>
<cfelseif #show_server_ip_octet4# is "0">
<cfset step=0>
<cfset m=3>
<cfelse>
<cfset step=10>
</cfif>
</cfif>


<cfif step is "10" and #show_server_dns1_octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #show_server_dns1_octet1# GTE #octet_first# AND #show_server_dns1_octet1# LTE #octet_last#>
<cfset step=11>
<cfelse>
<cfset step=0>
<cfset m=5>
</cfif>
<cfelseif step is "10" and #show_server_dns1_octet1# is "">
<cfset step=0>
<cfset m=6>
</cfif>


<cfif step is "11">

<cfif #show_server_dns1_octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #show_server_dns1_octet2# GTE #octet2_first# AND #show_server_dns1_octet2# LTE #octet2_last#>
<cfset step=12>
<cfelse>
<cfset step=0>
<cfset m=5>
</cfif>
<cfelseif #show_server_dns1_octet2# is "">
<cfset step=0>
<cfset m=6>
</cfif>
</cfif>

<cfif step is "12">

<cfif #show_server_dns1_octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #show_server_dns1_octet3# GTE #octet3_first# AND #show_server_dns1_octet3# LTE #octet3_last#>
<cfset step=13>
<cfelse>
<cfset step=0>
<cfset m=5>
</cfif>
<cfelseif #show_server_dns1_octet3# is "">
<cfset step=0>
<cfset m=6>
</cfif>
</cfif>

<cfif step is "13">

<cfif #show_server_dns1_octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #show_server_dns1_octet4# GTE #octet4_first# AND #show_server_dns1_octet4# LTE #octet4_last#>
<cfset step=14>
<cfelse>
<cfset step=0>
<cfset m=5>
</cfif>
<cfelseif #show_server_dns1_octet4# is "">
<cfset step=0>
<cfset m=6>
</cfif>
</cfif>

<cfif step is "14">
<cfif #show_server_dns1_octet1# is "0">
<cfset step=0>
<cfset m=5>
<cfelseif #show_server_dns1_octet1# is "127">
<cfset step=0>
<cfset m=5>
<cfelseif #show_server_dns1_octet1# is "169" and #show_server_dns1_octet2# is "254">
<cfset step=0>
<cfset m=5>
<cfelseif #show_server_dns1_octet1# is "192" and #show_server_dns1_octet2# is "0" and #show_server_dns1_octet3# is "2">
<cfset step=0>
<cfset m=5>
<cfelseif #show_server_ip_octet4# is "0">
<cfset step=0>
<cfset m=5>
<cfelse>
<cfset step=15>
</cfif>
</cfif>


<cfif step is "15" and #show_server_dns2_octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #show_server_dns2_octet1# GTE #octet_first# AND #show_server_dns2_octet1# LTE #octet_last#>
<cfset step=16>
<cfelse>
<cfset step=0>
<cfset m=7>
</cfif>
<cfelseif step is "15" and #show_server_dns2_octet1# is "">
<cfset step=16>

</cfif>


<cfif step is "16">

<cfif #show_server_dns2_octet2# is not "">
<cfif #show_server_dns2_octet1# is "" OR #show_server_dns2_octet3# is "" OR #show_server_dns2_octet4# is "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #show_server_dns2_octet2# GTE #octet2_first# AND #show_server_dns2_octet2# LTE #octet2_last#>
<cfset step=17>
<cfelse>
<cfset step=0>
<cfset m=7>
</cfif>
</cfif>
<cfelseif #show_server_dns2_octet2# is "">
<cfif #show_server_dns2_octet1# is not "" OR #show_server_dns2_octet3# is not "" OR #show_server_dns2_octet4# is not "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset step=17>
</cfif>
</cfif>
</cfif>

<cfif step is "17">
<cfif #show_server_dns2_octet3# is not "">
<cfif #show_server_dns2_octet4# is "" OR #show_server_dns2_octet2# is "" OR #show_server_dns2_octet1# is "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #show_server_dns2_octet3# GTE #octet3_first# AND #show_server_dns2_octet3# LTE #octet3_last#>
<cfset step=18>
<cfelse>
<cfset step=0>
<cfset m=7>
</cfif>
</cfif>
<cfelseif #show_server_dns2_octet3# is "">
<cfif #show_server_dns2_octet1# is not "" OR #show_server_dns2_octet4# is not "" OR #show_server_dns2_octet2# is not "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset step=18>
</cfif>
</cfif>
</cfif>

<cfif step is "18">
<cfif #show_server_dns2_octet4# is not "">
<cfif #show_server_dns2_octet3# is "" OR #show_server_dns2_octet2# is "" OR #show_server_dns2_octet1# is "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #show_server_dns2_octet4# GTE #octet4_first# AND #show_server_dns2_octet4# LTE #octet4_last#>
<cfset step=19>
<cfelse>
<cfset step=0>
<cfset m=7>
</cfif>
</cfif>
<cfelseif #show_server_dns2_octet4# is "">
<cfif #show_server_dns2_octet1# is not "" OR #show_server_dns2_octet3# is not "" OR #show_server_dns2_octet2# is not "">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset step=19>
</cfif>
</cfif>
</cfif>

<cfif step is "19">
<cfif #show_server_dns2_octet1# is "0">
<cfset step=0>
<cfset m=8>
<cfelseif #show_server_dns2_octet1# is "127">
<cfset step=0>
<cfset m=8>
<cfelseif #show_server_dns2_octet1# is "169" and #show_server_dns2_octet2# is "254">
<cfset step=0>
<cfset m=8>
<cfelseif #show_server_dns2_octet1# is "192" and #show_server_dns2_octet2# is "0" and #show_server_dns2_octet3# is "2">
<cfset step=0>
<cfset m=8>
<cfelseif #show_server_ip_octet4# is "0">
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset step=20>
</cfif>
</cfif>

<cfif step is "20" and #show_server_dns3_octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #show_server_dns3_octet1# GTE #octet_first# AND #show_server_dns3_octet1# LTE #octet_last#>
<cfset step=21>
<cfelse>
<cfset step=0>
<cfset m=9>
</cfif>
<cfelseif step is "20" and #show_server_dns3_octet1# is "">
<cfset step=21>
</cfif>


<cfif step is "21">
<cfif #show_server_dns3_octet2# is not "">
<cfif #show_server_dns3_octet1# is "" OR #show_server_dns3_octet3# is "" OR #show_server_dns3_octet4# is "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #show_server_dns3_octet2# GTE #octet2_first# AND #show_server_dns3_octet2# LTE #octet2_last#>
<cfset step=22>
<cfelse>
<cfset step=0>
<cfset m=9>
</cfif>
</cfif>
<cfelseif #show_server_dns3_octet2# is "">
<cfif #show_server_dns3_octet1# is not "" OR #show_server_dns3_octet3# is not "" OR #show_server_dns3_octet4# is not "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset step=22>
</cfif>
</cfif>
</cfif>

<cfif step is "22">
<cfif #show_server_dns3_octet3# is not "">
<cfif #show_server_dns3_octet4# is "" OR #show_server_dns3_octet2# is "" OR #show_server_dns3_octet1# is "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #show_server_dns3_octet3# GTE #octet3_first# AND #show_server_dns3_octet3# LTE #octet3_last#>
<cfset step=23>
<cfelse>
<cfset step=0>
<cfset m=9>
</cfif>
</cfif>
<cfelseif #show_server_dns3_octet3# is "">
<cfif #show_server_dns3_octet1# is not "" OR #show_server_dns3_octet4# is not "" OR #show_server_dns3_octet2# is not "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset step=23>
</cfif>
</cfif>
</cfif>

<cfif step is "23">

<cfif #show_server_dns3_octet4# is not "">
<cfif #show_server_dns3_octet3# is "" OR #show_server_dns3_octet2# is "" OR #show_server_dns3_octet1# is "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #show_server_dns3_octet4# GTE #octet4_first# AND #show_server_dns3_octet4# LTE #octet4_last#>
<cfset step=24>
<cfelse>
<cfset step=0>
<cfset m=9>
</cfif>
</cfif>
<cfelseif #show_server_dns3_octet4# is "">
<cfif #show_server_dns3_octet1# is not "" OR #show_server_dns3_octet3# is not "" OR #show_server_dns3_octet2# is not "">
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset step=24>
</cfif>
</cfif>



<cfif step is "24">
<cfif #show_server_dns3_octet1# is "0">
<cfset step=0>
<cfset m=9>
<cfelseif #show_server_dns3_octet1# is "127">
<cfset step=0>
<cfset m=9>
<cfelseif #show_server_dns3_octet1# is "169" and #show_server_dns3_octet2# is "254">
<cfset step=0>
<cfset m=9>
<cfelseif #show_server_dns3_octet1# is "192" and #show_server_dns3_octet2# is "0" and #show_server_dns3_octet3# is "2">
<cfset step=0>
<cfset m=9>
<cfelseif #show_server_ip_octet4# is "0">
<cfset step=0>
<cfset m=9>
<cfelse>
<cfset step=25>
</cfif>
</cfif>

<cfif step is "25" and #show_server_domain# is not "">
<cfset temp_email="bob@#show_server_domain#">
<cfif IsValid("email", temp_email)>
<cfset step=26>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=11>
</cfif>
<cfelseif step is "25" and #show_server_domain# is "">
<cfset step=0>
<cfset m=12>
</cfif>

<cfif step is "26" and #show_server_name# is "">
<cfset step=0>
<cfset m=14>
<cfelseif step is "26" and #show_server_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
<cfset step=0>
<cfset m=13>
<cfelse>
<cfset step=27>
</cfif>
</cfif>

<cfif step is "27">
<cfset m=15>


<cftransaction>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_ip_octet1,0)#', applied='2' where parameter='server_ip_octet1'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_ip_octet2,0)#', applied='2' where parameter='server_ip_octet2'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_ip_octet3,0)#', applied='2' where parameter='server_ip_octet3'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_ip_octet4,0)#', applied='2' where parameter='server_ip_octet4'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_gateway_octet1,0)#', applied='2' where parameter='server_gateway_octet1'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_gateway_octet2,0)#', applied='2' where parameter='server_gateway_octet2'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_gateway_octet3,0)#', applied='2' where parameter='server_gateway_octet3'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_gateway_octet4,0)#', applied='2' where parameter='server_gateway_octet4'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns1_octet1,0)#', applied='2' where parameter='server_dns1_octet1'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns1_octet2,0)#', applied='2' where parameter='server_dns1_octet2'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns1_octet3,0)#', applied='2' where parameter='server_dns1_octet3'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns1_octet4,0)#', applied='2' where parameter='server_dns1_octet4'
</cfquery>

<cfif #show_server_dns2_octet1# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns2_octet1,0)#', applied='2' where parameter='server_dns2_octet1'
</cfquery>
<cfelseif #show_server_dns2_octet1# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet1'
</cfquery>
</cfif>

<cfif #show_server_dns2_octet2# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns2_octet2,0)#', applied='2' where parameter='server_dns2_octet2'
</cfquery>
<cfelseif #show_server_dns2_octet2# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet2'
</cfquery>
</cfif>

<cfif #show_server_dns2_octet3# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns2_octet3,0)#', applied='2' where parameter='server_dns2_octet3'
</cfquery>
<cfelseif #show_server_dns2_octet3# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet3'
</cfquery>
</cfif>

<cfif #show_server_dns2_octet4# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns2_octet4,0)#', applied='2' where parameter='server_dns2_octet4'
</cfquery>
<cfelseif #show_server_dns2_octet4# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet4'
</cfquery>
</cfif>



<cfif #show_server_dns3_octet1# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns3_octet1,0)#', applied='2' where parameter='server_dns3_octet1'
</cfquery>
<cfelseif #show_server_dns3_octet1# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet1'
</cfquery>
</cfif>

<cfif #show_server_dns3_octet2# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns3_octet2,0)#', applied='2' where parameter='server_dns3_octet2'
</cfquery>
<cfelseif #show_server_dns3_octet2# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet2'
</cfquery>
</cfif>

<cfif #show_server_dns3_octet3# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns3_octet3,0)#', applied='2' where parameter='server_dns3_octet3'
</cfquery>
<cfelseif #show_server_dns3_octet3# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet3'
</cfquery>
</cfif>

<cfif #show_server_dns3_octet4# is not "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#numberFormat(show_server_dns3_octet4,0)#', applied='2' where parameter='server_dns3_octet4'
</cfquery>
<cfelseif #show_server_dns3_octet4# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet4'
</cfquery>
</cfif>

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_name#' , applied='2'where parameter='server_name'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_domain#', applied='2' where parameter='server_domain'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_subnet#', applied='2' where parameter='server_subnet'
</cfquery>
</cftransaction>



</cfif>

<cfelseif #show_action# is "edit" and #show_network_mode# is "dhcp">

<cfif #show_server_domain# is not "">
<cfset temp_email="bob@#show_server_domain#">
<cfif IsValid("email", temp_email)>
<cfset step=1>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=11>
</cfif>
<cfelseif #show_server_domain# is "">
<cfset step=0>
<cfset m=12>
</cfif>

<cfif step is "1" and #show_server_name# is "">
<cfset step=0>
<cfset m=14>
<cfelseif step is "1" and #show_server_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
<cfset step=0>
<cfset m=13>
<cfelse>
<cfset step=2>
</cfif>
</cfif>

<cfif step is "2">
<cfset m=15>

<cftransaction>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_name#' , applied='2'where parameter='server_name'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_domain#', applied='2' where parameter='server_domain'
</cfquery>
</cftransaction>

</cfif>


</cfif>


<script>

/*
Auto tabbing script- By JavaScriptKit.com
http://www.javascriptkit.com
This credit MUST stay intact for use
*/

function autotab(original,destination){
if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
destination.focus()
}

</script>
                            <table border="0" cellspacing="0" cellpadding="0" width="963" id="LayoutRegion18" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="963">
                                    <tr valign="top" align="left">
                                      <td width="501" id="Text464" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Allowed IP Addresses</span></b></p>
                                      </td>
                                      <td width="462"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="963" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_ips" datasource="#datasource#">
select * from firewall order by ip asc
</cfquery>

<cfif #get_ips.recordcount# GTE 1>

<form action="edit_firewall.cfm" method="post">


<select name="ip" style="height: 88px;" size="60">
<cfoutput query="get_ips">
<option value="#ip#">#ip#</option>
</cfoutput>
</select>

<table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 28px;">
    <td>
<input type="hidden" name="action" value="delete">
      <p style="margin-bottom: 0px;"><input type="submit" value="Delete" style="height: 24px; width: 69px;"></p>
    </td>
    
  </tr>
</table>
</form>

<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Allowed IP Addresses were found...</span></p>


</cfif>


    
&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" width="963" id="Text463" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must select an IP Address to delete</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You cannot delete your current IP Address</span></i></b></p>
</cfoutput>
</cfif>




<cfif #m3# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! IP Address Deleted.</span></i></b></p>
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