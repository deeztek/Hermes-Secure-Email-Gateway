<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>AD Integration</title>
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
              <td height="639" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 639px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="10" height="14"></td>
                                <td width="1"></td>
                                <td width="505"></td>
                                <td width="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">AD Integration</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="11"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text482" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add AD Connection</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/ad-integration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="11" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="416"></td>
                          <td width="961"><cfparam name = "m" default = "0">
<cfparam name = "step" default = "0"> 

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

<cfparam name = "show_schedule" default = ""> 
<cfif IsDefined("form.schedule") is "True">
<cfif form.schedule is not "">
<cfset show_schedule = form.schedule>
</cfif></cfif>

<cfparam name = "show_interval" default = "daily"> 
<cfif IsDefined("form.interval") is "True">
<cfif form.interval is not "">
<cfset show_interval = form.interval>
</cfif></cfif> 

<cfparam name = "show_entry_name" default = ""> 
<cfif IsDefined("form.entry_name") is "True">
<cfif form.entry_name is not "">
<cfset show_entry_name = form.entry_name>
</cfif></cfif> 

<cfparam name = "show_dc_name" default = ""> 
<cfif IsDefined("form.dc_name") is "True">
<cfif form.dc_name is not "">
<cfset show_dc_name = form.dc_name>
</cfif></cfif> 

<cfparam name = "show_fqdn_domain" default = "DC=domain, DC=com"> 
<cfif IsDefined("form.fqdn_domain") is "True">
<cfif form.fqdn_domain is not "">
<cfset show_fqdn_domain = form.fqdn_domain>
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

<cfparam name = "show_netbios" default = ""> 
<cfif IsDefined("form.netbios") is "True">
<cfif form.netbios is not "">
<cfset show_netbios = form.netbios>
</cfif></cfif>

<cfparam name = "show_objectclass" default = "user"> 
<cfif IsDefined("form.objectclass") is "True">
<cfif form.objectclass is not "">
<cfset show_objectclass = form.objectclass>
</cfif></cfif>

<cfif #action# is "edit">

<cfif #show_mode# is "test">

<cfif #show_entry_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",show_entry_name) gt 0>
<cfset step=0>
<cfset m=6>
<cfelse>
<cfset step=1>
</cfif>
<cfelseif #show_entry_name# is "">
<cfset step=0>
<cfset m=7>
</cfif>


<cfif #step# is "1" and #show_dc_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",show_dc_name) gt 0>
<cfset step=0>
<cfset m=8>
<cfelse>
<cfset step=2>
</cfif>
<cfelseif #step# is "1" and #show_dc_name# is "">
<cfset step=0>
<cfset m=9>
</cfif>


<cfif #step# is "2" and #show_fqdn_domain# is not "">
<cfif REFind("[^_a-zA-Z0-9-=]",show_fqdn_domain) gt 0>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m=10>
</cfif>
<cfelseif #step# is "2" and #show_fqdn_domain# is "">
<cfset step=0>
<cfset m=11>
</cfif>

<cfif #step# is "3" and #show_netbios# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",show_netbios) gt 0>
<cfset step=0>
<cfset m=18>
<cfelse>
<cfset step=4>
</cfif>
<cfelseif #step# is "3" and #show_netbios# is "">
<cfset step=0>
<cfset m=19>
</cfif>


<cfif #step# is "4" and #show_username# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",show_username) gt 0>
<cfset step=0>
<cfset m=12>
<cfelse>
<cfset step=5>
</cfif>
<cfelseif #step# is "4" and #show_username# is "">
<cfset step=0>
<cfset m=13>
</cfif>




<cfif #step# is "5" and #show_password# is not "">
<cfset step=6>
<cfelseif #step# is "5" and  #show_password# is "">
<cfset step=0>
<cfset m=14>
</cfif>



<cfif step is "6">

<cftry>

<cfldap action="query" name="adresult"
attributes = "mail"
START="#show_fqdn_domain#"
filter="(&(objectClass=#show_objectclass#)(mail=*))"
server="#show_dc_name#"
port="389"
username="#show_netbios#\#show_username#"
password="#show_password#">


<cfcatch type="any">

