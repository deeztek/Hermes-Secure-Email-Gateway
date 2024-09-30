
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

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">


<!--- GET ANTIVIRUS SETTINGS  --->
<cfinclude template="get_antivirus_settings.cfm">



<!--- GENERATE CLAMD.CONF STARTS HERE --->

<cfquery name="getAvSettings" datasource="hermes">
select parameter, value2 from parameters2 where active = '1' and module='clamav'
</cfquery>

<!--- CREATE TEMP AVSETTINGS FILE --->
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_avsettings"
    output = ""
    addNewLine = "no">
    
<cfoutput query="getAvSettings">

<cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_avsettings"
    output = "#parameter# #value2##chr(10)#"
    addNewLine = "no">
</cfoutput>    

<!--- Run Dos2Unix on /opt/hermes/tmp/#customtrans3#_avsettings --->
<cftry>

    <cfexecute name = "/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_avsettings"
    timeout = "60">
    </cfexecute>
  
  <cfcatch type="any">
  
      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->
  
      <cfset m="/inc/generate_antivirus_configuration.cfm: Error running /usr/bin/dos2unix on /opt/hermes/tmp/#customtrans3#_avsettings">
      <cfinclude template="error.cfm">
      <cfabort>
  
    </cfcatch>
  
  </cftry>
  
<!--- GENERATE CLAMD.CONF STARTS HERE --->
<!--- READ /opt/hermes/tmp/#customtrans3#_avsettings FILE --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_avsettings" variable="avsettings">

<!--- READ /opt/hermes/conf_files/clamd.conf.HERMES FILE --->
<cffile action="read" file="/opt/hermes/conf_files/clamd.conf.HERMES" variable="clamav">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_clamd.conf"
    output = "#REReplace("#clamav#","HERMES_ANTIVIRUS_SETTINGS_GO_HERE","#avsettings#","ALL")#" addnewline="no">

<!--- BACKUP /etc/clamav/clamd.conf --->
<cftry>
       
    <cfexecute name = "/bin/cp"
    arguments="/etc/clamav/clamd.conf /etc/clamav/clamd.conf.HERMES"
    timeout = "60">
    </cfexecute>
      
      <cfcatch type="any">

      <cfset m="Generate Antivirus Configuration: There was an error copying /etc/clamav/clamd.conf to /etc/clamav/clamd.conf.HERMES">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>

<!--- MOVE /opt/hermes/tmp/#customtrans3#_clamd.conf TO /etc/clamav/clamd.conf --->

<cftry>
       
    <cfexecute name = "/bin/mv"
    arguments="/opt/hermes/tmp/#customtrans3#_clamd.conf /etc/clamav/clamd.conf"
    timeout = "60">
    </cfexecute>
      
      <cfcatch type="any">

      <cfset m="Generate Antivirus Configuration: There was an error copying /opt/hermes/tmp/#customtrans3#_clamd.conf to /etc/clamav/clamd.conf">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>
    

<!--- GENERATE CLAMD.CONF ENDS HERE --->

<!--- GENERATE LOCAL.IGN2 STARTS HERE --->
<cfquery name = "getbypass" datasource="#datasource#">
    select parameter, module from parameters2 where module = 'clamav-bypass'
    </cfquery>
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
        output = ""
        addNewLine = "no">

<cfif #getbypass.recordcount# GTE 1>
        
    <cfoutput query="getbypass">
    
    <cffile action = "append"
        file = "/opt/hermes/tmp/#customtrans3#_local.ign2"
        output = "#parameter##chr(10)#"
        addNewLine = "no">
    </cfoutput>  

<!--- /CFIF #getbypass.recordcount# GTE 1 --->
</cfif>

<!--- Run Dos2Unix on /opt/hermes/tmp/#customtrans3#_local.ign2 --->
<cftry>

    <cfexecute name = "/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_local.ign2"
    timeout = "60">
    </cfexecute>
  
  <cfcatch type="any">
  
      <!--- DEBUG --->
    <!---
    <cfdump var="#cfcatch#">
      --->
  
      <cfset m="/inc/generate_antivirus_configuration.cfm: Error running /usr/bin/dos2unix on /opt/hermes/tmp/#customtrans3#_local.ign2">
      <cfinclude template="error.cfm">
      <cfabort>
  
    </cfcatch>
  
  </cftry>

<!--- BACKUP /var/lib/clamav/local.ign2 --->
<cftry>
       
    <cfexecute name = "/bin/cp"
    arguments="/var/lib/clamav/local.ign2 /var/lib/clamav/local.ign2.HERMES"
    timeout = "60">
    </cfexecute>
      
      <cfcatch type="any">

      <cfset m="Generate Antivirus Configuration: There was an error copying /var/lib/clamav/local.ign2 to /var/lib/clamav/local.ign2.HERMES">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>

<!--- MOVE /opt/hermes/tmp/#customtrans3#_local.ign2 TO /var/lib/clamav/local.ign2 --->

<cftry>
       
    <cfexecute name = "/bin/mv"
    arguments="/opt/hermes/tmp/#customtrans3#_local.ign2 /var/lib/clamav/local.ign2"
    timeout = "60">
    </cfexecute>
      
      <cfcatch type="any">

      <cfset m="Generate Antivirus Configuration: There was an error copying /opt/hermes/tmp/#customtrans3#_local.ign2 to /var/lib/clamav/local.ign2">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>
    
 <!--- GENERATE LOCAL.IGN2 ENDS HERE --->


<!--- Restart ClamAV --->   
<cfinclude template="restart_clamav.cfm">




