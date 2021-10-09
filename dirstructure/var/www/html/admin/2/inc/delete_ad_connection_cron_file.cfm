<cfquery name="getversion" datasource="hermes">
    select parameter, value from system_settings where parameter = 'version_no'
    </cfquery>
    
    <cfif #getversion.value# is "20.04">
    
     <!--- DELETE /VAR/WWW/HTML/SCHEDULE AD_TASKS.CFM --->
  <cfset testfile="/var/www/html/schedule/#getconnection.entry_name#_ad_tasks.cfm">
  <cfif fileExists(testfile)>
  <cffile 
  action = "delete"
  file = "#testfile#">
  </cfif>
    
  <cfelse>
  <!--- DELETE /OPT/HERMES/WEBAPPS/SCHEDULE AD_TASKS.CFM --->
  <cfset testfile="/opt/hermes/webapps/schedule/#getconnection.entry_name#_ad_tasks.cfm">
  <cfif fileExists(testfile)>
  <cffile 
  action = "delete"
  file = "#testfile#">
  </cfif>
    <!--- /CFIF #getversion.value# is --->
    </cfif>