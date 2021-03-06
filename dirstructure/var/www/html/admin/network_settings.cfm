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
<title>Network Settings</title>
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
              <td height="641" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 641px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="515">
                              <tr valign="top" align="left">
                                <td width="9" height="8"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Network Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="455">
                              <tr valign="top" align="left">
                                <td width="430" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/network-settings/')"><img id="Picture2" height="25" width="25" src="./help_1.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="9" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="60"></td>
                          <td width="960"><cfquery name="network_mode" datasource="#datasource#">
select * from parameters2 where parameter='network_mode' and module='network' and active='1'
</cfquery>

<cfif #network_mode.value2# is "">
<cfparam name = "show_network_mode" default = "dhcp"> 
<cfif IsDefined("form.network_mode") is "True">
<cfif form.network_mode is not "">
<cfset show_network_mode = form.network_mode>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_network_mode#' where parameter='network_mode'
</cfquery>
</cfif></cfif>
<cfelseif #network_mode.value2# is not "">
<cfparam name = "show_network_mode" default = "#network_mode.value2#"> 
<cfif IsDefined("form.network_mode") is "True">
<cfif form.network_mode is not "">
<cfset show_network_mode = form.network_mode>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_network_mode#' where parameter='network_mode'
</cfquery>
</cfif></cfif>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion12" style="height: 60px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion12FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="306">
                                      <tr valign="top" align="left">
                                        <td width="9"></td>
                                        <td width="297" id="Text291" class="TextObject">
                                          <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Network Mode</span></b></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="10" height="12"></td>
                                        <td></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td></td>
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
                                                            <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="radio" checked="checked" name="network_mode" value="static" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
<cfelseif #show_network_mode# is not "static">
<cfoutput>
<input type="radio" name="network_mode" value="static" style="height: 13px; width: 13px;" onclick="this.form.submit();">
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Static</span></b></p>
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
                                                            <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "dhcp">
<cfoutput>
<input type="radio" checked="checked" name="network_mode" value="dhcp" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
<cfelseif #show_network_mode# is not "dhcp">
<cfoutput>
<input type="radio" name="network_mode" value="dhcp" style="height: 13px; width: 13px;" onclick="this.form.submit();">
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DHCP</span></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="957"><hr id="HRRule1" width="957" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="379"></td>
                          <td width="957"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 



<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

<cfif #authkey# is "">

<!-- GENERATE SECRET KEY -->
<cfset authkey=generateSecretKey("AES", 256)>
<cffile action = "write"
file = "/opt/hermes/keys/hermes.key"
output = "#authkey#">

<!-- READ SECRET KEY -->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

<!-- /CFIF #authkey# is  -->
</cfif>

<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<!--- VALIDATE IP ADDRESS REGEX --->
<cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">


<!--- GET UBUNTU VERSION BELOW --->
<cfexecute name="/opt/hermes/scripts/get_ubuntu_version.sh"
variable="theubuntuversion"
timeout="10" />

<cfset UBUNTUVERSION = "#TRIM(theubuntuversion)#">
<!--- GET UBUNTU VERSION ABOVE --->


<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif> 

<cfquery name="server_ip" datasource="#datasource#">
select * from parameters2 where parameter='server_ip' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_ip" default = "#server_ip.value2#"> 
<cfif IsDefined("form.server_ip") is "True">
<cfset show_server_ip = form.server_ip>
</cfif>


<cfquery name="server_gateway" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_gateway" default = "#server_gateway.value2#"> 
<cfif IsDefined("form.server_gateway") is "True">
<cfset show_server_gateway = form.server_gateway>
</cfif>


<cfquery name="server_dns1" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns1" default = "#server_dns1.value2#"> 
<cfif IsDefined("form.server_dns1") is "True">
<cfset show_server_dns1 = form.server_dns1>
</cfif>

<cfquery name="server_dns2" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns2" default = "#server_dns2.value2#"> 
<cfif IsDefined("form.server_dns2") is "True">
<cfset show_server_dns2 = form.server_dns2>
</cfif>

<cfquery name="server_dns3" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3' and module='network' and active='1'
</cfquery>


<cfparam name = "show_server_dns3" default = "#server_dns3.value2#"> 
<cfif IsDefined("form.server_dns3") is "True">
<cfset show_server_dns3 = form.server_dns3>
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

<cfparam name = "show_server_subnet" default = "#server_subnet.value2#"> 
<cfif IsDefined("form.server_subnet") is "True">
<cfset show_server_subnet = form.server_subnet>
</cfif>

