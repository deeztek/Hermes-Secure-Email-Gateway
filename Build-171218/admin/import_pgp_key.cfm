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
<title>Import PGP Key</title>
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
              <td height="493" width="988"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "action" default = "0">

<cfparam name = "keytype" default = "public"> 
<cfif IsDefined("form.keytype") is "True">
<cfif form.keytype is not "">
<cfset keytype = form.keytype>
</cfif></cfif> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 493px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="521">
                        <tr valign="top" align="left">
                          <td width="15" height="18"></td>
                          <td width="506"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Import Recipient PGP Key</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="17" height="20"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="957">
                            <form name="Table190FORM" action="" method="post">
                              <table id="Table190" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 18px;">
                                <tr style="height: 14px;">
                                  <td width="957" id="Cell1167">
                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Key Type</span></b></p>
                                  </td>
                                </tr>
                                <tr style="height: 34px;">
                                  <td id="Cell1168">
                                    <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td>
                                          <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 7px;">
                                            <tr style="height: 17px;">
                                              <td width="51" id="Cell1161">
                                                <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #keytype# is "public">
<cfoutput>
<input type="radio" checked="checked" name="keytype" value="public" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #keytype# is not "public">
<cfoutput>
<input type="radio" name="keytype" value="public" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                              <td width="480" id="Cell1162">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Public</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1163">
                                                <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #keytype# is "private">
<cfoutput>
<input type="radio" checked="checked" name="keytype" value="private" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #keytype# is not "private">
<cfoutput>
<input type="radio" name="keytype" value="private" style="height: 13px; width: 13px;" onclick="this.form.submit();">
</cfoutput>
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                              <td id="Cell1164">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Private</span></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="974">
                        <tr valign="top" align="left">
                          <td width="16" height="218"></td>
                          <td width="958"><cfparam name="url.id" type="numeric" default=0>
<CFPARAM NAME="File.ServerFile" DEFAULT="">
<CFPARAM NAME="cffile.serverFileExt" DEFAULT="">



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

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>


<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "ctl" default = "1"> 
<cfif IsDefined("form.ctl") is "True">
<cfif form.ctl is not "">
<cfset ctl = form.ctl>
</cfif></cfif>

<cfparam name = "expired" default = "2"> 
<cfif IsDefined("form.expired") is "True">
<cfif form.expired is not "">
<cfset expired = form.expired>
</cfif></cfif>


<cfparam name = "localfile" default = ""> 
<cfif IsDefined("form.thekeyfile") is "True">
<cfif form.thekeyfile is not "">
<cfset localfile = form.thekeyfile>
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
<cfelseif #getrecipientdetails.recordcount# GTE 1>
<cfset theRecipient="#getrecipientdetails.recipient#">
</cfif>
 
<cfparam name = "show_pgp_password" default = ""> 
<cfif IsDefined("form.password") is "True">
<cfif form.password is not "">
<cfset show_pgp_password = form.password>
</cfif></cfif> 

<cfif #action# is "import">

<cfset rcpt_name = rereplace(getrecipientdetails.recipient, "[^A-Za-z0-9]+", "", "all")>

<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
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

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfif #keytype# is "private">
<cfif #localfile# is "">
<cfset step=0>
<cfset m=7>
<cfelseif #localfile# is not "">
<cfif #show_pgp_password# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_pgp_password# is not "">
<cfset step=2>
</cfif>
</cfif>

<cfelseif #keytype# is "public">
<cfif #localfile# is "">
<cfset step=0>
<cfset m=7>
<cfelseif #localfile# is not "">
<cfset step=2>
</cfif>

<!-- /CFIF keytype -->
</cfif>


<cfif step is "2">
<cftry>
  <cffile action="upload"
     fileField="thekeyfile"
     destination="/opt/hermes/tmp"
     nameconflict="makeunique">
     
<cfset OriginalFileName = #cffile.serverFile# />
<cfset NewFileName = rereplace(OriginalFileName, "[^A-Za-z0-9._]+", "", "all")>
<cffile action="rename" 
source="/opt/hermes/tmp/#OriginalFileName#" 
destination="/opt/hermes/tmp/#NewFileName#">
   
