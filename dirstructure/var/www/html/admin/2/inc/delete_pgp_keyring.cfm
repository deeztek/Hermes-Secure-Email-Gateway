<cfif #url.type# is "1">

<cfquery name="getinfo" datasource="hermes">
select * from recipients where id='#getkeys.user_id#'
</cfquery>

<cfelseif #url.type# is "2">

<cfquery name="getinfo" datasource="hermes">
select * from external_recipients where id='#getkeys.user_id#'
</cfquery>

<!--- /CFIF #url.type# is "1"/"2" --->
</cfif>
    
    <cfif #getinfo.recordcount# GTE 1>
    
    <cfif #getkeys.master# is "1">
    <cfset thekeytype="master">
    <cfelseif #getkeys.master# is "0">
    <cfset thekeytype="sub">
    </cfif>
    
    
    <cfelseif #getinfo.recordcount# LT 1>

<cfset m="Delete Recipient Keyring: getinfo.recordcount LT 1">
<cfinclude template="error.cfm">
<cfabort>

<!--- /CFIF #getinfo.recordcount# LT 1 --->
    </cfif>
    
    <cfif #thekeytype# is "master">
    
    <cfquery name="getkeystoredetails" datasource="hermes">
    select id, pgp_fingerprint, pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#form.keyring_id#'
    </cfquery>
    
    <cfquery name="getchildren" datasource="hermes">
    select id, pgp_fingerprint,  pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where parent  = '#getkeystoredetails.id#'
    </cfquery>
    
    <cfloop query="getchildren">
    
    <cfquery name="getchildkeystoredetails" datasource="hermes">
    select id, pgp_fingerprint,  pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#id#'
    </cfquery>
    
    <cfquery name="getpgpcmid" datasource="djigzo">
    select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletepgpnamevalues" datasource="djigzo">
    delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
    </cfquery>
    
    <cfquery name="deletetrustlist" datasource="djigzo">
    delete from cm_pgp_trust_list where cm_fingerprint = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletekeystore" datasource="djigzo">
    delete from cm_keystore where cm_alias = 'PGP:#getchildkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletecmkeyringuserid" datasource="djigzo">
    delete from cm_keyring_userid where cm_keyring_id = '#getchildkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    
    <cfquery name="deletecmkeyringemail" datasource="djigzo">
    delete from cm_keyring_email where cm_keyring_id = '#getchildkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deletecmkeyring" datasource="djigzo">
    delete from cm_keyring where cm_id = '#getchildkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deleterecipientkeystore" datasource="hermes">
    delete from recipient_keystores where pgp_fingerprint_sha256 = '#getchildkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    </cfloop>
    
    <cfquery name="getpgpcmid" datasource="djigzo">
    select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletepgpnamevalues" datasource="djigzo">
    delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
    </cfquery>
    
    <cfquery name="deletetrustlist" datasource="djigzo">
    delete from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletekeystore" datasource="djigzo">
    delete from cm_keystore where cm_alias = 'PGP:#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletecmkeyringuserid" datasource="djigzo">
    delete from cm_keyring_userid where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    
    <cfquery name="deletecmkeyringemail" datasource="djigzo">
    delete from cm_keyring_email where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deletecmkeyring" datasource="djigzo">
    delete from cm_keyring where cm_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deleterecipientkeystore" datasource="hermes">
    delete from recipient_keystores where pgp_fingerprint_sha256 = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <!-- DELETE FROM GNUPG STARTS HERE -->
    
    <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    
    <cffile action="read" file="/opt/hermes/scripts/delete_gpg_master_key.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
        output = "#REReplace("#temp#","THE_KEY","#getkeystoredetails.pgp_fingerprint#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
    timeout = "60">
    </cfexecute>
    
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
    timeout = "240"
    variable="thekeyemail2"
    arguments="-inputformat none">
    </cfexecute>
    
    <!-- delete /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh -->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF FiletoDelete --->
    </cfif>
    
    <!-- DELETE FROM GNUPG ENDS HERE -->
    
    <cfelseif #thekeytype# is "sub">
    
    <cfquery name="getkeystoredetails" datasource="hermes">
    select id, pgp_fingerprint, pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where id  = '#form.keyring_id#'
    </cfquery>
    
    <cfquery name="getpgpcmid" datasource="djigzo">
    select cm_id from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletepgpnamevalues" datasource="djigzo">
    delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
    </cfquery>
    
    <cfquery name="deletetrustlist" datasource="djigzo">
    delete from cm_pgp_trust_list where cm_fingerprint = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletekeystore" datasource="djigzo">
    delete from cm_keystore where cm_alias = 'PGP:#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <cfquery name="deletecmkeyringuserid" datasource="djigzo">
    delete from cm_keyring_userid where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    
    <cfquery name="deletecmkeyringemail" datasource="djigzo">
    delete from cm_keyring_email where cm_keyring_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deletecmkeyring" datasource="djigzo">
    delete from cm_keyring where cm_id = '#getkeystoredetails.djigzo_keystore_id#'
    </cfquery>
    
    <cfquery name="deleterecipientkeystore" datasource="hermes">
    delete from recipient_keystores where pgp_fingerprint_sha256 = '#getkeystoredetails.pgp_fingerprint_sha256#'
    </cfquery>
    
    <!-- SINCE THERE IS NO WAY TO DELETE SUB KEY FROM GNUPG WITHOUT INTERACTIVE PROMPTS, WE DON'T DELETE FROM GNUPG FOR A SUB KEY -->
    
    <!-- /CFIF thekeytype -->
    </cfif>
    
