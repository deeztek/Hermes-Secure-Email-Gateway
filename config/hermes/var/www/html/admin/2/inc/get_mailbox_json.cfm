
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
GET MAILBOX JSON - AJAX endpoint for edit modal
Returns mailbox data as JSON for populating the edit form.
Expects: form.id (mailbox.id)
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid mailbox ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username, m.name, m.quota, m.active, m.domain_id, m.nextcloud_enabled,
           m.first_name, m.last_name, m.title, m.phone, m.mobile, m.department,
           r.enforce_mfa,
           d.domain, d.default_quota_mb,
           r.id AS recipient_id, r.policy_id, r.auth_type, r.remoteauth_domain,
           us.report_enabled, us.train_bayes, us.download_msg, us.timezone
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id
    LEFT JOIN recipients r ON r.recipient = m.username
    LEFT JOIN user_settings us ON us.email = m.username
    WHERE m.id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailbox.recordcount LT 1>
    <cfoutput>{"error": "Mailbox not found"}</cfoutput>
    <cfabort>
</cfif>

<cfset quotaGb = getMailbox.quota / 1024 / 1024 / 1024>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getMailbox.id#,
    "username": "#JSStringFormat(getMailbox.username)#",
    "name": "#JSStringFormat(getMailbox.name)#",
    "domain": "#JSStringFormat(getMailbox.domain)#",
    "domain_id": #getMailbox.domain_id#,
    "quota_bytes": #getMailbox.quota#,
    "quota_gb": "<cfif quotaGb GTE 1>#NumberFormat(quotaGb, '0.0')#<cfelse>#NumberFormat(quotaGb, '0.00')#</cfif>",
    "active": #getMailbox.active#,
    "recipient_id": <cfif getMailbox.recipient_id NEQ "">#getMailbox.recipient_id#<cfelse>null</cfif>,
    "policy_id": <cfif getMailbox.policy_id NEQ "">#getMailbox.policy_id#<cfelse>null</cfif>,
    "auth_type": "#JSStringFormat(getMailbox.auth_type)#",
    "report_enabled": "#JSStringFormat(getMailbox.report_enabled)#",
    "train_bayes": "#JSStringFormat(getMailbox.train_bayes)#",
    "download_msg": "#JSStringFormat(getMailbox.download_msg)#",
    "nextcloud_enabled": #getMailbox.nextcloud_enabled#,
    "enforce_mfa": #getMailbox.enforce_mfa#,
    "timezone": "#JSStringFormat(getMailbox.timezone)#",
    "first_name": "#JSStringFormat(getMailbox.first_name)#",
    "last_name": "#JSStringFormat(getMailbox.last_name)#",
    "title": "#JSStringFormat(getMailbox.title)#",
    "phone": "#JSStringFormat(getMailbox.phone)#",
    "mobile": "#JSStringFormat(getMailbox.mobile)#",
    "department": "#JSStringFormat(getMailbox.department)#"
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
