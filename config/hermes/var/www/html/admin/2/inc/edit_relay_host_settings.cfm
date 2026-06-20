
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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

<!--- Get relay host parent parameter ID --->
<cfquery name="get_relayhost_id" datasource="hermes">
SELECT id FROM parameters WHERE parameter='relayhost' AND child = '2'
</cfquery>

<!--- Get smtp_sasl_auth_enable parent ID --->
<cfquery name="get_smtp_sasl_auth_enable_id" datasource="hermes">
SELECT id FROM parameters WHERE parameter='smtp_sasl_auth_enable' AND child = '2'
</cfquery>

<!--- Get smtp_sasl_password_maps parent ID --->
<cfquery name="get_smtp_sasl_password_maps_id" datasource="hermes">
SELECT id FROM parameters WHERE parameter='smtp_sasl_password_maps' AND child = '2'
</cfquery>

<!--- Get smtp_tls_security_level parent ID (outbound TLS for relay) --->
<cfquery name="get_smtp_tls_security_level_id" datasource="hermes">
SELECT id FROM parameters WHERE parameter='smtp_tls_security_level' AND child = '2'
</cfquery>

<!--- Check if relay host is enabled or disabled --->
<cfif StructKeyExists(form, "relay_enabled") AND form.relay_enabled is "1">
    <!--- RELAY HOST ENABLED --->

    <!--- Enable relayhost parent parameter --->
    <cfquery name="enablerelayhostparent" datasource="hermes">
    UPDATE parameters
    SET
        enabled='1',
        applied='2',
        action='APPLY'
    WHERE id='#get_relayhost_id.id#'
    </cfquery>

    <!--- Update relayhost child parameter with hostname and port --->
    <cfquery name="updaterelayhost" datasource="hermes">
    UPDATE parameters
    SET
        parameter='[#form.relayhost#]:#form.relayhost_port#',
        name='#form.relayhost#',
        enabled='1',
        applied='2',
        action='APPLY'
    WHERE parent='#get_relayhost_id.id#'
    AND child='1'
    </cfquery>

    <!--- OUTBOUND TLS SETTING --->
    <cfif get_smtp_tls_security_level_id.recordcount GT 0>
        <cfif form.relayhost_tls_mode is not "">
            <!--- TLS enabled - enable parent and set child value --->
            <cfquery name="enabletlsparent" datasource="hermes">
            UPDATE parameters
            SET
                enabled='1',
                applied='2',
                action='APPLY'
            WHERE id='#get_smtp_tls_security_level_id.id#'
            </cfquery>

            <cfquery name="updatetlschild" datasource="hermes">
            UPDATE parameters
            SET
                parameter='#form.relayhost_tls_mode#',
                enabled='1',
                applied='2',
                action='APPLY'
            WHERE parent_name='smtp_tls_security_level'
            AND child='1'
            </cfquery>
        <cfelse>
            <!--- TLS disabled - disable parent and child --->
            <cfquery name="disabletlsparent" datasource="hermes">
            UPDATE parameters
            SET
                enabled='0',
                applied='2',
                action='APPLY'
            WHERE id='#get_smtp_tls_security_level_id.id#'
            </cfquery>

            <cfquery name="disabletlschild" datasource="hermes">
            UPDATE parameters
            SET
                enabled='0',
                applied='2',
                action='APPLY'
            WHERE parent_name='smtp_tls_security_level'
            AND child='1'
            </cfquery>
        </cfif>
    </cfif>

    <!--- Check if authentication is required --->
    <cfif StructKeyExists(form, "relay_authenticate") AND form.relay_authenticate is "1">
        <!--- AUTHENTICATION REQUIRED --->

        <!--- Enable smtp_sasl_auth_enable parent parameter --->
        <cfquery name="enableauthparent" datasource="hermes">
        UPDATE parameters
        SET
            enabled='1',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_auth_enable_id.id#'
        </cfquery>

        <!--- Enable smtp_sasl_auth child and set to yes --->
        <cfquery name="enableauth" datasource="hermes">
        UPDATE parameters
        SET
            parameter='yes',
            enabled='1',
            applied='2',
            action='APPLY'
        WHERE parent='#get_smtp_sasl_auth_enable_id.id#'
        AND child='1'
        </cfquery>

        <!--- Enable smtp_sasl_password_maps parent parameter --->
        <cfquery name="enablepassmapsparent" datasource="hermes">
        UPDATE parameters
        SET
            enabled='1',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_password_maps_id.id#'
        </cfquery>

        <!--- Clear plaintext credentials from parameters (legacy) --->
        <cfquery name="updateuserpass" datasource="hermes">
        UPDATE parameters
        SET
            name='',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_password_maps_id.id#'
        </cfquery>

        <!--- Encrypt and store credentials in system_settings --->
        <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
        <cfset encryptedRelayUsername = encrypt(form.relayhost_username, theKey, "AES", "Base64")>
        <cfset encryptedRelayPassword = encrypt(form.relayhost_password, theKey, "AES", "Base64")>

        <cfquery datasource="hermes">
          UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encryptedRelayUsername#">
          WHERE parameter = 'relay_host_username'
        </cfquery>
        <cfquery datasource="hermes">
          UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#encryptedRelayPassword#">
          WHERE parameter = 'relay_host_password'
        </cfquery>

        <!--- Enable smtp_sasl_password_maps child parameter --->
        <cfquery name="enablepassmapschild" datasource="hermes">
        UPDATE parameters
        SET
            enabled='1',
            applied='2',
            action='APPLY'
        WHERE parent='#get_smtp_sasl_password_maps_id.id#'
        AND child='1'
        </cfquery>

        <!--- Generate consolidated sasl_passwd (relay host + per-domain auth) --->
        <cfinclude template="generate_sasl_password_transport.cfm">

    <cfelse>
        <!--- AUTHENTICATION NOT REQUIRED --->

        <!--- Disable smtp_sasl_auth_enable parent parameter --->
        <cfquery name="disableauthparent" datasource="hermes">
        UPDATE parameters
        SET
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_auth_enable_id.id#'
        </cfquery>

        <!--- Disable smtp_sasl_auth child and set to no --->
        <cfquery name="disableauth" datasource="hermes">
        UPDATE parameters
        SET
            parameter='no',
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE parent='#get_smtp_sasl_auth_enable_id.id#'
        AND child='1'
        </cfquery>

        <!--- Disable smtp_sasl_password_maps parent parameter --->
        <cfquery name="disablepassmapsparent" datasource="hermes">
        UPDATE parameters
        SET
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_password_maps_id.id#'
        </cfquery>

        <!--- Clear plaintext credentials from parameters (legacy) --->
        <cfquery name="clearuserpass" datasource="hermes">
        UPDATE parameters
        SET
            name='',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_sasl_password_maps_id.id#'
        </cfquery>

        <!--- Clear encrypted credentials from system_settings --->
        <cfquery datasource="hermes">
          UPDATE system_settings SET value = '' WHERE parameter = 'relay_host_username'
        </cfquery>
        <cfquery datasource="hermes">
          UPDATE system_settings SET value = '' WHERE parameter = 'relay_host_password'
        </cfquery>

        <!--- Disable smtp_sasl_password_maps child parameter --->
        <cfquery name="disablepassmapschild" datasource="hermes">
        UPDATE parameters
        SET
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE parent='#get_smtp_sasl_password_maps_id.id#'
        AND child='1'
        </cfquery>

        <!--- Regenerate sasl_passwd (removes relay host entry, keeps per-domain) --->
        <cfinclude template="generate_sasl_password_transport.cfm">

    <!--- /CFIF form.relay_authenticate --->
    </cfif>

