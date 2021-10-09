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
    
    <cffile action="read" file="/opt/hermes/scripts/validate_mysql.sh" variable="validatemysql">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
        output = "#REReplace("#validatemysql#","MYSQLUSER","#show_mysql_username_opendmarc#","ALL")#"> 
        
    <cffile action="read" file="/opt/hermes/tmp/validate_mysql_#customtrans3#" variable="validatemysql">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
        output = "#REReplace("#validatemysql#","MYSQLPASS","#show_mysql_password_opendmarc#","ALL")#"> 
    
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/validate_mysql_#customtrans3#"
    timeout = "60">
    </cfexecute>
    
    <cftry>
    
    <cfexecute name = "/opt/hermes/tmp/validate_mysql_#customtrans3#"
    timeout = "240"
    variable ="mysqlvalidate"
    arguments="">
    </cfexecute>
    
    
    <cfcatch type="any">
    
    <cfif #cfcatch.detail# contains "ERROR 1045 (28000): Access denied">
    <cfset errormessage=25>
    <cfset step=0>
    <!-- /CFIF cfcatch.detail -->
    </cfif>
    </cfcatch>
    <cfset step=14>
    </cftry>
    
<!--- DELETE /opt/hermes/tmp/validate_mysql_#customtrans3# --->
  <cfset Deletefile="/opt/hermes/tmp/validate_mysql_#customtrans3#">
  <cfif fileExists(Deletefile)>
  <cffile 
  action = "delete"
  file = "#Deletefile#">
  </cfif>
    
