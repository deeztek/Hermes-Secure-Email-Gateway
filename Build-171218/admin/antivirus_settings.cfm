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
<title>Antivirus Settings</title>
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
              <td height="1232" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1232px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="11" height="21"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antivirus Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="453">
                              <tr valign="top" align="left">
                                <td width="428" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/antivirus-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="6"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="967"></td>
                          <td width="959"><cfparam name = "m" default = "0"> 
<cfparam name = "m2" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfset show_action = form.action>
</cfif>

<cfquery name="getScanMail" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanMail' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanArchive" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanArchive' and active = '1' and module='clamav'
</cfquery>


<cfquery name="getArchiveBlockEncrypted" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ArchiveBlockEncrypted' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPE" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPE' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanOLE2" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanOLE2' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getOLE2BlockMacros" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='OLE2BlockMacros' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPDF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPDF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanHTML" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanHTML' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getAlgorithmicDetection" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='AlgorithmicDetection' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanELF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanELF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingSignatures" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingSignatures' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingScanURLs" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingScanURLs' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockSSLMismatch" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockSSLMismatch' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockCloak" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockCloak' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getDetectPUA" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='DetectPUA' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getHeuristicScanPrecedence" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='HeuristicScanPrecedence' and active = '1' and module='clamav'
</cfquery>


<cfparam name = "ScanMail" default = "#getScanMail.value2#"> 
<cfif IsDefined("form.ScanMail") is "True">
<cfset ScanMail = form.ScanMail>
</cfif>

<cfparam name = "ScanArchive" default = "#getScanArchive.value2#"> 
<cfif IsDefined("form.ScanArchive") is "True">
<cfset ScanArchive= form.ScanArchive>
</cfif>

<cfparam name = "ArchiveBlockEncrypted" default = "#getArchiveBlockEncrypted.value2#"> 
<cfif IsDefined("form.ArchiveBlockEncrypted") is "True">
<cfset ArchiveBlockEncrypted= form.ArchiveBlockEncrypted>
</cfif>

<cfparam name = "ScanPE" default = "#getScanPE.value2#"> 
<cfif IsDefined("form.ScanPE") is "True">
<cfset ScanPE= form.ScanPE>
</cfif>

<cfparam name = "ScanOLE2" default = "#getScanOLE2.value2#"> 
<cfif IsDefined("form.ScanOLE2") is "True">
<cfset ScanOLE2= form.ScanOLE2>
</cfif>

<cfparam name = "OLE2BlockMacros" default = "#getOLE2BlockMacros.value2#"> 
<cfif IsDefined("form.OLE2BlockMacros") is "True">
<cfset OLE2BlockMacros = form.OLE2BlockMacros>
</cfif>

<cfparam name = "ScanPDF" default = "#getScanPDF.value2#"> 
<cfif IsDefined("form.ScanPDF") is "True">
<cfset ScanPDF = form.ScanPDF>
</cfif>



<cfparam name = "ScanHTML" default = "#getScanHTML.value2#"> 
<cfif IsDefined("form.ScanHTML") is "True">
<cfset ScanHTML = form.ScanHTML>
</cfif>


<cfparam name = "AlgorithmicDetection" default = "#getAlgorithmicDetection.value2#"> 
<cfif IsDefined("form.AlgorithmicDetection") is "True">
<cfset AlgorithmicDetection = form.AlgorithmicDetection>
</cfif>

<cfparam name = "ScanELF" default = "#getScanELF.value2#"> 
<cfif IsDefined("form.ScanELF") is "True">
<cfset ScanELF = form.ScanELF>
</cfif>

<cfparam name = "PhishingSignatures" default = "#getPhishingSignatures.value2#"> 
<cfif IsDefined("form.PhishingSignatures") is "True">
<cfset PhishingSignatures = form.PhishingSignatures>
</cfif>

<cfparam name = "PhishingScanURLs" default = "#getPhishingScanURLs.value2#"> 
<cfif IsDefined("form.PhishingScanURLs") is "True">
<cfset PhishingScanURLs = form.PhishingScanURLs>
</cfif>

<cfparam name = "PhishingAlwaysBlockSSLMismatch" default = "#getPhishingAlwaysBlockSSLMismatch.value2#"> 
<cfif IsDefined("form.PhishingAlwaysBlockSSLMismatch") is "True">
<cfset PhishingAlwaysBlockSSLMismatch = form.PhishingAlwaysBlockSSLMismatch>
</cfif>

