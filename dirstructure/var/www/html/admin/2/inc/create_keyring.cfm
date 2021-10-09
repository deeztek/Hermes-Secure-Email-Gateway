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

<cfset rcpt_name = rereplace(getrecipientdetails.recipient, "[^A-Za-z0-9]+", "", "all")>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>

<!-- CREATE GPG TEMPLATE STARTS HERE -->

<cffile action="read" file="/opt/hermes/templates/gpg_template" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","KEY_LENGTH","#form.encryption#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","NAME_REAL","#form.realname#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","NAME_EMAIL","#getrecipientdetails.recipient#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_template" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_gpg_template"
    output = "#REReplace("#temp#","PASS_PHRASE","#password1#","ALL")#" addnewline="no">
    
<!--- CREATE GPG TEMPLATE ENDS HERE --->

<!--- CREATE_PGP_KEY SCRIPT STARTS HERE --->

<cffile action="read" file="/opt/hermes/scripts/create_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
    output = "#REReplace("#temp1#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh"
outputfile ="/opt/hermes/tmp/#customtrans3#_gpg_output"
timeout = "240"
arguments="-inputformat none">
</cfexecute>


<!--- DELETE CREATE_PGP_KEY --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_create_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>




<!--- DELETE GPG_TEMPLATE --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_gpg_template">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>

    
<!--- CREATE GPG SCRIPT ENDS HERE --->

<!--- CREATE_PGP_KEY SCRIPT ENDS HERE --->

<!--- EXPORT_IMPORT_PGP_KEY SCRIPT STARTS HERE --->

<cffile action="read" file="/opt/hermes/scripts/export_import_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
    output = "#REReplace("#temp1#","CUSTOM-TRANS","#customtrans3#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh" variable="temp1">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
    output = "#REReplace("#temp1#","THE-PASSWORD","#password1#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
outputfile ="/dev/null"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh"
outputfile ="/dev/null"
timeout = "240"
arguments="-inputformat none">
</cfexecute>

<!--- DELETE EXPORT_IMPORT_PGP_KEY --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_export_import_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>


<!--- DELETE public.key THAT THE EXPORT_IMPORT_PGP_KEY.SH SCRIPT CREATES --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_public.key">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>


<!--- DELETE private.key THAT THE EXPORT_IMPORT_PGP_KEY.SH SCRIPT CREATES --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_private.key">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>


<!--- EXPORT_IMPORT_PGP_KEY SCRIPT ENDS HERE --->

<!--- READ KEYID FROM _GPG_OUTPUT FILE --->
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_gpg_output" variable="theKeyID2">
<cfset theKeyID = #TRIM(theKeyID2)#>

<!--- DELETE _GPG_OUTPUT FILE --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_gpg_output">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>


<cfquery name="getparentdjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_keyidhex='#theKeyID#' and cm_master='1'
</cfquery>

<cfquery name="getchilddjigzokeyring" datasource="djigzo">
select * from cm_keyring where cm_parentid='#getparentdjigzokeyring.cm_id#' and cm_master='0'
</cfquery>

<!--- INSERT PARENT AND CHILD KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES STARTS HERE --->
<cfoutput>
<cfquery name="insertctlmaster" datasource="djigzo">
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#getparentdjigzokeyring.cm_sha256fingerprint#')
</cfquery>

<cfquery name="getctlmaster" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfquery name="insertctlmasternamevalues" datasource="djigzo">
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctlmaster.cm_id#', 'trusted','status')
</cfquery>

</cfoutput>



<cfloop query="getchilddjigzokeyring">
<cfoutput>
<cfquery name="insertctlchild" datasource="djigzo">
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp','#cm_sha256fingerprint#')
</cfquery>

<cfquery name="getctlchild" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint='#cm_sha256fingerprint#'
</cfquery>

<cfquery name="insertctlchildnamevalues" datasource="djigzo">
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values ('#getctlchild.cm_id#', 'trusted','status')
</cfquery>

