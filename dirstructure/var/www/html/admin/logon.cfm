<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/
 
 
--->

<cfset datasource="hermes">
<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Logon</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">


<script type="text/javascript" src="./validation.js">
</script>
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(192,192,192); background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="53"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="97" width="988"><img id="Picture46" height="97" width="988" src="./top_blue_logon1.png" border="0" alt="top_blue_logon1" title="top_blue_logon1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="262" width="988"><cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "reason" default = "">
<cfif IsDefined("session.reason") is "True">
<cfset reason = #session.reason#>
</cfif> 

<cfparam name = "logoncount" default = "1"> 
<cfif IsDefined("session.logoncount") is "True">
<cfset logoncount = #session.logoncount#>
</cfif>

<cfif action is "login">

<cfif #logoncount# GT 10>
<CFSET session.reason = 'You have exceeded the maximum number of logons. Please wait 1 hour before trying again'>
<CFLOCATION url="logon.cfm" addtoken="no">

<cfelseif #logoncount# LTE 10>

<cfquery name="checkrestore" datasource="#datasource#">
select status from restore_jobs where status='running'
</cfquery>

<cfif #checkrestore.recordcount# GTE 1>
<CFSET session.reason = 'System Restore is in Progress. You will not be be able to log into the system until the process has completed'>
<CFLOCATION url="logon.cfm" addtoken="no">
</cfif>

<CFSET SESSION.LOGGEDIN = FALSE>
<cfparam name = "step" default = "0"> 

<CFQUERY NAME="checkuser" DATASOURCE="#datasource#">
	SELECT username, password
	FROM system_users
	WHERE username='#form.username#'
</CFQUERY>

<!-- is the username present in the database? -->

<cfif checkuser.recordcount LTE 0>

<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 10'>
<CFLOCATION url="logon.cfm" addtoken="no">

<cfelseif checkuser.recordcount GT 0>

<cfset theSalt="#Left(checkuser.password, 30)#">

<cfloop index="hashCount" from="1" to="5000">
<cfset passwordHash512=Hash(form.password & theSalt, 'SHA-512', 'UTF-8') />
</cfloop>


<cfset thePassword="#theSalt##passwordHash512#" />

<cfset compare_password = Compare(#thePassword#, #checkuser.password#)>

<cfif #compare_password# is "1">

<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 10'>
<CFLOCATION url="logon.cfm" addtoken="no">


<cfelseif #compare_password# is "-1">
<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 10'>
<CFLOCATION url="logon.cfm" addtoken="no">

<cfelseif #compare_password# is "0">
<cfset session.loggedin = true>
<cfset session.logoncount = 1>

<cfexecute name = "/opt/hermes/scripts/dmidecode"
arguments=""
timeout = "60">
</cfexecute>

<cffile action="read" file="/usr/share/UUID" variable="temp1">

<cfset temp2="#REReplace("#temp1#","#chr(10)#","","ALL")#">

<cfset temp3="#REReplace("#temp2#","#chr(13)#","","ALL")#">
<cfset temp4="#REReplace("#temp3#","","","ALL")#">
<cfset temp5="#REReplace("#temp4#","UUID:","","ALL")#">

<cffile action = "write"
    file = "/usr/share/UUID"
    output = "#TRIM(temp5)#" addnewline="no">

<cfset uuid2_file="/usr/share/UUID2">
<cfif fileExists(uuid2_file)> 

<cffile action="read" file="/usr/share/UUID" variable="uuid">
<cffile action="read" file="/usr/share/UUID2" variable="uuid2">
<cfset compare_uuid = Compare(#uuid#, #uuid2#)>

<cfif #compare_uuid# is "0">

<cffile action="read" file="/usr/share/lt" variable="lt">

<cfset lt2=#TRIM(lt)#>

<cfif #lt2# is "1">
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="date">
<cfset difference = #datediff("d", '#datenow# #timenow#', '#date#')#>

<cfif #difference# LT 1>

<cfquery name="getserial" datasource="#datasource#">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cffile action = "delete"
    file = "/usr/share/UUID2">

<cfset session.license="NEW">
<cfset session.edition="Community">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">

<cfelseif #difference# GTE 1>
<cfset session.license="VALID">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">
</cfif>

<cfelseif #lt2# is "2">
<cfset session.license="VALID">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">
</cfif>

<cfelseif #compare_uuid# is "1">
<cfquery name="getserial" datasource="#datasource#">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">

<cfelseif #compare_uuid# is "-1">
<cfquery name="getserial" datasource="#datasource#">
select parameter, value from system_settings where parameter='serial'
</cfquery>


<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">

</cfif>

<cfelseif NOT fileExists(uuid2_file)> 
<cfset session.license="NEW">
<cfset session.edition="Community">
<CFSET session.reason = "">
<CFLOCATION url="index.cfm" addtoken="no">

</cfif>


</cfif>
</cfif>

<!-- /CFIF FOR LOGONCOUNT -->
</cfif>

<!-- /CFIF FOR ACTION -->
</cfif>



                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion3" style="background-image: url('./middle_988.png'); height: 262px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="14" height="227"></td>
                          <td width="954">
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td height="26"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="954">
                                  <script type="text/javascript">
                                  <!--
                                  function __fv1_logon(form) {
                                   var args = {
                                  "username":[["NOF_isRequired", [''], "A username is required", "", ""], ["NOF_isLengthInRange", ['1', '30'], "The username must be a min of 1 character and a maximum of 30 characters", "", ""]],
                                  "password":[["NOF_isRequired", [''], "A password is required", "", ""], ["NOF_isLengthInRange", ['8', '30'], "The password must be a minimum of 8 characters and a maximum of 30 characters", "", ""]]
                                   };
                                   return NOF_validateForm(form, args, true, null,'Please correct the following errors:');
                                  }
                                  //-->
                                  </script>
                                  <form name="logon" action="" method="post" onSubmit="return __fv1_logon(this)">
                                    <input type="hidden" name="action" value="login">
                                    <table id="Table3" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 144px;">
                                      <tr style="height: 18px;">
                                        <td width="954" id="Cell10">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Administration Console</span></b></p>
                                        </td>
                                      </tr>
                                      <tr style="height: 18px;">
                                        <td id="Cell11">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="198" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Username</span></b></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 28px;">
                                        <td id="Cell12">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center"><input type="text" id="FormsEditField1" name="username" size="25" maxlength="30" style="width: 196px; white-space: pre;"></td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 18px;">
                                        <td id="Cell13">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="198" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Password</span></b></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 28px;">
                                        <td id="Cell14">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center"><input type="password" id="FormsEditField2" name="password" size="25" maxlength="30" style="width: 196px; white-space: pre;" style="white-space:pre"></td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 31px;">
                                        <td id="Cell15">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Logon" style="height: 24px; width: 142px;">&nbsp;</p>
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
                            <table border="0" cellspacing="0" cellpadding="0" width="954">
                              <tr valign="top" align="left">
                                <td width="954" height="4"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="954" id="Text11" class="TextObject">
                                  <p style="text-align: center; margin-bottom: 0px;"><cfoutput>

<P STYLE="text-align: center;"><SPAN STYLE="font-size: x-small; color: rgb(255,0,0); FACE="Arial,Helvetica,Geneva,Sans-serif,sans-serif">#reason#</P>

</cfoutput>&nbsp;</p>
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>
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