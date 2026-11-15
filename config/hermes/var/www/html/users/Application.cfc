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

        <!--- Password change logic (AuthService.cfc) lives outside the web
             root; this mapping is never reachable by URL. --->
        <cfset This.mappings["/hermesauth"] = "/opt/hermes/cfml" />

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

     <cfset theCookie = "">
     <!--- Rebuild the Cookie header from the browser's cookies, keeping only
          well-formed pairs: a token name, and a value of printable ASCII with
          no space or semicolon (Authelia session values contain characters
          such as $ ! %). Control characters, which could inject an extra
          header, never pass. Whatever the Authelia cookie is called (it
          follows Authelia's running configuration, not the database), it
          passes through. --->
     <cfset cookiePairs = []>
     <cfloop list="#reqData.Headers['cookie']#" delimiters=";" index="cookiePair">
         <cfset cookiePair = Trim(cookiePair)>
         <cfif REFind("^[A-Za-z0-9_.-]{1,128}=[!-:<-~]{1,4096}$", cookiePair) GT 0>
             <cfset ArrayAppend(cookiePairs, cookiePair)>
         </cfif>
     </cfloop>
     <cfif ArrayLen(cookiePairs) GT 0 AND Len(ArrayToList(cookiePairs, "; ")) LE 8192>
         <cfset theCookie = ArrayToList(cookiePairs, "; ")>
     </cfif>
     <cfif theCookie EQ "">
         <cfset m="Application.cfc: session cookie missing or malformed">
         <cfinclude template="/user-auth/error.cfm">
         <cfabort>
     </cfif>

     <!--- DEBUG BELOW --->

     <!---
    <cfoutput>the cookie: #theCookie#<br>
the url: https://#ConsoleHost#</cfoutput>
    --->


         <!--- Arguments as an array: each element reaches curl as exactly one
              argument, with no quote parsing and no shell, so nothing in a
              cookie value can become a separate option. --->
         <cfexecute name="/usr/bin/curl"
         arguments="#['-X', 'GET', '-k', 'https://' & ConsoleHost & '/api/verify', '-H', 'accept: */*', '-H', 'X-Original-URL: https://' & ConsoleHost & '/users/', '-H', 'Cookie: ' & theCookie]#"
         variable="curlresult"
         timeout="10" />

       <cfif #curlresult# is "Unauthorized">

       <cfset m="User Application.cfc: session is unauthorized">
       <cfinclude template="/user-auth/error.cfm">
       <cfabort>


<cfelse>

       <cfset session.loggedin = "true">


  <cfquery name="getid" datasource="hermes">
  select id from maddr where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
  </cfquery>

<cfif #getid.recordcount# LT 1>
  <!--- No maddr entry yet (new mailbox user, no mail processed by Amavis).
       Set owner to 0 so portal loads with empty message history/filters. --->
  <cfset session.owner = 0>
<cfelse>
  <cfset session.owner = #getid.id#>
<!--- /CFIF #getid.recordcount# --->
</cfif>

  <cfquery name="getusersettings" datasource="hermes">
  select train_bayes, download_msg, secondary_email, secondary_email_verified
  from user_settings where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
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

  <!--- Auth type (local vs remote/SSO). Used to suppress the
       password-recovery-email nag for remote-auth users — their
       password lives in an external IdP, so a recovery email here
       would do nothing. Defaults to empty if no recipients row. --->
  <cfquery name="getauthtype" datasource="hermes">
  select auth_type from recipients where recipient = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif getauthtype.recordcount GTE 1>
    <cfset session.auth_type = getauthtype.auth_type>
  <cfelse>
    <cfset session.auth_type = "">
  </cfif>

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





      <!--- Record login (first request of new session only; flag-gated inside) --->
      <cfinclude template="/admin/2/inc/record_login.cfm" />

      <!--- SECURITY: files under /users/2/inc/ are fragments for other pages
           to include. Requested directly they would skip the checks the
           including page makes, so only the endpoints the browser really
           calls (AJAX, form targets, downloads) may be requested. --->
      <cfset _incPath = LCase(Arguments.targetPage)>
      <cfif Find("/users/2/inc/", _incPath) EQ 1>
          <cfset _incAllowed = "/users/2/inc/download_message.cfm,/users/2/inc/get_domain_mailboxes.cfm,/users/2/inc/get_mailbox_folders.cfm,/users/2/inc/get_sieve_rule_json.cfm,/users/2/inc/get_user_addresses.cfm,/users/2/inc/save_signature_action.cfm">
          <cfif NOT ListFind(_incAllowed, _incPath)>
              <cfheader statuscode="404" statustext="Not Found">
              <cfcontent reset="true" type="text/plain">
              <cfabort>
          </cfif>
      </cfif>

      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />



       </cffunction>
</cfcomponent>

