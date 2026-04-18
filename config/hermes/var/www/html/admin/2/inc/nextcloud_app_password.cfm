
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NEXTCLOUD APP PASSWORD MANAGEMENT
Creates, updates, or deletes a Nextcloud app password for a mailbox user.
The app password is named "Hermes System" and allows DAV clients
(calendar/contacts/files) to authenticate using the same password as email.

How it works:
  1. Creates an app password token via occ user:auth-tokens:add
  2. Computes SHA-512(ldap_password + nc_secret) where nc_secret is from config.php
  3. Updates oc_authtoken.token with the computed hash and renames to "Hermes System"
  4. The user's email password now works for DAV authentication

Requires the following variables before including:
  - ncAppPasswordAction: "create", "update", or "delete"
  - ncAppPasswordUser: Nextcloud username (email address)
  - ncAppPasswordValue: plaintext password (required for create/update)

Sets after execution:
  - ncAppPasswordResult: "success", "error", or "skipped"
  - ncAppPasswordError: error message (if any)

Non-fatal: failures are caught and logged but do not block the calling action.
--->

<cfparam name="ncAppPasswordAction" default="">
<cfparam name="ncAppPasswordUser" default="">
<cfparam name="ncAppPasswordValue" default="">

<cfset ncAppPasswordResult = "skipped">
<cfset ncAppPasswordError = "">
<cfset ncAppPasswordName = "Hermes System">

<cfif ncAppPasswordAction EQ "" OR ncAppPasswordUser EQ "">
    <!--- Nothing to do --->

<cfelseif ncAppPasswordAction EQ "delete">

    <!--- DELETE: Remove all app passwords named "Hermes System" for this user --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list #ncAppPasswordUser# --output=json"
            variable="listResult"
            errorVariable="listError"
            timeout="30" />

        <cfif Len(trim(listResult)) GT 0 AND IsJSON(trim(listResult))>
            <cfset tokenList = DeserializeJSON(trim(listResult))>
            <cfif IsArray(tokenList)>
                <cfloop array="#tokenList#" index="tokenData">
                    <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenData.id#"
                            variable="delResult"
                            errorVariable="delError"
                            timeout="30" />
                    </cfif>
                </cfloop>
            <cfelseif IsStruct(tokenList)>
                <cfloop collection="#tokenList#" item="tokenId">
                    <cfset tokenData = tokenList[tokenId]>
                    <cfif IsStruct(tokenData) AND StructKeyExists(tokenData, "name") AND tokenData.name EQ ncAppPasswordName>
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tokenId#"
                            variable="delResult"
                            errorVariable="delError"
                            timeout="30" />
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>
        <cfset ncAppPasswordResult = "success">
    <cfcatch type="any">
        <cfset ncAppPasswordResult = "error">
        <cfset ncAppPasswordError = cfcatch.message>
    </cfcatch>
    </cftry>

