<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>System Settings</title>
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
              <td height="769" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 769px;">
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
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">System Settings</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/system-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="11" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="615"></td>
                          <td width="957"><cfparam name = "m" default = "0"> 

<cfparam name = "m4" default = "0"> 

<cfparam name = "m5" default = "0"> 
<cfif IsDefined("url.m5") is "True">
<cfif url.m5 is not "">
<cfset m5 = url.m5>
</cfif></cfif>

<!--- IF WIZARD IS SET TO 2 DISPLAY M4=1 ERROR MESSAGE ---> 
<cfquery name="checkwizard" datasource="#datasource#">
select parameter, value from system_settings where parameter='wizard_settings'
</cfquery>

<cfif #checkwizard.value# is "2">
<cfset m4=1>

<!--- /CFIF #checkwizard.value# is not ---> 
</cfif>

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

<!-- /CFIF #authkey# is "" -->
</cfif>


<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfquery name="get_admin_email" datasource="#datasource#">
select parameter, value from system_settings where parameter='admin_email'
</cfquery>

<cfquery name="get_postmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfquery name="get_mysql_username_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_hermes'
</cfquery>

<cfquery name="get_mysql_password_hermes" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_hermes'
</cfquery>

<cfif #get_mysql_password_hermes.value# is not "">

