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
<title>View PGP Keyrings</title>
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
              <td height="434" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0"> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 434px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="14" height="18"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="447"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">View Recipient PGP Keyrings</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="95"></td>
                          <td colspan="3" width="954"><cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfparam name = "m1" default = ""> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif>

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif>

<CFPARAM NAME="StartRow" DEFAULT="1">
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

<cfif NOT IsDefined('url.type')>
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=1>
<cfelseif IsDefined('url.type')>
<cfif #url.type# is not "2">
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=1>
<cfelseif #url.type# is "2">
<cfquery name="getrecipientdetails" datasource="#datasource#">
select id, email as recipient from external_recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset type=2>

</cfif>
</cfif>


<cfif #getrecipientdetails.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>

<cfif #type# is "1">
<!--
<cfquery name="getkeyrings" datasource="djigzo">
select cm_keyring_id, cm_email from cm_keyring_email where cm_email = '#getrecipientdetails.recipient#'
</cfquery>
-->

<cfquery name="getkeyrings" datasource="#datasource#">
select * from recipient_keystores where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and master = '1'
</cfquery>

<cfelseif #type# is "2">
<!--
<cfquery name="getkeyrings" datasource="djigzo">
select cm_keyring_id, cm_email from cm_keyring_email where cm_email = '#getrecipientdetails.recipient#'
</cfquery>
-->

<cfquery name="getkeyrings" datasource="#datasource#">
select * from recipient_keystores where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and master = '1'
</cfquery>

</cfif>







                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion15" style="height: 95px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <form name="Table145FORM" action="" method="post">
                                          <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 36px;">
                                            <tr style="height: 14px;">
                                              <td width="954" id="Cell935">
                                                <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell934">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center"><cfoutput><input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="#getrecipientdetails.recipient#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text375" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><cfif #getkeyrings.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No PGP Keyrings were found for this recipient. Please add PGP Keyrings...</span></i></b></p>

<cfelseif #getkeyrings.recordcount# GTE 1>

<table border="0" cellspacing="4" cellpadding="0" width="954px" style="height: 102px;">
  <tr style="height: 14px;">
    <td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Size</span></b></p>
    </td>


<td style="background-color: rgb(241,236,236);" id="Cell972">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">User-ID</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell973">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Created</span></b></p>
    </td>
    <td style="background-color: rgb(241,236,236);" id="Cell974">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Expires</span></b></p>
    </td>
    
        <td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Private Key</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Key ID</span></b></p>
    </td>


    
<td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Parent ID</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Delete</span></b></p>
    </td>
<td style="background-color: rgb(241,236,236);" id="Cell975">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Download Public</span></b></p>
    </td>

    <td style="background-color: rgb(241,236,236);" id="Cell976">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Download Private</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell976">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View Password</span></b></p>
    </td>

<td style="background-color: rgb(241,236,236);" id="Cell976">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Publish Key</span></b></p>
    </td>
    
  </tr>

<cfloop query="getkeyrings">
  <tr style="height: 36px;">

<cfoutput>
<cfquery name="getchildkeys" datasource="#datasource#">
select * from recipient_keystores where parent='#id#' and master = '0'
</cfquery>

<cfquery name="getkeyservers" datasource="#datasource#">
select id from pgp_keyservers
</cfquery>



    <td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">MASTER</span></p>
    </td>



<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#encryption#</span></p>
    </td>


<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#htmlEditFormat(user_name)#</span></p>
    </td>



    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_creation, "mm/dd/yyyy")#</span></p>
    </td>
<cfif #pgp_keystore_expiration# is not "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_expiration, "mm/dd/yyyy")#</span></p>
    </td>

<cfelseif #pgp_keystore_expiration# is "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">N/A</span></p>
    </td>


</cfif>

<cfquery name="getprivatekeyalias" datasource="djigzo">
select cm_private_key_alias from cm_keyring where cm_sha256fingerprint='#pgp_fingerprint_sha256#'
</cfquery>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">
<td id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Not Available</span></p>
    </td>


<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
    <td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Available</span></p>
    </td>
</cfif>

<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#pgp_key_id#</span></p>
    </td>


<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">N/A</span></p>
    </td>

<td align="center"><a href="./delete_key.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="delete_icon.png" border="0" alt="Delete Certificate" title="Delete Certificate"></a></td>

<td align="center"><a href="./download_public.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="download_icon.png" border="0" alt="Download Public Key" title="Download Public Key"></a></td>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">

<td align="center"><img id="Picture36" height="19" width="19" src="download_icon_off.png" border="0" alt="No Private Key Available" title="No Private Key Available"></td>

<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
<td align="center"><a href="./download_private.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="download_icon.png" border="0" alt="Download Private Key" title="Download Private Key"></a></td>
</cfif>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">

