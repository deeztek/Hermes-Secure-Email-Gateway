<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Console SSL Settings</title>
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
              <td height="316" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

<cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 316px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="516">
                              <tr valign="top" align="left">
                                <td width="10" height="16"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text369" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Console SSL Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="454">
                              <tr valign="top" align="left">
                                <td width="429" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/console-ssl-settings/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="11" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="45"></td>
                          <td width="957"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfquery name="getcertmode" datasource="#datasource#">
select parameter, value from system_settings where parameter='certificate_mode'
</cfquery>

<cfparam name = "show_certificate_mode" default = "#getcertmode.value#"> 
<cfif IsDefined("form.certificate_mode") is "True">
<cfif form.certificate_mode is not "">
<cfset show_certificate_mode = form.certificate_mode>
</cfif></cfif>

<cffile action="read" file="/opt/hermes/ssl/hermes.cer" variable="certificatefile">
<cffile action="read" file="/opt/hermes/ssl/hermes.key" variable="keyfile">
<cffile action="read" file="/opt/hermes/ssl/hermes.chain.cer" variable="chainfile">

<cfparam name = "show_certificate" default = "#certificatefile#"> 
<cfif IsDefined("form.certificate") is "True">
<cfset show_certificate = form.certificate>
</cfif>

<cfparam name = "show_key" default = "#keyfile#"> 
<cfif IsDefined("form.key") is "True">
<cfset show_key = form.key>
</cfif>

<cfparam name = "show_chain" default = "#chainfile#"> 
<cfif IsDefined("form.chain") is "True">
<cfset show_chain = form.chain>
</cfif>

<cfif #action# is "import">
<cfif #show_certificate_mode# is "specified">

<cfif #show_certificate# is "">
<cfset m=1>
<cfset step=0>
<cfelseif #show_certificate# is not "">
<cfset step=1>
</cfif>

<cfif step is "1" and #show_key# is "">
<cfset m=2>
<cfset step=0>
<cfelseif step is "1" and #show_key# is not "">
<cfset step=2>
</cfif>

<cfif step is "2" and #show_chain# is "">
<cfset m=3>
<cfset step=0>
<cfelseif step is "2" and #show_chain# is not "">
<cfset step=3>
</cfif>

<cfif step is "3">

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

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.cer"
    output = "#show_certificate#"> 
    
    
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.chain.cer"
    output = "#show_chain#">


<cffile action="read" file="/opt/hermes/scripts/verify_certificate.sh" variable="verify">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
    output = "#REReplace("#verify#","CHAINFILE","/opt/hermes/tmp/#customtrans3#_hermes.chain.cer","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_verify_certificate.sh" variable="verify">
       
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
    output = "#REReplace("#verify#","CERTIFICATEFILE","/opt/hermes/tmp/#customtrans3#_hermes.cer","ALL")#"> 
    
       
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh"
arguments="-inputformat none"
outputfile="/opt/hermes/tmp/#customtrans3#_output"
timeout = "120">
</cfexecute>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_output" variable="check">

<cfif FindNoCase("hermes.cer: OK", check)>
    
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh">
    
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_output">
    
<cfset step=4>

<cfelse>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.cer">
    
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_hermes.chain.cer">
    
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_verify_certificate.sh">
    
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_output">
    
<cfset step=0>
<cfset m=5>
</cfif>

</cfif>


<cfif step is "4">
<cfquery name="updatesettings" datasource="#datasource#">
update system_settings set value='specified' where parameter='certificate_mode'
</cfquery>

<cfexecute name = "/bin/mv"
arguments="/opt/hermes/tmp/#customtrans3#_hermes.cer /opt/hermes/ssl/hermes.cer"
timeout = "60">
</cfexecute>


<cfexecute name = "/bin/mv"
arguments="/opt/hermes/tmp/#customtrans3#_hermes.chain.cer /opt/hermes/ssl/hermes.chain.cer"
timeout = "60">
</cfexecute>
    
<cffile action = "write"
    file = "/opt/hermes/ssl/hermes.key"
    output = "#show_key#">
    
<cfexecute name = "/bin/cp"
arguments="/opt/hermes/conf_files/hermes-ssl.SPECIFIED /etc/apache2/sites-available/hermes-ssl.conf"
timeout = "60">
</cfexecute>

<!--- Run Dos2Unix on /opt/hermes/ssl/hermes.cer --->
<cfexecute name = "/usr/bin/dos2unix"
arguments="/opt/hermes/ssl/hermes.cer"
timeout = "60">
</cfexecute>

<!--- Run Dos2Unix on /opt/hermes/ssl/hermes.chain.cer --->
<cfexecute name = "/usr/bin/dos2unix"
arguments="/opt/hermes/ssl/hermes.chain.cer"
timeout = "60">
</cfexecute>

