
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
    SELECT id, alias_address, delivers_to, alias_type, send_as, domain_id
    FROM mailbox_aliases
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

<!--- VALIDATE DELIVERS TO

     This edits ONE destination row, identified by alias_id, rather than
     replacing the whole set. Per-row editing was chosen over replace-the-set
     because it is safer and more precise: there is no window in which the
     list is empty, `created_at` survives on members that did not change, and
     two admins working on the same list only collide if they touch the same
     member. Adding members is the Add modal's job; removing one is a delete
     on its own row.

     The alias address is read-only in the modal, so a per-row edit can only
     change where this one destination points. There is no way to split a
     grouped alias by renaming a single row out of it.

     Format validation only. The old "must be an existing mailbox" check is
     gone, matching the add handler: it made external forwarding impossible on
     mailbox domains while relay domains allowed it freely. --->
<!--- Accepts SEVERAL destinations, not one.

     Editing normally changes the single destination whose pen icon was
     clicked, and passing one address still does exactly that. But converting
     an alias from Discard to Forward is a case where one is not enough: a
     discard alias has no destination chips, so there is nowhere else to add
     from, and forcing the admin to save one and then add the rest from the
     row is a two-step dance for something that should be one action.

     Rather than special-casing the conversion, the field simply takes a list
     everywhere. One value edits the row, as before. Several edit the row and
     add the remainder, which reads naturally as "this destination becomes
     these". Nothing is ever deleted by an edit. --->
<cfparam name="form.edit_delivers_to" default="">
<cfset editDestList = "">

<cfif form.edit_alias_type EQ "forward">
    <cfloop index="editDestCandidate" list="#Trim(form.edit_delivers_to)#" delimiters=",; #chr(9)##chr(10)##chr(13)#">
        <cfset editDestCandidate = LCase(Trim(editDestCandidate))>
        <cfif editDestCandidate EQ "">
            <cfcontinue>
        </cfif>
        <cfif NOT IsValid("email", editDestCandidate)>
            <cfset session.m = 16>
            <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
        </cfif>
        <cfif ListFindNoCase(editDestList, editDestCandidate) EQ 0>
            <cfset editDestList = ListAppend(editDestList, editDestCandidate)>
        </cfif>
    </cfloop>

    <cfif ListLen(editDestList) EQ 0>
        <cfset session.m = 15>
        <cflocation url="view_mailbox_aliases.cfm" addtoken="no">
    </cfif>

    <!--- No duplicate-pair check needed. The submitted set is deduplicated
         above, and the diff below only inserts what is not already stored, so
         uq_alias_dest can never be violated. --->
</cfif>

<!--- VALIDATE SEND-AS --->
<cfparam name="form.edit_send_as" default="0">
<cfif form.edit_alias_type EQ "discard">
    <cfset form.edit_send_as = 0>
</cfif>
<cfif form.edit_send_as NEQ "0" AND form.edit_send_as NEQ "1">
    <cfset form.edit_send_as = 0>
</cfif>

<!--- VALIDATE INTERNAL-ONLY --->
<cfparam name="form.edit_internal_only" default="0">
<cfif form.edit_internal_only NEQ "0" AND form.edit_internal_only NEQ "1">
    <cfset form.edit_internal_only = 0>
</cfif>

<!--- UPDATE THIS DESTINATION ROW

     send_as is deliberately NOT written. Its control is gone from the modal
     now that the permission is granted per mailbox, so a cfparam default of
     0 would silently zero the column on every edit. Nothing reads it for
     permissions any more, but quietly rewriting stored data because a form
     field disappeared is the kind of thing that is impossible to explain
     later. Left exactly as it was found. --->
<!--- The modal shows the alias's whole destination set as chips, so the save
     is a DIFF against what is stored, not a rewrite of it.

     Diffing rather than delete-all-then-reinsert matters for three reasons:
     there is never a moment where the alias has no destinations and mail
     would bounce, created_at survives on members that did not change, and a
     failure partway through cannot leave the alias empty.

     Type belongs to the ADDRESS. An alias either forwards or discards, never
     both, which the add path also enforces. --->

