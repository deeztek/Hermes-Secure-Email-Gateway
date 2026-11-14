
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

SIEVE HELPERS - Shared functions for building sieve condition/action strings
from database rows. Used by both global and user generators.
--->

<cffunction name="sieveEscape" returntype="string" output="false">
    <cfargument name="val" type="string" required="true">
    <!--- Escape backslashes and double quotes for sieve string literals --->
    <cfset var s = Replace(arguments.val, "\", "\\", "all")>
    <cfset s = Replace(s, '"', '\"', "all")>
    <cfreturn s>
</cffunction>

<!--- SECURITY: text placed in a "# ..." comment line. A line break would end
     the comment and turn the rest into live Sieve, so every control character
     (CR, LF, tab, NUL...) becomes a space. --->
<cffunction name="sieveComment" returntype="string" output="false">
    <cfargument name="val" type="string" required="true">
    <cfreturn Trim(REReplace(arguments.val, "[[:cntrl:]]", " ", "all"))>
</cffunction>

<cffunction name="buildSieveCondition" returntype="string" output="false">
    <cfargument name="cfield" type="string" required="true">
    <cfargument name="ctype" type="string" required="true">
    <cfargument name="cvalue" type="string" required="true">

    <cfset var headerName = "">
    <cfset var headerValue = "">
    <cfset var v = sieveEscape(arguments.cvalue)>

    <cfif arguments.cfield EQ "header">
        <!--- Split on the FIRST colon only - header values can contain colons
             (e.g. "X-Custom: foo:bar"). ListFirst/ListRest would lose "bar". --->
        <cfset var colonPos = Find(":", arguments.cvalue)>
        <cfif colonPos EQ 0>
            <cfreturn "">
        </cfif>
        <cfset headerName = trim(Left(arguments.cvalue, colonPos - 1))>
        <!--- SECURITY: the header name is printed inside quotes; only a valid
             header field name (letters, digits, hyphen) is accepted --->
        <cfif REFind("^[A-Za-z0-9-]{1,76}$", headerName) EQ 0>
            <cfreturn "">
        </cfif>
        <cfset headerValue = sieveEscape(trim(Mid(arguments.cvalue, colonPos + 1, Len(arguments.cvalue))))>
        <cfif arguments.ctype EQ "is">
            <cfreturn 'header :is "#headerName#" "#headerValue#"'>
        <cfelseif arguments.ctype EQ "contains">
            <cfreturn 'header :contains "#headerName#" "#headerValue#"'>
        <cfelseif arguments.ctype EQ "matches">
            <cfreturn 'header :matches "#headerName#" "#headerValue#"'>
        <cfelseif arguments.ctype EQ "not_contains">
            <cfreturn 'not header :contains "#headerName#" "#headerValue#"'>
        </cfif>
    <cfelseif ListFindNoCase("from,to,cc,bcc", arguments.cfield)>
        <!--- Address fields: use sieve "address" test which extracts just the
             email address (ignores display name and angle brackets), unlike
             "header" which compares the entire raw header value. --->
        <cfset headerName = UCase(Left(arguments.cfield, 1)) & LCase(Mid(arguments.cfield, 2, Len(arguments.cfield)))>
        <cfif arguments.ctype EQ "is">
            <cfreturn 'address :is "#headerName#" "#v#"'>
        <cfelseif arguments.ctype EQ "contains">
            <cfreturn 'address :contains "#headerName#" "#v#"'>
        <cfelseif arguments.ctype EQ "matches">
            <cfreturn 'address :matches "#headerName#" "#v#"'>
        <cfelseif arguments.ctype EQ "not_contains">
            <cfreturn 'not address :contains "#headerName#" "#v#"'>
        </cfif>
    <cfelseif arguments.cfield EQ "subject">
        <cfif arguments.ctype EQ "is">
            <cfreturn 'header :is "Subject" "#v#"'>
        <cfelseif arguments.ctype EQ "contains">
            <cfreturn 'header :contains "Subject" "#v#"'>
        <cfelseif arguments.ctype EQ "matches">
            <cfreturn 'header :matches "Subject" "#v#"'>
        <cfelseif arguments.ctype EQ "not_contains">
            <cfreturn 'not header :contains "Subject" "#v#"'>
        </cfif>
    <cfelseif arguments.cfield EQ "size">
        <!--- SECURITY: printed bare, so only a number with an optional
             K / M / G quantifier (RFC 5228) is accepted --->
        <cfset var sizeVal = UCase(Trim(arguments.cvalue))>
        <cfif REFind("^[0-9]{1,12}[KMG]?$", sizeVal) EQ 0>
            <cfreturn "">
        </cfif>
        <cfif arguments.ctype EQ "over">
            <cfreturn 'size :over #sizeVal#'>
        <cfelseif arguments.ctype EQ "under">
            <cfreturn 'size :under #sizeVal#'>
        </cfif>
    </cfif>

    <cfreturn "">
</cffunction>

<cffunction name="buildSieveAction" returntype="string" output="false">
    <cfargument name="atype" type="string" required="true">
    <cfargument name="avalue" type="string" required="false" default="">
    <cfargument name="useCreate" type="boolean" required="false" default="false">

    <cfset var v = sieveEscape(arguments.avalue)>

    <cfif arguments.atype EQ "fileinto">
        <cfif arguments.useCreate>
            <cfreturn 'fileinto :create "#v#";'>
        <cfelse>
            <cfreturn 'fileinto "#v#";'>
        </cfif>
    <cfelseif arguments.atype EQ "discard">
        <cfreturn "discard;">
    <cfelseif arguments.atype EQ "keep">
        <cfreturn "keep;">
    <cfelseif arguments.atype EQ "redirect">
        <cfreturn 'redirect "#v#";'>
    <cfelseif arguments.atype EQ "flag_seen">
        <cfreturn 'addflag "\\Seen";'>
    <cfelseif arguments.atype EQ "reject">
        <cfreturn 'reject "#v#";'>
    </cfif>

    <cfreturn "">
</cffunction>