<cfcatch>

<cfif FindNoCase("not accepted", cfcatch.Message)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=6>
<cfdump var="#cfcatch#" abort />
<cfelseif FindNoCase("doesn't exist", cfcatch.Message)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=7>
<cfdump var="#cfcatch#" abort />

<!--- looks like non-MIME error, handle separately  
<cfdump var="#cfcatch#" abort /> --->

</cfif>

</cfcatch>


</cftry>

<cfif #cffile.serverFileExt# is "asc" OR #cffile.serverFileExt# is "pgp" OR #cffile.serverFileExt# is "gpg">
<cfset step=3>
<cfelse>
<cfset m=6>
<cfset step=0>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


</cfif>


<!-- /CFIF for step -->
</cfif>

<cfif #step# is "3">

<!-- SINCE A PUBLIC KEY CAN EXIST IN DJIGZO WITHOUT THE CORRESPONDING SECRET KEY THEN IF KEYTYPE IS PUBLIC GET KEY ID FROM FILE AND CHECK IF IT EXISTS IN
 DJGZO CM_KEYRING TABLE. IF KEYTYPE IS PRIVATE, GET KEY ID FROM FILE AND CHECK IF CM_PRIVATE_KEY_ALIAS FIELD IN CM_KEYRING IS NULL -->
 
<cfif #keytype# is "public">

<!-- GET KEY ID STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/get_pgp_key_id.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
timeout = "240"
variable="thekeyid2"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif #thekeyid2# is "">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=2>
<cfelseif #thekeyid2# is not "">
<cfset thekeyid = #TRIM(thekeyid2)#>

<!-- GET KEY ID ENDS HERE -->

<cfquery name="getsha256fingerprint" datasource="djigzo">
select cm_sha256fingerprint from cm_keyring where cm_keyidhex='#thekeyid#'
</cfquery>

<cfquery name="checkkeyidexists" datasource="djigzo">
select cm_fingerprint from cm_pgp_trust_list where cm_fingerprint='#getsha256fingerprint.cm_sha256fingerprint#'
</cfquery>

<cfif #checkkeyidexists.recordcount# LT 1>
<cfset step=4>
<cfelseif #checkkeyidexists.recordcount# GTE 1>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=3>
</cfif>
<!-- /CFIF for thekeyid2 is "" -->
</cfif>

<cfelseif #keytype# is "private">

<!-- GET SUB KEY ID STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/get_pgp_subkey_id.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
timeout = "240"
variable="thekeyid2"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif #thekeyid2# is "">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=2>
<cfelseif #thekeyid2# is not "">
<cfset thekeyid = #TRIM(thekeyid2)#>

<!-- GET SUB KEY ID ENDS HERE -->

<cfquery name="getsha256fingerprint" datasource="djigzo">
select cm_sha256fingerprint from cm_keyring where cm_keyidhex='#thekeyid#'
</cfquery>

<cfquery name="checkkeyidexists" datasource="djigzo">
select cm_fingerprint from cm_pgp_trust_list where cm_fingerprint='#getsha256fingerprint.cm_sha256fingerprint#'
</cfquery>

<cfif #checkkeyidexists.recordcount# LT 1>
<cfset step=4>
<cfelseif #checkkeyidexists.recordcount# GTE 1>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=3>
<!-- /CFIF for checkkeyidexists.recordcount -->
</cfif>
<!-- /CFIF for thekeyid2 is "" -->
</cfif>



<!-- /CFIF for keytype -->
</cfif>

<!-- /CFIF for step -->
</cfif>





<cfif #step# is "4">

<!-- GET EMAIL FROM KEY TO SEE IF IT MATCHES RECIPIENT EMAIL -->
 
<cfif #keytype# is "public">

<!-- GET KEY EMAIL STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/get_pgp_key_email.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
timeout = "240"
variable="thekeyemail2"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif #thekeyemail2# is "">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=2>
<cfelseif #thekeyemail2# is not "">
<cfset thekeyemail = #TRIM(htmlEditFormat(thekeyemail2))#>

