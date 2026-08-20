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
SEND-AS ACTION HANDLER

Owns `sender_login_maps` for one mailbox. That table is Postfix's
smtpd_sender_login_maps source: a row (sender, login_user) permits
login_user to put `sender` in the From address.

This is the ONLY place the grant is edited. It used to be written as a
side effect of the alias page's Send-As toggle, which worked while an
alias had exactly one destination and stopped making sense the moment
an alias could have many: a single Yes/No on the alias would have
granted send-as to every member of a distribution list at once.

Moving the grant onto the mailbox makes membership and send-as
independent. Adding somebody to a list gives them nothing extra, and
granting send-as to one member does not require touching the list.

Scope: only aliases on the MAILBOX'S OWN DOMAIN can be granted. Wider
than that and a mailbox on one tenant could be given the right to send
as another tenant's address. Revisit if anyone has a real need.

Resync semantics: the submitted set replaces the stored set for this
login_user. Anything unchecked is revoked. Sending an empty set revokes
everything, which is how an admin removes the last grant.
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "mailbox_id") OR NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 61>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- RESOLVE THE MAILBOX. username IS the SASL login, so it is what
     goes in login_user. domain_id scopes which aliases may be granted. --->
<cfquery name="getSendAsMailbox" datasource="hermes">
    SELECT id, username, domain_id
    FROM mailboxes
    WHERE id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getSendAsMailbox.recordcount LT 1>
    <cfset session.m = 61>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset sendAsLoginUser = LCase(Trim(getSendAsMailbox.username))>
<cfset sendAsDomainId  = getSendAsMailbox.domain_id>

<!--- The addresses this mailbox is ALLOWED to be granted: aliases on its
     own domain. Built server-side rather than trusted from the form, so a
     crafted POST cannot grant an address from another domain. --->
<cfquery name="getGrantableAddresses" datasource="hermes">
    SELECT DISTINCT alias_address
    FROM mailbox_aliases
    WHERE domain_id = <cfqueryparam value="#sendAsDomainId#" cfsqltype="cf_sql_integer">
      AND alias_type <> <cfqueryparam value="discard" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset grantableList = "">
<cfoutput query="getGrantableAddresses">
    <cfset grantableList = ListAppend(grantableList, LCase(Trim(alias_address)))>
</cfoutput>

<!--- Submitted set. TomSelect posts a comma-delimited string. --->
<cfparam name="form.send_as_addresses" default="">
<cfset submitted = Trim(form.send_as_addresses)>

<cfset acceptedList = "">
<cfset rejectedCount = 0>

<cfloop index="candidate" list="#submitted#" delimiters=",">
    <cfset candidate = LCase(Trim(candidate))>
    <cfif candidate is "">
        <cfcontinue>
    </cfif>
    <cfif ListFindNoCase(grantableList, candidate) GT 0>
        <cfif ListFindNoCase(acceptedList, candidate) EQ 0>
            <cfset acceptedList = ListAppend(acceptedList, candidate)>
        </cfif>
    <cfelse>
        <!--- Not an alias on this mailbox's domain. Dropped rather than
             failing the whole save, so a stale modal does not block an
             otherwise valid edit. --->
        <cfset rejectedCount = rejectedCount + 1>
    </cfif>
</cfloop>

<!--- REPLACE the stored set. Delete-then-insert rather than diffing:
     the set is small, and this cannot leave a stale grant behind.

     `sender <> login_user` is LOAD-BEARING. Every mailbox owns a self-row,
     (alice@d, alice@d), written by add_mailbox_action.cfm when the mailbox is
     created. That row is what lets the user send as their OWN address:
     Postfix's smtpd_sender_login_maps feeds reject_sender_login_mismatch on
     the submission port, and without it the mailbox can receive mail but
     cannot send any.

     Deleting by login_user alone took the self-row with it, and nothing put
     it back, because the picker only ever offers aliases. Opening this modal
     and saving, even with nothing selected and nothing changed, was enough to
     stop that mailbox sending. --->
<cftry>
    <cfquery datasource="hermes">
        DELETE FROM sender_login_maps
        WHERE login_user = <cfqueryparam value="#sendAsLoginUser#" cfsqltype="cf_sql_varchar">
          AND sender    <> <cfqueryparam value="#sendAsLoginUser#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!--- Re-assert the self-row. Normally already present, so this is a no-op;
         it repairs a mailbox whose row was removed by the delete above before
         it was scoped. Idempotent via INSERT IGNORE. --->
    <cfquery datasource="hermes">
        INSERT IGNORE INTO sender_login_maps (sender, login_user)
        VALUES (
          <cfqueryparam value="#sendAsLoginUser#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#sendAsLoginUser#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>

    <cfloop index="granted" list="#acceptedList#" delimiters=",">
        <cfquery datasource="hermes">
            INSERT IGNORE INTO sender_login_maps (sender, login_user)
            VALUES (
              <cfqueryparam value="#Trim(granted)#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#sendAsLoginUser#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
    </cfloop>

    <cfcatch type="any">
        <cfset session.m = 61>
        <cflocation url="view_mailboxes.cfm" addtoken="no">
    </cfcatch>
</cftry>

<cfset session.sendAsTarget = sendAsLoginUser>
<cfset session.sendAsCount  = ListLen(acceptedList)>
<cfset session.m = 60>
<cflocation url="view_mailboxes.cfm" addtoken="no">
