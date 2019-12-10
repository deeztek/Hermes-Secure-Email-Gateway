<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>System Update</title>
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
              <td height="479" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 479px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="518">
                              <tr valign="top" align="left">
                                <td width="12" height="9"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">System Update</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/system-update/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="85"></td>
                          <td width="955"><cfparam name = "m" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

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

</cfif>

<cfif #action# is "view">

<cfquery name="getserial" datasource="#datasource#">
SELECT value FROM system_settings where parameter = 'serial'
</cfquery>

<cfquery name="getlatestlocal" datasource="#datasource#">
SELECT * FROM system_updates where status = '1' order by install_order desc limit 1
</cfquery>

<CFHTTP url="http://updates.deeztek.com/update.cfm?build=#getlatestlocal.build#&sn=#getserial.value#" method="GET" resolveurl="false"> 
</CFHTTP>

<cfset status2="#trim(ListGetAt(cfhttp.FileContent, 1, "#chr(64)#"))#">
<cfif #status2# contains 'SUCCESS'>
<cfset build2 = "#trim(ListGetAt(cfhttp.FileContent, 2, "#chr(64)#"))#">
<cfset released2 = "#trim(ListGetAt(cfhttp.FileContent, 3, "#chr(64)#"))#">
<cfset filename2 = "#trim(ListGetAt(cfhttp.FileContent, 4, "#chr(64)#"))#">
<cfset relnoteavailable = "#trim(ListGetAt(cfhttp.FileContent, 5, "#chr(64)#"))#">
<cfif #relnoteavailable# is "1">
<cfset relnotefile = "#trim(ListGetAt(cfhttp.FileContent, 6, "#chr(64)#"))#">
</cfif>
<cfset compare_build = Compare(#build2#, #getlatestlocal.build#)>
<cfif #compare_build# is "0">
<cfset m=1>
<cfelse>
<cfset m=2>
</cfif>
<cfelseif #status2# contains 'Connection'>
<cfset m=3>
<cfelseif #status2# contains 'INVALID'>
<cfset m=4>
<cfelseif #status2# contains 'NOUPDATE'>
<cfset m=1>
</cfif>


<cfelseif #action# is "download">
<cfquery name="getserial" datasource="#datasource#">
SELECT value FROM system_settings where parameter = 'serial'
</cfquery>

<CFHTTP url="http://updates.deeztek.com/download.cfm?file=#form.file#&sn=#getserial.value#" method="GET" resolveurl="false" redirect="false" path="/opt/hermes/tmp/" file="#form.file#"> 
</CFHTTP>

<cfif #cfhttp.filecontent# contains 'Not Authorized'>
<cfset m=4>
<cfset action="">
<cfelseif #cfhttp.filecontent# contains 'File Not Found'>
<cfoutput>
<cfset updatepath="/opt/hermes/tmp/#form.file#">
</cfoutput>
<cfif fileExists(updatepath)>
<cffile action = "delete" file = "#updatepath#">
</cfif>
<cfset m=5>
<cfset action="">
<cfelse>
<cfoutput>
<cfset updatepath="/opt/hermes/tmp/#form.file#">
</cfoutput>
<cfif NOT fileExists(updatepath)>
<cfset m=6>
<cfset action="">
<cfelseif fileExists(updatepath)>
<cfset m=7>
</cfif>
</cfif>

<cfelseif #action# is "install">

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

<cffile action="read" file="/opt/hermes/scripts/update_hermes.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_update_hermes.sh"
    output = "#REReplace("#temp#","HERMES-BUILD","#form.build#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_update_hermes.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_update_hermes.sh"
    output = "#REReplace("#temp#","HERMESSQLUSERNAME","#mysqlusernamehermes#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_update_hermes.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_update_hermes.sh"
    output = "#REReplace("#temp#","HERMESSQLPASSWORD","#mysqlpasswordhermes#","ALL")#" addnewline="no">

<!--- EXECUTE UPDATE STARTS HERE --->

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_update_hermes.sh"
timeout = "60">
</cfexecute>



<cfexecute name = "/opt/hermes/tmp/#customtrans3#_update_hermes.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_update_hermes.sh">
    


<cfquery name="getresult" datasource="#datasource#">
SELECT * FROM system_settings where parameter = 'build_no' and value = '#form.build#'
</cfquery>

<cfif #getresult.recordcount# GTE 1>
<cfset m=8>
<cfset action="">
<cfelseif #getresult.recordcount# LT 1>
<cfset m=9>
<cfset action="">
</cfif>

<!--- EXECUTE UPDATE ENDS HERE --->

<!-- CFIF for action -->
</cfif>








                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion11" style="height: 85px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="955">
                                    <tr valign="top" align="left">
                                      <td width="867" id="Text499" class="TextObject"><cfif #action# is "">


<form name="check_updates" action="system_update.cfm" method="post">
<input type="hidden" name="action" value="view">
  
<table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="956" id="Cell753">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="204" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: center; margin-bottom: 0px;">

<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Check for Updates" style="height: 24px; width: 142px;">
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

<cfelseif #action# is "view">
<cfif #m# is 2>
<table id="Table131" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="391" style="background-color: rgb(241,236,236);" id="Cell792">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Build No</span></b></p>
    </td>
<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Date Released</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Release Notes</span></b></p>
    </td>

    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Action</span></b></p>
    </td>
  </tr>


<tr style="height: 19px;">
<td>
<cfoutput>
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>#build2#</b></span></p>
</cfoutput>
</td>

<cfset released = #DateFormat(released2, "mm/dd/yyyy")#>

<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>#released#</b></span></p>
</cfoutput>
</td>

<cfif #relnoteavailable# is "1">
<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(128,128,128);"><a href="http://updates.deeztek.com/downloads/hermes-#build2#-release.txt">Build #build2# Release Notes</a></span></p>
</cfoutput>
</td>

<cfelse>
<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>N/A</b></span></p>
</cfoutput>
</td>

</cfif>

<td>
      <form name="editreport" action="system_update.cfm" method="post">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>

<input type="hidden" name="action" value="download">
<cfoutput>
<input type="hidden" name="file" value="hermes-#build2#.tar.gz">
<input type="hidden" name="build" value="#build2#">
<input type="hidden" name="released" value="#released#">
<input type="hidden" name="relnoteavailable" value="#relnoteavailable#">

</cfoutput>
            <td align="center"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Download Update" style="height: 24px; width: 142px;">
</td>

</tr>
        </table>
      </form>
    </td>

      </tr>

</table>

<!-- CFIF for M -->
</cfif>



<cfelseif #action# is "download">
<cfif #m# is 7>
<table id="Table131" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="391" style="background-color: rgb(241,236,236);" id="Cell792">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Build No</span></b></p>
    </td>
<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Date Released</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Release Notes</span></b></p>
    </td>


    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Action</span></b></p>
    </td>
  </tr>


<tr style="height: 19px;">
<td>
<cfoutput>
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>#form.build#</b></span></p>
</cfoutput>
</td>

<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>#form.released#</b></span></p>
</cfoutput>
</td>

<cfif #form.relnoteavailable# is "1">
<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(128,128,128);"><a href="http://updates.deeztek.com/downloads/hermes-#form.build#-release.txt">Build #form.build# Release Notes</a></span></p>
</cfoutput>
</td>

<cfelse>
<td>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b>N/A</b></span></p>
</cfoutput>
</td>

</cfif>



<td>
      <form name="editreport" action="system_update.cfm" method="post">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>

<input type="hidden" name="action" value="install">
<cfoutput>
<input type="hidden" name="file" value="#form.file#">
<input type="hidden" name="build" value="#form.build#">
</cfoutput>
            <td align="center"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Install Update" style="height: 24px; width: 142px;">
</td>

</tr>
        </table>
      </form>
    </td>

      </tr>

</table>          

<!-- CFIF for M -->
</cfif>




<!-- CFIF action -->
</cfif>
                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                      </td>
                                      <td width="88"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" width="955" id="Text185" class="TextObject"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Hermes SEG is on the latest version</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! An update is available for Hermes SEG. Please click
 the Download button above to retrieve the update</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0"
 alt="warning_icon1" title="warning_icon1">&nbsp;Unable to reach update server. Please ensure the system has outbound
 HTTP/HTTPS access</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0"
 alt="warning_icon1" title="warning_icon1">&nbsp;The system has detected and invalid license. Please contact
 support</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0"
 alt="warning_icon1" title="warning_icon1">&nbsp;There was a problem downloading the update. Please contact support
 (Server)</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0"
 alt="warning_icon1" title="warning_icon1">&nbsp;There was a problem downloading the update (Client). Please contact
 support</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Update downloaded. Please ensure you have a recent
 valid backup and click the Install Update button above to proceed with the installation</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top"
 border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Update installed. Please reboot your system in order
 for the changes to take effect</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color:
 rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0"
 alt="warning_icon1" title="warning_icon1">&nbsp;There was a problem installing the update. Please contact
 support</span></i></b></p>
</cfoutput>
</cfif>
                                        <p style="text-align: left; margin-bottom: 0px;">&nbsp;</p>
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