<!-- GET KEY EMAIL ENDS HERE -->

<!-- CHECK TO SEE IF IT CONTAINS RECIPIENT EMAIL -->


<cfif  #thekeyemail# DOES NOT CONTAIN "#getrecipientdetails.recipient#">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=10>
<cfelseif #thekeyemail# CONTAINS "#getrecipientdetails.recipient#">
<cfset step=5>
</CFIF>

<!-- /CFIF for thekeyemail2 is "" -->
</cfif>

<cfelseif #keytype# is "private">

<!-- GET SUB KEY EMAIL STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/get_pgp_subkey_email.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
timeout = "240"
variable="thekeyemail2"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif #thekeyemail2# is "">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=2>
<cfelseif #thekeyemail2# is not "">
<cfset thekeyemail = #TRIM(htmlEditFormat(thekeyemail2))#>

<!-- GET SUB KEY EMAIL ENDS HERE -->

<!-- CHECK TO SEE IF IT CONTAINS RECIPIENT EMAIL -->

<cfif  #thekeyemail# DOES NOT CONTAIN "#getrecipientdetails.recipient#">

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=10>
<cfelseif #thekeyemail# CONTAINS "#getrecipientdetails.recipient#">
<cfset step=5>
</CFIF>

<!-- /CFIF for thekeyemail2 is "" -->
</cfif>


<!-- /CFIF for keytype -->
</cfif>

<!-- /CFIF for step -->
</cfif>




<cfif #step# is "5">


<cfif #keytype# is "public">

<!-- IMPORT PUBLIC KEY INTO DJIGZO STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/import_pgp_public_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
timeout = "240"
variable="commandoutput"
arguments="-inputformat none">
</cfexecute>

<!-- Delete /opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif FindNoCase("key ring file does not exist or is not a file", commandoutput)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=9>

<cfelse>
<cfset step=6>


<!-- /CFIF FindNoCase -->
</cfif>


<!-- IMPORT PUBLIC KEY INTO DJIGZO ENDS HERE -->


<cfelseif #keytype# is "private">

<!-- IMPORT PRIVATE KEY INTO DJIGZO STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/import_pgp_private_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#show_pgp_password#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
timeout = "240"
variable="commandoutput"
arguments="-inputformat none">
</cfexecute>

<!-- Delete /opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfif FindNoCase("key ring file does not exist or is not a file", commandoutput)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=9>

<cfelse>
<cfset step=6>

<!-- /CFIF FindNoCase -->
</cfif>

<!-- IMPORT PRIVATE KEY INTO DJIGZO ENDS HERE -->

<!-- /cfif for keytype -->
</cfif>

<!-- /cfif for step -->
</cfif>

<cfif #step# is "6">

<cfif #keytype# is "public">
<cfquery name="checkexistsdjigzo" datasource="djigzo">
select cm_id from cm_keyring where cm_keyidhex='#thekeyid#'
</cfquery>

<cfif #checkexistsdjigzo.recordcount# GTE 1>
<cfset step=7>
<cfelseif #checkexistsdjigzo.recordcount# LT 1>
<cfset step=0>
<cfset m=3>
<!-- /cfif for checkexistsdjigzo.recordcount -->
</cfif>

<cfelseif #keytype# is "private">
<cfquery name="checkexistsdjigzo" datasource="djigzo">
select cm_private_key_alias from cm_keyring where cm_keyidhex='#thekeyid#'
</cfquery>

<cfif #checkexistsdjigzo.cm_private_key_alias# is not "">
<cfset step=7>
<cfelseif #checkexistsdjigzo.cm_private_key_alias# is "">
<cfset step=0>
<cfset m=4>
<!-- /cfif for checkexistsdjigzo.cm_private_key_alias -->
</cfif>

<!-- /cfif for keytype -->
</cfif>

<!-- /cfif for step -->
</cfif>

<cfif #step# is "7">