<cfif #show_action# is "edit" and #show_network_mode# is "static">

<!--- GET HERMES USERNAME --->
<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfif #get_mysql_username_hermes.value# is "">
<cfset step=0>
<cfset m=17>
<cfelseif #get_mysql_username_hermes.value# is not "">
<cfset step=1>

<!--- /CFIF FOR get_mysql_username_hermes.value --->
</cfif>

<cfif step is "1">

<!--- GET HERMES PASSWORD --->
<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is "">
<cfset step=0>
<cfset m=18>

<cfelseif #get_mysql_password_hermes.value# is not "">

<cfset step=2>

<!--- /CFIF FOR get_mysql_password_hermes.value --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<cfif step is "2">

<cfif #show_server_ip# is not "">

<cfif REFind(pattern,show_server_ip) GT 0>

<cfset step=3>

<cfelse>
<cfset step=0>
<cfset m=1>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #show_server_ip# is "">
<cfset step=0>
<cfset m=2>

<!--- /CFIF #show_server_ip# is --->
</cfif>

<!--- /CFIF FOR STEP 2 --->
</cfif>

<cfif step is "3">

<cfif #show_server_gateway# is not "">

<cfif REFind(pattern,show_server_gateway) GT 0>
<cfset step=4>

<cfelse>
<cfset step=0>
<cfset m=3>
 
<!--- /CFIF REFind --->
</cfif>

<cfelseif #show_server_gateway# is "">
<cfset step=0>
<cfset m=4>

<!--- /CFIF #show_server_gateway# is --->
</cfif>

<!--- /CFIF FOR STEP 3 --->
</cfif>



<cfif step is "4">

<cfif #show_server_dns1# is not "">

<cfif REFind(pattern,show_server_dns1) GT 0>
<cfset step=5>
<cfelse>
<cfset step=0>
<cfset m=5>
 
<!--- /CFIF REFind --->
</cfif>

<cfelseif #show_server_dns1# is "">
<cfset step=0>
<cfset m=6>

<!--- /CFIF #show_server_dns1# is --->
</cfif>

<!--- /CFIF FOR STEP 4 --->
</cfif>


<cfif step is "5">

<cfif #show_server_dns2# is not "">

<cfif REFind(pattern,show_server_dns2) gt 0>
<cfset step=6> 
<cfelse>
<cfset step=0>
<cfset m=7>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #show_server_dns2# is "">
<cfset step=6>

<!--- /CFIF #show_server_dns2# is --->
</cfif>

<!--- /CFIF FOR STEP 13 --->
</cfif>

<cfif step is "6">

<cfif #show_server_dns3# is not "">

<cfif REFind(pattern,show_server_dns3) gt 0>
<cfset step=7> 
<cfelse>
<cfset step=0>
<cfset m=9>

<!--- /CFIF REFind --->
</cfif>

<cfelseif #show_server_dns3# is "">
<cfset step=7> 

<!--- /CFIF #show_server_dns3# is --->
</cfif>

<!--- /CFIF FOR STEP 6 --->
</cfif>


<cfif step is "7">

<cfif #show_server_domain# is not "">

<cfset temp_email="bob@#show_server_domain#">
<cfif IsValid("email", temp_email)>
<cfset step=8>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=11>

<!--- /CFIF IsValid("email", temp_email) --->
</cfif>

<cfelseif #show_server_domain# is "">
<cfset step=0>
<cfset m=12>

<!--- /CFIF #show_server_domain# is --->
</cfif>

<!--- /CFIF FOR STEP 7 --->
</cfif>


<cfif step is "8">

<cfif #show_server_name# is "">

<cfset step=0>
<cfset m=14>
<cfelseif #show_server_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
<cfset step=0>
<cfset m=13>
<cfelse>
<cfset step=9>

<!--- /CFIF REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0 --->
</cfif>

<!--- /CFIF #show_server_name# is --->
</cfif>

<!--- /CFIF FOR STEP 8 --->
</cfif>



<cfif step is "9">

<cfset m=15>

<cftransaction>

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_ip#', applied='2' where parameter='server_ip'
</cfquery>


<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_gateway#', applied='2' where parameter='server_gateway'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_dns1#', applied='2' where parameter='server_dns1'
</cfquery>

<cfif #show_server_dns2# is not "">

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_dns2#', applied='2' where parameter='server_dns2'
</cfquery>

<cfelseif #show_server_dns2# is "">
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns2'
</cfquery>

