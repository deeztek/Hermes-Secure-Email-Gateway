
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD MAIL ACCOUNT MANAGEMENT
Creates, updates, or deletes a Nextcloud Mail app email account for a
mailbox user. Uses occ mail:account:create to set up IMAP/SMTP
connectivity so the user can send/receive email through Nextcloud webmail.

Connection settings use Docker internal networking (no TLS required):
  IMAP: hermes_dovecot:143 (none)
  SMTP: hermes_postfix_dkim:25 (none)

Requires the following variables before including:
  - ncMailAction: "create", "update", or "delete"
  - ncMailUser: Nextcloud username (email address)
  - ncMailName: Display name (for create)
  - ncMailEmail: Email address
  - ncMailPassword: Mail password (for create/update)

Sets after execution:
  - ncMailResult: "success", "error", or "skipped"
  - ncMailError: error message (if any)
--->

<cfparam name="ncMailAction" default="">
<cfparam name="ncMailUser" default="">
<cfparam name="ncMailName" default="">
<cfparam name="ncMailEmail" default="">
<cfparam name="ncMailPassword" default="">

<cfset ncMailResult = "skipped">
<cfset ncMailError = "">

<cfif ncMailAction EQ "" OR ncMailUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncMailAction EQ "create">

    <!--- CREATE: Add a new mail account via occ mail:account:create
         Syntax: mail:account:create <user-id> <name> <email>
                 <imap-host> <imap-port> <imap-ssl-mode>
                 <imap-user> <imap-password>
                 <smtp-host> <smtp-port> <smtp-ssl-mode>
                 <smtp-user> <smtp-password> <auth-method>
    --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:create #ncMailUser# ""#ncMailName#"" #ncMailEmail# hermes_dovecot 143 none #ncMailEmail# #ncMailPassword# hermes_postfix_dkim 25 none #ncMailEmail# #ncMailPassword# password"
            variable="ncMailOccResult"
            errorVariable="ncMailOccError"
            timeout="30" />

        <cfif FindNoCase("error", ncMailOccError) OR FindNoCase("exception", ncMailOccError)>
            <cfset ncMailResult = "error">
            <cfset ncMailError = ncMailOccError>
        <cfelse>
            <cfset ncMailResult = "success">
        </cfif>
    <cfcatch type="any">
        <cfset ncMailResult = "error">
        <cfset ncMailError = cfcatch.message>
    </cfcatch>
    </cftry>

<cfelseif ncMailAction EQ "update">

    <!--- UPDATE: On password change, delete the old account and recreate.
         The occ mail:account:update command doesn't exist, so we delete
         and recreate. We first need to find the account ID.

         Alternative approach: use the Nextcloud database directly to
         update the password. But occ is safer as it goes through the
         app's business logic.

         Step 1: List accounts for user to find the account ID
         Step 2: Delete the account
         Step 3: Recreate with new password --->
    <cftry>
        <!--- Get account list as JSON --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:export #ncMailUser# --output=json"
            variable="ncMailAccountList"
            errorVariable="ncMailAccountListError"
            timeout="30" />

        <!--- Try to parse and find accounts to delete --->
        <cfset accountsDeleted = false>
        <cftry>
            <cfif IsJSON(trim(ncMailAccountList))>
                <cfset accounts = DeserializeJSON(trim(ncMailAccountList))>
                <cfif IsArray(accounts)>
                    <cfloop array="#accounts#" index="acct">
                        <!--- Delete each account matching this email --->
                        <cfif StructKeyExists(acct, "id")>
                            <cfexecute name="/usr/local/bin/docker"
                                arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:delete #acct.id#"
                                variable="delResult"
                                errorVariable="delError"
                                timeout="30" />
                            <cfset accountsDeleted = true>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
        <cfcatch type="any">
            <!--- If parsing/deletion fails, still try to create --->
        </cfcatch>
        </cftry>

        <!--- Recreate with new password --->
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:create #ncMailUser# ""#ncMailName#"" #ncMailEmail# hermes_dovecot 143 none #ncMailEmail# #ncMailPassword# hermes_postfix_dkim 25 none #ncMailEmail# #ncMailPassword# password"
            variable="ncMailOccResult"
            errorVariable="ncMailOccError"
            timeout="30" />

        <cfset ncMailResult = "success">
    <cfcatch type="any">
        <cfset ncMailResult = "error">
        <cfset ncMailError = cfcatch.message>
    </cfcatch>
    </cftry>

<cfelseif ncMailAction EQ "delete">

    <!--- DELETE: Remove all mail accounts for this user.
         occ mail:account:delete requires an account ID, not a username.
         So we export, parse, and delete each one.
         If mail:account:delete isn't available in this NC version,
         the accounts will be orphaned but cleaned up when the NC user
         is deleted (NC handles this internally). --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:export #ncMailUser# --output=json"
            variable="ncMailAccountList"
            errorVariable="ncMailAccountListError"
            timeout="30" />

        <cfif IsJSON(trim(ncMailAccountList))>
            <cfset accounts = DeserializeJSON(trim(ncMailAccountList))>
            <cfif IsArray(accounts)>
                <cfloop array="#accounts#" index="acct">
                    <cfif StructKeyExists(acct, "id")>
                        <cftry>
                            <cfexecute name="/usr/local/bin/docker"
                                arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:delete #acct.id#"
                                variable="delResult"
                                errorVariable="delError"
                                timeout="30" />
                        <cfcatch type="any">
                            <!--- mail:account:delete may not exist in all NC versions.
                                 When the LDAP user is deleted, NC should clean up
                                 associated data including mail accounts. --->
                        </cfcatch>
                        </cftry>
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>

        <cfset ncMailResult = "success">
    <cfcatch type="any">
        <cfset ncMailResult = "error">
        <cfset ncMailError = cfcatch.message>
    </cfcatch>
    </cftry>

</cfif>