<!-- IMPORT KEY INTO GNUPG KEYSTORE STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/import_pgp_key_gnupg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
    output = "#REReplace("#temp#","THE-FILE","#NewFileName#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
timeout = "240"
variable="commandoutput"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>    

<!-- IMPORT KEY INTO GNUPG KEYSTORE ENDS HERE -->

<cfset step=8>

<!-- /cfif for step -->
</cfif>

<cfif #step# is "8">

<!-- INSERT KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES STARTS HERE -->

<cfquery name="getkeyprint" datasource="djigzo">
select * from cm_keyring where cm_keyidhex='#thekeyid#'
</cfquery>

<!-- QUERY GETKEYUSERID TO BE USED TO INSERT INTO THE USER_NAME FIELD IN THE RECIPIENT_KEYSTORES TABLE IN HERMES FURTHER DOWN -->
<cfif #getkeyprint.cm_master# is "1">
<cfquery name="getkeyuserid" datasource="djigzo">
select cm_userid from cm_keyring_userid where cm_keyring_id='#getkeyprint.cm_id#'
</cfquery>
<cfelseif #getkeyprint.cm_master# is "0">
<cfquery name="getkeyuserid" datasource="djigzo">
select cm_userid from cm_keyring_userid where cm_keyring_id='#getkeyprint.cm_parentid#'
</cfquery>
<!-- /CFIF FOR getkeyprint.cm_master IS 1 -->
</cfif>

<cfquery name="ctlexists" datasource="djigzo">
select cm_fingerprint from cm_pgp_trust_list where cm_fingerprint='#getkeyprint.cm_sha256fingerprint#'
</cfquery>

<cfif #ctlexists.recordcount# LT 1>

<cfoutput>
<cfquery name="insertctl" datasource="djigzo">
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#getkeyprint.cm_sha256fingerprint#')
</cfquery>

<cfquery name="getctl" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint='#getkeyprint.cm_sha256fingerprint#'
</cfquery>

<cfquery name="insertctlnamevalues" datasource="djigzo">
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctl.cm_id#', 'trusted','status')
</cfquery>

</cfoutput>

<!-- /CFIF FOR ctlexists.recordcount -->
</cfif>

<!-- INSERT KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES ENDS HERE -->


<cfset step=9>

<!-- /cfif for step -->
</cfif>


<cfif #step# is "9">

<!-- GET KEY SIZE STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/get_pgp_key_size.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
    output = "#REReplace("#temp#","THE_KEY","#getkeyprint.cm_keyidhex#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
timeout = "240"
variable="thekeysize"
arguments="-inputformat none">
</cfexecute>

<cfif FindNoCase("Total number processed: 0", thekeysize)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=4>
<cfelseif FindNoCase("key not found", thekeysize)>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<cfset step=0>
<cfset m=4>

</cfif>


<!-- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>    
    
<!-- GET KEY SIZE ENDS HERE -->

<cfset step=10>

<!-- /cfif for step -->
</cfif>


<cfif #step# is "10">



<!-- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE STARTS HERE -->

<cfif #getkeyprint.cm_master# is "1">

<cfquery name="getparentdjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_id='#getkeyprint.cm_id#' and cm_master='1'
</cfquery>

<cfquery name="getchilddjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_parentid='#getkeyprint.cm_id#' and cm_master='0'
</cfquery>

<cfelseif #getkeyprint.cm_master# is "0">

<cfquery name="getparentdjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_id='#getkeyprint.cm_parentid#' and cm_master='1'
</cfquery>

<cfquery name="getchilddjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_parentid='#getkeyprint.cm_parentid#' and cm_master='0'
</cfquery>

</cfif>

<cfif #keytype# is "public">
<cfquery name="keystoreexists" datasource="#datasource#">
select * from recipient_keystores where pgp_key_id='#thekeyid#'
</cfquery>

<cfif #keystoreexists.recordcount# LT 1>