<cfif #cfcatch.type# contains "javax.naming.AuthenticationException">
<cfset m=1>
<cfelseif #cfcatch.type# contains "javax.naming.CommunicationException">
<cfset m=2>
<cfelseif #cfcatch.type# contains "javax.naming.InvalidNameException">
<cfset m=15>
<cfelseif #cfcatch.type# contains "javax.naming.NamingException">
<cfset m=15> 	
<cfelse>
<cfset m=4>
</cfif>

</cfcatch>

<cfif #adresult.recordcount# GTE 1>
<cfset m=5>
<cfelseif #adresult.recordcount# LT 1>
<cfset m=3>
</cfif>

</cftry>



</cfif>

<cfelseif #show_mode# is "save">
<cfquery name="check" datasource="#datasource#">
select * from ad_integration where entry_name='#show_entry_name#'
</cfquery>
<cfif #check.recordcount# LT 1>
<!--- ENCRYPTION MECHANISM FOR USERNAME/PASSWORD --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">


<!-- ENCRYPT USERNAME & PASSWORD -->
<cfset encryptedUsername=encrypt(show_username, #theKey#, "AES", "Base64")>
<cfset encryptedPassword=encrypt(show_password, #theKey#, "AES", "Base64")>


<cfquery name="insertad" datasource="#datasource#" result="adResult">
insert into ad_integration
(entry_name, dc_name, fqdn_domain, username, password, objectclass, netbios_domain)
values
('#show_entry_name#', '#show_dc_name#', '#show_fqdn_domain#', '#encryptedUsername#', '#encryptedPassword#', '#show_objectclass#', '#show_netbios#')
</cfquery>

<cfif #show_schedule# is "yes">

<cfquery name="schedulead" datasource="#datasource#">
update ad_integration set
scheduled='1',
scheduled_interval='#show_interval#'
where id='#adResult.GENERATED_KEY#'
</cfquery>

<!--- NOT USED. SCHEDULED TASK ALREADY IN RAILO --->
<cfset date1="#dateformat(now(), "dd/mm/yyyy")#">
<cfschedule action="update"
task="update_recipients_#show_entry_name#"
operation="HTTPRequest"
startdate="#date1#"
starttime="00:01"
requesttimeout="7200"
url="http://localhost:8888/schedule/#show_entry_name#_ad_tasks.cfm"
interval="#show_interval#">

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


<cffile action="read" file="/opt/hermes/templates/ad_scheduled_task.cfm" variable="adtask">

<cffile action = "write"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_DN_NAME.cfm"
    output = "#REReplace("#adtask#","DN_NAME","#show_fqdn_domain#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/templates/#customtrans3#ad_scheduled_task_DN_NAME.cfm" variable="adtask">

<cffile
    action = "delete"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_DN_NAME.cfm">

<cffile action = "write"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_SERVER_NAME.cfm"
    output = "#REReplace("#adtask#","SERVER_NAME","#show_dc_name#","ALL")#"> 

<cffile action="read" file="/opt/hermes/templates/#customtrans3#ad_scheduled_task_SERVER_NAME.cfm" variable="adtask">
    
<cffile
    action = "delete"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_SERVER_NAME.cfm">

<cffile action = "write"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_USER_NAME.cfm"
    output = "#REReplace("#adtask#","USER_NAME","#show_netbios#\#show_username#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/templates/#customtrans3#ad_scheduled_task_USER_NAME.cfm" variable="adtask">
    
<cffile
    action = "delete"
    file = "/opt/hermes/templates/#customtrans3#ad_scheduled_task_USER_NAME.cfm">
   
<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>


 
<cffile action = "write"
    file = "/var/www/html/schedule/#show_entry_name#_ad_tasks.cfm"
    output = "#REReplace("#adtask#","PASS_WORD","#show_password#","ALL")#"> 
    


</cfif>

<cfset show_mode="test">
<cfset show_entry_name="">
<cfset show_dc_name="">
<cfset show_fqdn_domain="">
<cfset show_username="">
<cfset show_password="">
<cfset show_schedule="">
<cfset show_interval="">
<cfset m=16>

<cfelseif #check.recordcount# GTE 1>
<cfset show_mode="test">
<cfset m=17>
</cfif>
</cfif>

</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion1" style="height: 416px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="ad_integration_form" action="" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="961">
                                          <table id="Table76" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 306px;">
                                            <tr style="height: 14px;">
                                              <td width="961" id="Cell739">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Connection Mode</span></b></p>
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
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Validate Connection</span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell526">
                                                            <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_mode# is "save">
<cfif #m# is "5">
<cfoutput>
<input type="radio" name="mode" value="save" checked="checked" style="height: 19px; width: 19px;">
</cfoutput>
<cfelseif #m# is not "5">
<cfoutput>
<input type="radio" name="mode" value="save" disabled="disabled" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>
<cfelseif #show_mode# is not "save">
<cfif #m# is "5">
<cfoutput>
<input type="radio" name="mode" value="save" style="height: 19px; width: 19px;">
</cfoutput>
<cfelseif #m# is not "5">
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
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Save Connection</span></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Connection Name<span style="font-weight: normal;"> (Enter a friendly name to identify this connection)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell737">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="entry_name" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#show_entry_name#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell735">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Domain Controller<span style="font-weight: normal;"> (IP Address or FQDN Host Name)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell734">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="dc_name" size="30" maxlength="100" style="width: 236px; white-space: pre;" value="#show_dc_name#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell732">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Distinguished Name <span style="font-weight: normal;">(Example: domain.com would be </span>DC=domain, DC=com<span style="font-weight: normal;">)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell733">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="fqdn_domain" size="30" maxlength="255" style="width: 236px; white-space: pre;" value="#show_fqdn_domain#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1020">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Object Class</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell1021">
                                                <table width="123" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_objectclass# is "user">

<select name="objectclass" style="height: 24px;">
  <option value="organizationalPerson">organizationalPerson</option>
  <option value="person">person</option>
  <option value="top">top</option>
  <option value="user" selected="selected">user</option>
</select>

<cfelseif #show_objectclass# is "organizationalPerson">

<select name="objectclass" style="height: 24px;">
  <option value="user">user</option>
    <option value="person">person</option>
  <option value="top">top</option>
  <option value="organizationalPerson" selected="selected">organizationalPerson</option>
</select>

<cfelseif #show_objectclass# is "person">

<select name="objectclass" style="height: 24px;">
  <option value="user">user</option>
    <option value="organizationalPerson">organizationalPerson</option>
  <option value="top">top</option>
  <option value="person" selected="selected">person</option>
</select>

<cfelseif #show_objectclass# is "top">

<select name="objectclass" style="height: 24px;">
  <option value="user">user</option>
    <option value="organizationalPerson">organizationalPerson</option>
  <option value="person" selected="selected">person</option>
  <option value="top" selected="selected">top</option>
</select>

</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1017">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Netbios Domain Name</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1018">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="netbios" size="30" maxlength="75" style="width: 236px; white-space: pre;" value="#show_netbios#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell436">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Username</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell437">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" name="username" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_username#">
</cfoutput>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell442">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Password</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell460">
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
                                              <td id="Cell764">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Schedule SMTP Address Import</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 24px;">
                                              <td id="Cell765">
                                                <table width="385" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table127" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 2px;">
                                                        <tr style="height: 24px;">
                                                          <td width="62" id="Cell766">
                                                            <table width="17" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_schedule# is "yes">
<input type="checkbox" checked="checked" id="FormsCheckbox1" name="schedule" value="yes" style="height: 13px; width: 13px;">
<cfelseif #show_schedule# is not "yes">
<input type="checkbox" id="FormsCheckbox1" name="schedule" value="yes" style="height: 13px; width: 13px;">
</cfif>&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="89" id="Cell767">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Refresh every</span></p>
                                                          </td>
                                                          <td width="234" id="Cell768">
                                                            <table width="123" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_interval# is "daily">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily" selected="selected">24 Hours</option>
</select>

<cfelseif #show_interval# is "43200">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200" selected="selected">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>

<cfelseif #show_interval# is "28800">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800" selected="selected">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>

<cfelseif #show_interval# is "14400">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400" selected="selected">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>

<cfelseif #show_interval# is "3600">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600" selected="selected">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>

<cfelseif #show_interval# is "2700">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700" selected="selected">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>

<cfelseif #show_interval# is "1800">

<select name="interval" style="height: 24px;">
  <option value="900">15 Minutes</option>
  <option value="1800" selected="selected">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
</select>


<cfelseif #show_interval# is "900">

<select name="interval" style="height: 24px;">
  <option value="900" selected="selected">15 Minutes</option>
  <option value="1800">30 Minutes</option>
  <option value="2700">45 Minutes</option>
  <option value="3600">1 Hour</option>
  <option value="14400">4 Hours</option>
  <option value="28800">8 Hours</option>
  <option value="43200">12 Hours</option>
  <option value="daily">24 Hours</option>
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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="961" id="Cell722">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="961">
                                      <tr valign="top" align="left">
                                        <td width="961" height="9"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Domain Username and/or Password. Plese try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Controller cannot be reached. Please check the IP/Host Name and ensure it's reachable via port 389</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;An undefined error has occured. Please contact support</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Connection validated. The system was able to contact the domain and obtain SMTP addresses. Please select the Save Connection radio box on top and click Submit button to permanently save you entry.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Connection Name you entered is invalid. Please do not use any special characters or spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Connection Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Controller field must not contain any special characters or spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Controller field must not be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Distinguished Name field must not contain any special characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Distinguished Name field must not be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Username field must not contain any special characters or spaces</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Username field must not be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Password field must not be empty</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "15">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Distinguished Name Root you entered is invalid. Please check your entry and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Connection saved.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "17">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Connection you are attempting to add already exists. Please try again</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "18">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Netbios Domain name you are attempting to add is invalid.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "19">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Netbios Domain name cannot be blank.</span></i></b></p>
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
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="9" height="2"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="452"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="961"><hr id="HRRule12" width="961" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text356" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Existing AD&nbsp; Connection(s)</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="72"></td>
                          <td colspan="3" width="959"><cfparam name = "m2" default = "0">

                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion15" style="height: 72px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="959">
                                    <tr valign="top" align="left">
                                      <td width="959" id="Text367" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="getconnections" datasource="#datasource#">
select * from ad_integration order by entry_name asc
</cfquery>


<cfif #getconnections.recordcount# LT 1>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);  font-size: 12px;">No Existing Active Directory Connections were found...</span></i></b></p>

<cfelseif #getconnections.recordcount# GTE 1>

<table id="Table71" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    
    <td width="48" style="background-color: rgb(241,236,236);" id="Cell764">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete</span></b></p>
    </td>
    <td width="109" style="background-color: rgb(241,236,236);" id="Cell416">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Connection Name</span></b></p>
    </td>
    <td width="112" style="background-color: rgb(241,236,236);" id="Cell402">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Domain Controller</span></b></p>
    </td>
    <td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Distinguished Name</span></b></p>
    </td>

<td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Object Class</span></b></p>
    </td>


    <td width="91" style="background-color: rgb(241,236,236);" id="Cell770">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scheduled</span></b></p>
    </td>
  </tr>
<cfoutput query="getconnections">
  <tr style="height: 19px;">

    <td id="Cell765">
      <form name="Cell765FORM" action="delete_connection.cfm" method="post">
        <input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><input type="image" id="FormsButton1" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
          </tr>
        </table>
      </form>
    </td>
    <td id="Cell406">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#entry_name#</span></p>
    </td>
    <td id="Cell407">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#dc_name#</span></p>
    </td>
    <td id="Cell408">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#fqdn_domain#</span></p>
    </td>

<td id="Cell408">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#objectclass#</span></p>
    </td>

<cfif #scheduled# is "1">
<cfif #scheduled_interval# is not "daily">
<cfset interval1=#scheduled_interval#/60>
<cfset interval2=#interval1#/60>
    <td id="Cell771">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES - #interval2# Hrs</span></p>
    </td>
<cfelseif #scheduled_interval# is "daily">

    <td id="Cell771">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES - Daily</span></p>
    </td>
</cfif>
<cfelseif #scheduled# is not "1">
    <td id="Cell771">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">NO</span></p>
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
                                      <td height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="959" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Domain Username and/or Password. Plese try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Controller cannot be reached. Please check the IP/Host Name and ensure it's reachable via port 389</span></i></b></p>
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