<cfquery name="getjobstatus"  datasource="#datasource#">
select * from archive_jobs where status = 'running'
</cfquery>

<cfif #getjobstatus.recordcount# LT 1>

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

<cfquery name="getjob"  datasource="#datasource#">
select * from archive_jobs limit 1
</cfquery>

<cfquery name="setstatus"  datasource="#datasource#">
update archive_jobs set status = 'running', customtrans = '#customtrans3#' where id = '#getjob.id#'
</cfquery>


<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow=#TimeFormat(Now(),"HH:mm:ss")#>
<cfset datepast=#DateFormat(DateAdd('d', -#getjob.archive_interval#, datenow),'yyyy-mm-dd')#>
<cfoutput>
Date Now: #datenow#<br>
Date Past: #datepast#
</cfoutput>

<cfquery name="setdates"  datasource="#datasource#">
update archive_jobs set jobstartdate = '#datenow# #timenow#', archive_date = '#datepast#' where id = '#getjob.id#'
</cfquery>


<cfquery name="getarchivesmsgs" datasource="#datasource#">
SELECT time_iso, quar_loc, archive FROM msgs where time_iso <= '#datepast#' and archive = 'N' and quar_loc <> ''
</cfquery>


<cfquery name="count"  datasource="#datasource#">
update archive_jobs set initial_count = '#getarchivesmsgs.recordcount#' where id = '#getjob.id#'
</cfquery>


<cfset FileData = "">

<cffile action = "write" file = "/opt/hermes/tmp/#customtrans3#-rsyncfiles" output = "#FileData#" addnewline="no">

<cfloop query="getarchivesmsgs">
<cffile action = "append" file = "/opt/hermes/tmp/#customtrans3#-rsyncfiles" output = "/mnt/data/amavis/#quar_loc##Chr(10)#" addnewline="no">
</cfloop>

<cfset FileData2 = "">

<cffile action = "write" file = "/opt/hermes/tmp/#customtrans3#-rsynccheck" output = "#FileData2#" addnewline="no">


<cfloop query="getarchivesmsgs">
<cffile action = "append" file = "/opt/hermes/tmp/#customtrans3#-rsynccheck" output = "#quar_loc##Chr(10)#" addnewline="no">
</cfloop>

<cfif #getjob.snapshot# is "no">

<cffile action="read" file="/opt/hermes/templates/system_archive.sh" variable="archive">

<cfelseif #getjob.snapshot# is "yes">

<cffile action="read" file="/opt/hermes/templates/system_archive_snapshot.sh" variable="archive">

</cfif>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","CUSTOM-TRANS","#customtrans3#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","SERVER","#getjob.server#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","SHARE","#getjob.share#","ALL")#"> 

<cfif #getjob.directory# is "">
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","DIRECTORY","","ALL")#"> 

<cfelseif #getjob.directory# is not "">
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","DIRECTORY","#getjob.directory#","ALL")#"> 
</cfif>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","SAMBAVER","#getjob.smbversion#","ALL")#"> 


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","USERNAME","#getjob.username#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","DOMAIN","#getjob.domain#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","PASSWORD","#getjob.password#","ALL")#">  


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","MYSQL-USER","#getjob.mysqlusername#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","MYSQL-PASS","#getjob.mysqlpassword#","ALL")#">


<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","THE-SENDER","#getpostmaster.value#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","THE-RECIPIENT","#getjob.notification#","ALL")#">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_system_archive.sh" variable="archive">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
    output = "#REReplace("#archive#","THE-RETENTION","#getjob.retention#","ALL")#">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_system_archive.sh"
timeout = "0">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_system_archive.sh"
outputfile ="/dev/null"
arguments="-inputformat none"
timeout = "120">
</cfexecute>

<cfelseif #getjobstatus.recordcount# GTE 1>

<cfquery name="getpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfquery name="getnotification"  datasource="#datasource#">
select notification from archive_jobs limit 1
</cfquery>

<cfmail from="#getpostmaster.value#" subject="Warning Email Archive Job" to="#getnotification.notification#" server="localhost">

This message is to inform you that the scheduled instance of Email Archive Job was not able to start due to the fact that an Email Archive Job was already running. This may be normal if the system is performing the initial Email Archive. This may also indicate a problem. If you continue to get this message please contact support.

</cfmail>

</cfif>