<!--- /CFIF #show_server_dns2_octet1#  --->
</cfif>

<cfif #show_server_dns3# is not "">

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_dns3#', applied='2' where parameter='server_dns3'
</cfquery>

<cfelseif #show_server_dns3# is "">

<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='', applied='2' where parameter='server_dns3'
</cfquery>

<!--- /CFIF #show_server_dns3#  --->
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



<!--- /CFIF FOR STEP 9 --->
</cfif>



<cfelseif #show_action# is "edit" and #show_network_mode# is "dhcp">

<!--- GET HERMES USERNAME --->
<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfif #get_mysql_username_hermes.value# is "">
<cfset step=0>
<cfset m=17>
<cfelseif #get_mysql_username_hermes.value# is not "">
<cfset mysqlusernamehermes=#get_mysql_username_hermes.value#>
<cfset step=1>

<!--- /CFIF FOR get_mysql_username_hermes.value --->
</cfif>

<cfif step is "1">

<!--- GET HERMES PASSWORD --->
<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is "">
<cfset step=0>
<cfset m=18>

<cfelseif #get_mysql_password_hermes.value# is not "">

<!--- DECRYPT HERMES PASSWORD --->
<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>

<cfset step=2>

<!--- /CFIF FOR get_mysql_password_hermes.value --->
</cfif>

<!--- /CFIF FOR STEP 1 --->
</cfif>

<cfif step is "2">

<cfif #show_server_domain# is not "">
<cfset temp_email="bob@#show_server_domain#">
<cfif IsValid("email", temp_email)>
<cfset step=3>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=11>
</cfif>
<cfelseif #show_server_domain# is "">
<cfset step=0>
<cfset m=12>
</cfif>

<!--- /CFIF FOR STEP 2 --->
</cfif>


<cfif step is "3" and #show_server_name# is "">
<cfset step=0>
<cfset m=14>
<cfelseif step is "3" and #show_server_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_server_name) gt 0>
<cfset step=0>
<cfset m=13>
<cfelse>
<cfset step=4>
</cfif>

<!--- /CFIF FOR STEP 3 --->
</cfif>


<cfif step is "4">

<cfset m=15>

<cftransaction>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_name#' , applied='2'where parameter='server_name'
</cfquery>
<cfquery name="update" datasource="#datasource#">
update parameters2 set value2='#show_server_domain#', applied='2' where parameter='server_domain'
</cfquery>
</cftransaction>

<!--- /CFIF FOR STEP 4 --->
</cfif>

<!--- /CFIF FOR show_action--->
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
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion1" style="height: 379px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="system_configuration_form" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="7"></td>
                                        <td width="950">
                                          <table id="Table76" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 317px;">
                                            <tr style="height: 14px;">
                                              <td width="950" id="Cell735">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Host Name <span style="color: rgb(51,51,51);"> (Required)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell734">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="server_name" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_name#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell732">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Primary Domain Name <span style="color: rgb(51,51,51);"> (Required)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell733">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="server_domain" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_domain#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell454">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">IP Address (Required)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell455">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="text" name="server_ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_ip#">
</cfoutput>
<cfelseif #show_network_mode# is "dhcp">
<cfoutput>
<input type="text" name="server_ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_ip#" disabled="disabled">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell436">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Subnet Mask&nbsp; (Required)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell437">
                                                <table width="150" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #UBUNTUVERSION# LTE "16.999">

<cfif #show_server_subnet# is "">
<cfset default_value="255.255.255.0">
<cfset default_mask="/24 (255.255.255.0)">
<cfelseif #show_server_subnet# is not "">
<cfquery name="getmask" datasource="#datasource#">
select mask from subnet where value2='#show_server_subnet#'
</cfquery>
<cfset default_value="#show_server_subnet#">
<cfset default_mask="#getmask.mask#">
</cfif>

<cfquery name="getsubnet" datasource="#datasource#">
select * from subnet where value2 <> '#default_value#' order by value2 asc
</cfquery>

<cfif #show_network_mode# is "static">
<select name="server_subnet" style="height: 24px;">
<cfoutput>
<option value="#default_value#" selected="selected">#default_mask#</option>
</cfoutput>
<cfoutput query="getsubnet">
<option value="#value2#">#mask#</option>
</cfoutput>
</select>
<cfelseif #show_network_mode# is "dhcp">
<select name="server_subnet" style="height: 24px;" disabled="disabled">
<cfoutput>
<option value="#default_value#" selected="selected">#default_mask#</option>
</cfoutput>
<cfoutput query="getsubnet">
<option value="#value2#">#mask#</option>
</cfoutput>
</select>
</cfif>

