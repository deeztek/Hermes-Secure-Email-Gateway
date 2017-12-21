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
<title>Email Archive</title>
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
              <td height="874" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 874px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="9" height="13"></td>
                                <td width="2"></td>
                                <td width="504"></td>
                                <td width="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Email Archive</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="10"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text482" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Archive Job</span></b></p>
                                </td>
                                <td></td>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/email-archive/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="959"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="959" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">The system requires a Windows (Samba) share in order to perform scheduled email archive. Creating an Archive Job requires that you you first validate the share and upon successful validation only then you can save the archive job. Fill out all the fields below and click the submit button. If the share is successfully validated, the Save Archive Job selection box will become available. <b>It is highly recommended that you archive email in deduplicating storage</b>. In addition to archiving the email on the appliance to the specified share, this job will also allow you to create a compressed 7-zip snapshot of the latest archive on that share . The 7-zip snapshot is useful for having multiple backup copies of the e-mail archive.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="10" height="22"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="452"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="592"></td>
                          <td colspan="4" width="959"><cfparam name = "m" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "m2" default = ""> 
<cfif IsDefined("url.m2") is "True">
<cfif url.m2 is not "">
<cfset m2 = url.m2>
</cfif></cfif>

<cfparam name = "m3" default = ""> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>


<cfparam name = "show_mode" default = "test"> 
<cfif IsDefined("form.mode") is "True">
<cfif form.mode is not "">
<cfset show_mode = form.mode>
</cfif></cfif>

<cfparam name = "email_age" default = "180"> 
<cfif IsDefined("form.email_age") is "True">
<cfif form.email_age is not "">
<cfset email_age = form.email_age>
</cfif></cfif>

<cfparam name = "show_entry_name" default = ""> 
<cfif IsDefined("form.entry_name") is "True">
<cfif form.entry_name is not "">
<cfset show_entry_name = form.entry_name>
</cfif></cfif> 

<cfparam name = "show_server" default = ""> 
<cfif IsDefined("form.server") is "True">
<cfif form.server is not "">
<cfset show_server = form.server>
</cfif></cfif> 

<cfparam name = "show_share" default = ""> 
<cfif IsDefined("form.share") is "True">
<cfif form.share is not "">
<cfset show_share = form.share>
</cfif></cfif> 

<cfparam name = "show_directory" default = ""> 
<cfif IsDefined("form.directory") is "True">
<cfif form.directory is not "">
<cfset show_directory = form.directory>
</cfif></cfif> 

<cfparam name = "show_domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset show_domain = form.domain>
</cfif></cfif>

<cfparam name = "show_username" default = ""> 
<cfif IsDefined("form.username") is "True">
<cfif form.username is not "">
<cfset show_username = form.username>
</cfif></cfif> 

<cfparam name = "show_password" default = ""> 
<cfif IsDefined("form.password") is "True">
<cfif form.password is not "">
<cfset show_password = form.password>
</cfif></cfif> 

<cfparam name = "show_notification" default = ""> 
<cfif IsDefined("form.notification") is "True">
<cfif form.notification is not "">
<cfset show_notification = form.notification>
</cfif></cfif>

<cfparam name = "show_interval" default = "daily"> 
<cfif IsDefined("form.interval") is "True">
<cfif form.interval is not "">
<cfset show_interval = form.interval>
</cfif></cfif>

<cfparam name = "startdate" default = ""> 
<cfif IsDefined("form.startdate") is "True">
<cfif form.startdate is not "">
<cfset startdate = form.startdate>
</cfif></cfif>

<cfparam name = "starttime" default = ""> 
<cfif IsDefined("form.start") is "True">
<cfif form.start is not "">
<cfset starttime = form.start>
</cfif></cfif> 

<cfparam name = "snapshot" default = "yes"> 
<cfif IsDefined("form.snapshot") is "True">
<cfif form.snapshot is not "">
<cfset snapshot = form.snapshot>
</cfif></cfif>

<cfparam name = "show_retention" default = "7"> 
<cfif IsDefined("form.retention") is "True">
<cfif form.retention is not "">
<cfset show_retention = form.retention>
</cfif></cfif>

<cfif #action# is "edit">

<cfif #show_mode# is "test">

