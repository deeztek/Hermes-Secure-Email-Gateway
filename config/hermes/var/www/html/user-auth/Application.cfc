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
		, connectionString: 'jdbc:mysql://hermes_db_server:3306/hermes?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&autoReconnect=true&useSSL=false&verifyServerCertificate=false&enabledTLSProtocols=TLSv1.2&requireSSL=false'
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

       <!--- Password reset logic lives outside the web root, in
            /opt/hermes/cfml/AuthService.cfc. An Application.cfc mapping is
            never reachable by URL: Lucee resolves the requested file before
            it reads this file. --->
       <cfset This.mappings["/hermesauth"] = "/opt/hermes/cfml" />

      
	<cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />

       <!--- Set default session.UserLoggedin parameter as false --->
       <cfparam name="session.UserLoggedin" default=false />
	
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />
       
  
       <!--- URL Variable Checks Commented Out - Not necessary for password reset flow --->
       <!---

       ... URL validation code removed for brevity ...

       --->

      <!--- SECURITY (GHSA-wwxm-p5f2-q6xm, GHSA-rgx7-j3qv-h2gm, GHSA-h2c7-jjqq-j49j):
           /user-auth/ is public (no Authelia), so it serves ONLY the pages
           listed here. Everything else, including any file added later,
           answers 404. Included files (error.cfm, inc/html_head.cfm) are not
           requests and are unaffected. --->
      <cfset _publicPages = "/user-auth/index.cfm,/user-auth/forgot_password.cfm,/user-auth/reset_password.cfm,/user-auth/quarantine_release.cfm">
      <cfif NOT ListFind(_publicPages, LCase(Arguments.targetPage))>
          <cfheader statuscode="404" statustext="Not Found">
          <cfcontent reset="true" type="text/plain">
          <cfabort>
      </cfif>

      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

      

       </cffunction>

</cfcomponent>
