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
<title>User Authenticate</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script type="text/javascript" src="./validation.js">
</script>
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="989">
            <tr valign="top" align="left">
              <td height="26"></td>
              <td width="1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="97" width="988"><img id="Picture3" height="97" width="988" src="./top_blue_logon2.png" border="0" alt="top_blue_logon2" title="top_blue_logon2"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td colspan="2" height="1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="301" colspan="2" width="989"><cfif structKeyExists(url, 'uid')>
<cfif #url.uid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.uid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset uid="#url.uid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm?error=Keyword in UID" addtoken="no">
</cfif>

<cfelseif #url.uid# is "">
<cflocation url="/main/user_error.cfm?error=UID is empty" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'uid')>
<cflocation url="/main/user_error.cfm?error=UID does NOT exist" addtoken="no">
</cfif>


<cfif structKeyExists(url, 'mid')>
<cfif #url.mid# is not "">

<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#url.mid#') and banned='1'
</cfquery>

<cfif #checkkeywords.recordcount# LT 1>
<cfset mid="#url.mid#">
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="/main/user_error.cfm?error=Keyword in MID" addtoken="no">
</cfif>

<cfelseif #url.mid# is "">
<cflocation url="/main/user_error.cfm?error=MID is empty" addtoken="no">
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
<cflocation url="/main/user_error.cfm?error=Keyword in SID" addtoken="no">
</cfif>
<cfelseif #url.sid# is "">
<cflocation url="/main/user_error.cfm?error=SID is empty" addtoken="no">
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
<cflocation url="/main/user_error.cfm?error=Keyword in DEST" addtoken="no">
</cfif>
<cfelseif #url.dest# is "">
<cflocation url="/main/user_error.cfm?error=DEST is empty" addtoken="no">
</cfif>

<cfelseif NOT structKeyExists(url, 'dest')>
<cflocation url="/main/user_error.cfm?error=DEST does NOT exist" addtoken="no">
</cfif>


<cfquery name="getemail" datasource="#datasource#">
select email, password, password_set, train_bayes, download_msg from user_settings where id like binary '#uid#'
</cfquery>

<cfif #getemail.recordcount# GTE 1>
<cfif #getemail.password_set# is "0">
<cflocation url="/main/user_create_password.cfm?uid=#uid#&dest=#dest#&mid=#mid#&sid=#sid#" addtoken="no">
</cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "reason" default = "">
<cfif IsDefined("session.reason") is "True">
<cfset reason = #session.reason#>
</cfif> 

<cfparam name = "logoncount" default = "1"> 
<cfif IsDefined("session.logoncount") is "True">
<cfset logoncount = #session.logoncount#>
</cfif>

<cfif #action# is "login">

<cfif #logoncount# GT 10>
<CFSET session.reason = 'You have exceeded the maximum number of logons. Please wait 1 hour before trying again'>
<CFLOCATION url="user_authenticate.cfm?uid=#uid#&dest=#dest#&mid=#mid#&sid=#sid#" addtoken="no">

<cfelseif #logoncount# LTE 10>
<CFSET session.UserLoggedin = FALSE>

<cfquery name="getpassword" datasource="#datasource#">
select email, password from user_settings where id like binary '#uid#'
</cfquery>

<cfset theSalt="#Left(getpassword.password, 30)#">

<cfloop index="hashCount" from="1" to="5000">
<cfset passwordHash512=Hash(form.password & theSalt, 'SHA-512', 'UTF-8') />
</cfloop>


<cfset thePassword="#theSalt##passwordHash512#" />

