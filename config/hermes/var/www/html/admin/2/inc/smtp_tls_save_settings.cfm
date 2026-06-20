<!---
Hermes Secure Email Gateway - SMTP TLS Save Settings Action Handler
Validates and saves SMTP TLS mode and certificate selection.
Expects: form.tlsmode, form.certificateno_1
--->

<!--- Delegate to existing validation/save logic --->
<cfinclude template="./edit_smtp_tls_settings.cfm">

<!--- Generate Postfix configuration and reload --->
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 35>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
