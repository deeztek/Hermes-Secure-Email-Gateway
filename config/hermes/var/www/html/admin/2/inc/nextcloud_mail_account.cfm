
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
        <cfinclude template="generate_customtrans.cfm">

        <!--- Read NC DB creds for pre/post-flight verification. --->
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncMailDbUser" charset="utf-8">
        <cfset ncMailDbUser = Trim(ncMailDbUser)>
        <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncMailDbPass" charset="utf-8">
        <cfset ncMailDbPass = Trim(ncMailDbPass)>

        <!--- 1. PRE-FLIGHT: count existing oc_mail_accounts rows for
             this user + email. Should usually be 0 for a fresh mailbox
             but tolerates reprovisioning. --->
        <cfset _mailPreScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_mail_pre.sh">
        <cfscript>
            fileWrite(_mailPreScript,
                chr(35) & "!/bin/bash" & chr(10) &
                "docker exec hermes_db_server mariadb -u """ & ncMailDbUser & """ -p""" & ncMailDbPass & """ nextcloud -se """ &
                "SELECT COUNT(*) FROM oc_mail_accounts WHERE user_id='" & ncMailUser & "' AND email='" & ncMailEmail & "';" &
                """ 2>&1" & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #_mailPreScript#" timeout="10" />
        <cfset _mailPreResult = "">
        <cfexecute name="#_mailPreScript#" variable="_mailPreResult" timeout="30" />
        <cftry><cffile action="delete" file="#_mailPreScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfset _mailPreCount = -1>
        <cfloop array="#ListToArray(Trim(_mailPreResult), chr(10), false)#" index="_mLine">
            <cfset _mLine = Trim(_mLine)>
            <cfif IsNumeric(_mLine)><cfset _mailPreCount = _mLine><cfbreak></cfif>
        </cfloop>

        <!--- 2. CREATE the mail account via occ. Use temp script to
             handle special characters in password/name. --->
        <cfset ncMailScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_mail_create.sh">
        <cfset ncMailCmd = 'docker exec -u www-data hermes_nextcloud php /var/www/html/occ mail:account:create "' &
                ncMailUser & '" "' & ncMailName & '" "' & ncMailEmail &
                '" hermes_dovecot 143 none "' & ncMailEmail & '" "' & ncMailPassword &
                '" hermes_postfix_dkim 25 none "' & ncMailEmail & '" "' & ncMailPassword & '" password'>
        <cfscript>
            fileWrite(ncMailScript,
                chr(35) & "!/bin/bash" & chr(10) & ncMailCmd & chr(10),
                "utf-8");
            fileWrite("/opt/hermes/tmp/nc_mail_debug.log",
                "Action: " & ncMailAction & chr(10) &
                "User: " & ncMailUser & chr(10) &
                "Name: " & ncMailName & chr(10) &
                "Email: " & ncMailEmail & chr(10) &
                "Password length: " & Len(ncMailPassword) & chr(10) &
                "Script: " & ncMailScript & chr(10) &
                "Command: " & ncMailCmd & chr(10) &
                "Pre-flight oc_mail_accounts count: " & _mailPreCount & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #ncMailScript#" timeout="10" />
        <cfexecute name="#ncMailScript#"
            variable="ncMailOccResult"
            errorVariable="ncMailOccError"
            timeout="30" />
        <cffile action="delete" file="#ncMailScript#">

        <!--- 3. POST-FLIGHT: count again. Must equal _mailPreCount + 1
             for the create to be considered successful — independent of
             what occ wrote to stdout/stderr. --->
        <cfset _mailPostScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_mail_post.sh">
        <cfscript>
            fileWrite(_mailPostScript,
                chr(35) & "!/bin/bash" & chr(10) &
                "docker exec hermes_db_server mariadb -u """ & ncMailDbUser & """ -p""" & ncMailDbPass & """ nextcloud -se """ &
                "SELECT COUNT(*) FROM oc_mail_accounts WHERE user_id='" & ncMailUser & "' AND email='" & ncMailEmail & "';" &
                """ 2>&1" & chr(10),
                "utf-8");
        </cfscript>
        <cfexecute name="/bin/chmod" arguments="+x #_mailPostScript#" timeout="10" />
        <cfset _mailPostResult = "">
        <cfexecute name="#_mailPostScript#" variable="_mailPostResult" timeout="30" />
        <cftry><cffile action="delete" file="#_mailPostScript#"><cfcatch type="any"></cfcatch></cftry>
        <cfset _mailPostCount = -1>
        <cfloop array="#ListToArray(Trim(_mailPostResult), chr(10), false)#" index="_mLine">
            <cfset _mLine = Trim(_mLine)>
            <cfif IsNumeric(_mLine)><cfset _mailPostCount = _mLine><cfbreak></cfif>
        </cfloop>

        <cfscript>
            fileAppend("/opt/hermes/tmp/nc_mail_debug.log",
                "occ STDOUT: " & ncMailOccResult & chr(10) &
                "occ STDERR: " & ncMailOccError & chr(10) &
                "Post-flight oc_mail_accounts count: " & _mailPostCount & chr(10) &
                "---" & chr(10),
                "utf-8");
        </cfscript>

        <cfif _mailPreCount GTE 0 AND _mailPostCount EQ _mailPreCount + 1>
            <cfset ncMailResult = "success">
        <cfelse>
            <cfset ncMailResult = "error">
            <cfset ncMailError = "occ mail:account:create did not commit a row. preflight=" & _mailPreCount & ", postflight=" & _mailPostCount & " (expected preflight+1). occ STDOUT: " & Left(ncMailOccResult, 300) & " / occ STDERR: " & Left(ncMailOccError, 300)>
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
