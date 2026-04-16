<!---
Hermes Secure Email Gateway - Authentication Generate Secret Action Handler
Generates random secrets/keys for Authelia configuration.
Expects: form.action (generatejwtsecret, generatesessionsecret, etc.)
--->

<cfswitch expression="#action#">

  <cfcase value="generatejwtsecret">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/keys/authelia_identity_validation_reset_password_jwt_secret_file"
      output="#trim(customtrans3)#" addnewline="no">
    <cfset session.m = 28>
  </cfcase>

  <cfcase value="generatesessionsecret">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/keys/authelia_session_secret_file"
      output="#trim(customtrans3)#" addnewline="no">
    <cfset session.m = 29>
  </cfcase>

  <cfcase value="generateoidchmacsecret">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/keys/authelia_identity_providers_oidc_hmac_secret_file"
      output="#trim(customtrans3)#" addnewline="no">
    <cfset session.m = 42>
  </cfcase>

  <cfcase value="generateredispassword">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/keys/authelia_session_redis_password_file"
      output="#trim(customtrans3)#" addnewline="no">
    <cfset session.m = 41>
  </cfcase>

  <cfcase value="generateoidckey">
    <cftry>
      <cfexecute name="/usr/bin/openssl"
        arguments="genrsa -out /opt/hermes/keys/authelia_identity_providers_oidc_jwks_file 2048"
        timeout="60"
        variable="opensslOutput"
        errorVariable="opensslError" />
      <cfcatch type="any">
        <cfset m = "Error generating OIDC key: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
      </cfcatch>
    </cftry>
    <cfset session.m = 40>
  </cfcase>

  <cfcase value="generateoidcclientsecret">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cfset OidcClientSecret = trim(customtrans3)>

    <cffile action="write" file="/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_plain_file"
      output="#OidcClientSecret#" addnewline="no">

    <cftry>
      <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_authelia authelia crypto hash generate pbkdf2 --password #OidcClientSecret#"
        variable="OidcClientSecretDigest"
        timeout="60" />
      <cfcatch type="any">
        <cfset m = "Error generating OIDC client secret hash: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
      </cfcatch>
    </cftry>

    <cfset OidcClientSecretDigest = trim(REReplace(OidcClientSecretDigest, "Digest:", "", "ALL"))>
    <cffile action="write" file="/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_digest_file"
      output="#OidcClientSecretDigest#" addnewline="no">
    <cfset session.m = 42>
  </cfcase>

  <cfcase value="generatestorageencryptionkey">
    <cfset _transLength = 64>
    <cfinclude template="./generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/keys/authelia_storage_encryption_key_file"
      output="#trim(customtrans3)#" addnewline="no">
    <cfset session.m = 30>
  </cfcase>

</cfswitch>

<!--- Regenerate configs and restart Authelia to pick up new keys --->
<cfinclude template="./generate_authelia_configuration.cfm">
<cfinclude template="./restart_authelia.cfm">

<!--- If OIDC client secret changed, update the user_oidc provider in Nextcloud --->
<cfif action EQ "generateoidcclientsecret">
  <cffile action="read" file="/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_plain_file" variable="newOidcPlain">
  <cfset newOidcPlain = Trim(newOidcPlain)>
  <cfinclude template="generate_customtrans.cfm">
  <cfset oidcUpdateScript = "/opt/hermes/tmp/" & customtrans3 & "_oidc_update_secret.sh">
  <cfscript>
    fileWrite(oidcUpdateScript,
      chr(35) & "!/bin/bash" & chr(10) &
      "docker exec -u www-data hermes_nextcloud php /var/www/html/occ user_oidc:provider Hermes_SEG --clientsecret=""" & newOidcPlain & """" & chr(10),
      "utf-8");
  </cfscript>
  <cfexecute name="/bin/chmod" arguments="+x #oidcUpdateScript#" timeout="10" />
  <cfexecute name="#oidcUpdateScript#"
    variable="oidcUpdateResult"
    errorVariable="oidcUpdateError"
    timeout="30" />
  <cffile action="delete" file="#oidcUpdateScript#">
</cfif>

<cflocation url="view_authentication_settings.cfm" addtoken="no">
