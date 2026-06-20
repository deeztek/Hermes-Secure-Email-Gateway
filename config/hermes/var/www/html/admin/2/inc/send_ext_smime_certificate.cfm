<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

Sends an S/MIME PFX certificate to an external recipient via email.
Expects: getcerts query (from recipient_certificates), recipientEmail variable
--->

<cfquery name="getsettings" datasource="hermes">
  SELECT parameter, value FROM system_settings WHERE parameter = 'postmaster'
</cfquery>

<cfmail from="#getsettings.value#" to="#recipientEmail#" server="hermes_postfix_dkim" subject="[Hermes SEG] Your PFX Certificate File" port="10026" type="html">

  <div align="center">

    <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

    <h2>Your PFX Certificate File</h2>

Your PFX Certificate File is attached to this e-mail.

Please <a href="https://docs.deeztek.com/books/hosted/page/how-to-sendreceive-encrypted-email-from-microsoft-outlook">click here</a> for detailed instructions on how to install the certificate and configure Outlook to send S/MIME encrypted email or click the link below:<br><br>

https://docs.deeztek.com/books/hosted/page/how-to-sendreceive-encrypted-email-from-microsoft-outlook

<cfif getcerts.external_ca is "1">
<cfmailparam file="/opt/hermes/HermesExternalCACerts/#getcerts.pfx_certificate_name#">
<cfelseif getcerts.external_ca is not "1">
<cfquery name="getcadetails" datasource="hermes">
  SELECT id, ca_directory FROM ca_settings WHERE id = <cfqueryparam value="#getcerts.ca_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfmailparam file="/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/PFX/#getcerts.pfx_certificate_name#">
</cfif>

</cfmail>
