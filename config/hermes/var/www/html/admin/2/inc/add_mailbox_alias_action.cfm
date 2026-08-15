
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

<!--- The alias address existing already is NO LONGER a reason to refuse.
     Adding a destination to an alias that already has one is precisely how
     a list grows, so blocking it here would block the feature.

     What is still refused is an exact repeat of the same address AND the
     same destination, which is checked per pair at insert time below and
     enforced by uq_alias_dest in the database. --->

<!--- Was: blanket duplicate check on alias_address, session.m = 14 --->

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

<!--- VALIDATE DELIVERS TO (required for forward, ignored for discard)

     Now accepts SEVERAL destinations. One row is written per destination,
     and Postfix concatenates the rows it gets back into a single recipient
     list, which is how an alias becomes a distribution list.

     Split on comma, semicolon, whitespace and newline, so an admin can
     paste a list from wherever they keep it without reformatting.

     Destinations are NOT restricted to local mailboxes any more. The old
     "must exist in mailboxes" check made external forwarding impossible on
     mailbox domains while relay domains allowed it freely, which was an
     inconsistency rather than a policy. External destinations carry real
     caveats around SPF and DKIM, and the page warns about them, but that is
     the operator's call to make. --->
<cfparam name="form.delivers_to" default="">
<cfset deliversToList = "">

<cfif form.alias_type EQ "forward">
    <cfset rawDestinations = Trim(form.delivers_to)>
    <cfif rawDestinations EQ "">
        <cfset session.m = 15>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>

    <cfloop index="destCandidate" list="#rawDestinations#" delimiters=",; #chr(9)##chr(10)##chr(13)#">
        <cfset destCandidate = LCase(Trim(destCandidate))>
        <cfif destCandidate EQ "">
            <cfcontinue>
        </cfif>
        <!--- Format only. Anything that is a valid address is allowed,
             local or external. --->
        <cfif NOT IsValid("email", destCandidate)>
            <cfset session.m = 16>
            <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
        </cfif>
        <cfif ListFindNoCase(deliversToList, destCandidate) EQ 0>
            <cfset deliversToList = ListAppend(deliversToList, destCandidate)>
        </cfif>
    </cfloop>

    <cfif ListLen(deliversToList) EQ 0>
        <cfset session.m = 15>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>
<cfelse>
    <!--- Discard type. Exactly one pseudo-destination, never a list. --->
    <cfset deliversToList = "discard:silently">
</cfif>

<!--- VALIDATE SEND-AS (only for forward type) --->
<cfparam name="form.send_as" default="0">
<cfif form.alias_type EQ "discard">
    <cfset form.send_as = 0>
</cfif>
<cfif form.send_as NEQ "0" AND form.send_as NEQ "1">
    <cfset form.send_as = 0>
</cfif>

<!--- VALIDATE INTERNAL-ONLY

     Conceptually a property of the ADDRESS, not of any one destination, but
     stored per row because that is where the rows live. Every row for this
     alias therefore gets the same value, and the list view reads it with
     MAX() so a mixed state, which should not arise, still reads as
     restricted rather than open. --->
<cfparam name="form.internal_only" default="0">
<cfif form.internal_only NEQ "0" AND form.internal_only NEQ "1">
    <cfset form.internal_only = 0>
</cfif>

<!--- Adding members to an alias that already exists must not silently
     change its reachability. Inherit whatever the existing rows carry. --->
<cfquery name="getExistingInternalOnly" datasource="hermes">
    SELECT MAX(internal_only) AS internal_only
    FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif getExistingInternalOnly.recordcount GTE 1 AND IsNumeric(getExistingInternalOnly.internal_only)>
    <cfset form.internal_only = getExistingInternalOnly.internal_only>
</cfif>

<!--- ====================================================================
     ALL VALIDATION PASSED - BEGIN CREATION
     ==================================================================== --->

<!--- 1. INSERT ONE ROW PER DESTINATION.
     INSERT IGNORE rather than checking first: uq_alias_dest already refuses
     an exact address-plus-destination repeat, so a destination the alias
     already has is silently skipped instead of failing the whole save. That
     makes re-pasting a list with two new members on the end do the obvious
     thing. --->
<cfset aliasRowsAdded = 0>
<cfloop index="oneDestination" list="#deliversToList#" delimiters=",">
    <cfquery name="insertAliasRow" datasource="hermes" result="insertAliasResult">
        INSERT IGNORE INTO mailbox_aliases (alias_address, delivers_to, alias_type, internal_only, send_as, domain_id)
        VALUES (
          <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#Trim(oneDestination)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.alias_type#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.internal_only#" cfsqltype="cf_sql_tinyint">,
          <cfqueryparam value="#form.send_as#" cfsqltype="cf_sql_tinyint">,
          <cfqueryparam value="#checkDomain.id#" cfsqltype="cf_sql_integer">
        )
    </cfquery>
    <cfif StructKeyExists(insertAliasResult, "recordcount") AND insertAliasResult.recordcount GT 0>
        <cfset aliasRowsAdded = aliasRowsAdded + 1>
    </cfif>
</cfloop>

<!--- Everything submitted was already present. Say so rather than
     reporting a success that changed nothing. --->
<cfif aliasRowsAdded EQ 0>
    <cfset session.m = 14>
    <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
</cfif>

<cfset session.aliasRowsAdded = aliasRowsAdded>

<!--- 2. SENDER_LOGIN_MAPS is deliberately NOT written here any more.
     Send-As is now granted per mailbox, via Mailboxes > Actions > Send As,
     which owns sender_login_maps in edit_mailbox_send_as_action.cfm.

     It used to be a side effect of this page's Send-As toggle. That worked
     while an alias had exactly one destination and stopped making sense the
     moment an alias could have several: a single Yes/No here would have
     granted send-as to every member of a distribution list at once, with no
     way to say "these three may, the other seventeen may not".

     The send_as column is still written above so existing rows keep their
     value, but nothing reads it to decide permissions. Dropping it is a
     later cleanup with no urgency. --->

<!--- SUCCESS --->
<cfset session.m = 1>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
