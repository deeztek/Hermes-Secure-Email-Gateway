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
GET INTERNAL (RELAY) RECIPIENT JSON - AJAX endpoint for Edit Options modal
pre-fill (#225 Phase 2). Returns a single relay recipient's settings as
JSON so the modal opens with current values selected.
Expects: form.id (recipients.id)
--->

<cfparam name="form.id" default="">

<cfif form.id EQ "" OR NOT IsNumeric(form.id)>
    <cfoutput>{"error": "Invalid recipient ID"}</cfoutput>
    <cfabort>
</cfif>

<cfquery name="getRecipient" datasource="hermes">
    SELECT r.id, r.recipient, r.policy_id, r.enforce_mfa,
           r.auth_type, r.remoteauth_domain,
           us.report_enabled, us.train_bayes, us.download_msg,
           COALESCE(us.ldap_username, '') AS ldap_username
    FROM recipients r
    LEFT JOIN user_settings us ON us.email = r.recipient
    WHERE r.id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
      AND (r.recipient_type = 'relay' OR r.recipient_type IS NULL)
</cfquery>

<cfif getRecipient.recordcount LT 1>
    <cfoutput>{"error": "Recipient not found"}</cfoutput>
    <cfabort>
</cfif>

<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
{
    "id": #getRecipient.id#,
    "recipient": "#JSStringFormat(getRecipient.recipient)#",
    "policy_id": <cfif getRecipient.policy_id NEQ "">#getRecipient.policy_id#<cfelse>null</cfif>,
    "enforce_mfa": #Val(getRecipient.enforce_mfa)#,
    "auth_type": "#JSStringFormat(getRecipient.auth_type)#",
    "remoteauth_domain": "#JSStringFormat(getRecipient.remoteauth_domain)#",
    "report_enabled": "#JSStringFormat(getRecipient.report_enabled)#",
    "train_bayes": #Val(getRecipient.train_bayes)#,
    "download_msg": #Val(getRecipient.download_msg)#,
    "ldap_username": "#JSStringFormat(getRecipient.ldap_username)#"
}
</cfprocessingdirective>
</cfoutput>
<cfabort>
