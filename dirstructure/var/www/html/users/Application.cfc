<cfcomponent displayname="HermesSEGUsers" output="false" hint="Handle the applications">

       
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

       //Define POP4 Component
       <cfset This.componentpaths["/pop"]= "/var/www/html/cfc/pop4" />
      
       <cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />
       
       <!--- Set default session.UserLoggedin parameter as false --->
       <cfparam name="session.UserLoggedin" default=false />
              
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />

       <!--- ENABLE BELOW FOR SESSION DEBUG --->
       <!---
       <cfoutput>#session.UserLoggedin#</cfoutput>
       --->
       
      <!--- Authentication Session --->
      <cfif session.UserLoggedin is "false">

       <cfset m="Users: Session Expired">
       <cfinclude template="./2/inc/error.cfm">
       <cfabort>

      <!--- </CFIF session.UserloggedIn --->     
      </cfif>

 
      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

       </cffunction>

</cfcomponent>

