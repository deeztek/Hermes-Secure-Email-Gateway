<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/
 
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Disable DKIM Sign</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

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
                <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 56px;">
                  <tr style="height: 28px;">
                    <td width="644" id="Cell8">
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"></p>
                    </td>
                  </tr>
                  <tr style="height: 132px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>

<cfif NOT structKeyExists(form, "domain")>
<cflocation url="error.cfm" addtoken="no">
<cfelseif structKeyExists(form, "domain")>
<cfif form.domain is "">
<cflocation url="error.cfm" addtoken="no">
<cfelseif form.domain is not "">

<cfquery name="getdkim" datasource="#datasource#">
select dkim_sign.private, dkim_sign.public from dkim_sign where dkim_sign.domain='#form.domain#'
</cfquery>

<cfif #getdkim.recordcount# LT 1>
<cflocation url="dkim_sign.cfm?m=2" addtoken="no">


<cfelseif #getdkim.recordcount# GTE 1>

<cfparam name = "domain" default = "#form.domain#"> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif> 

<cfif #action# is "disable">

<cfset PrivateFile="/opt/hermes/dkim/keys/#form.domain#.dkim.private">
<cfif fileExists(PrivateFile)>
<cffile 
action = "delete"
file = "#PrivateFile#">
<!-- /CFIF fileExists(PrivateFile) -->
</cfif>

<cfset PublicFile="/opt/hermes/dkim/keys/#form.domain#.dkim.txt">
<cfif fileExists(PublicFile)>
<cffile 
action = "delete"
file = "#PublicFile#">
<!-- /CFIF fileExists(PublicFile) -->
</cfif>

<!-- DELETE KEYTABLE ENTRIES FROM DATABASE --> 
<cfquery name="deletedkim" datasource="#datasource#">
delete from dkim_sign where dkim_sign.domain='#form.domain#'
</cfquery>

<!-- GET KEYTABLE ENTRIES FROM DATABASE --> 
<cfquery name="getkeys" datasource="#datasource#">
select dkim_sign.domain, dkim_sign.private from dkim_sign
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

<cfif #getkeys.recordcount# GTE 1>

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
    
<cflocation url="dkim_sign.cfm?m=3" addtoken="no">

<cfelseif #getkeys.recordcount# LT 1>

<cfset FileData="">

<!-- WRITE EMPTY DATA TO /OPT/HERMES/DKIM/KEYTABLE --> 
<cffile action = "write"
    file = "/opt/hermes/dkim/KeyTable"
    output = "#FileData#" addnewline="no">
    
<!-- WRITE EMPTY DATA TO /OPT/HERMES/DKIM/SIGNINGTABLE -->  
<cffile action = "write"
    file = "/opt/hermes/dkim/SigningTable"
    output = "#FileData#" addnewline="no">
    
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
    
<cflocation url="dkim_sign.cfm?m=3" addtoken="no">

<!-- /CFIF GETKEYS.RECORDCOUNT -->
</cfif>

<cfelseif #action# is "cancel">
<cflocation url="dkim_sign.cfm" addtoken="no">

<!-- /CFIF for action -->
</cfif>

<!-- /CFIF #getdkim.recordcount# -->
</cfif>

<!-- /CFIF form.domain is "" -->
</cfif>

<!-- /CFIF structKeyExists(form, "domain") -->
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 132px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="628">
                                    <tr valign="top" align="left">
                                      <td colspan="2"></td>
                                      <td colspan="2" width="614" id="Text272" class="TextObject"><cfoutput>
                                        <p style="text-align: center; margin-bottom: 0px;"><b>Are you sure you want to disable DKIM for the #domain# domain?</b></p>
                                        
</cfoutput></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="13" height="3"></td>
                                      <td width="1"></td>
                                      <td width="613"></td>
                                      <td width="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td colspan="2" width="614" id="Text462" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b><span style="color: rgb(255,0,0);">Ensure you have deleted the DKIM TXT Record from your DNS before clicking the Yes button below. Failure to do so has the potential for your email being rejected by remote email servers.</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="11" height="4"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="615">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 10px;">
                                          <tr style="height: 24px;">
                                            <td width="615" id="Cell769">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="178" style="height: 24px;">
                                                      <tr style="height: 24px;">
                                                        <td width="93" id="Cell770">
                                                          <form name="Cell770FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="disable"><input type="hidden" name="domain" value="<cfoutput>#form.domain#</cfoutput>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton11" name="FormsButton11" value="YES" style="height: 24px; width: 49px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                        <td width="85" id="Cell771">
                                                          <form name="Cell771FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="cancel"><input type="hidden" name="domain" value="<cfoutput>#form.domain#</cfoutput>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton12" name="FormsButton12" value="NO" style="height: 24px; width: 39px;"></td>
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