<cfparam name = "PhishingAlwaysBlockCloak" default = "#getPhishingAlwaysBlockCloak.value2#"> 
<cfif IsDefined("form.PhishingAlwaysBlockCloak") is "True">
<cfset PhishingAlwaysBlockCloak = form.PhishingAlwaysBlockCloak>
</cfif>

<cfparam name = "DetectPUA" default = "#getDetectPUA.value2#"> 
<cfif IsDefined("form.DetectPUA") is "True">
<cfset DetectPUA = form.DetectPUA>
</cfif>

<cfparam name = "HeuristicScanPrecedence" default = "#getHeuristicScanPrecedence.value2#"> 
<cfif IsDefined("form.HeuristicScanPrecedence") is "True">
<cfset HeuristicScanPrecedence = form.HeuristicScanPrecedence>
</cfif>



<cfif #action# is "edit">


<cfquery name="updateScanMail" datasource="#datasource#">
update parameters2 set value2='#ScanMail#', applied='2' where parameter='ScanMail' and module='clamav'
</cfquery>

<cfquery name="updateScanArchive" datasource="#datasource#">
update parameters2 set value2='#ScanArchive#', applied='2' where parameter='ScanArchive' and module='clamav'
</cfquery>

<cfquery name="updateArchiveBlockEncrypted" datasource="#datasource#">
update parameters2 set value2='#ArchiveBlockEncrypted#', applied='2' where parameter='ArchiveBlockEncrypted' and module='clamav'
</cfquery>

<cfquery name="updateScanPE" datasource="#datasource#">
update parameters2 set value2='#ScanPE#', applied='2' where parameter='ScanPE' and module='clamav'
</cfquery>

<cfquery name="updateScanOLE2" datasource="#datasource#">
update parameters2 set value2='#ScanOLE2#', applied='2' where parameter='ScanOLE2' and module='clamav'
</cfquery>

<cfquery name="updateOLE2BlockMacros" datasource="#datasource#">
update parameters2 set value2='#OLE2BlockMacros#', applied='2' where parameter='OLE2BlockMacros' and module='clamav'
</cfquery>

<cfquery name="updateScanPDF" datasource="#datasource#">
update parameters2 set value2='#ScanPDF#', applied='2' where parameter='ScanPDF' and module='clamav'
</cfquery>

<cfquery name="updateScanHTML" datasource="#datasource#">
update parameters2 set value2='#ScanHTML#', applied='2' where parameter='ScanHTML' and module='clamav'
</cfquery>

<cfquery name="updateAlgorithmicDetection" datasource="#datasource#">
update parameters2 set value2='#AlgorithmicDetection#', applied='2' where parameter='AlgorithmicDetection' and module='clamav'
</cfquery>

<cfquery name="updateScanELF" datasource="#datasource#">
update parameters2 set value2='#ScanELF#', applied='2' where parameter='ScanELF' and module='clamav'
</cfquery>

<cfquery name="updatePhishingSignatures" datasource="#datasource#">
update parameters2 set value2='#PhishingSignatures#', applied='2' where parameter='PhishingSignatures' and module='clamav'
</cfquery>

<cfquery name="updatePhishingScanURLs" datasource="#datasource#">
update parameters2 set value2='#PhishingScanURLs#', applied='2' where parameter='PhishingScanURLs' and module='clamav'
</cfquery>

<cfquery name="updatePhishingAlwaysBlockSSLMismatch" datasource="#datasource#">
update parameters2 set value2='#PhishingAlwaysBlockSSLMismatch#', applied='2' where parameter='PhishingAlwaysBlockSSLMismatch' and module='clamav'
</cfquery>

<cfquery name="updatePhishingAlwaysBlockCloak" datasource="#datasource#">
update parameters2 set value2='#PhishingAlwaysBlockCloak#', applied='2' where parameter='PhishingAlwaysBlockCloak' and module='clamav'
</cfquery>

<cfquery name="updateDetectPUA" datasource="#datasource#">
update parameters2 set value2='#DetectPUA#', applied='2' where parameter='DetectPUA' and module='clamav'
</cfquery>

<cfquery name="updateHeuristicScanPrecedence" datasource="#datasource#">
update parameters2 set value2='#HeuristicScanPrecedence#', applied='2' where parameter='HeuristicScanPrecedence' and module='clamav'
</cfquery>


<cfset m=27>

