<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DMARC Configuration</title>
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
              <td height="570" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>


<!--- GET OPENDMARC USERNAME --->
<cfquery name="get_mysql_username_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_opendmarc'
</cfquery>

<cfif #get_mysql_username_opendmarc.value# is "">

<cflocation url="error.cfm" addtoken="no">

</cfif>

<!--- GET OPENDMARC PASSWORD --->
<cfquery name="get_mysql_password_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_opendmarc'
</cfquery>

<cfif #get_mysql_password_opendmarc.value# is "">

<cflocation url="error.cfm" addtoken="no">

</cfif>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 570px;">
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
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">DMARC Configuration</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/dmarc-configuration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="961">
                        <tr valign="top" align="left">
                          <td width="10" height="4"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>DMARC</b> (<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Domain-based Message Authentication, Reporting and Conformance Checks</span>)</b> is set to <b>enabled</b> under <a href="./perimeter_configuration.cfm"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="10" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="977">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="299"></td>
                          <td width="965"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "show_action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset show_action = form.action>
</cfif></cfif>

<cfquery name="get_FailureReports" datasource="#datasource#">
select value2 from parameters2 where parameter='FailureReports' and module = 'dmarc'
</cfquery>


<cfquery name="get_RejectFailures" datasource="#datasource#">
select value2 from parameters2 where parameter='RejectFailures' and module = 'dmarc'
</cfquery>

<cfquery name="get_report_email" datasource="#datasource#">
select value2 from parameters2 where parameter='report_email' and module = 'dmarc'
</cfquery>

<cfquery name="get_report_org" datasource="#datasource#">
select value2 from parameters2 where parameter='report_org' and module = 'dmarc'
</cfquery>

<cfquery name="get_interval" datasource="#datasource#">
select value2 from parameters2 where parameter='interval' and module = 'dmarc'
</cfquery>

<cfquery name="get_startdate" datasource="#datasource#">
select value2 from parameters2 where parameter='startdate' and module = 'dmarc'
</cfquery>

<cfquery name="get_starttime" datasource="#datasource#">
select value2 from parameters2 where parameter='starttime' and module = 'dmarc'
</cfquery>


<cfparam name = "FailureReports" default = "#get_FailureReports.value2#"> 
<cfif IsDefined("form.FailureReports") is "True">
<cfif form.FailureReports is not "">
<cfset FailureReports = form.FailureReports>
</cfif></cfif> 


<cfparam name = "RejectFailures" default = "#get_RejectFailures.value2#"> 
<cfif IsDefined("form.RejectFailures") is "True">
<cfif form.RejectFailures is not "">
<cfset RejectFailures = form.RejectFailures>
</cfif></cfif> 

<cfparam name = "report_email" default = "#get_report_email.value2#"> 
<cfif IsDefined("form.report_email") is "True">
<cfif form.report_email is not "">
<cfset report_email = form.report_email>
</cfif></cfif> 

<cfparam name = "report_org" default = "#get_report_org.value2#"> 
<cfif IsDefined("form.report_org") is "True">
<cfif form.report_org is not "">
<cfset report_org = form.report_org>
</cfif></cfif> 

<cfparam name = "interval" default = "#get_interval.value2#"> 
<cfif IsDefined("form.interval") is "True">
<cfif form.interval is not "">
<cfset interval = form.interval>
</cfif></cfif> 

<cfparam name = "startdate" default = "#get_startdate.value2#"> 
<cfif IsDefined("form.startdate") is "True">
<cfif form.startdate is not "">
<cfset startdate = form.startdate>
</cfif></cfif> 

<cfparam name = "starttime" default = "#get_starttime.value2#"> 
<cfif IsDefined("form.starttime") is "True">
<cfif form.starttime is not "">
<cfset starttime = form.starttime>
</cfif></cfif> 


<cfif #show_action# is "edit">

<cfif #FailureReports# is "true">

