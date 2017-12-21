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
<title>Password</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({selector:'textarea',
readonly: true,
  toolbar: false,
  menubar: false,
  statusbar: false
});
</script>

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

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
<body style="background-color: rgb(192,192,192); background-image: none; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu_users',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu_users.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="130" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./top_blue_3.png'); height: 130px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="887">
                        <tr valign="top" align="left">
                          <td width="132" height="101"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="19"></td>
                          <td width="755"><!--<img id="AllWebMenusComponent1" height="19" width="755" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu_users.js' AWMJSPATH='./hermes_seg_menu_users.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu_users'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="510" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion7" style="background-image: url('./middle_988.png'); height: 510px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="744">
                              <tr valign="top" align="left">
                                <td width="11" height="14"></td>
                                <td width="733"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="733" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Change User Self-Service Portal Password</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="223">
                              <tr valign="top" align="left">
                                <td width="198" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/password/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
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
                          <td height="399"></td>
                          <td width="957"><cfparam name = "m" default = "0">
<cfparam name = "step" default = "0">

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "show_old_password" default = ""> 
<cfif IsDefined("form.old_password") is "True">
<cfif form.old_password is not "">
<cfset show_old_password = form.old_password>
</cfif></cfif>

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

<cfif #action# is "changepassword">

<cfif #show_old_password# is not "">
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m=1>
</cfif>

<cfif step is "1" and #show_old_password# is not "">
<cfquery name="getoldpassword" datasource="#datasource#">
select password from user_settings where id='#session.uid#'
</cfquery>

<cfset oldSalt="#Left(getoldpassword.password, 30)#">

<cfloop index="hashCount" from="1" to="5000">
<cfset oldpasswordHash512=Hash(show_old_password & oldSalt, 'SHA-512', 'UTF-8') />
</cfloop>

<cfset oldPassword="#oldSalt##oldpasswordHash512#" />


<cfset compare_password = Compare(#getoldpassword.password#, #oldPassword#)>
<cfif #compare_password# is "1">
<cfset m=7>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=7>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=2>
</cfif>
<!-- /CFIF FOR STEP 1 -->
</cfif>

<cfif step is "2" and #show_password1# is "">
<cfset step=0>
<cfset m=2>
<cfelseif step is "2" and #show_password1# is not "">
<cfif NOT ( len(show_password1) GTE 8)>
<cfset step=0>
<cfset m=3>
<cfelse>
<cfif REFind("[a-z]",show_password1) gte 1 and REFind("[A-Z]",show_password1) gte 1 and REFind("[0-9]",show_password1) gte 1 and
 REFind("[?!$@*()%^]",show_password1) gte 1>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m=8>
</cfif>
</cfif>
<!-- /CFIF FOR STEP 2 -->
</cfif>

<cfif step is "3" and #show_password2# is "">
<cfset step=0>
<cfset m=4>
<cfelseif step is "3" and #show_password2# is not "">
<cfset step=4>
<!-- /CFIF FOR STEP 3 -->
</cfif>



<cfif step is "4" and #show_password1# is not "" and #show_password2# is not "">
<cfset compare_password = Compare(#show_password1#, #show_password2#)>
<cfif #compare_password# is "1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=5>
</cfif>
<!-- /CFIF FOR STEP 4 -->
</cfif>

<cfif step is "5">
<cfset m=6>
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

<cfquery name="updatepassword" datasource="#datasource#">
update user_settings set password='#thePassword#' where id='#session.uid#'
</cfquery>

<cfquery name="getsettings" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getsettings.value#" to="#session.email#" server="localhost" subject="Your Hermes SEG User Self-Service Portal Password has been changed" port="10026">
*** Please do not reply to this email. This email account is not monitored ***

This is an automatic notification that someone, hopefully you,  has changed your Hermes SEG User Self-Service Portal Password. If you made this change, you do not need to do
 anything further and you can safely delete this message.
  
If you did NOT request the change of your Hermes SEG User Self-Service Portal password, please contact your system Administrator immediately.
 
</cfmail>


<!-- /CFIF FOR STEP 5 -->
</cfif>

<!-- /CFIF FOR ACTION -->
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 399px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="user_change_password.cfm" method="post">
                                    <input type="hidden" name="action" value="changepassword">
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text374" class="TextObject">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 12px; font-weight: normal;">Please enter your <b>Old Password</b>, specify a <b>New Password</b> and then <b>Verify the New Password</b> and click the <b>Change Password</b> button. Ensure the password is at least 8 characters long, includes both upper and lower case letters, numbers and any of the following special characters <a href="mailto:?!$@*()%^.">?!$@*()%^.</a> </span></p>
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
                                        <td height="4"></td>
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
                                                      <td align="center"><cfoutput><input type="text" id="FormsEditField4" name="email" size="30" maxlength="30" disabled="disabled" style="width: 236px; white-space: pre;" value="#session.email#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                </cfoutput>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1041">
                                                  <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Old Password&nbsp; </span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell1042">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center"><input type="password" id="FormsEditField7" name="old_password" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre"></td>
                                                    </tr>
                                                  </table>
                                                </td>
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
                                                                  <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="changepass" value="Change Password" style="height: 24px; width: 205px;">
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
                                              <td width="957" height="6"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957" id="Text185" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Old Password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the New Password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the New Password must be at least 8 characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;you must Verify the New Password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the new passwords you entered do not match. please try again.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Your password has been changed. Please logout and login with your new password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the old password you used is not correct. Please try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the password does not meet complexity requirements. Passwords must be at least 8 characters, they must contain both upper and lower case letters, numbers and any of the special characters ?!$@*()%^</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./bottom_988.png'); height: 49px;">
                        <tr align="left" valign="top">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="979">
                              <tr valign="top" align="left">
                                <td width="979" height="13"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="979" id="Text464" class="TextObject">
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