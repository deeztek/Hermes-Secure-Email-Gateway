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
<title>CA Settings</title>
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
              <td height="705" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 705px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="518">
                              <tr valign="top" align="left">
                                <td width="12" height="11"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Internal Certificate Authority</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="5"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text483" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="color: rgb(0,51,153);"><span style="font-size: 12px;">Add Internal Certificate Authority</span></span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="452">
                              <tr valign="top" align="left">
                                <td width="427" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/internal-certificate-authority/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="11" height="4"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="437"></td>
                          <td width="956"><cfparam name = "m" default = "0">

<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 



<cfparam name = "show_encryption" default = "4096"> 
<cfif IsDefined("form.encryption") is "True">
<cfif form.encryption is not "">
<cfset show_encryption = form.encryption>
</cfif></cfif>

<cfparam name = "show_validity" default = "1825"> 
<cfif IsDefined("form.validity") is "True">
<cfif form.validity is not "">
<cfset show_validity = form.validity>
</cfif></cfif>

<cfparam name = "show_algorithm" default = ""> 
<cfif IsDefined("form.algorithm") is "True">
<cfif form.algorithm is not "">
<cfset show_algorithm = form.algorithm>
</cfif></cfif>

<cfparam name = "show_ca_commonname" default = ""> 
<cfif IsDefined("form.ca_commonname") is "True">
<cfif form.ca_commonname is not "">
<cfset show_ca_commonname = form.ca_commonname>
</cfif></cfif>

<cfparam name = "show_ca_email" default = ""> 
<cfif IsDefined("form.ca_email") is "True">
<cfif form.ca_email is not "">
<cfset show_ca_email = form.ca_email>
</cfif></cfif>

<cfparam name = "show_subca_commonname" default = ""> 
<cfif IsDefined("form.subca_commonname") is "True">
<cfif form.subca_commonname is not "">
<cfset show_subca_commonname = form.subca_commonname>
</cfif></cfif>

<cfparam name = "show_subca_email" default = ""> 
<cfif IsDefined("form.subca_email") is "True">
<cfif form.subca_email is not "">
<cfset show_subca_email = form.subca_email>
</cfif></cfif>

<cfparam name = "show_organizationname" default = ""> 
<cfif IsDefined("form.organizationname") is "True">
<cfif form.organizationname is not "">
<cfset show_organizationname = form.organizationname>
</cfif></cfif>

<cfparam name = "show_unitname" default = ""> 
<cfif IsDefined("form.unitname") is "True">
<cfif form.unitname is not "">
<cfset show_unitname = form.unitname>
</cfif></cfif>

<cfparam name = "show_stateprovincename" default = ""> 
<cfif IsDefined("form.stateprovincename") is "True">
<cfif form.stateprovincename is not "">
<cfset show_stateprovincename = form.stateprovincename>
</cfif></cfif>

<cfparam name = "show_countryname" default = ""> 
<cfif IsDefined("form.countryname") is "True">
<cfif form.countryname is not "">
<cfset show_countryname = form.countryname>
</cfif></cfif>

<cfparam name = "show_default" default = ""> 
<cfif IsDefined("form.default") is "True">
<cfif form.default is not "">
<cfset show_default = form.default>
</cfif></cfif>



<cfif #show_ca_commonname# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_ca_commonname# is not "">
<cfif REFind("[^a-zA-Z0-9 ]",show_ca_commonname) gt 0>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfset step=1>
</cfif>
</cfif>


<cfif step is "1" and #show_organizationname# is "">
<cfset step=0>
<cfset m=9>
<cfelseif step is "1" and #show_organizationname# is not "">
<cfif REFind("[^a-zA-Z0-9, ]",show_organizationname) gt 0>
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset step=2>
</cfif>
</cfif>


<cfif step is "2" and #show_unitname# is "">
<cfset step=0>
<cfset m=11>
<cfelseif step is "2" and #show_unitname# is not "">
<cfif REFind("[^_a-zA-Z0-9 ]",show_unitname) gt 0>
<cfset step=0>
<cfset m=12>
<cfelse>
<cfset step=3>
</cfif>
</cfif>


<cfif step is "3" and #show_stateprovincename# is "">
<cfset step=0>
<cfset m=13>
<cfelseif step is "3" and #show_stateprovincename# is not "">
<cfif REFind("[^a-zA-Z]",show_stateprovincename) gt 0>
<cfset step=0>
<cfset m=14>
<cfelse>
<cfset step=4>
</cfif>
</cfif>

