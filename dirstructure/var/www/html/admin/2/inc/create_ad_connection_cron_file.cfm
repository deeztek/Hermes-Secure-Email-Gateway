<cfquery name="getversion" datasource="hermes">
    select parameter, value from system_settings where parameter = 'version_no'
    </cfquery>
    
    <cfif #getversion.value# is "20.04">
    
    <cffile action = "write"
        file = "/opt/hermes/webapps/schedule/#show_entry_name#_ad_tasks.cfm"
        output = "#REReplace("#adtask#","PASS_WORD","#show_password#","ALL")#"> 
    
    <cfelse>
      <cffile action = "write"
      file = "/var/www/html/schedule/#show_entry_name#_ad_tasks.cfm"
      output = "#REReplace("#adtask#","PASS_WORD","#show_password#","ALL")#"> 
    
    <!--- /CFIF #getversion.value# is --->
    </cfif>