</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion11" style="height: 967px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="antivirus_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="19"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="959" style="height: 640px;">
                                            <tr style="height: 14px;">
                                              <td width="959" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Email Files <span style="font-weight: normal;">(</span><span style="color: rgb(255,0,0);">WARNING:</span> <span style="font-weight: normal;">Setting to Disabled will effectively disable the antivirus engine)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 38px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table180" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1120">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanMail# is "true">
<cfoutput>
<input type="radio" name="ScanMail" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanMail# is not "true">
<cfoutput>
<input type="radio" name="ScanMail" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1121">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1122">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanMail# is "false">
<cfoutput>
<input type="radio" name="ScanMail" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanMail# is not "false">
<cfoutput>
<input type="radio" name="ScanMail" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1123">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1091">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Archives <span style="font-weight: normal;">(Enable scanning of archive files such as ZIP, RAR etc)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1092">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table181" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1124">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanArchive# is "true">
<cfoutput>
<input type="radio" name="ScanArchive" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanArchive# is not "true">
<cfoutput>
<input type="radio" name="ScanArchive" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1125">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1126">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanArchive# is "false">
<cfoutput>
<input type="radio" name="ScanArchive" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanArchive# is not "false">
<cfoutput>
<input type="radio" name="ScanArchive" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1127">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1143">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Mark Encrypted Archives as Viruses <span style="font-weight: normal;">(Encrypted Zip, Encrypted RAR)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1144">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table182" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1128">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ArchiveBlockEncrypted# is "true">
<cfoutput>
<input type="radio" name="ArchiveBlockEncrypted" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ArchiveBlockEncrypted# is not "true">
<cfoutput>
<input type="radio" name="ArchiveBlockEncrypted" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1129">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1130">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ArchiveBlockEncrypted# is "false">
<cfoutput>
<input type="radio" name="ArchiveBlockEncrypted" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ArchiveBlockEncrypted# is not "false">
<cfoutput>
<input type="radio" name="ArchiveBlockEncrypted" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1131">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 28px;">
                                                <td id="Cell1105">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Portable Executables. <span style="font-weight: normal;">(This allows AV engine to perform a deeper analysis of executable files. This option is also required for decompression of popular executable packers such as UPX)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1099">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table183" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1145">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanPE# is "true">
<cfoutput>
<input type="radio" name="ScanPE" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanPE# is not "true">
<cfoutput>
<input type="radio" name="ScanPE" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1146">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1147">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanPE# is "false">
<cfoutput>
<input type="radio" name="ScanPE" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanPE# is not "false">
<cfoutput>
<input type="radio" name="ScanPE" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1148">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1100">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Scan OLE2 files <span style="font-weight: normal;">(Microsoft Office Documents, MSI files)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1109">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1060">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanOLE2# is "true">
<cfoutput>
<input type="radio" name="ScanOLE2" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanOLE2# is not "true">
<cfoutput>
<input type="radio" name="ScanOLE2" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1061">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1062">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanOLE2# is "false">
<cfoutput>
<input type="radio" name="ScanOLE2" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanOLE2# is not "false">
<cfoutput>
<input type="radio" name="ScanOLE2" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1063">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 28px;">
                                                <td id="Cell1110">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Block OLE2 Macros <span style="font-weight: normal;">(</span><span style="color: rgb(255,0,0);">WARNING:</span><span style="font-weight: normal;"> This will bypass ALL AV signatures and block ALL OLE2 files with VBA Macros in them whether malicious or not. In effect, it will treat any macros as a virus. This setting has no effect if </span>Enable Scanning of OLE2 files<span style="font-weight: normal;"> is set to Disabled)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1111">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1078">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #OLE2BlockMacros# is "true">
<cfoutput>
<input type="radio" name="OLE2BlockMacros" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #OLE2BlockMacros# is not "true">
<cfoutput>
<input type="radio" name="OLE2BlockMacros" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1079">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1080">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #OLE2BlockMacros# is "false">
<cfoutput>
<input type="radio" name="OLE2BlockMacros" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #OLE2BlockMacros# is not "false">
<cfoutput>
<input type="radio" name="OLE2BlockMacros" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1081">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1180">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Scan PDF files</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1181">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1175">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanPDF# is "true">
<cfoutput>
<input type="radio" name="ScanPDF" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanPDF# is not "true">
<cfoutput>
<input type="radio" name="ScanPDF" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1176">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1177">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanPDF# is "false">
<cfoutput>
<input type="radio" name="ScanPDF" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanPDF# is not "false">
<cfoutput>
<input type="radio" name="ScanPDF" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1178">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan and normalize HTML </span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1047">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1082">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanHTML# is "true">
<cfoutput>
<input type="radio" name="ScanHTML" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanHTML# is not "true">
<cfoutput>
<input type="radio" name="ScanHTML" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1083">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1084">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #ScanHTML# is "false">
<cfoutput>
<input type="radio" name="ScanHTML" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanHTML# is not "false">
<cfoutput>
<input type="radio" name="ScanHTML" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1085">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Algorithmic Detection <span style="font-weight: normal;">(Useful in detecting complex malware, exploits in graphic files and others)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td>
                                                          <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                            <tr style="height: 19px;">
                                                              <td width="58" id="Cell1086">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;"><cfif #AlgorithmicDetection# is "true">
