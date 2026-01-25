<!---LICENSE CHECK BELOW --->
<cfif StructKeyExists(session, "license")>
    <cfif #session.license# is "VIOLATION">
    
    <cfinclude template="license_invalid.cfm">
    <cfabort>
    
    <cfelseif #session.license# is "N/A">
    
<cfinclude template="license_invalid.cfm">
<cfabort>

<!--- /CFIF #session.license# is  --->
</cfif>

<!--- /CFIF StructKeyExists(session, "license")> --->
</cfif>

<!---LICENSE CHECK ABOVE --->