</cfoutput>
</cfloop>

<!--- INSERT PARENT AND CHILD KEYRING IN CM_PGP_TRUST_LIST AND CM_PGP_TRUST_LIST_CM_NAME_VALUES ENDS HERE --->

<!--- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE STARTS HERE --->
<cfif #getparentdjigzokeyring.cm_expiration_date# is not "">
<cfset pgp_keystore_expiration_date = #DateFormat(getparentdjigzokeyring.cm_expiration_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_expiration_time = #TimeFormat(getparentdjigzokeyring.cm_expiration_date, "HH:mm:ss")#>
<cfset pgp_keystore_expiration = "#pgp_keystore_expiration_date# #pgp_keystore_expiration_time#">

<cfelseif #getparentdjigzokeyring.cm_expiration_date# is "">
<cfset pgp_keystore_expiration = "9999-01-01 12:00:00">

<!--- /CFIF #getparentdjigzokeyring.cm_expiration_date# --->
</cfif>

<cfset pgp_keystore_creation_date = #DateFormat(getparentdjigzokeyring.cm_creation_date, "yyyy-mm-dd")#>
<cfset pgp_keystore_creation_time = #TimeFormat(getparentdjigzokeyring.cm_creation_date, "HH:mm:ss")#>
<cfset pgp_keystore_creation = "#pgp_keystore_creation_date# #pgp_keystore_creation_time#">

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!--- ENCRYPT PASSWORD --->
<cfset encryptedPassword=encrypt(password1, #theKey#, "AES", "Base64")>

<cfif #type# is "1">

<cfif #pgp_keystore_expiration# is not "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration# is "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA',
 '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '1')
</cfquery>
</cfoutput>

<!--- /CFIF #pgp_keystore_expiration# --->
</cfif>

<cfquery name="getparentid" datasource="hermes">
select * from recipient_keystores where master='1' and pgp_fingerprint_sha256='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfloop query="getchilddjigzokeyring">

<cfif #pgp_keystore_expiration # is not "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, parent)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA',
 '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#')
</cfquery>
</cfoutput>

<!--- /CFIF #pgp_keystore_expiration# --->
</cfif>

</cfloop>

<cfelseif #type# is "2">

<cfif #pgp_keystore_expiration # is not "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, external)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA', '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '#getparentdjigzokeyring.cm_master#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA',
 '#getparentdjigzokeyring.cm_sha256fingerprint#', '#getparentdjigzokeyring.cm_fingerprint#', '#theKeyID#', '#getparentdjigzokeyring.cm_id#', '#getparentdjigzokeyring.cm_master#', '1')
</cfquery>
</cfoutput>

<!--- /CFIF #pgp_keystore_expiration# --->
</cfif>


<cfquery name="getparentid" datasource="hermes">
select * from recipient_keystores where master='1' and pgp_fingerprint_sha256='#getparentdjigzokeyring.cm_sha256fingerprint#'
</cfquery>

<cfloop query="getchilddjigzokeyring">

<cfif #pgp_keystore_expiration # is not "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id, djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_expiration#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA', '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#', '1')
</cfquery>
</cfoutput>

<cfelseif #pgp_keystore_expiration # is "">

<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_creation, encryption, algorithm, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('#url.id#', '#form.realname# <#getrecipientdetails.recipient#>', '#encryptedPassword#', '#pgp_keystore_creation#', '#form.encryption#', 'RSA',
 '#cm_sha256fingerprint#', '#cm_fingerprint#', '#cm_keyidhex#', '#cm_id#', '#cm_master#', '#getparentid.id#', '1')
</cfquery>
</cfoutput>

<!--- /CFIF #pgp_keystore_expiration# --->
</cfif>

</cfloop>

<!-- /CFIF for type -->
</cfif>

<!-- INSERT KEYRING INFO INTO HERMES RECIPIENT_KEYSTORES TABLE ENDS HERE -->