<cfif #getkeyprint.cm_expiration_date# is not "">
<cfset pgp_keystore_expiration_date = #DateFormat(getkeyprint.cm_expiration_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_expiration_time = #TimeFormat(getkeyprint.cm_expiration_date, "HH:mm:ss")#>
<cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">
<cfelseif #getkeyprint.cm_expiration_date# is "">
<cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
</cfif>

<cfif #type# is "1">
<cfset external=2>
<cfelseif #type# is "2">
<cfset external=1>
</cfif>

<cfset pgp_keystore_creation_date = #DateFormat(getkeyprint.cm_creation_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_creation_time = #TimeFormat(getkeyprint.cm_creation_date, "HH:mm:ss")#>
<cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">

<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('#url.id#', '#getkeyuserid.cm_userid#', '#thekeysize#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#getparentdjigzokeyring.cm_keyidhex#', '#getparentdjigzokeyring.cm_id#', '1', '#external#')
</cfquery>
</cfoutput>

<cfloop query="getchilddjigzokeyring">
<cfoutput>

<cfquery name="gethermesparent" datasource="#datasource#">
select id, pgp_fingerprint, pgp_key_id from recipient_keystores where pgp_key_id = '#getparentdjigzokeyring.cm_keyidhex#'
</cfquery>

<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#getkeyuserid.cm_userid#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
 '#thekeysize#', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#gethermesparent.id#', '#external#')
</cfquery>
</cfoutput>
</cfloop>

<!-- /CFIF for keystoreexists.recordcount -->
</cfif>

<cfelseif #keytype# is "private">
<cfquery name="keystoreexists" datasource="#datasource#">
select * from recipient_keystores where pgp_key_id='#thekeyid#'
</cfquery>

<cfif #keystoreexists.recordcount# LT 1>

<cfif #getkeyprint.cm_expiration_date# is not "">
<cfset pgp_keystore_expiration_date = #DateFormat(getkeyprint.cm_expiration_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_expiration_time = #TimeFormat(getkeyprint.cm_expiration_date, "HH:mm:ss")#>
<cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">
<cfelseif #getkeyprint.cm_expiration_date# is "">
<cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
</cfif>

<cfif #type# is "1">
<cfset external=2>
<cfelseif #type# is "2">
<cfset external=1>
</cfif>

<cfset pgp_keystore_creation_date = #DateFormat(getkeyprint.cm_creation_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_creation_time = #TimeFormat(getkeyprint.cm_creation_date, "HH:mm:ss")#>
<cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<cfif #theKey# is "">

<!-- GENERATE SECRET KEY -->
<cfset theKey=generateSecretKey("AES", 256)>
<cffile action = "write"
file = "/opt/hermes/keys/hermes.key"
output = "#theKey#">

<!-- READ SECRET KEY -->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_pgp_password, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_pgp_password, #theKey#, "AES", "Base64")>
</cfif>

<cfoutput>
<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('#url.id#', '#getkeyuserid.cm_userid#', '#encryptedPassword#', '#thekeysize#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
 '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#getparentdjigzokeyring.cm_keyidhex#', '#getparentdjigzokeyring.cm_id#', '1', '#external#')
</cfquery>
</cfoutput>

<cfloop query="getchilddjigzokeyring">
<cfoutput>

<cfquery name="gethermesparent" datasource="#datasource#">
select id, pgp_fingerprint, pgp_key_id from recipient_keystores where pgp_key_id = '#getparentdjigzokeyring.cm_keyidhex#'
</cfquery>

<cfquery name="insert" datasource="#datasource#">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#getkeyuserid.cm_userid#', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
 '#thekeysize#', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#gethermesparent.id#', '#external#')
</cfquery>
</cfoutput>
</cfloop>

<cfset show_pgp_password="">
<cfset encryptedPassword="">

<!-- Since it's possible for the keystore to exist in recipient_keystores but not have the password for the private key, we check to see if the
 checkkeyidexists.recordcount from above is LT 1. If so, we simply update the password field -->
 
<cfelseif #keystoreexists.recordcount# GTE 1>

<cfif #checkkeyidexists.recordcount# LT 1>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<cfif #theKey# is "">