<cfif #show_entry_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_entry_name) gt 0>
<cfset step=0>
<cfset m=1>
<cfelse>
<cfset step=1>
</cfif>
<cfelseif #show_entry_name# is "">
<cfset step=0>
<cfset m=2>
</cfif>


<cfif #step# is "1" and #show_server# is not "">
<cfif REFind("[^A-Za-z0-9\_\-\+\.]",show_server) gt 0>
<cfset step=0>
<cfset m=3>
<cfelse>
<cfset step=2>
</cfif>
<cfelseif #step# is "1" and #show_server# is "">
<cfset step=0>
<cfset m=4>
</cfif>


<cfif #step# is "2" and #show_share# is not "">
<cfif REFind("[^A-Za-z0-9\_\-\+ ]",show_share) gt 0>
<cfset step=0>
<cfset m=5>
<cfelse>
<cfset step=3>
</cfif>
<cfelseif #step# is "2" and #show_share# is "">
<cfset step=0>
<cfset m=6>
</cfif>

<cfif #step# is "3" and #show_directory# is not "">
<cfif REFind("[^A-Za-z0-9\_\.\-\+ ]",show_server) gt 0>
<cfset step=0>
<cfset m=7>
<cfelse>
<cfset step=4>
</cfif>
<cfelseif #step# is "3" and #show_directory# is "">
<cfset step=4>
</cfif>

<cfif #step# is "4" and #show_domain# is not "">
<cfif REFind("[^A-Za-z0-9\_\-\+]",show_domain) gt 0>
<cfset step=0>
<cfset m=18>
<cfelse>
<cfset step=5>
</cfif>
<cfelseif #step# is "4" and #show_domain# is "">
<cfset step=0>
<cfset m=21>
</cfif>


<cfif #step# is "5" and #show_username# is not "">
<cfset step=6>
<cfelseif #step# is "5" and #show_username# is "">
<cfset step=0>
<cfset m=8>
</cfif>


<cfif #step# is "6" and #show_password# is not "">
<cfset step=7>
<cfelseif #step# is "6" and  #show_password# is "">
<cfset step=0>
<cfset m=9>
</cfif>

<cfif #step# is "7" and #show_notification# is not "">
<cfif isValid("email", show_notification)> 
<cfset step=8>
<cfelse>
<cfset step=0>
<cfset m=10>
</cfif>
<cfelseif #step# is "7" and #show_notification# is "">
<cfset step=0>
<cfset m=11>
</cfif>

<cfif #step# is "8" and #startdate# is not "">
<cfif isValid("date", startdate)>
<cfset step=9> 
<cfelse>
<cfset step=0>
<cfset m=12>
</cfif>
<cfelseif #step# is "8" and #startdate# is "">
<cfset step=0>
<cfset m=13>
</cfif>





<cfif step is "9">

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

<cffile action="read" file="/opt/hermes/scripts/validate_share_archive.sh" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-SERVER","#show_server#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-SHARE","#show_share#","ALL")#"> 

<cfif #show_directory# is "">

<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-DIRECTORY","","ALL")#"> 

<cfelseif #show_directory# is not "">

<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-DIRECTORY","#show_directory#","ALL")#">
 
</cfif>


<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-DOMAIN","#show_domain#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-USERNAME","#show_username#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/validate_share_archive_#customtrans3#" variable="validateshare">

<cffile action = "write"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
    output = "#REReplace("#validateshare#","THE-PASSWORD","#show_password#","ALL")#"> 
    


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/validate_share_archive_#customtrans3#"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/validate_share_archive_#customtrans3#"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/validate_share_archive_#customtrans3#">


<cfset testfile="/mnt/hermesarchivetest/testsmb">
<cfif fileExists(testfile)>
<cfset m=19>

<cffile action = "delete" file = "#testfile#">


<cfexecute name = "/opt/hermes/scripts/umount_share_archive.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cfelseif NOT fileExists(testfile)>
<cfexecute name = "/opt/hermes/scripts/umount_share_archive.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>
<cfset m=20>
<cfset step=0>
</cfif>



</cfif>

<cfelseif #show_mode# is "save">

<cfquery name="check" datasource="#datasource#">
select * from archive_jobs  
</cfquery>

<cfif #check.recordcount# LT 1>
<!--- ENCRYPTION MECHANISM FOR PASSWORDS. NOT USED AT THIS TIME. 
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
<cfoutput>#hermeskey#</cfoutput>
<cfif #hermeskey# is "">
<cfscript>
theKey=generateSecretKey(AES, 256);
</cfscript>

