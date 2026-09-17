<cfcomponent displayname="HermesTransactionalAPI" output="false" hint="Transactional API application bootstrap">

  <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="HERMES_DATASOURCE_USERNAME">
  <cffile action="read" file="/opt/hermes/creds/hermes_password" variable="HERMES_DATASOURCE_PASSWORD">

  <cfscript>
    this.datasources["hermes"] = {
      class: "com.mysql.jdbc.Driver",
      bundleName: "com.mysql.jdbc",
      bundleVersion: "5.1.40",
      connectionString: "jdbc:mysql://hermes_db_server:3306/hermes?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&useSSL=false&verifyServerCertificate=false&enabledTLSProtocols=TLSv1.2&requireSSL=false",
      username: trim(HERMES_DATASOURCE_USERNAME),
      password: trim(HERMES_DATASOURCE_PASSWORD),
      blob: true,
      clob: true,
      connectionLimit: 100
    };
  </cfscript>

  <cfset This.name = "HermesTransactionalAPI">
  <cfset This.Sessionmanagement = "False">
  <cfset This.datasource = "hermes">
  <cfset This.requestTimeout = createTimeSpan(0,1,0,0)>

</cfcomponent>
