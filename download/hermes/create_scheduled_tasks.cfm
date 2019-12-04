<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cfset theStamp="#datenow# #timenow#">
<cfset past=#DateAdd("d", -1, theStamp)#> 
<cfset date1="#dateformat(past, "mm/dd/yyyy")#">


<cfschedule action="update"
task="message_cleanup"
operation="HTTPRequest"
startdate="#date1#"
starttime="01:00"
requesttimeout="10800"
url="http://localhost:8888/schedule/message_cleanup.cfm"
interval="daily">

<cfschedule action="update"
task="daily_quarantine_report"
operation="HTTPRequest"
startdate="#date1#"
starttime="00:30"
requesttimeout="3600"
url="http://localhost:8888/schedule/quarantine_report_daily.cfm"
interval="daily">

<cfschedule action="update"
task="daily_quarantine_report"
operation="HTTPRequest"
startdate="#date1#"
starttime="00:30"
requesttimeout="3600"
url="http://localhost:8888/schedule/quarantine_report_daily.cfm"
interval="daily">

<cfschedule action="update"
task="quarantine_report_4_hours"
operation="HTTPRequest"
startdate="#date1#"
starttime="04:05"
requesttimeout="3600"
url="http://localhost:8888/schedule/quarantine_report.cfm?frequency=4"
interval="240">

<cfschedule action="update"
task="quarantine_report_8_hours"
operation="HTTPRequest"
startdate="#date1#"
starttime="08:10"
requesttimeout="3600"
url="http://localhost:8888/schedule/quarantine_report.cfm?frequency=8"
interval="480">

<cfschedule action="update"
task="quarantine_report_2_hours"
operation="HTTPRequest"
startdate="#date1#"
starttime="02:00"
requesttimeout="3600"
url="http://localhost:8888/schedule/quarantine_report.cfm?frequency=2"
interval="120">

<cfschedule action="update"
task="dmarc_report"
operation="HTTPRequest"
startdate="#date1#"
starttime="0:45"
requesttimeout="7200"
url="http://localhost:8888/schedule/dmarc_report.cfm"
interval="daily">