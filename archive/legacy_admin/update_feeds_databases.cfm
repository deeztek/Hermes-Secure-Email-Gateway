<cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm" addToken="no">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm" addToken="no">
</cfif>
</cfif>
<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Update Feeds Databases</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="867">
    <tr valign="top" align="left">
      <td width="47" height="57"></td>
      <td width="820"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="820" id="Text378" class="TextObject">
        <p style="margin-bottom: 0px;"><!--- CREATE CUSTOMTRANS --->
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


<!--- START SANESECURITY--->
<cfquery name = "sanesecurityconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'sanesecurity'
</cfquery>

<cffile action="read" file="/opt/hermes/conf_files/user.conf" variable="temp">

<cfif #sanesecurityconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #sanesecurityconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-ENABLED","no","ALL")#" addnewline="no">

<!--- /CFIF sanesecurity.enabled --->
</cfif>

<!--- START SANESECURITY DBS--->
<cfquery name = "sanesecuritydbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'sanesecurity' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="sanesecuritydbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_sanesecuritydbs" variable="sanesecuritydbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SANESECURITY-DBS","#sanesecuritydbsfile#","ALL")#" addnewline="no">


<cfif FileExists("/opt/hermes/tmp/#customtrans3#_sanesecuritydbs")>
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_sanesecuritydbs">
</cfif>

<!--- END SANESECURITY DBS--->

<!--- END SANESECURITY--->

<!--- START SECURITEINFO --->
<cfquery name = "securiteinfoconf" datasource="#datasource#">
select enabled, update_int, code, securite_premium from malware_feeds where name = 'securiteinfo'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #securiteinfoconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-AUTHORIZATION-SIGNATURE","#securiteinfoconf.code#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-UPDATE","#securiteinfoconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #securiteinfoconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-AUTHORIZATION-SIGNATURE","#securiteinfoconf.code#","ALL")#" addnewline="no">

    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-UPDATE","#securiteinfoconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITEINFO-ENABLED","no","ALL")#" addnewline="no">
    

<!--- /CFIF securiteinfoconf.enabled --->
</cfif>

<cfif #securiteinfoconf.securite_premium# is "yes">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITE-PREMIUM","yes","ALL")#" addnewline="no">

<cfelseif #securiteinfoconf.securite_premium# is "no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURITE-PREMIUM","no","ALL")#" addnewline="no">


<!--- /CFIF secureritepremium is --->
</cfif>


<!--- START SECURITEINFO DBS--->
<cfquery name = "securiteinfodbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'securiteinfo' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="securiteinfodbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_securiteinfodbs" variable="securiteinfodbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","SECURERITEINFO-DBS","#securiteinfodbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_securiteinfodbs")>
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_securiteinfodbs">
    
</cfif>
    
<!--- END SECURITEINFO DBS--->

<!--- END SECURITEINFO --->


<!--- START MALWAREPATROL--->
<cfquery name = "malwarepatrolconf" datasource="#datasource#">
select enabled, update_int, code, product, list, malwarepatrol_free from malware_feeds where name = 'malwarepatrol'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #malwarepatrolconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-RECEIPT-CODE","#malwarepatrolconf.code#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-PRODUCT-CODE","#malwarepatrolconf.product#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-LIST","#malwarepatrolconf.list#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-FREE","#malwarepatrolconf.malwarepatrol_free#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-UPDATE","#malwarepatrolconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #malwarepatrolconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-RECEIPT-CODE","","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-PRODUCT-CODE","","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-LIST","#malwarepatrolconf.list#","ALL")#" addnewline="no">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-FREE","#malwarepatrolconf.malwarepatrol_free#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-UPDATE","#malwarepatrolconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","MALWAREPATROL-ENABLED","no","ALL")#" addnewline="no">

<!--- /CFIF malwarepatrol.enabled --->
</cfif>

<!--- END MALWAREPATROL--->


