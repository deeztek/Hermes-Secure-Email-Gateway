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
    
    <cfquery name="dmarcstarttime" datasource="hermes">
    select value2 from parameters2 where parameter='starttime' and module = 'dmarc'
    </cfquery>
    
    <cfset timeHour="#timeformat(dmarcstarttime.value2, "H")#">
    <cfset timeMinute="#timeformat(dmarcstarttime.value2, "m")#">
    
    <cffile action = "write"
        file = "/etc/cron.d/hermes_dmarcjob"
        output = "#timeMinute# #timeHour# * * * root /usr/bin/curl --silent http://localhost:8888/schedule/dmarc_report.cfm &>/dev/null#chr(10)#"
        addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cfexecute name = "/usr/bin/dos2unix"
    timeout = "240"
    arguments="/etc/cron.d/hermes_dmarcjob">
    </cfexecute>
    
    
    <!--- /CFIF #get_FailureReports.value2# is "true" --->    
    </cfif>   
    
    
    <!--- GET ALL BACKUP JOBS --->
    <cfquery name="getbackupjobs" datasource="hermes">
    select entry_name, scheduled, startdate, scheduled_interval from backup_jobs 
    </cfquery>
    
    <!--- DELETE EXISTING /ETC/CRON.D/ BACKUP JOBS --->
    <cfloop query="getbackupjobs">
    <cfset FiletoDelete="/etc/cron.d/hermes_backupjob_#entry_name#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    </cfif>
    </cfloop>
        
    <!--- CREATE /ETC/CRON.D/ BACKUP JOBS --->
    <cfloop query="getbackupjobs">
    <cfset timeHour="#timeformat(startdate, "H")#">
    <cfset timeMinute="#timeformat(startdate, "m")#">
    <cffile action = "write"
        file = "/etc/cron.d/hermes_backupjob_#entry_name#"
        output = "#timeMinute# #timeHour# * * * root /usr/bin/curl --silent http://localhost:8888/schedule/#entry_name#_backup_task.cfm &>/dev/null#chr(10)#"
        addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cfexecute name = "/usr/bin/dos2unix"
    timeout = "240"
    arguments="/etc/cron.d/hermes_backupjob_#entry_name#">
    </cfexecute>
    
    </cfloop>
    
    
    <!--- GET ALL ARCHIVE JOBS --->
    <cfquery name="getarchivejobs" datasource="hermes">
    select entry_name, startdate, scheduled_interval from archive_jobs
    </cfquery>
    
    <!--- DELETE EXISTING /ETC/CRON.D/ ARCHIVE JOBS --->
    <cfloop query="getarchivejobs">
    <cfset FiletoDelete="/etc/cron.d/hermes_archivejob_#entry_name#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    </cfif>
    </cfloop>
        
    <!--- CREATE /ETC/CRON.D/ ARCHIVE JOBS --->
    <cfloop query="getarchivejobs">
    <cfset timeHour="#timeformat(startdate, "H")#">
    <cfset timeMinute="#timeformat(startdate, "m")#">
    <cffile action = "write"
        file = "/etc/cron.d/hermes_archivejob_#entry_name#"
        output = "#timeMinute# #timeHour# * * * root /usr/bin/curl --silent http://localhost:8888/schedule/#entry_name#_archive_task.cfm &>/dev/null#chr(10)#"
        addNewLine = "yes">
    
    <!--- CONVERT TO UNIX --->
    <cfexecute name = "/usr/bin/dos2unix"
    timeout = "240"
    arguments="/etc/cron.d/hermes_archivejob_#entry_name#">
    </cfexecute>
    
    </cfloop>
    