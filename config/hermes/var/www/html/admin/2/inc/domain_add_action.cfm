<!---
Hermes Secure Email Gateway - Domain Add Action Handler
Creates a new domain with transport, sender, and recipient records.
Expects: form.domain_name, form.delivery_method, form.recipient_delivery,
  form.destination_address, form.destination_port, form.destination_mx,
  form.destination_authentication, form.destination_username, form.destination_password
--->

<!--- Validate domain name --->
<cfif NOT StructKeyExists(form, "domain_name") OR trim(form.domain_name) is "">
  <cfset session.m = 10>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfset domain_name = LCase(trim(form.domain_name))>

<cfset tempemail = "bob@#domain_name#">
<cfif NOT IsValid("email", tempemail)>
  <cfset session.m = 11>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<!--- Check if domain already exists --->
<cfquery name="checkexists" datasource="hermes">
  SELECT id FROM domains WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
</cfquery>

<cfif checkexists.recordcount GTE 1>
  <cfset session.m = 12>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<!--- Validate delivery method --->
<cfparam name="form.delivery_method" default="smtp">
<cfif NOT ListFindNoCase("smtp,discard", form.delivery_method)>
  <cfset session.m = 20>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfparam name="form.recipient_delivery" default="OK">
<cfparam name="form.destination_address" default="smtp.#domain_name#">
<cfparam name="form.destination_port" default="25">
<cfparam name="form.destination_mx" default="NO">
<cfparam name="form.destination_authentication" default="NO">

<cfif form.delivery_method is "smtp">

  <!--- Validate destination --->
  <cfif trim(form.destination_address) is "">
    <cfset session.m = 13>
    <cflocation url="view_domains.cfm" addtoken="no">
  </cfif>

  <cfif NOT isValid("integer", form.destination_port)>
    <cfset session.m = 14>
    <cflocation url="view_domains.cfm" addtoken="no">
  </cfif>

  <cfset destination_address = LCase(trim(form.destination_address))>

  <!--- Handle authentication --->
  <cfset authUsername = "">
  <cfset authPassword = "">

  <cfif form.destination_authentication is "YES">
    <cfif NOT StructKeyExists(form, "destination_username") OR trim(form.destination_username) is "">
      <cfset session.m = 16>
      <cflocation url="view_domains.cfm" addtoken="no">
    </cfif>
    <cfif NOT StructKeyExists(form, "destination_password") OR trim(form.destination_password) is "">
      <cfset session.m = 17>
      <cflocation url="view_domains.cfm" addtoken="no">
    </cfif>

    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
    <cfset authUsername = encrypt(form.destination_username, theKey, "AES", "Base64")>
    <cfset authPassword = encrypt(form.destination_password, theKey, "AES", "Base64")>
    <cfset form.destination_mx = "NO">
  </cfif>

  <!--- Build transport string --->
  <cfif form.destination_mx is "NO">
    <cfset transportStr = "smtp:[#destination_address#]:#form.destination_port#">
  <cfelse>
    <cfset transportStr = "smtp:#destination_address#:#form.destination_port#">
  </cfif>

  <!--- Insert transport --->
  <cfquery name="addTransport" datasource="hermes" result="transResult">
    INSERT INTO transport (domain, transport, destination, method, port, mx, authentication, authentication_username, authentication_password)
    VALUES (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#transportStr#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#destination_address#">,
      'smtp',
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.destination_port#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.destination_mx#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.destination_authentication#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#authUsername#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#authPassword#">
    )
  </cfquery>

<cfelse>
  <!--- Discard delivery --->
  <cfquery name="addTransport" datasource="hermes" result="transResult">
    INSERT INTO transport (domain, transport, destination, method, port, mx, authentication)
    VALUES (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
      'discard:Discard Email Silently', '', 'discard', '25', 'NO', 'NO'
    )
  </cfquery>
</cfif>

<!--- Insert sender --->
<cfquery name="addSender" datasource="hermes" result="sendersResult">
  INSERT INTO senders (sender, action) VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">, 'OK'
  )
</cfquery>

<!--- Insert recipient --->
<cfquery name="addRecipient" datasource="hermes" result="recResult">
  INSERT INTO recipients (recipient, domain, status) VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="@#domain_name#">, '1',
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.recipient_delivery#">
  )
</cfquery>

<!--- Insert domain --->
<cfquery datasource="hermes">
  INSERT INTO domains (domain, transport_id, senders_id, recipients_id, action_taken) VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#transResult.GENERATED_KEY#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#sendersResult.GENERATED_KEY#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#recResult.GENERATED_KEY#">,
    'OK'
  )
</cfquery>

<!--- Regenerate configs --->
<cfset datasource = "hermes">
<cfinclude template="./generate_transports.cfm">
<cfinclude template="./generate_relay_domains.cfm">

<!--- Sync SASL parameters and regenerate sasl_passwd --->
<cfinclude template="./sync_sasl_parameters.cfm">
<cfinclude template="./generate_sasl_password_transport.cfm">

<!--- Auto-manage TLS policy for domains with auth --->
<cfparam name="form.enforce_tls" default="0">
<cfif form.destination_authentication is "YES" AND form.enforce_tls is "1">
  <cfquery name="checkTlsPolicy" datasource="hermes">
    SELECT id FROM tls_policies WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
  </cfquery>
  <cfif checkTlsPolicy.recordcount EQ 0>
    <cfquery datasource="hermes">
      INSERT INTO tls_policies (domain, method, description, applied, action)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
        'encrypt',
        'Auto-added: domain requires authentication',
        '1', 'add'
      )
    </cfquery>
  </cfif>
  <cfinclude template="./generate_tls_policy.cfm">
</cfif>

<!--- Generate Postfix configuration and reload --->
<cfinclude template="./generate_postfix_configuration.cfm">

<!--- Add domain to Ciphermail --->
<cfset theNewDomain = domain_name>
<cfinclude template="./add_domain_djigzo.cfm">

<cfset session.m = 8>
<cflocation url="view_domains.cfm" addtoken="no">