<cfoutput>
<input type="radio" name="AlgorithmicDetection" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #AlgorithmicDetection# is not "true">
<cfoutput>
<input type="radio" name="AlgorithmicDetection" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td width="429" id="Cell1087">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                              </td>
                                                            </tr>
                                                            <tr style="height: 19px;">
                                                              <td id="Cell1088">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;"><cfif #AlgorithmicDetection# is "false">
<cfoutput>
<input type="radio" name="AlgorithmicDetection" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #AlgorithmicDetection# is not "false">
<cfoutput>
<input type="radio" name="AlgorithmicDetection" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td id="Cell1089">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Executable and Linking Format Files (ELF)</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 38px;">
                                                  <td id="Cell912">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table178" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1112">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #ScanELF# is "true">
<cfoutput>
<input type="radio" name="ScanELF" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanELF# is not "true">
<cfoutput>
<input type="radio" name="ScanELF" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1113">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1114">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #ScanELF# is "false">
<cfoutput>
<input type="radio" name="ScanELF" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #ScanELF# is not "false">
<cfoutput>
<input type="radio" name="ScanELF" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1115">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      </b></td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1014">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Signature Based Detection of Phishing Attempts</span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1058">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table179" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1116">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingSignatures# is "true">
<cfoutput>
<input type="radio" name="PhishingSignatures" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingSignatures# is not "true">
<cfoutput>
<input type="radio" name="PhishingSignatures" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1117">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1118">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingSignatures# is "false">
<cfoutput>
<input type="radio" name="PhishingSignatures" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingSignatures# is not "false">
<cfoutput>
<input type="radio" name="PhishingSignatures" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1119">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1059">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Email URLs for Phishing Attempts </span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1072">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table177" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1093">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingScanURLs# is "true">
<cfoutput>
<input type="radio" name="PhishingScanURLs" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingScanURLs# is not "true">
<cfoutput>
<input type="radio" name="PhishingScanURLs" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1094">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1095">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingScanURLs# is "false">
<cfoutput>
<input type="radio" name="PhishingScanURLs" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingScanURLs# is not "false">
<cfoutput>
<input type="radio" name="PhishingScanURLs" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1096">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1073">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Block SSL Mismatches in Email URLs </b>(<b><span style="color: rgb(255,0,0);">Warning:</span></b> This can lead to false positives)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1149">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1151">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingAlwaysBlockSSLMismatch# is "true">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingAlwaysBlockSSLMismatch# is not "true">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1152">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled </span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1153">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingAlwaysBlockSSLMismatch# is "false">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingAlwaysBlockSSLMismatch# is not "false">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1154">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1150">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Block Cloaked Email URLs </b>(<b><span style="color: rgb(255,0,0);">Warning:</span></b> This can lead to false positives)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1155">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1156">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingAlwaysBlockCloak# is "true">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockCloak" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingAlwaysBlockCloak# is not "true">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockCloak" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1157">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1158">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #PhishingAlwaysBlockCloak# is "false">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockCloak" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #PhishingAlwaysBlockCloak# is not "false">
<cfoutput>
<input type="radio" name="PhishingAlwaysBlockCloak" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1159">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1161">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Detect Possibly Unwanted Applications</span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1162">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table186" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1163">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #DetectPUA# is "true">
<cfoutput>
<input type="radio" name="DetectPUA" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #DetectPUA# is not "true">
<cfoutput>
<input type="radio" name="DetectPUA" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1164">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1165">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #DetectPUA# is "false">
<cfoutput>
<input type="radio" name="DetectPUA" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #DetectPUA# is not "false">
<cfoutput>
<input type="radio" name="DetectPUA" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1166">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 42px;">
                                                    <td id="Cell1168">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Heuristic Scan Precedence </b>(When enabled, if a heuristic malware match, the scanning will stop immediately thus saving CPU. When disabled, heuristic matches will be reported at the end of the scan. For example, if disabled and an archive contains both a heuristically detected malware and a signature based malware, the signature based malware will be reported. If signature based malware is found, the scan stops immediately regardless of whether this option is enabled or not)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1167">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1169">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HeuristicScanPrecedence# is "true">
