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

<!--- GET / DISK DEVICE --->

<cfexecute name="/opt/hermes/scripts/get_root_disk_device.sh"
variable="rootdevice"
timeout="10" />

<cftry>
       
    <cfexecute name="/opt/hermes/scripts/get_root_disk_device.sh"
    variable="rootdevice"
    timeout="10" />
    
          
          <cfcatch type="any">
    
          <cfset m="/inc/get_system_root_filesystem_usage: There was an error executing /opt/hermes/scripts/get_root_disk_device.sh">
          <cfinclude template="error.cfm">
          <cfabort>   
    
          </cfcatch>
          </cftry>
    

          <cfif #rootdevice# contains 'mapper'>

            <cfset rootdevice = reReplace( rootdevice, "Filesystem", "", "all" )>
            <cfset rootdevice = reReplace( rootdevice, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
            <cfset rootdevice = reReplace( rootdevice, "/dev/mapper/ubuntu--vg-ubuntu--lv", "\/dev\/mapper\/ubuntu--vg-ubuntu--lv", "all" )>
            <cfset rootdevice=#TRIM(rootdevice)#>
            
            <cfelse>
            
            <cfset rootdevice = reReplace( rootdevice, "Filesystem", "", "all" )>
            <cfset rootdevice = reReplace( rootdevice, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
            <cfset rootdevice = reReplace( rootdevice, "/dev/", "\/dev\/", "all" )>
            <cfset rootdevice=#TRIM(rootdevice)#>
            
            <!--- /CFIF #rootdevice# contains 'mapper' --->
            </cfif>
            

  <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>

<!--- GET / FILESYSTEM USAGE --->

  <cffile action="read" file="/opt/hermes/scripts/disk_space_usage_2_0.sh" variable="diskspacefile">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh"
    output = "#REReplace("#diskspacefile#","THE-DEVICE","#rootdevice#","ALL")#">

    <cftry>
       
        <cfexecute name = "/bin/chmod"
        arguments="+x /opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh"
        timeout = "60">
        </cfexecute>
              
              <cfcatch type="any">
        
              <cfset m="/inc/get_system_root_filesystem_usage: There was an error executing /bin/chmod +x /opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh">
              <cfinclude template="error.cfm">
              <cfabort>   
        
              </cfcatch>
              </cftry>

              <cftry>
       
          
                <cfexecute name="/opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh"
                variable="rootusage"
                timeout="10" />
                      
                      <cfcatch type="any">
                
                      <cfset m="/inc/get_system_root_filesystem_usage: There was an error executing /opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh">
                      <cfinclude template="error.cfm">
                      <cfabort>   
                
                      </cfcatch>
                      </cftry>

<cfset rootusage=#TRIM(rootusage)#>

<!--- CHECK FOR EXISTENCE OF /opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh AND DELETE IT --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_disk_space_usage_2_0.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>

<cfif #rootusage# GTE "0" and #rootusage# LTE "59">

    <cfset rootusagecolor = "20c997">
    
    <cfelseif #rootusage# GTE "60" and #rootusage# LTE "79">
    
    <cfset rootusagecolor = "ffc107">
    
    <cfelseif #rootusage# GTE "80" and #rootusage# LTE "89">
    
    <cfset rootusagecolor = "fd7e14">
    
    <cfelseif #rootusage# GTE "90" and #rootusage# LTE "100">
    
    <cfset rootusagecolor = "e74c3c">
    
    <cfelse>
    
    <cfset rootusagecolor = "e74c3c">
    
    <!--- /CFIF #rootusage# is --->
    </cfif>


 