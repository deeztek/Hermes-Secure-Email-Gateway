
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
EDIT MAILBOX ALIAS ACTION HANDLER
Updates alias type, delivers-to, and send-as settings.
Alias address is immutable after creation.
--->

<!--- VALIDATE ALIAS ID --->
<cfif NOT StructKeyExists(form, "alias_id") OR NOT IsNumeric(form.alias_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- GET EXISTING ALIAS --->
<cfquery name="getAlias" datasource="hermes">
    SELECT id, alias_address, delivers_to, alias_type, send_as FROM mailbox_aliases
    WHERE id = <cfqueryparam value="#form.alias_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getAlias.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<cfset aliasAddress = getAlias.alias_address>
<cfset oldDeliversTo = getAlias.delivers_to>
<cfset oldSendAs = getAlias.send_as>

<!--- VALIDATE ALIAS TYPE --->
<cfparam name="form.edit_alias_type" default="forward">
<cfif form.edit_alias_type NEQ "forward" AND form.edit_alias_type NEQ "discard">
    <cfset form.edit_alias_type = "forward">
</cfif>

<!--- VALIDATE DELIVERS TO --->
<cfparam name="form.edit_delivers_to" default="">
<cfif form.edit_alias_type EQ "forward">
    <cfset newDeliversTo = LCase(trim(form.edit_delivers_to))>
    <cfif newDeliversTo EQ "">
        <cfset session.m = 15>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
    <cfquery name="checkTarget" datasource="hermes">
        SELECT id FROM mailboxes WHERE username = <cfqueryparam value="#newDeliversTo#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkTarget.recordcount LT 1>
        <cfset session.m = 16>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
<cfelse>
    <cfset newDeliversTo = "discard:silently">
</cfif>

<!--- VALIDATE SEND-AS --->
<cfparam name="form.edit_send_as" default="0">
<cfif form.edit_alias_type EQ "discard">
    <cfset form.edit_send_as = 0>
</cfif>
<cfif form.edit_send_as NEQ "0" AND form.edit_send_as NEQ "1">
    <cfset form.edit_send_as = 0>
</cfif>

<!--- UPDATE MAILBOX_ALIASES --->
<cfquery datasource="hermes">
    UPDATE mailbox_aliases
    SET delivers_to = <cfqueryparam value="#newDeliversTo#" cfsqltype="cf_sql_varchar">,
        alias_type = <cfqueryparam value="#form.edit_alias_type#" cfsqltype="cf_sql_varchar">,
        send_as = <cfqueryparam value="#form.edit_send_as#" cfsqltype="cf_sql_tinyint">
    WHERE id = <cfqueryparam value="#form.alias_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- UPDATE SENDER_LOGIN_MAPS --->
<!--- Remove old send-as entry if it existed --->
<cfif oldSendAs EQ 1 AND oldDeliversTo NEQ "discard:silently">
    <cfquery datasource="hermes">
        DELETE FROM sender_login_maps
        WHERE sender = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
        AND login_user = <cfqueryparam value="#oldDeliversTo#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cfif>

<!--- Add new send-as entry if enabled --->
<cfif form.edit_send_as EQ "1" AND form.edit_alias_type EQ "forward">
    <cfquery datasource="hermes">
        INSERT IGNORE INTO sender_login_maps (sender, login_user)
        VALUES (
          <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#newDeliversTo#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 2>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
