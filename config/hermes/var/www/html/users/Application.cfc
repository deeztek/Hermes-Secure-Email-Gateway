<cfcomponent displayname="HermesSEGUser" output="false" hint="Handle the applications">

  <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="HERMES_DATASOURCE_USERNAME">
  <cffile action="read" file="/opt/hermes/creds/hermes_password" variable="HERMES_DATASOURCE_PASSWORD">

//Define Datasource
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


        <cfset This.name="UserGUI" />
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

<!--- GET CONSOLE HOST --->
<cfquery name = "getconsolehost" datasource = "hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.host'
</cfquery>

<cfset consoleHost = "#getconsolehost.value2#">


      <cfset reqData = GetHttpRequestData() />



       <cfset session.theUser = getHttpRequestData().headers["remote-user"]>

      <!--- CHECK FOR REMOTE-USER HEADER --->
      <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "remote-user" ) AND StructKeyExists( reqData.Headers , "remote-email" ) AND StructKeyExists( reqData.Headers , "remote-name") AND StructKeyExists( reqData.Headers , "remote-groups" )>


       <cfset session.theUser = getHttpRequestData().headers["remote-user"]>
       <cfset session.email = getHttpRequestData().headers["remote-email"]>
        <cfset session.theName = getHttpRequestData().headers["remote-name"]>
        <cfset session.theGroups = getHttpRequestData().headers["remote-groups"]>

      <cfelse>

     <cfset m="User Application.cfc: remote-user and/or remote-email, remote-name heeaders do NOT exist">
     <cfinclude template="/user-auth/error.cfm">
     <cfabort>


     <!--- IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "remote-user" ) --->
     </cfif>

     <!--- CHECK FOR COOKIE HEADER --->

     <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "cookie" )>

     <cfset theCookie = getHttpRequestData().headers["cookie"]>

     <!--- DEBUG BELOW --->

     <!---
    <cfoutput>the cookie: #theCookie#<br>
the url: https://#ConsoleHost#</cfoutput>
    --->


         <cfexecute name="/usr/bin/curl"
         arguments="-X 'GET' -k 'https://#ConsoleHost#/api/verify' -H 'accept: */*' -H 'X-Original-URL: https://#ConsoleHost#/users/' -H 'Cookie: #theCookie#'"
         variable="curlresult"
         timeout="10" />

       <cfif #curlresult# is "Unauthorized">

       <cfset m="User Application.cfc: session is unauthorized">
       <cfinclude template="/user-auth/error.cfm">
       <cfabort>


<cfelse>

       <cfset session.loggedin = "true">


  <cfquery name="getid" datasource="hermes">
  select id from maddr where email='#session.email#'
  </cfquery>

<cfif #getid.recordcount# LT 1>

       <cfset m="User Application.cfc: Unable to get maddr id ">
       <cfinclude template="/user-auth/error.cfm">
       <cfabort>
<cfelse>

<cfset session.owner = #getid.id#>

<!--- /CFIF #getid.recordcount# --->
</cfif>

  <cfquery name="getusersettings" datasource="hermes">
  select train_bayes, download_msg, secondary_email, secondary_email_verified
  from user_settings where email='#session.email#'
  </cfquery>

<cfif #getusersettings.recordcount# LT 1>

       <cfset m="User Application.cfc: Unable to get user settings ">
       <cfinclude template="/user-auth/error.cfm">
       <cfabort>
<cfelse>

 <cfset session.train_bayes = #getusersettings.train_bayes#>
  <cfset session.download_msg = #getusersettings.download_msg#>
  <cfset session.secondary_email = getusersettings.secondary_email>
  <cfset session.secondary_email_verified = getusersettings.secondary_email_verified>

<!--- /CFIF #getusersettings.recordcount# --->
</cfif>



     <!---
      <cfset session.theGroups = getHttpRequestData().headers["remote-groups"]>
      --->



       <!--- /CFIF  #curlresult# is "Unauthorized"  --->
       </cfif>


     <cfelse>

       <cfset m="User Application.cfc: cookie header does NOT exist">
       <cfinclude template="/user-auth/error.cfm">
       <cfabort>

    <!--- IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "cookie" ) --->
        </cfif>





      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />



       </cffunction>
</cfcomponent>

