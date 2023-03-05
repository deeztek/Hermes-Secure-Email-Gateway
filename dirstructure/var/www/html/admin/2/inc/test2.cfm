<cfif StructKeyExists(url, "dev")>

    <cfif IsValid("integer", #url.dev#)>
    
    <cfif url.dev is "1">    
    
    <cfset dev = 1>
    
    <cfelse>
    
    <cfset dev = 0>
    
    <!--- /CFIF url.dev is  --->
    </cfif>

</cfif>

</cfif>

    <cfoutput>
        DEV: #dev#
    </cfoutput>