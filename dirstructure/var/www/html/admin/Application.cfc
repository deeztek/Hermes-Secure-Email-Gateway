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


       
	<cfset This.name="AdminGUI" />
	<cfset This.Sessionmanagement="True" />
       <cfset This.loginstorage="session" />
       <cfset This.requestTimeout=createTimeSpan(0,1,0,0) />

       //Define POP4 Component  
	<cfset This.componentpaths["/pop"]= "/opt/lucee/tomcat/webapps/ROOT/WEB-INF/lucee/components/hermes/extension/pop4" />

	<cffunction name="onRequest">
       <cfargument name="targetPage" type="String" required=true />

       <!--- Set default session.LoggedIn parameter as false --->
       <cfparam name="session.Loggedin" default=false />
	
       <!--- Set default datasource name ---> 
       <cfset datasource="hermes" />
       
       <!--- check if Firewall is enabled --->
       <cfquery name="checkfirewall" datasource="hermes">
       select value2 from parameters2 where parameter='firewall_status'
       </cfquery>

      <!--- If Firewall is enabled --->
      <cfif #checkfirewall.value2# is "enabled">

      <!--- Get Client IP and check against the firewall table --->
      <cfquery name="checkip" datasource="hermes">
      select ip from firewall where ip='#GetHttpRequestData().headers['X-Forwarded-For']#'
      </cfquery>

      <!--- If IP is not in the firewall table display unauthorized.cfm page and stop all processing --->
      <cfif #checkip.recordcount# LT 1>
      <cfinclude template="/main/unauthorized.cfm" />
      <cfabort />


      <!-- /CFIF #checkip.recordcount# LT 1 -->
      </cfif>

      <!-- /CFIF #checkfirewall.value2# is "enabled" -->
      </cfif>

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


      <!--- url.email --->
      <cfif structKeyExists(url, "email")>
   
      <cfif not IsValid("email", url.email)>
      <cfinclude template="error.cfm" />
      <cfabort />
      
      <!--- /CFIF not IsValid ---> 
      </cfif>

      <!--- /CFIF StuctKeyExists ---> 
      </cfif>

      <!--- url.mid --->
      <cfif structKeyExists(url, "mid")>
   
      <cfif REFind("[^A-Za-z0-9\\[%]\\-]",url.mid) gt 0>
      <cfinclude template="error.cfm" />
      <cfabort />
      
      <cfelse>
      <cfquery name="checkkeywords" datasource="hermes">
      SELECT * FROM keywords where keyword IN ('#url.mid#') and banned='1'
      </cfquery>
 
      <cfif #checkkeywords.recordcount# GTE 1>
      <cfinclude template="error.cfm" />
      <cfabort />

      <!--- /CFIF checkkeywords.recordcount --->
      </cfif>

      <!--- /CFIF REFind ---> 
      </cfif>

      <!--- /CFIF StuctKeyExists ---> 
      </cfif>

  
      <!--- URL Variable Checks Ends Here --->

      <!--- Authentication Session --->
      <cfif not session.Loggedin>
      <cfinclude template="logon.cfm" />
      <cfabort />

      <!--- </CFIF session.loggedIn --->     
      </cfif>

      <!--- Check if Wizard has been ran --->
      <cfquery name="checkwizard" datasource="hermes">
       select parameter, value from system_settings where parameter='wizard_settings'
       </cfquery>
       
       <cfif #checkwizard.value# is "2">
       
       <cfif NOT ListFindNoCase("login.cfm,logout.cfm,system_settings.cfm,system_backup.cfm,system_restore.cfm,run_restore.cfm,system_restart.cfm", ListLast(CGI.SCRIPT_NAME, "/"))>
       <cfinclude template="system_settings.cfm" />
       <cfabort />
       
       <!--- /CFIF NOT ListFindNoCase ---> 
       </cfif>
       
       <!--- /CFIF #checkwizard.value# is "2" ---> 
       </cfif>
       
      <cfinclude template="#Arguments.targetPage#" />
      <cfreturn />

      

       </cffunction>

</cfcomponent>