<!--- Run Dos2Unix on /opt/hermes/ssl/hermes.key --->
<cfexecute name = "/usr/bin/dos2unix"
arguments="/opt/hermes/ssl/hermes.key"
timeout = "60">
</cfexecute>


<cfexecute name = "/etc/init.d/apache2"
arguments="reload"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfset m=4>    
   
</cfif>

<cfelseif #show_certificate_mode# is "self">
<cfquery name="updatesettings" datasource="#datasource#">
update system_settings set value='self' where parameter='certificate_mode'
</cfquery>

<cfexecute name = "/bin/cp"
arguments="/opt/hermes/conf_files/hermes-ssl.SELF /etc/apache2/sites-available/hermes-ssl.conf"
timeout = "60">
</cfexecute>

<cfexecute name = "/etc/init.d/apache2"
arguments="reload"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfset m=4>

</cfif>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion19" style="height: 45px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="648">
                                    <tr valign="top" align="left">
                                      <td height="38" width="648">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_certificate_mode# is "self">
<cfoutput>
<input type="radio" name="certificate_mode" value="self" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_certificate_mode# is not "self">
<cfoutput>
<input type="radio" name="certificate_mode" value="self" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Built-in Self Signed SSL Certificate</b> (Default)</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_certificate_mode# is "specified">
<cfoutput>
<input type="radio" name="certificate_mode" value="specified" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_certificate_mode# is not "specified">
<cfoutput>
<input type="radio" name="certificate_mode" value="specified" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">3rd Party Specified SSL Certificate</span></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="955"><hr id="HRRule3" width="955" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="976">
                        <tr valign="top" align="left">
                          <td width="12" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="179"></td>
                          <td width="964">
                            <table border="0" cellspacing="0" cellpadding="0" width="964" id="LayoutRegion17" style="height: 179px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="certform" enctype="multipart/form-data" action="console_ssl_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="import"><input type="hidden" name="certificate_mode" value="<cfoutput>#show_certificate_mode#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 145px;">
                                            <tr style="height: 14px;">
                                              <td width="949" id="Cell908">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Paste Contents of Certificate <span style="font-weight: normal;"> <span style="font-size: 10px;">(Include -----BEGIN CERTIFICATE----- &amp; -----END CERTIFICATE----- lines)</span></span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1057">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_certificate_mode# is "specified">
<textarea name="certificate" wrap="physical" rows="10" cols="65">
<cfoutput>
#show_certificate#
</cfoutput>
</textarea>
<cfelseif #show_certificate_mode# is "self">
<textarea name="certificate" wrap="physical" rows="10" cols="65" disabled="disabled">
<cfoutput>
#show_certificate#
</cfoutput>
</textarea>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1052">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Paste Contents of Unencrypted Key&nbsp; <span style="font-size: 10px; font-weight: normal;">(Include -----BEGIN CERTIFICATE----- &amp; -----END CERTIFICATE----- lines)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1053">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_certificate_mode# is "specified">
<textarea name="key" wrap="physical" rows="10" cols="65">
<cfoutput>
#show_key#
</cfoutput>
</textarea>
<cfelseif #show_certificate_mode# is "self">
<textarea name="key" wrap="physical" rows="10" cols="65" disabled="disabled">
<cfoutput>
#show_key#
</cfoutput>
</textarea>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1054">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Paste Contents of Root and Int CA Certificate <span style="font-size: 10px; font-weight: normal;">(Include -----BEGIN CERTIFICATE----- &amp; -----END CERTIFICATE----- lines)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1055">
                                                <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_certificate_mode# is "specified">
<textarea name="chain" wrap="physical" rows="10" cols="65">
<cfoutput>
#show_chain#
</cfoutput>
</textarea>
<cfelseif #show_certificate_mode# is "self">
<textarea name="chain" wrap="physical" rows="10" cols="65" disabled="disabled">
<cfoutput>
#show_chain#
</cfoutput>
</textarea>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1056">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1018">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="943" style="height: 17px;">
                                                        <tr style="height: 17px;">
                                                          <td width="943" id="Cell815">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center">
                                                                  <table width="267" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Applying, please wait...';this.form.submit();" name="savechanges" value="Save & Apply Changes" style="height: 24px; width: 160px;">


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
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="954">
                                      <tr valign="top" align="left">
                                        <td width="954" height="17"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Certificate field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Unencrypted Key field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Root and Int CA Certificate field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings Updated. You must restart your web browser in order to see your changes</span></i></b></p><br>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Certificate and Root and Int CA Certificate you entered have failed validation. Please verify the contents you entered and try again</span></i></b></p>
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