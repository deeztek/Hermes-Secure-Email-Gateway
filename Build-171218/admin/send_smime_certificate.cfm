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
<title>Send SMIME Certificate</title>
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
              <td height="483" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 483px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="10" height="18"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="451"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Send Recipient PFX Certificate File &amp; Password</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="144"></td>
                          <td colspan="3" width="957"><cfparam name = "m" default = "0">

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "10"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>


<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<cfif NOT IsDefined('url.type')>
<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select * from recipients where id='#getcerts.user_id#'
</cfquery>

<cfset type=1>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getcerts.smime_certificate_password, #theKey#, "AES", "Base64")>

<cfelseif IsDefined('url.type')>

<cfif #url.type# is not "2">
<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select * from recipients where id='#getcerts.user_id#'
</cfquery>

<cfset type=1>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getcerts.smime_certificate_password, #theKey#, "AES", "Base64")>

<cfelseif #url.type# is "2">

<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where id=<cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and external='1'
</cfquery>

<cfquery name="getinfo" datasource="#datasource#">
select id, email as recipient from external_recipients where id='#getcerts.user_id#'
</cfquery>

<cfset type=2>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
<cfset decryptedPassword=decrypt(getcerts.smime_certificate_password, #theKey#, "AES", "Base64")>

</cfif>


</cfif>


<cfif #getinfo.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 144px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>send_smime_certificate2.cfm?id=#url.id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text215" class="TextObject">
                                          <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">The system will send the PFX Certificate File to the recipient via e-mail. The PFX Certificate File password is shown below in order to relay to the recipient. It is <b><u>HIGHLY</u></b> recommended that <b><u>you do not relay&nbsp; the password via any communications medium including telephone, SMS or unencrypted e-mail</u></b>. All those mediums are considered unsecure. Click the <b>Send Certificate</b> button below to proceed.</span></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="4"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table9" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 74px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell408">
                                                <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient E-mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <cfoutput>
                                              <td id="Cell62">
                                                <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                  <table width="280" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td><cfoutput><input type="text" id="FormsEditField5" name="email" size="35" maxlength="45" disabled="disabled" style="width: 276px; white-space: pre;" value="#getinfo.recipient#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                </cfoutput>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell84">
                                                  <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">PFX Certificate File Password<span style="color: rgb(255,0,0);"> </span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 24px;">
                                                <td id="Cell90">
                                                  <table width="280" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td><cfoutput><input type="text" id="FormsEditField6" name="password" size="35" maxlength="45" disabled="disabled" style="width: 276px; white-space: pre;" value="#decryptedPassword#"></cfoutput></td>
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
                                          <td height="2"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="957">
                                            <table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                              <tr style="height: 22px;">
                                                <td width="957" id="Cell435">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="206" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Sending, please wait...';this.form.submit();" name="FormsButton1" value="Send Certificate" style="height: 24px; width: 144px;">&nbsp;</p>
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
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="4" height="3"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="30"></td>
                            <td colspan="3" valign="middle" width="957"><hr id="HRRule1" width="957" size="1"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="4" height="1"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="2" height="40"></td>
                            <td colspan="2" width="956">

                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956">
                                          <form name="apply_settings" action="<cfoutput>view_smime_certificates.cfm?id=#getcerts.user_id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="956" id="Cell518">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="591" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Recipient S/MIME Certificates" style="height: 24px; width: 357px;">
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