<td align="center"><img id="Picture36" height="19" width="19" src="view_icon_off.png" border="0" alt="No Private Key Available" title="No Private Key Available"></td>

<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
<td align="center"><a href="./view_private_password.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="view_icon.png" border="0" alt="View Private Password" title="View Private Password"></a></td>
</cfif>

<cfif #getkeyservers.recordcount# GTE 1>
<td align="center"><a href="./publish_key.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="publish_icon.png" border="0" alt="Publish Public Key" title="Publish Public Key"></a></td>

<cfelseif #getkeyservers.recordcount# LT 1>

<td align="center"><img id="Picture36" height="19" width="19" src="publish_icon_off.png" border="0" alt="No Key Servers Available" title="No Key Servers Available"></td>
</cfif>

</cfoutput>

<tr style="height: 36px;">
<cfoutput query="getchildkeys">


    <td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">SUB</span></p>
    </td>



    <td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#encryption#</span></p>
    </td>

<td id="Cell978">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#htmlEditFormat(user_name)#</span></p>
    </td>



    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_creation, "mm/dd/yyyy")#</span></p>
    </td>
<cfif #pgp_keystore_expiration# is not "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#DateFormat(pgp_keystore_expiration, "mm/dd/yyyy")#</span></p>
    </td>

<cfelseif #pgp_keystore_expiration# is "">
    <td id="Cell979">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">N/A</span></p>
    </td>


</cfif>

<cfquery name="getprivatekeyalias" datasource="djigzo">
select cm_private_key_alias from cm_keyring where cm_sha256fingerprint='#pgp_fingerprint_sha256#'
</cfquery>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">
<td id="Cell980">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Not Available</span></p>
    </td>


<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
    <td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">Available</span></p>
    </td>
</cfif>

<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#pgp_key_id#</span></p>
    </td>


<cfquery name="getparentid" datasource="#datasource#">
select pgp_key_id from recipient_keystores where id='#parent#'
</cfquery>

<td id="Cell981">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px;">#getparentid.pgp_key_id#</span></p>
    </td>

<td align="center"><a href="./delete_key.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="delete_icon.png" border="0" alt="Delete Certificate" title="Delete Certificate"></a></td>

<td align="center"><a href="./download_public.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="download_icon.png" border="0" alt="Download Public Key" title="Download Public Key"></a></td>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">

<td align="center"><img id="Picture36" height="19" width="19" src="download_icon_off.png" border="0" alt="No Private Key Available" title="No Private Key Available"></td>

<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
<td align="center"><a href="./download_private.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="download_icon.png" border="0" alt="Download Private Key" title="Download Private Key"></a></td>
</cfif>

<cfif #getprivatekeyalias.cm_private_key_alias# is "">

<td align="center"><img id="Picture36" height="19" width="19" src="view_icon_off.png" border="0" alt="No Private Key Available" title="No Private Key Available"></td>

<cfelseif #getprivatekeyalias.cm_private_key_alias# is not "">
<td align="center"><a href="./view_private_password.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="view_icon.png" border="0" alt="View Private Password" title="View Private Password"></a></td>
</cfif>

<cfif #getkeyservers.recordcount# GTE 1>
<td align="center"><a href="./publish_key.cfm?id=#id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&type=#type#&show=#show#"><img id="Picture44" height="19" width="19" src="publish_icon.png" border="0" alt="Publish Public Key" title="Publish Public Key"></a></td>

<cfelseif #getkeyservers.recordcount# LT 1>

<td align="center"><img id="Picture36" height="19" width="19" src="publish_icon_off.png" border="0" alt="No Key Servers Available" title="No Key Servers Available"></td>
</cfif>



</cfoutput>
</tr>




</tr>         

</cfloop>
</table>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #action# is "add">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recipient encryption options set.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "none">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;No changes were made to the Recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "edit">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recipient encryption options set</span></i></b></p>
</cfoutput>
</cfif>


<cfif #action# is "delete">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recipient PGP Key deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "addedcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recipient PGP Key created</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "sentcertificate">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Recipient S/MIME Certificate sent</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "certnoexist">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;A system error has occured. The certificate file was not found. Please contact support</span></i></b></p>
</cfoutput>
</cfif>



<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
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
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="953"><hr id="HRRule3" width="953" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td colspan="3" width="954">

                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="10"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="954" id="Cell1019">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="635" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><cfif #type# is "1">
<form name="apply_settings" action="<cfoutput>internal_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;"><cfif #type# is "1">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
<cfelseif #type# is "2">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
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

<cfelseif #type# is "2">

<form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;"><cfif #type# is "1">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
<cfelseif #type# is "2">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
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