<cfif step is "4" and #show_countryname# is "">
<cfset step=0>
<cfset m=15>
<cfelseif step is "4" and #show_countryname# is not "">
<cfif REFind("[^a-zA-Z]",show_countryname) gt 0>
<cfset step=0>
<cfset m=16>
<cfelse>
<cfset step=5>
</cfif>
</cfif>

<cfif step is "5">
<cfquery name="checkca" datasource="#datasource#">
select * from ca_settings where ca_commonname='#show_ca_commonname#'
</cfquery>

<cfif #checkca.recordcount# LT 1>
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset certexpires = DateAdd('d', #show_validity#, #datenow#)>
<cfset certexpires =#DateFormat(certexpires,"yyyy-mm-dd")#>

<cfif #show_default# is "1">
<cfset default=1>
<cfquery name="reset" datasource="#datasource#">
update ca_settings set default2='2'
</cfquery>

<cfelseif #show_default# is "">
<cfset default=2>
</cfif>

<cfset ca_directory = rereplace(show_ca_commonname, "[^A-Za-z0-9]+", "", "all")>

<cfquery name="insertca" datasource="#datasource#" result="caResult">
insert into ca_settings 
(
validity, 
encryption, 
ca_commonname, 
organizationname, 
unitname, 
stateprovincename, 
countryname,
applied,
expires,
default2,
ca_directory)
values
(
'#show_validity#', 
'#show_encryption#', 
'#show_ca_commonname#', 
'#show_organizationname#', 
'#show_unitname#', 
'#show_stateprovincename#', 
'#show_countryname#',
'2',
'#certexpires#',
'#default#',
'#ca_directory#')
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

<cfquery name="clearcerttmp" datasource="djigzo">
delete from cm_certificates_tmp
</cfquery>

<cfquery name="copycerts" datasource="djigzo">
INSERT INTO cm_certificates_tmp SELECT * FROM cm_certificates
</cfquery>

<cffile action="read" file="/opt/hermes/scripts/create_ca.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-ENCRYPTION","#show_encryption#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-VALIDITY","#show_validity#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-COUNTRYNAME","#show_countryname#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-STATEPROVINCENAME","#show_stateprovincename#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-ORGANIZATIONNAME","#show_organizationname#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-UNITNAME","#show_unitname#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","SHOW-CA-COMMONNAME","#show_ca_commonname#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
    output = "#REReplace("#temp#","CA-DIRECTORY","#ca_directory#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/templates/rootca_openssl.cnf" variable="openssl">

<cffile action = "write"
    file = "/opt/hermes/templates/#customtrans3#_rootca_openssl.cnf"
    output = "#REReplace("#openssl#","CA-DIRECTORY","#ca_directory#","ALL")#" addnewline="no">
    
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_create_ca.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_create_ca.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>




<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_create_ca.sh">

    
<cfquery name="getnewcert" datasource="djigzo">
SELECT * FROM cm_certificates WHERE cm_thumbprint NOT IN (SELECT cm_thumbprint FROM cm_certificates_tmp)
</cfquery>

<cfif #getnewcert.recordcount# LT 1>
<cfset step=0>
<cfset m=19>

<cfelseif #getnewcert.recordcount# EQ 1>

<cfquery name="setroot" datasource="djigzo">
update cm_certificates set cm_store_name='roots' where cm_id='#getnewcert.cm_id#'
</cfquery>

<cfquery name="checkthumb" datasource="djigzo">
select cm_thumbprint from cm_ctl where cm_thumbprint = '#getnewcert.cm_thumbprint#'
</cfquery>

<cfif #checkthumb.recordcount# LT 1>

<cfquery name="getmax" datasource="djigzo">
SELECT max(cm_id) as maxid FROM cm_ctl
</cfquery>

<cfif #getmax.maxid# is "">
<cfset maxid2=0>
<cfset nextid=#maxid2#+1>
<cfelseif #getmax.maxid# is not "">
<cfset nextid=#getmax.maxid#+1>
</cfif>

<cfquery name="insertctl" datasource="djigzo">
insert into cm_ctl (cm_id, cm_name, cm_thumbprint) values ('#nextid#', 'global', '#getnewcert.cm_thumbprint#')
</cfquery>

<cfquery name="insertctlnamewhitelisted" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'whitelisted', 'status')
</cfquery>