<cffile action = "write"
    file = "/opt/hermes/keys/hermes.key"
    output = "#theKey#">

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">

<cfset encrypted_username=encrypt(show_username, hermeskey, AES, Base64)>
<cfset encrypted_password=encrypt(show_password, hermeskey, AES, Base64)>
<cfelse>

<cfset encrypted_username=encrypt(show_username, hermeskey, AES, Base64)>
<cfset encrypted_password=encrypt(show_password, hermeskey, AES, Base64)>
</cfif>
--->

<cfset date2="#dateformat(startdate, "yyyy-mm-dd")#">
<cfset time2="#timeformat(starttime, "HH:mm:ss")#">

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

<cfif #show_directory# is "">
<cfquery name="insertjob" datasource="#datasource#" result="adResult">
insert into archive_jobs
(entry_name, share, domain, server, username, password, notification, archive_interval, scheduled_interval, retention, snapshot)
values
('#show_entry_name#', '#show_share#', '#show_domain#', '#show_server#', '#show_username#', '#show_password#', '#show_notification#', '#email_age#', '#show_interval#', '#show_retention#', '#snapshot#')
</cfquery>

<cfelseif #show_directory# is not "">
<cfquery name="insertjob" datasource="#datasource#" result="adResult">
insert into archive_jobs
(entry_name, share, domain, server, username, password, notification, archive_interval, directory, scheduled_interval, retention, snapshot)
values
('#show_entry_name#', '#show_share#', '#show_domain#', '#show_server#', '#show_directory#', ,'#show_username#', '#show_password#',
 '#show_notification#', '#email_age#', '#show_directory#', '#show_interval#', '#show_retention#', '#snapshot#')
</cfquery>

</cfif>


<!--- NOT USED. SCHEDULED TASK ALREADY IN RAILO --->
<cfset date1="#dateformat(startdate, "dd/mm/yyyy")#">
<cfset time1="#timeformat(starttime, "HH:mm")#">
<cfschedule action="update"
task="archivejob_#show_entry_name#"
operation="HTTPRequest"
startdate="#date1#"
starttime="#time1#"
requesttimeout="7200"
url="http://localhost:8080/schedule/#show_entry_name#_archive_task.cfm"
interval="#show_interval#">



<cffile action="read" file="/opt/hermes/templates/archive_task.cfm" variable="archivetask">

<cffile action = "write"
    file = "/var/www/schedule/#show_entry_name#_archive_task.cfm"
    output = "#archivetask#"> 
    





<cfset show_mode="test">
<cfset show_entry_name="">
<cfset show_server="">
<cfset show_domain="">
<cfset show_share="">
<cfset show_directory="">
<cfset show_username="">
<cfset show_password="">
<cfset email_age="180">
<cfset show_notification="">
<cfset show_interval="daily">
<cfset show_retention="7">
<cfset startdate="">
<cfset starttime="">
<cfset m=16>

<cfelseif #check.recordcount# GTE 1>
<cfset show_mode="test">
<cfset m=17>
</cfif>

</cfif>

</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion1" style="height: 592px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="archive_form" action="email_archive.cfm" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table76" border="0" cellspacing="0" cellpadding="0" width="959" style="height: 385px;">
                                            <tr style="height: 14px;">
                                              <td width="959" id="Cell739">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Archive Job Create&nbsp; Mode</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 38px;">
                                              <td id="Cell738">
                                                <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 19px;">
                                                          <td width="58" id="Cell524">
                                                            <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_mode# is "test">
<cfoutput>
<input type="radio" name="mode" value="test" checked="checked" style="height: 19px; width: 19px;">
</cfoutput>
<cfelseif #show_mode# is not "test">
<cfoutput>
<input type="radio" name="mode" value="test" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>


&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="429" id="Cell525">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Validate Share</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell526">
                                                            <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_mode# is "save">
