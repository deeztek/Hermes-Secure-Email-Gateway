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
<title>Create Virtual</title>
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
<body style="background-color: rgb(255,255,255); background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
              <td height="402" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">  
<cfparam name = "action" default = "0"> 

<cfquery name="gettopdomain" datasource="#datasource#">
SELECT domain from domains order by domain asc limit 1
</cfquery>

<cfparam name = "show_virtual" default = ""> 
<cfif IsDefined("form.virtual") is "True">
<cfif form.virtual is not "">
<cfset show_virtual = form.virtual>
</cfif></cfif>

<cfparam name = "show_domain" default = "#gettopdomain.domain#"> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset show_domain = form.domain>
</cfif></cfif>

<cfparam name = "show_maps" default = ""> 
<cfif IsDefined("form.maps") is "True">
<cfif form.maps is not "">
<cfset show_maps = form.maps>
</cfif></cfif>

<cfquery name="getdomains" datasource="#datasource#">
select * from domains order by domain asc
</cfquery>

<cfif #action# is "edit">

<cfif #show_virtual# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_virtual# is not "">
<cfif REFind("[^_a-zA-Z0-9-.]",show_virtual) gt 0>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfset step=1>
</cfif>
</cfif>

<cfif step is "1">
<cfif #show_maps# is not "">
<cfif IsValid("email", show_maps)>
<cfset step=2>
<cfelseif NOT IsValid("email", show_maps)>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif #show_maps# is "">
<cfset step=0>
<cfset m=5>
</cfif>
</cfif>

<cfif step is "2">
<cfquery name="checkexists" datasource="#datasource#">
select * from virtual where virtual = '#show_virtual#@#show_domain#' and maps = '#show_maps#'
</cfquery>
<cfif #checkexists.recordcount# GTE 1>
<cfset step=0>
<cfset m=3>
<cfelseif #checkexists.recordcount# LT 1>
<cfset step=3>
</cfif>
</cfif>


<cfif step is "3">
<cfset session.virtual="#show_virtual#@#show_domain#">
<cfset session.maps=#show_maps#>
<cflocation url="create_virtual2.cfm">
</cfif>

</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion11" style="background-image: url('./middle_988.png'); height: 402px;">
                  <tr align="left" valign="top">
                    <td>
                      <form name="LayoutRegion11FORM" action="create_virtual.cfm" method="post">
                        <input type="hidden" name="action" value="edit">
                        <table border="0" cellspacing="0" cellpadding="0" width="515">
                          <tr valign="top" align="left">
                            <td width="9" height="15"></td>
                            <td width="506"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td></td>
                            <td width="506" id="Text291" class="TextObject">
                              <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Create Virtual Recipient</span></b></p>
                            </td>
                          </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0" width="973">
                          <tr valign="top" align="left">
                            <td width="6" height="4"></td>
                            <td width="967"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td></td>
                            <td width="967" id="Text479" class="TextObject">
                              <p style="text-align: justify; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Virtual Recipients allow you to add a virtual email address that will deliver email to an actual mailbox. Please note however, email addressed to a virtual recipient will bypass any type of spam checking and will be delivered to the actual mailbox unchecked.</span></p>
                            </td>
                          </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0" width="973">
                          <tr valign="top" align="left">
                            <td width="6" height="2"></td>
                            <td width="967"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td></td>
                            <td width="967" id="Text440" class="TextObject">
                              <p style="margin-bottom: 0px;"><table id="Table160" border="0" cellspacing="3" cellpadding="0" width="100%" style="height: 33px;">
  <tr style="height: 17px;">
    <td width="170" style="background-color: rgb(241,239,239);" id="Cell889">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Virtual</span></b></p>
    </td>
    <td width="22" style="background-color: rgb(241,239,239);" id="Cell890">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span></b>&nbsp;</p>
    </td>
    <td width="241" style="background-color: rgb(241,239,239);" id="Cell891">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Domain</span></b></p>
    </td>
    <td width="171" style="background-color: rgb(241,239,239);" id="Cell892">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Delivers to</span></b></p>
    </td>
  </tr>
  <tr style="height: 26px;">
    <td id="Cell893">
<cfif #getdomains.recordcount# GTE 1>
<cfoutput>
      <p style="margin-bottom: 0px;"><input type="text" name="virtual" value="#show_virtual#" size="20" maxlength="50" style="width: 156px; white-space: pre;"></p>
</cfoutput>
<cfelseif #getdomains.recordcount# LT 1>
<cfoutput>
      <p style="margin-bottom: 0px;"><input type="text" name="virtual" value="#show_virtual#" size="20" maxlength="50" style="width: 156px; white-space: pre;" disabled="disabled"></p>
</cfoutput>
</cfif>

    </td>
    <td id="Cell894">
      <p style="text-align: center; margin-bottom: 0px;"><b>@</b></p>
    </td>
    <td id="Cell895">
      <p style="margin-bottom: 0px;">
<cfif #getdomains.recordcount# LT 1>
        <select name="domain" style="height: 24px;" disabled="disabled">
<cfoutput>
<option value="#show_domain#" SELECTED>#show_domain#</option>
</cfoutput>
<cfoutput query="getdomains">
          <option value="#domain#">#domain#</option>
</cfoutput>
        </select>
<cfelseif #getdomains.recordcount# GTE 1>
     <select name="domain" style="height: 24px;"><cfoutput>
<option value="#show_domain#" SELECTED>#show_domain#</option>
</cfoutput>
         <cfoutput query="getdomains">
          <option value="#domain#">#domain#</option>
</cfoutput>
        </select>
</cfif>

      </p>
    </td>
    <td id="Cell896">
<cfif #getdomains.recordcount# GTE 1>
<cfoutput>
      <p style="margin-bottom: 0px;"><input type="text" name="maps" value="#show_maps#" size="20" maxlength="50" style="width: 156px; white-space: pre;"></p>
</cfoutput>
<cfelseif #getdomains.recordcount# LT 1>
<cfoutput>
      <p style="margin-bottom: 0px;"><input type="text" name="maps" value="#show_maps#" size="20" maxlength="50" style="width: 156px; white-space: pre;" disabled="disabled"></p>
</cfoutput>
</cfif>
    </td>
  </tr>
</table>&nbsp;</p>
                            </td>
                          </tr>
                        </table>
                        <table border="0" cellspacing="0" cellpadding="0">
                          <tr valign="top" align="left">
                            <td width="7" height="6"></td>
                            <td></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td></td>
                            <td width="967">
                              <table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                <tr style="height: 22px;">
                                  <td width="967" id="Cell435">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="206" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: right; margin-bottom: 0px;"><cfif #getdomains.recordcount# GTE 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Create" style="height: 24px; width: 142px;">
<cfelseif #getdomains.recordcount# LT 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Create" style="height: 24px; width: 142px;" disabled="disabled">
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
                        <table border="0" cellspacing="0" cellpadding="0" width="973">
                          <tr valign="top" align="left">
                            <td width="8" height="6"></td>
                            <td width="965"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td></td>
                            <td width="965" id="Text185" class="TextObject">
                              <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The virtual field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The virtual field must only contains letters, numbers, dashes, underscores and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The virtual address mapping you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The delivers to field must be a valid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The delivers to field must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Virtual E-mail Address #show_user# successfully created.</span></i></b></p>
</cfoutput>

</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Virtual E-mail successfully deleted.</span></i></b></p>
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