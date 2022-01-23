<cfsetting enablecfoutputonly="yes">

<cfcomponent displayname="HermesSEGUserAuth" output="false" hint="Handle the applications">

      <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="HERMES_DATASOURCE_USERNAME">
	<cffile action="read" file="/opt/hermes/creds/hermes_password" variable="HERMES_DATASOURCE_PASSWORD">
	<cffile action="read" file="/opt/hermes/creds/syslog_username" variable="SYSLOG_DATASOURCE_USERNAME">
	<cffile action="read" file="/opt/hermes/creds/syslog_password" variable="SYSLOG_DATASOURCE_PASSWORD">
	<cffile action="read" file="/opt/hermes/creds/ciphermail_username" variable="CIPHERMAIL_DATASOURCE_USERNAME">
	<cffile action="read" file="/opt/hermes/creds/ciphermail_password" variable="CIPHERMAIL_DATASOURCE_PASSWORD">

      //Define hermes Datasource
      <cfscript>
		this.datasources["hermes"] = {
		class: 'com.mysql.jdbc.Driver'
		, bundleName: 'com.mysql.jdbc'
		, bundleVersion: '5.1.40'
		, connectionString: 'jdbc:mysql://localhost:3306/hermes?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
		, username: '#HERMES_DATASOURCE_USERNAME#'
		, password: "#HERMES_DATASOURCE_PASSWORD#"
		// optional settings
		, blob:true // default: false
		, clob:true // default: false
		, connectionLimit:100 // default:-1
		};
	</cfscript>

       
	<cfset This.name="User-Auth" />
	<cfset This.Sessionmanagement="True" />
       <cfset This.loginstorage="session" />
       <cfset This.requestTimeout=createTimeSpan(0,1,0,0) />

      
	<cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />

       <!--- Set default session.UserLoggedin parameter as false --->
       <cfparam name="session.UserLoggedin" default=false />
	
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />
       
  
       <!--- URL Variable Checks Starts Here --->
       
       
             <cfif structKeyExists(url, 'uid')>
       
             <cfif #url.uid# is not "">
       
             <cfif REFind("[^_a-zA-Z0-9]",url.uid) gt 0>
       
              <cfset m="user-auth Application.cfc: url.uid Invalid Characters">
              <cfinclude template="error.cfm">
              <cfabort>
       
       
             <cfelse>
       
              <cfquery name="checkuid" datasource="hermes">
              select id from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
              </cfquery>
       
              <cfif #checkuid.recordcount# LT 1>
       
       
              <cfset m="user-auth Application.cfc: checkuid.recordcount LT 1">
              <cfinclude template="error.cfm">
              <cfabort>
       
              <!--- /CFIF #checkuid.recordcount# LT 1 --->
              </cfif>
              
              <!--- /CFIF REFind("[^_a-zA-Z0-9]",url.uid) gt 0 --->
             </cfif>
       
             <cfelseif #url.uid# is "">
       
              <cfset m="user-auth Application.cfc: url.uid blank">
              <cfinclude template="error.cfm">
              <cfabort>
       
             <!--- /CFIF #url.uid# is/is not "" --->
             </cfif>
       
             <cfelseif NOT structKeyExists(url, 'uid')>
       
              <cfset m="user-auth Application.cfc: url.uid does not exist">
              <cfinclude template="error.cfm">
              <cfabort>
       
              <!--- /CFIF structKeyExists(url, 'uid') --->
              </cfif>
           
       
              <cfif structKeyExists(url, 'dest')>
       
                     <cfif #url.dest# is not "">
               
                     <cfif IsValid("integer", #url.dest#)>
               
               
                      <cfquery name="checkdest" datasource="hermes">
                      select id from user_destinations where id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.dest#">
                      </cfquery>
               
               <cfif #checkdest.recordcount# LT 1>
       
                     <cfset m="user-auth Application.cfc: checkdest.recordcount LT 1">
                     <cfinclude template="error.cfm">
                     <cfabort>
               
                      
                      <!--- /CFIF #checkdest.recordcount# LT 1 --->
                      </cfif>
                      
               
                     <cfelse>
       
                     <cfset m="user-auth Application.cfc: url.dest not integer">
                    <cfinclude template="error.cfm">
                     <cfabort>        
                      
                      <!--- /CFIF IsValid("integer", #url.dest#) --->
                     </cfif>
               
                     <cfelseif #url.dest# is "">
       
                     <cfset m="user-auth Application.cfc: url.dest is blank">
                     <cfinclude template="error.cfm">
                     <cfabort>
              
                     <!--- /CFIF #url.dest# is/is not "" --->
                     </cfif>
               
                     <cfelseif NOT structKeyExists(url, 'dest')>
               
                      <cfset m="user-auth Application.cfc: url.dest does not exist">
                      <cfinclude template="error.cfm">
                      <cfabort>
               
                      <!--- /CFIF structKeyExists(url, 'dest') --->
                      </cfif>
       
       
            <cfif structKeyExists(url, 'mid')>
            
            <cfif #url.mid# is not "">
       
            <cfif REFind("[^_a-zA-Z0-9\-\_\+]",url.mid) gt 0>
       
       <cfset m="user-auth Application.cfc: url.mid Invalid Characters">
       <cfinclude template="error.cfm">
       <cfabort>
       
       
            <!--- REFind("[^_a-zA-Z0-9\-\_\+]",url.mid) gt 0 --->
            </cfif>
       
            <!--- /CFIF #url.mid# is not "" --->
           </cfif>
       
            <cfelseif NOT structKeyExists(url, 'mid')>
       
            <cfset mid=666>
       
            <!--- /CFIF structKeyExists(url, 'mid') --->
            </cfif>
       
          
            <cfif structKeyExists(url, 'sid')>
            
              <cfif #url.sid# is not "">
         
              <cfif REFind("[^_a-zA-Z0-9\-\_\+]",url.sid) gt 0>
         
              <cfset m="user-auth Application.cfc: url.sid Invalid Characters">
              <cfinclude template="error.cfm">
              <cfabort>
         
              <!--- REFind("[^_a-zA-Z0-9\-\_\+]",url.sid) gt 0 --->
              </cfif>
       
            <!--- /CFIF #url.mid# is not "" --->
            </cfif>
         
              <cfelseif NOT structKeyExists(url, 'sid')>
       
              <cfset sid=666>
         
              <!--- /CFIF structKeyExists(url, 'sid') --->
              </cfif>

              <cfif structKeyExists(url, 'token')>
            
                  <cfif #url.token# is not "">
             
                  <cfif REFind("[^a-zA-Z0-9]",url.token) gt 0>
             
                  <cfset m="user-auth Application.cfc: url.token Invalid Characters">
                  <cfinclude template="error.cfm">
                  <cfabort>
             
                  <!--- REFind("[^a-zA-Z0-9]",url.token) gt 0 --->
                  </cfif>

            <cfelse>

                  <cfset m="user-auth Application.cfc: url.token is empty">
                  <cfinclude template="error.cfm">
                  <cfabort>
           
                <!--- /CFIF #url.token# is not "" --->
                </cfif>
             
               
                  <!--- /CFIF structKeyExists(url, 'token') --->
                  </cfif>
       
       
           <cfquery name="getemail" datasource="hermes">
           select email, password_set, train_bayes, download_msg from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
           </cfquery>
       
           <cfif #getemail.recordcount# GTE 1>
       
           <cfif #getemail.password_set# is "0">
       
           <cfset session.UserPassword = 0>
          
           <cfelseif #getemail.password_set# is "1">
       
           <cfset session.UserPassword = 1>
           
           <cfelse>

            <cfset m="user-auth Application.cfc: getemail.password_set is not 0 or 1">
            <cfinclude template="error.cfm">
            <cfabort>

           <!-- /CFIF FOR getemail.password_set -->
           </cfif>
       
           <cfelseif #getemail.recordcount# LT 1>
       
       <cfset m="user-auth Application.cfc: getemail.recordcount LT 1">
       <cfinclude template="error.cfm">
       <cfabort>
       
           <!-- /CFIF FOR getemail.recordcount -->
           </cfif>
       
         
             <!--- URL Variable Checks Ends Here --->
             
<!---
      
      <!--- Authentication Session --->
      <cfif #session.UserLoggedin# is "false">

      <cfinclude template="index.cfm" />
      <cfabort />
 

      <!--- </CFIF #session.UserLoggedin# is  --->     
      </cfif>

--->     
       
      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

      

       </cffunction>

</cfcomponent>
