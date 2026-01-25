
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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

<!--- UPDATE DMARC --->

<cfif #dmarcenabled# is "1">

  <cfquery name="dmarcsmtpd" datasource="hermes">
  update parameters set 
  enabled='1',
  applied='1'
  where
  parameter='inet:127.0.0.1:54321' and child = '1' and parent='#get_smtpd_milters_id.id#'
  </cfquery>
  
  <cfquery name="dmarcnonsmtpd" datasource="hermes">
  update parameters set 
  enabled='1',
  applied='1'
  where
  parameter='inet:127.0.0.1:54321' and child = '1' and parent='#get_non_smtpd_milters_id.id#'
  </cfquery>


<cfquery name="updateFailureReports" datasource="hermes">
  update parameters2 set 
  value2='#form.failurereports#',
  applied='1'
  where
  parameter='FailureReports' and module = 'dmarc'
  </cfquery>
  
  
  <cfquery name="UpdateRejectFailures" datasource="hermes">
  update parameters2 set 
  value2='#form.rejectfailures#',
  applied='1'
  where
  parameter='RejectFailures' and module = 'dmarc'
  </cfquery>

<cfquery name="UpdateHoldQuarantinedMessages" datasource="hermes">
  update parameters2 set 
  value2='#form.holdquarantinedmessages#',
  applied='1'
  where
  parameter='holdquarantinedmessages' and module = 'dmarc'
  </cfquery>

<cfif #form.failurereports# is "true">

  <cfquery name="updatereport_email" datasource="hermes">
    update parameters2 set 
    value2='#report_email#',
    applied='1'
    where
    parameter='report_email' and module = 'dmarc'
    </cfquery>
    
    <cfquery name="updatereport_org" datasource="hermes">
    update parameters2 set 
    value2='#report_org#',
    applied='1'
    where
    parameter='report_org' and module = 'dmarc'
    </cfquery>

<cfinclude template="dmarc_generate_config_file.cfm">
       
<cfinclude template="dmarc_generate_reports_script.cfm">

<cfinclude template="restart_opendmarc.cfm">

<cfinclude template="restart_postfix.cfm">


<cfelseif #form.failurereports# is "false">

  <!--- CHECK FOR EXISTENCE OF /OPT/HERMES/SCHEDULE/DMARC_REPORT_SCRIPT.SH AND DELETE IT --->
<cfset FiletoDelete="/opt/hermes/schedule/dmarc_report_script.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>

<cfinclude template="set_crontab.cfm">

<cfinclude template="dmarc_generate_config_file.cfm">
       
<cfinclude template="restart_opendmarc.cfm">

<cfinclude template="restart_postfix.cfm">

<!--- /CFIF #form.failurereports# is --->
</cfif>

<cfelseif #dmarcenabled# is "2">
  
  <cfquery name="dmarcsmtpd" datasource="hermes">
  update parameters set 
  enabled='2',
  applied='1'
  where
  parameter='inet:127.0.0.1:54321' and child = '1' and parent='#get_smtpd_milters_id.id#'
  </cfquery>
  
  <cfquery name="dmarcnonsmtpd" datasource="hermes">
  update parameters set 
  enabled='2',
  applied='1'
  where
  parameter='inet:127.0.0.1:54321' and child = '1' and parent='#get_non_smtpd_milters_id.id#'
  </cfquery>

<cfquery name="updateFailureReports" datasource="hermes">
  update parameters2 set 
  value2='false',
  applied='1'
  where
  parameter='FailureReports' and module = 'dmarc'
  </cfquery>

<!--- CHECK FOR EXISTENCE OF /OPT/HERMES/SCHEDULE/DMARC_REPORT_SCRIPT.SH AND DELETE IT --->
<cfset FiletoDelete="/opt/hermes/schedule/dmarc_report_script.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>

<cfinclude template="set_crontab.cfm">

<cfinclude template="dmarc_generate_config_file.cfm">
       
<cfinclude template="restart_opendmarc.cfm">

<cfinclude template="restart_postfix.cfm">
  
  <!--- /CFIF for #dmarcenabled# is --->
  </cfif>
  