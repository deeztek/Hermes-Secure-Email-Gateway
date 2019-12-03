<cfquery name="getscheduled" datasource="hermes">
select * from archive_jobs
</cfquery>

<cfquery name="getversion" datasource="hermes">
select value from system_settings where parameter = 'version_no'
</cfquery>

<cfif #getscheduled.recordcount# GTE 1>

<cfloop query="getscheduled">
<cfoutput>

<cfschedule  
action = "delete"  
task = "archivejob_#entry_name#"> 


<cfif #getversion.value# contains '16.04'>

<cfset testfile="/var/www/html/schedule/#entry_name#_archive_task.cfm">

<cfelseif #getversion.value# contains '14.04'>

<cfset testfile="/var/www/schedule/#entry_name#_archive_task.cfm">

<cfelseif #getversion.value# contains '12.04'>

<cfset testfile="/var/www/schedule/#entry_name#_archive_task.cfm">

</cfif>

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>


<cfquery name="delete" datasource="hermes">
delete from archive_jobs where id='#id#'
</cfquery>

</cfoutput>
</cfloop>
   


</cfif>
    

