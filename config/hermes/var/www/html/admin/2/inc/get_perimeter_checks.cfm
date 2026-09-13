<!---
Hermes Secure Email Gateway - Perimeter Checks Data Include
Queries the parameters table for all perimeter check settings.
--->

<!--- Postscreen Settings --->
<cfquery name="get_postscreen_pipelining" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="postscreen_pipelining_enable" cfsqltype="cf_sql_varchar"> AND child = '1'
  ORDER BY order1 ASC
</cfquery>

<cfquery name="get_postscreen_non_smtp" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="postscreen_non_smtp_command_enable" cfsqltype="cf_sql_varchar"> AND child = '1'
  ORDER BY order1 ASC
</cfquery>

<cfquery name="get_postscreen_bare_newline" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="postscreen_bare_newline_enable" cfsqltype="cf_sql_varchar"> AND child = '1'
  ORDER BY order1 ASC
</cfquery>

<cfquery name="get_dnsbl_threshold" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="postscreen_dnsbl_threshold" cfsqltype="cf_sql_varchar"> AND child = '1' AND enabled = '1'
  ORDER BY order1 ASC
</cfquery>

<!--- Message Settings --->
<cfquery name="get_message_size" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="message_size_limit" cfsqltype="cf_sql_varchar"> AND child = '1' AND enabled = '1'
  ORDER BY order1 ASC
</cfquery>

<!--- HELO Required --->
<cfquery name="get_helo_required" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parent_name = <cfqueryparam value="smtpd_helo_required" cfsqltype="cf_sql_varchar"> AND child = '1'
  ORDER BY order1 ASC
</cfquery>

<!--- Recipient Restrictions --->

<cfquery name="get_reject_unauth_destination" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_unauth_destination" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_unauth_pipelining" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_unauth_pipelining" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_invalid_hostname" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_invalid_hostname" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_non_fqdn_sender" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_non_fqdn_sender" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_unknown_sender_domain" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_unknown_sender_domain" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_non_fqdn_recipient" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_non_fqdn_recipient" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_reject_unknown_recipient_domain" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="reject_unknown_recipient_domain" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- SPF/DKIM/DMARC Milters --->

<cfquery name="get_spf" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter = <cfqueryparam value="check_policy_service unix:private/policy-spf" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_recipient_restrictions" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_dkim" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter LIKE <cfqueryparam value="inet:%:8891" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_milters" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="get_dmarc" datasource="hermes">
  SELECT id, parameter, enabled FROM parameters
  WHERE parameter LIKE <cfqueryparam value="inet:%:54321" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent_name = <cfqueryparam value="smtpd_milters" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Convert message size from bytes to MB for display --->
<cfset messageSizeMB = 0>
<cfif get_message_size.recordCount GT 0 AND IsNumeric(get_message_size.parameter)>
  <cfset messageSizeMB = get_message_size.parameter / 1024 / 1024>
</cfif>
