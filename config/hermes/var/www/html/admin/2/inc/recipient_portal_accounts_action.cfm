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

<!--- RELAY RECIPIENT PORTAL ACCOUNTS: PROVISION AND WELCOME EMAIL (#359)

     Requires portalMode to be set by the caller:
       "provision"  the selected recipients (form.recipient_id), or with
                    form.scope = "missing" every relay recipient (catch-all
                    @domain entries excluded), get a user-portal account if
                    they have none.
                    With form.send_welcome = 1, each NEWLY created account
                    is sent the welcome email. Existing accounts are left
                    alone and not emailed, so this is safe to run again.
       "resend"     the welcome email is sent to the recipients in
                    form.recipient_id; no account is created.
     form.welcome_message (optional, plain text) is added to the email.

     Why it exists: a recipient's portal account is created when an admin
     adds the recipient. Recipients that arrive any other way (a legacy
     migration restores them straight into the database) have none, so the
     password reset that the welcome email points to cannot find them.

     Each recipient runs in its own thread. The account and email includes
     end their error paths with error.cfm + cfabort, which cftry cannot
     catch; inside a thread an abort ends only that recipient, which is then
     counted as failed. Same reasoning as schedule/post_upgrade.cfm.

     Sets session.portalAccountsResult for the page to display. --->

<cfsetting requesttimeout="3600">

<cfparam name="form.welcome_message" default="">
<cfset portalExtraMessage = Left(Trim(form.welcome_message), 4000)>
<cfset portalSendWelcome = (portalMode EQ "resend")
       OR (StructKeyExists(form, "send_welcome") AND form.send_welcome EQ "1")>

<!--- Provision acts on the selected rows unless the admin chose "all
     recipients without a portal account" (form.scope = "missing"). --->
<cfparam name="form.scope" default="selected">
<cfset portalUseSelection = (portalMode EQ "resend") OR (form.scope NEQ "missing")>

<cfif portalUseSelection>
    <cfset portalIds = "">
    <cfif StructKeyExists(form, "recipient_id")>
        <cfloop list="#form.recipient_id#" index="pid">
            <cfif IsValid("integer", pid)>
                <cfset portalIds = ListAppend(portalIds, pid)>
            </cfif>
        </cfloop>
    </cfif>
    <cfif portalIds EQ "">
        <cfset portalIds = "0">
    </cfif>
    <cfquery name="portalRecipients" datasource="hermes">
        SELECT recipient, auth_type, remoteauth_domain
        FROM recipients
        WHERE id IN (<cfqueryparam value="#portalIds#" cfsqltype="cf_sql_integer" list="true">)
          AND recipient NOT LIKE '@%'
        ORDER BY recipient
    </cfquery>
<cfelse>
    <cfquery name="portalRecipients" datasource="hermes">
        SELECT recipient, auth_type, remoteauth_domain
        FROM recipients
        WHERE recipient NOT LIKE '@%'
        ORDER BY recipient
    </cfquery>
</cfif>

<cfset portalResult = {
    "mode": portalMode,
    "total": portalRecipients.recordcount,
    "created": 0,
    "existed": 0,
    "emailed": 0,
    "failed": 0,
    "failedList": ""
}>

<cfloop query="portalRecipients">
    <cfset portalThread = "pa_" & Replace(CreateUUID(), "-", "", "ALL")>
    <cfthread action="run" name="#portalThread#"
              email="#portalRecipients.recipient#"
              authtype="#portalRecipients.auth_type#"
              radomain="#portalRecipients.remoteauth_domain#"
              mode="#portalMode#"
              sendwelcome="#portalSendWelcome#"
              extramsg="#portalExtraMessage#">
        <cftry>
            <cfset recipientEmail = attributes.email>
            <cfset recipientName = attributes.email>
            <cfset welcomeExtraMessage = attributes.extramsg>
            <cfset thread.emailed = false>
            <cfif attributes.mode EQ "provision">
                <cfset ldapUserExists = false>
                <cfset ldapUserCreated = false>
                <cfif attributes.authtype EQ "remote">
                    <cfset remoteauthDomain = attributes.radomain>
                    <cfinclude template="ldap_add_user_relay_remoteauth.cfm">
                <cfelse>
                    <cfinclude template="ldap_add_user_relay.cfm">
                </cfif>
                <cfif NOT ldapUserCreated>
                    <cfset thread.outcome = "failed">
                <cfelseif ldapUserExists>
                    <cfset thread.outcome = "existed">
                <cfelse>
                    <cfset thread.outcome = "created">
                    <cfif attributes.sendwelcome>
                        <cfif attributes.authtype EQ "remote">
                            <cfinclude template="send_recipient_welcome_email_remoteauth.cfm">
                        <cfelse>
                            <cfinclude template="send_recipient_welcome_email.cfm">
                        </cfif>
                        <cfset thread.emailed = true>
                    </cfif>
                </cfif>
            <cfelse>
                <cfif attributes.authtype EQ "remote">
                    <cfinclude template="send_recipient_welcome_email_remoteauth.cfm">
                <cfelse>
                    <cfinclude template="send_recipient_welcome_email.cfm">
                </cfif>
                <cfset thread.emailed = true>
                <cfset thread.outcome = "emailed">
            </cfif>
            <cfcatch type="any">
                <cfset thread.outcome = "failed">
                <cflog file="hermes" type="error"
                       text="recipient_portal_accounts_action: #attributes.email#: #cfcatch.message#">
            </cfcatch>
        </cftry>
    </cfthread>
    <cfthread action="join" name="#portalThread#" timeout="120000" />

    <!--- An abort inside the thread leaves no outcome: count it as failed. --->
    <cfset portalOutcome = StructKeyExists(cfthread[portalThread], "outcome") ? cfthread[portalThread].outcome : "failed">
    <cfif portalOutcome EQ "created">
        <cfset portalResult.created = portalResult.created + 1>
    <cfelseif portalOutcome EQ "existed">
        <cfset portalResult.existed = portalResult.existed + 1>
    <cfelseif portalOutcome EQ "failed">
        <cfset portalResult.failed = portalResult.failed + 1>
        <cfset portalResult.failedList = ListAppend(portalResult.failedList, portalRecipients.recipient, " ")>
    </cfif>
    <cfif StructKeyExists(cfthread[portalThread], "emailed") AND cfthread[portalThread].emailed>
        <cfset portalResult.emailed = portalResult.emailed + 1>
    </cfif>
</cfloop>

<cflog file="hermes" type="information"
       text="recipient_portal_accounts_action (#portalMode#): total=#portalResult.total# created=#portalResult.created# existed=#portalResult.existed# emailed=#portalResult.emailed# failed=#portalResult.failed#">

<cfset session.portalAccountsResult = portalResult>
