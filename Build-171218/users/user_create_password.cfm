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
<title>User Create Password</title>
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
var isAutoCenter = true;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=1";

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
<body style="background-color: rgb(192,192,192); background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="26"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="97" width="988"><img id="Picture3" height="97" width="988" src="./top_blue_logon2.png" border="0" alt="top_blue_logon2" title="top_blue_logon2"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="510" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion7" style="background-image: url('./middle_988.png'); height: 510px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="797">
                              <tr valign="top" align="left">
                                <td width="11" height="14"></td>
                                <td width="786"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="786" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Create User Self-Service Portal Password</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="170">
                              <tr valign="top" align="left">
                                <td width="145" height="8"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/user-self-service-portal-login/#firstime')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
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
                          <td width="957"><cfif structKeyExists(url, 'uid')>
<cfif #url.uid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.uid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset uid="#url.uid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif #url.uid# is "">
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'uid')>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>


<cfif structKeyExists(url, 'mid')>
<cfif #url.mid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.mid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset mid="#url.mid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif #url.mid# is "">
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'mid')>
<cfset mid=666>
</cfif>

<cfif structKeyExists(url, 'sid')>
<cfif #url.sid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.sid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset sid="#url.sid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>
<cfelseif #url.sid# is "">
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'sid')>
<cfset sid=666>
</cfif>

<cfif structKeyExists(url, 'dest')>
<cfif #url.dest# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.dest#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset dest="#url.dest#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>
<cfelseif #url.dest# is "">
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'dest')>
<cflocation url="/main/user_error.cfm" addtoken="no">
</cfif>

<cfparam name = "m" default = "">

<cfquery name="getemail" datasource="#datasource#">
select email, password, password_set, train_bayes, download_msg from user_settings where id like binary '#uid#' and password_set = '0'
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

<cfparam name = "show_password1" default = ""> 
<cfif IsDefined("form.password1") is "True">
<cfif form.password1 is not "">
<cfset show_password1 = form.password1>
</cfif></cfif> 

<cfparam name = "show_password2" default = ""> 
<cfif IsDefined("form.password2") is "True">
<cfif form.password2 is not "">
<cfset show_password2 = form.password2>
</cfif></cfif> 

<cfif #action# is "create">

<cfif #show_password1# is "">
<cfset step=0>
<cfset m=2>
<cfelseif #show_password1# is not "">
<cfif NOT ( len(show_password1) GTE 8)>
<cfset step=0>
<cfset m=3>
<cfelse>
<cfif REFind("[a-z]",show_password1) gte 1 and REFind("[A-Z]",show_password1) gte 1 and REFind("[0-9]",show_password1) gte 1 and
 REFind("[?!$@*()%^]",show_password1) gte 1>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m=8>
</cfif>
</cfif>
</cfif>

<cfif step is "1" and #show_password2# is "">
<cfset step=0>
<cfset m=4>
<cfelseif step is "1" and #show_password2# is not "">
<cfset step=2>
</cfif>



