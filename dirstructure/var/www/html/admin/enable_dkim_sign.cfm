<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Enable DKIM Sign</title>
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
              <td height="438" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>


                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 438px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="506"></td>
                          <td width="447"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Enable DKIM Sign</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="165"></td>
                          <td colspan="2" width="953"><cfif NOT structKeyExists(form, "domain")>
<cflocation url="error.cfm" addtoken="no">
<cfelseif structKeyExists(form, "domain")>
<cfif form.domain is "">
<cflocation url="error.cfm" addtoken="no">
<cfelseif form.domain is not "">

<cfparam name = "m1" default = "0">

<CFPARAM NAME="domain" DEFAULT="#form.domain#">
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif>

<CFPARAM NAME="theID" DEFAULT="#form.id#">
<cfif IsDefined("form.id") is "True">
<cfif form.id is not "">
<cfset theID = form.id>
</cfif></cfif>

<CFPARAM NAME="dkimkey" DEFAULT="1024">
<cfif IsDefined("form.dkimkey") is "True">
<cfif form.dkimkey is not "">
<cfset dkimkey = form.dkimkey>
</cfif></cfif>

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfif #action# is "generate">


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


<cffile action="read" file="/opt/hermes/scripts/generate_dkim.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_generate_dkim.sh"
    output = "#REReplace("#temp#","THE-KEY","#dkimkey#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_generate_dkim.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_generate_dkim.sh"
    output = "#REReplace("#temp#","THE-DOMAIN","#domain#","ALL")#" addnewline="no">
    


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_generate_dkim.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_generate_dkim.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_generate_dkim.sh">
    




<!-- CHECK PRIVATE FILE EXISTS -->
<cfset PrivateFile="/opt/hermes/dkim/keys/#domain#.dkim.private">
<cfif fileExists(PrivateFile)>

<!-- CHECK PRIVATE FILE EXISTS --> 
<cfset PublicFile="/opt/hermes/dkim/keys/#domain#.dkim.txt">
<cfif fileExists(PublicFile)>

<cfquery name="insertdkim" datasource="#datasource#">
insert into dkim_sign (dkim_sign.domain, dkim_sign.applied, dkim_sign.public, dkim_sign.private, dkim_sign.enabled, dkim_sign.generated) values ('#domain#', '1', '#domain#.dkim.txt', '#domain#.dkim.private', '1', '1')
</cfquery>

<!-- GET KEYTABLE ENTRIES FROM DATABASE --> 
<cfquery name="getkeys" datasource="#datasource#">
select domain, private from dkim_sign
</cfquery>

<!-- LOOP THROUGH KEYTABLE ENTRIES FROM DATABASE AND CREATE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE --> 
<cfloop query="getkeys">

<cffile action="read" file="/opt/hermes/templates/DkimKeyTable" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_DkimKeyTable"
    output = "#REReplace("#temp#","THE-DOMAIN","#getkeys.domain#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_DkimKeyTable" variable="temp">

<cffile action = "append" file = "/opt/hermes/tmp/#customtrans3#_KeyTable" output = "#temp#" addnewline="no">

</cfloop>

<!-- DELETE /opt/hermes/tmp/#customtrans3#_DkimKeyTable --> 
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_DkimKeyTable">

<!-- CREATE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/KEYTABLE --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_mv_keytable.sh"
    output = "/bin/cp /opt/hermes/dkim/KeyTable /opt/hermes/dkim/KeyTable.HERMES#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#_KeyTable /opt/hermes/dkim/KeyTable" addnewline="no">


<cfexecute name ="/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_mv_keytable.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_mv_keytable.sh"
timeout = "240">
</cfexecute>

<!-- DELETE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/KEYTABLE --> 
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_mv_keytable.sh">
    
    
<!-- CREATE SCRIPT TO CHANGE OWNER OF /OPT/HERMES/DKIM/KEYS TO OPENDKIM:OPENDKIM --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_change_keys_owner.sh"
    output = "/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/" addnewline="no">


<cfexecute name ="/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_change_keys_owner.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_change_keys_owner.sh"
timeout = "240">
</cfexecute>