<cfelseif #UBUNTUVERSION# GTE "18">

<cfif #show_server_subnet# is "">
<cfset default_value="24">
<cfset default_mask="/24 (255.255.255.0)">
<cfelseif #show_server_subnet# is not "">
<cfquery name="getmask" datasource="#datasource#">
select mask,value3 from subnet where value3='#show_server_subnet#'
</cfquery>
<cfset default_value="#getmask.value3#">
<cfset default_mask="#getmask.mask#">
</cfif>

<cfquery name="getsubnet" datasource="#datasource#">
select * from subnet where value3 <> '#default_value#' order by value2 asc
</cfquery>

<cfif #show_network_mode# is "static">
<select name="server_subnet" style="height: 24px;">
<cfoutput>
<option value="#default_value#" selected="selected">#default_mask#</option>
</cfoutput>
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
<cfelseif #show_network_mode# is "dhcp">
<select name="server_subnet" style="height: 24px;" disabled="disabled">
<cfoutput>
<option value="#default_value#" selected="selected">#default_mask#</option>
</cfoutput>
<cfoutput query="getsubnet">
<option value="#value3#">#mask#</option>
</cfoutput>
</select>
</cfif>


<!--- CFIF #UBUNTUVERSION# --->
</CFIF>





&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell442">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Gateway&nbsp; (Required)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell460">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="text" name="server_gateway" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_gateway#">
</cfoutput>
<cfelseif #show_network_mode# is "dhcp">
<cfoutput>
<input type="text" name="server_gateway" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_gateway#" disabled="disabled">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell433">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">DNS1&nbsp; (Required)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell445">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="text" name="server_dns1" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns1#">
</cfoutput>
<cfelseif #show_network_mode# is "dhcp">
<cfoutput>
<input type="text" name="server_dns1" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns1#" disabled="disabled">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell446">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DNS2</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell447">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="text" name="server_dns2" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns2#">
</cfoutput>
<cfelseif #show_network_mode# is "dhcp">
<cfoutput>
<input type="text" name="server_dns2" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns2#" disabled="disabled">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell453">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DNS3</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell473">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_network_mode# is "static">
<cfoutput>
<input type="text" name="server_dns3" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns3#">
</cfoutput>
<cfelseif #show_network_mode# is "dhcp">
<cfoutput>
<input type="text" name="server_dns3" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_server_dns3#" disabled="disabled">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell474">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span></b>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="8" height="8"></td>
                                        <td></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td></td>
                                        <td width="949">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="949" id="Cell722">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="8" height="8"></td>
                                        <td width="949"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td></td>
                                        <td width="949" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;">
<cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Server IP Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server IP Address fields cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Server Gateway Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server Gateway Address fields cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Server DNS1 Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server DNS1 Address fields cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid DNS2 Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The DNS2 fields cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid DNS3 Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The DNS3 fields cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Server Domain</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server Domain field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Server Name</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server Name field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "15">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings button for the changes to take effect. If you have changed the system IP address, please ensure you connect to the new IP address after you click the Apply Settings button.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Username is not defined. Please navigate to <b>System --> System Settings</b> and specify a username for the Hermes MySQL Database </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Password is not defined. Please navigate to <b>System --> System Settings</b> and specify a password for the Hermes MySQL Database </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to apply your settings because the Hermes MySQL Database credentials are not defined or are incorrect. Please navigate to <b>System --> System Settings</b> and specify the correct credentials for the Hermes MySQL Database </span></i></b></p>
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
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="958"><hr id="HRRule2" width="958" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td colspan="2" width="958"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<!--- Set Interface name --->
<cfexecute name="/opt/hermes/scripts/get_network_interface.sh"
variable="thenetworkinterface"
timeout="10" />
<cfset THEINTERFACE = "#TRIM(thenetworkinterface)#">

<!--- Set Network command for network_restart_script.sh depending on Ubuntu Version --->
<cfif #UBUNTUVERSION# LTE "16.999">
<cfset THENETCOMMAND = "/sbin/ip addr flush #THEINTERFACE# && /bin/systemctl restart networking.service">
<cfelseif #UBUNTUVERSION# gte "18">
<cfset THENETCOMMAND = "/usr/sbin/netplan apply">
</cfif>