<cfif #m# is "19">
<cfoutput>
<input type="radio" name="mode" value="save" checked="checked" style="height: 19px; width: 19px;">
</cfoutput>
<cfelseif #m# is not "19">
<cfoutput>
<input type="radio" name="mode" value="save" disabled="disabled" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>
<cfelseif #show_mode# is not "save">
<cfif #m# is "19">
<cfoutput>
<input type="radio" name="mode" value="save" style="height: 19px; width: 19px;">
</cfoutput>
<cfelseif #m# is not "19">
<cfoutput>
<input type="radio" name="mode" value="save" disabled="disabled" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>
</cfif>

&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell527">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Save Archive Job</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell736">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Archive Job Name<span style="font-weight: normal;"> (Enter a friendly name to identify this job)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell737">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="entry_name" size="30" maxlength="15" style="width: 236px; white-space: pre;" value="#show_entry_name#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell735">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"><span style="font-weight: normal;">&nbsp;</span>Server<span style="font-weight: normal;">(IP Address or FQDN Host Name)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell734">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="server" size="30" maxlength="100" style="width: 236px; white-space: pre;" value="#show_server#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell732">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Share Name </span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell733">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="share" size="30" maxlength="255" style="width: 236px; white-space: pre;" value="#show_share#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1048">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Directory Name <span style="font-weight: normal;">(If Applicable)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1049">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="directory" size="30" maxlength="255" style="width: 236px; white-space: pre;" value="#show_directory#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1053">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1054">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="domain" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_domain#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1017">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Username</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1018">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="username" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#show_username#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell436">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell437">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="password" name="password" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_password#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1050">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Notification E-mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1051">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="notification" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#show_notification#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1059">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Archive Emails Older Than</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1060">
                                                <table width="166" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #email_age# is "7">
<select name="email_age" style="height: 24px;">
    <option value="7" selected="selected">7 Days</option>
  <option value="14">14 Days</option>
  <option value="30">30 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>
<option value="365">1 Year</option>
</select>

<cfelseif #email_age# is "14">
<select name="email_age" style="height: 24px;">
    <option value="14" selected="selected">14 Days</option>
  <option value="7">7 Days</option>
  <option value="30">30 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>
<option value="365">1 Year</option>

</select>

<cfelseif #email_age# is "30">
<select name="email_age" style="height: 24px;">
    <option value="30" selected="selected">30 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="60">60 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>
<option value="365">1 Year</option>

</select>

<cfelseif #email_age# is "60">
<select name="email_age" style="height: 24px;">
    <option value="60" selected="selected">60 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="30">30 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>
<option value="365">1 Year</option>

</select>

<cfelseif #email_age# is "90">
<select name="email_age" style="height: 24px;">
    <option value="90" selected="selected">90 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="30">30 Days</option>
  <option value="180">180 Days</option>
<option value="365">1 Year</option>

</select>

<cfelseif #email_age# is "180">
<select name="email_age" style="height: 24px;">
    <option value="180" selected="selected">180 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="30">30 Days</option>
  <option value="90">90 Days</option>
<option value="365">1 Year</option>

</select>

<cfelseif #email_age# is "365">
<select name="email_age" style="height: 24px;">
    <option value="365" selected="selected">1 Year</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="30">30 Days</option>
  <option value="90">90 Days</option>
  <option value="180">180 Days</option>

</select>



</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1075">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Create Compressed 7-zip Snapshot</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1076">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="51" id="Cell1063">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #snapshot# is "yes">
<cfoutput>
<input type="radio" checked="checked" name="snapshot" value="yes" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #snapshot# is not "yes">
<cfoutput>
<input type="radio" name="snapshot" value="yes" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="480" id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell1025">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #snapshot# is "no">
<cfoutput>
<input type="radio" checked="checked" name="snapshot" value="no" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #snapshot# is not "no">
<cfoutput>
<input type="radio" name="snapshot" value="no" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1026">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1072">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Compressed 7-zip Snapshot Retention Period</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1073">
                                                <table width="166" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_retention# is "7">
<select name="retention" style="height: 24px;">
    <option value="7" selected="selected">7 Days</option>
  <option value="14">14 Days</option>
  <option value="21">21 Days</option>
  <option value="28">28 Days</option>
</select>

<cfelseif #show_retention# is "14">
<select name="retention" style="height: 24px;">
    <option value="14" selected="selected">14 Days</option>
  <option value="7">7 Days</option>
  <option value="21">21 Days</option>
  <option value="28">28 Days</option>
</select>

<cfelseif #show_retention# is "21">
<select name="retention" style="height: 24px;">
    <option value="21" selected="selected">21 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="28">28 Days</option>
