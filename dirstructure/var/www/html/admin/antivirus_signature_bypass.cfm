<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Antivirus Signature Bypass</title>
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 501px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="515">
                              <tr valign="top" align="left">
                                <td width="9" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antivirus Signature Bypass</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/antivirus-signature-bypass/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="959">
                        <tr valign="top" align="left">
                          <td width="9" height="2"></td>
                          <td width="950"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="950" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">In this page, you can manage problematic Antivirus Signatures that cause too many false positives. Determining a problematic signature is as simple as looking at a blocked email&#8217;s headers which would yield the actual signature that was used to block the email. Alternatively, looking at the System Logs and searching for the keyword <b>INFECTED</b> will also yield the actual signature. Enter the signature name in the Signature field below and click on the <b>Add Signature Bypass</b> button below. Additionally, you can delete already specified bypassed signature below by checking the <b>Delete</b> checkbox and clicking on the <b>Delete Signature Bypass(es) </b>button.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="959">
                        <tr valign="top" align="left">
                          <td width="8" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="951"><hr id="HRRule35" width="951" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="959">
                        <tr valign="top" align="left">
                          <td width="8" height="2"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="444"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text482" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Antivirus Signature Bypass</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="86"></td>
                          <td colspan="3" width="951"><cfparam name = "m" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 

<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<cfparam name = "signature" default = ""> 
<cfif IsDefined("form.signature") is "True">
<cfset signature = form.signature>
</cfif>


<cfif #action# is "Add Signature">


<cfif #signature# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #signature# is not "">
<cfset step=1>
</cfif>

<cfif step is "1">
<cfquery name="checksignature" datasource="#datasource#">
select parameter, module from parameters2 where parameter = '#signature#' and module = 'clamav-bypass'
</cfquery>
<cfif #checksignature.recordcount# GTE 1>
<cfset step=0>
<cfset m=2>
<cfelseif #checksignature.recordcount# LT 1>
<cfset step=2>
</cfif>
</cfif>

<cfif #step# is "2">
<cfquery name="insertsignature" datasource="#datasource#">
insert into parameters2 (parameter, value2, module, active, applied) values ('#signature#', 'true', 'clamav-bypass', '1', '2')
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

<cfquery name = "getbypass" datasource="#datasource#">
select parameter, module from parameters2 where module = 'clamav-bypass'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
    output = ""
    addNewLine = "no">
    
<cfoutput query="getbypass">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
    output = "#parameter##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_local.ign2")>

<cfexecute name = "/bin/cp"
arguments="/var/lib/clamav/local.ign2 /var/lib/clamav/local.ign2.HERMES"
timeout = "60">
</cfexecute>

<cfexecute name = "/bin/cp"
arguments="/opt/hermes/tmp/#customtrans3#_local.ign2 /var/lib/clamav/local.ign2"
timeout = "60">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2">

<cfquery name="updateparameters" datasource="#datasource#">
update parameters2 set applied = '1' where module = 'clamav-bypass'
</cfquery>

<cfexecute name = "/bin/chown"
arguments="clamav:clamav /var/lib/clamav/local.ign2"
timeout = "240"
outputfile = "/dev/null">
</cfexecute>

<cfexecute name = "/etc/init.d/clamav-daemon"
arguments="force-reload"
timeout = "240"
outputfile = "/dev/null">
</cfexecute>

<cfset m=7>

<cfelse>

<cfset m=8>

<!-- /CFIF FileExists /opt/hermes/tmp/#customtrans3#_local.ign2 -->
</cfif>

<!-- /CFIF step-->
</cfif>

<cfelseif action is "Delete Signature">

<!-- START ROUTINE TO DELETE SIGNATURES -->

<cfloop index="thefield" list="#form.fieldnames#">
<cfif thefield contains 'cboxdelete'>
<cfoutput>
<cfset thedeleteId = listGetAt(form[thefield], 2, "_")>


<cfquery name="deletesignature" datasource="#datasource#">
delete from parameters2 where id = '#thedeleteId#' and module = 'clamav-bypass'
</cfquery>

</cfoutput>
</cfif>
</cfloop>

<!-- STOP ROUTINE TO DELETE SIGNATURES -->

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

