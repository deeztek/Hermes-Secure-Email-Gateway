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


          
  <cfset This.name="Hermes API" />
  <cfset This.Sessionmanagement="True" />
     <cfset This.loginstorage="session" />
     <cfset This.requestTimeout=createTimeSpan(0,1,0,0) />

     
  <cffunction name="onRequest">
     <cfargument name="targetPage" type="String" required=true />

      
     <!--- Set default datasource name ---> 
     <cfset datasource="hermes" />
       
    <cfinclude template="#Arguments.targetPage#" />
    <cfreturn />

     </cffunction>

</cfcomponent>