<!--- Set Network File for network_restart_script.sh depending on Ubuntu Version --->
<cfif #UBUNTUVERSION# LTE "16.999">
<cfset THENETWORKFILE = "/etc/network/interfaces">
<cfelseif #UBUNTUVERSION# gte "18">
<cfset THENETWORKFILE = "/etc/netplan/50-cloud-init.yaml">
</cfif>

<!--- Set Interface file for network_restart_script.sh depending on Ubuntu Version --->
<cfif #UBUNTUVERSION# LTE "16.999">
<cfset THEINTFILE = "interfaces">
<cfelseif #UBUNTUVERSION# gte "18">
<cfset THEINTFILE = "50-cloud-init.yaml">
</cfif>



<cfif #show_action2# is "apply" and #show_network_mode# is "static">

<!--- GET HERMES USERNAME --->
<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfif #get_mysql_username_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_username_hermes.value# is not "">

<cfset mysqlusernamehermes=#get_mysql_username_hermes.value#>

</cfif>

<!--- GET HERMES PASSWORD --->
<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_password_hermes.value# is not "">


<!--- DECRYPT HERMES PASSWORD --->
<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>

<!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS BELOW --->

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

<cffile action="read" file="/opt/hermes/scripts/validate_mysql.sh" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLUSER","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#mysqlpasswordhermes#","ALL")#"> 


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/validate_mysql_#customtrans3#"
timeout = "60">
</cfexecute>

<cftry>

<cfexecute name = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
timeout = "240"
variable ="mysqlvalidate"
arguments="">
</cfexecute>


<cfcatch type="any">

<cfif #cfcatch.detail# contains "ERROR 1045 (28000): Access denied">

<cfset validatefile="/opt/hermes/tmp/validate_mysql_#customtrans3#">

<cfif fileExists(validatefile)>
<cffile action = "delete" file = "#validatefile#">
</cfif>

<cflocation url="error.cfm" addtoken="no">

<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>

</cftry>

<cfset validatefile="/opt/hermes/tmp/validate_mysql_#customtrans3#">

<cfif fileExists(validatefile)>
<cffile action = "delete" file = "#validatefile#">
</cfif>

<!--- /CFIF #get_mysql_password_hermes.value# is not "" --->
</cfif>

<!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS ABOVE --->

<!--- GET HERMES VERSION BELOW --->
<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>
<!--- GET HERMES VERSION ABOVE --->


<cfset m2=16>

<cfquery name="server_ip" datasource="#datasource#">
select * from parameters2 where parameter='server_ip' and module='network' and active='1'
</cfquery>

<cfquery name="server_gateway" datasource="#datasource#">
select * from parameters2 where parameter='server_gateway' and module='network' and active='1'
</cfquery>

<cfquery name="server_dns1" datasource="#datasource#">
select * from parameters2 where parameter='server_dns1' and module='network' and active='1'
</cfquery>

<cfquery name="server_dns2" datasource="#datasource#">
select * from parameters2 where parameter='server_dns2' and module='network' and active='1'
</cfquery>

<cfquery name="server_dns3" datasource="#datasource#">
select * from parameters2 where parameter='server_dns3' and module='network' and active='1'
</cfquery>


<cfquery name="server_name" datasource="#datasource#">
select * from parameters2 where parameter='server_name' and module='network' and active='1'
</cfquery>

<cfquery name="server_domain" datasource="#datasource#">
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
</cfquery>

<cfquery name="server_subnet" datasource="#datasource#">
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
</cfquery>

<cfquery name="get_sa_spam_subject_tag" datasource="#datasource#">
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
</cfquery>

<cfquery name="get_final_virus_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_banned_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_spam_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_bad_header_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update parameters2 set applied='1' where module='network'
</cfquery>

<cfset ServerAddress="#server_ip.value2#">
<cfset ServerGateway="#server_gateway.value2#">
<cfset ServerDns1="#server_dns1.value2#">
<cfif #server_dns2.value2# is not "">
<cfset ServerDns2="#server_dns2.value2#">
<cfelseif #server_dns2.value2# is "">
<cfset ServerDns2="">
</cfif>
<cfif #server_dns3.value2# is not "">
<cfset ServerDns3="#server_dns3.value2#">
<cfelseif #server_dns3.value2# is "">
<cfset ServerDns3="">
</cfif>
<cfset ServerName="#server_name.value2#">
<cfset ServerDomain="#server_domain.value2#">
<cfset ServerSubnet="#server_subnet.value2#">