<cfquery name="getCurrentDests" datasource="hermes">
    SELECT id, delivers_to FROM mailbox_aliases
    WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif form.edit_alias_type EQ "discard">

    <!--- Collapsing to Discard. Every real destination goes, replaced by the
         single pseudo-destination. Cannot be done by UPDATE: setting them all
         to 'discard:silently' would collide with uq_alias_dest as soon as
         there was more than one row. --->
    <cfquery datasource="hermes">
        DELETE FROM mailbox_aliases
        WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
          AND delivers_to  <> <cfqueryparam value="discard:silently" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery datasource="hermes">
        INSERT IGNORE INTO mailbox_aliases (alias_address, delivers_to, alias_type, internal_only, send_as, domain_id)
        VALUES (
          <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="discard:silently" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="discard" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">,
          <cfqueryparam value="#Val(getAlias.send_as)#" cfsqltype="cf_sql_tinyint">,
          <cfqueryparam value="#getAlias.domain_id#" cfsqltype="cf_sql_integer">
        )
    </cfquery>

<cfelse>

    <!--- ADD what is new. INSERT IGNORE so a destination already present is
         simply left alone. --->
    <cfset currentDestList = "">
    <cfoutput query="getCurrentDests">
        <cfset currentDestList = ListAppend(currentDestList, LCase(Trim(delivers_to)))>
    </cfoutput>

    <cfloop index="wantedDest" list="#editDestList#" delimiters=",">
        <cfset wantedDest = Trim(wantedDest)>
        <cfif ListFindNoCase(currentDestList, wantedDest) GT 0>
            <cfcontinue>
        </cfif>
        <cfquery datasource="hermes">
            INSERT IGNORE INTO mailbox_aliases (alias_address, delivers_to, alias_type, internal_only, send_as, domain_id)
            VALUES (
              <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#wantedDest#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="forward" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">,
              <cfqueryparam value="0" cfsqltype="cf_sql_tinyint">,
              <cfqueryparam value="#getAlias.domain_id#" cfsqltype="cf_sql_integer">
            )
        </cfquery>
    </cfloop>

    <!--- REMOVE what the admin took off. Includes the 'discard:silently'
         pseudo-row when converting from Discard, since it is not in the
         submitted set. Deleting by id leaves untouched rows, and their
         created_at, alone. --->
    <cfoutput query="getCurrentDests">
        <cfif ListFindNoCase(editDestList, LCase(Trim(delivers_to))) EQ 0>
            <cfquery datasource="hermes">
                DELETE FROM mailbox_aliases
                WHERE id = <cfqueryparam value="#getCurrentDests.id#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfif>
    </cfoutput>

    <!--- Rows that survived a conversion from Discard are still marked
         discard. Type is a property of the address, so bring them into line. --->
    <cfquery datasource="hermes">
        UPDATE mailbox_aliases
        SET alias_type = <cfqueryparam value="forward" cfsqltype="cf_sql_varchar">
        WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
    </cfquery>

</cfif>

<!--- Reachability belongs to the ADDRESS, not to one destination, so it is
     applied across every row the alias has. Leaving it per-row would let an
     alias end up half open and half restricted, which Postfix has no way to
     express and an admin has no way to reason about. --->
<cfquery datasource="hermes">
    UPDATE mailbox_aliases
    SET internal_only = <cfqueryparam value="#form.edit_internal_only#" cfsqltype="cf_sql_tinyint">
    WHERE alias_address = <cfqueryparam value="#aliasAddress#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- SENDER_LOGIN_MAPS is deliberately NOT resynced here any more.
     Send-As is granted per mailbox, via Mailboxes > Actions > Send As, which
     owns that table in edit_mailbox_send_as_action.cfm. See the note in
     add_mailbox_alias_action.cfm for why it moved.

     Consequence worth knowing: changing an alias's destination no longer
     moves the send-as permission along with it. That is intentional. The
     grant now says "this mailbox may send from this address", which has
     nothing to do with where the address happens to deliver, so silently
     transferring it on a destination change would be wrong.

     Existing grants are untouched by an alias edit. Deleting the alias still
     revokes them, in delete_mailbox_alias_action.cfm. --->

<!--- oldSendAs / oldDeliversTo are still read above so the surrounding
     validation keeps working; nothing acts on them here. --->

<!--- SUCCESS --->
<cfset session.m = 2>
<cflocation url="view_mailbox_aliases.cfm" addtoken="no">
