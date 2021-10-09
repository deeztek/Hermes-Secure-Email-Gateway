<!--- CREATE CUSTOMTRANS BELOW --->
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

     <!--- CREATE CUSTOMTRANS ABOVE --->

<!--- GET ANY EXISTING CERTIFICATES FROM DJIGZO --->
<cfquery name="getdjigzocertificates" datasource="djigzo">
select * from cm_certificates_email where cm_email='#recipient#'
</cfquery>

<!--- IF CERTIFICATES EXIST DUMP THEM INTO THE TEMP_TABLE FOR LATER COMPARISON --->
<cfif #getdjigzocertificates.recordcount# GTE 1>

  <cfloop query="getdjigzocertificates">
  
  <cfoutput>
  <cfquery name="insertcerts" datasource="hermes">
  insert into temp_table 
  (session_id, djigzo_certificate_id, recipient_id)
  values
  ('#customtrans3#', '#cm_certificates_id#', '#form.recipient_id#')
  </cfquery>
  </cfoutput>
  
  </cfloop>

  <!--- /CFIF #getdjigzocertificates.recordcount# GTE 1 --->
  </cfif>

  <!--- SET CERTIFICATE EXPIRATION DATE --->
  <cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
  <cfset certexpires = DateAdd('d', #form.validity#, #datenow#)>
  <cfset certexpires =#DateFormat(certexpires,"yyyy-mm-dd")#>
  

  <cffile action="read" file="/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/serial" variable="currentserial2">
  <cfset currentserial = rereplace(currentserial2, "[[:space:]]", "", "all")>
  
  <cfset rcpt_name = rereplace(recipient, "[^A-Za-z0-9]+", "", "all")>


<cffile action="read" file="/opt/hermes/scripts/create_smime_certficate.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","CA-DIRECTORY","#getcadetails.ca_directory#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#recipient#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-ENCRYPTION","#form.encryption#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-ALGORITHM","#form.algorithm#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-VALIDITY","#form.validity#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#password1#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
    output = "#REReplace("#temp#","RCPT-NAME","#rcpt_name#_#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cfset filelocation  = "/opt/hermes/tmp/#customtrans3#_create_smime_certficate.sh">

<cfif fileExists(filelocation)>
<cffile action = "delete" file = "#filelocation#">
      
<!--- /CFIF fileExists(filelocation) --->
</cfif>
    
<cfset filelocation  = "/opt/hermes/CA/#getcadetails.ca_directory#/root_ca/newcerts/#currentserial#.pem">
    
<cfif fileExists(filelocation)>
<cffile action = "delete" file = "#filelocation#">

<!--- /CFIF fileExists(filelocation) --->
</cfif>

<!--- GET RECIPIENT CERTIFICATES FROM DJIGZO WHICH SHOULD INCLUDE THE NEW CERTIFICATE THAT WAS JUST ADDED --->
<cfquery name="getdjigzocertificates2" datasource="djigzo">
  select * from cm_certificates_email where cm_email='#recipient#'
  </cfquery>

<!--- IF NO CERTIFICATES EXIST THAT MEANS THERE WAS A PROBLEM ADDING THE CERTIFICATE TO DJIGZO SO THROW ERROR --->
<cfif #getdjigzocertificates2.recordcount# LT 1>


<cfset m="Create Recipient Certificate: getdjigzocertificates2.recordcount LT 1">
<cfinclude template="error.cfm">
<cfabort>

<cfelseif #getdjigzocertificates2.recordcount# GTE 1>

<!--- COMPARE AGAINST RECIPIENT CERTIFICATES THAT WERE INSERTED INTO THE TEMP TABLE PREVIOUSLY --->
  <cfloop query="getdjigzocertificates2">
  
  <cfquery name="exists" datasource="hermes">
  select djigzo_certificate_id, recipient_id, session_id from temp_table where session_id='#customtrans3#' 
  and recipient_id='#form.recipient_id#' and djigzo_certificate_id='#cm_certificates_id#'
  </cfquery>
  
  <!--- IF DOES NOT EXIST THEN THIS IS THE NEW CERTIFICATE SO GET THUMBPRINT AND CERTIFICATE ID IN ORDER TO INSERT INTO DJIGZO CERTIFICATE TRUST LIST TABLES (CM_CTL, CM_CTL_CM_NAME_VALUES) AND HERMES RECIPIENT_CERTIFICATES OR EXTERNAL_RECIPIENT_CERTIFICATES TABLES LATER  --->
  <cfif #exists.recordcount# LT 1>

  <cfquery name="getcertprint" datasource="djigzo">
  select cm_id, cm_thumbprint from cm_certificates where cm_id='#cm_certificates_id#'
  </cfquery>

  <cfset thumbprint="#getcertprint.cm_thumbprint#">
  <cfset djigzo_certificate_id="#getcertprint.cm_id#">

  <!--- /CFIF exists.recordcount LT 1 --->
  </cfif>

  </cfloop>


<!--- DELETE RECIPIENT CERTIFICATES THAT WERE INSERTED INTO THE TEMP TABLE PREVIOUSLY --->
  <cfquery name="deletetemp" datasource="hermes">
    delete from temp_table where session_id='#customtrans3#'
    </cfquery>
  
  <!--- GET THE MAXIMUM CM_ID FROM CM_CTL --->
  <cfquery name="getmax" datasource="djigzo">
  SELECT max(cm_id) as maxid FROM cm_ctl
  </cfquery>

  <!--- GENERATE NEXT CM_ID BY ADDING 1 TO THE PREVIOUS ID OR IF BLANK MAKE IT ZERO --->
  <cfif #getmax.maxid# is "">
  <cfset maxid2=0>
  <cfset nextid=#maxid2#+1>
  <cfelseif #getmax.maxid# is not "">
  <cfset nextid=#getmax.maxid#+1>

  <!--- /CFIF #getmax.maxid# is --->
  </cfif>
  
  <!--- INSERT INTO CM_CTL TABLE --->
  <cfquery name="insertctl" datasource="djigzo">
  insert into cm_ctl (cm_id, cm_name, cm_thumbprint) values ('#nextid#', 'global', '#thumbprint#')
  </cfquery>
  
  <!--- INSERT INTO CM_CTL_CM_NAME_VALUES TABLE --->
  <cfquery name="insertctlnamewhitelisted" datasource="djigzo">
  insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'whitelisted', 'status')
  </cfquery>
  
