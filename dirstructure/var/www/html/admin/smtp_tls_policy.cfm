<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SMTP TLS Policy</title>
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
              <td height="841" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion23" style="background-image: url('./middle_988.png'); height: 841px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="11" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text482" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">SMTP TLS Policy</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/smtp-tls-policy/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="9" height="9"></td>
                          <td width="959"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="959" id="Text464" class="TextObject">
                            <p style="text-align: justify; margin-bottom: 0px;"><span style="font-size: 12px;">Transport Layer Security (TLS) provides certificate-based authentication and encryption over SMTP email. For the absolute best security, it is highly recommended to utilize a combination of S/MIME or PDF encrypted email along with TLS encryption. Below you can add/delete domains along with the desired TLS encryption method in order to build a system TLS policy. For any domains that you add to the TLS policy, the system will force TLS encryption when attempting to deliver email to that domain. If TLS encryption is not successful when attempting delivery, email will be deferred, so it&#8217;s imperative to determine if the domain supports TLS encryption beforehand. The easiest way to accomplish that is by sending a test email to the remote domain and then navigating to <a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;" href="system_logs.cfm"><b>System --&gt; System Logs</b></a> from the system menu and searching for the string <b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Host offered STARTTLS: [server.remotedomain.tld]</span></b> where <b>server.remotedomain.tld</b> is the domain&#8217;s receiving email server. </span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="9" height="11"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                          <td width="2"></td>
                          <td width="2"></td>
                          <td width="497"></td>
                          <td width="3"></td>
                          <td width="446"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="7" width="506" id="Text351" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add domain to the SMTP TLS Policy</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="12" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="237"></td>
                          <td colspan="10" width="957"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">

<cfparam name = "m3" default = ""> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif>

<cfparam name = "step" default = "0"> 


<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "method" default = ""> 
<cfif IsDefined("form.method") is "True">
<cfif form.method is not "">
<cfset method = form.method>
</cfif></cfif> 

<cfparam name = "domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfparam name = "policy" default = ""> 
<cfif IsDefined("form.policy") is "True">
<cfif form.policy is not "">
<cfset policy = form.policy>
</cfif></cfif> 


                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion5" style="height: 237px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="957">
                                    <tr valign="top" align="left">
                                      <td height="111" width="957"><cfif #action# is "add">

<cfif #domain# is not "">
<cfset step=1>
<cfelseif #domain# is "">
<cfset step=0>
<cfset m=1>
</cfif>


<cfif step is "1">
<cfset temp_email="bob@#domain#">
<cfif IsValid("email", temp_email)>
<cfset step=2>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>



<cfif step is "2">

<cfquery name="checkexists" datasource="#datasource#">
SELECT domain from tls_policies where domain = '#domain#'
</cfquery>

<cfif #checkexists.recordcount# LT 1>

<cfquery name="insert" datasource="#datasource#">
insert into tls_policies
(domain, method, applied, action)
values
('#domain#', '#method#', '2', 'add')
</cfquery>

<cfset m=3>

<cfelseif #checkexists.recordcount# GTE 1>
<cfset step=0>
<cfset m=4>

</cfif>

</cfif>

</cfif>



<cfif #action# is "canceladd">
<cfquery name="delete" datasource="#datasource#">
delete from tls_policies where applied = '2' and action = 'add'
</cfquery>
<cfset m=5>
</cfif>






                                        <form name="domain" action="smtp_tls_policy.cfm" method="post">
                                          <input type="hidden" name="action" value="add">
                                          <table border="0" cellspacing="0" cellpadding="0" width="600">
                                            <tr valign="top" align="left">
                                              <td colspan="2" width="472" id="Text424" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Domain Name</span></p>
                                              </td>
                                              <td colspan="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="2"></td>
                                              <td width="32"></td>
                                              <td width="118"></td>
                                              <td width="10"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="22" width="440"><input type="text" id="FormsEditField39" name="domain" size="55" maxlength="255" style="width: 436px; white-space: pre;"></td>
                                              <td colspan="3"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="4" height="8"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="4" width="600" id="Text423" class="TextObject"><address style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-style: normal;"><span style="font-size: 12px; color: rgb(128,128,128);">Select the TLS encryption method</span></span></address></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="4" height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="21" colspan="3" width="590" id="Text403" class="TextObject">
                                                <p style="margin-bottom: 0px;"><select name="method" style="height: 24px;">
<option value="encrypt">Encrypt Only</option>
</select>
&nbsp;</p>
                                              </td>
                                              <td></td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="4"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957">
                                                <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="957" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="957" id="Cell934">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="957">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="957"><hr id="HRRule8" width="957" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="609">
                                    <tr valign="top" align="left">
                                      <td width="600" height="1"></td>
                                      <td width="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="600" id="Text462" class="TextObject"><address style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; font-style: normal;">Domains to be added to the SMTP TLS Policy</span></b></address></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="609" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_added" datasource="#datasource#">