<cfif #report_email# is not "">
<cfif isValid("email", report_email)> 
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m=1>
<!---- /CFIF isValid("email" --->
</cfif>

<cfelseif #report_email# is "">
<cfset step=0>
<cfset m=2>

<!---- /CFIF #report_email# is not "" --->
</cfif>

<cfif #step# is "1" and #report_org# is not "">
<cfset step=2>
<cfelseif #report_org# is "">
<cfset step=0>
<cfset m=4>

<!---- /CFIF #step# is "1" and #report_org# is not "" --->
</cfif>


<cfif #step# is "2" and #startdate# is not "">
<cfif isValid("date", startdate)>
<cfset step=3> 
<cfelse>
<cfset step=0>
<cfset m=5>

<!---- /CFIF isValid("date" --->
</cfif>

<cfelseif #step# is "2" and #startdate# is "">
<cfset step=0>
<cfset m=6>

<!---- /CFIF #step# is "2" and #startdate# --->
</cfif>


<cfif #step# is "3">

<cfquery name="updateFailureReports" datasource="#datasource#">
update parameters2 set 
value2='#FailureReports#',
applied='2'
where
parameter='FailureReports' and module = 'dmarc'
</cfquery>


<cfquery name="UpdateRejectFailures" datasource="#datasource#">
update parameters2 set 
value2='#RejectFailures#',
applied='2'
where
parameter='RejectFailures' and module = 'dmarc'
</cfquery>

<cfquery name="updatereport_email" datasource="#datasource#">
update parameters2 set 
value2='#report_email#',
applied='2'
where
parameter='report_email' and module = 'dmarc'
</cfquery>

<cfquery name="updatereport_org" datasource="#datasource#">
update parameters2 set 
value2='#report_org#',
applied='2'
where
parameter='report_org' and module = 'dmarc'
</cfquery>


<cfquery name="updateinterval" datasource="#datasource#">
update parameters2 set 
value2='#interval#',
applied='2'
where
parameter='interval' and module = 'dmarc'
</cfquery>

<cfquery name="updatestartdate" datasource="#datasource#">
update parameters2 set 
value2='#startdate#',
applied='2'
where
parameter='startdate' and module = 'dmarc'
</cfquery>



<cfquery name="updatestarttime" datasource="#datasource#">
update parameters2 set 
value2='#starttime#',
applied='2'
where
parameter='starttime' and module = 'dmarc'
</cfquery>



<cfset m=3>

<!--- /CFIF FOR STEP IS "3" --->
</cfif>

<cfelseif #FailureReports# is "false">

<cfquery name="UpdateRejectFailures" datasource="#datasource#">
update parameters2 set 
value2='#RejectFailures#',
applied='2'
where
parameter='RejectFailures' and module = 'dmarc'
</cfquery>

<cfquery name="updateFailureReports" datasource="#datasource#">
update parameters2 set 
value2='#FailureReports#',
applied='2'
where
parameter='FailureReports' and module = 'dmarc'
</cfquery>

<cfquery name="updatereport_email" datasource="#datasource#">
update parameters2 set 
value2='',
applied='2'
where
parameter='report_email' and module = 'dmarc'
</cfquery>

<cfquery name="updatereport_org" datasource="#datasource#">
update parameters2 set 
value2='',
applied='2'
where
parameter='report_org' and module = 'dmarc'
</cfquery>


<cfquery name="updateinterval" datasource="#datasource#">
update parameters2 set 
value2='daily',
applied='2'
where
parameter='interval' and module = 'dmarc'
</cfquery>

<cfquery name="updatestartdate" datasource="#datasource#">
update parameters2 set 
value2='',
applied='2'
where
parameter='startdate' and module = 'dmarc'
</cfquery>



<cfquery name="updatestarttime" datasource="#datasource#">
update parameters2 set 
value2='',
applied='2'
where
parameter='starttime' and module = 'dmarc'
</cfquery>

<cfset m=3>

<!---- /CFIF FOR #FailureReports# is "true" --->
</cfif>

<!---- /CFIF FOR ACTION --->
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="965" id="LayoutRegion11" style="height: 299px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="dmarc_form" action="dmarc_configuration.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 131px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1045">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Reject Failures</span></b></p>
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
                                                                        <p style="margin-bottom: 0px;"><cfif #RejectFailures# is "true">
<cfoutput>
<input type="radio" checked="checked" name="RejectFailures" value="true" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #RejectFailures# is not "true">
<cfoutput>
<input type="radio" name="RejectFailures" value="true" style="height: 13px; width: 13px;">
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
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Yes</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
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
                                                                        <p style="margin-bottom: 0px;"><cfif #RejectFailures# is "false">
<cfoutput>
<input type="radio" checked="checked" name="RejectFailures" value="false" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #RejectFailures# is not "false">
<cfoutput>
<input type="radio" name="RejectFailures" value="false" style="height: 13px; width: 13px;">
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
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">No</span></b></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Generate Failure Reports</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
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
                                                                        <p style="margin-bottom: 0px;"><cfif #FailureReports# is "true">
<cfoutput>
<input type="radio" checked="checked" name="FailureReports" value="true" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #FailureReports# is not "true">
<cfoutput>
<input type="radio" name="FailureReports" value="true" style="height: 13px; width: 13px;">
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
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Yes</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
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
                                                                        <p style="margin-bottom: 0px;"><cfif #FailureReports# is "false">
<cfoutput>
<input type="radio" checked="checked" name="FailureReports" value="false" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #FailureReports# is not "false">
<cfoutput>
<input type="radio" name="FailureReports" value="false" style="height: 13px; width: 13px;">
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
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">No</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Reports From Email Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1104">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="report_email" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#report_email#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1105">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Reporting Organization</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1106">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="report_org" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#report_org#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1107">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Reporting Frequency</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 41px;">
                                              <td id="Cell1108">
                                                <table width="613" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table127" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                                        <tr style="height: 17px;">
                                                          <td width="98" id="Cell1023">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Frequency</span></b></p>
                                                          </td>
                                                          <td width="50" id="Cell1046">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                          <td width="109" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Start Date</span></b></p>
                                                          </td>
                                                          <td width="356" id="Cell1021">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Start Time</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 24px;">
                                                          <td id="Cell768">
                                                            <table width="92" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #interval# is "daily">
<select id="FormsComboBox1" name="interval" style="height: 24px;">
    <option value="daily" selected="selected">Daily</option>
  <option value="weekly">Weekly</option>
  <option value="monthly">Monthly</option>
</select>

<cfelseif #interval# is "weekly">
<select id="FormsComboBox1" name="interval" style="height: 24px;">
    <option value="weekly" selected="selected">Weekly</option>
  <option value="daily">Daily</option>
  <option value="monthly">Monthly</option>
</select>

<cfelseif #interval# is "monthly">
<select id="FormsComboBox1" name="interval" style="height: 24px;">
    <option value="monthly" selected="selected">Monthly</option>
  <option value="daily">Daily</option>
  <option value="weekly">Weekly</option>
</select>
</cfif>&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1047">
                                                            <table width="45" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('dmarc_form',%20'startdate')"><img id="Picture49" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1019">
                                                            <table width="104" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="startdate" size="10" maxlength="10" style="width: 76px; white-space: pre;" value="#startdate#">
</cfoutput>&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1020">
                                                            <table width="150" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfset stime = CreateTime(01,0,0)> 
<cfset etime = CreateTime(24,45,0)>
 
<cfif #starttime# is "">
<select name="starttime" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<cfif #TimeFormat(i, "HH:mm:ss")# is "01:00:00" or #TimeFormat(i, "HH:mm:ss")# is "01:15:00" or #TimeFormat(i, "HH:mm:ss")# is "01:30:00" or #TimeFormat(i, "HH:mm:ss")# is "01:45:00" or #TimeFormat(i, "HH:mm:ss")# is "02:00:00" or #TimeFormat(i, "HH:mm:ss")# is "02:15:00" or #TimeFormat(i, "HH:mm:ss")# is "02:30:00" or #TimeFormat(i, "HH:mm:ss")# is "02:45:00" or #TimeFormat(i, "HH:mm:ss")# is "03:00:00" or #TimeFormat(i, "HH:mm:ss")# is "03:15:00" or #TimeFormat(i, "HH:mm:ss")# is "03:30:00" or #TimeFormat(i, "HH:mm:ss")# is "03:45:00" or #TimeFormat(i, "HH:mm:ss")# is "04:00:00">
<cfelse>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfif>
</cfoutput>
</cfloop>
</select>

<cfelseif #starttime# is not "">
<cfset starttime2=#TimeFormat(starttime, "hh:mm tt")#>
<select name="starttime" style="height: 22px;">
<cfoutput>
<option value="#starttime#" SELECTED>#starttime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<cfif #TimeFormat(i, "HH:mm:ss")# is "01:00:00" or #TimeFormat(i, "HH:mm:ss")# is "01:15:00" or #TimeFormat(i, "HH:mm:ss")# is "01:30:00" or #TimeFormat(i, "HH:mm:ss")# is "01:45:00" or #TimeFormat(i, "HH:mm:ss")# is "02:00:00" or #TimeFormat(i, "HH:mm:ss")# is "02:15:00" or #TimeFormat(i, "HH:mm:ss")# is "02:30:00" or #TimeFormat(i, "HH:mm:ss")# is "02:45:00" or #TimeFormat(i, "HH:mm:ss")# is "03:00:00" or #TimeFormat(i, "HH:mm:ss")# is "03:15:00" or #TimeFormat(i, "HH:mm:ss")# is "03:30:00" or #TimeFormat(i, "HH:mm:ss")# is "03:45:00" or #TimeFormat(i, "HH:mm:ss")# is "04:00:00">
<cfelse>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>
</cfif>
</cfoutput>
</cfloop>
</select>

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
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        <td width="956" height="16"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Reports From Email Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Reports from Email Address cannot be blank if you set Generate Failure Reports to Yes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Reporting Organization cannot be blank if you set Generate Failure Reports to Yes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Reporting Freqency Start Date must be a valid date in the form of mm/dd/yyyy</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Reporting Frequency Start Date cannot be blank if you set Generate Failure Reports to Yes</span></i></b></p>
</cfoutput>
</cfif>
&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="13"></td>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="957"><hr id="HRRule3" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
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

<cfquery name="get_FailureReports" datasource="#datasource#">
select value2 from parameters2 where parameter='FailureReports' and module = 'dmarc'
</cfquery>

<cfquery name="get_RejectFailures" datasource="#datasource#">
select value2 from parameters2 where parameter='RejectFailures' and module = 'dmarc'
</cfquery>

<cfquery name="get_interval" datasource="#datasource#">
select value2 from parameters2 where parameter='interval' and module = 'dmarc'
</cfquery>

<cfquery name="get_startdate" datasource="#datasource#">
select value2 from parameters2 where parameter='startdate' and module = 'dmarc'
</cfquery>

<cfquery name="get_starttime" datasource="#datasource#">
select value2 from parameters2 where parameter='starttime' and module = 'dmarc'
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



<!--- CONFIGURE OPENDMARC.CONF FILE BELOW --->

<cffile action="read" file="/opt/hermes/conf_files/opendmarc.conf.HERMES" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendmarc.conf.HERMES"
    output = "#REReplace("#dmarcfile#","FAILURE-REPORTS","#get_FailureReports.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_opendmarc.conf.HERMES" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_opendmarc.conf.HERMES"
    output = "#REReplace("#dmarcfile#","REJECT-FAILURES","#get_RejectFailures.value2#","ALL")#">
    
<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/opendmarc.conf /etc/opendmarc.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_opendmarc.conf.HERMES /etc/opendmarc.conf#chr(10)#"
addnewline="no">


<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/systemctl restart opendmarc#chr(10)#/bin/systemctl restart postfix"
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
    
<!--- CONFIGURE OPENDKIM.CONF FILE ABOVE --->

<!--- CONFIGURE DMARC_REPORT SCHEDULED TASK BELOW --->

<cfif #get_FailureReports.value2# is "true">

<cfset date1="#dateformat(get_startdate.value2, "yyyy-mm-dd")#">

<cfschedule action="update"
task="dmarc_report"
operation="HTTPRequest"
startdate="#date1#"
starttime="#get_starttime.value2#"
requesttimeout="7200"
url="http://dmarcfilehost:8888/schedule/dmarc_report.cfm"
interval="#get_interval.value2#">

<cfschedule
action = "resume"
task = "dmarc_report">


<cfelseif #get_FailureReports.value2# is "false">

<cfschedule
action = "pause"
task = "dmarc_report">

<!--- /CFIF #get_FailureReports.value2# is --->
</cfif>
    
    
<!--- CONFIGURE DMARC_REPORT SCHEDULED TASK ABOVE --->
    
<cfquery name="completedmarc" datasource="#datasource#">
update parameters2 set applied='1' where module = 'dmarc'
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
                                        <form name="apply_settings" action="dmarc_configuration.cfm" method="post">
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
select * from parameters2 where module='dmarc' and applied='2'
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