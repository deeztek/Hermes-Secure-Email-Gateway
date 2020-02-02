<cfcomponent displayname="HermesSEG" output="false" hint="Handle the applications">
	
      //Define hermes Datasource
      <cfscript>
		this.datasources["hermes"] = {
		class: 'com.mysql.jdbc.Driver'
		, bundleName: 'com.mysql.jdbc'
		, bundleVersion: '5.1.40'
		, connectionString: 'jdbc:mysql://localhost:3306/hermes?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
		, username: 'HERMES_DATASOURCE_USERNAME'
		, password: "HERMES_DATASOURCE_PASSWORD"
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
		, username: 'SYSLOG_DATASOURCE_USERNAME'
		, password: "SYSLOG_DATASOURCE_PASSWORD"
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
		, username: 'CIPHERMAIL_DATASOURCE_USERNAME'
		, password: "CIPHERMAIL_DATASOURCE_PASSWORD"
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
	<cfset This.componentpaths["/pop"]= "/opt/lucee/tomcat/webapps/ROOT/WEB-INF/lucee/components/hermes/extension/pop4" />

	<cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />

       <!--- Set default session.UserLoggedin Parameter as false --->
       <cfparam name="session.UserLoggedin" default=false />
	
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />
         
      <!--- URL Variable Checks Starts Here --->
      
      <!--- url.ID --->
      <cfif structKeyExists(url, "ID")>
   
      <cfif not IsNumeric(URL.ID)>
      <cfinclude template="error.cfm" />
      <cfabort />
      
      <!--- /CFIF not IsNumeric ---> 
      </cfif>

      <!--- /CFIF StuctKeyExists ---> 
      </cfif>

      <!--- url.startrow --->
      <cfif structKeyExists(url, "startrow")>
   
      <cfif not IsNumeric(url.startrow)>
      <cfinclude template="error.cfm" />
      <cfabort />
      
      <!--- /CFIF not IsNumeric ---> 
      </cfif>

      <!--- /CFIF StuctKeyExists ---> 
      </cfif>

      <!--- url.displayrows --->
      <cfif structKeyExists(url, "displayrows")>
   
      <cfif not IsNumeric(url.displayrows)>
      <cfinclude template="error.cfm" />
      <cfabort />
      
      <!--- /CFIF not IsNumeric ---> 
      </cfif>

      <!--- /CFIF StuctKeyExists ---> 
      </cfif>

      <cfif structKeyExists(url, 'uid')>
      <cfif #url.uid# is not "">

      <cfquery name="checkkeywords" datasource="hermes">
      SELECT * FROM keywords where keyword IN ('#url.uid#') and banned='1'
      </cfquery>

      <cfif #checkkeywords.recordcount# LT 1>
      <cfset uid="#url.uid#">
      <cfelseif #checkkeywords.recordcount# GTE 1>
      <cfinclude template="/main/user_error.cfm">
      <cfabort />

      </cfif>

      <cfelseif #url.uid# is "">
      <cfinclude template="/main/user_error.cfm">
      <cfabort />

      </cfif>

      <cfelseif NOT structKeyExists(url, 'uid')>
      <cfif #session.UserLoggedin# is "FALSE">
      <cfinclude template="/main/user_error.cfm">
      <cfabort />

      <cfelseif #session.UserLoggedin# is "TRUE">
      <cfset uid=#session.uid#>
      </cfif>
      </cfif>


     <cfif structKeyExists(url, 'mid')>
     <cfif #url.mid# is not "">

     <cfquery name="checkkeywords" datasource="hermes">
     SELECT * FROM keywords where keyword IN ('#url.mid#') and banned='1'
     </cfquery>

     <cfif #checkkeywords.recordcount# LT 1>
     <cfset mid="#url.mid#">
     <cfelseif #checkkeywords.recordcount# GTE 1>
     <cfinclude template="/main/user_error.cfm">
     <cfabort />

     </cfif>

     <cfelseif #url.mid# is "">
     <cfinclude template="/main/user_error.cfm">
     <cfabort />

     </cfif>

     <cfelseif NOT structKeyExists(url, 'mid')>
     <cfset mid=666>
     </cfif>

    <cfif structKeyExists(url, 'sid')>
    <cfif #url.sid# is not "">

    <cfquery name="checkkeywords" datasource="hermes">
    SELECT * FROM keywords where keyword IN ('#url.sid#') and banned='1'
    </cfquery>

    <cfif #checkkeywords.recordcount# LT 1>
    <cfset sid="#url.sid#">
    <cfelseif #checkkeywords.recordcount# GTE 1>
    <cfinclude template="/main/user_error.cfm">
    <cfabort />

    </cfif>
    <cfelseif #url.sid# is "">
    <cfinclude template="/main/user_error.cfm">
    <cfabort />

    </cfif>

    <cfelseif NOT structKeyExists(url, 'sid')>
    <cfset sid=666>
    </cfif>

    <cfif structKeyExists(url, 'dest')>
    <cfif #url.dest# is not "">

    <cfquery name="checkkeywords" datasource="hermes">
    SELECT * FROM keywords where keyword IN ('#url.dest#') and banned='1'
    </cfquery>

    <cfif #checkkeywords.recordcount# LT 1>
    <cfset dest="#url.dest#">
    <cfelseif #checkkeywords.recordcount# GTE 1>
    <cfinclude template="/main/user_error.cfm">
    <cfabort />

    </cfif>
    <cfelseif #url.dest# is "">
    <cfinclude template="/main/user_error.cfm">
    <cfabort />

    </cfif>

    <cfelseif NOT structKeyExists(url, 'dest')>
    <cfif #session.UserLoggedin# is "FALSE">
    <cfinclude template="/main/user_error.cfm">
    <cfabort />

    </cfif>
    </cfif>


    <cfquery name="getemail" datasource="hermes">
    select email, password_set from user_settings where id like binary '#uid#'
    </cfquery>

    <cfif #getemail.recordcount# GTE 1>
    <cfif #getemail.password_set# is "0">
    <cfset session.UserPassword = 0>
    <cfelseif #getemail.password_set# is "1">
    <cfset session.UserPassword = 1>
    <!-- /CFIF FOR getemail.password_set -->
    </cfif>
    <cfelseif #getemail.recordcount# LT 1>
    <cfinclude template="/main/user_error.cfm">
    <cfabort>
    <!-- /CFIF FOR getemail.recordcount -->
    </cfif>

  
      <!--- URL Variable Checks Ends Here --->

      <!--- Authentication Session --->
      <cfif not session.UserLoggedin>
      <cfinclude template="user_authenticate.cfm" />
      <cfabort />

      <!--- </CFIF session.UserloggedIn --->     
      </cfif>

      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

       </cffunction>

</cfcomponent>