<cfelse>
    <!--- RELAY HOST DISABLED --->

    <!--- Disable relayhost parent parameter --->
    <cfquery name="disablerelayhostparent" datasource="hermes">
    UPDATE parameters
    SET
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE id='#get_relayhost_id.id#'
    </cfquery>

    <!--- Clear relayhost child parameter and disable it --->
    <cfquery name="disablerelayhost" datasource="hermes">
    UPDATE parameters
    SET
        parameter='',
        name='',
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE parent='#get_relayhost_id.id#'
    AND child='1'
    </cfquery>

    <!--- Disable smtp_sasl_auth_enable parent parameter --->
    <cfquery name="disableauthparent" datasource="hermes">
    UPDATE parameters
    SET
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE id='#get_smtp_sasl_auth_enable_id.id#'
    </cfquery>

    <!--- Disable smtp_sasl_auth child --->
    <cfquery name="disableauth" datasource="hermes">
    UPDATE parameters
    SET
        parameter='no',
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE parent='#get_smtp_sasl_auth_enable_id.id#'
    AND child='1'
    </cfquery>

    <!--- Disable smtp_sasl_password_maps parent parameter --->
    <cfquery name="disablepassmapsparent" datasource="hermes">
    UPDATE parameters
    SET
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE id='#get_smtp_sasl_password_maps_id.id#'
    </cfquery>

    <!--- Clear plaintext credentials from parameters (legacy) --->
    <cfquery name="clearuserpass" datasource="hermes">
    UPDATE parameters
    SET
        name='',
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE id='#get_smtp_sasl_password_maps_id.id#'
    </cfquery>

    <!--- Clear encrypted credentials from system_settings --->
    <cfquery datasource="hermes">
      UPDATE system_settings SET value = '' WHERE parameter = 'relay_host_username'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE system_settings SET value = '' WHERE parameter = 'relay_host_password'
    </cfquery>

    <!--- Disable smtp_sasl_password_maps child parameter --->
    <cfquery name="disablepassmapschild" datasource="hermes">
    UPDATE parameters
    SET
        enabled='0',
        applied='2',
        action='APPLY'
    WHERE parent='#get_smtp_sasl_password_maps_id.id#'
    AND child='1'
    </cfquery>

    <!--- Disable outbound TLS setting --->
    <cfif get_smtp_tls_security_level_id.recordcount GT 0>
        <cfquery name="disabletlsparent" datasource="hermes">
        UPDATE parameters
        SET
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE id='#get_smtp_tls_security_level_id.id#'
        </cfquery>

        <cfquery name="disabletlschild" datasource="hermes">
        UPDATE parameters
        SET
            enabled='0',
            applied='2',
            action='APPLY'
        WHERE parent_name='smtp_tls_security_level'
        AND child='1'
        </cfquery>
    </cfif>

<!--- /CFIF form.relay_enabled --->
</cfif>
