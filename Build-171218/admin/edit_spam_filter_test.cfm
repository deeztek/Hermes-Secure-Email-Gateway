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
<title>Edit Spam Filter Test</title>
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
        <td><style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted
 black;padding:5px; }
</style>



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
              <td height="920" width="988"><cfparam name = "m1" default = "0">
<cfparam name = "step" default = "0"> 

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "StartRow" default = ""> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = ""> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion27" style="background-image: url('./middle_988.png'); height: 920px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="977">
                        <tr valign="top" align="left">
                          <td width="14" height="15"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="504"></td>
                          <td width="448"></td>
                          <td width="1"></td>
                          <td width="8"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="506" id="Text485" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Edit Custom Spam Filter Test</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="188"></td>
                          <td colspan="4" width="954"><cfif NOT structKeyExists(form, "id")>
<cflocation url="error.cfm" addtoken="no">
<cfelseif structKeyExists(form, "id")>
<cfif form.id is "">
<cflocation url="error.cfm" addtoken="no">
<cfelseif form.id is not "">
<cfif isValid("integer", form.id)>
<cfset id = form.id>
<cfelse>
<cflocation url="error.cfm" addtoken="no">

<!-- /CFIF form.id is "" -->
</cfif>

<!-- /CFIF isValid("integer", form.id) -->
</cfif>

<!-- /CFIF structKeyExists(form, "id") -->
</cfif>

<cfquery name="gettest" datasource="#datasource#">
select * from spam_settings where id=<cfqueryparam value = #id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfparam name = "parameter" default = "#gettest.parameter#"> 
<cfif IsDefined("form.parameter") is "True">
<cfif form.parameter is not "">
<cfset parameter = form.parameter>
</cfif></cfif> 

<cfparam name = "value" default = "#gettest.value#"> 
<cfif IsDefined("form.value") is "True">
<cfif form.value is not "">
<cfset value = form.value>
</cfif></cfif> 

<cfparam name = "description" default = "#gettest.description#"> 
<cfif IsDefined("form.description") is "True">
<cfif form.description is not "">
<cfset description = form.description>
</cfif></cfif> 


<cfif #action# is "edit">

<cfif #parameter# is "">
<cfset step=0>
<cfset m1=1>
<cfelseif #parameter# is not "">
<cfset step=1>
</cfif>

<cfif #step# is "1">
<cfquery name="checkparameter" datasource="#datasource#">
select parameter from spam_settings where parameter = '#parameter#' and spamfilter='1' and id <> '#id#'
</cfquery>

<cfif #checkparameter.recordcount# LT 1>
<cfset step=2>
<cfelseif #checkparameter.recordcount# GTE 1>
<cfset step=0>
<cfset m1=2>
</cfif>

<!-- /cfif for step 1 -->
</cfif>

<cfif #step# is "2">

<cfif #value# is "">
<cfset step=0>
<cfset m1=3>
<cfelseif #value# is not "">
<cfset step=3>
</cfif>

<!-- /cfif for step 2 -->
</cfif>



<cfif #step# is "3">
<cfif IsValid("float", value)>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m1=7>

<!-- /cfif for IsValid float -->
</cfif>

<!-- /cfif for step 3 -->
</cfif>

<cfif #step# is "4">
<cfif #value# LT -999>
<cfset step=0>
<cfset m1=4>
<cfelseif #value# GT 999>
<cfset step=0>
<cfset m1=5>
<cfelse>
<cfset step=5>

<!-- /cfif for value -->
</cfif>

<!-- /cfif for step 4 -->
</cfif>




<cfif #step# is "5">
<cfquery name="insert" datasource="#datasource#">
update spam_settings
set
parameter = '#parameter#',
value = '#value#',
description = '#description#',
applied = '2'
where id = '#id#'
</cfquery>
<cfset step=0>
<cfset m1=6>

<cfoutput>
<cflocation url="spam_filter_tests.cfm?m3=1&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#" addToken = "no">
</cfoutput>
<!-- /cfif for step 2 -->
</cfif>

<!-- /cfif for action -->
</cfif> 




                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion5" style="height: 188px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion5FORM" action="<cfoutput>edit_spam_filter_test.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="id" value="<cfoutput>#id#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="954">
                                          <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 102px;">
                                            <tr style="height: 17px;">
                                              <td width="954" id="Cell1022">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Parameter</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell1023">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField44" name="parameter" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#parameter#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1024">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Value</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell1025">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField45" name="value" size="8" maxlength="8" style="width: 60px; white-space: pre;" value="#value#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1026">
                                                <table width="472" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Description</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell1027">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField46" name="description" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#description#"></cfoutput></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954">
                                          <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="954" id="Cell934">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Edit" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="954">
                                      <tr valign="top" align="left">
                                        <td width="954" height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954" id="Text351" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Parameter field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Parameter you are trying to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be less than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field cannot be greater than 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Spam Filter Test added. Please click the Apply Settings button below to apply your new settings.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Value field must be a valid integer between -999 and 999</span></i></b></p>
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
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="2" valign="middle" width="952"><hr id="HRRule3" width="952" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="46"></td>
                          <td colspan="4" width="961">

                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion18" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="961">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
                                          <tr style="height: 28px;">
                                            <td width="961" id="Cell1021">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="417" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;">
<form name="apply_settings" action="<cfoutput>spam_filter_tests.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Custom Spam Filter Tests" style="height: 24px; width: 357px;">


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