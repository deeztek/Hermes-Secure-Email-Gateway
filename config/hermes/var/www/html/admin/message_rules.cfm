<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message Rules</title>
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
              <td height="634" width="988"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">

<CFPARAM NAME="rule_name" DEFAULT="">
<cfif IsDefined("form.rule_name") is "True">
<cfif form.rule_name is not "">
<cfset rule_name = form.rule_name>
</cfif></cfif>

<CFPARAM NAME="rule_desc" DEFAULT="">
<cfif IsDefined("form.rule_desc") is "True">
<cfif form.rule_desc is not "">
<cfset rule_desc = form.rule_desc>
</cfif></cfif>

<CFPARAM NAME="rule_type" DEFAULT="body">
<cfif IsDefined("form.rule_type") is "True">
<cfif form.rule_type is not "">
<cfset rule_type = form.rule_type>
</cfif></cfif>

<CFPARAM NAME="header" DEFAULT="">
<cfif IsDefined("form.header") is "True">
<cfif form.header is not "">
<cfset header = form.header>
</cfif></cfif>

<CFPARAM NAME="regex" DEFAULT="">
<cfif IsDefined("form.regex") is "True">
<cfif form.regex is not "">
<cfset regex = form.regex>
</cfif></cfif>

<CFPARAM NAME="score" DEFAULT="">
<cfif IsDefined("form.score") is "True">
<cfif form.score is not "">
<cfset score = form.score>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<cfif #action# is "edit">

<cfif #rule_name# is "">
<cfset m1=1>
<cfelseif #rule_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",rule_name) gt 0>
<cfset m1=2>
<cfelse>
<cfset step=1>