<cfquery name="insertctlnameexpired" datasource="djigzo">
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'false', 'allowExpired')
</cfquery>

<cfquery name="updatedjigzoproperties" datasource="#datasource#">
update ca_settings set ca_djigzo_id='#getnewcert.cm_id#', ca_djigzo_subject='CN=#show_ca_commonname#, OU=#show_organizationname#, O=#show_unitname#, ST=#show_stateprovincename#, C=#show_countryname#' where id='#caResult.GENERATED_KEY#'
</cfquery>
</cfif>

<cfquery name="clearcerttmp" datasource="djigzo">
delete from cm_certificates_tmp
</cfquery>

<cfset m=17>

<cfset show_ca_commonname=""> 
<cfset show_organizationname=""> 
<cfset show_unitname=""> 
<cfset show_stateprovincename=""> 
<cfset show_countryname="">
<cfset certexpires="">
<cfset default="">
<cfset ca_directory="">


<cfelse>
<cfset step=0>
<cfset m=20>
</cfif>



<cfelseif #checkca.recordcount# GTE 1>
<cfset step=0>
<cfset m=18>
</cfif>


</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion1" style="height: 437px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="system_configuration_form" action="ca_settings.cfm?action=" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="578">
                                          <table id="Table76" border="0" cellspacing="0" cellpadding="0" width="578" style="height: 365px;">
                                            <tr style="height: 14px;">
                                              <td width="578" id="Cell735">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certificate Authority Common Name </span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell734">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField1" name="ca_commonname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="#show_ca_commonname#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell442">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certficate Authority Certificate Validity in Years</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 95px;">
                                              <td id="Cell460">
                                                <table width="563" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table73" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 95px;">
                                                        <tr style="height: 19px;">
                                                          <td width="46" id="Cell423">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1825">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1825">
<cfoutput>
<input type="radio" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="517" id="Cell424">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">5 Years <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell425">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1460">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1460" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1460">
<cfoutput>
<input type="radio" name="validity" value="1460" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell426">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell427">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "1095">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1095" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "1095">
<cfoutput>
<input type="radio" name="validity" value="1095" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell428">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">3 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell429">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "730">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "730">
<cfoutput>
<input type="radio" name="validity" value="730" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell430">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell431">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_validity# is "365">
<cfoutput>
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_validity# is not "365">
<cfoutput>
<input type="radio" name="validity" value="365" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell432">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">1 Year</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell433">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certificate Authority Certificate Key Length</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell445">
                                                <table width="564" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="45" id="Cell411">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_encryption# is "2048">
<cfoutput>
<input type="radio" checked="checked" name="encryption" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption# is not "2048">
<cfoutput>
<input type="radio" name="encryption" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="519" id="Cell412">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2048-bits </span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell413">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_encryption# is "4096">
<cfoutput>
<input type="radio" checked="checked" name="encryption" value="4096" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption# is not "4096">
<cfoutput>
<input type="radio" name="encryption" value="4096" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell414">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4096-bits</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell453">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization/Company Name</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell473">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField5" name="organizationname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="#show_organizationname#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell474">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization Unit</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell772">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField6" name="unitname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="#show_unitname#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell773">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization State/Province</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell774">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField7" name="stateprovincename" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="#show_stateprovincename#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell775">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization Country Code</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell776">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField8" name="countryname" size="40" maxlength="2" style="width: 316px; white-space: pre;" value="#show_countryname#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell790">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Make Default</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell791">
                                                <table width="44" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfquery name="checkdefault" datasource="#datasource#">
select default2 from ca_settings where default2='1'
</cfquery>
<cfif #checkdefault.recordcount# GTE 1>
<input type="checkbox" name="default" value="1" style="height: 13px; width: 13px;">
<cfelseif #checkdefault.recordcount# LT 1>
<input type="hidden" name="default" value="1">
<input type="checkbox" name="default" value="1" style="height: 13px; width: 13px;" checked="checked" disabled="disabled">
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
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
                                        <td width="956">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="956" id="Cell722">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        <td width="956" height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA Common Name cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA Common Name must not contain special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Root CA E-mail Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA E-mail address cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Intermediate CA Common Name must not contain special characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server Intermedia CA Common Name cannot be empty</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Intermedite CA E-mail Address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Intermedia CA E-mail Address cannot be empty</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization/Company Name cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization/Company Name cannot contain any special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Unit cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Unit cannot contain any special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization State/Province cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization State/Province cannot contain any special characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "15">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Country Code cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Country Code cannot contain any special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! CA Created.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Certification Authority you are attempting to add already exists. Please change the Certification Authority Common Name</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;System error has occured. Please contact support with the following error: Error occured while inserting CA. Temp Email not found</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "20">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;System error has occured. Please contact support with the following error: Error occured while inserting CA. Multiple Temp Email found</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "101">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="449"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="2" valign="middle" width="954"><hr id="HRRule13" width="954" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="11"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Edit/Delete Existing Internal Certificate Authorities</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="126"></td>
                          <td colspan="4" width="956"><cfparam name = "m2" default = "0">