<!--- INSERT INTO CM_CTL_CM_NAME_VALUES TABLE --->
  <cfquery name="insertctlnameexpired" datasource="djigzo">
  insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('#nextid#', 'false', 'allowExpired')
  </cfquery>

<!--- GET HERMES.KEY --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(password1, #theKey#, "AES", "Base64")>

<!--- IF URL.TYPE IS 1 THEN INTERNAL RECIPIENT --->
<cfif #url.type# is "1">

  <cfquery name="insert" datasource="hermes">
    insert into recipient_certificates
    (user_id, ca_id, validity, encryption, algorithm, smime_certificate_key, smime_certificate_request, smime_certificate_name, pfx_certificate_name, smime_certificate_password, smime_certificate_expiration, serial, thumbprint, djigzo_certificate_id)
    values
    ('#form.recipient_id#', '#ca#', '#validity#', '#encryption#', '#algorithm#', '#rcpt_name#_#customtrans3#_key.pem', '#rcpt_name#_#customtrans3#.csr', '#rcpt_name#_#customtrans3#_cert.pem', '#rcpt_name#_#customtrans3#.pfx', '#encryptedPassword#', '#certexpires#', '#currentserial#', '#thumbprint#', '#djigzo_certificate_id#')
    </cfquery>

<!--- IF URL.TYPE IS 2 THEN EXTERNAL RECIPIENT --->
<cfelseif #url.type# is "2">

  <cfquery name="insert" datasource="hermes">
    insert into recipient_certificates
    (user_id, ca_id, validity, encryption, algorithm, smime_certificate_key, smime_certificate_request, smime_certificate_name, pfx_certificate_name, smime_certificate_password, smime_certificate_expiration, serial, thumbprint, djigzo_certificate_id, external)
    values
    ('#form.recipient_id#', '#ca#', '#validity#', '#encryption#', '#algorithm#', '#rcpt_name#_#customtrans3#_key.pem', '#rcpt_name#_#customtrans3#.csr', '#rcpt_name#_#customtrans3#_cert.pem', '#rcpt_name#_#customtrans3#.pfx', '#encryptedPassword#', '#certexpires#', '#currentserial#', '#thumbprint#', '#djigzo_certificate_id#', '1')
    </cfquery>
    
    <!--- /CFIF URL.TYPE IS "1" OR "2" --->
    </cfif>


<!--- /CFIF #getdjigzocertificates2.recordcount#  --->
</cfif> 