<cfif step is "2" and #show_password1# is not "" and #show_password2# is not "">
<cfset compare_password = Compare(#show_password1#, #show_password2#)>
<cfif #compare_password# is "1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=3>
</cfif>
</cfif>

<cfif step is "3">

<cfquery name="getrandom_512" datasource="#datasource#" result="getrandom_results">
select random_letter as random_512 from captcha_list order by RAND() limit 30
</cfquery>

<cfquery name="insert_salt_512" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="getrandom_512">#TRIM(random_512)#</cfoutput>')
</cfquery>

<cfquery name="getsalt_512" datasource="#datasource#">
select salt as salt_512 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset salt512=#getsalt_512.salt_512#>

<cfquery name="deletesalt512" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfloop index="hashCount" from="1" to="5000">
<cfset passwordHash512=Hash(show_password1 & salt512, 'SHA-512', 'UTF-8') />
</cfloop>

<cfset thePassword="#salt512##passwordHash512#" />

<cfquery name="createpassword" datasource="#datasource#">
update user_settings set password='#thePassword#', password_set = '1' where id like binary '#uid#'
</cfquery>

<cfset m=9>

<!-- /CFIF FOR STEP 3 -->
</cfif>

<!-- /CFIF FOR ACTION -->
</cfif>

<cfelseif #getemail.recordcount# LT 1>
<cflocation url="/main/user_error.cfm" addtoken="no">

<!-- /CFIF FOR GETEMAIL.RECORDCOUNT -->
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 287px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="<cfoutput>user_create_password.cfm?uid=#uid#&dest=#dest#&mid=#URLEncodedFormat(Trim(mid))#&sid=#URLEncodedFormat(Trim(sid))#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="create">
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text374" class="TextObject">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 12px; font-weight: normal;">In an effort to improve security, the system requires that all users set passwords in order to utilize any of the functionality of&nbsp; the User Self-Service Portal. Please create a password below, verify the password and click the Create Password button., Ensure the password is at least 8 characters long, includes both upper and lower case letters, numbers and any of the following special characters <a href="mailto:?!$@*()%^.">?!$@*()%^.</a> Once you have successfully created a password, the system will direct you to the login page. </span></p>
                                          <ol>
                                          </ol>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="1" height="1"></td>
                                        <td></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td height="30"></td>
                                        <td valign="middle" width="956"><hr id="HRRule10" width="956" size="1"></td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table9" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 128px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell1032">
                                                <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Email Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <cfoutput>
                                              <td id="Cell60">
                                                <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center"><cfoutput><input type="text" id="FormsEditField4" name="recipient" size="30" maxlength="30" disabled="disabled" style="width: 236px; white-space: pre;" value="#getemail.email#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                </cfoutput>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1034">
                                                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">New Password&nbsp; </span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <cfoutput>
                                                <td id="Cell62">
                                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td align="center"><input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre"></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                  </cfoutput>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1036">
                                                    <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Verify New Password</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <cfoutput>
                                                  <td id="Cell64">
                                                    <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center"><input type="password" id="FormsEditField6" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre"></td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    </cfoutput>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell84">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell90">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="205" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="changepass" value="Create Password" style="height: 24px; width: 205px;">
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
                                              <td width="957" height="8"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957" id="Text185" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the existing password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new password must be at least 8 characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must verify the new password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new passwords you entered do not match. please try again.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Portal Password Reset.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the old password you used is not correct. Please try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the password does not meet complexity requirements. Passwords must be at least 8 characters, they must contain both upper and lower case letters, numbers and any of the special characters ?!$@*()%^</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
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
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="11" height="2"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="958"><cfif #m# is "9">
                                  <table id="Table10" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 29px;">
                                    <tr style="height: 61px;">
                                      <td width="958" id="Cell1037">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td align="center"><img id="Picture4" height="61" width="75" src="./checkmark_big.png" border="0" alt="checkmark_big" title="checkmark_big"></td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                      <td id="Cell1038">
                                        <table width="958" border="0" cellspacing="0" cellpadding="0" align="left">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Congratulations! You have successfully created a password for the User Self-Service Portal. Click the button below to proceed the to the login page and login with the password you just created.</span></b></p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr style="height: 17px;">
                                      <td id="Cell1039">
                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr style="height: 40px;">
                                      <td id="Cell1040">
                                        <table width="956" border="0" cellspacing="0" cellpadding="0" align="left">
                                          <tr>
                                            <td>

                                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                                <tr align="left" valign="top">
                                                  <td>
                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                      <tr valign="top" align="left">
                                                        <td height="7"></td>
                                                      </tr>
                                                      <tr valign="top" align="left">
                                                        <td width="956">
                                                          <form name="apply_settings" action="<cfoutput>user_authenticate.cfm?uid=#uid#&dest=#dest#&mid=#URLEncodedFormat(Trim(mid))#&sid=#URLEncodedFormat(Trim(sid))#</cfoutput>" method="post">
                                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                              <tr style="height: 24px;">
                                                                <td width="956" id="Cell518">
                                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td align="center">
                                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                                          <tr>
                                                                            <td class="TextObject">
                                                                              <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Proceed to Login" style="height: 24px; width: 357px;">
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
                                  </cfif></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr valign="top" align="left">
                    <td height="49" width="988">
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