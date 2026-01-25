

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


<cfquery name="getofeliajobs" datasource="hermes">
 select job_name, schedule, command, container, active from ofelia_jobs where active = '1'
  </cfquery>

<cfif #getofeliajobs.recordcount# GTE 1>

     <!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- Generate ofelia_jobs temp file --->

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_ofelia_jobs"
    output = ""
    addNewLine = "no">

<cfoutput query="getofeliajobs">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_ofelia_jobs"
    output = "#job_name##chr(10)#schedule = #schedule##chr(10)#container = #container##chr(10)#command = #command##chr(10)##chr(10)#"
    addNewLine = "no">

</cfoutput>

<!--- Run Dos2Unix on /opt/hermes/tmp/#customtrans3#_ofelia_jobs --->
<cftry>

    <cfexecute name = "/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_ofelia_jobs"
    timeout = "60">
    </cfexecute>

  <cfcatch type="any">

      <cfset m="ofelia_generate_config.cfm: #cfcatch.detail#">
  <cfinclude template="error.cfm">
  <cfabort>


      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->


    </cfcatch>

  </cftry>


  <!--- READ /opt/hermes/tmp/#customtrans3#_ofelia_jobs FILE --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_ofelia_jobs" variable="ofeliajobs">

<!--- Get postmaster and admin email addresses --->

<cfquery name="getpostmaster" datasource="hermes">
 select parameter, value from system_settings where parameter = 'postmaster'
  </cfquery>

  <cfquery name="getadmin" datasource="hermes">
 select parameter, value from system_settings where parameter = 'admin_email'
  </cfquery>

<!--- add postmaster and admin e-mail --->

<cffile action="read" file="/opt/hermes/conf_files/ofelia_config.ini" variable="ofeliaconfig">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_config.ini"
    output = "#REReplace("#ofeliaconfig#","POSTMASTER_EMAIL","#getpostmaster.value#","ALL")#" addnewline="no">

    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_config.ini" variable="ofeliaconfig">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_config.ini"
    output = "#REReplace("#ofeliaconfig#","ADMIN_EMAIL","#getadmin.value#","ALL")#" addnewline="no">

<!--- append ofelia jobs --->

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_config.ini" variable="ofeliaconfig">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_config.ini"
    output = "#REReplace("#ofeliaconfig#","OFELIA_JOBS_GO_HERE","#ofeliajobs#","ALL")#" addnewline="no">

<!--- Move to /opt/hermes/tmp/#customtrans3#_config.ini to  --->

<cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_config.ini" destination = "/etc/ofelia/config.ini">

    <!--- Delete Temp Files --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_ofelia_jobs">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF FiletoDelete --->
    </cfif>

<!--- Restart Ofelia --->
  <cfinclude template="restart_ofelia.cfm">

  <!--- /CFIF getofeliajobs.recordcount GTE 1 --->
</cfif>

<!--- enable for debug 
<cfoutput>Active</cfoutput>
--->