<cfquery name = "getbypass" datasource="#datasource#">
select parameter, module from parameters2 where module = 'clamav-bypass'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
    output = ""
    addNewLine = "no">
    
<cfoutput query="getbypass">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
    output = "#parameter##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_local.ign2")>

<cfexecute name = "/bin/cp"
arguments="/var/lib/clamav/local.ign2 /var/lib/clamav/local.ign2.HERMES"
timeout = "60">
</cfexecute>

<cfexecute name = "/bin/cp"
arguments="/opt/hermes/tmp/#customtrans3#_local.ign2 /var/lib/clamav/local.ign2"
timeout = "60">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_local.ign2">


<cfexecute name = "/bin/chown"
arguments="clamav:clamav /var/lib/clamav/local.ign2"
timeout = "240"
outputfile = "/dev/null">
</cfexecute>

<cfexecute name = "/etc/init.d/clamav-daemon"
arguments="force-reload"
timeout = "240"
outputfile = "/dev/null">
</cfexecute>

<cfset m=9>

<cfelse>

<cfset m=8>

<!-- /CFIF FileExists /opt/hermes/tmp/#customtrans3#_local.ign2 -->
</cfif>

<!-- /CFIF action-->
</cfif>

<table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion11" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 330px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion11" style="height: 86px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <input type="hidden" name="action" value="Add Signature">
                                    <table border="0" cellspacing="0" cellpadding="0" width="951">
                                      <tr valign="top" align="left">
                                        <td width="951" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Signature field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Signature you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Encryption by e-mail subject keyword field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Signature Bypass Added.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;An error occured while setting up local.ign2 file. Please contact support for assistance</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Signature Bypass(es) Deleted.</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="951">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 4px;">
                                            <tr style="height: 14px;">
                                              <td width="947" id="Cell908">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Signature</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell909">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="signature" size="55" maxlength="255" style="width: 236px; white-space: pre;" style="white-space:pre" value="#signature#">
</cfoutput>

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
                                    <table border="0" cellspacing="0" cellpadding="0" width="951">
                                      <tr valign="top" align="left">
                                        <td width="951" height="9"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="951" id="Text529" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please Wait...';this.form.submit();" value="Add Signature Bypass" style="height: 24px; width: 200px;">
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
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="951"><hr id="HRRule34" width="951" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text526" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Existing Antivirus Signature Bypasses</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="961">
                        <tr valign="top" align="left">
                          <td width="8" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="65"></td>
                          <td width="953">
                            <form name="LayoutRegion33FORM" action="" method="post">
                              <input type="hidden" name="action" value="Delete Signature">
                              <table border="0" cellspacing="0" cellpadding="0" width="953">
                                <tr valign="top" align="left">
                                  <td colspan="2" width="953" id="Text521" class="TextObject">
                                    <p style="margin-bottom: 0px;">
<cfquery name="getbypasses" datasource="#datasource#">
select id, parameter, module from parameters2 where module = 'clamav-bypass' order by parameter asc
</cfquery>



<cfif #getbypasses.recordcount# LT 1>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);  font-size: 12px;">No Antivirus Signature Bypasses found...</span></i></b></p>

<cfelseif #getbypasses.recordcount# GTE 1>

<table id="Table71" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;" class="bottomBorder">
  <tr style="height: 14px;">

    <td width="48" style="background-color: rgb(241,236,236);" id="Cell764">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Signature Name</span></b></p>
    </td>
    
<td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete</span></b></p>
    </td>



  </tr>


<cfoutput query="getbypasses">
  <tr style="height: 19px;">



    <td id="Cell406">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#parameter#</span></p>
    </td>





<td align="center">
<input type="checkbox" name="cboxdelete#id#" value="cboxdelete_#id#" style="height: 13px; width: 13px;">
</td>



  </tr>
</cfoutput>

</table>
</cfif>&nbsp;</p>
                                  </td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td width="951" height="17"></td>
                                  <td width="2"></td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td width="951" id="Text530" class="TextObject">
                                    <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please Wait...';this.form.submit();" value="Delete Signature Bypass(es)" style="height: 24px; width: 200px;">
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