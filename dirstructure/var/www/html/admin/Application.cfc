<cfsetting enablecfoutputonly="yes">

<cfcomponent displayname="HermesSEG" output="false" hint="Handle the applications">

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

       //Define syslog Datasource
       <cfscript>
		this.datasources["syslog"] = {
		class: 'com.mysql.jdbc.Driver'
		, bundleName: 'com.mysql.jdbc'
		, bundleVersion: '5.1.40'
		, connectionString: 'jdbc:mysql://localhost:3306/Syslog?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
		, username: '#SYSLOG_DATASOURCE_USERNAME#'
		, password: "#SYSLOG_DATASOURCE_PASSWORD#"
		// optional settings
		, blob:true // default: false
		, clob:true // default: false
		, connectionLimit:100 // default:-1
		};
	</cfscript>

       //Define syslog Datasource
       <cfscript>
		this.datasources["djigzo"] = {
		class: 'com.mysql.jdbc.Driver'
		, bundleName: 'com.mysql.jdbc'
		, bundleVersion: '5.1.40'
		, connectionString: 'jdbc:mysql://localhost:3306/djigzo?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
		, username: '#CIPHERMAIL_DATASOURCE_USERNAME#'
		, password: "#CIPHERMAIL_DATASOURCE_PASSWORD#"
		// optional settings
		, blob:true // default: false
		, clob:true // default: false
		, connectionLimit:100 // default:-1
		};
	</cfscript>

       
	<cfset This.name="AdminGUI" />
	<cfset This.Sessionmanagement="True" />
       <cfset This.loginstorage="session" />
       <cfset This.requestTimeout=createTimeSpan(0,1,0,0) />

       //Define POP4 Component
        <cfset This.componentpaths["/pop"]= "/var/www/html/cfc/pop4" />

	<cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />

       <!--- Set default session.LoggedIn parameter as false --->
       <cfparam name="session.Loggedin" default=false />
	
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />

       <!--- Authentication Session --->


       <!--- DETERMINE CONSOLE MODE --->
       
       <cfinclude template="/admin/2/inc/get_console_mode.cfm">


      <cfset reqData = GetHttpRequestData() />

      <!--- GET CLIENT IP --->
      <cfif IsStruct( reqData ) 
        AND StructKeyExists( reqData, "Headers" )
        AND IsStruct( reqData.Headers )
        AND StructKeyExists( reqData.Headers , "X-Forwarded-For" )>

        <!--- Get IP using X-Forwarded-For --->
        <cfset ClientIP=#GetHttpRequestData().headers['X-Forwarded-For']#>

        <!--- If IP contains multiple IPs separated by comma due to reverse proxy in front of Hermes --->
        <cfif #ClientIP# contains ",">
        <!--- Get the left most value which is most likely the client IP --->
        <cfset ClientIP = #trim(ListGetAt(ClientIP, 1, ","))#>
       </cfif>

    <!--- IsStruct( reqData ) --->
    </cfif>

     <!--- ATTEMPT TO CHECK FOR TOKEN STARTS HERE --->

     <!--- CHECK FOR X-TOKEN HEADER --->

       <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Token" )>

       <cfset theToken = getHttpRequestData().headers["X-Token"]>
 
       <cfif #theToken# is "">
 
        <cfset m="Appplication.cfc: There was an error verifying token session. X-Token is blank">
        <cfinclude template="/admin/2/inc/error.cfm">
        <cfabort>     
 
       <cfelse>
 
         <!--- CHECK FOR X-VERIFY-TOKEN HEADER --->
        <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Verify-Token" )>
 
        <cfset VerifyToken = getHttpRequestData().headers["X-Verify-Token"]>
 
        <cfif #VerifyToken# is "">
 
               
        <cfset m="Appplication.cfc: There was an error verifying token session. X-Verify-Token is blank">
        <cfinclude template="/admin/2/inc/error.cfm">
        <cfabort>   
 
        <cfelse>
 
               
        <CFQUERY NAME="checktoken" DATASOURCE="hermes">
               SELECT token, name, ip, system, active, verify
               FROM api_tokens
               WHERE token like binary '#theToken#' and verify like binary '#VerifyToken#'
               </CFQUERY>
        
               <cfif #checktoken.recordcount# EQ 1>
 
               <!--- DELETE VERIFY TOKEN  --->
               <CFQUERY NAME="deleteverify" DATASOURCE="hermes">
               update api_tokens set verify = ''
               WHERE token like binary '#theToken#' and verify like binary '#VerifyToken#'
               </CFQUERY>
               
                      
               <!--- PROCESS TOKEN REQUEST --->      
               <cfinclude template="/admin/2/inc/setsession.cfm">     
   
               <cfelse>
        
               <cfset m="Appplication.cfc: There was an error verifying token session. checktoken.recordcount NEQ 1">
               <cfinclude template="/admin/2/inc/error.cfm">
               <cfabort>     
               
               <!--- /CFIF #checktoken.recordcount# --->
               </cfif>
 
      
        <!--- /CFIF  #VerifyToken# is "" --->
        </cfif>
 
        <!--- /CFIF IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Verify-Token" --->
        </cfif>
 
             
        <!--- /CFIF  #theToken# is "" --->
        </cfif>


     <!--- ATTEMPT TO CHECK FOR TOKEN ENDS HERE --->

       <!--- IF X-Token Header does NOT exist check for remote-user and cookie headers --->
       <cfelse>

       <cfset session.theUser = getHttpRequestData().headers["remote-user"]>  

      <!--- CHECK FOR REMOTE-USER HEADER --->
      <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "remote-user" )>

      
       <cfset session.theUser = getHttpRequestData().headers["remote-user"]>

      <cfelse>

     <cfset m="Appplication.cfc: remote-user header does NOT exist">
     <cfinclude template="/admin/2/inc/error.cfm">
     <cfabort>

     
     <!--- IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "remote-user" ) --->
     </cfif>

     <!--- CHECK FOR COOKIE HEADER --->

     <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "cookie" )>

     <cfset theCookie = getHttpRequestData().headers["cookie"]>
       
     <!--- DEBUG BELOW --->
     
     <!---
    <cfoutput>the cookie: #theCookie#<br>