<!--- Update Postfix Parameters Below --->
<!--- Get myorigin parent parameter id --->
<cfquery name="getmyoriginparent" datasource="#datasource#">
select id from parameters where parameter='myorigin' and module='postfix' and conf_file='main.cf' and child='2'
</cfquery>

<!--- Update myorigin child parameter --->
<cfquery name="updatemyorigin" datasource="#datasource#">
update parameters set parameter='#ServerDomain#' where parent='#getmyoriginparent.id#' and child='1' and module='postfix' and conf_file='main.cf'
</cfquery>

<!--- Get myhostname parent parameter id --->
<cfquery name="getmyhostnameparent" datasource="#datasource#">
select id from parameters where parameter='myhostname' and module='postfix' and conf_file='main.cf' and child='2'
</cfquery>

<!--- Update myhostname child parameter --->
<cfquery name="updatemyhostname" datasource="#datasource#">
update parameters set parameter='#ServerName#' where parent='#getmyhostnameparent.id#' and child='1' and module='postfix' and conf_file='main.cf'
</cfquery>
<!--- Update Postfix Parameters Above --->

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

<cfif #UBUNTUVERSION# LTE "16.999">
<!--- MODIFY /etc/network/interfaces --->

<cffile action="read" file="/opt/hermes/conf_files/interfaces.HERMES.static" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-ADDRESS","#ServerAddress#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-SUBNET","#ServerSubnet#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-GATEWAY","#ServerGateway#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DNS","#ServerDns1# #ServerDns2# #ServerDns3#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<cfelseif #UBUNTUVERSION# GTE "18">

<!--- MODIFY /etc/netplan/50-cloud-init.yaml --->

<cffile action="read" file="/opt/hermes/conf_files/50-cloud-init.yaml.HERMES.static" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-ADDRESS","#ServerAddress#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-SUBNET","#ServerSubnet#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-GATEWAY","#ServerGateway#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static" variable="interfaces">



<cfset theServerDNS="#ServerDNS1#">
<cfif #ServerDNS2# is not "">
<cfset theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2#">
</cfif>
<cfif #ServerDNS3# is not "">
<cfset theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS3#">
</cfif>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DNS","#theServerDNS#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static" variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<!--- /CFIF for #UBUNTUVERSION# --->
</cfif>

<!--- MODIFY /etc/amavis/conf.d/50-user --->

<cffile action="read" file="/opt/hermes/conf_files/50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","sa-spam-subject-tag","#get_sa_spam_subject_tag.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-virus-destiny","#get_final_virus_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-banned-destiny","#get_final_banned_destiny.value#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-spam-destiny","#get_final_spam_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-bad-header-destiny","#get_final_bad_header_destiny.value#","ALL")#">
    
<!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD BELOW --->    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#">

<!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD ABOVE --->    

<!--- INSERT AMAVIS FILE RULES BELOW --->

<cfquery name="getrules" datasource="#datasource#">
SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
</cfquery>



<cfloop query="getrules">

<cfquery name="getrulecomponents" datasource="#datasource#">
select file_id, type from file_rule_components where rule_id='#RuleID#' order by priority asc
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
    output = "'#rule_name#' => new_RE( RULES ),"
    addNewLine = "yes">



<cfset last = #getrulecomponents.recordcount#>

<cfloop query="getrulecomponents">

<cfif #currentrow# EQ #last#>

<cfif #type# is "ban">

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">


</cfif>

<cfelseif #currentrow# NEQ #last#>


<cfif #type# is "ban">

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">


</cfif>

</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#" variable="theComponents">


</cfloop>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
    output = "#REReplace("#theRule#","RULES","#chr(10)##theComponents#","ALL")#"
    addNewLine = "no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule"
    output = "#theRule#"
    addNewLine = "yes">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#">
</cfif>

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#">
</cfif>


</cfloop>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule" variable="theRules">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
</cfif>


<!--- INSERT AMAVIS FILE RULES ABOVE --->


<!--- MODIFY /opt/hermes/conf_files/hosts --->

<cffile action="read" file="/opt/hermes/conf_files/hosts.HERMES" variable="hosts">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#hosts"
    output = "#REReplace("#hosts#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#hosts" variable="hosts">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#hosts"
    output = "#REReplace("#hosts#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<!--- MODIFY /etc/mailname --->    