<cfset compare_password = Compare(#thePassword#, #getpassword.password#)>

<cfif #compare_password# is "1">

<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 10'>
<CFLOCATION url="user_authenticate.cfm?uid=#uid#&dest=#dest#&mid=#mid#&sid=#sid#" addtoken="no">


<cfelseif #compare_password# is "-1">
<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 10'>
<CFLOCATION url="user_authenticate.cfm?uid=#uid#&dest=#dest#&mid=#mid#&sid=#sid#" addtoken="no">

<cfelseif #compare_password# is "0">
<cfset session.UserLoggedin = true>
<cfset session.logoncount = 1>

<cfquery name="getid" datasource="#datasource#">
select id from maddr where email='#getpassword.email#'
</cfquery>

<cfset session.owner = #getid.id#>
<cfset session.email = #getemail.email#>
<cfset session.uid = #uid#>
<cfset session.train_bayes = #getemail.train_bayes#>
<cfset session.download_msg = #getemail.download_msg#>
<cfset session.reason = "">

<cfquery name="getdestination" datasource="#datasource#">
select destination from user_destinations where id='#dest#'
</cfquery>

<cfif #dest# is "7">
<cflocation url="#getdestination.destination#?mid=#URLEncodedFormat(Trim(mid))#" addtoken="no">
<cfelseif #dest# is "8">
<cflocation url="#getdestination.destination#?mid=#URLEncodedFormat(Trim(mid))#&sid=#URLEncodedFormat(Trim(sid))#" addtoken="no">
<cfelse>
<cflocation url="#getdestination.destination#" addtoken="no">
</cfif>

<!-- /CFIF FOR COMPAREPASSWORD -->
</cfif>


<!-- /CFIF FOR LOGONCOUNT -->
</cfif>

<!-- /CFIF FOR ACTION -->
</cfif>

<cfelseif #getemail.recordcount# LT 1>
<cflocation url="/main/user_error.cfm" addtoken="no">

<!-- /CFIF FOR GETEMAIL.RECORDCOUNT -->
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="989" id="LayoutRegion34" style="background-image: url('./middle_988.png'); height: 301px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="614" height="35"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="354">
                            <form name="Table91FORM" action="/main/user_forgot_password.cfm" method="post">
                              <input type="hidden" name="uid" value="<cfoutput>#uid#</cfoutput>">
                              <table id="Table91" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 23px;">
                                <tr style="height: 23px;">
                                  <td width="354" id="Cell519">
                                    <table width="229" border="0" cellspacing="0" cellpadding="0" align="right">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="text-align: right; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Forgot Password?" style="height: 24px; width: 142px;">
&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    &nbsp;</td>
                                </tr>
                              </table>
                            </form>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="13" height="6"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955">
                            <script type="text/javascript">
                            <!--
                            function __fv1_logon(form) {
                             var args = {
                            "username":[["NOF_isRequired", [''], "A username is required", "", ""], ["NOF_isLengthInRange", ['1', '30'], "The username must be a min of 1 character and a maximum of 30 characters", "", ""]],
                            "password":[["NOF_isRequired", [''], "A password is required", "", ""], ["NOF_isLengthInRange", ['8', '30'], "The password must be a minimum of 8 characters and a maximum of 30 characters", "", ""]]
                             };
                             return NOF_validateForm(form, args, true, null,'Please correct the following errors:');
                            }
                            //-->
                            </script>
                            <form name="logon" action="<cfoutput>user_authenticate.cfm?uid=#uid#&dest=#dest#&mid=#URLEncodedFormat(Trim(mid))#&sid=#URLEncodedFormat(Trim(sid))#</cfoutput>" method="post" onSubmit="return __fv1_logon(this)">
                              <input type="hidden" name="action" value="login">
                              <table id="Table4" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 141px;">
                                <tr style="height: 18px;">
                                  <td width="955" id="Cell10">
                                    <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">User Self-Service Portal</span></b></p>
                                  </td>
                                </tr>
                                <tr style="height: 18px;">
                                  <td id="Cell11">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="198" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">E-Mail Address</span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr style="height: 28px;">
                                  <td id="Cell16">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center"><cfoutput><input type="text" id="FormsEditField1" name="username" size="25" maxlength="30" disabled="disabled" style="width: 196px; white-space: pre;" value="#getemail.email#"></cfoutput></td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr style="height: 18px;">
                                  <td id="Cell13">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="198" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Password</span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr style="height: 28px;">
                                  <td id="Cell14">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center"><input type="password" id="FormsEditField2" name="password" size="25" maxlength="30" style="width: 196px; white-space: pre;" style="white-space:pre"></td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr style="height: 31px;">
                                  <td id="Cell17">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="562" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Logon" style="height: 24px; width: 142px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="4"></td>
                          <td width="955"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955" id="Text11" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><cfoutput>

<P STYLE="text-align: center;"><SPAN STYLE="font-size: x-small; color: rgb(255,0,0); FACE="Arial,Helvetica,Geneva,Sans-serif,sans-serif">#reason#</P>

</cfoutput>&nbsp;</p>
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
              <td></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
   