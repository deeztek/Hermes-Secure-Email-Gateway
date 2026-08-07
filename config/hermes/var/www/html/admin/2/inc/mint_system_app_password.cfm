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

<!---
Mints (or re-mints) the "Hermes System" app password for one mailbox.

This is the credential Nextcloud Mail presents to Dovecot on the user's behalf.
The user never sees it. Dovecot authenticates IMAP and SMTP only against
app_passwords, so the account's login password can never serve this purpose.

Only the ARGON2ID hash is stored, so an existing row's plaintext cannot be
recovered. Any caller that needs the plaintext (to hand to
`occ mail:account:create`) must re-mint, which is what this does.

Input:
    mintAppPwUser            mailbox username / email address

Output:
    mintedAppPasswordPlain   the new plaintext, or "" if minting failed
    mintedAppPasswordError   error message when it failed, else ""

Failure is non-fatal by design: callers decide whether a missing credential
should abort their own work. See docs/admin/authentication/01-credential-model.md
--->

<cfparam name="mintAppPwUser" default="">
<cfset mintedAppPasswordPlain = "">
<cfset mintedAppPasswordError = "">

<cfif Trim(mintAppPwUser) EQ "">
    <cfset mintedAppPasswordError = "mint_system_app_password.cfm called with an empty mintAppPwUser">
<cfelse>
    <cftry>
        <!--- Ambiguous characters (0/O, 1/l/I) are excluded: this value gets
             copied into Nextcloud's mail account store and occasionally read
             by a human during support. --->
        <cfset _sysPwAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789">
        <cfset _sysPwLen = Len(_sysPwAlphabet)>
        <cfset _sysPwPlain = "">
        <cfloop from="1" to="30" index="_sysPwIdx">
            <cfset _sysPwPlain &= Mid(_sysPwAlphabet, RandRange(1, _sysPwLen, "SHA1PRNG"), 1)>
        </cfloop>

        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #_sysPwPlain#"
            variable="_sysPwHash"
            timeout="60" />
        <cfset _sysPwHash = Trim(_sysPwHash)>

        <cfif _sysPwHash EQ "" OR NOT FindNoCase("{ARGON2ID}", _sysPwHash)>
            <cfthrow message="doveadm pw returned unexpected output: #_sysPwHash#">
        </cfif>

        <!--- Re-mint in place when a system row already exists. It is minted
             unconditionally at mailbox creation, so on an existing mailbox the
             row is normally present but its plaintext is unrecoverable. Clearing
             revoked_at reinstates a row an admin had revoked. --->
        <cfquery name="_sysPwExisting" datasource="hermes">
            SELECT id FROM app_passwords
            WHERE username = <cfqueryparam value="#mintAppPwUser#" cfsqltype="cf_sql_varchar">
              AND is_system = 1
            ORDER BY id ASC
        </cfquery>

        <cfif _sysPwExisting.recordcount GTE 1>
            <cfquery datasource="hermes">
                UPDATE app_passwords
                SET password   = <cfqueryparam value="#_sysPwHash#" cfsqltype="cf_sql_varchar">,
                    revoked_at = NULL
                WHERE id = <cfqueryparam value="#_sysPwExisting.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <!--- Collapse duplicates: only one system credential per mailbox is
                 meaningful, and a stale extra would authenticate forever. --->
            <cfif _sysPwExisting.recordcount GT 1>
                <cfquery datasource="hermes">
                    DELETE FROM app_passwords
                    WHERE username = <cfqueryparam value="#mintAppPwUser#" cfsqltype="cf_sql_varchar">
                      AND is_system = 1
                      AND id <> <cfqueryparam value="#_sysPwExisting.id#" cfsqltype="cf_sql_integer">
                </cfquery>
            </cfif>
        <cfelse>
            <cfquery datasource="hermes">
                INSERT INTO app_passwords (username, label, password, is_system)
                VALUES (
                    <cfqueryparam value="#mintAppPwUser#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Hermes System" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#_sysPwHash#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
                )
            </cfquery>
        </cfif>

        <cfset mintedAppPasswordPlain = _sysPwPlain>
    <cfcatch type="any">
        <cfset mintedAppPasswordPlain = "">
        <cfset mintedAppPasswordError = cfcatch.message>
    </cfcatch>
    </cftry>
</cfif>
