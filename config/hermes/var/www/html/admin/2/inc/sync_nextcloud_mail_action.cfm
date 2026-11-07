<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

SYNC NEXTCLOUD MAIL ACTION HANDLER (#356)

Nextcloud Mail refreshes its folder list on its own every 15 minutes to 6 hours,
depending on how recently the user opened it. This does it now, for example
after a Mail Import. No password is involved and the account is not changed.

--force also syncs messages, which can take a while on a large mailbox, so it
runs detached and the page does not wait for it.
--->

<cfif NOT StructKeyExists(form, "sync_mailbox_id") OR NOT IsNumeric(form.sync_mailbox_id)>
    <cfset session.m = 50>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="getMailboxSync" datasource="hermes">
    SELECT id, username, nextcloud_enabled
    FROM mailboxes
    WHERE id = <cfqueryparam value="#form.sync_mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailboxSync.recordcount LT 1>
    <cfset session.m = 51>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfif Val(getMailboxSync.nextcloud_enabled) NEQ 1 OR NOT REFind("^[A-Za-z0-9._%+@-]+$", getMailboxSync.username)>
    <cfset session.m = 56>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset ncSyncOut = "">
<cfset ncSyncStarted = 0>
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:export #getMailboxSync.username# --output=json"
        variable="ncSyncOut"
        timeout="60" />

    <cfif IsJSON(Trim(ncSyncOut))>
        <cfset ncSyncAccounts = DeserializeJSON(Trim(ncSyncOut))>
        <cfif IsArray(ncSyncAccounts)>
            <cfloop array="#ncSyncAccounts#" index="ncSyncAccount">
                <cfif IsStruct(ncSyncAccount) AND StructKeyExists(ncSyncAccount, "id") AND IsNumeric(ncSyncAccount.id)>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec -d -u www-data hermes_nextcloud php /var/www/html/occ mail:account:sync #Int(ncSyncAccount.id)# --force"
                        timeout="30" />
                    <cfset ncSyncStarted = ncSyncStarted + 1>
                </cfif>
            </cfloop>
        </cfif>
    </cfif>
    <cfcatch>
        <cfset ncSyncStarted = 0>
    </cfcatch>
</cftry>

<cfset session.syncNcUser = getMailboxSync.username>
<cfset session.m = ncSyncStarted GT 0 ? 57 : 58>
<cflocation url="view_mailboxes.cfm" addtoken="no">