<cffile action="read" file="/opt/hermes/conf_files/mailname.HERMES" variable="mailname">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#mailname"
    output = "#REReplace("#mailname#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#mailname" variable="mailname">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#mailname"
    output = "#REReplace("#mailname#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<!--- Create Network Restart Script ---> 

<cffile action="read" file="/opt/hermes/templates/network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-TRANSACTION","#customtrans3#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-NAME","#ServerName#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NET-COMMAND","#THENETCOMMAND#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NETWORK-FILE","#THENETWORKFILE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INT-FILE","#THEINTFILE#","ALL")#">
    

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_network_restart.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
outputfile ="/dev/null"
timeout = "120">
</cfexecute>

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_network_restart.sh")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh">
</cfif>


<cfelseif #show_action2# is "apply" and #show_network_mode# is "dhcp">

<!--- GET HERMES USERNAME --->
<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfif #get_mysql_username_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_username_hermes.value# is not "">

<cfset mysqlusernamehermes=#get_mysql_username_hermes.value#>

</cfif>

<!--- GET HERMES PASSWORD --->
<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is "">

<cflocation url="error.cfm" addtoken="no">

<cfelseif #get_mysql_password_hermes.value# is not "">


<!--- DECRYPT HERMES PASSWORD --->
<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>

<!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS BELOW --->

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

<cffile action="read" file="/opt/hermes/scripts/validate_mysql.sh" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLUSER","#mysqlusernamehermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#mysqlpasswordhermes#","ALL")#"> 


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/validate_mysql_#customtrans3#"
timeout = "60">
</cfexecute>

<cftry>

<cfexecute name = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
timeout = "240"
variable ="mysqlvalidate"
arguments="">
</cfexecute>


<cfcatch type="any">

<cfif #cfcatch.detail# contains "ERROR 1045 (28000): Access denied">

<cfset validatefile="/opt/hermes/tmp/validate_mysql_#customtrans3#">

<cfif fileExists(validatefile)>
<cffile action = "delete" file = "#validatefile#">
</cfif>

<cflocation url="error.cfm" addtoken="no">

<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>

</cftry>

<cfset validatefile="/opt/hermes/tmp/validate_mysql_#customtrans3#">

<cfif fileExists(validatefile)>
<cffile action = "delete" file = "#validatefile#">
</cfif>

<!--- /CFIF #get_mysql_password_hermes.value# is not "" --->
</cfif>

<!--- VALIDATE HERMES DATABASE MYSQL CREDENTIALS ABOVE --->

<!--- GET HERMES VERSION BELOW --->
<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>
<!--- GET HERMES VERSION ABOVE --->


<cfset m2=16>

<cfquery name="server_domain" datasource="#datasource#">
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
</cfquery>

<cfquery name="server_subnet" datasource="#datasource#">
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
</cfquery>

<cfquery name="get_sa_spam_subject_tag" datasource="#datasource#">
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
</cfquery>

<cfquery name="get_final_virus_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_banned_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_spam_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
</cfquery>

<cfquery name="get_final_bad_header_destiny" datasource="#datasource#">
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
</cfquery>

<cfquery name="update" datasource="#datasource#">
update parameters2 set applied='1' where module='network'
</cfquery>

<cfset ServerName="#server_name.value2#">
<cfset ServerDomain="#server_domain.value2#">

<!--- Update Postfix Parameters Below --->
<!--- Get myorigin parent parameter id --->
<cfquery name="getmyoriginparent" datasource="#datasource#">
select id from parameters where parameter='myorigin' and module='postfix' and conf_file='main.cf' and child='2'
</cfquery>

<!--- Update myorigin child parameter --->
<cfquery name="updatemyorigin" datasource="#datasource#">
update parameters set parameter='#ServerDomain#' where parent='#getmyoriginparent.id#' and child='1' and module='postfix' and conf_file='main.cf'
</cfquery>

<!--- Get myhostname parent parameter id --->
<cfquery name="getmyhostnameparent" datasource="#datasource#">
select id from parameters where parameter='myhostname' and module='postfix' and conf_file='main.cf' and child='2'
</cfquery>

<!--- Update myhostname child parameter --->
<cfquery name="updatemyhostname" datasource="#datasource#">
update parameters set parameter='#ServerName#' where parent='#getmyhostnameparent.id#' and child='1' and module='postfix' and conf_file='main.cf'
</cfquery>
<!--- Update Postfix Parameters Above --->

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

