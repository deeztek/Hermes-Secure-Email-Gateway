<!---
Hermes Secure Email Gateway - Domain Edit Action Handler
Validates and updates domain settings across domains, transport, senders, recipients tables.
Expects: form.domain_id, form.domain_name, form.delivery_method, form.recipient_delivery,
  form.destination_address, form.destination_port, form.destination_mx,
  form.destination_authentication, form.destination_username, form.destination_password
--->

<!--- Validate domain_id --->
<cfif NOT StructKeyExists(form, "domain_id") OR NOT isValid("integer", form.domain_id)>
  <cfset session.m = 20>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfset theDomainID = form.domain_id>

<!--- Get existing domain and linked records --->
<cfquery name="getdomain" datasource="hermes">
  SELECT id, domain, transport_id, senders_id, recipients_id FROM domains
  WHERE id = <cfqueryparam value="#theDomainID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getdomain.recordcount LT 1>
  <cfset session.m = 20>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfset theOriginalDomain = getdomain.domain>
<cfset theTransportID = getdomain.transport_id>
<cfset theSenderID = getdomain.senders_id>
<cfset theRecipientID = getdomain.recipients_id>

<!--- Domain name is immutable — use existing value from database --->
<cfset domain_name = theOriginalDomain>

<!--- Validate delivery method --->
<cfparam name="form.delivery_method" default="smtp">
<cfif NOT ListFindNoCase("smtp,discard", form.delivery_method)>
  <cfset session.m = 20>
  <cflocation url="view_domains.cfm" addtoken="no">
</cfif>

<cfif form.delivery_method is "smtp">

  <!--- Validate destination address --->
  <cfif NOT StructKeyExists(form, "destination_address") OR trim(form.destination_address) is "">
    <cfset session.m = 13>
    <cflocation url="view_domains.cfm" addtoken="no">
  </cfif>

  <cfset destination_address = LCase(trim(form.destination_address))>

  <!--- Validate destination port --->
  <cfif NOT StructKeyExists(form, "destination_port") OR NOT isValid("integer", form.destination_port)>
    <cfset session.m = 14>
    <cflocation url="view_domains.cfm" addtoken="no">
  </cfif>

  <!--- Validate recipient delivery --->
  <cfparam name="form.recipient_delivery" default="OK">
  <cfparam name="form.destination_mx" default="NO">
  <cfparam name="form.destination_authentication" default="NO">

  <!--- Handle authentication --->
  <cfif form.destination_authentication is "YES">

    <!--- Validate username --->
    <cfif NOT StructKeyExists(form, "destination_username") OR trim(form.destination_username) is "">
      <cfset session.m = 16>
      <cflocation url="view_domains.cfm" addtoken="no">
    </cfif>

    <!--- Get existing transport for password check --->
    <cfquery name="getExistingTransport" datasource="hermes">
      SELECT authentication_password FROM transport
      WHERE id = <cfqueryparam value="#theTransportID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- If password blank, keep existing (unless no existing password) --->
    <cfparam name="form.destination_password" default="">
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
    <cfset encryptedUsername = encrypt(form.destination_username, theKey, "AES", "Base64")>

    <cfif trim(form.destination_password) is not "">
      <!--- New password provided --->
      <cfset encryptedPassword = encrypt(form.destination_password, theKey, "AES", "Base64")>
    <cfelseif getExistingTransport.authentication_password is not "">
      <!--- Keep existing password --->
      <cfset encryptedPassword = getExistingTransport.authentication_password>
    <cfelse>
      <!--- No existing password and none provided --->
      <cfset session.m = 17>
      <cflocation url="view_domains.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
      UPDATE transport SET
        authentication = 'YES',
        authentication_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encryptedUsername#">,
        authentication_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encryptedPassword#">
      WHERE id = <cfqueryparam value="#theTransportID#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Force MX off when using auth --->
    <cfset form.destination_mx = "NO">
  <cfelse>
    <!--- Clear auth fields --->
    <cfquery datasource="hermes">
      UPDATE transport SET authentication = 'NO'
      WHERE id = <cfqueryparam value="#theTransportID#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfif>

  <!--- Sync SASL parameters and regenerate sasl_passwd --->
  <cfinclude template="./sync_sasl_parameters.cfm">
  <cfinclude template="./generate_sasl_password_transport.cfm">

  <!--- Build transport string --->
  <cfif form.destination_mx is "NO">
    <cfset transportStr = "#form.delivery_method#:[#destination_address#]:#form.destination_port#">
  <cfelse>
    <cfset transportStr = "#form.delivery_method#:#destination_address#:#form.destination_port#">
  </cfif>

  <!--- Update transport --->
  <cfquery datasource="hermes">
    UPDATE transport SET
      domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
      transport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#transportStr#">,
      destination = <cfqueryparam cfsqltype="cf_sql_varchar" value="#destination_address#">,
      method = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.delivery_method#">,
      port = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.destination_port#">,
      mx = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.destination_mx#">
    WHERE id = <cfqueryparam value="#theTransportID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Update recipient --->
  <cfquery datasource="hermes">
    UPDATE recipients SET
      recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="@#domain_name#">,
      domain = '1',
      status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.recipient_delivery#">
    WHERE id = <cfqueryparam value="#theRecipientID#" cfsqltype="cf_sql_integer">
  </cfquery>

<cfelseif form.delivery_method is "discard">

  <!--- Update transport for discard --->
  <cfquery datasource="hermes">
    UPDATE transport SET
      domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
      transport = 'discard:Discard Email Silently',
      destination = '',
      method = 'discard',
      port = '25',
      mx = 'NO'
    WHERE id = <cfqueryparam value="#theTransportID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Update recipient --->
  <cfquery datasource="hermes">
    UPDATE recipients SET
      recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="@#domain_name#">,
      domain = '1'
    WHERE id = <cfqueryparam value="#theRecipientID#" cfsqltype="cf_sql_integer">
  </cfquery>

</cfif>

<!--- Update sender --->
<cfquery datasource="hermes">
  UPDATE senders SET sender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">, action = 'OK'
  WHERE id = <cfqueryparam value="#theSenderID#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Update domain --->
<cfquery datasource="hermes">
  UPDATE domains SET domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
  WHERE id = <cfqueryparam value="#theDomainID#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Auto-manage TLS policy for domains with auth --->
<cfparam name="form.enforce_tls" default="0">
<cfif form.delivery_method is "smtp" AND form.destination_authentication is "YES" AND form.enforce_tls is "1">
  <!--- Add to TLS policy if not already there --->
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
<cfelseif form.delivery_method is "smtp" AND (form.destination_authentication is "NO" OR form.enforce_tls is "0")>
  <!--- Remove auto-added TLS policy if auth or TLS was disabled --->
  <cfquery datasource="hermes">
    DELETE FROM tls_policies
    WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
      AND description = 'Auto-added: domain requires authentication'
  </cfquery>
</cfif>

<!--- Regenerate configs --->
<cfset datasource = "hermes">
<cfinclude template="./generate_relay_domains.cfm">
<cfinclude template="./generate_transports.cfm">
<cfinclude template="./generate_tls_policy.cfm">

<!--- Generate Postfix configuration and reload --->
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 9>
<cflocation url="view_domains.cfm" addtoken="no">
