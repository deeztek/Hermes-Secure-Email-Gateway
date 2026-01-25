<!--- generate_container_ips.cfm --->
<!--- Generates container IPs file for fail2ban API notify script --->
<!--- fail2ban uses network_mode: host and can't use Docker DNS names --->
<!--- File is overwritten each time the page loads --->

<cfset containerIPsFile = "/opt/hermes/tmp/container_ips.env">
<cfset generateSuccess = false>
<cfset generateError = "">

<cftry>
    <!--- Get database container IP --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hermes_db_server"
        variable="dbIP"
        errorVariable="dbError"
        timeout="10">
    </cfexecute>
    <cfset dbIP = trim(dbIP)>

    <!--- Get commandbox container IP --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hermes_commandbox"
        variable="commandboxIP"
        errorVariable="cbError"
        timeout="10">
    </cfexecute>
    <cfset commandboxIP = trim(commandboxIP)>

    <!--- Generate the env file content --->
    <cfset fileContent = "## Auto-generated container IPs for fail2ban API notify script#chr(10)#">
    <cfset fileContent = fileContent & "## Generated at: #DateFormat(Now(), 'yyyy-mm-dd')# #TimeFormat(Now(), 'HH:mm:ss')##chr(10)#">
    <cfset fileContent = fileContent & "HERMES_DB_IP=#dbIP##chr(10)#">
    <cfset fileContent = fileContent & "HERMES_COMMANDBOX_IP=#commandboxIP##chr(10)#">

    <!--- Write to file (overwrites existing) --->
    <cffile action="write" file="#containerIPsFile#" output="#fileContent#">

    <cfset generateSuccess = true>

<cfcatch type="any">
    <cfset generateError = cfcatch.message>
</cfcatch>
</cftry>