</select>

<cfelseif #show_retention# is "28">
<select name="retention" style="height: 24px;">
    <option value="28" selected="selected">28 Days</option>
  <option value="7">7 Days</option>
  <option value="14">14 Days</option>
  <option value="21">21 Days</option>
</select>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 41px;">
                                              <td id="Cell1071">
                                                <table width="614" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table127" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                                        <tr style="height: 19px;">
                                                          <td width="92" id="Cell1023">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Frequency</span></b></p>
                                                          </td>
                                                          <td width="45" id="Cell1046">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                          <td width="327" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Start Date</span></b></p>
                                                          </td>
                                                          <td width="150" id="Cell1021">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Start Time</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 22px;">
                                                          <td id="Cell768">
                                                            <table width="92" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_interval# is "daily">
<select id="FormsComboBox1" name="interval" style="height: 24px;">
    <option value="daily" selected="selected">Daily</option>
  <option value="weekly">Weekly</option>
  <option value="monthly">Monthly</option>
</select>

<cfelseif #show_interval# is "weekly">
<select id="FormsComboBox1" name="interval" style="height: 24px;">
    <option value="weekly" selected="selected">Weekly</option>
  <option value="daily">Daily</option>
  <option value="monthly">Monthly</option>
</select>

<cfelseif #show_interval# is "monthly">
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
                                                                  <p style="margin-bottom: 0px;"><a href="javascript:ShowCalendar('archive_form',%20'startdate')"><img id="Picture49" height="22" width="20" src="calendar1.png" border="0" alt="Show Calendar" title="Show Calendar"></a>&nbsp;</p>
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
<select name="start" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>

<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>

</cfoutput>
</cfloop>
</select>

<cfelseif #starttime# is not "">
<cfset starttime2=#TimeFormat(starttime, "hh:mm tt")#>
<select name="start" style="height: 22px;">
<cfoutput>
<option value="#starttime#" SELECTED>#starttime2#</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="#CreateTimeSpan(0,0,15,0)#"> 
<cfoutput>
<option value="#TimeFormat(i, "HH:mm:ss")#">#TimeFormat(i, "hh:mm tt")#</option>

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
                                    <table border="0" cellspacing="0" cellpadding="0" width="959">
                                      <tr valign="top" align="left">
                                        <td width="959" height="14"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Archive Job Name field must not contain any characters or spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Archive Job Name field must not be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Server field must be alphanumeric, it can only contain "_", "-", "." characters and must not contain spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Server field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Share Name field must be alphanumeric, it can only contain "_", "-" characters and it can also contain spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Share Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Directory Name field must be alphanumeric, it can only contain "_", "-" characters and it can also contain spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Username field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Password field must not be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Archive Notification E-mail field must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Archive Notification E-mail field must not be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Start Date field must be a valid date in the form mm/dd/yyyy</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Start Date field must not be empty</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Archive Job Saved.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;An Archive Job already exists. You cannot add more than one Archive Job. </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain field must be alphanumeric and it can only contain "_", "-" characters </span></i></b></p>
</cfoutput>
</cfif>



<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Share Validated. Please select "Save Archive Job" selection box on top and click the "Submit" button to save the Archive job</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "20">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Share cannot be validated. Please check all supplied information and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "21">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Archive Job share mounted.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Archive Job share was not mounted successfully. Please check ensure the share is available and the credentials are correct. </span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "deleted">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Connection you are attempting to add already exists. Please try again</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="959" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Submit" style="height: 24px; width: 142px;">&nbsp;</p>
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
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="958"><hr id="HRRule1" width="958" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text356" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">&nbsp;Existing Archive Job</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="64"></td>
                          <td colspan="3" width="958"><cfparam name = "m2" default = "0">

                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion15" style="height: 64px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="958">
                                    <tr valign="top" align="left">
                                      <td width="958" id="Text367" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="getarchives" datasource="#datasource#">
select id, server as server2, share, directory, entry_name, archive_interval, archive_date, scheduled_interval, startdate, initial_count, retention, snapshot from archive_jobs order by entry_name asc
</cfquery>

<cfquery name="checkarchive" datasource="#datasource#">
select * from archive_jobs where status='running' limit 1
</cfquery>