select * from tls_policies where action='add' and applied='2' order by domain asc
</cfquery>
<cfif #get_added.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_added">
<cfif #method# is "encrypt">
<option value="#id#">#domain# ---> Encrypt Only ---> TO BE ADDED</option>
<cfelseif #method# is "secure">
<option value="#id#">#domain# ---> Encrypt & Verify ---> TO BE ADDED</option>
</cfif>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Domains found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="957">
                                        <form name="Table127FORM" action="smtp_tls_policy.cfm" method="post">
                                          <input type="hidden" name="action" value="canceladd">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="957" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="957" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #get_added.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_added.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" disabled="disabled">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="957">
                                    <tr valign="top" align="left">
                                      <td width="957" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="957" id="Text459" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain Name you entered is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Domain set to be added. Please ensure you click on Apply Settings below for your changes to take effect</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Domain Name you entered already exists or is already set to be added</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All TLS Policy Add actions have been cancelled</span></i></b></p>
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
                        <tr valign="top" align="left">
                          <td colspan="12" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="9" valign="middle" width="956"><hr id="HRRule9" width="956" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="12" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4"></td>
                          <td colspan="5" width="506" id="Text415" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Existing domains in&nbsp; the SMTP TLS Policy</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="12" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="178"></td>
                          <td colspan="5" width="950"><cfif #action# is "delete">

<cfif #policy# is "">
<cfset m2=1>

<cfelse>
<cfquery name="checkexists" datasource="#datasource#">
SELECT id from tls_policies where id = '#policy#'
</cfquery>

<cfif #checkexists.recordcount# GTE 1>
<cfquery name="delete" datasource="#datasource#">
update tls_policies set applied = '2', action = 'delete' where id = '#policy#'
</cfquery>

<cfset m2=2>

<cfelseif #checkexists.recordcount# LT 1>
<cfset m2=3>
</cfif>

</cfif>
</cfif>

<cfif #action# is "canceldelete">
<cfquery name="delete" datasource="#datasource#">
update tls_policies set applied = '1', action = NULL where action = 'delete' and applied = '2'
</cfquery>
<cfset m2=4>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion4" style="height: 178px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td height="50" width="950">
                                        <form name="delete" action="smtp_tls_policy.cfm" method="post">
                                          <input type="hidden" name="action" value="delete">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="614">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="614" style="height: 50px;">
                                                  <tr style="height: 24px;">
                                                    <td width="614" id="Cell7">
                                                      <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfquery name="getpolicies" datasource="#datasource#">
select id, domain, method from tls_policies where applied = '1' order by domain asc
</cfquery>

<cfif #getpolicies.recordcount# GTE 1>
<select name="policy" style="height: 88px;" size="300">
<cfoutput query="getpolicies">
<cfif #method# is "secure">
<option value="#id#">#domain# ---> Encrypt & Verify</option>
<cfelseif #method# is "encrypt">
<option value="#id#">#domain# ---> Encrypt Only</option>
</cfif>
</cfoutput>
</select>
<cfelse>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Exising Domains found...</span></i></b></p>
</cfif>
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 26px;">
                                                    <td id="Cell1">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #getpolicies.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="950"><hr id="HRRule10" width="950" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="600">
                                    <tr valign="top" align="left">
                                      <td width="600" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="600" id="Text463" class="TextObject"><address style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-style: normal;"><span style="font-size: 12px;">Domains to be deleted from the SMTP TLS Policy</span></span></b></address></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="950" id="Text417" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_deleted" datasource="#datasource#">
select * from tls_policies where action='delete' and applied='2' order by domain asc
</cfquery>
<cfif #get_deleted.recordcount# GTE 1>
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_deleted">
<cfif #method# is "encrypt">
<option value="#id#">#domain# ---> Encrypt Only --> TO BE DELETED</option>
<cfelseif #method# is "secure">
<option value="#id#">#domain# ---> Encrypt & Verify --> TO BE DELETED</option>
</cfif>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Domains found to be deleted..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <form name="Table127FORM" action="smtp_tls_policy.cfm" method="post">
                                          <input type="hidden" name="action" value="canceldelete">
                                          <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="950" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="950" id="Cell875">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #get_deleted.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_deleted.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" disabled="disabled">
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="8"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Domain set to be deleted. Please ensure you click the Apply Settings button for your changes to take effect</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;System Error has occured. Please contact support at support@deeztek.com</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All TLS Policy Delete actions have been cancelled</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="12" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="30"></td>
                          <td colspan="5" valign="middle" width="949"><hr id="HRRule12" width="949" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="12" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="46"></td>
                          <td colspan="4" width="947"><cfif #action# is "apply">
<cfquery name="delete" datasource="#datasource#">
delete from tls_policies where applied='2' and action='delete'
</cfquery>

<cfquery name="add" datasource="#datasource#">
update tls_policies set applied = '1' where applied='2' and action='add'
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


<cfquery name="policies" datasource="#datasource#">
SELECT domain, method from tls_policies where applied = '1' order by domain asc
</cfquery>


<cfif #policies.recordcount# GTE 1>
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
    output = ""
    addNewLine = "no">
<cfloop query="policies">

<cfoutput>
<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
    output = "#domain# #method#"
    addNewLine = "yes">
</cfoutput>

</cfloop>

<cfelseif #policies.recordcount# LT 1>
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
    output = ""
    addNewLine = "no">
</cfif>


<cfset command="/bin/cp /etc/postfix/tls_policy /etc/postfix/tls_policy.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#_tls_policy /etc/postfix/tls_policy#chr(10)#/usr/sbin/postmap /etc/postfix/tls_policy#chr(10)#/etc/init.d/postfix reload#chr(10)#/etc/init.d/postfix restart">

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "#command#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "120">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh">
    
<cflocation url="smtp_tls_policy.cfm?m3=16">
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="947" id="LayoutRegion17" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="947">
                                        <form name="apply_settings" action="smtp_tls_policy.cfm" method="post">
                                          <input type="hidden" name="action" value="apply">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="947" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="947" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from tls_policies where applied='2' 
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="947">
                                    <tr valign="top" align="left">
                                      <td width="947" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="947" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m3# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "applied">
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