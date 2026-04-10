
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GET MAILBOX FOLDERS - AJAX endpoint
Returns the list of mailbox folders for the logged-in user as JSON.
Used by the user mail filters modal to populate the folder dropdown.
--->

<cfif NOT StructKeyExists(session, "email") OR session.email EQ "">
    <cfoutput>{"error": "Not logged in"}</cfoutput>
    <cfabort>
</cfif>

<!--- Only mailbox users have folders --->
<cfif NOT session.theGroups CONTAINS "mailboxes">
    <cfoutput>{"error": "Not a mailbox user"}</cfoutput>
    <cfabort>
</cfif>

<cfset folders = []>

<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot doveadm mailbox list -u #session.email#"
        variable="folderOutput"
        errorVariable="folderError"
        timeout="30" />

    <cfif isDefined("folderOutput") AND folderOutput NEQ "">
        <cfloop list="#folderOutput#" index="folder" delimiters="#Chr(10)#">
            <cfset folder = trim(folder)>
            <cfif folder NEQ "">
                <cfset ArrayAppend(folders, folder)>
            </cfif>
        </cfloop>
    </cfif>
<cfcatch type="any">
    <!--- doveadm failed - return empty list --->
</cfcatch>
</cftry>

<!--- Sort alphabetically --->
<cfset ArraySort(folders, "textnocase")>

<cfset jsonFolders = []>
<cfloop array="#folders#" index="folder">
    <cfset ArrayAppend(jsonFolders, '"' & JSStringFormat(folder) & '"')>
</cfloop>

<cfoutput>{"folders": [#ArrayToList(jsonFolders, ",")#]}</cfoutput>
<cfabort>
