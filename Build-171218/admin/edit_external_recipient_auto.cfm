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
<title>Edit External Recipient Auto</title>
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
              <td height="406" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 406px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="14" height="18"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="445"></td>
                          <td width="1"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit External Encrypted Recipient</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="208"></td>
                          <td colspan="3" width="952"><CFPARAM NAME="StartRow" DEFAULT="1">
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<CFPARAM NAME="DisplayRows" DEFAULT="10">
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>


<cfquery name="getencryption" datasource="#datasource#">
select * from external_recipients where email = '#url.email#'
</cfquery>

<cfif #getencryption.recordcount# GTE 1>

<cflocation url="error.cfm">
</cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>



<cfparam name = "show_email" default = "#url.email#"> 


<cfparam name = "show_encryption_mode" default = "pdf_mandatory"> 
<cfif IsDefined("form.encryption_mode") is "True">
<cfif form.encryption_mode is not "">
<cfset show_encryption_mode = form.encryption_mode>
</cfif> 
</cfif>

<cfif #action# is "edit">
<cfset session.mode="insert">
<cfset session.email=#show_email#>
<cfset session.encryption_mode=#show_encryption_mode#>
<cfif #show_encryption_mode# is "pdf_mandatory">
<cfoutput>
<cflocation url="create_recipient2.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
<cfelseif #show_encryption_mode# is "pdf_by_subject">
<cfoutput>
<cflocation url="create_recipient2.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
<cfelseif #show_encryption_mode# is "smime_mandatory">
<cfoutput>
<cflocation url="create_recipient3.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
<cfelseif #show_encryption_mode# is "smime_by_subject">
<cfoutput>
<cflocation url="create_recipient3.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
<cfelseif #show_encryption_mode# is "pgp_mandatory">
<cfoutput>
<cflocation url="create_recipient5.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
<cfelseif #show_encryption_mode# is "pgp_by_subject">
<cfoutput>
<cflocation url="create_recipient5.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
</cfif>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion17" style="height: 208px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" enctype="multipart/form-data" action="" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="952">
                                          <table id="Table76" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 137px;">
                                            <tr style="height: 14px;">
                                              <td width="948" id="Cell466">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Specify E-Mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 26px;">
                                              <td id="Cell473">
                                                <table width="581" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table72" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
                                                        <tr style="height: 26px;">
                                                          <td width="576" id="Cell390">
                                                            <table width="576" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td><cfoutput><input type="text" id="FormsEditField23" name="user" size="72" maxlength="72" disabled="disabled" style="width: 572px; white-space: pre;" value="#show_email#"></cfoutput></td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="5" id="Cell391">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 19px;">
                                              <td id="Cell422">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"></span>
                                                  <table width="584" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table83" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 19px;">
                                                          <tr style="height: 19px;">
                                                            <td width="416" id="Cell479">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select Encryption Type</span></b></p>
                                                            </td>
                                                            <td width="168" id="Cell480">
                                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b>&nbsp;</td>
                                              </tr>
                                              <tr style="height: 102px;">
                                                <td id="Cell468">
                                                  <table width="580" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table82" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                          <tr style="height: 17px;">
                                                            <td width="47" id="Cell469">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "pdf_mandatory">
<cfoutput>
<input type="radio" checked="checked" name="encryption_mode" value="pdf_mandatory" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption_mode# is not "pdf_mandatory">
<cfoutput>
<input type="radio" name="encryption_mode" value="pdf_mandatory" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="533" id="Cell470">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory PDF Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell636">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "pdf_by_subject">
<cfoutput>
<input type="radio" checked="checked" name="encryption_mode" value="pdf_by_subject" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_encryption_mode# is not "pdf_by_subject">
<cfoutput>
<input type="radio" name="encryption_mode" value="pdf_by_subject" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell635">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">PDF Encryption Triggered by E-mail Subject Keyword</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell471">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "smime_mandatory">

<input type="radio" checked="checked" name="encryption_mode" value="smime_mandatory" style="height: 13px; width: 13px;">

<cfelseif #show_encryption_mode# is not "smime_mandatory">

<input type="radio" name="encryption_mode" value="smime_mandatory" style="height: 13px; width: 13px;">

</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell472">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory S/MIME Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell477">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "smime_by_subject">

<input type="radio" checked="checked" name="encryption_mode" value="smime_by_subject" style="height: 13px; width: 13px;">

<cfelseif #show_encryption_mode# is not "smime_by_subject">

<input type="radio" name="encryption_mode" value="smime_by_subject" style="height: 13px; width: 13px;">

</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell478">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">S/MIME Encryption Triggered by E-mail Subject Keyword </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell1070">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "pgp_mandatory">

<input type="radio" checked="checked" name="encryption_mode" value="pgp_mandatory" style="height: 13px; width: 13px;">

<cfelseif #show_encryption_mode# is not "pgp_mandatory">

<input type="radio" name="encryption_mode" value="pgp_mandatory" style="height: 13px; width: 13px;">

</cfif>


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1071">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory PGP Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell1072">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_encryption_mode# is "pgp_by_subject">

<input type="radio" checked="checked" name="encryption_mode" value="pgp_by_subject" style="height: 13px; width: 13px;">

<cfelseif #show_encryption_mode# is not "pgp_by_subject">

<input type="radio" name="encryption_mode" value="pgp_by_subject" style="height: 13px; width: 13px;">

</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1073">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">PGP Encryption Triggered by E-mail Subject Keyword </span></b></p>
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
                                          <td height="6"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="952">
                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="952" id="Cell518">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Continue" style="height: 24px; width: 357px;">
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
                            </td>
                            <td></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="6" height="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="2" height="30"></td>
                            <td colspan="2" valign="middle" width="951"><hr id="HRRule7" width="951" size="1"></td>
                            <td colspan="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="6" height="3"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="40"></td>
                            <td colspan="5" width="956">

                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956">
                                          <form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
                                            <table id="Table191" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="956" id="Cell1031">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
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