<cfelseif ncAppPasswordAction EQ "create" OR ncAppPasswordAction EQ "update">

    <cfif ncAppPasswordValue EQ "">
        <cfset ncAppPasswordResult = "skipped">
    <cfelse>
        <cftry>
            <!--- Step 1: If updating, delete existing "Hermes System" tokens first --->
            <cfif ncAppPasswordAction EQ "update">
                <cfset savedAction = ncAppPasswordAction>
                <cfset savedValue = ncAppPasswordValue>
                <cfset ncAppPasswordAction = "delete">
                <!--- Inline delete instead of recursive include --->
                <cftry>
                    <cfexecute name="/usr/local/bin/docker"
                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:list #ncAppPasswordUser# --output=json"
                        variable="listResult2"
                        errorVariable="listError2"
                        timeout="30" />
                    <cfif Len(trim(listResult2)) GT 0 AND IsJSON(trim(listResult2))>
                        <cfset tokenList2 = DeserializeJSON(trim(listResult2))>
                        <cfif IsArray(tokenList2)>
                            <cfloop array="#tokenList2#" index="td2">
                                <cfif IsStruct(td2) AND StructKeyExists(td2, "name") AND td2.name EQ ncAppPasswordName>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #td2.id#"
                                        variable="dr2" errorVariable="de2" timeout="30" />
                                </cfif>
                            </cfloop>
                        <cfelseif IsStruct(tokenList2)>
                            <cfloop collection="#tokenList2#" item="tid2">
                                <cfset td2 = tokenList2[tid2]>
                                <cfif IsStruct(td2) AND StructKeyExists(td2, "name") AND td2.name EQ ncAppPasswordName>
                                    <cfexecute name="/usr/local/bin/docker"
                                        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:delete #ncAppPasswordUser# #tid2#"
                                        variable="dr2" errorVariable="de2" timeout="30" />
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfif>
                <cfcatch type="any"><!--- ignore delete errors ---></cfcatch>
                </cftry>
                <cfset ncAppPasswordAction = savedAction>
                <cfset ncAppPasswordValue = savedValue>
            </cfif>

            <!--- Step 2: Create a new app password via occ.
                 Use --password-from-env to embed the login password in the token. --->
            <cfinclude template="generate_customtrans.cfm">
            <cfset appPwdScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_app_pwd.sh">
            <cfscript>
                fileWrite(appPwdScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    'docker exec -e OC_PASS="' & ncAppPasswordValue & '" -u www-data hermes_nextcloud php /var/www/html/occ user:auth-tokens:add "' & ncAppPasswordUser & '" --password-from-env' & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #appPwdScript#" timeout="10" />
            <cfexecute name="#appPwdScript#"
                variable="occResult"
                errorVariable="occError"
                timeout="30" />
            <cftry><cffile action="delete" file="#appPwdScript#"><cfcatch type="any"></cfcatch></cftry>

            <!--- Step 3: Read NC secret from config.php for token hash --->
            <cffile action="read" file="/mnt/data/nextcloud/config/config.php" variable="ncConfigContent" charset="utf-8">
            <cfset secretMatch = REFind("'secret'\s*=>\s*'([^']*)'", ncConfigContent, 1, true)>
            <cfif secretMatch.pos[1] GT 0>
                <cfset ncSecret = Mid(ncConfigContent, secretMatch.pos[2], secretMatch.len[2])>
            <cfelse>
                <cfthrow message="Could not read NC secret from config.php">
            </cfif>

            <!--- Step 4: Compute SHA-512(password + secret) --->
            <cfscript>
                msgDigest = createObject("java", "java.security.MessageDigest").getInstance("SHA-512");
                inputBytes = (ncAppPasswordValue & ncSecret).getBytes("UTF-8");
                msgDigest.update(inputBytes);
                hashBytes = msgDigest.digest();
                sb = createObject("java", "java.lang.StringBuilder");
                for (b in hashBytes) {
                    sb.append(createObject("java", "java.lang.String").format("%02x",
                        [createObject("java", "java.lang.Integer").valueOf(bitAnd(b, 255))]));
                }
                tokenHash = sb.toString();
            </cfscript>

            <!--- Step 5: Update oc_authtoken — set token hash and rename to "Hermes System".
                 Uses docker exec mysql since the nextcloud datasource is not available
                 in the CFML application context. --->
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_username" variable="ncDbUser" charset="utf-8">
            <cfset ncDbUser = Trim(ncDbUser)>
            <cffile action="read" file="/opt/hermes/creds/nextcloud_mysql_password" variable="ncDbPass" charset="utf-8">
            <cfset ncDbPass = Trim(ncDbPass)>

            <cfinclude template="generate_customtrans.cfm">
            <cfset updateScript = "/opt/hermes/tmp/" & customtrans3 & "_nc_token_update.sh">
            <cfscript>
                fileWrite(updateScript,
                    chr(35) & "!/bin/bash" & chr(10) &
                    "docker exec hermes_db_server mysql -u """ & ncDbUser & """ -p""" & ncDbPass & """ nextcloud -e """ &
                    "UPDATE oc_authtoken SET token='" & tokenHash & "', name='Hermes System' " &
                    "WHERE uid='" & ncAppPasswordUser & "' AND name='cli' ORDER BY id DESC LIMIT 1;" &
                    """" & chr(10),
                    "utf-8");
            </cfscript>
            <cfexecute name="/bin/chmod" arguments="+x #updateScript#" timeout="10" />
            <cfexecute name="#updateScript#"
                variable="updateResult"
                errorVariable="updateError"
                timeout="30" />
            <cftry><cffile action="delete" file="#updateScript#"><cfcatch type="any"></cfcatch></cftry>

            <cfset ncAppPasswordResult = "success">

        <cfcatch type="any">
            <cfset ncAppPasswordResult = "error">
            <cfset ncAppPasswordError = cfcatch.message & " | " & cfcatch.detail>
        </cfcatch>
        </cftry>
    </cfif>

</cfif>