<cfoutput>
<input type="radio" name="HeuristicScanPrecedence" value="true" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #HeuristicScanPrecedence# is not "true">
<cfoutput>
<input type="radio" name="HeuristicScanPrecedence" value="true" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1170">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1171">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"><cfif #HeuristicScanPrecedence# is "false">
<cfoutput>
<input type="radio" name="HeuristicScanPrecedence" value="false" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelseif #HeuristicScanPrecedence# is not "false">
<cfoutput>
<input type="radio" name="HeuristicScanPrecedence" value="false" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1172">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1179">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1015">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
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
                                          <table border="0" cellspacing="0" cellpadding="0" width="959">
                                            <tr valign="top" align="left">
                                              <td width="959" height="9"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="959" id="Text495" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;">
<cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the User Portal Address cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Spam Message Modified Subject String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be an integer</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be an integer</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be an integer</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "15">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be an integer</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "20">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "21">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "22">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be an integer</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "23">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "24">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be greater than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "25">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be less 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "26">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be an integer</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m# is "27">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
</cfoutput>
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
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="966">
                              <tr valign="top" align="left">
                                <td width="9" height="3"></td>
                                <td></td>
                                <td width="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="30"></td>
                                <td colspan="2" valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="46"></td>
                                <td width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

<cfquery name="getScanMail" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanMail' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanArchive" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanArchive' and active = '1' and module='clamav'
</cfquery>


<cfquery name="getArchiveBlockEncrypted" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ArchiveBlockEncrypted' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPE" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPE' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanOLE2" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanOLE2' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getOLE2BlockMacros" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='OLE2BlockMacros' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPDF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPDF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanHTML" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanHTML' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getAlgorithmicDetection" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='AlgorithmicDetection' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanELF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanELF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingSignatures" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingSignatures' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingScanURLs" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingScanURLs' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockSSLMismatch" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockSSLMismatch' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockCloak" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockCloak' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getDetectPUA" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='DetectPUA' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getHeuristicScanPrecedence" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='HeuristicScanPrecedence' and active = '1' and module='clamav'
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

<cffile action="read" file="/opt/hermes/conf_files/clamd.conf.HERMES" variable="clam">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-Mail","ScanMail #getScanmail.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-Archive","ScanArchive #getScanArchive.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Archive-BlockEncrypted","ArchiveBlockEncrypted #getArchiveBlockEncrypted.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-PE","ScanPE #getScanPE.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-OLE2","ScanOLE2 #getScanOLE2.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","OLE2-BlockMacros","OLE2BlockMacros #getOLE2BlockMacros.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-PDF","ScanPDF #getScanPDF.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-HTML","ScanHTML #getScanHTML.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Algorithmic-Detection","AlgorithmicDetection #getAlgorithmicDetection.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-ELF","ScanELF #getScanELF.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-Signatures","PhishingSignatures #getPhishingSignatures.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-ScanURLs","PhishingScanURLs #getPhishingScanURLs.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-AlwaysBlockSSLMismatch","PhishingAlwaysBlockSSLMismatch #getPhishingAlwaysBlockSSLMismatch.value2#","ALL")#">
 
 
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-AlwaysBlockCloak","PhishingAlwaysBlockCloak #getPhishingAlwaysBlockCloak.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Detect-PUA","DetectPUA #getDetectPUA.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","HeuristicScan-Precedence","HeuristicScanPrecedence #getHeuristicScanPrecedence.value2#","ALL")#">


<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/clamav/clamd.conf /etc/clamav/clamd.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">


<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES /etc/clamav/clamd.conf#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/etc/init.d/clamav-daemon restart#chr(10)#/etc/init.d/amavis restart#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh"> 

    
<cfquery name="updateparams" datasource="#datasource#">
update parameters2 set applied='1' where applied = '2' and module = 'clamav'
</cfquery> 
    
</cfif>


                                  <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 46px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="955">
                                              <form name="apply_settings" action="antivirus_settings.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="955" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters2 where module = 'clamav' and applied='2'
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
                                            <td width="955" height="5"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="955" id="Text351" class="TextObject">
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