<cfif #UBUNTUVERSION# LTE "16.999">
<!--- MODIFY /etc/network/interfaces --->  
<cffile action="read" file="/opt/hermes/conf_files/interfaces.HERMES.dhcp" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#interfaces.HERMES.dhcp"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cfelseif #UBUNTUVERSION# GTE "18">
<!--- MODIFY /etc/netplan/50-cloud-init.yaml --->
<cffile action="read" file="/opt/hermes/conf_files/50-cloud-init.yaml.HERMES.dhcp" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.dhcp"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">

<!--- /CFIF for #UBUNTUVERSION# --->
</cfif>

<!--- MODIFY /etc/amavis/conf.d/50-user --->

<cffile action="read" file="/opt/hermes/conf_files/50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-DOMAIN","#ServerDomain#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","sa-spam-subject-tag","#get_sa_spam_subject_tag.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-virus-destiny","#get_final_virus_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-banned-destiny","#get_final_banned_destiny.value#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-spam-destiny","#get_final_spam_destiny.value#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","final-bad-header-destiny","#get_final_bad_header_destiny.value#","ALL")#">
    
<!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD BELOW --->    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","HERMES-USERNAME","#mysqlusernamehermes#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","HERMES-PASSWORD","#mysqlpasswordhermes#","ALL")#">

<!--- INSERT HERMES MYSQL DATABASE USERNAME AND PASSWORD ABOVE --->    

<!--- INSERT AMAVIS FILE RULES BELOW --->

<cfquery name="getrules" datasource="#datasource#">
SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
</cfquery>



<cfloop query="getrules">

<cfquery name="getrulecomponents" datasource="#datasource#">
select file_id, type from file_rule_components where rule_id='#RuleID#' order by priority asc
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
    output = "'#rule_name#' => new_RE( RULES ),"
    addNewLine = "yes">



<cfset last = #getrulecomponents.recordcount#>

<cfloop query="getrulecomponents">

<cfif #currentrow# EQ #last#>

<cfif #type# is "ban">

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#"
    addNewLine = "yes">


</cfif>

<cfelseif #currentrow# NEQ #last#>


<cfif #type# is "ban">

<cfquery name="getfile" datasource="#datasource#">
select ban as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">

<cfelseif #type# is "allow">
<cfquery name="getfile" datasource="#datasource#">
select allow as theType from files where id='#file_id#'
</cfquery>

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#"
    output = "#getfile.theType#,"
    addNewLine = "yes">


</cfif>

</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#" variable="theComponents">


</cfloop>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#"
    output = "#REReplace("#theRule#","RULES","#chr(10)##theComponents#","ALL")#"
    addNewLine = "no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#" variable="theRule">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_amavis_rule"
    output = "#theRule#"
    addNewLine = "yes">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_#rule_name#">
</cfif>

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule_components_#rule_name#">
</cfif>


</cfloop>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_rule" variable="theRules">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","FILE-RULES-GO-HERE","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_amavis_rule")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_amavis_rule">
</cfif>

<!--- INSERT AMAVIS FILE RULES ABOVE --->

<!--- MODIFY /opt/hermes/conf_files/hosts --->

<cffile action="read" file="/opt/hermes/conf_files/hosts.HERMES" variable="hosts">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#hosts"
    output = "#REReplace("#hosts#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#hosts" variable="hosts">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#hosts"
    output = "#REReplace("#hosts#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
  
<!--- MODIFY /etc/mailname --->    

<cffile action="read" file="/opt/hermes/conf_files/mailname.HERMES" variable="mailname">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#mailname"
    output = "#REReplace("#mailname#","SERVER-NAME","#ServerName#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#mailname" variable="mailname">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#mailname"
    output = "#REReplace("#mailname#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    

<!--- Create Network Restart Script ---> 

<cffile action="read" file="/opt/hermes/templates/network_restart_dhcp.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-TRANSACTION","#customtrans3#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","SERVER-NAME","#ServerName#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NET-COMMAND","#THENETCOMMAND#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-NETWORK-FILE","#THENETWORKFILE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh" variable="networkrestart">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
    output = "#REReplace("#networkrestart#","THE-INT-FILE","#THEINTFILE#","ALL")#">

   
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_network_restart.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_network_restart.sh"
outputfile ="/dev/null"
timeout = "120">
</cfexecute>

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_network_restart.sh")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_network_restart.sh">
</cfif>



</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="958">
                                        <form name="apply_settings" action="" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="958" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters2 where module='network' and active='1' and applied='2'
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
                                      <td width="8" height="6"></td>
                                      <td width="944"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="944" id="Text330" class="TextObject">
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