the url: #theurl#</cfoutput>
    --->

       
         <cfexecute name="/usr/bin/curl"
         arguments="-X 'GET' -k '#theurl#/api/verify' -H 'accept: */*' -H 'X-Original-URL: #theurl#/admin/' -H 'Cookie: #theCookie#'"
         variable="curlresult"
         timeout="10" />

       <cfif #curlresult# is "Unauthorized">

       <cfset m="Appplication.cfc: session is unauthorized">
       <cfinclude template="/admin/2/inc/error.cfm">
       <cfabort>      
       </cfif>

     <cfelse>

       <cfset m="Appplication.cfc: cookie header does NOT exist">
       <cfinclude template="/admin/2/inc/error.cfm">
       <cfabort>
    
    <!--- IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "cookie" ) --->
        </cfif>
    
      
      <!---
      <cfset session.theGroups = getHttpRequestData().headers["remote-groups"]>
      --->

      <cfif #session.theUser# is not "">

       <CFQUERY NAME="checkuser" DATASOURCE="hermes">
       SELECT id, username, first_name, last_name, email
       FROM system_users
       WHERE username='#session.theUser#'
       </CFQUERY>

       <cfif #checkuser.recordcount# LT 1>

       <!--- PROCESS SYSTEM USER LOG IN --->
       <cfelseif #checkuser.recordcount# GTE 1>

       <cfset session.loggedin = "true">
       <cfoutput>
       <cfset session.first_name = #checkuser.first_name#>
       <cfset session.last_name = #checkuser.last_name#>
       <cfset session.email = #checkuser.email#>
       <cfset session.userid = #checkuser.id#>
       </cfoutput>
       
       <cfinclude template="/admin/2/inc/setsession.cfm"  >

       <!--- /CFIF checkuser.recordcount LT 1 --->
       </cfif>

       <!--- /CFIF session.theUser is not "" --->
      </cfif>

       <!--- /CFIF IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Token" --->
       </cfif>

<!--- CHECK IF WIZARD HAS BEEN RAN FUNCTIONALITY HAS BEEN MOVED TO INDEX.CFM AS OF BUILD 220410 --->
<!---       

      <!--- Check if Wizard has been ran --->
      <cfquery name="checkwizard" datasource="hermes">
       select parameter, value from system_settings where parameter='wizard_settings'
       </cfquery>
       
       <cfif #checkwizard.value# is "2">
       
       <cfif NOT ListFindNoCase("logout.cfm,system_settings.cfm,system_backup.cfm,system_restore.cfm,run_restore.cfm,system_restart.cfm", ListLast(CGI.SCRIPT_NAME, "/"))>
     
       <cfinclude template="system_settings.cfm" />
       <cfabort />
   
  

       <!--- /CFIF NOT ListFindNoCase ---> 
       </cfif>
       
       <!--- /CFIF #checkwizard.value# is "2" ---> 
       </cfif>
      --->

      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

      

       </cffunction>

</cfcomponent>
