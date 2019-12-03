<!---
	Name         : pop.cfc
	Author       : Paul Vernon, New Media Development Ltd (http://www.newmediadevelopment.net/)
	Created      : 08 Nov 2009
	Last Updated : 22 Jul 2013
	History      : Version 1
						Added basic functions to retrieve and delete messages.
						Added support for SSL connections (a la CFX_POP3).
						Added functions to retrieve mail by index or UID.
						Added functions to retrieve new mails received after a specific UID.
						Added extra processing to add in columns containing just pure e-mail addresses (a la CFX_POP3)

					Version 1.1
						Added attachment handling features.
						Added loadFromFile function to allow the reading of rfc2822 messages from disc

					Version 1.2
						Added Stat function returning the number of mails and the total message size.

					Version 1.3
						Added parseRFCDateToCFDate function to convert the date in a message into a usable CF date.

					Version 1.4
						Added List and ListByUID functions returning an array of message sizes. (For all or one specific message)
					Version 1.5
						Added the getRawMessageHeadersByUID, parseRawHeaders and parseRawMessages.
						Re-factored loadFromFile to use parseRawMessages.
							Using these functions along with getRawMessageByUID enables developers to bypass CFPOP entirely. This is
							useful when CFPOP exhibits strange behaviour when downloading e-mails. e.g. where a server has , characters
							in its UID values, CFPOP fails to work.
						Added a separator property to allow developers to specify a list delimiter that is not ","
							This allows a developer to work with mail servers that use , values in their UID responses.
					Version 1.6
						Fixed a bug in the parseRawMessages function to handle nested multipart mails.
					Version 1.7
						Split out the content part processing from parseRawMessages and made it recursive.
							This allows for n-depth nesting of e-mail content, attachments and alternative parts.
						Fixed a bug parsing out the Reply-To header
					Version 1.8

						Removed a couple of lines of repeated and unneccessary code.

						Added in fixes for bugs raised by Tom Chiverton.

							1. a "QUIT" command to the GetRawMessageByUID function and then code to read the response
							from the server before issuing the socket.close() which resolves the issue of the POP3 server
							keeping the account locked for periods of time after disconnection.
							2. added parsing for multipart/report and body with no Content-Type
							3. added in missing procesing for text/html for mails that only contain text/html.
					Version 1.9
						Added in code to decode Quoted Printable strings using the decodeString method.
						Added a fix contributed by Hadyn Cotton to stop writing an extra byte at the end of files.


	Purpose		 : To wrap up CFPOP into a CFC and provide extra features to move the native CF functions towards CFX_POP3

	TODO         : Try to figure out the SSL issues.

	Examples	 :

	Retrieves all mail

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfset popAccount.setProperty("attachmentPath", "C:\")>
	<cfset popAccount.setProperty("generateUniqueFilenames", true)>
	<cfif popAccount.hasMail()>
		<cfset messages = popAccount.getMessages()>
		<cfdump var="#messages#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Retrieves all mail where the server uses "," values within UIDs and the code above fails.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfset popAccount.setProperty("separator", "|")>
	<cfif popAccount.hasMail()>
		<cfset myUIDList = popAccount.getUIDList()>
		<cfset msgSrc = popAccount.GetRawMessageByUID(ArrayToList(myUIDList, "|"))>
		<cfset messages = popAccount.parseRawMessage(msgSrc)>
		<cfdump var="#messages#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Retrieves all mail headers the server uses "," values within UIDs and the getMessageHeaders() function fails.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfset popAccount.setProperty("separator", "|")>
	<cfif popAccount.hasMail()>
		<cfset myUIDList = popAccount.getUIDList()>
		<cfset headerSrc = popAccount.GetRawMessageHeaderByUID(ArrayToList(myUIDList, "|"))>
		<cfset headers = popAccount.parseRawHeaders(headerSrc)>
		<cfdump var="#headers#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Load an email from a file and parse it.

	<cfset popAccount = createObject("component", "pop").init()>
	<cfset message = popAccount.loadFromFile("C:\my-mail.eml")>
	<cfdump var="#message#">

	----------------------------------------------------------

	Retrieve all e-mail from a GMAIL or other SSL account.

	<cfset popAccount = createObject("component", "pop").init("pop.gmail.com", myUsername, myPassword)>
	<cfset popAccount.setProperty("UseSSL", true)>
	<cfif popAccount.hasMail()>
		<cfset messages = popAccount.getMessages()>
		<cfdump var="#messages#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Retrieve all the message headers

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfif popAccount.hasMail()>
		<cfset headers = popAccount.getMessageHeaders()>
		<cfdump var="#headers#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Get all messages that are on the server *AFTER* the message with the UID specified.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>

	<cfif popAccount.hasMail()>
		<cfset messages = popAccount.getMessagesAfterUID("4449837D49E64FA188ED17C20A20373F")>
		<cfdump var="#messages#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Delete these messages by their UID values

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>

	<cfif popAccount.hasMail()>
		<cfset popAccount.deleteMessagesByUID("4449837D49E64FA188ED17C20A20373F,AF6B59B77C314DC48AE25FE41A9434D2")>
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Retrieve the list of UIDs for the e-mails on the server.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfset UIDList = popAccount.getUIDList()>
	<cfdump var="#UIDList#">

	----------------------------------------------------------

	Retrieve the list of all messages and their sizes from the server.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfif popAccount.hasMail()>
		<cfset messagelist = popAccount.list()>
		<cfdump var="#messagelist#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

	----------------------------------------------------------

	Retrieve the information from the list for a specific message in the mailbox.

	<cfset popAccount = createObject("component", "pop").init(myHostname, myUsername, myPassword)>
	<cfif popAccount.hasMail()>
		<cfset messagelist = popAccount.list(1)>
		<cfdump var="#messagelist#">
	<cfelse>
		<p>Mailbox is empty.</p>
	</cfif>

--->

<cfcomponent name="pop" displayName="POP" output="false"
		hint="Provides POP3 functions.">

	<cffunction name="init" type="public" returntype="pop" output="false"
			hint="Constructor function configuring the connection settings for an account.">
		<cfargument name="hostname" type="string" required="false" default="" hint="The hostname for the POP3 server.">
		<cfargument name="username" type="string" required="false" default="" hint="The username for the POP3 account.">
		<cfargument name="password" type="string" required="false" default="" hint="The password for the POP3 account.">
		<cfargument name="port" type="numeric" required="false" default="110" hint="The port to connect to the POP3 server with.">
		<cfargument name="timeout" type="numeric" required="false" default="30" hint="The connection timeout in Seconds">
		<cfargument name="attachmentPath" type="string" required="false" default="" hint="The path to which any attachments should be saved.">
		<cfargument name="generateUniqueFilenames" type="boolean" required="false" default="false" hint="A flag to set whether attachments should be given a unique name.">
		<cfargument name="UseSSL" type="boolean" required="false" default="false" hint="A flag to set the usage of SSL for the mailbox in question.">
		<cfargument name="separator" type="string" required="false" default="," hint="Sets the list separator for UIDL lists">
		<cfargument name="processRFC822asAttachment" type="string" required="false" default="true" hint="Allows you to process an embedded RFC822 eml as an attachment (default) or as the actual e-mail.">

		<cfset var tmpVar = ["EEE, d MMM yy HH:mm:ss z","EEE, d MMM yy HH:mm:ss","EEE, d MMM yyyy HH:mm:ss z","EEE, d MMM yyyy HH:mm:ss","EEE, d MMM yy HH:mm z","EEE, d MMM yyyy HH:mm z","EEE, d MMM yy HH:mm","EEE, d MMM yyyy HH:mm","d MMM yy HH:mm z","d MMM yy HH:mm:ss z","d MMM yyyy HH:mm z","d MMM yyyy HH:mm:ss z"]>

		<cfset StructInsert(variables, "instance", StructNew())>

		<cfset setProperty("hostname", arguments.hostname)>
		<cfset setProperty("username", arguments.username)>
		<cfset setProperty("password", arguments.password)>
		<cfset setProperty("port", arguments.port)>
		<cfset setProperty("timeout", arguments.timeout)>
		<cfset setProperty("lockhash", hash(arguments.hostname&arguments.username))>
		<cfset setProperty("attachmentPath", arguments.attachmentPath)>
		<cfset setProperty("generateUniqueFilenames", arguments.generateUniqueFilenames)>
		<cfset setProperty("emailRegEx", "\b[\w-\._']+@[\w\.-]+\.[\w+\.-]+\b")>
		<cfset setProperty("UseSSL", arguments.UseSSL)>
		<cfset setProperty("dateFormats", tmpVar)>
		<cfset setProperty("separator", arguments.separator)>
		<cfset setProperty("processRFC822asAttachment", arguments.processRFC822asAttachment)>

		<cfreturn this>
	</cffunction>

	<!--- instance property functions --->
	<cffunction name="setSSL" access="private" returntype="boolean" output="false"
			hint="Sets the SSL status of the instance and configures the underlying SocketFactory to use SSL or plain sockets.">
		<cfargument name="UseSSL" type="boolean" required="false" default="false" hint="A flag to set the use of SSL.">

		<cfset var javaSystem = createObject("java", "java.lang.System")>
		<cfset var javaProps = javaSystem.getProperties()>

		<cfif arguments.UseSSL>
			<cfset javaProps.setProperty("mail.pop3.socketFactory.class", "javax.net.ssl.SSLSocketFactory") />
			<cfif getProperty("port") IS 110>
				<cfset setProperty("port", 995)>
			</cfif>
			<cfset StructInsert(variables["instance"], "UseSSL", true, true)>
		<cfelse>
			<cfset javaProps.setProperty("mail.pop3.socketFactory.class", "javax.net.SocketFactory") />
			<cfif getProperty("port") IS 995>
				<cfset setProperty("port", 110)>
			</cfif>
			<cfset StructInsert(variables["instance"], "UseSSL", false, true)>
		</cfif>

		<cfreturn getProperty("UseSSL")>
	</cffunction>

	<cffunction name="setProperty" access="public" returntype="boolean" output="false"
			hint="Sets a property in the object instance.">
		<cfargument name="property" type="string" required="true" hint="The name of the instance property to be set.">
		<cfargument name="propertyValue" type="any" required="true" hint="The value of the instance property to be set.">

		<cfif arguments.property IS "UseSSL">
			<!--- UseSSL is a special case so re-route the logic to the setSSL private function --->
			<cfreturn setSSL(arguments.propertyValue)>
		<cfelse>
			<cfset StructInsert(variables["instance"], arguments.property, arguments.propertyValue, true)>
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="getProperty" access="public" returntype="any" output="false"
			hint="Returns the value of the property in the object instance.">
		<cfargument name="property" type="string" required="true" hint="The name of the instance property to retrieve.">

		<cfreturn variables["instance"][arguments.property]>
	</cffunction>

	<!--- private cfpop functions --->
	<cffunction name="getMessagesEx" access="private" returntype="query" output="false"
			hint="Gets the messages from the POP server.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">
		<cfargument name="startrow" type="numeric" required="false" default="1" hint="This is the index of the first message to retrieve.">
		<cfargument name="UIDList" type="string" required="false" default="" hint="A list of UID values to retrieve specific e-mails.">
		<cfargument name="action" type="string" required="false" default="getAll" hint="The action that CFPOP should perform. Only getAll and getHeaderOnly are valid here.">

		<cfset var result = "">
		<cfset var UIDArray = "">
		<cfset var UID = "">
		<cfset var tmpArray = ArrayNew(1)>
		<cfset var toArray = ArrayNew(1)>
		<cfset var ccArray = ArrayNew(1)>
		<cfset var fromArray = ArrayNew(1)>
		<cfset var replyToArray = ArrayNew(1)>
		<cfset var attributes = StructNew()>

		<cfset checkPOPSettings()>

		<cfif arguments.action NEQ "getAll" AND
				arguments.action NEQ "getHeaderOnly">
			<cfset arguments.action = "getAll">
		</cfif>

		<cfset StructInsert(attributes, "server", getProperty("hostname"))>
		<cfset StructInsert(attributes, "port", getProperty("port"))>
		<cfset StructInsert(attributes, "username", getProperty("username"))>
		<cfset StructInsert(attributes, "password", getProperty("password"))>
		<cfset StructInsert(attributes, "timeout", getProperty("timeout"))>
		<cfset StructInsert(attributes, "action", arguments.action)>
		<cfset StructInsert(attributes, "name", "result")>
		<cfif getProperty("attachmentPath") NEQ "">
			<cfset StructInsert(attributes, "attachmentPath", getProperty("attachmentPath"))>
			<cfset StructInsert(attributes, "generateUniqueFilenames", getProperty("generateUniqueFilenames"))>
		</cfif>

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif arguments.UIDList IS "">
				<cfset UIDArray = getUIDList()>
				<cfif arguments.maxrows IS -1>
					<cfset arguments.maxrows = ArrayLen(UIDArray)-(arguments.startrow-1)>
				</cfif>
				<cfif ArrayLen(UIDArray) LT arguments.startrow+(arguments.maxrows-1)>
					<cfset arguments.maxrows = ArrayLen(UIDArray)-(arguments.startrow-1)>
				</cfif>
				<cfloop from="#arguments.startrow#" to="#arguments.startrow+(arguments.maxrows-1)#" index="UID">
					<cfset ArrayAppend(tmpArray, UIDArray[UID])>
				</cfloop>
				<cfset arguments.UIDList = ArrayToList(tmpArray, getProperty("separator"))>
			</cfif>
			<cfif arguments.UIDList NEQ "">
				<cfset StructInsert(attributes, "UID", UIDList)>
			</cfif>

			<cfpop attributeCollection="#attributes#">
		</cflock>

		<cfif result.recordCount GT 0>
			<cfloop query="result">
				<cfset ArrayAppend(toArray, ExtractAddresses(To))>
				<cfset ArrayAppend(ccArray, ExtractAddresses(CC))>
				<cfset ArrayAppend(fromArray, ExtractAddresses(From))>
				<cfset ArrayAppend(replyToArray, ExtractAddresses(replyTo))>
			</cfloop>
			<cfset QueryAddColumn(result, "TOEMAILADDRESS", "VarChar", toArray)>
			<cfset QueryAddColumn(result, "CCEMAILADDRESS", "VarChar", ccArray)>
			<cfset QueryAddColumn(result, "FROMEMAILADDRESS", "VarChar", fromArray)>
			<cfset QueryAddColumn(result, "REPLYTOEMAILADDRESS", "VarChar", replyToArray)>
		</cfif>

		<cfreturn result>
	</cffunction>

	<cffunction name="deleteMessagesEx" access="private" returntype="void" output="false"
			hint="Private function that deletes messages in the mailbox according to either a start and end row or a list of UID values.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">
		<cfargument name="startrow" type="numeric" required="false" default="1" hint="This is the index of the first message to retrieve.">
		<cfargument name="UIDList" type="string" required="false" default="" hint="A list of UID values to retrieve specific e-mails.">

		<cfset var UIDArray = "">
		<cfset var UID = "">
		<cfset var attributes = StructNew()>
		<cfset var tmpArray = ArrayNew(1)>

		<cfset checkPOPSettings()>

		<cfset StructInsert(attributes, "server", getProperty("hostname"))>
		<cfset StructInsert(attributes, "port", getProperty("port"))>
		<cfset StructInsert(attributes, "username", getProperty("username"))>
		<cfset StructInsert(attributes, "password", getProperty("password"))>
		<cfset StructInsert(attributes, "timeout", getProperty("timeout"))>
		<cfset StructInsert(attributes, "action", "delete")>

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif arguments.maxrows GTE 1>
				<cfset UIDArray = getUIDList()>
				<cfif ArrayLen(UIDArray) LT arguments.startrow+(arguments.maxrows-1)>
					<cfset arguments.maxrows = ArrayLen(UIDArray)-(arguments.startrow-1)>
				</cfif>
				<cfloop from="#arguments.startrow#" to="#arguments.startrow+(arguments.maxrows-1)#" index="UID">
					<cfset ArrayAppend(tmpArray, UIDArray[UID])>
				</cfloop>
				<cfset arguments.UIDList = ArrayToList(tmpArray, getProperty("separator"))>
			</cfif>
			<cfif arguments.UIDList NEQ "">
				<cfset StructInsert(attributes, "UID", UIDList)>
			</cfif>

			<cfif getProperty("separator") IS ",">
				<cfpop attributeCollection="#attributes#">
			<cfelse>
				<cfset customDelMessagesEx(attributes.UID)>
			</cfif>
		</cflock>

	</cffunction>

	<!--- additional functions that extend CFPOP to perform some of the extra functions CFX_POP3 does --->
	<cffunction name="getUIDList" access="public" returntype="array" output="false"
			hint="Retrieves an array of UID values for the e-mails in a mailbox.">

		<cfset var javaSystem = createObject("java", "java.lang.System")>
		<cfset var javaProps = javaSystem.getProperties()>
		<cfset var javaSession = createObject("java", "javax.mail.Session")>
		<cfset var fp = createObject("java", "javax.mail.FetchProfile")>
		<cfset var fpItem = createObject("java", "javax.mail.UIDFolder$FetchProfileItem")>
		<cfset var pop3Session = "">
		<cfset var store = "">
		<cfset var folder = "">
		<cfset var UIDs = ArrayNew(1)>
		<cfset var mailMsg = 1>
		<cfset var messages = "">

		<cfset checkPOPSettings()>

		<cfset javaProps.setProperty("mail.pop3.port", getProperty("port"))>
		<cfset javaProps.setProperty("mail.pop3.socketFactory.port", getProperty("port"))>
		<cfset javaProps.setProperty("mail.pop3.connectiontimeout", JavaCast("string", getProperty("timeout")*1000))>
		<cfif getProperty("UseSSL")>
			<cfset javaProps.setProperty("mail.pop3.socketFactory.class", "javax.net.ssl.SSLSocketFactory")>
		<cfelse>
			<cfset javaProps.setProperty("mail.pop3.socketFactory.class", "javax.net.SocketFactory") />
		</cfif>

		<cfset pop3Session = javaSession.getDefaultInstance(javaProps)>
		<cfif getProperty("UseSSL")>
			<cfset store = pop3Session.getStore("pop3s")>
		<cfelse>
			<cfset store = pop3Session.getStore("pop3")>
		</cfif>

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cftry>
					<cfset store.connect(getProperty("hostname"),
											getProperty("username"),
											getProperty("password"))>
				<cfcatch>
					<!--- if we're here throw a useful error --->
					<cfthrow message="Unable to connect to #getProperty("hostname")#."
							detail="The most common reason for this is a mis-spelling of one of the arguments.">
				</cfcatch>
			</cftry>
			<cfif store.isConnected()>
				<cftry>
						<!--- for the POP3 protocol the folder is always "INBOX" --->
						<cfset folder = store.getFolder("INBOX")>
						<!--- open the folder --->
						<cfset folder.open(1)>
						<!--- create the message objects --->
						<cfset messages = folder.getMessages()>
						<!--- set up the filter with the FetchProfile, adding the FetchProfileItem of the UID --->
						<cfset fp.add(fpItem.UID)>
						<cfset folder.fetch(messages, fp)>
						<!--- loop through the retrieved message objects and retrieve the UID from the object appending it to the result array --->
						<cfloop from="1" to="#ArrayLen(messages)#" index="mailMsg">
							<cfset ArrayAppend(UIDs, folder.getUID(messages[mailMsg]))>
						</cfloop>
					<cfcatch>
						<!--- if we're here, ignore the error and allow the following code to run thereby closing the socket. --->
					</cfcatch>
				</cftry>
				<!--- close the connection to the POP server --->
				<cfset store.close()>
			<cfelse>
				<cfthrow message="Unable to connect to #getProperty("hostname")#."
						detail="The most common reason for this is a mis-spelling of one of the arguments.">
			</cfif>
		</cflock>

		<cfreturn UIDs>
	</cffunction>

	<cffunction name="getMessageCount" access="public" returntype="numeric" output="false"
			hint="Returns the number of messages in the mailbox.">

		<cfreturn ArrayLen(getUIDlist())>
	</cffunction>

	<cffunction name="hasMail" access="public" returntype="boolean" output="false"
			hint="Tells us if we have mail in the mailbox">

		<cfreturn getMessageCount() GT 0>
	</cffunction>

	<cffunction name="GetRawMessageByIndex" access="public" returntype="array" output="false"
			hint="Retrieves the full raw message. Depends on socket.cfc which only seems to work on non-SSL sockets at the moment.">
		<cfargument name="messagenumbers" type="string" required="true" hint="A list of message numbers to retrieve from the mailbox.">

		<cfset var UIDArray = getUIDList()>
		<cfset var tmpArray = ArrayNew(1)>
		<cfset var result = ArrayNew(1)>
		<cfset var msgNo = "">

		<cfif ListLen(arguments.messageNumbers) GT 0>
			<cfloop list="#arguments.messageNumbers#" index="msgNo">
				<cfif msgNo LTE ArrayLen(UIDArray)>
					<cfset ArrayAppend(tmpArray, UIDArray[msgNo])>
				</cfif>
			</cfloop>
			<cfset result = GetRawMessageByUID(ArrayToList(tmpArray, getProperty("separator")))>
		</cfif>

		<cfreturn result>
	</cffunction>

	<cffunction name="GetRawMessageByUID" access="public" returntype="array" output="false"
			hint="Retrieves the full raw message. Depends on socket.cfc which only seems to work on non-SSL sockets at the moment.">
		<cfargument name="UIDList" type="string" required="true">
		<cfargument name="GetHeaderOnly" type="string" required="false" default="false">

		<cfset var result = ArrayNew(1)>
		<cfset var socket = createObject("component", "socket").init(getProperty("hostname"), getProperty("port"), getProperty("UseSSL"), getProperty("timeout"))>
		<cfset var tmpResult = "">
		<cfset var UID = "">
		<cfset var serverUIDList = getUIDList()>
		<cfset var UIDIndex = 0>
		<cfset var EOM = chr(10)&"."&chr(10)>

		<cfif getProperty("UseSSL")>
			<cfthrow message="GetRawMessageByUID and GetRawMessageByIndex currently operate on non-SSL connections only." detail="If you wish to debug the SSL operations of the socket, please take a look at socket.cfc upon which GetRawMessageByUID depends.">
		</cfif>

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif socket.connect()>
				<cftry>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("USER #getProperty("username")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("PASS #getProperty("password")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfloop list="#arguments.UIDList#" index="UID" delimiters="#getProperty("separator")#">
							<cfset UIDIndex = FindUID(serverUIDList, UID)>
							<cfif UIDIndex GT 0>
								<cfset socket.write("RETR #UIDIndex#")>
								<cfif arguments.GetHeaderOnly>
									<cfset tmpResult = socket.readToEOM("\r?\n\r?\n")>
								<cfelse>
									<cfset tmpResult = socket.readToEOM()>
								</cfif>
								<!--- top and tail the response --->
								<cfset tmpResult = REReplaceNoCase(tmpResult, "\+OK( )?([0-9]* octets)?[\r?\n]+", "", "all")>
								<cfset tmpResult = REReplaceNoCase(tmpResult, "\r\n\.\r\n", "", "ALL")>
								<!--- append the message source to the array --->
								<cfset arrayAppend(result, Trim(tmpResult))>
							</cfif>
						</cfloop>
						<!--- issue a QUIT command to clean up the POP3 connection --->
						<!--- this was missing and spotted by Tom Chiverton --->
						<cfset socket.write("QUIT")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
					<cfcatch>
						<!--- act like a finally and ignore the error so the code afterwards will still run --->
					</cfcatch>
				</cftry>
				<!--- Close the socket --->
				<cfset socket.close()>
			</cfif>
		</cflock>

		<cfreturn result>
	</cffunction>

	<cffunction name="GetRawMessageHeaderByUID" access="public" returntype="array" output="false"
			hint="Retrieves the full raw message. Depends on socket.cfc which only seems to work on non-SSL sockets at the moment.">
		<cfargument name="UIDList" type="string" required="true">

		<cfreturn GetRawMessageByUID(arguments.UIDList, true)>
	</cffunction>

	<cffunction name="Stat" access="public" returntype="struct" output="false"
			hint="Returns the stat values for the account">

		<cfset var socket = createObject("component", "socket").init(getProperty("hostname"), getProperty("port"), getProperty("UseSSL"), getProperty("timeout"))>
		<cfset var tmpResult = "">
		<cfset var result = StructNew()>

		<cfset checkPOPSettings()>

		<cfset StructInsert(result, "msgCount", 0)>
		<cfset StructInsert(result, "mailboxSize", 0)>

		<cfif getProperty("UseSSL")>
			<cfthrow message="Stat currently operate on non-SSL connections only." detail="If you wish to debug the SSL operations of the socket, please take a look at socket.cfc upon which GetRawMessageByUID depends.">
		</cfif>

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif socket.connect()>
				<cftry>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("USER #getProperty("username")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("PASS #getProperty("password")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("STAT")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset StructInsert(result, "msgCount", ListGetAt(tmpResult, 2, " "), true)>
						<cfset StructInsert(result, "mailboxSize", ListGetAt(tmpResult, 3, " "), true)>
						<cfset socket.write("QUIT")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
					<cfcatch>
						<!--- act like a finally and ignore the error so the code afterwards will still run --->
					</cfcatch>
				</cftry>
				<cfset socket.close()>
			</cfif>
		</cflock>

		<cfreturn result>
	</cffunction>

	<cffunction name="List" access="public" returntype="array" output="false"
			hint="Performs a pop3 LIST call with or without a message number.">
		<cfargument name="MessageNumber" type="numeric" required="false">

		<cfset var result = ArrayNew(1)>
		<cfset var socket = createObject("component", "socket").init(getProperty("hostname"), getProperty("port"), getProperty("UseSSL"), getProperty("timeout"))>
		<cfset var tmpResult = "">
		<cfset var EOM = chr(10)&"."&chr(10)>
		<cfset var msgData = "">

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif socket.connect()>
				<cftry>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("USER #getProperty("username")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("PASS #getProperty("password")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfif StructKeyExists(arguments, "MessageNumber")>
							<cfset socket.write("LIST #arguments.MessageNumber#")>
							<cfset tmpResult = checkPOPResponse(socket.read())>
							<cfset tmpResult = Trim(ReplaceNoCase(tmpResult, "+OK ", "", "all"))>
						<cfelse>
							<cfset socket.write("LIST")>
							<cfset tmpResult = socket.readToEOM()>
							<cfset tmpResult = REReplaceNoCase(tmpResult, "\+OK [0-9]+ [0-9]+[\r?\n]+", "", "all")>
							<cfset tmpResult = REReplaceNoCase(tmpResult, "\r\n\.\r\n", "", "ALL")>
						</cfif>
						<cfloop list="#tmpResult#" index="msgData" delimiters="#chr(13)#,#chr(10)#">
							<cfset arrayAppend(result, ListLast(msgData, " "))>
						</cfloop>
						<cfset socket.write("QUIT")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
					<cfcatch>
						<!--- act like a finally and ignore the error so the code afterwards will still run --->
					</cfcatch>
				</cftry>
				<cfset socket.close()>
			</cfif>
		</cflock>

		<cfreturn result>
	</cffunction>

	<cffunction name="ListByUID" access="public" returntype="array" output="false"
			hint="Retrieves the LIST results only for the messages with the UID value passed in.">
		<cfargument name="UID" type="string" required="true" hint="The UID of the mail that was last received. All mails after the one specified will be retrieved.">

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfreturn List(FindUID(getUIDList(), arguments.UID))>
		</cflock>
	</cffunction>

	<cffunction name="customDelMessagesEx" access="private" returntype="void" output="false"
			hint="Deletes a list of e-mails by UID">
		<cfargument name="UIDList" type="string" required="false">

		<cfset var socket = createObject("component", "socket").init(getProperty("hostname"), getProperty("port"), getProperty("UseSSL"), getProperty("timeout"))>
		<cfset var tmpResult = "">
		<cfset var EOM = chr(10)&"."&chr(10)>
		<cfset var UIDArray = getUIDList()>
		<cfset var msgIndex = 0>
		<cfset var UID = "">

		<cflock name="#getProperty("lockhash")#" type="exclusive" timeout="10">
			<cfif socket.connect()>
				<cftry>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("USER #getProperty("username")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfset socket.write("PASS #getProperty("password")#")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
						<cfloop list="#arguments.UIDList#" index="UID" delimiters="#getProperty("separator")#">
							<cfset msgIndex = FindUID(UIDArray, UID)>
							<cfif msgIndex GT 0>
								<cfset socket.write("DELE #msgIndex#")>
								<cfset tmpResult = checkPOPResponse(socket.read())>
								<cfset tmpResult = Trim(ReplaceNoCase(tmpResult, "+OK ", "", "all"))>
							</cfif>
						</cfloop>
						<cfset socket.write("QUIT")>
						<cfset tmpResult = checkPOPResponse(socket.read())>
					<cfcatch>
						<!--- act like a finally and ignore the error so the code afterwards will still run --->
					</cfcatch>
				</cftry>
				<cfset socket.close()>
			</cfif>
		</cflock>

	</cffunction>

	<!--- parse raw headers from a string --->
	<cffunction name="parseRawHeaders" access="public" returntype="query" output="false"
			hint="Reads an array of MIME message header strings places the results into a query">
		<cfargument name="headers" type="array" required="true">

		<cfset var javaProps = createObject("java", "java.util.Properties").init()>
		<cfset var javaSession = createObject("java", "javax.mail.Session")>
		<cfset var pop3Session = javaSession.getDefaultInstance(javaProps)>
		<cfset var msgSource = "">
		<cfset var msgObj = "">
		<cfset var msgDate = "">
		<cfset var i = 0>
		<cfset var fromArray = ArrayNew(1)>
		<cfset var ccArray = ArrayNew(1)>
		<cfset var RecipientArray = "">
		<cfset var ReplyToArray = "">

		<cfset var sender = "">
		<cfset var Recipient = "">
		<cfset var CC = "">
		<cfset var ReplyTo = "">
        <cfset var msgHeader = "">
        <cfset var msgHeaderObj = "">
		<cfset var result = QueryNew("CC,CCEMAILADDRESS,DATE,FROM,FROMEMAILADDRESS,HEADER,MESSAGEID,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TO,TOEMAILADDRESS")>

		<cfloop from="1" to="#ArrayLen(arguments.headers)#" index="i">
			<cfset msgSource = createObject("java", "java.io.ByteArrayInputStream").init(arguments.headers[i].getBytes())>
			<cftry>
			        <cfset msgObj = createObject("java", "javax.mail.internet.MimeMessage").init(pop3Session, msgSource)>

					<cfset msgHeaderObj = msgObj.getAllHeaderLines()>
					<cfloop condition="msgHeaderObj.hasMoreElements()">
						<cfset msgHeader = msgHeader & msgHeaderObj.nextElement() & chr(13)&chr(10)>
					</cfloop>

			        <cfset msgDate =  msgObj.getHeader("Date")>

			        <cfset RecipientArray = msgObj.getHeader("To")>
			        <cfset CCArray = msgObj.getHeader("CC")>
			        <cfset fromArray =  msgObj.getHeader("From")>
			        <cfset ReplyToArray =  msgObj.getHeader("reply-to")>

					<cfif isDefined("RecipientArray")>
						<cfset recipient = ArrayToList(RecipientArray)>
					</cfif>
					<cfif isDefined("CCArray")>
						<cfset CC = ArrayToList(CCArray)>
					</cfif>
					<cfif isDefined("fromArray")>
						<cfset sender = ArrayToList(fromArray)>
					</cfif>
					<cfif isDefined("ReplyToArray")>
						<cfset ReplyTo = ArrayToList(ReplyToArray)>
					</cfif>

					<cfset QueryAddRow(result)>
					<cfset QuerySetCell(result, "HEADER", msgHeader)>
					<cfset QuerySetCell(result, "TO", Recipient)>
					<cfset QuerySetCell(result, "FROM", sender)>

					<cfset QuerySetCell(result, "TO", Recipient)>
					<cfset QuerySetCell(result, "TOEMAILADDRESS", ExtractAddresses(Recipient))>
					<cfset QuerySetCell(result, "CC", CC)>
					<cfset QuerySetCell(result, "CCEMAILADDRESS", ExtractAddresses(CC))>
					<cfset QuerySetCell(result, "FROM", sender)>
					<cfset QuerySetCell(result, "FROMEMAILADDRESS", ExtractAddresses(sender))>
					<cfset QuerySetCell(result, "REPLYTO", ReplyTo)>
					<cfset QuerySetCell(result, "REPLYTOEMAILADDRESS", ExtractAddresses(ReplyTo))>

					<cfset QuerySetCell(result, "SUBJECT", msgObj.getSubject())>
					<cfset QuerySetCell(result, "MESSAGEID", msgObj.getMessageID())>
					<cfif isDefined("msgDate")>
						<cfset QuerySetCell(result, "DATE", msgDate[1])>
					<cfelse>
						<cfset QuerySetCell(result, "DATE", Now())>
					</cfif>
				<cfcatch>
					<cfdump var="#cfcatch#"><cfabort>
				</cfcatch>
			</cftry>
			<cfset msgSource.close()>
		</cfloop>

		<cfreturn result>
	</cffunction>

	<!--- parses an e-mail from a string --->
	<cffunction name="parseRawMessage" access="public" returntype="query" output="false"
			hint="Reads an e-mail from a file and places the results into a query">
		<cfargument name="eml" type="array" required="true">

		<cfset var javaProps = createObject("java", "java.util.Properties").init()>
		<cfset var javaSession = createObject("java", "javax.mail.Session")>
		<cfset var pop3Session = javaSession.getDefaultInstance(javaProps)>
		<cfset var msgSource = "">
		<cfset var msgObj = "">
		<cfset var msgDate = "">
		<cfset var e = 0>
		<cfset var i = 0>
		<cfset var fromArray = ArrayNew(1)>
		<cfset var ccArray = ArrayNew(1)>
		<cfset var RecipientArray = "">
		<cfset var ReplyToArray = "">
		<cfset var pos = "">

		<cfset var sender = "">
		<cfset var Recipient = "">
		<cfset var CC = "">
		<cfset var ReplyTo = "">
        <cfset var msgHeader = "">
        <cfset var msgHeaderObj = "">
		<cfset var result = QueryNew("BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS")>

		<cfif getProperty("attachmentPath") NEQ "">
			<cfset QueryAddColumn(result, "ATTACHMENTS", "VarChar", ArrayNew(1))>
			<cfset QueryAddColumn(result, "ATTACHMENTFILES", "VarChar", ArrayNew(1))>
		</cfif>

		<cfloop from="1" to="#ArrayLen(arguments.eml)#" index="e">
			<cfset msgHeader = "">
			<cfset msgSource = createObject("java", "java.io.ByteArrayInputStream").init(arguments.eml[e].getBytes())>
			<cftry>
			        <cfset msgObj = createObject("java", "javax.mail.internet.MimeMessage").init(pop3Session, msgSource)>

					<cfset msgHeaderObj = msgObj.getAllHeaderLines()>
					<cfloop condition="msgHeaderObj.hasMoreElements()">
						<cfset msgHeader = msgHeader & msgHeaderObj.nextElement() & chr(13)&chr(10)>
					</cfloop>

			        <cfset msgDate =  msgObj.getHeader("Date")>

			        <cfset RecipientArray = msgObj.getHeader("To")>
			        <cfset CCArray = msgObj.getHeader("CC")>
			        <cfset fromArray =  msgObj.getHeader("From")>
			        <cfset ReplyToArray =  msgObj.getHeader("reply-to")>

					<cfset Recipient = "">
					<cfset CC = "">
					<cfset sender = "">
					<cfset ReplyTo = "">

					<cfif isDefined("RecipientArray")>
						<cfset recipient = ArrayToList(RecipientArray)>
					</cfif>
					<cfif isDefined("CCArray")>
						<cfset CC = ArrayToList(CCArray)>
					</cfif>
					<cfif isDefined("fromArray")>
						<cfset sender = ArrayToList(fromArray)>
					</cfif>
					<cfif isDefined("ReplyToArray")>
						<cfset ReplyTo = ArrayToList(ReplyToArray)>
					</cfif>

					<cfset QueryAddRow(result)>
					<cfset QuerySetCell(result, "HEADER", msgHeader)>

					<cfset QuerySetCell(result, "TO", Recipient)>
					<cfset QuerySetCell(result, "TOEMAILADDRESS", ExtractAddresses(Recipient))>
					<cfset QuerySetCell(result, "CC", CC)>
					<cfset QuerySetCell(result, "CCEMAILADDRESS", ExtractAddresses(CC))>
					<cfset QuerySetCell(result, "FROM", sender)>
					<cfset QuerySetCell(result, "FROMEMAILADDRESS", ExtractAddresses(sender))>
					<cfset QuerySetCell(result, "REPLYTO", ReplyTo)>
					<cfset QuerySetCell(result, "REPLYTOEMAILADDRESS", ExtractAddresses(ReplyTo))>

					<cfset QuerySetCell(result, "SUBJECT", msgObj.getSubject())>
					<cfset QuerySetCell(result, "MESSAGEID", msgObj.getMessageID())>
					<cfif isDefined("msgDate")>
						<cfset QuerySetCell(result, "DATE", msgDate[1])>
					<cfelse>
						<cfset QuerySetCell(result, "DATE", Now())>
					</cfif>

					<cfif ListFirst(msgObj.getContentType(), ";") contains "multipart/">
						<cfloop from="0" to="#msgObj.getContent().getCount()-1#" index="i">
							<cfset result = parseBodyPart(msgObj.getContent().getBodyPart(i), result)>
						</cfloop>
					<cfelseif ListFirst(msgObj.getContentType(), ";") contains "text/plain">
						<cftry>
								<cfset QuerySetCell(result, "TEXTBODY", msgObj.getContent())>
							<cfcatch>
								<cfset QuerySetCell(result, "TEXTBODY", cfcatch.Type & " " & cfcatch.Message)>
							</cfcatch>
						</cftry>
					<cfelseif ListFirst(msgObj.getContentType(), ";") contains "text/html">
						<!--- thanks to Tom Chiverton for raising this piece of code as being missing --->
						<cftry>
								<cfset QuerySetCell(result, "HTMLBODY", msgObj.getContent())>
							<cfcatch>
								<cfset QuerySetCell(result, "HTMLBODY", cfcatch.Type & " " & cfcatch.Message)>
							</cfcatch>
						</cftry>
					<cfelseif not(getProperty("processRFC822asAttachment")) AND
							ListFirst(msgObj.getContentType(), ";") contains "message/rfc822">
						<!--- we want to process an embedded rfc822 message as if it were the original email --->
						<!--- start again with first blank line --->
						<cfset pos = find(chr(13)&chr(10)&chr(13)&chr(10), arguments.eml[e])/>
						<cfset result = parseRawMessage(mid(arguments.eml[e], pos+4, len(arguments.eml[e])), result)>
					</cfif>
					<cfif result.TEXTBODY[result.recordcount] NEQ "">
						<cfset QuerySetCell(result, "BODY", result.TEXTBODY[result.recordcount])>
					<cfelseif result.HTMLBODY[result.recordcount] NEQ "">
						<cfset QuerySetCell(result, "BODY", result.HTMLBODY[result.recordcount])>
					<cfelse>
						<cfset QuerySetCell(result, "BODY", "")>
					</cfif>

					<cfif not IsStruct(result.CIDS[result.recordcount])>
						<cfset result.CIDS[result.recordcount] = StructNew()>
					</cfif>
				<cfcatch>
					<!--- catch any error and let the code continue on like a finally ensuring the .close() is called --->
					<!--- USE cffinally in CF9 --->
				</cfcatch>
			</cftry>
			<cfset msgSource.close()>
		</cfloop>

		<cfreturn result>
	</cffunction>

	<cffunction name="parseBodyPart" access="private" returntype="query" output="false"
			hint="Parses a specific body part recursively thereby handling multi-nested body parts.">
		<cfargument name="bodyPart" type="any" required="true">
		<cfargument name="result" type="query" required="true">

		<cfset var j = 0>
        <cfset var attachments = "">
        <cfset var attachmentfiles = "">
		<cfset var contentType = "">
		<cfset var filename = "">
		<cfset var saveFilename = "">
		<cfset var outputStream = "">
		<cfset var fileOutputStream = "">
		<cfset var bodyPartInputStream = "">
		<cfset var CIDs = StructNew()>
		<cfset var ContentID = "">
		<cfset var utfString = "">
		<cfset var header = "">
		<cfset var hdr = "">
		<cfset var tmpFileData = "">

		<cfset contentType = arguments.bodyPart.getHeader("Content-Type")>
		<cfset filename = arguments.bodyPart.getFilename()>
		<cfif IsDefined("filename") and
				getProperty("attachmentPath") NEQ "">
			<cfset ContentID = arguments.bodyPart.getContentID()>
			<cfif IsDefined("ContentID")>
				<cfset StructInsert(CIDs, filename, ContentID, true)>
			</cfif>
			<cfset saveFilename = getProperty("attachmentPath")&filename>
			<cfif getProperty("generateUniqueFilenames")>
				<cfloop condition="fileExists(saveFilename)">
					<cfset saveFilename = getProperty("attachmentPath")&CreateUUID()&"."&ListLast(filename, ".")>
				</cfloop>
			</cfif>
			<cfset attachments = listAppend(attachments, filename, chr(9))>
			<cfset attachmentfiles = listAppend(attachmentfiles, saveFilename, chr(9))>
			<cfset outputStream = createObject("java", "java.io.BufferedOutputStream")>
			<cfset fileOutputStream = createObject("java", "java.io.FileOutputStream")>
			<cfset fileOutputStream.init(saveFilename)>
			<cfset outputStream.init(fileOutputStream)>
			<!--- Altered this code to fix a bug reported by Hadyn Cotton --->
			<cftry>
					<cfset bodyPartInputStream = arguments.bodyPart.getContent()>
					<cfloop condition="bodyPartInputStream.available() GT -1">
						<cfset tmpFileData = bodyPartInputStream.read()>
						<!--- if the FileData read in is "-1" then it's the end of the file and we don't want to write it out... --->
						<cfif tmpFileData NEQ -1>
							<cfset outputStream.write(tmpFileData)>
						</cfif>
					</cfloop>
				<cfcatch>
					<!--- For CF8 and below we need to catch and ignore this error so we can close the streams --->
					<!--- For CF9 we should use a finally block to force the .close() calls --->
				</cfcatch>
			</cftry>
			<cfset outputStream.close()>
			<cfset fileOutputStream.close()>
			<cfif getProperty("attachmentPath") NEQ "">
				<cfset QuerySetCell(arguments.result, "ATTACHMENTS", arguments.result.ATTACHMENTS[arguments.result.recordcount] & chr(9) & attachments)>
				<cfset QuerySetCell(arguments.result, "ATTACHMENTFILES", arguments.result.ATTACHMENTFILES[arguments.result.recordcount] & chr(9) & attachmentfiles)>
			</cfif>
			<cfif IsStruct(arguments.result.CIDS[arguments.result.recordcount])>
				<cfset StructAppend(arguments.result.CIDS[arguments.result.recordcount], CIDs)>
			<cfelse>
				<cfset QuerySetCell(arguments.result, "CIDS", CIDs)>
			</cfif>
		<cfelseif ListFirst(arguments.bodyPart.getContentType(), ";") contains "multipart/">
			<!--- for any multipart body part, go through each part and parse it recursively --->
			<cfloop from="0" to="#arguments.bodyPart.getContent().getCount()-1#" index="j">
				<cfset arguments.result = parseBodyPart(arguments.bodyPart.getContent().getBodyPart(j), arguments.result)>
			</cfloop>
		<cfelse>
			<!--- eventually, we'll end up with a text/plain or text/html body part which we can use --->
			<cfif not isDefined("contentType") OR
					ListFirst(contentType[1], ";") IS "text/plain">
				<cftry>
						<cfset QuerySetCell(arguments.result, "TEXTBODY", arguments.bodyPart.getContent())>
					<cfcatch>
						<cfset QuerySetCell(arguments.result, "TEXTBODY", cfcatch.Type & " " & cfcatch.Message)>
					</cfcatch>
				</cftry>
			<cfelseif ListFirst(contentType[1], ";") IS "message/delivery-status" and
						arguments.bodyPart.getContent().toString() contains "SharedByteArrayInputStream">
				<!--- thanks to Tom Chiverton for providing this code --->
				<cftry>
						<cfset utfString = "">
						<cfloop list="Reporting-MTA,Received-From-MTA,Action,Status,Final-Recipient" index="header">
							<cfset hdr = arguments.bodyPart.getHeader(header, javaCast("null", ""))>
							<cfif isDefined("hdr")>
								<cfset utfString = utfString & chr(10) & chr(13) & header & ": " & hdr.toString()>
							</cfif>
						</cfloop>
	            		<cfset utfString = utfString & createObject("java", "java.util.Scanner").init(arguments.bodyPart.getContent(), "UTF-8").useDelimiter("\\A").next()><!--- stuff after the headers--->

						<cfset QuerySetCell(arguments.result, "TEXTBODY", arguments.result.TEXTBODY & utfString)>
					<cfcatch>
						<cfset QuerySetCell(arguments.result, "TEXTBODY", cfcatch.Type & " " & cfcatch.Message)>
					</cfcatch>
				</cftry>
			<cfelseif ListFirst(contentType[1], ";") IS "text/html">
				<cftry>
						<cfset QuerySetCell(arguments.result, "HTMLBODY", arguments.bodyPart.getContent())>
					<cfcatch>
						<cfset QuerySetCell(arguments.result, "HTMLBODY", cfcatch.Type & " " & cfcatch.Message)>
					</cfcatch>
				</cftry>
			</cfif>
		</cfif>

		<cfreturn arguments.result>
	</cffunction>

	<!--- load an e-mail from a file and parse it --->
	<cffunction name="loadFromFile" access="public" returntype="query" output="false"
			hint="Reads an e-mail from a file and places the results into a query">
		<cfargument name="emlFile" type="string" required="true">

		<cfset var result = QueryNew("BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS")>
		<cfset var emlSrc = "">
		<cfset var eml = ArrayNew(1)>

		<cfif FileExists(arguments.emlFile)>
			<cffile action="read" file="#arguments.emlFile#" variable="emlSrc">
			<cfset ArrayAppend(eml, emlSrc)>
			<cfset result = parseRawMessage(eml)>
		</cfif>

		<cfreturn result>
	</cffunction>

	<!--- wrapper functions that wrap standard functions of CFPOP --->
	<cffunction name="getMessages" access="public" returntype="query" output="false"
			hint="Gets the messages from the POP server">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">
		<cfargument name="startrow" type="numeric" required="false" default="1" hint="This is the index of the first message to retrieve.">
		<cfargument name="UIDList" type="string" required="false" hint="A list of UID values to retrieve specific e-mails.">

		<cfset arguments.action = "getAll">

		<cfreturn getMessagesEx(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="getMessagesByIndex" access="public" returntype="query" output="false"
			hint="Retrieves messages by index">
		<cfargument name="messagenumbers" type="string" required="true" hint="A list of message numbers for the mailbox to retrieve.">

		<cfset var UIDArray = getUIDList()>
		<cfset var tmpArray = ArrayNew(1)>
		<cfset var msgNo = "">

		<cfif ListLen(arguments.messageNumbers) GT 0>
			<cfloop list="#arguments.messageNumbers#" index="msgNo">
				<cfif msgNo LTE ArrayLen(UIDArray)>
					<cfset ArrayAppend(tmpArray, UIDArray[msgNo])>
				</cfif>
			</cfloop>

			<cfreturn getMessagesByUID(ArrayToList(tmpArray, getProperty("separator")))>
		</cfif>

		<cfreturn QueryNew("ATTACHMENTFILES,ATTACHMENTS,BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,MESSAGENUMBER,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS,UID")>
	</cffunction>

	<cffunction name="getMessagesByUID" access="public" returntype="query" output="false"
			hint="Retrieves messages by UID only">
		<cfargument name="UIDList" type="string" required="true" hint="A list of UID values to retrieve specific e-mails.">

		<cfreturn getMessages(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="getMessagesAfterUID" access="public" returntype="query" output="false"
			hint="Retrieves only the messages received after the message with the UID value passed in.">
		<cfargument name="UID" type="string" required="true" hint="The UID of the mail that was last received. All mails after the one specified will be retrieved.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">

		<cfset var UIDList = getUIDList()>
		<cfset var lastMessageIndex = FindUID(UIDList, arguments.UID)>

		<cfif lastMessageIndex IS ArrayLen(UIDList)>
			<!--- if the UID passed in is the last one in the list then there are no messages after that UID... --->
			<cfreturn QueryNew("ATTACHMENTFILES,ATTACHMENTS,BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,MESSAGENUMBER,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS,UID")>
		<cfelse>
			<cfreturn getMessages(maxrows=arguments.maxrows,startrow=lastMessageIndex+1)>
		</cfif>
	</cffunction>

	<cffunction name="getMessageHeaders" access="public" returntype="query" output="false"
			hint="Gets the message headers from the POP server.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">
		<cfargument name="startrow" type="numeric" required="false" default="1" hint="This is the index of the first message to retrieve.">
		<cfargument name="UIDList" type="string" required="false" hint="A list of UID values to retrieve specific e-mails.">

		<cfset arguments.action = "getHeaderOnly">

		<cfreturn getMessagesEx(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="getMessageHeadersByIndex" access="public" returntype="query" output="false"
			hint="Retrieves the messages by their message number. Internally converts to UIDs and retrieves messages by UID.">
		<cfargument name="messagenumbers" type="string" required="true" hint="A list of message numbers for the mailbox to retrieve.">

		<cfset var UIDArray = getUIDList()>
		<cfset var tmpArray = ArrayNew(1)>
		<cfset var msgNo = "">

		<cfif ListLen(arguments.messageNumbers) GT 0>
			<cfloop list="#arguments.messageNumbers#" index="msgNo">
				<cfif msgNo LTE ArrayLen(UIDArray)>
					<cfset ArrayAppend(tmpArray, UIDArray[msgNo])>
				</cfif>
			</cfloop>

			<cfreturn getMessageHeadersByUID(ArrayToList(tmpArray, getProperty("separator")))>
		</cfif>

		<cfreturn QueryNew("ATTACHMENTFILES,ATTACHMENTS,BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,MESSAGENUMBER,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS,UID")>
	</cffunction>

	<cffunction name="getMessageHeadersByUID" access="public" returntype="query" output="false"
			hint="Retrieves message headers for the mails that match the list of UIDs.">
		<cfargument name="UIDList" type="string" required="false" hint="A list of UID values to retrieve specific e-mails.">

		<cfreturn getMessageHeaders(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="getMessageHeadersAfterUID" access="public" returntype="query" output="false"
			hint="Retrieves only the message headers received after the message with the UID value passed in.">
		<cfargument name="UID" type="string" required="true" hint="The UID of the mail that was last received. All mails after the one specified will be retrieved.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">

		<cfset var UIDList = getUIDList()>
		<cfset var lastMessageIndex = FindUID(UIDList, arguments.UID)>

		<cfif lastMessageIndex IS ArrayLen(UIDList)>
			<!--- if the UID passed in is the last one in the list then there are no messages after that UID... --->
			<cfreturn QueryNew("ATTACHMENTFILES,ATTACHMENTS,BODY,CC,CCEMAILADDRESS,CIDS,DATE,FROM,FROMEMAILADDRESS,HEADER,HTMLBODY,MESSAGEID,MESSAGENUMBER,REPLYTO,REPLYTOEMAILADDRESS,SUBJECT,TEXTBODY,TO,TOEMAILADDRESS,UID")>
		<cfelse>
			<cfreturn getMessageHeaders(maxrows=arguments.maxrows,startrow=lastMessageIndex+1)>
		</cfif>
	</cffunction>

	<cffunction name="deleteMessages" access="public" returntype="void" output="false"
			hint="Deletes a set of messages from the POP account. Startrow and Maxrows values are optional.">
		<cfargument name="maxrows" type="numeric" required="false" default="-1" hint="Return no more than maxrows messages.">
		<cfargument name="startrow" type="numeric" required="false" default="1" hint="This is the index of the first message to retrieve.">

		<cfreturn deleteMessagesEx(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="deleteMessagesByIndex" access="public" returntype="void" output="false"
			hint="Deletes messages by their message number. Internally converts the message number to UID and then deletes by UID.">
		<cfargument name="messagenumbers" type="string" required="true" hint="A list of message numbers to delete from the mailbox.">

		<cfset var UIDArray = getUIDList()>
		<cfset var tmpArray = ArrayNew(1)>
		<cfset var msgNo = "">

		<cfif ListLen(arguments.messageNumbers) GT 0>
			<cfloop list="#arguments.messageNumbers#" index="msgNo">
				<cfif msgNo LTE ArrayLen(UIDArray)>
					<cfset ArrayAppend(tmpArray, UIDArray[msgNo])>
				</cfif>
			</cfloop>
			<cfset deleteMessagesByUID(ArrayToList(tmpArray, getProperty("separator")))>
		</cfif>

	</cffunction>

	<cffunction name="deleteMessagesByUID" access="public" returntype="void" output="false"
			hint="Deletes a set of messages as specified by a list of UID values.">
		<cfargument name="UIDList" type="string" required="true" hint="A list of UID values to delete specific e-mails.">

		<cfreturn deleteMessagesEx(argumentCollection=arguments)>
	</cffunction>

	<!--- support functions --->
	<cffunction name="ExtractAddresses" access="private" returntype="string" output="false"
			hint="Extracts e-mail addresses from a string returning them as a list.">
		<cfargument name="sourceString" type="string" required="true">

		<cfset var emailaddresses = ArrayNew(1)>
		<cfset var currentpos = 0>
		<cfset var addressDetails = REFindNoCase(getProperty("emailRegEx"), arguments.sourceString, currentPos, True)>

		<cfloop condition="addressDetails.Pos[1] GT 0">
			<cfset ArrayAppend(emailAddresses, Mid(arguments.sourceString, addressDetails.pos[1], addressDetails.Len[1]))>
			<cfset currentpos = (addressDetails.pos[1] + addressDetails.Len[1])>
			<cfset addressDetails = REFindNoCase(getProperty("emailRegEx"), arguments.sourceString, currentPos, True)>
		</cfloop>

		<cfreturn ArrayToList(emailaddresses)>
	</cffunction>

	<!--- FindUID could be replaced by ArrayFind in CF9 but to work in previous versions of CF, FindUID is used --->
	<cffunction  name="FindUID" access="public" returntype="numeric" output="false"
			hint="Finds a value in an array and returns the index. Returns zero if there is no match.">
		<cfargument name="UIDList" type="array" required="true" hint="The 1-dimensional array containing a list of UID values">
		<cfargument name="UID" type="string" required="true" hint="The UID value to find the index of.">

		<cfset var i = 1>

		<cfloop from="1" to="#ArrayLen(arguments.UIDList)#" index="i">
			<cfif not Compare(arguments.UIDList[i], arguments.UID)>
				<cfreturn i>
			</cfif>
		</cfloop>

		<cfreturn 0>
	</cffunction>

	<cffunction name="checkPOPSettings" access="private" returntype="void" output="false"
			hint="Checks to see if the minimum settings are set and throws and error if not">

		<cfif getProperty("hostname") IS "">
			<cfthrow message="Attribute error" detail="The POP3 hostname is required for this operation.">
		</cfif>
		<cfif getProperty("username") IS "">
			<cfthrow message="Attribute error" detail="The POP3 account username is required for this operation.">
		</cfif>
		<cfif getProperty("password") IS "">
			<cfthrow message="Attribute error" detail="The POP3 account password is required for this operation.">
		</cfif>
	</cffunction>

	<cffunction name="checkPOPResponse" access="private" returntype="string" output="false"
			hint="Checks the POP response and returns either the response string if +OK or throws an error halting the process.">
		<cfargument name="POPresponse" type="string" required="true">

		<cfif arguments.POPresponse contains "-ERR">
			<cfthrow message="POP error" detail="The POP server responded with the message: #arguments.POPresponse#.">
		</cfif>

		<cfreturn arguments.POPresponse>
	</cffunction>

	<cffunction name="decodeString" access="public" returntype="any" output="false"
			hint="Attempts to convert a base 64 or quoted-printable encoded string that has a specific charset into the UTF-8 plain text equivalent.">
		<cfargument name="encodedString" type="string" required="true">
		<cfargument name="targetCharset" type="string" required="false" default="UTF-8">

		<cfset var stringParts = REFindNoCase("=\?([a-z0-9\-]*)\?([B|Q])\?([a-z0-9/+=]*)\?=", arguments.encodedString, 1, true)>
		<cfset var charset = "">
		<cfset var stringToDecode = "">
		<cfset var encType = "">
		<cfset var i = 1>
		<cfset var result = "">
		<cfset var decodedCharset = "">
		<cfset var charsetObj = createObject("java", "java.nio.charset.Charset")>

		<cfif ArrayLen(stringParts.pos) IS 4>
			<cfset charset = Mid(arguments.encodedString, stringParts.Pos[2], stringParts.Len[2])>
			<cfset encType = Mid(arguments.encodedString, stringParts.Pos[3], stringParts.Len[3])>
			<cfset stringToDecode = Mid(arguments.encodedString, stringParts.Pos[4], stringParts.Len[4])>


			<cfif charsetObj.isSupported(JavaCast("string", charset))>
				<cfif encType IS "B"> <!--- base 64 --->
					<cfset stringToDecode = toString(toBinary(stringToDecode), charset)>
				<cfelseif encType IS "Q"> <!--- Quoted-Printable --->
					<cfset stringToDecode = parseQuotedPrintable(stringToDecode)>
				</cfif>
				<cfset decodedCharset = CharsetDecode(stringToDecode, charset)>
				<cfset result = CharsetEncode(decodedCharset, arguments.targetCharset)>
			<cfelse>
				<cfset result = stringToDecode>
			</cfif>
		<cfelse>
			<cfset result = arguments.encodedString>
		</cfif>

		<cfreturn ReReplaceNoCase(arguments.encodedString, "=\?([a-z0-9\-]*)\?([B|Q])\?([a-z0-9/+=]*)\?=", result)>
	</cffunction>

	<cffunction name="parseQuotedPrintable" access="private" returntype="any" output="false"
			hint="Takes a string and parses it for Quoted-Printable encodings and returns a decoded string.">
		<cfargument name="qpString" type="string" required="true">

		<cfset var result = arguments.qpString>
		<cfset var qpPos = REFindNoCase("=[0-9]{2}", result, 1, true)>
		<cfset var qpChar = "">
		<cfset var char = "">

		<cfloop condition="qpPos.Pos[1] GT 0">
			<cfset qpChar = Replace(Mid(result,qpPos.Pos[1], qpPos.Len[1]), "=", "")>
			<cfset Char = Chr(InputBaseN(qpChar, 16))>

			<cfset result = ReplaceNoCase(result, "=#qpChar#", char, "ALL")>

			<cfset qpPos = REFindNoCase("=[0-9]{2}", result, 1, true)>
		</cfloop>

		<cfreturn result>
	</cffunction>

	<cffunction name="parseRFCDateToCFDate" access="public" returntype="any" output="false"
			hint="Takes an RFC string and parses it to a date, returning a blank string is the date format is unrecognised.">
		<cfargument name="RFCDateString" type="string" required="true">

		<cfset var i = 1>
		<cfset var dateParser = createObject("java", "java.text.SimpleDateFormat")>
		<cfset var theDate = "">
		<cfset var dateFormats = getProperty("dateFormats")>

		<cfloop from="1" to="#ArrayLen(dateFormats)#" index="i">
			<cftry>
					<cfset dateParser.applyPattern(dateFormats[i])>
					<cfset theDate = dateParser.parse(arguments.RFCDateString)>
					<cfif IsDate(theDate)>
						<cfreturn theDate>
					</cfif>
				<cfcatch>
					<!--- If we're here then the pattern used to parse the date was incorrect, try another one... --->
				</cfcatch>
			</cftry>
		</cfloop>

		<cfreturn "">
	</cffunction>

</cfcomponent>