<!-- /CFIF REFind("[^_a-zA-Z0-9-]"rule_name gt 0 -->
</cfif>

<!-- /CFIF rule_name is "" -->
</cfif>

<cfif step is "1">

<cfquery name="checkname" datasource="#datasource#">
select rule_name from message_rules where rule_name='#rule_name#'
</cfquery>

<cfif #checkname.recordcount# GTE 1>
<cfset m1=3>
<cfelseif #checkname.recordcount# LT 1>
<cfset step=2>

<!-- /CFIF checkname.recordcount "" -->
</cfif>

<!-- /CFIF FOR STEP 1 -->
</cfif>

<cfif step is "2">

<cfif #rule_type# is "header">
<cfif #header# is "">
<cfset m1=4>
<cfelseif #header# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",header) gt 0>
<cfset m1=5>
<cfelse>
<cfset step=3>


<!-- /CFIF REFind("[^_a-zA-Z0-9-]",header) gt 0 -->
</cfif>

<!-- /CFIF header is "" -->
</cfif>

<cfelseif #rule_type# is not "header">
<cfset step=3>

<!-- /CFIF rule_type is header -->
</cfif>

<!-- /CFIF FOR STEP 2 -->
</cfif>


<cfif step is "3">

<cfif #regex# is "">
<cfset m1=6>
<cfelseif #regex# is not "">
<cfset step=4>

<!-- /CFIF regex is "" -->
</cfif>

<!-- /CFIF FOR STEP 3 -->
</cfif>

<cfif step is "4">

<cfif #score# is "">
<cfset m1=7>
<cfelseif #score# is not "">
<cfif IsNumeric(score)> 
<cfset step=5>
<cfelse>
<cfset m1=8>

<!-- /CFIF IsNumeric(score) -->
</cfif>

<!-- /CFIF regex is "" -->
</cfif>

<!-- /CFIF FOR STEP 4 -->
</cfif>


<cfif #step# is "5">

<cfquery name="insert" datasource="#datasource#">
insert into message_rules (rule_name, rule_type, rule_desc, header, regex, score, applied) values ('#rule_name#', '#rule_type#', '#rule_desc#', '#header#', <cfqueryparam value="#regex#" cfsqltype="cf_sql_varchar">, '#score#', '2')
</cfquery>

<cfset rule_name="">
<cfset rule_type="">
<cfset rule_desc="">
<cfset header="">
<cfset regex="">
<cfset score="">

<cflocation url="message_rules.cfm?m2=1" addtoken="no">

<!-- /CFIF FOR STEP 5 -->
</cfif>


<!-- /CFIF FOR ACTION -->
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 634px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="835">
                              <tr valign="top" align="left">
                                <td width="10" height="13"></td>
                                <td width="1"></td>
                                <td width="1"></td>
                                <td width="504"></td>
                                <td width="1"></td>
                                <td width="318"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="3" width="506" id="Text373" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Message Rules</span></b></p>
                                </td>
                                <td colspan="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="3" width="506" id="Text505" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Message Rule</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="106"></td>
                                <td colspan="3" width="823">
                                  <form name="LayoutRegion33FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="780">
                                          <table id="Table139" border="0" cellspacing="0" cellpadding="0" width="780" style="height: 32px;">
                                            <tr style="height: 17px;">
                                              <td width="780" id="Cell1086">
                                                <table width="753" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Added. If you are finished adding rules, click the Apply Settings button below to apply your changes.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Updated. Click the Apply Settings button below to apply your changes.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Deleted. Click the Apply Settings button below to apply your changes.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name you are attempting to use already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field cannot be empty if Rule Type of Header is selected</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Regex field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field must be numeric only</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1084">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Type</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 68px;">
                                              <td id="Cell1085">
                                                <table width="749" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                        <tr style="height: 17px;">
                                                          <td width="64" id="Cell797">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #rule_type# is "body">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value=body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "body">
<cfoutput>
<input type="radio" name="rule_type" value="body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>







&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="685" id="Cell798">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Body Rule <span style="font-weight: normal;">(Search body of messages for matches)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell799">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #rule_type# is "header">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "header">
<cfoutput>
<input type="radio" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell800">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Header Rule <span style="font-weight: normal;">(Search message header for matches. Ex: Subject, To, From)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1077">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #rule_type# is "uri">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "uri">
<cfoutput>
<input type="radio" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1078">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">URI Rule <span style="font-weight: normal;">(Search for URI in the plain text or HTML section of messages)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1079">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #rule_type# is "rawbody">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "rawbody">
<cfoutput>
<input type="radio" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1080">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Rawbody Rule <span style="font-weight: normal;">(Search body of messages for HTML tags or HTML comments or line-break patterns)</span></span></b></p>
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
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="135">
                              <tr valign="top" align="left">
                                <td width="110" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/message-rules/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="13" height="7"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="226"></td>
                          <td width="957">




 

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 226px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="message_rules.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="rule_type" value="<cfoutput>#rule_type#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="803">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 153px;">
                                            <tr style="height: 14px;">
                                              <td width="803" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Rule Name <span style="font-weight: normal;">(Letters numbers, dashes and underlines only. No spaces are allowed)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell972">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField39" name="rule_name" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#rule_name#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Description</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell902">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField61" name="rule_desc" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#rule_desc#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1082">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Message Header </span></b><span style="font-weight: normal;">(Letters numbers, dashes and underlines only. No spaces are allowed. Use ALL to match any header)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1083">
                                                <table width="440" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #rule_type# is not "header">
<cfoutput>
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="" disabled="disabled">
</cfoutput>

<cfelseif #rule_type# is "header">
<cfoutput>
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="#header#">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell904">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Regex<span style="font-weight: normal;"> </span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell905">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField63" name="regex" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#regex#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell906">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Spam Score </span></b><span style="font-weight: normal;">(Numeric value only. A score of 0 effectively disables rule)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"><cfoutput><input type="text" id="FormsEditField62" name="score" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#score#"></cfoutput></span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="957" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Adding Rule, please wait...';this.form.submit();" name="savechanges" value="Add Rule" style="height: 24px; width: 275px;">
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
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="448"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text410" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Existing Message Rules</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td width="960"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="960" id="Text407" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getmessagerules" datasource="#datasource#">
select * from message_rules order by rule_name asc
</cfquery>

<cfif #getmessagerules.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Existing Message Rules were found...</span></i></b></p>

<cfelseif #getmessagerules.recordcount# GTE 1>
<table id="Table131" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="212" style="background-color: rgb(241,236,236);" id="Cell792">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Name</span></b></p>
    </td>
<td width="391" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Description</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Type</span></b></p>
    </td>


    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Header</span></b></p>
    </td>




    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Regex</span></b></p>
    </td>




    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Score</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Edit</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Delete</span></b></p>
    </td>



  </tr>

<cfoutput query="getmessagerules">

  <tr style="height: 19px;">

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#rule_name#</span></p>
</td>

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#rule_desc#</span></p>
</td>

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#rule_type#</span></p>
</td>

<cfif #rule_type# is "header">

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#header#</span></p>
</td>

<cfelse>

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">N/A</span></p>
</td>

</cfif>

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#regex#</span></p>
</td>

<td id="Cell798">
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#score#</span></p>
</td>


<td id="Cell802">
      <form name="editreport" action="edit_message_rule.cfm" method="post">
<input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>

<td align="center"><input type="image" name="FormsButton1" src="configure_icon.png" style="height: 19px; border-start-width: 0px; border-start-style: solid; border-top-width: 0px; border-top-style: solid; border-end-width: 0px; border-end-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>


          </tr>
        </table>
      </form>
    </td>




    <td id="Cell802">
      <form name="Cell802FORM" action="delete_message_rule.cfm" method="post">
<input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>


<td align="center"><input type="image" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-start-width: 0px; border-start-style: solid; border-top-width: 0px; border-top-style: solid; border-end-width: 0px; border-end-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>


          </tr>
        </table>
      </form>
    </td>
  </tr>
</cfoutput>
</table>
</cfif>
    &nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="955"><hr id="HRRule31" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="48"></td>
                          <td width="952"><cfif #action# is "apply">
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

<cffile action="read" file="/opt/hermes/conf_files/local.cf.HERMES" variable="safile">

<cfif #get_use_dcc.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-DCC","use_dcc 1","ALL")#">

<cfelseif #get_use_dcc.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-DCC","use_dcc 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cfif #get_use_pyzor.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 1","ALL")#">

<cfelseif #get_use_pyzor.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-PYZOR","use_pyzor 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cfif #get_use_razor2.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 1","ALL")#">

<cfelseif #get_use_razor2.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-RAZOR2","use_razor2 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cfif #get_use_bayes.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-BAYES","use_bayes 1","ALL")#">

<cfelseif #get_use_bayes.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","USE-BAYES","use_bayes 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cfif #get_bayes_auto_learn.value# is "1">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 1","ALL")#">

<cfelseif #get_bayes_auto_learn.value# is "0">
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","BAYES-AUTO-LEARN","bayes_auto_learn 0","ALL")#">
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","BAYESAUTOLEARN-SPAM","bayes_auto_learn_threshold_spam #get_bayes_auto_learn_threshold_spam.value#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","BAYESAUTOLEARN-HAM","bayes_auto_learn_threshold_nonspam #get_bayes_auto_learn_threshold_nonspam.value#","ALL")#">

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

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","##CUSTOM-TESTS","#theTests#","ALL")#">


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

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#local.cf.HERMES" variable="safile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#local.cf.HERMES"
    output = "#REReplace("#safile#","##CUSTOM-MESSAGE-RULES","#theRules#","ALL")#">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_message_rules")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_message_rules">
</cfif>


</cfif>

<!--- /ETC/SPAMASSASSIN/LOCAL.CF CUSTOM MESSAGE RULES ABOVE --->


<!--- EDIT /ETC/SPAMASASSIN/LOCAL.CF ABOVE --->

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.cf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#local.cf.HERMES /etc/spamassassin/local.cf#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/etc/init.d/amavis restart#chr(10)#/etc/init.d/postfix restart"
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
update spam_settings set applied='1' where applied = '2' and spamfilter = '1'
</cfquery> 

<cfquery name="updaterules" datasource="#datasource#">
update message_rules set applied='1' where applied = '2'
</cfquery> 


<cflocation url="message_rules.cfm?m2=16" addtoken="no">
    
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion13" style="height: 48px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="10"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952">
                                        <form name="apply_settings" action="message_rules.cfm" method="post">
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
select applied from message_rules where applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="hidden" name="action" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="hidden" name="action" value="apply">
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