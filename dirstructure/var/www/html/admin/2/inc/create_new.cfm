<cfif NOT StructKeyExists(url, "type")>
    <cfset m=6>
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    <cfelseif StructKeyExists(url, "type")>
    <cfif #url.type# is "">
    <cfset m=6>
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    <cfelseif #url.type# is not "">
    <cfset theType = #url.type#>
    </cfif>
    </cfif>

<cfif #theType# is "adconnection">

  <cfquery name="insertconnection" datasource="hermes" result="stResult">
    insert into ad_integration
    (entry_name, objectclass)
    values 
    ('', 'user')
    </cfquery>  



<cfoutput>
<cflocation url="../edit_ad_connection.cfm?id=#stResult.GENERATED_KEY#" addtoken="no">
</cfoutput>




<!--- /CFIF #thetype# is --->
</cfif>