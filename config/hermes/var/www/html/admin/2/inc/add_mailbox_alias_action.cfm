
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
ADD MAILBOX ALIAS ACTION HANDLER
Creates an alias in mailbox_aliases, a recipients entry for Amavis SVF policy,
and optionally a sender_login_maps entry for send-as.
Types: forward (delivers to mailbox) or discard (silently drops mail)
--->

<!--- VALIDATE ALIAS ADDRESS --->
<cfif NOT StructKeyExists(form, "alias_address") OR trim(form.alias_address) EQ "">
    <cfset session.m = 10>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<cfset aliasAddress = LCase(trim(form.alias_address))>

<!--- Validate email format --->
<cfif NOT IsValid("email", aliasAddress)>
    <cfset session.m = 11>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- Validate domain is a mailbox domain --->
<cfset aliasDomain = ListLast(aliasAddress, "@")>
<cfquery name="checkDomain" datasource="hermes">
    SELECT id FROM domains
    WHERE domain = <cfqueryparam value="#aliasDomain#" cfsqltype="cf_sql_varchar">
    AND type = 'mailbox'
</cfquery>
<cfif checkDomain.recordcount LT 1>
    <cfset session.m = 12>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- Check alias doesn't already exist as a mailbox --->
<cfquery name="checkMailbox" datasource="hermes">
    SELECT id FROM mailboxes WHERE username = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif checkMailbox.recordcount GTE 1>
    <cfset session.m = 13>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- Check alias doesn't already exist in mailbox_aliases --->
<cfquery name="checkDuplicate" datasource="hermes">
    SELECT id FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif checkDuplicate.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- Check alias doesn't already exist in virtual_recipients (relay) --->
<cfquery name="checkVirtual" datasource="hermes">
    SELECT id FROM virtual_recipients
    WHERE virtual_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif checkVirtual.recordcount GTE 1>
    <cfset session.m = 17>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<!--- VALIDATE ALIAS TYPE --->
<cfparam name="form.alias_type" default="forward">
<cfif form.alias_type NEQ "forward" AND form.alias_type NEQ "discard">
    <cfset form.alias_type = "forward">
</cfif>

<!--- VALIDATE DELIVERS TO (required for forward, ignored for discard) --->
<cfparam name="form.delivers_to" default="">
<cfif form.alias_type EQ "forward">
    <cfset deliversTo = LCase(trim(form.delivers_to))>
    <cfif deliversTo EQ "">
        <cfset session.m = 15>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
    <!--- Verify target mailbox exists --->
    <cfquery name="checkTarget" datasource="hermes">
        SELECT id FROM mailboxes WHERE username = <cfqueryparam value="#deliversTo#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkTarget.recordcount LT 1>
        <cfset session.m = 16>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
<cfelse>
    <!--- Discard type --->
    <cfset deliversTo = "discard:silently">
</cfif>

<!--- VALIDATE SEND-AS (only for forward type) --->
<cfparam name="form.send_as" default="0">
<cfif form.alias_type EQ "discard">
    <cfset form.send_as = 0>
</cfif>
<cfif form.send_as NEQ "0" AND form.send_as NEQ "1">
    <cfset form.send_as = 0>
</cfif>

<!--- ====================================================================
     ALL VALIDATION PASSED - BEGIN CREATION
     ==================================================================== --->

<!--- 1. INSERT INTO MAILBOX_ALIASES --->
<cfquery datasource="hermes">
    INSERT INTO mailbox_aliases (alias_address, delivers_to, alias_type, send_as, domain_id)
    VALUES (
      <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#deliversTo#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.alias_type#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#form.send_as#" cfsqltype="cf_sql_tinyint">,
      <cfqueryparam value="#checkDomain.id#" cfsqltype="cf_sql_integer">
    )
</cfquery>

<!--- 2. INSERT SENDER_LOGIN_MAPS (if send-as enabled) --->
<cfif form.send_as EQ "1" AND form.alias_type EQ "forward">
    <cfquery datasource="hermes">
        INSERT IGNORE INTO sender_login_maps (sender, login_user)
        VALUES (
          <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#deliversTo#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 1>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
