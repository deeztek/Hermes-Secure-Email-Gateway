
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

<cfinclude template="get_dmarc_mysql_creds.cfm" />


<cfinclude template="generate_customtrans.cfm">
  
  <!--- GET REPORTING EMAIL, REPORTING ORGANIZATION AND POSTMASTER ADDRESS BELOW  --->
  
  <cfquery name="get_report_email" datasource="hermes">
  select value2 from parameters2 where parameter='report_email' and module = 'dmarc'
  </cfquery>
  
  <cfquery name="get_report_org" datasource="hermes">
  select value2 from parameters2 where parameter='report_org' and module = 'dmarc'
  </cfquery>

<cfquery name="getpostmaster" datasource="hermes">
  select parameter, value from system_settings where parameter='postmaster'
  </cfquery>
  
  <!--- GET REPORTING EMAIL, REPORTING ORGANIZATION AND POSTMASTER ADDRESS ABOVE --->
  
<!--- CHECK FOR EXISTENCE OF /OPT/HERMES/SCHEDULE/DMARC_REPORT_SCRIPT.SH AND DELETE IT --->
<cfset FiletoDelete="/opt/hermes/schedule/dmarc_report_script.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>
  
  
  <!--- CREATE DMARC_REPORT_SCRIPT.SH FILE BELOW --->
  
  
  <cffile action="read" file="/opt/hermes/scripts/dmarc_report_script.sh" variable="dmarcfile">

  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
      output = "#REReplace("#dmarcfile#","DATABASE-SERVER","hermes_db_server","ALL")#">

  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">

  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
      output = "#REReplace("#dmarcfile#","DATABASE-USER","#mysqlusernameopendmarc#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
      output = "#REReplace("#dmarcfile#","DATABASE-PASSWORD","#mysqlpasswordopendmarc#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
      output = "#REReplace("#dmarcfile#","REPORTING-EMAIL","#get_report_email.value2#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
      output = "#REReplace("#dmarcfile#","REPORTING-ORGANIZATION","#get_report_org.value2#","ALL")#">

      <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" variable="dmarcfile">
  
      <cffile action = "write"
          file = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh"
          output = "#REReplace("#dmarcfile#","POSTMASTER-EMAIL","#getpostmaster.value#","ALL")#">
    

  <cffile action="move" source = "/opt/hermes/tmp/#customtrans3#_dmarc_report_script.sh" destination = "/opt/hermes/schedule/dmarc_report_script.sh">

<!--- MAKE /OPT/HERMES/SCHEDULED_TASKS/DMARC_REPORT_SCRIPT.SH EXECUTABLE --->
<cftry>

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/schedule/dmarc_report_script.sh"
timeout = "60">
</cfexecute>
      
                          
<cfcatch type="any">
                      
  <cfset m="/inc/dmarc_generate_reports_script: There was an error running chmod +x /opt/hermes/schedule/dmarc_report_script.sh ">
  <cfinclude template="error.cfm">
  <cfabort>  
                      
  </cfcatch>
  </cftry>
  
  <!--- CREATE DMARC_REPORT_SCRIPT.SH FILE ABOVE --->
  

  <!--- Enable DMARC report job in Ofelia --->
  <cfquery datasource="hermes">
    UPDATE ofelia_jobs SET active = '1' WHERE job_name = '[job-exec "hermes-dmarc-report"]'
  </cfquery>
  <cfinclude template="ofelia_generate_config.cfm">
  
