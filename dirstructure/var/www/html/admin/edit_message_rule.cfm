<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Edit Message Rule</title>
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
              <td height="634" width="988"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">

<cfif NOT structKeyExists(form, "id")>
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

<cfquery name="getrule" datasource="#datasource#">
select * from message_rules where id= <cfqueryparam value = #id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getrule.recordcount# LT 1>
<cflocation url="error.cfm" addtoken="no">

<cfelseif #getrule.recordcount# GTE 1>

<CFPARAM NAME="rule_name" DEFAULT="#getrule.rule_name#">
<cfif IsDefined("form.rule_name") is "True">
<cfif form.rule_name is not "">
<cfset rule_name = form.rule_name>
</cfif></cfif>

<CFPARAM NAME="rule_desc" DEFAULT="#getrule.rule_desc#">
<cfif IsDefined("form.rule_desc") is "True">
<cfif form.rule_desc is not "">
<cfset rule_desc = form.rule_desc>
</cfif></cfif>

<CFPARAM NAME="rule_type" DEFAULT="#getrule.rule_type#">
<cfif IsDefined("form.rule_type") is "True">
<cfif form.rule_type is not "">
<cfset rule_type = form.rule_type>
</cfif></cfif>

<CFPARAM NAME="header" DEFAULT="#getrule.header#">
<cfif IsDefined("form.header") is "True">
<cfif form.header is not "">
<cfset header = form.header>
</cfif></cfif>

<CFPARAM NAME="regex" DEFAULT="#getrule.regex#">
<cfif IsDefined("form.regex") is "True">
<cfif form.regex is not "">
<cfset regex = form.regex>
</cfif></cfif>

<CFPARAM NAME="score" DEFAULT="#getrule.score#">
<cfif IsDefined("form.score") is "True">
<cfif form.score is not "">
<cfset score = form.score>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<!-- /CFIF getrule.recordcount -->
</cfif>

<cfif #action# is "edit">

<cfif #rule_name# is "">
<cfset m1=1>
<cfelseif #rule_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",rule_name) gt 0>
<cfset m1=2>
<cfelse>
<cfset step=1>

