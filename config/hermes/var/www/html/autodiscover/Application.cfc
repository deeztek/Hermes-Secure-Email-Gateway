<cfsetting enablecfoutputonly="yes">

<cfcomponent displayname="HermesAutoDiscover" output="false" hint="Minimal Application.cfc for autodiscover/autoconfig endpoints. Provides the hermes datasource without session/auth requirements.">

  <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="HERMES_DATASOURCE_USERNAME">
  <cffile action="read" file="/opt/hermes/creds/hermes_password" variable="HERMES_DATASOURCE_PASSWORD">

      <cfscript>
        this.name = "HermesAutoDiscover";
        this.sessionManagement = false;
        this.clientManagement = false;

        this.datasources["hermes"] = {
            class: 'com.mysql.jdbc.Driver'
            , bundleName: 'com.mysql.jdbc'
            , bundleVersion: '5.1.40'
            , connectionString: 'jdbc:mysql://hermes_db_server:3306/hermes?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&autoReconnect=true&useSSL=false&verifyServerCertificate=false&enabledTLSProtocols=TLSv1.2&requireSSL=false'
            , username: '#HERMES_DATASOURCE_USERNAME#'
            , password: "#HERMES_DATASOURCE_PASSWORD#"
            , blob:true
            , clob:true
            , connectionLimit:10
        };
      </cfscript>

    <cffunction name="onRequestStart" returnType="boolean" output="false">
        <cfargument name="thePage" type="string" required="true">
        <cfset datasource = "hermes">
        <cfreturn true>
    </cffunction>

</cfcomponent>
