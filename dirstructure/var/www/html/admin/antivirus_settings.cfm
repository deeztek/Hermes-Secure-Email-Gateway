<!---
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
    --->
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Antivirus Settings</title>
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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="1232" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1232px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="9" height="21"></td>
                          <td width="2"></td>
                          <td width="506"></td>
                          <td width="445"></td>
                          <td width="2"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text291" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antivirus Settings</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="951" id="Text500" class="TextObject" style="background-color: rgb(102,153,51);">
                            <p style="margin-bottom: 0px;"><b><span style="color: rgb(255,255,255);">This page has been upgraded to our 2.0 interface. Please click <a href="/admin/2/view_antivirus_settings.cfm">here</a> to use the new version</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="955"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="5" valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="46"></td>
                          <td colspan="4" width="955"><cfparam name = "show_action2" default = "view"> 
<cfif IsDefined("form.action2") is "True">
<cfif form.action2 is not "">
<cfset show_action2 = form.action2>
</cfif></cfif> 

<cfif #show_action2# is "apply">
<cfset m2=16>

<cfquery name="getScanMail" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanMail' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanArchive" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanArchive' and active = '1' and module='clamav'
</cfquery>


<cfquery name="getArchiveBlockEncrypted" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ArchiveBlockEncrypted' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPE" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPE' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanOLE2" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanOLE2' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getOLE2BlockMacros" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='OLE2BlockMacros' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanPDF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanPDF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanHTML" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanHTML' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getAlgorithmicDetection" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='AlgorithmicDetection' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getScanELF" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='ScanELF' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingSignatures" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingSignatures' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingScanURLs" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingScanURLs' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockSSLMismatch" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockSSLMismatch' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getPhishingAlwaysBlockCloak" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockCloak' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getDetectPUA" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='DetectPUA' and active = '1' and module='clamav'
</cfquery>

<cfquery name="getHeuristicScanPrecedence" datasource="#datasource#">
select parameter, value2 from parameters2 where parameter='HeuristicScanPrecedence' and active = '1' and module='clamav'
</cfquery>



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

<cffile action="read" file="/opt/hermes/conf_files/clamd.conf.HERMES" variable="clam">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-Mail","ScanMail #getScanmail.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-Archive","ScanArchive #getScanArchive.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Archive-BlockEncrypted","ArchiveBlockEncrypted #getArchiveBlockEncrypted.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-PE","ScanPE #getScanPE.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-OLE2","ScanOLE2 #getScanOLE2.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","OLE2-BlockMacros","OLE2BlockMacros #getOLE2BlockMacros.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-PDF","ScanPDF #getScanPDF.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-HTML","ScanHTML #getScanHTML.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Algorithmic-Detection","AlgorithmicDetection #getAlgorithmicDetection.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Scan-ELF","ScanELF #getScanELF.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-Signatures","PhishingSignatures #getPhishingSignatures.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-ScanURLs","PhishingScanURLs #getPhishingScanURLs.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-AlwaysBlockSSLMismatch","PhishingAlwaysBlockSSLMismatch #getPhishingAlwaysBlockSSLMismatch.value2#","ALL")#">
 
 
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Phishing-AlwaysBlockCloak","PhishingAlwaysBlockCloak #getPhishingAlwaysBlockCloak.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","Detect-PUA","DetectPUA #getDetectPUA.value2#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES" variable="clam">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES"
    output = "#REReplace("#clam#","HeuristicScan-Precedence","HeuristicScanPrecedence #getHeuristicScanPrecedence.value2#","ALL")#">

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/cp /etc/clamav/clamd.conf /etc/clamav/clamd.conf.HERMES.BACKUP#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/bin/mv /opt/hermes/tmp/#customtrans3#_clamd.conf.HERMES /etc/clamav/clamd.conf#chr(10)#"
addnewline="no">

<cffile action = "write" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/usr/bin/dos2unix /etc/clamav/clamd.conf#chr(10)#"
addnewline="no">

<cffile action = "APPEND" 
file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
output = "/etc/init.d/clamav-daemon restart#chr(10)#/etc/init.d/amavis restart#chr(10)#/etc/init.d/postfix restart"
addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "240">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_apply.sh"> 

    
<cfquery name="updateparams" datasource="#datasource#">
update parameters2 set applied='1' where applied = '2' and module = 'clamav'
</cfquery> 
    
</cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="antivirus_settings.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from parameters2 where module = 'clamav' and applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="955">
                                    <tr valign="top" align="left">
                                      <td width="955" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955" id="Text351" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
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
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>
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
  </div>
</body>
</html>
   