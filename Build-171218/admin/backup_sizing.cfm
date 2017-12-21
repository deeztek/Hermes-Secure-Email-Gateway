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
<title>Backup Sizing</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-image: url('./top_blue.png'); margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0">
            <tr valign="top" align="left">
              <td width="9" height="53"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td></td>
              <td width="644">
                <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="644" style="height: 56px;">
                  <tr style="height: 28px;">
                    <td width="644" id="Cell8">
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"></p>
                    </td>
                  </tr>
                  <tr style="height: 448px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 448px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="635">
                                    <tr valign="top" align="left">
                                      <td width="635" id="Text468" class="TextObject">
                                        <p><span style="font-size: 12px;">The information below are presented to you in order to assist you in planning and sizing your backup repository accordingly. <b>The sizing shown below is not taking into consideration backups compression, so it shows more space needed that what is actually needed. </b></span></p>
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Ensure that your backup repository has enough space to accommodate your backups. If enough space is not available, your backups will fail <u>without any indication of a problem</u>.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="635">
                                    <tr valign="top" align="left">
                                      <td width="635" height="14"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="635" id="Text467" class="TextObject" style="background-color: rgb(243,239,239);">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Backup w/out E-mail Archive Data Statistics and Approximate Sizing Requirements</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="634"><cfquery name="gethermes" datasource="hermes">
SELECT  sum(round(((data_length + index_length) / 1024 / 1024 / 1024), 2))  as "size" FROM information_schema.TABLES  WHERE table_schema = "hermes"
</cfquery>

<cfif #gethermes.size# LT 0>
<cfset hermessize=0>
<cfelse>
<cfset hermessize=#gethermes.size#>
</cfif>

<cfquery name="getdjigzo" datasource="djigzo">
SELECT  sum(round(((data_length + index_length) / 1024 / 1024 / 1024), 2))  as "size" FROM information_schema.TABLES  WHERE table_schema = "djigzo"
</cfquery>

<cfif #getdjigzo.size# LT 0>
<cfset djigzosize=0>
<cfelse>
<cfset djigzosize=#getdjigzo.size#>
</cfif>

<cfquery name="getsyslog" datasource="syslog">
SELECT  sum(round(((data_length + index_length) / 1024 / 1024 / 1024), 2))  as "size" FROM information_schema.TABLES  WHERE table_schema = "Syslog"
</cfquery>

<cfif #getsyslog.size# LT 0>
<cfset syslogsize=0>
<cfelse>
<cfset syslogsize=#getsyslog.size#>
</cfif>

<cfexecute name = "/opt/hermes/scripts/get_amavis_size.sh"
variable="amavissize"
timeout = "300">
</cfexecute>

<cfoutput>

<cfset asize2 = TRIM(#ReReplaceNoCase(amavissize,"[^0-9]","","ALL")#)>

<cfset totalwithamavis=#asize2#+#hermessize#+#djigzosize#+#syslogsize#>
<cfset totalwoutamavis=#hermessize#+#djigzosize#+#syslogsize#>

<cfset totalwithamavis7=#totalwithamavis#*7>
<cfset totalwithamavis14=#totalwithamavis#*14>
<cfset totalwithamavis21=#totalwithamavis#*21>
<cfset totalwithamavis28=#totalwithamavis#*28>

<cfset totalwoutamavis7=#totalwoutamavis#*7>
<cfset totalwoutamavis14=#totalwoutamavis#*14>
<cfset totalwoutamavis21=#totalwoutamavis#*21>
<cfset totalwoutamavis28=#totalwoutamavis#*28>


                                        <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="634" style="height: 66px;">
                                          <tr style="height: 14px;">
                                            <td width="336" id="Cell1112">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Total Backup Size</span></p>
                                            </td>
                                            <td width="298" id="Cell1113">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwoutamavis# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1114">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 7 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1115">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwoutamavis7# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1116">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 14 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1117">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwoutamavis14# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1118">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 21 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1119">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwoutamavis21# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1120">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 28 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1121">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwoutamavis28# GB</span></p>
                                            </td>
                                          </tr>
                                        </table>
                                        </cfoutput></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="635">
                                    <tr valign="top" align="left">
                                      <td width="635" height="21"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="635" id="Text469" class="TextObject" style="background-color: rgb(243,239,239);">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Backup with E-mail Archive Data Statistics and Approximate Sizing Requirements</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="634"><cfoutput>
                                        <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="634" style="height: 60px;">
                                          <tr style="height: 14px;">
                                            <td width="335" id="Cell1122">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Total Backup Size</span></p>
                                            </td>
                                            <td width="299" id="Cell1123">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwithamavis# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1124">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 7 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1125">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwithamavis7# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1126">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 14 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1127">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwithamavis14# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1128">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 21 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1129">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwithamavis21# GB</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell1130">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Approximate Space Required for 28 Days Retention</span></p>
                                            </td>
                                            <td id="Cell1131">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">#totalwithamavis28# GB</span></p>
                                            </td>
                                          </tr>
                                        </table>
                                        </cfoutput></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="22"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="635">
                                        <form name="Table128FORM" action="system_backup.cfm" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="635" id="Cell769">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="338" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to System Backup" style="height: 24px; width: 357px;">
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
                  <tr style="height: 32px;">
                    <td id="Cell10">
                      <p style="margin-bottom: 0px;"><img id="Picture2" height="32" width="635" src="./background_635_bottom.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_bottom" title="background_635_bottom"></p>
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