<cfif IsDefined("url.m2") is "True">
<cfif url.m2 is not "">
<cfset m2 = url.m2>
</cfif></cfif>

<cfif #action# is "mkdefault">
<cfquery name="reset" datasource="#datasource#">
update ca_settings set default2='2'
</cfquery>
<cfquery name="set" datasource="#datasource#">
update ca_settings set default2='1' where id='#form.id#'
</cfquery>
<cflocation url="ca_settings.cfm?action=setdefault">
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion15" style="height: 126px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="956">
                                    <tr valign="top" align="left">
                                      <td width="956" id="Text367" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="getca" datasource="#datasource#">
select * from ca_settings order by ca_commonname asc
</cfquery>


<cfif #getca.recordcount# LT 1>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);">No Existing Certificate Authrorities were found...</span></i></b></p>

<cfelseif #getca.recordcount# GTE 1>

<table id="Table129" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="51" style="background-color: rgb(241,236,236);" id="Cell779">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete</span></b></p>
    </td>
    <td width="150" style="background-color: rgb(241,236,236);" id="Cell780">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">CA Common Name</span></b></p>
    </td>
    
    <td width="87" style="background-color: rgb(241,236,236);" id="Cell782">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Cert Expires</span></b></p>
    </td>
    <td width="83" style="background-color: rgb(241,236,236);" id="Cell783">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Key Length</span></b></p>
    </td>
    <td width="60" style="background-color: rgb(241,236,236);" id="Cell790">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Default</span></b></p>
    </td>
  </tr>
<cfoutput query="getca">
<cfquery name="getcarecepients" datasource="#datasource#">
select * from recipient_certificates where ca_id='#id#'
</cfquery>
  <tr style="height: 19px;">
    <td id="Cell784">
      <form name="Cell765FORM" action="delete_ca.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<cfif #getcarecepients.recordcount# LT 1>
            <td align="center"><input type="image" id="FormsButton2" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
<cfelseif #getcarecepients.recordcount# GTE 1>
<td align="center"><input type="image" id="FormsButton2" name="FormsButton1" disabled="disabled" src="delete_icon_off.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
</cfif>
          </tr>
        </table>
      </form>
    </td>
    <td id="Cell785">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#ca_commonname#</span></p>
    </td>
    
    <td id="Cell787">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#DateFormat(expires,"mm/dd/yyyy")#</span></p>
    </td>
    <td id="Cell788">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#encryption#</span></p>
    </td>
<cfif #default2# is "1">
    <td width="60" id="Cell791">
  <form name="Cell791FORM" action="ca_settings.cfm?action=mkdefault" method="post">
    <input type="hidden" name="id" value="#id#">
    <p style="text-align: center; margin-bottom: 0px;"><input type="checkbox" name="mkdefault" value="1" style="height: 13px; width: 13px;" checked="checked" disabled="disabled">&nbsp;</p>
  </form>
</td>
<cfelseif #default2# is "2">
    <td width="60" id="Cell791">
  <form name="Cell791FORM" action="ca_settings.cfm?action=mkdefault" method="post">
    <input type="hidden" name="id" value="#id#">
    <p style="text-align: center; margin-bottom: 0px;"><input type="checkbox" name="mkdefault" value="1" style="height: 13px; width: 13px;" onclick="this.form.submit();">&nbsp;</p>
  </form>
</td>
</cfif>

  </tr>
</cfoutput>
</table>
</cfif>
&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #action# is "setdefault">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! New default Certification Authority set.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Certificate Authority you are attempting to delete has issued certificates. You must first delete the users and corresponding certificates that are issued before you can delete the Certificate Authority</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Certificate Authority Deleted</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
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