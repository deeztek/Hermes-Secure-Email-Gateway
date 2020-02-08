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
<title>User Forgot Password</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
<script type="text/javascript">
<!--
var hwndPopup_27b5;
function openpopup_27b5(url){
var popupWidth = 800;
var popupHeight = 600;
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
<body style="margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="989">
            <tr valign="top" align="left">
              <td width="1" height="24"></td>
              <td width="987"></td>
              <td width="1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="97" colspan="2" width="988"><img id="Picture3" height="97" width="988" src="./top_blue_logon2_1.png" border="0" alt="top_blue_logon2" title="top_blue_logon2"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td colspan="3" height="1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="581" colspan="2" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion7" style="background-image: url('./middle_988.png'); height: 581px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="828">
                              <tr valign="top" align="left">
                                <td width="11" height="14"></td>
                                <td width="817"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="817" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Forgot User Self-Service Portal Password</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="139">
                              <tr valign="top" align="left">
                                <td width="114" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/user-self-service-portal-login/#forgotpassword')"><img id="Picture2" height="25" width="25" src="./help_1.png" border="0" alt="Online Help" title="Online Help"></a></td>
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
                          <td height="287"></td>
                          <td width="957"><cfif structKeyExists(form, 'uid')>
<cfif #form.uid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#form.uid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset uid="#form.uid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="user_error.cfm" addtoken="no">
</cfif>

<cfelseif #form.uid# is "">
<cflocation url="user_error.cfm" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(form, 'uid')>
<cflocation url="user_error.cfm" addtoken="no">
</cfif>

<cfparam name = "m" default = "">

<cfquery name="getemail" datasource="#datasource#">
select email, password, password_set, train_bayes, download_msg from user_settings where id like binary '#uid#'
</cfquery>

<cfif #getemail.recordcount# GTE 1>

<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "reason" default = "">
<cfif IsDefined("session.reason") is "True">
<cfset reason = #session.reason#>
</cfif> 

<cfparam name = "thecode" default = ""> 
<cfif IsDefined("form.thecode") is "True">
<cfif form.thecode is not "">
<cfset thecode = form.thecode>
</cfif></cfif> 



<cfif #action# is "sendcode">

<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 10
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

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>


<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">


<cfquery name="insertpasswordcode" datasource="#datasource#">
update user_settings 
set
reset_password_code='#gettrans.customtrans2#', 
reset_password_datetime='#datenow# #timenow#', 
reset_password_ip='#GetHttpRequestData().headers['X-Forwarded-For']#'
where id='#uid#'
</cfquery>

<cfquery name="getsettings" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getsettings.value#" to="#getemail.email#" server="localhost" subject="Your Hermes SEG User Self-Service Portal Code" port="10026">
*** Please do not reply to this email. This email account is not monitored ***

Someone, hopefully you, has requested to reset you Hermes SEG User Self-Service Portal Password. If you requested this change, please copy and paste the code below in the Forgot User Self-Service Portal Password Code browser window and click the Verify Code button.
 
#gettrans.customtrans2#

If you did NOT request the reset of your Hermes SEG User Self-Service Portal password, you do not need to do anything and you can safely delete this message.
 
</cfmail>

<cflocation url="user_password_code.cfm?uid=#uid#" addtoken="no">

<!-- /CFIF FOR ACTION -->
</cfif>

<cfelseif #getemail.recordcount# LT 1>
<cflocation url="/main/user_error.cfm" addtoken="no">

<!-- /CFIF FOR GETEMAIL.RECORDCOUNT -->
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 287px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="957">
                                    <tr valign="top" align="left">
                                      <td colspan="3" width="957" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; font-weight: normal;">Please click the button below to reset your Self-Service Portal password. The system will send you an email with a special code. Follow the instructions in the email to reset your password.. </span></p>
                                        <ol>
                                        </ol>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" colspan="2" valign="middle" width="956"><hr id="HRRule10" width="956" size="1"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="1" height="2"></td>
                                      <td width="955"></td>
                                      <td width="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="40"></td>
                                      <td colspan="2" width="956"><cfoutput>
                                        <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                          <tr align="left" valign="top">
                                            <td>
                                              <table border="0" cellspacing="0" cellpadding="0">
                                                <tr valign="top" align="left">
                                                  <td height="7"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td width="956">
                                                    <form name="send_code" action="user_forgot_password.cfm" method="post">
                                                      <input type="hidden" name="action" value="sendcode"><input type="hidden" name="uid" value="#uid#">
                                                      <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                        <tr style="height: 24px;">
                                                          <td width="956" id="Cell518">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center">
                                                                  <table width="419" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Send Code" style="height: 24px; width: 357px;">
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
                                        </cfoutput></td>
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
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td height="49"></td>
              <td colspan="2" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion23" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="979">
                        <tr valign="top" align="left">
                          <td width="979" height="13"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="979" id="Text439" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,255,255);"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfoutput>
<span style="font-size: 12px; color: rgb(255,255,255);">Hermes Secure Email Gateway #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved.</span></cfoutput></span>&nbsp;</p>
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