<!-- /CFIF REFind("[^_a-zA-Z0-9-]"rule_name gt 0 -->
</cfif>

<!-- /CFIF rule_name is "" -->
</cfif>

<cfif step is "1">

<cfif #rule_type# is "header">
<cfif #header# is "">
<cfset m1=4>
<cfelseif #header# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",header) gt 0>
<cfset m1=5>
<cfelse>
<cfset step=2>


<!-- /CFIF REFind("[^_a-zA-Z0-9-]",header) gt 0 -->
</cfif>

<!-- /CFIF header is "" -->
</cfif>

<cfelseif #rule_type# is not "header">
<cfset step=2>

<!-- /CFIF rule_type is header -->
</cfif>

<!-- /CFIF FOR STEP 1 -->
</cfif>


<cfif step is "2">

<cfif #regex# is "">
<cfset m1=6>
<cfelseif #regex# is not "">
<cfset step=3>

<!-- /CFIF regex is "" -->
</cfif>

<!-- /CFIF FOR STEP 2 -->
</cfif>

<cfif step is "3">

<cfif #score# is "">
<cfset m1=7>
<cfelseif #score# is not "">
<cfif IsNumeric(score)> 
<cfset step=4>
<cfelse>
<cfset m1=8>

<!-- /CFIF IsNumeric(score) -->
</cfif>

<!-- /CFIF regex is "" -->
</cfif>

<!-- /CFIF FOR STEP 3 -->
</cfif>


<cfif #step# is "4">

<cfif #rule_type# is not "header">
<cfset header="">
</cfif>

<cfquery name="update" datasource="#datasource#">
update message_rules 
set
rule_name='#rule_name#',
rule_type='#rule_type#',
rule_desc='#rule_desc#',
header='#header#', 
regex=<cfqueryparam value="#regex#" cfsqltype="cf_sql_varchar">, 
score='#score#',
applied='2'
where id='#id#'
</cfquery>


<cflocation url="message_rules.cfm?m2=2" addtoken="no">

<!-- /CFIF FOR STEP 4 -->
</cfif>


<!-- /CFIF FOR ACTION -->
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 634px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="987">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="446"></td>
                          <td width="4"></td>
                          <td width="1"></td>
                          <td width="20"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit Message Rule</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="106"></td>
                          <td colspan="3" width="952">
                            <form name="LayoutRegion33FORM" action="edit_message_rule.cfm" method="post">
                              <input type="hidden" name="id" value="<cfoutput>#id#</cfoutput>">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td height="7"></td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td width="780">
                                    <table id="Table139" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 32px;">
                                      <tr style="height: 17px;">
                                        <td width="780" id="Cell1086">
                                          <table width="751" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved and applied</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name you are attempting to use already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field cannot be empty if Rule Type of Header is selected</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Regex field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field must be numeric only</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                          &nbsp;</td>
                                      </tr>
                                      <tr style="height: 14px;">
                                        <td id="Cell1084">
                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Type</span></b></p>
                                        </td>
                                      </tr>
                                      <tr style="height: 68px;">
                                        <td id="Cell1085">
                                          <table width="749" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td>
                                                <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                  <tr style="height: 17px;">
                                                    <td width="64" id="Cell797">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #rule_type# is "body">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value=body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "body">
<cfoutput>
<input type="radio" name="rule_type" value="body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>







&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td width="685" id="Cell798">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Body Rule <span style="font-weight: normal;">(Search body of messages for matches)</span></span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell799">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #rule_type# is "header">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "header">
<cfoutput>
<input type="radio" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell800">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Header Rule <span style="font-weight: normal;">(Search message header for matches. Ex: Subject, To, From)</span></span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1077">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #rule_type# is "uri">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "uri">
<cfoutput>
<input type="radio" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell1078">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">URI Rule <span style="font-weight: normal;">(Search for URI in the plain text or HTML section of messages)</span></span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1079">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #rule_type# is "rawbody">
<cfoutput>
<input type="radio" checked="checked" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #rule_type# is not "rawbody">
<cfoutput>
<input type="radio" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>





&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell1080">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Rawbody Rule <span style="font-weight: normal;">(Search body of messages for HTML tags or HTML comments or line-break patterns)</span></span></b></p>
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
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="226"></td>
                          <td colspan="5" width="976">




 

                            <table border="0" cellspacing="0" cellpadding="0" width="976" id="LayoutRegion17" style="height: 226px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="edit_message_rule.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="rule_type" value="<cfoutput>#rule_type#</cfoutput>"><input type="hidden" name="id" value="<cfoutput>#id#</cfoutput>"><input type="hidden" name="rule_name" value="<cfoutput>#rule_name#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="803">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 153px;">
                                            <tr style="height: 14px;">
                                              <td width="803" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Rule Name <span style="font-weight: normal;">(Cannot be changed)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell972">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField39" name="rule_name" size="55" maxlength="255" disabled="disabled" style="width: 436px; white-space: pre;" value="#rule_name#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Description</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell902">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField61" name="rule_desc" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#rule_desc#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1082">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Message Header </span></b><span style="font-weight: normal;">(Letters numbers and underlines only. No spaces are allowed)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1083">
                                                <table width="441" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #rule_type# is not "header">
<cfoutput>
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="" disabled="disabled">
</cfoutput>

<cfelseif #rule_type# is "header">
<cfoutput>
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="#header#">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell904">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Regex<span style="font-weight: normal;"> </span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell905">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField63" name="regex" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#regex#"></cfoutput></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell906">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Spam Score </span></b><span style="font-weight: normal;">(Numeric&nbsp; Value only)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"><cfoutput><input type="text" id="FormsEditField62" name="score" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="#score#"></cfoutput></span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="957" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving Changes, please wait...';this.form.submit();" name="savechanges" value="Save Changes" style="height: 24px; width: 275px;">
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
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="40"></td>
                          <td colspan="4" width="956">

                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="<cfoutput>message_rules.cfm</cfoutput>" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Message Rules" style="height: 24px; width: 357px;">
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