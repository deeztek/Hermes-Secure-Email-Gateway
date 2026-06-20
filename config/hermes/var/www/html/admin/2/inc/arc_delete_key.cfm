<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- Delete an ARC signing key: removes both the public/private files from
      /opt/hermes/arc/keys/ and the arc_sign row. Mirrors dkim_delete_key.cfm. --->

<cfquery name="getkeys" datasource="hermes">
    SELECT public, private FROM arc_sign
    WHERE id = <cfqueryparam value="#form.key_id#" CFSQLType="CF_SQL_INTEGER">
</cfquery>

<cfoutput>
    <cfset PublicFiletoDelete = "/opt/hermes/arc/keys/#getkeys.public#">
    <cfif fileExists(#PublicFiletoDelete#)>
        <cffile action="delete" file="#PublicFiletoDelete#">
    </cfif>

    <cfset PrivateFiletoDelete = "/opt/hermes/arc/keys/#getkeys.private#">
    <cfif fileExists(#PrivateFiletoDelete#)>
        <cffile action="delete" file="#PrivateFiletoDelete#">
    </cfif>
</cfoutput>

<!--- DELETE ARC KEY FROM DATABASE --->
<cfquery name="deletearckey" datasource="hermes">
    DELETE FROM arc_sign WHERE id = <cfqueryparam value="#form.key_id#" CFSQLType="CF_SQL_INTEGER">
</cfquery>