<cfif #checkarchive.recordcount# GTE 1>
<cfset archivestatus="running">
<cfelseif #checkarchive.recordcount# LT 1>
<cfset archivestatus="notrunning">
</cfif>


<cfif #getarchives.recordcount# LT 1>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);  font-size: 12px;">No Existing Archive Job found...</span></i></b></p>

<cfelseif #getarchives.recordcount# GTE 1>

<table id="Table71" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    
    <td width="48" style="background-color: rgb(241,236,236);" id="Cell764">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete</span></b></p>
    </td>
    <td width="109" style="background-color: rgb(241,236,236);" id="Cell416">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Job Name</span></b></p>
    </td>
    <td width="112" style="background-color: rgb(241,236,236);" id="Cell402">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Server</span></b></p>
    </td>
    <td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Share</span></b></p>
    </td>
<td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Directory </span></b></p>
    </td>

    <td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Interval</span></b></p>
    </td>
    <td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Email Age</span></b></p>
    </td>

 <td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Compressed Snapshot</span></b></p>
    </td>



<td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Compressed Snapshot Retention</span></b></p>
    </td>


    <td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Job Progress</span></b></p>
    </td>

<td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Remount Share</span></b></p>
    </td>

<td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Run/Stop</span></b></p>
    </td>

  </tr>
<cfoutput query="getarchives">
  <tr style="height: 19px;">

<cfif #archivestatus# is "notrunning">

    <td id="Cell765">
      <form name="Cell765FORM" action="delete_archive_job.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      </form>
    </td>

<cfelseif #archivestatus# is "running">
<td id="Cell765">
      
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="delete_icon_off.png" alt="Cannot delete while Archive Job is Currently Running" title="Cannot delete while Archive Job is Currently Running" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      
    </td>



</cfif>

    <td id="Cell406">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#entry_name#</span></p>
    </td>

    <td id="Cell407">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#server2#</span></p>
    </td>
    <td id="Cell408">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#share#</span></p>
    </td>
<td id="Cell408">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#directory#</span></p>
    </td>



    <td id="Cell771">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#scheduled_interval#</span></p>
    </td>

    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#archive_interval#</span></p>
    </td>


    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#snapshot#</span></p>
    </td>

<cfif #snapshot# is "yes">
    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#retention#</span></p>
    </td>
<cfelseif #snapshot# is "no">
    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">N/A</span></p>
    </td>

</cfif>

<cfif #archivestatus# is "notrunning">

    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">N/A</span></p>
    </td>


<cfelseif #archivestatus# is "running">
<cfset theDate=#DateFormat(getarchives.archive_date, "yyyy-mm-dd")#>
<cfquery name = "getarchived" datasource = "#datasource#">
SELECT mail_id FROM msgs where time_iso <= '#theDate#' and archive = 'N'
</cfquery>

<cfif #getarchives.initial_count# GTE 1>

<cfset percentage2 = #getarchived.recordcount#/#getarchives.initial_count#>
<cfset percentage3 = #percentage2#*100>
<cfset percentage4 = 100-#percentage3#>


    <td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#Numberformat(percentage4, '____.__')#%</span></p>
    </td>

<cfelseif #getarchives.initial_count# LT 1>

<td id="Cell772">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Calculating...</span></p>
    </td>
</cfif>
</cfif>

<cfif #archivestatus# is "notrunning">

<td id="Cell765">
      <form name="Cell765FORM" action="remount_archive_share.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="remount.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      </form>
    </td>

<cfelseif #archivestatus# is "running">

<td id="Cell765">
      
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="remount_off.png" alt="Cannot remount share while Archive Job is Currently Running" title="Cannot remount share while Archive Job is Currently Running" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      
    </td>


</cfif>


<cfif #archivestatus# is "notrunning">
<td id="Cell765">
      <form name="Cell765FORM" action="run_archive_job.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="run_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      </form>
    </td>
<cfelseif #archivestatus# is "running">

<td id="Cell765">
      <form name="Cell765FORM" action="stop_archive_job.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="stop_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
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
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="958" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Archive Job Deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Archive Job has been scheduled to run immediately. You will receive an email confirmation to the Archive Notification Email address you specified when the job has completed. This can take a considerable amount of time depending on the size of you archives.You will not be able to run this archive job until all previous instances have completed.</span></i></b></p>
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