<cfset mysqlpasswordhermes=decrypt(get_mysql_password_hermes.value, #authkey#, #algo#, #encoding#)>

<cfelseif #get_mysql_password_hermes.value# is "">

<cfset mysqlpasswordhermes="">

</cfif>


<cfquery name="get_mysql_username_djigzo" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_djigzo'
</cfquery>

<cfquery name="get_mysql_password_djigzo" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_djigzo'
</cfquery>

<cfif #get_mysql_password_djigzo.value# is not "">

<cfset mysqlpassworddjigzo=decrypt(get_mysql_password_djigzo.value, #authkey#, #algo#, #encoding#)>

<cfelseif #get_mysql_password_djigzo.value# is "">

<cfset mysqlpassworddjigzo="">

</cfif>

<cfquery name="get_mysql_username_syslog" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_syslog'
</cfquery>

<cfquery name="get_mysql_password_syslog" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_syslog'
</cfquery>

<cfif #get_mysql_password_syslog.value# is not "">

<cfset mysqlpasswordsyslog=decrypt(get_mysql_password_syslog.value, #authkey#, #algo#, #encoding#)>

<cfelseif #get_mysql_password_syslog.value# is "">

<cfset mysqlpasswordsyslog="">

</cfif>

<cfquery name="get_mysql_username_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_opendmarc'
</cfquery>

<cfquery name="get_mysql_password_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_opendmarc'
</cfquery>

<cfif #get_mysql_password_opendmarc.value# is not "">

<cfset mysqlpasswordopendmarc=decrypt(get_mysql_password_opendmarc.value, #authkey#, #algo#, #encoding#)>

<cfelseif #get_mysql_password_opendmarc.value# is "">

<cfset mysqlpasswordopendmarc="">

</cfif>

<cfquery name="get_serial" datasource="#datasource#">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cfquery name="get_accepted" datasource="#datasource#">
select parameter, value from system_settings where parameter='accepted'
</cfquery>

<cfquery name="get_users" datasource="#datasource#">
select parameter, value from system_settings where parameter='users'
</cfquery>

<cfparam name = "show_admin_email" default = "#get_admin_email.value#"> 
<cfif IsDefined("form.admin_email") is "True">
<cfif form.admin_email is not "">
<cfset show_admin_email = form.admin_email>
</cfif></cfif> 

<cfparam name = "show_postmaster" default = "#get_postmaster.value#"> 
<cfif IsDefined("form.postmaster") is "True">
<cfif form.postmaster is not "">
<cfset show_postmaster = form.postmaster>
</cfif></cfif>

<cfparam name = "show_mysql_username_hermes" default = "#get_mysql_username_hermes.value#"> 
<cfif IsDefined("form.mysql_username_hermes") is "True">
<cfif form.mysql_username_hermes is not "">
<cfset show_mysql_username_hermes = form.mysql_username_hermes>
</cfif></cfif>

<cfparam name = "show_mysql_password_hermes" default = "#mysqlpasswordhermes#"> 
<cfif IsDefined("form.mysql_password_hermes") is "True">
<cfif form.mysql_password_hermes is not "">
<cfset show_mysql_password_hermes = form.mysql_password_hermes>
</cfif></cfif>

<cfparam name = "show_mysql_username_djigzo" default = "#get_mysql_username_djigzo.value#"> 
<cfif IsDefined("form.mysql_username_djigzo") is "True">
<cfif form.mysql_username_djigzo is not "">
<cfset show_mysql_username_djigzo = form.mysql_username_djigzo>
</cfif></cfif>

<cfparam name = "show_mysql_password_djigzo" default = "#mysqlpassworddjigzo#"> 
<cfif IsDefined("form.mysql_password_djigzo") is "True">
<cfif form.mysql_password_djigzo is not "">
<cfset show_mysql_password_djigzo = form.mysql_password_djigzo>
</cfif></cfif>

<cfparam name = "show_mysql_username_syslog" default = "#get_mysql_username_syslog.value#"> 
<cfif IsDefined("form.mysql_username_syslog") is "True">
<cfif form.mysql_username_syslog is not "">
<cfset show_mysql_username_syslog = form.mysql_username_syslog>
</cfif></cfif>

<cfparam name = "show_mysql_password_syslog" default = "#mysqlpasswordsyslog#"> 
<cfif IsDefined("form.mysql_password_syslog") is "True">
<cfif form.mysql_password_syslog is not "">
<cfset show_mysql_password_syslog = form.mysql_password_syslog>
</cfif></cfif>

<cfparam name = "show_mysql_username_opendmarc" default = "#get_mysql_username_opendmarc.value#"> 
<cfif IsDefined("form.mysql_username_opendmarc") is "True">
<cfif form.mysql_username_opendmarc is not "">
<cfset show_mysql_username_opendmarc = form.mysql_username_opendmarc>
</cfif></cfif>

<cfparam name = "show_mysql_password_opendmarc" default = "#mysqlpasswordopendmarc#"> 
<cfif IsDefined("form.mysql_password_opendmarc") is "True">
<cfif form.mysql_password_opendmarc is not "">
<cfset show_mysql_password_opendmarc = form.mysql_password_opendmarc>
</cfif></cfif>

<cfparam name = "serial" default = "#get_serial.value#"> 

<cfparam name = "show_users" default = "#get_users.value#"> 

<cfparam name = "accepted" default = "#get_accepted.value#"> 

<cfif #action# is "edit">
<cfif #show_postmaster# is not "">
<cfif IsValid("email", show_postmaster)>
<cfset domainpart = #trim(ListGetAt(show_postmaster, 2, "@"))#>
<cfquery name="checkdomain" datasource="#datasource#">
select domain from domains where domain='#domainpart#'
</cfquery>
<cfif #checkdomain.recordcount# GTE 1>
<cfset step=1>
<cfelseif #checkdomain.recordcount# LT 1>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif not IsValid("email", show_postmaster)>
<cfset step=0>
<cfset m=5>
</cfif>
<cfelseif #show_postmaster# is "">
<cfset step=0>
<cfset m=6>
</cfif>
</cfif>
 


<cfif #step# is "1">
<cfif #show_admin_email# is not "">
<cfif IsValid("email", show_admin_email)>
<cfset step=2>
<cfelseif not IsValid("email", show_admin_email)>
<cfset step=0>
<cfset m=2>
</cfif>
<cfelseif #show_admin_email# is "">
<cfset step=0>
<cfset m=3>
</cfif>

<cfif #step# is "2">
<cfif #show_mysql_username_hermes# is "">
<cfset step=0>
<cfset m=13>
<cfelseif #show_mysql_username_hermes# is not "">
<cfset step=3>
</cfif>
</cfif>

<cfif #step# is "3">
<cfif #show_mysql_password_hermes# is "">
<cfset step=0>
<cfset m=14>
<cfelseif #show_mysql_password_hermes# is not "">
<cfset step=4>
</cfif>
</cfif>

<cfif #step# is "4">
<cfif #show_mysql_username_djigzo# is "">
<cfset step=0>
<cfset m=17>
<cfelseif #show_mysql_username_djigzo# is not "">
<cfset step=5>
</cfif>
</cfif>

<cfif #step# is "5">
<cfif #show_mysql_password_djigzo# is "">
<cfset step=0>
<cfset m=18>
<cfelseif #show_mysql_password_djigzo# is not "">
<cfset step=6>
</cfif>
</cfif>

<cfif #step# is "6">
<cfif #show_mysql_username_syslog# is "">
<cfset step=0>
<cfset m=19>
<cfelseif #show_mysql_username_syslog# is not "">
<cfset step=7>
</cfif>
</cfif>

<cfif #step# is "7">
<cfif #show_mysql_password_syslog# is "">
<cfset step=0>
<cfset m=20>
<cfelseif #show_mysql_password_syslog# is not "">
<cfset step=8>
</cfif>
</cfif>

<cfif #step# is "8">
<cfif #show_mysql_username_opendmarc# is "">
<cfset step=0>
<cfset m=23>
<cfelseif #show_mysql_username_opendmarc# is not "">
<cfset step=9>
</cfif>
</cfif>

<cfif #step# is "9">
<cfif #show_mysql_password_opendmarc# is "">
<cfset step=0>
<cfset m=24>
<cfelseif #show_mysql_password_opendmarc# is not "">
<cfset step=10>
</cfif>
</cfif>


<cfif #step# is "10">

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
    output = "#REReplace("#validatemysql#","MYSQLUSER","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#show_mysql_password_hermes#","ALL")#"> 


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
<cfset m=15>
<cfset step=0>
<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>
<cfset step=11>
</cftry>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#">

<!-- /CFIF for step -->
</cfif>


<cfif #step# is "11">

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
    output = "#REReplace("#validatemysql#","MYSQLUSER","#show_mysql_username_djigzo#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#show_mysql_password_djigzo#","ALL")#"> 


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
<cfset m=16>
<cfset step=0>
<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>
<cfset step=12>
</cftry>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#">

<!-- /CFIF for step -->
</cfif>


<cfif #step# is "12">

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
    output = "#REReplace("#validatemysql#","MYSQLUSER","#show_mysql_username_syslog#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#show_mysql_password_syslog#","ALL")#"> 


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
<cfset m=21>
<cfset step=0>
<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>
<cfset step=13>
</cftry>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#">

<!-- /CFIF for step -->
</cfif>


<cfif #step# is "13">

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
    output = "#REReplace("#validatemysql#","MYSQLUSER","#show_mysql_username_opendmarc#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    output = "#REReplace("#validatemysql#","MYSQLPASS","#show_mysql_password_opendmarc#","ALL")#"> 


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
<cfset m=25>
<cfset step=0>
<!-- /CFIF cfcatch.detail -->
</cfif>
</cfcatch>
<cfset step=14>
</cftry>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/validate_mysql_#customtrans3#">

<!-- /CFIF for step -->
</cfif>

<cfif #step# is "14">

<cftry>
<cfset encrypted_mysql_password_hermes=encrypt(show_mysql_password_hermes, #authkey#, #algo#, #encoding#)>

<cfcatch type="any">

<cfif FindNoCase("Illegal key size", cfcatch.Message)>
<cfset step=0>
<cfset m=22>

<!--- <cfdump var="#cfcatch#" abort /> --->


<!--- /CFIF FindNoCase --->
</cfif>

</cfcatch>

<cfquery name="update3" datasource="#datasource#">
update system_settings set value='#show_mysql_username_hermes#' where parameter='mysql_username_hermes'
</cfquery>

<cfquery name="update4" datasource="#datasource#">
update system_settings set value='#encrypted_mysql_password_hermes#' where parameter='mysql_password_hermes'
</cfquery>

<cfset step=15>

</cftry>

<!--- /CFIF step is 14 --->
</cfif>


<cfif #step# is "15">

<cftry>
<cfset encrypted_mysql_password_djigzo=encrypt(show_mysql_password_djigzo, #authkey#, #algo#, #encoding#)>

<cfcatch type="any">

<cfif FindNoCase("Illegal key size", cfcatch.Message)>
<cfset step=0>
<cfset m=22>

<!--- <cfdump var="#cfcatch#" abort /> --->


<!--- /CFIF FindNoCase --->
</cfif>

</cfcatch>

<cfquery name="update5" datasource="#datasource#">
update system_settings set value='#show_mysql_username_djigzo#' where parameter='mysql_username_djigzo'
</cfquery>

<cfquery name="update6" datasource="#datasource#">
update system_settings set value='#encrypted_mysql_password_djigzo#' where parameter='mysql_password_djigzo'
</cfquery>

<cfset step=16>

</cftry>

<!--- /CFIF step is 15 --->
</cfif>


<cfif #step# is "16">

<cftry>
<cfset encrypted_mysql_password_syslog=encrypt(show_mysql_password_syslog, #authkey#, #algo#, #encoding#)>

<cfcatch type="any">

<cfif FindNoCase("Illegal key size", cfcatch.Message)>
<cfset step=0>
<cfset m=22>

<!--- <cfdump var="#cfcatch#" abort /> --->

<!--- /CFIF FindNoCase --->
</cfif>

</cfcatch>

<cfquery name="update7" datasource="#datasource#">
update system_settings set value='#show_mysql_username_syslog#' where parameter='mysql_username_syslog'
</cfquery>

<cfquery name="update8" datasource="#datasource#">
update system_settings set value='#encrypted_mysql_password_syslog#' where parameter='mysql_password_syslog'
</cfquery>


<cfset step=17>

</cftry>

<!--- /CFIF step is 16 --->
</cfif>

<cfif #step# is "17">

<cftry>
<cfset encrypted_mysql_password_opendmarc=encrypt(show_mysql_password_opendmarc, #authkey#, #algo#, #encoding#)>

<cfcatch type="any">

<cfif FindNoCase("Illegal key size", cfcatch.Message)>
<cfset step=0>
<cfset m=22>

<!--- <cfdump var="#cfcatch#" abort /> --->

<!--- /CFIF FindNoCase --->
</cfif>

</cfcatch>

<cfquery name="update9" datasource="#datasource#">
update system_settings set value='#show_mysql_username_opendmarc#' where parameter='mysql_username_opendmarc'
</cfquery>

<cfquery name="update10" datasource="#datasource#">
update system_settings set value='#encrypted_mysql_password_opendmarc#' where parameter='mysql_password_opendmarc'
</cfquery>


<cfset step=18>

</cftry>

<!--- /CFIF step is 17 --->
</cfif>




<cfif #step# is "18">

<cfquery name="update" datasource="#datasource#">
update system_settings set value='#show_admin_email#' where parameter='admin_email'
</cfquery>

<cfquery name="update2" datasource="#datasource#">
update system_settings set value='#show_postmaster#' where parameter='postmaster'
</cfquery>

<cfquery name="update9" datasource="#datasource#">
update system_settings set value='1' where parameter='wizard_settings'
</cfquery>


<cfquery name="checkpostmaster" datasource="#datasource#">
delete from virtual_recipients where system='1'
</cfquery>

<cfquery name="checkpostmaster" datasource="#datasource#">
delete from virtual_recipients where virtual_address='#show_postmaster#' and maps='#show_admin_email#'
</cfquery>

<cfquery name="insertpostmaster" datasource="#datasource#">
insert into virtual_recipients
(virtual_address, maps, system)
values
('#show_postmaster#', '#show_admin_email#', '1')
</cfquery>


<cfset domainpart = #trim(ListGetAt(show_postmaster, 2, "@"))#>


<cfquery name="checkroot" datasource="#datasource#">
delete from virtual_recipients where virtual_address='root@#domainpart#' and maps='#show_admin_email#'
</cfquery>

<cfquery name="insertroot" datasource="#datasource#">
insert into virtual_recipients
(virtual_address, maps, system)
values
('root@#domainpart#', '#show_admin_email#', '1')
</cfquery>


<cfquery name="checkabuse" datasource="#datasource#">
delete from virtual_recipients where virtual_address='abuse@#domainpart#' and maps='#show_admin_email#'
</cfquery>

<cfquery name="insertabuse" datasource="#datasource#">
insert into virtual_recipients
(virtual_address, maps, system)
values
('abuse@#domainpart#', '#show_admin_email#', '1')
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

<!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES STARTS HERE -->

<!-- MODIFY mysql-aliases.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-aliases.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
<!-- MODIFY mysql-clients.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-clients.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-domains.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-domains.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
<!-- MODIFY mysql-rbl_override.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-rbl_override.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-recipients.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-recipients.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-senders.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-senders.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
    
<!-- MODIFY mysql-transport.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-transport.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
<!-- MODIFY mysql-virtual.cf -->

<cffile action="read" file="/opt/hermes/conf_files/mysql-virtual.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
    output = "#REReplace("#postfix#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf"
    output = "#REReplace("#postfix#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#"> 
    
<!-- MODIFY POSTFIX MYSQL USERNAME AND PASSWORD CONFIG FILES ENDS HERE -->

<!-- MODIFY DJIGZO MYSQL CONFIG STARTS HERE -->

<cffile action="read" file="/opt/hermes/conf_files/hibernate.mysql.connection.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
    output = "#REReplace("#postfix#","DJIGZO-USERNAME","#show_mysql_username_djigzo#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml"
    output = "#REReplace("#postfix#","DJIGZO-PASSWORD","#show_mysql_password_djigzo#","ALL")#"> 

<!-- MODIFY DJIGZO MYSQL CONFIG ENDS HERE -->

<!-- MODIFY RSYSLOG MYSQL CONFIG STARTS HERE -->

<cffile action="read" file="/opt/hermes/conf_files/mysql.HERMES" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
    output = "#REReplace("#postfix#","SYSLOG-USERNAME","#show_mysql_username_syslog#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mysql.conf" variable="postfix">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mysql.conf"
    output = "#REReplace("#postfix#","SYSLOG-PASSWORD","#show_mysql_password_syslog#","ALL")#"> 

<!-- MODIFY RSYSLOG MYSQL CONFIG ENDS HERE -->

<!--- GET /etc/amavis/conf.d/50-user PARAMETERS --->

<cfquery name="server_name" datasource="#datasource#">
select * from parameters2 where parameter='server_name' and module='network' and active='1'
</cfquery>

<cfquery name="server_domain" datasource="#datasource#">
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
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

<!--- MODIFY /etc/amavis/conf.d/50-user STARTS HERE --->

<cffile action="read" file="/opt/hermes/conf_files/50-user.HERMES" variable="user">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-NAME","#server_name.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","SERVER-DOMAIN","#server_domain.value2#","ALL")#">

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
    output = "#REReplace("#user#","HERMES-USERNAME","#show_mysql_username_hermes#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-user" variable="user">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-user"
    output = "#REReplace("#user#","HERMES-PASSWORD","#show_mysql_password_hermes#","ALL")#">

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

<!--- MODIFY /etc/amavis/conf.d/50-user ENDS HERE --->

<!-- MAKE BACKUPS OF MYSQL CONFIG FILES STARTS HERE -->

<cffile action = "copy" source = "/etc/postfix/mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-clients.cf" destination = "/etc/postfix/mysql-clients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-domains.cf" destination = "/etc/postfix/mysql-domains.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-senders.cf" destination = "/etc/postfix/mysql-senders.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-transport.cf" destination = "/etc/postfix/mysql-transport.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/postfix/mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.HERMES.BACKUP">
<cffile action = "copy" source = "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml" destination =
 "/usr/share/djigzo/conf/database/hibernate.mysql.connection.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/rsyslog.d/mysql.conf" destination = "/etc/rsyslog.d/mysql.HERMES.BACKUP">
<cffile action = "copy" source = "/etc/amavis/conf.d/50-user" destination = "/etc/amavis/conf.d/50-user.HERMES.BACKUP">

<!-- MAKE BACKUPS OF MYSQL CONFIG FILES ENDS HERE -->

<!-- COPY MYSQL CONFIG FILES TO APPROPRIATE LOCATIONS STARTS HERE -->

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf" destination = "/etc/postfix/mysql-aliases.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-aliases.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-clients.cf" destination = "/etc/postfix/mysql-clients.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-clients.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-clients.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-domains.cf" destination = "/etc/postfix/mysql-domains.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-domains.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-domains.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf" destination = "/etc/postfix/mysql-rbl_override.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-rbl_override.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf" destination = "/etc/postfix/mysql-recipients.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-recipients.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-senders.cf" destination = "/etc/postfix/mysql-senders.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-senders.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-senders.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-transport.cf" destination = "/etc/postfix/mysql-transport.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-transport.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-transport.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf" destination = "/etc/postfix/mysql-virtual.cf">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql-virtual.cf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml" destination =
 "/usr/share/djigzo/conf/database/hibernate.mysql.connection.xml">
 
 <cfif FileExists("/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_hibernate.mysql.connection.xml">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#_mysql.conf" destination = "/etc/rsyslog.d/mysql.conf">

 <cfif FileExists("/opt/hermes/tmp/#customtrans3#_mysql.conf")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_mysql.conf">
</cfif>

<cffile action = "copy" source = "/opt/hermes/tmp/#customtrans3#50-user" destination = "/etc/amavis/conf.d/50-user">

 <cfif FileExists("/opt/hermes/tmp/#customtrans3#50-user")>
<cffile action="delete" file="/opt/hermes/tmp/#customtrans3#50-user">
</cfif>



<!-- COPY MYSQL CONFIG FILES TO APPROPRIATE LOCATIONS ENDS HERE -->

<cfset m=7>
<cfset m4=0>

<!--- CFIF STEP 18--->
</cfif>
<!--- CFIF ACTION --->
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 615px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="<cfoutput>system_settings.cfm</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table160" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 452px;">
                                            <tr style="height: 14px;">
                                              <td width="949" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Postmaster E-mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span></b>
                                                  <table width="600" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td><cfoutput><input type="text" id="FormsEditField57" name="postmaster" size="75" maxlength="75" style="width: 596px; white-space: pre;" value="#show_postmaster#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Admin E-mail Address (Recommended to be set to an email address outside of this system)</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="text" id="FormsEditField42" name="admin_email" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_admin_email#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL Hermes Database Username</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1051">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="text" id="FormsEditField59" name="mysql_username_hermes" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_mysql_username_hermes#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1052">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL Hermes Database Password</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1053">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="password" id="FormsEditField60" name="mysql_password_hermes" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_mysql_password_hermes#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1054">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL Ciphermail Database Username</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1055">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="text" id="FormsEditField61" name="mysql_username_djigzo" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_mysql_username_djigzo#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1056">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL Ciphermail Database Password</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1057">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="password" id="FormsEditField62" name="mysql_password_djigzo" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_mysql_password_djigzo#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1058">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL SysLog Database Username </span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1059">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="text" id="FormsEditField63" name="mysql_username_syslog" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_mysql_username_syslog#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1060">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL SysLog Database Password</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1061">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="password" id="FormsEditField64" name="mysql_password_syslog" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_mysql_password_syslog#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1109">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL OpenDMARC Database Username</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1110">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="text" id="FormsEditField65" name="mysql_username_opendmarc" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="#show_mysql_username_opendmarc#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1111">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">MySQL OpenDMARC Database Password</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1112">
                                                    <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><cfoutput><input type="password" id="FormsEditField66" name="mysql_password_opendmarc" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="#show_mysql_password_opendmarc#"></cfoutput></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell912">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Serial Number</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1063">
                                                    <table width="353" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="serial" size="75" maxlength="20" value="#serial#" disabled="disabled">
</cfoutput>
&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1064">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Number of Licensed Users</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell1065">
                                                    <table width="353" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="show_users" size="75" maxlength="20" value="#show_users#" disabled="disabled">
</cfoutput>
&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr style="height: 17px;">
                                                  <td id="Cell1019">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td align="center">
                                                          <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="text-align: center; margin-bottom: 0px;"><cfif #accepted# is "">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
<cfelseif #accepted# is "1">
<input type="hidden" name="tos" value="1">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="957">
                                          <tr valign="top" align="left">
                                            <td width="957" height="37"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="957" id="Text185" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must be part of a domain that this system does NOT relay</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Admin E-mail Address must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must be part of a domain that this system relays</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings updated</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must accept the License Agreement</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you have entered an invalid Serial Number</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the serial number cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon1">&nbsp;the Serial Number you entered is invalid. Please obtain a new Serial Number from support@deeztek.com and try again. <br><br>IMPORTANT: You MUST have Internet Access in order to activate your serial number. Please goto System>>Network Settings and verify your network settings before attempting to activate a serial number. If you need to restore you system, goto to System --> System Restore</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Hermes Database Username must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Hermes Database Password must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "15">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Credentials you entered are invalid. Please verify MySQL Hermes Database Username and MySQL Hermes Database Password and try again </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Credentials you entered are invalid. Please verify MySQL Djigzo Database Username and MySQL Djigzo Database Password and try again </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Djigzo Database Username must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Djigzo Database Password must not be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Syslog Database Username must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "20">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Syslog Database Password must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "21">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Credentials you entered are invalid. Please verify MySQL Syslog Database Username and MySQL Syslog Database Password and try again </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "22">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;Unable to save the settings because the sytem doesn't have the Java JCE Unlimited Strength Policy Jars. Please follow the instructions on <a href="http://www.deeztek.com/documentation/hermes-seg-documentation/hermes-secure-email-gateway-general-documentation/install-java-jce-unlimited-strength-jurisdiction-policy-files/">how to install the Unlimited Strength Policy Jars on Hermes SEG</a> and try again.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "23">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL OpenDMARC Database Username must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "24">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL OpenDMARC Database Password must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "25">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The MySQL Credentials you entered are invalid. Please verify MySQL OpenDMARC Database Username and MySQL Syslog Database Password and try again </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;You must set and save the parameters in this page before you will be allowed to configure the rest of the system. </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m5# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Serial Number Updated!</span></i></b></p>
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
                          <table border="0" cellspacing="0" cellpadding="0" width="967">
                            <tr valign="top" align="left">
                              <td width="11" height="1"></td>
                              <td></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td height="30"></td>
                              <td valign="middle" width="956"><hr id="HRRule1" width="956" size="1"></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td colspan="2" height="2"></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td height="45"></td>
                              <td width="956">

                                <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion13" style="height: 45px;">
                                  <tr align="left" valign="top">
                                    <td>
                                      <table border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top" align="left">
                                          <td height="9"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="956">
                                            <form name="new_serial" action="new_serial.cfm" method="post">
                                              <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                <tr style="height: 24px;">
                                                  <td width="956" id="Cell753">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td align="center">
                                                          <table width="204" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="text-align: center; margin-bottom: 0px;"><input type="submit" value="Enter Serial Number" style="height: 24px; width: 142px;">

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