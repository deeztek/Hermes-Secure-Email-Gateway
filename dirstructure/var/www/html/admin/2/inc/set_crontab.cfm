
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

<!--- GET SCHEDULED AD --->
<cfquery name="get_ScheduledAd" datasource="hermes">
    select entry_name, scheduled, scheduled_interval from ad_integration where scheduled='1'
    </cfquery>
    
    
    
    <!--- DELETE EXISTING /ETC/CRON.D/ AD JOBS --->
    <cfloop query="get_ScheduledAd">
    <cfset FiletoDelete="/etc/cron.d/hermes_adjob_#entry_name#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    </cfif>
    </cfloop>
        
    <!--- CREATE /ETC/CRON.D/ AD JOBS --->
    <cfloop query="get_ScheduledAd">
    <cffile action = "write"
        file = "/etc/cron.d/hermes_adjob_#entry_name#"
        output = "#scheduled_interval# root /usr/bin/curl --silent http://localhost:8888/schedule/#entry_name#_ad_tasks.cfm &>/dev/null#chr(10)#"
        addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cfexecute name = "/usr/bin/dos2unix"
    timeout = "240"
    arguments="/etc/cron.d/hermes_adjob_#entry_name#">
    </cfexecute>
    
    </cfloop>
    
    
    <!--- GET DMARC --->
    <cfquery name="get_FailureReports" datasource="hermes">
    select value2 from parameters2 where parameter='FailureReports' and module = 'dmarc'
    </cfquery>
    
    <!--- DELETE EXISTING /ETC/CRON.D/ DMARC JOB --->
    <cfset FiletoDelete="/etc/cron.d/hermes_dmarcjob">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    </cfif>
    
    
    <!--- IF DMARC IS ENABLED CREATE DMARC JOB FILE--->
    <cfif #get_FailureReports.value2# is "true">
    
    
    <cffile action = "write"
        file = "/etc/cron.d/hermes_dmarcjob"
        output = "30 2 * * * root /opt/hermes/schedule/dmarc_report_script.sh &>/dev/null#chr(10)#"
        addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cfexecute name = "/usr/bin/dos2unix"
    timeout = "240"
    arguments="/etc/cron.d/hermes_dmarcjob">
    </cfexecute>

<!--- IF DMARC IS DISABLED DELETE DMARC JOB FILE--->
<cfelseif #get_FailureReports.value2# is "false">

        <!--- DELETE EXISTING /ETC/CRON.D/ DMARC JOB --->
        <cfset FiletoDelete="/etc/cron.d/hermes_dmarcjob">
        <cfif fileExists(FiletoDelete)> 
        <cffile action="delete" 
        file = "#FiletoDelete#">
        </cfif>
    
    <!--- /CFIF #get_FailureReports.value2# is "true" --->    
    </cfif>   
    
      
    <!--- GET DAILY UPDATE CHECK --->
    <cfquery name="get_update_check" datasource="hermes">
        select value from system_settings where parameter='daily_update_check'
        </cfquery>
        
        <!--- DELETE EXISTING /ETC/CRON.D/HERMES_DAILY_UPDATE_JOB --->
        <cfset FiletoDelete="/etc/cron.d/hermes_update_check_job">
        <cfif fileExists(FiletoDelete)> 
        <cffile action="delete" 
        file = "#FiletoDelete#">
        </cfif>
    
     <!--- IF DAILY UPDATE CHECK IS ENABLED --->
        <cfif #get_update_check.value# is "1">
        
        
        <cffile action = "write"
            file = "/etc/cron.d/hermes_update_check_job"
            output = "30 4 * * * root /opt/hermes/schedule/update_check.sh &>/dev/null#chr(10)#"
            addNewLine = "yes">
        
        <!--- CONVERT TO UNIX --->
        <cfexecute name = "/usr/bin/dos2unix"
        timeout = "240"
        arguments="/etc/cron.d/hermes_update_check_job">
        </cfexecute>
    
    <!--- IF DAILY UPDATE CHECK IS DELETE JOB FILE--->
    <cfelseif #get_update_check.value# is "2">
    
        <!--- DELETE EXISTING /ETC/CRON.D/HERMES_DAILY_UPDATE_JOB --->
        <cfset FiletoDelete="/etc/cron.d/hermes_update_check_job">
        <cfif fileExists(FiletoDelete)> 
        <cffile action="delete" 
        file = "#FiletoDelete#">
        </cfif>
        
        <!--- /CFIF #get_update_check.value# is --->    
        </cfif>   
    