<!-- DELETE SCRIPT TO SCRIPT TO CHANGE OWNER OF /OPT/HERMES/DKIM/KEYS TO OPENDKIM:OPENDKIM --> 
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_change_keys_owner.sh">
    

<!-- LOOP THROUGH KEYTABLE ENTRIES FROM DATABASE AND CREATE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE --> 
<cfloop query="getkeys">

<cffile action="read" file="/opt/hermes/templates/DkimSignTable" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_DkimSignTable"
    output = "#REReplace("#temp#","THE-DOMAIN","#getkeys.domain#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_DkimSignTable" variable="temp">

<cffile action = "append" file = "/opt/hermes/tmp/#customtrans3#_SignTable" output = "#temp#" addnewline="no">

</cfloop>

<!-- DELETE /opt/hermes/tmp/#customtrans3#_DkimSignTable --> 
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_DkimSignTable">

<!-- CREATE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/SIGNINGTABLE --> 
<cffile action = "write" file = "/opt/hermes/tmp/#customtrans3#_mv_signtable.sh" output = "/bin/cp /opt/hermes/dkim/SigningTable /opt/hermes/dkim/SigningTable.HERMES#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#_SignTable /opt/hermes/dkim/SigningTable" addnewline="no">


<cfexecute name ="/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_mv_signtable.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_mv_signtable.sh"
timeout = "240">
</cfexecute>

<!-- DELETE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/SIGNINGTABLE --> 
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_mv_signtable.sh">
  
<!-- RELOAD & RESTART OPENDKIM -->   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
    output = "/usr/sbin/service opendkim reload#chr(10)#/usr/sbin/service opendkim restart" addnewline="no">


<cfexecute name ="/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_restart_opendkim.sh">

<!-- RELOAD & RESTART POSTFIX --> 
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
    output = "/usr/sbin/service postfix reload#chr(10)#/usr/sbin/service postfix restart" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_restart_postfix.sh">
    
<cflocation url="dkim_sign.cfm?m=1" addtoken="no">

<cfelse>
<cfset m=1>
<!-- PrivateFile Exists -->
</cfif>

<cfelse>
<cfset m=1>
<!-- PublicFile Exists -->
</cfif>



<!-- /CFIF  action  -->
</cfif>

<!-- /CFIF form.domain is "" -->
</cfif>

<!-- /CFIF structKeyExists(form, "domain") -->
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion17" style="height: 165px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>enable_dkim_sign.cfm</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="generate"><input type="hidden" name="domain" value="<cfoutput>#domain#</cfoutput>"><input type="hidden" name="id" value="<cfoutput>#theID#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="595">
                                          <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 17px;">
                                              <td width="595" id="Cell1029">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1030">
                                                <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="#domain#">
</cfoutput>

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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="590">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 45px;">
                                            <tr style="height: 14px;">
                                              <td width="586" id="Cell886">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">DKIM Key Length</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell887">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 21px;">
                                                          <td width="51" id="Cell1032">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #dkimkey# is "1024">
<cfoutput>
<input type="radio" checked="checked" name="dkimkey" value="1024" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dkimkey# is not "1024">
<cfoutput>
<input type="radio" name="dkimkey" value="1024" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="480" id="Cell1031">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">1024-bits</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 21px;">
                                                          <td id="Cell411">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #dkimkey# is "2048">
<cfoutput>
<input type="radio" checked="checked" name="dkimkey" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #dkimkey# is not "2048">
<cfoutput>
<input type="radio" name="dkimkey" value="2048" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell412">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2048-bits</span></b></p>
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
                                        <td height="15"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="194" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Generate DKIM Keys" style="height: 24px; width: 357px;">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="953">
                                      <tr valign="top" align="left">
                                        <td width="953" height="5"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953" id="Text276" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;there was an error generating DKIM keys. Please try again or contact support</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m1# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Relay  domain edited</span></i></b></p>
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
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="953"><hr id="HRRule2" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td colspan="3" width="956">

                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="<cfoutput>dkim_sign.cfm</cfoutput>" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="591" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to DKIM Sign" style="height: 24px; width: 357px;">
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