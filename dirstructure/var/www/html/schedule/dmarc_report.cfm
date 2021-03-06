<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DMARC Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="950">
    <tr valign="top" align="left">
      <td width="9" height="8"></td>
      <td width="941"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="941" id="Text441" class="TextObject">
        <p style="margin-bottom: 0px;"><cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
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

<!--- GET MYSQL OPENDMARC CREDENTIALS BELOW --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">
<cfparam name = "algo" default = "AES">
<cfparam name = "encoding" default = "Base64">

<!--- GET OPENDMARC USERNAME --->
<cfquery name="get_mysql_username_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_username_opendmarc'
</cfquery>

<cfif #get_mysql_username_opendmarc.value# is "">

<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#getpostmaster.value#" subject="Hermes Secure Email Gateway DMARC Reports Error" type="Text" server="localhost" port="10026">
There was an error while trying to execute the DMARC Reports: The MySQL OpenDMARC Database Username is empty. Please goto System --> System Settings and correct the error.
</cfmail>

<cfelseif #get_mysql_username_opendmarc.value# is not "">

<cfset mysqlusernameopendmarc=#get_mysql_username_opendmarc.value#>

</cfif>

<!--- GET OPENDMARC PASSWORD --->
<cfquery name="get_mysql_password_opendmarc" datasource="#datasource#">
select parameter, value from system_settings where parameter='mysql_password_opendmarc'
</cfquery>

<cfif #get_mysql_password_opendmarc.value# is "">

<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#getpostmaster.value#" subject="Hermes Secure Email Gateway DMARC Reports Error" type="Text" server="localhost" port="10026">
There was an error while trying to execute the DMARC Reports: The MySQL OpenDMARC Database Password is empty. Please goto System --> System Settings and correct the error.
</cfmail>


<cfelseif #get_mysql_password_opendmarc.value# is not "">


<!--- DECRYPT OPENDMARC PASSWORD --->
<cfset mysqlpasswordopendmarc=decrypt(get_mysql_password_opendmarc.value, #authkey#, #algo#, #encoding#)>

</cfif>

<!--- GET MYSQL OPENDMARC CREDENTIALS ABOVE --->

<!--- GET REPORTING EMAIL & REPORTING ORGANIZATION BELOW  --->

<cfquery name="get_report_email" datasource="#datasource#">
select value2 from parameters2 where parameter='report_email' and module = 'dmarc'
</cfquery>

<cfquery name="get_report_org" datasource="#datasource#">
select value2 from parameters2 where parameter='report_org' and module = 'dmarc'
</cfquery>

<!--- GET REPORTING EMAIL & REPORTING ORGANIZATION ABOVE --->

<!--- CHECK FOR EXISTENCE OF /OPT/HERMES/TMP/DMARC DIRECTORY AND CREATE IF IT DOES NOT EXIST --->
<cfset DmarcDirectory="/opt/hermes/tmp/dmarc">
<cfif DirectoryExists(DmarcDirectory)> 
<cfelse>
<cfexecute name = "/bin/mkdir"
arguments="/opt/hermes/tmp/dmarc"
timeout = "60">
</cfexecute>

</cfif>


<!--- CREATE DMARC_REPORT_SCRIPT.SH FILE BELOW --->


<cffile action="read" file="/opt/hermes/scripts/dmarc_report_script.sh" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh"
    output = "#REReplace("#dmarcfile#","DATABASE-USER","#mysqlusernameopendmarc#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh"
    output = "#REReplace("#dmarcfile#","DATABASE-PASSWORD","#mysqlpasswordopendmarc#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh"
    output = "#REReplace("#dmarcfile#","REPORTING-EMAIL","#get_report_email.value2#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">

<cffile action = "write"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh"
    output = "#REReplace("#dmarcfile#","REPORTING-ORGANIZATION","#get_report_org.value2#","ALL")#">

<!--- CREATE DMARC_REPORT_SCRIPT.SH FILE ABOVE --->


<!--- CREATE RUN_DMARC_REPORT_SCRIPT.SH FILE BELOW --->

<cffile action = "WRITE"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_run_dmarc_report_script.sh"
    output = "/bin/chmod +x /opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh">

<cffile action = "APPEND"
    file = "/opt/hermes/tmp/dmarc/#customtrans3#_run_dmarc_report_script.sh"
    output = "/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh > /opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report.log 2>&1">

<!--- MAKE RUN_DMARC_REPORT_SCRIPT.SH EXECUTABLE --->
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/dmarc/#customtrans3#_run_dmarc_report_script.sh"
timeout = "60">
</cfexecute>

<!--- CHANGE OWNER OF /OPT/HERMES/TMP/DMARC TO OPENDMARC USER --->
<cfexecute name = "/bin/chown"
arguments="-R opendmarc:opendmarc /opt/hermes/tmp/dmarc"
timeout = "60">
</cfexecute>

<!--- EXECUTE RUN_DMARC_REPORT_SCRIPT.SH EXECUTABLE --->
<cfexecute name = "/usr/bin/sudo -u opendmarc /opt/hermes/tmp/dmarc/#customtrans3#_run_dmarc_report_script.sh"
timeout = "1800">
</cfexecute>



<!--- DELETE RUN_DMARC_REPORT_SCRIPT.SH --->
<cfset FiletoDelete="/opt/hermes/tmp/dmarc/#customtrans3#_run_dmarc_report_script.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!--- DELETE DMARC_REPORT_SCRIPT.SH --->
<cfset FiletoDelete="/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report_script.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!--- FIX PERMISSIONS THAT GOT CHANGED TO ROOT FROM RUNNING SCRIPT ABOVE AS ROOT ON /VAR/RUN/OPENDMARC --->
<cfexecute name = "/bin/chown"
arguments="-R opendmarc:opendmarc /var/run/opendmarc/"
timeout = "60">
</cfexecute>


<!--- SEND DMARC REPORTS SUCCESS EMAIL AND ATTACH LOG CREATED ABOVE --->

<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#getpostmaster.value#" subject="Hermes Secure Email Gateway DMARC Reports Success" type="Text" server="localhost" port="10026">
The Hermes Secure Email Gateway DMARC Reports executed succesfully. Results log is attached to this email.

<cfmailparam 
file="/opt/hermes/tmp/dmarc/#customtrans3#_dmarc_report.log" 
disposition="attachment" remove="true">

</cfmail>


 &nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   