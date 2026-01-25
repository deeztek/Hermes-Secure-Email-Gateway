
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

<cfquery name="get_failurereports" datasource="hermes">
  select value2 from parameters2 where parameter='FailureReports' and module = 'dmarc'
  </cfquery>
  
  
  <cfquery name="get_rejectFailures" datasource="hermes">
  select value2 from parameters2 where parameter='RejectFailures' and module = 'dmarc'
  </cfquery>

<cfquery name="get_holdquarantinedmessages" datasource="hermes">
  select value2 from parameters2 where parameter='HoldQuarantinedMessages' and module = 'dmarc'
  </cfquery>
  
  <cfquery name="get_report_email" datasource="hermes">
  select value2 from parameters2 where parameter='report_email' and module = 'dmarc'
  </cfquery>
  
  <cfquery name="get_report_org" datasource="hermes">
  select value2 from parameters2 where parameter='report_org' and module = 'dmarc'
  </cfquery>
  
  <cfquery name="get_interval" datasource="hermes">
  select value2 from parameters2 where parameter='interval' and module = 'dmarc'
  </cfquery>
  
  <cfquery name="get_starttime" datasource="hermes">
  select value2 from parameters2 where parameter='starttime' and module = 'dmarc'
  </cfquery>

<cfquery name="get_smtpd_milters_id" datasource="hermes">
  select id from parameters where parameter='smtpd_milters' and child = '2'
  </cfquery>

<cfquery name="get_non_smtpd_milters_id" datasource="hermes">
  select id from parameters where parameter='non_smtpd_milters' and child = '2'
  </cfquery>
  
  
  <cfquery name="get_dmarc" datasource="hermes">
  select parameter, child, parent, enabled from parameters where parameter='inet:127.0.0.1:54321' and child = '1' and parent='#get_smtpd_milters_id.id#'
  </cfquery>
  
  <cfparam name = "dmarcenabled" default = "#get_dmarc.enabled#"> 
  <cfif IsDefined("form.dmarcenabled") is "True">
  <cfif form.dmarcenabled is not "">
  <cfset dmarcenabled = form.dmarcenabled>
  </cfif></cfif> 
  
  <cfparam name = "failurereports" default = "#get_failurereports.value2#"> 
  <cfif IsDefined("form.failurereports") is "True">
  <cfif form.failurereports is not "">
  <cfset failurereports = form.failurereports>
  </cfif></cfif> 
  
  
  <cfparam name = "rejectfailures" default = "#get_rejectfailures.value2#"> 
  <cfif IsDefined("form.RejectFailures") is "True">
  <cfif form.RejectFailures is not "">
  <cfset RejectFailures = form.RejectFailures>
  </cfif></cfif> 

  <cfparam name = "holdquarantinedmessages" default = "#get_holdquarantinedmessages.value2#"> 
  <cfif IsDefined("form.HoldQuarantinedMessages") is "True">
  <cfif form.HoldQuarantinedMessages is not "">
  <cfset HoldQuarantinedMessages = form.HoldQuarantinedMessages>
  </cfif></cfif> 
  
  <cfparam name = "report_email" default = "#get_report_email.value2#"> 
  <cfif IsDefined("form.report_email") is "True">
  <cfif form.report_email is not "">
  <cfset report_email = form.report_email>
  </cfif></cfif> 
  
  <cfparam name = "report_org" default = "#get_report_org.value2#"> 
  <cfif IsDefined("form.report_org") is "True">
  <cfif form.report_org is not "">
  <cfset report_org = form.report_org>
  </cfif></cfif> 
  
  <cfparam name = "interval" default = "#get_interval.value2#"> 
  <cfif IsDefined("form.interval") is "True">
  <cfif form.interval is not "">
  <cfset interval = form.interval>
  </cfif></cfif> 
  
  <cfparam name = "startdate" default = "1/1/2020"> 
  
  <cfparam name = "starttime" default = "#get_starttime.value2#"> 
  <cfif IsDefined("form.starttime") is "True">
  <cfif form.starttime is not "">
  <cfset starttime = form.starttime>
  </cfif></cfif> 
  