<!--- START LINUXMALWAREDETECT --->
<cfquery name = "linuxmalwaredetectconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'linuxmalwaredetect'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #linuxmalwaredetectconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-UPDATE","#linuxmalwaredetectconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #linuxmalwaredetectconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-UPDATE","#linuxmalwaredetectconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-ENABLED","no","ALL")#" addnewline="no">

<!--- /CFIF linuxmalwaredetect.enabled --->
</cfif>

<!--- START LINUXMALWAREDETECT DBS--->
<cfquery name = "linuxmalwaredetectdbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'linuxmalwaredetect' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="linuxmalwaredetectdbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs" variable="linuxmalwaredetectdbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","LINUXMALWAREDETECT-DBS","#linuxmalwaredetectdbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs")>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_linuxmalwaredetectdbs">

</cfif>
    
<!--- END LINUXMALWAREDETECT DBS--->


<!--- END LINUXMALWAREDETECT --->


<!--- START YARARULES --->
<cfquery name = "yararulesconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'yararules'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #yararulesconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-UPDATE","#yararulesconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #yararulesconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-UPDATE","#yararulesconf.update_int#","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-ENABLED","no","ALL")#" addnewline="no">

<!--- /CFIF yararulesCONF.enabled --->
</cfif>

<!--- START YARRARULES DBS--->
<cfquery name = "yararulesdbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'yararules' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="yararulesdbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_yararulesdbs" variable="yararulesdbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","YARARULES-DBS","#yararulesdbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_yararulesdbs")>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_yararulesdbs">
    
</cfif>   
    
<!--- END YARRARULES DBS--->

<!--- END YARARULES --->

<!--- START URLHAUS --->
<cfquery name = "urlhausconf" datasource="#datasource#">
select enabled, update_int from malware_feeds where name = 'urlhaus'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cfif #urlhausconf.enabled# is "yes">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","URLHAUS-UPDATE","#urlhausconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","URLHAUS-ENABLED","yes","ALL")#" addnewline="no">

<cfelseif #urlhausconf.enabled# is "no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","URLHAUS-UPDATE","#urlhausconf.update_int#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","URLHAUS-ENABLED","no","ALL")#" addnewline="no">
    
    
<!--- /CFIF urlhaus.enabled --->
</cfif>

<!--- START URLHAUS DBS--->
<cfquery name = "urlhausdbs" datasource="#datasource#">
select db, active, feed from malware_databases where feed = 'urlhaus' and active = 'true'
</cfquery>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_urlhausdbs"
    output = ""
    addNewLine = "no">
    
<cfoutput query="urlhausdbs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_urlhausdbs"
    output = "#db##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_urlhausdbs" variable="urlhausdbsfile">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_user.conf" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf"
    output = "#REReplace("#temp#","URLHAUS-DBS","#urlhausdbsfile#","ALL")#" addnewline="no">

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_urlhausdbs")>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_urlhausdbs">
    
</cfif>   
    
<!--- END URLHAUS DBS--->

<!--- END URLHAUS --->

<cfif FileExists("/opt/hermes/tmp/#customtrans3#_user.conf")>

<cfexecute name = "/bin/cp"
arguments="/etc/clamav-unofficial-sigs/user.conf /etc/clamav-unofficial-sigs/user.HERMES"
timeout = "60">
</cfexecute>

<cfexecute name = "/bin/cp"
arguments="/opt/hermes/tmp/#customtrans3#_user.conf /etc/clamav-unofficial-sigs/user.conf"
timeout = "60">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_user.conf">

<cfquery name="updatedatabases" datasource="#datasource#">
update malware_databases set applied = '1'
</cfquery>


<cfset m=7>

<cfelse>

<cfset m=8>

<!--- /CFIF FileExists /opt/hermes/tmp/#customtrans3#_user.conf --->
</cfif>&nbsp;</p>
      </td>
    </tr>
  </table>
  

</body>
</html>
   