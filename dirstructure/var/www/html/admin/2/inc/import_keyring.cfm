
   <cfif #form.keytype# is "public">
    
    <!--- IMPORT PUBLIC KEY INTO DJIGZO STARTS HERE --->
    
    <cffile action="read" file="/opt/hermes/scripts/import_pgp_public_key.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
        output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
    timeout = "60">
    </cfexecute>
    
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh"
    timeout = "240"
    variable="commandoutput"
    arguments="-inputformat none">
    </cfexecute>
    
    <!--- Delete /opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_public_key.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <cfif FindNoCase("key ring file does not exist or is not a file", commandoutput)>
    

    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>

    
     <cfset step=0>
    <cfset session.m = 9>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

   
    <cfelse>

    <cfset step=2>
    
    
    <!--- /CFIF FindNoCase --->
    </cfif>
    
    
    <!--- IMPORT PUBLIC KEY INTO DJIGZO ENDS HERE --->
    
    
    <cfelseif #form.keytype# is "private">
    
    <!--- IMPORT PRIVATE KEY INTO DJIGZO STARTS HERE --->
    
    <cffile action="read" file="/opt/hermes/scripts/import_pgp_private_key.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
        output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
        
    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
        output = "#REReplace("#temp#","THE-PASSWORD","#form.password1#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
    timeout = "60">
    </cfexecute>
    
    <cftry>
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh"
    timeout = "240"
    variable="commandoutput"
    arguments="-inputformat none">
    </cfexecute>
    
    <cfcatch>
    
    <cfif FindNoCase("checksum mismatch", cfcatch.Detail)>
    

    <!--- Delete /opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF fileExists(FiletoDelete) --->
    </cfif>

    
   <cfset step=0>
    <cfset session.m = 11>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

      
    <!--- <cfdump var="#cfcatch#" abort /> --->
    
    <!--- /CFIF FindNoCase --->
    </cfif>
    
    </cfcatch>
    
    
    </cftry>
    
    <!--- Delete /opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_private_key.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">
    
    <!--- /CFIF fileExists(FiletoDelete) --->
    </cfif>
    
    <cfif FindNoCase("key ring file does not exist or is not a file", commandoutput)>
    

    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>


    <cfset step=0>
    <cfset session.m = 9>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

    
    <cfelse>

    <cfset step=2>
    
    <!--- /CFIF FindNoCase --->
    </cfif>
    
    <!--- IMPORT PRIVATE KEY INTO DJIGZO ENDS HERE --->
    
    <!--- /cfif for form.keytype --->
    </cfif>
    
    
    <cfif #step# is "2">
    
    <cfif #form.keytype# is "public">

    <cfquery name="checkexistsdjigzo" datasource="djigzo">
    select cm_id from cm_keyring where cm_keyidhex='#thekeyid#'
    </cfquery>
    
    <cfif #checkexistsdjigzo.recordcount# GTE 1>

    <cfset step=3>

    <cfelseif #checkexistsdjigzo.recordcount# LT 1>

        <cfset step=0>
        <cfset session.m = 14>
        <cfoutput>
        <cflocation url="#cgi.http_referer#" addtoken="no">
        </cfoutput>
        <cfabort>

      <!--- /cfif for checkexistsdjigzo.recordcount --->
    </cfif>
    
    <cfelseif #form.keytype# is "private">

    <cfquery name="checkexistsdjigzo" datasource="djigzo">
    select cm_private_key_alias from cm_keyring where cm_keyidhex='#thekeyid#'
    </cfquery>
    
 

    <cfif #checkexistsdjigzo.cm_private_key_alias# is "">

        <cfset step=0>
        <cfset session.m = 13>
        <cfoutput>
        <cflocation url="#cgi.http_referer#" addtoken="no">
        </cfoutput>
        <cfabort>

    <cfelse>

    <cfset step=3>
 
    <!--- /cfif for checkexistsdjigzo.cm_private_key_alias --->
    </cfif>
    
    <!--- /cfif for form.keytype --->
    </cfif>
    
    <!--- /cfif for step --->
    </cfif>
    
    <cfif #step# is "3">
    
    
    <!--- IMPORT KEY INTO GNUPG KEYSTORE STARTS HERE --->
    
    <cffile action="read" file="/opt/hermes/scripts/import_pgp_key_gnupg.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
        output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
    timeout = "60">
    </cfexecute>
    
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh"
    timeout = "240"
    variable="commandoutput"
    arguments="-inputformat none">
    </cfexecute>
    
    <!--- delete /opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_pgp_key_gnupg.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>   

    
    <!--- IMPORT KEY INTO GNUPG KEYSTORE ENDS HERE --->
    
    <cfset step=4>
    
    <!--- /cfif for step --->
    </cfif>
    
    <cfif #step# is "4">
    
    <!--- INSERT KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES STARTS HERE --->
    
    <cfquery name="getkeyprint" datasource="djigzo">
    select * from cm_keyring where cm_keyidhex='#thekeyid#'
    </cfquery>
    
    <!--- QUERY GETKEYUSERID TO BE USED TO INSERT INTO THE USER_NAME FIELD IN THE RECIPIENT_KEYSTORES TABLE IN HERMES FURTHER DOWN --->
    <cfif #getkeyprint.cm_master# is "1">

    <cfquery name="getkeyuserid" datasource="djigzo">
    select cm_userid from cm_keyring_userid where cm_keyring_id='#getkeyprint.cm_id#'
    </cfquery>

    <cfelseif #getkeyprint.cm_master# is "0">

    <cfquery name="getkeyuserid" datasource="djigzo">
    select cm_userid from cm_keyring_userid where cm_keyring_id='#getkeyprint.cm_parentid#'
    </cfquery>

    <!--- /CFIF FOR getkeyprint.cm_master IS 1 --->
    </cfif>
    
    <cfquery name="ctlexists" datasource="djigzo">
    select cm_fingerprint from cm_pgp_trust_list where cm_fingerprint='#getkeyprint.cm_sha256fingerprint#'
    </cfquery>
    
    <cfif #ctlexists.recordcount# LT 1>
    
    <cfoutput>
    <cfquery name="insertctl" datasource="djigzo">
    insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#getkeyprint.cm_sha256fingerprint#')
    </cfquery>
    
    <cfquery name="getctl" datasource="djigzo">
    select cm_id from cm_pgp_trust_list where cm_fingerprint='#getkeyprint.cm_sha256fingerprint#'
    </cfquery>
    
    <cfquery name="insertctlnamevalues" datasource="djigzo">
    insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctl.cm_id#', 'trusted','status')
    </cfquery>
    
    </cfoutput>
    
    <!--- /CFIF FOR ctlexists.recordcount --->
    </cfif>
    
    <!--- INSERT KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES ENDS HERE --->
    
    
    <cfset step=5>
    
    <!--- /cfif for step --->
    </cfif>
    
    
    <cfif #step# is "5">
    
    <!--- GET KEY SIZE STARTS HERE --->
    
    <cffile action="read" file="/opt/hermes/scripts/get_pgp_key_size.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
        output = "#REReplace("#temp#","THE_KEY","#getkeyprint.cm_keyidhex#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
    timeout = "60">
    </cfexecute>
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh"
    timeout = "240"
    variable="thekeysize"
    arguments="-inputformat none">
    </cfexecute>
    
    <cfif FindNoCase("Total number processed: 0", thekeysize)>
    
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <cfset session.m = 13>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

  
    <cfelseif FindNoCase("key not found", thekeysize)>
    

    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>

    
    <cfset session.m = 13>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>
    
    </cfif>
    

    <!--- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh --->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_size.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>

        
    <!--- GET KEY SIZE ENDS HERE --->
    
    <cfset step=6>
    
    <!--- /cfif for step --->
    </cfif>
    
    
    <cfif #step# is "6">
    
    
    
    <!--- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE STARTS HERE --->
    
    <cfif #getkeyprint.cm_master# is "1">
    
    <cfquery name="getparentdjigzokeyring" datasource="djigzo">
    select * from cm_keyring where cm_id='#getkeyprint.cm_id#' and cm_master='1'
    </cfquery>
    
    <cfquery name="getchilddjigzokeyring" datasource="djigzo">
    select * from cm_keyring where cm_parentid='#getkeyprint.cm_id#' and cm_master='0'
    </cfquery>
    
    <cfelseif #getkeyprint.cm_master# is "0">
    
    <cfquery name="getparentdjigzokeyring" datasource="djigzo">
    select * from cm_keyring where cm_id='#getkeyprint.cm_parentid#' and cm_master='1'
    </cfquery>
    
    <cfquery name="getchilddjigzokeyring" datasource="djigzo">
    select * from cm_keyring where cm_parentid='#getkeyprint.cm_parentid#' and cm_master='0'
    </cfquery>
    
    </cfif>
    
    <cfif #form.keytype# is "public">

    <cfquery name="keystoreexists" datasource="hermes">
    select * from recipient_keystores where pgp_key_id='#thekeyid#'
    </cfquery>
    
    <cfif #keystoreexists.recordcount# LT 1>
    
    <cfif #getkeyprint.cm_expiration_date# is not "">
    <cfset pgp_keystore_expiration_date = #DateFormat(getkeyprint.cm_expiration_date, "yyyy-mm-dd")#>
    <cfset pgp_keystore_expiration_time = #TimeFormat(getkeyprint.cm_expiration_date, "HH:mm:ss")#>
    <cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">
    <cfelseif #getkeyprint.cm_expiration_date# is "">
    <cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
    </cfif>
    
    <cfif #url.type# is "1">
    <cfset external=2>
    <cfelseif #url.type# is "2">
    <cfset external=1>
    </cfif>
    
    <cfset pgp_keystore_creation_date = #DateFormat(getkeyprint.cm_creation_date, "yyyy-mm-dd")#>
    <cfset pgp_keystore_creation_time = #TimeFormat(getkeyprint.cm_creation_date, "HH:mm:ss")#>
    <cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">
    
    <cfoutput>
    <cfquery name="insert" datasource="hermes">
    insert into recipient_keystores
    (user_id, user_name, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
     djigzo_keystore_id, master, external)
    values
    ('#url.id#', '#getkeyuserid.cm_userid#', '#thekeysize#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#getparentdjigzokeyring.cm_keyidhex#', '#getparentdjigzokeyring.cm_id#', '1', '#external#')
    </cfquery>
    </cfoutput>
    
    <cfloop query="getchilddjigzokeyring">
    <cfoutput>
    
    <cfquery name="gethermesparent" datasource="hermes">
    select id, pgp_fingerprint, pgp_key_id from recipient_keystores where pgp_key_id = '#getparentdjigzokeyring.cm_keyidhex#'
    </cfquery>
    
    <cfquery name="insert" datasource="hermes">
    insert into recipient_keystores
    (user_id, user_name, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
     djigzo_keystore_id, master, parent, external)
    values
    ('#url.id#', '#getkeyuserid.cm_userid#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
     '#thekeysize#', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#gethermesparent.id#', '#external#')
    </cfquery>
    </cfoutput>
    </cfloop>
    
    <!--- /CFIF for keystoreexists.recordcount --->
    </cfif>
    
    <cfelseif #form.keytype# is "private">

    <cfquery name="keystoreexists" datasource="hermes">
    select * from recipient_keystores where pgp_key_id='#thekeyid#'
    </cfquery>
    
    <cfif #keystoreexists.recordcount# LT 1>
    
    <cfif #getkeyprint.cm_expiration_date# is not "">
    <cfset pgp_keystore_expiration_date = #DateFormat(getkeyprint.cm_expiration_date, "yyyy-mm-dd")#>
    <cfset pgp_keystore_expiration_time = #TimeFormat(getkeyprint.cm_expiration_date, "HH:mm:ss")#>
    <cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">
    <cfelseif #getkeyprint.cm_expiration_date# is "">
    <cfset pgp_keystore_expiration = "9999-01-01 12:00:00">
    </cfif>
    
    <cfif #url.type# is "1">
    <cfset external=2>
    <cfelseif #url.type# is "2">
    <cfset external=1>
    </cfif>
    
    <cfset pgp_keystore_creation_date = #DateFormat(getkeyprint.cm_creation_date, "yyyy-mm-dd")#>
    <cfset pgp_keystore_creation_time = #TimeFormat(getkeyprint.cm_creation_date, "HH:mm:ss")#>
    <cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">
    
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
    
    <!--- ENCRYPT PASSWORD --->
    <cfset encryptedPassword=encrypt(form.password1, #theKey#, "AES", "Base64")>
    
    <cfoutput>
    <cfquery name="insert" datasource="hermes">
    insert into recipient_keystores
    (user_id, user_name, pgp_keystore_password, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
     djigzo_keystore_id, master, external)
    values
    ('#url.id#', '#getkeyuserid.cm_userid#', '#encryptedPassword#', '#thekeysize#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
     '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#getparentdjigzokeyring.cm_keyidhex#', '#getparentdjigzokeyring.cm_id#', '1', '#external#')
    </cfquery>
    </cfoutput>
    
    <cfloop query="getchilddjigzokeyring">
    <cfoutput>
    
    <cfquery name="gethermesparent" datasource="hermes">
    select id, pgp_fingerprint, pgp_key_id from recipient_keystores where pgp_key_id = '#getparentdjigzokeyring.cm_keyidhex#'
    </cfquery>
    
    <cfquery name="insert" datasource="hermes">
    insert into recipient_keystores
    (user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
     djigzo_keystore_id, master, parent, external)
    values
    ('#url.id#', '#getkeyuserid.cm_userid#', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#',
     '#thekeysize#', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#gethermesparent.id#', '#external#')
    </cfquery>
    </cfoutput>
    </cfloop>
    
    <cfset form.password1="">
    <cfset encryptedPassword="">
    
    <!--- Since it's possible for the keystore to exist in recipient_keystores but not have the password for the private key, we check to see if the
     checkkeyidexists.recordcount from above is LT 1. If so, we simply update the password field --->
     
    <cfelseif #keystoreexists.recordcount# GTE 1>
    
    <cfif #checkkeyidexists.recordcount# LT 1>
    
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
    
    <!--- ENCRYPT PASSWORD --->
    <cfset encryptedPassword=encrypt(form.password1, #theKey#, "AES", "Base64")>
    
    
    <cfquery name="updatepasswordparent" datasource="hermes">
    update recipient_keystores set pgp_keystore_password='#encryptedPassword#' where pgp_key_id='#getparentdjigzokeyring.cm_keyidhex#'
    </cfquery>
    
    <cfloop query="getchilddjigzokeyring">
    <cfoutput>
    <cfquery name="updatepasswordchild" datasource="hermes">
    update recipient_keystores set pgp_keystore_password='#encryptedPassword#' where pgp_key_id='#cm_keyidhex#'
    </cfquery>
    </cfoutput>
    </cfloop>
    
    <cfset form.password1="">
    <cfset encryptedPassword="">
    
    <!--- /CFIF for checkkeyidexists.recordcount --->
    </cfif>
    
    <!--- /CFIF for keystoreexists.recordcount --->
    </cfif>
    
    <!--- /CFIF for form.keytype --->
    </cfif>
    
   
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>

    
    <!--- /cfif for step --->
    </cfif>