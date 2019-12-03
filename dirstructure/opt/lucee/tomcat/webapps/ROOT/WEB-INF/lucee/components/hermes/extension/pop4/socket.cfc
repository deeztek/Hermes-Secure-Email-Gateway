<!---
	Name         : socket.cfc
	Author       : Paul Vernon, New Media Development Ltd (http://www.newmediadevelopment.net/)
	Created      : 09 Nov 2009
	Last Updated : 09 Nov 2009
	History      : Version 1
						Added basic socket functions
					Version 1.1
						Improved performance of the read function when handling large chunks of data by using the StringWriter object.

	Purpose		 : To provide basic sockets connectivity for ColdFusion
--->

<cfcomponent name="socket" displayName="socket" output="false"
		hint="Provides Raw socket functionality.">

	<cffunction name="init" type="public" returntype="socket" output="false"
			hint="Constructor function.">
		<cfargument name="hostname" type="string" required="true">
		<cfargument name="port" type="numeric" required="true">
		<cfargument name="UseSSL" type="boolean" required="false" default="false">
		<cfargument name="timeout" type="numeric" required="false" default="30">

		<cfset StructInsert(variables, "instance", StructNew())>

		<cfif arguments.UseSSL>
			<cfset setProperty("socketFactory", createObject("java","javax.net.ssl.SSLSocketFactory").getDefault())>
		<cfelse>
			<cfset setProperty("socketFactory", createObject("java","javax.net.SocketFactory").getDefault())>
		</cfif>

		<cfset setProperty("hostname", arguments.hostname)>
		<cfset setProperty("port", arguments.port)>
		<cfset setProperty("timeout", arguments.timeout)>
		<cfset setProperty("UseSSL", arguments.UseSSL)>

		<cfreturn this>
	</cffunction>

	<cffunction name="setProperty" access="public" returntype="boolean" output="false"
			hint="Sets a property in the object instance.">
		<cfargument name="property" type="string" required="true" hint="The name of the instance property to be set.">
		<cfargument name="propertyValue" type="any" required="true" hint="The value of the instance property to be set.">

		<cfset StructInsert(variables["instance"], arguments.property, arguments.propertyValue, true)>

		<cfreturn true>
	</cffunction>

	<cffunction name="getProperty" access="public" returntype="any" output="false"
			hint="Returns the value of the property in the object instance.">
		<cfargument name="property" type="string" required="true" hint="The name of the instance property to retrieve.">

		<cfreturn variables["instance"][arguments.property]>
	</cffunction>

	<cffunction name="propertyExists" access="private" returntype="boolean" output="false"
			hint="Just checks whether the property exists or not...">
		<cfargument name="property" type="string" required="true" hint="The name of the instance property to retrieve.">

		<cfreturn StructKeyExists(variables.instance, arguments.property)>
	</cffunction>

	<cffunction name="connect" access="public" returntype="boolean" output="false"
			hint="Connects to a host and port">
		<cfset var sout = "">

		<cfset setProperty("sock", variables["instance"]["socketFactory"].createSocket(getProperty("hostname"), JavaCast("int", getProperty("port"))))>
		<cfif getProperty("UseSSL")>
			<cfset getProperty("sock").startHandshake()>
		</cfif>
		<cfset getProperty("sock").setSoTimeout(JavaCast("int", getProperty("timeout")*1000))>
		<cfif getProperty("sock").isConnected()>
			<cfset sout = getProperty("sock").getOutputStream()>
			<cfset setProperty("out", createObject("java", "java.io.PrintWriter").init(sout))>
		</cfif>

		<cfreturn getProperty("sock").isConnected()>
	</cffunction>

	<cffunction name="write" access="public" returntype="boolean" output="false"
			hint="Writes data to the socket">
		<cfargument name="string" type="string" required="true">

		<cfset getProperty("out").println(arguments.string)>
		<cfset getProperty("out").flush()>

		<cfreturn true>
	</cffunction>

	<cffunction name="read" access="public" returntype="string" output="false"
			hint="Reads data from the socket">

		<cfset var result = "">
		<cfset var sinput = getProperty("sock").getInputStream()>
		<cfset var inputStreamReader = createObject("java", "java.io.InputStreamReader").init(sinput)>
		<cfset var locInput = createObject("java", "java.io.BufferedReader").init(InputStreamReader)>
		<cfset var timeout = getTickCount()+(getProperty("timeout")*1000)>
		<cfset var outputStream = createObject("java", "java.io.StringWriter")>

		<cfif getProperty("sock").isConnected()>
			<cfloop condition="not locInput.ready()">
				<cfset sleep(1)> <!--- take a breather --->
				<cfif timeout LT getTickCount()>
					<!--- if we're here we haven't had a response from the server --->
					<!--- SSL connections currently always time out --->
					<!--- no idea why --->
					<cfthrow message="Connection Timed out." detail="The connection did not receive a response within the timeout period.">
				</cfif>
			</cfloop>
			<!---
			<cfloop condition="locInput.ready()">
            	<cfset outputStream.write(locInput.read())>
			</cfloop>
			--->
			<cfscript>
				while (locInput.ready())
					outputStream.write(locInput.read());
			</cfscript>
			<cfset result = outputStream.toString()>
		<cfelse>
			<cfthrow message="Not connected." detail="There is no connection to the host.">
		</cfif>

		<cfreturn result>
	</cffunction>

	<cffunction name="readToEOM" access="public" returntype="string" output="false"
			hint="Reads data from the socket until we hit an EOM pattern.">
		<cfargument name="EOM" type="string" required="false" default="\r?\n\.\r?\n">

		<cfset var result = read()>

		<!---
		<cfloop condition="REFind(arguments.EOM, result) IS 0">
			<cfset result = result & read()>
		</cfloop>
		--->

    	 <cfscript>
			while (REFind(arguments.EOM, result) IS 0)
				result = result & read();
		</cfscript>

		<cfreturn REReplaceNoCase(result, "(#arguments.EOM#).*", "\1", "ALL")>
	</cffunction>

	<cffunction name="close" access="public" returntype="boolean" output="false"
			hint="Closes the socket.">

		<cfif propertyExists("out")>
			<cfset getProperty("out").close()>
		</cfif>
		<cfif propertyExists("input")>
			<cfset getProperty("input").close()>
		</cfif>
		<cfif propertyExists("sock")>
			<cfset getProperty("sock").close()>
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="isClosed" access="public" returntype="boolean" output="false"
			hint="Checks to see if the socket is closed.">

		<cfif propertyExists("sock")>
			<cfreturn getProperty("sock").isClosed()>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="Test" access="Public" returntype="string" output="false"
			hint="Test performs a whois call.">
		<cfargument name="hostname" type="string" required="false" default="whois.nic.uk">
		<cfargument name="domain" type="string" required="true" default="web-architect.co.uk">
		<cfargument name="port" type="numeric" required="false" default="43" hint="The port to connect to." >

		<cfset var result = "">

		<cfset setProperty("hostname", arguments.hostname)>
		<cfset setProperty("port", arguments.port)>
		<cftry>
			<cfif connect()>
				<cfset write(arguments.domain)>
				<cfset sleep(500)>
				<cfset result = read()>
				<cfset close()>
			</cfif>
			<cfcatch>
				<cfif not isClosed()>
					<cfset close()>
				</cfif>
			</cfcatch>
		</cftry>

		<cfreturn result>
	</cffunction>

</cfcomponent>