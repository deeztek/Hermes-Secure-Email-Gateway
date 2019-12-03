<cfparam name = "success" default = "0">
<cfparam name = "error" default = "0">
<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfldap action="query"
name="adresult"
attributes = "mail"
START="DN_NAME"
filter="(&(objectClass=User)(mail=*))"
server="SERVER_NAME"
port="389"
username="USER_NAME"
password="PASS_WORD">

==== LISTS STARTS ====<br>
<cfloop query="adresult">
<cfoutput>
#TRIM(mail)#<br>
<cfquery name="insertadimport" datasource="#datasource#">
insert into ad_import_temp
(recipient, applied, action)
values
('#TRIM(mail)#', '2', 'insert')
</cfquery>
</cfoutput>
</cfloop>
==== LIST ENDS ====<br>
<cfquery name="getadimport" datasource="#datasource#">
select * from ad_import_temp where applied='2' and action='insert'
</cfquery>

<cfloop query="getadimport">
<cfset success=#success#+1>
<cfset domainpart = #trim(ListGetAt(recipient, 2, "@"))#>
<cfquery name="checkdomain" datasource="#datasource#">
select domain from domains where domain='#domainpart#'
</cfquery>

<cfif #checkdomain.recordcount# GTE 1>
<cfoutput>
<cfquery name="checkentry" datasource="#datasource#">
select recipient from recipients where recipient='#recipient#'
</cfquery>
</cfoutput>

<cfif #checkentry.recordcount# LT 1>
<cfquery name="getlicensedusers" datasource="#datasource#">
select parameter, value from system_settings where parameter='users'
</cfquery>

<cfif #getlicensedusers.value# GTE 1>
<cfset usercount=#getlicensedusers.value#>
<cfelseif #getlicensedusers.value# LT 1>
<cfset usercount=0>
</cfif>

<cfquery name="countrecipients" datasource="#datasource#">
select count(recipient) as rcptcount from recipients where domain is NULL
</cfquery>

<cfif #countrecipients.rcptcount# GTE 1>
<cfset rcptcount=#countrecipients.rcptcount#>
<cfelseif #countrecipients.rcptcount# LT 1>
<cfset rcptcount=0>
</cfif>

<cfif #usercount# GTE #rcptcount#>


<cfoutput>

<cfquery name="getdefaultpolicy" datasource="#datasource#">
select policy_id, default_policy from spam_policies where default_policy='1'
</cfquery>

<cfif #getdefaultpolicy.recordcount# GTE 1>

<cfquery name="insert" datasource="#datasource#">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
values
('#getdefaultpolicy.policy_id#', '#LCase(recipient)#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>

<cfelse>

<cfquery name="insert" datasource="#datasource#">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
values
('7', '#LCase(recipient)#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>


<!-- /CFIF getdefaultpolicy.recordcount -->
</cfif>

<cfquery name="userrandom" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 24
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="userrandom">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as userrandom2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset userrandom3=#gettrans.userrandom2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfquery name="insertreport" datasource="#datasource#">
insert into user_settings
(id, email, report_enabled, report_frequency, password_set, train_bayes, download_msg)
values
('#userrandom3#', '#recipient#', 'YES', '24', '0', '0', '0')
</cfquery>

#recipient# -- DOES NOT EXIST<BR></cfoutput>

<cfelseif #usercount# LT #rcptcount#>
<cfset error=#error#+1>
<cfoutput>#recipient# -- BUY MORE LICENSES<BR></cfoutput>
</cfif>
<cfelseif #checkentry.recordcount# GTE 1>
<cfoutput>#recipient# -- EXISTS<BR></cfoutput>

</cfif>

<cfelseif #checkdomain.recordcount# LT 1>
<cfoutput>#recipient# --- NOT RELAYED DOMAIN<br></cfoutput>
<cfset error=#error#+1>
</cfif>
</cfloop>

<cfquery name="deleteadimport" datasource="#datasource#">
delete from ad_import_temp where applied='2' and action='insert'
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>


<cfquery name="dropusers" datasource="#datasource#">
drop table users
</cfquery>

<cfquery name="createusers" datasource="#datasource#">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="#datasource#">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="#datasource#">
alter table users change recipient email VARBINARY(255)
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfoutput>#error#</cfoutput>