<!-- GENERATE SECRET KEY -->
<cfset theKey=generateSecretKey("AES", 256)>
<cffile action = "write"
file = "/opt/hermes/keys/hermes.key"
output = "#theKey#">

<!-- READ SECRET KEY -->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_pgp_password, #theKey#, "AES", "Base64")>

<cfelseif #theKey# is not "">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(show_pgp_password, #theKey#, "AES", "Base64")>
</cfif>

<cfquery name="updatepasswordparent" datasource="#datasource#">
update recipient_keystores set pgp_keystore_password='#encryptedPassword#' where pgp_key_id='#getparentdjigzokeyring.cm_keyidhex#'
</cfquery>

<cfloop query="getchilddjigzokeyring">
<cfoutput>
<cfquery name="updatepasswordchild" datasource="#datasource#">
update recipient_keystores set pgp_keystore_password='#encryptedPassword#' where pgp_key_id='#cm_keyidhex#'
</cfquery>
</cfoutput>
</cfloop>

<cfset show_pgp_password="">
<cfset encryptedPassword="">

<!-- /CFIF for checkkeyidexists.recordcount -->
</cfif>

<!-- /CFIF for keystoreexists.recordcount -->
</cfif>

<!-- /CFIF for keytype -->
</cfif>

<cfset m=8>

<!-- Delete File -->
<cfset FiletoDelete="/opt/hermes/tmp/#NewFileName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>




<!-- /cfif for step -->
</cfif>
<!-- /cfif for action -->
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion17" style="height: 218px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" enctype="multipart/form-data" action="<cfoutput>import_pgp_key.cfm?id=#id#&type=#type#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="import"><input type="hidden" name="keytype" value="<cfoutput>#keytype#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="605">
                                          <table id="Table143" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 14px;">
                                              <td width="605" id="Cell932">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell933">
                                                <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="#theRecipient#"></cfoutput></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table186" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 106px;">
                                            <tr style="height: 14px;">
                                              <td width="954" id="Cell1165">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Private PGP Key Password <span style="font-weight: normal;">(Required if Private is selected above )</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1166">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #keytype# is "public">
<cfoutput>
<input type="password" id="FormsEditField5" name="password" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password#" disabled="disabled">
</cfoutput>

<cfelseif #keytype# is "private">
<cfoutput>
<input type="password" id="FormsEditField5" name="password" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="#show_pgp_password#">
</cfoutput>
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select PGP Key file <span style="font-weight: normal;">(.asc, .pgp or .gpg files only)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1022">
                                                <table width="567" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><input type="file" name="thekeyfile">
<input type="hidden" name="fileupload">












&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1026">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                                  <tr style="height: 17px;">
                                                    <td width="954" id="Cell1033">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="133" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><input type="submit" name="savechanges" onclick="this.disabled=true;this.value='Importing, please wait...';this.form.submit();" value="Import Key" style="height: 24px; width: 160px;">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="955">
                                      <tr valign="top" align="left">
                                        <td width="955" height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="955" id="Text567" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must enter a password in the Private PGP Key Password field</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;There was an error importing the PGP key you specified. This usually occurs because of any of the following reasons:<br>
You are attempting to import an invalid file<br> 
You are attempting to import a Private key when you have Public selected in the PGP Key Type field<br>
You are attempting to import a Public Key when you have Private selected in the PGP Key Type field.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key you are attempting to import already exists in the system. </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. You have entered an incorrect password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. The system accepts only files with .asc, .pgp and .gpg extensions</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. You must select a valid GPG Key file by browsing to the location of the file.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. A system error has occured. No valid file was found for import into Djigzo.</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File you are attempting to import is not for this recipient</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! The PGP Key File was successfully imported.</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="976">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule4" width="960" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="973">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="45"></td>
                          <td width="957">

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion18" style="height: 45px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="17"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="957">
                                        <table id="Table189" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="957" id="Cell1034">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="635" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><cfif #type# is "1">
<form name="apply_settings" action="<cfoutput>internal_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
  


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

<form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
  


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