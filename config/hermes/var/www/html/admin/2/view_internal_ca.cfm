<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Internal CA</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Internal Certificate Authority</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Internal CA</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m_ca") AND session.m_ca is not "">
  <cfset m = session.m_ca>
  <cfset session.m_ca = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ===================== --->
<!--- ACTION: CREATE CA    --->
<!--- ===================== --->
<cfif action is "create_ca">
  <cfparam name="form.ca_commonname" default="">
  <cfparam name="form.validity" default="1825">
  <cfparam name="form.encryption" default="4096">
  <cfparam name="form.organizationname" default="">
  <cfparam name="form.unitname" default="">
  <cfparam name="form.stateprovincename" default="">
  <cfparam name="form.countryname" default="">
  <cfparam name="form.make_default" default="">

  <cfset ca_cn = trim(form.ca_commonname)>
  <cfset ca_validity = trim(form.validity)>
  <cfset ca_encryption = trim(form.encryption)>
  <cfset ca_org = trim(form.organizationname)>
  <cfset ca_unit = trim(form.unitname)>
  <cfset ca_state = trim(form.stateprovincename)>
  <cfset ca_country = trim(form.countryname)>

  <!--- Validation --->
  <cfif ca_cn is "">
    <cfset session.m_ca = 1>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z0-9 ]", ca_cn) GT 0>
    <cfset session.m_ca = 2>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif ca_org is "">
    <cfset session.m_ca = 9>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z0-9, ]", ca_org) GT 0>
    <cfset session.m_ca = 10>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif ca_unit is "">
    <cfset session.m_ca = 11>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^_a-zA-Z0-9 ]", ca_unit) GT 0>
    <cfset session.m_ca = 12>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif ca_state is "">
    <cfset session.m_ca = 13>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z ]", ca_state) GT 0>
    <cfset session.m_ca = 14>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif ca_country is "" OR Len(ca_country) NEQ 2>
    <cfset session.m_ca = 15>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z]", ca_country) GT 0>
    <cfset session.m_ca = 16>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate CA name --->
  <cfquery name="checkca" datasource="hermes">
    SELECT COUNT(*) as cnt FROM ca_settings WHERE ca_commonname = <cfqueryparam value="#ca_cn#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkca.cnt GT 0>
    <cfset session.m_ca = 18>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <!--- Calculate expiration --->
  <cfset datenow = DateFormat(Now(), "yyyy-mm-dd")>
  <cfset certexpires = DateFormat(DateAdd("d", ca_validity, datenow), "yyyy-mm-dd")>

  <!--- Handle default setting --->
  <cfset ca_default = 2>
  <cfif form.make_default is "1">
    <cfset ca_default = 1>
    <cfquery datasource="hermes">
      UPDATE ca_settings SET default2 = '2'
    </cfquery>
  <cfelse>
    <!--- If no CAs exist, force this as default --->
    <cfquery name="checkAnyCA" datasource="hermes">
      SELECT COUNT(*) as cnt FROM ca_settings
    </cfquery>
    <cfif checkAnyCA.cnt EQ 0>
      <cfset ca_default = 1>
    </cfif>
  </cfif>

  <cfset ca_directory = REReplace(ca_cn, "[^A-Za-z0-9]+", "", "all")>

  <!--- Insert CA record --->
  <cfquery name="insertca" datasource="hermes" result="caResult">
    INSERT INTO ca_settings
    (validity, encryption, ca_commonname, organizationname, unitname, stateprovincename, countryname, applied, expires, default2, ca_directory)
    VALUES (
      <cfqueryparam value="#ca_validity#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_encryption#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_cn#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_org#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_unit#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_state#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_country#" cfsqltype="cf_sql_varchar">,
      '2',
      <cfqueryparam value="#certexpires#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_default#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_directory#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Generate CA using temp script --->
  <cfinclude template="./inc/generate_customtrans.cfm">

  <cfquery datasource="djigzo">
    DELETE FROM cm_certificates_tmp
  </cfquery>
  <cfquery datasource="djigzo">
    INSERT INTO cm_certificates_tmp SELECT * FROM cm_certificates
  </cfquery>

  <!--- Build the create_ca script with replacements --->
  <cffile action="read" file="/opt/hermes/scripts/create_ca.sh" variable="temp">
  <cfset temp = REReplace(temp, "SHOW-ENCRYPTION", ca_encryption, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-VALIDITY", ca_validity, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-COUNTRYNAME", ca_country, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-STATEPROVINCENAME", ca_state, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-ORGANIZATIONNAME", ca_org, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-UNITNAME", ca_unit, "ALL")>
  <cfset temp = REReplace(temp, "SHOW-CA-COMMONNAME", ca_cn, "ALL")>
  <cfset temp = REReplace(temp, "CUSTOM-TRANS", customtrans3, "ALL")>
  <cfset temp = REReplace(temp, "CA-DIRECTORY", ca_directory, "ALL")>
  <cffile action="write" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh" output="#temp#">

  <!--- Build the openssl.cnf template --->
  <cffile action="read" file="/opt/hermes/templates/rootca_openssl.cnf" variable="openssl">
  <cfset openssl = REReplace(openssl, "CA-DIRECTORY", ca_directory, "ALL")>
  <cffile action="write" file="/opt/hermes/templates/#customtrans3#_rootca_openssl.cnf" output="#openssl#">

  <!--- Execute CA creation script --->
  <cftry>
    <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/scripts/#customtrans3#_create_ca.sh" timeout="60"></cfexecute>
    <cfexecute name="/opt/hermes/scripts/#customtrans3#_create_ca.sh" timeout="240" outputfile="/dev/null" arguments="-inputformat none"></cfexecute>
    <cfcatch type="any">
      <cfset session.m_ca = 19>
      <cflocation url="view_internal_ca.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <!--- Cleanup script --->
  <cfif fileExists("/opt/hermes/scripts/#customtrans3#_create_ca.sh")>
    <cffile action="delete" file="/opt/hermes/scripts/#customtrans3#_create_ca.sh">
  </cfif>

  <!--- Find new cert in Ciphermail --->
  <cfquery name="getnewcert" datasource="djigzo">
    SELECT * FROM cm_certificates WHERE cm_thumbprint NOT IN (SELECT cm_thumbprint FROM cm_certificates_tmp)
  </cfquery>

  <cfif getnewcert.recordcount LT 1>
    <cfset session.m_ca = 19>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <cfif getnewcert.recordcount EQ 1>
    <cfquery datasource="djigzo">
      UPDATE cm_certificates SET cm_store_name = 'roots' WHERE cm_id = <cfqueryparam value="#getnewcert.cm_id#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfquery name="checkthumb" datasource="djigzo">
      SELECT cm_thumbprint FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getnewcert.cm_thumbprint#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkthumb.recordcount LT 1>
      <cfquery name="getmax" datasource="djigzo">
        SELECT MAX(cm_id) as maxid FROM cm_ctl
      </cfquery>
      <cfset nextid = (getmax.maxid is "" ? 1 : getmax.maxid + 1)>

      <cfquery datasource="djigzo">
        INSERT INTO cm_ctl (cm_id, cm_name, cm_thumbprint)
        VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'global', <cfqueryparam value="#getnewcert.cm_thumbprint#" cfsqltype="cf_sql_varchar">)
      </cfquery>
      <cfquery datasource="djigzo">
        INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
        VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'whitelisted', 'status')
      </cfquery>
      <cfquery datasource="djigzo">
        INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
        VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'false', 'allowExpired')
      </cfquery>
      <cfquery datasource="hermes">
        UPDATE ca_settings
        SET ca_djigzo_id = <cfqueryparam value="#getnewcert.cm_id#" cfsqltype="cf_sql_varchar">,
            ca_djigzo_subject = <cfqueryparam value="CN=#ca_cn#, OU=#ca_org#, O=#ca_unit#, ST=#ca_state#, C=#ca_country#" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#caResult.GENERATED_KEY#" cfsqltype="cf_sql_integer">
      </cfquery>
    </cfif>

    <cfquery datasource="djigzo">
      DELETE FROM cm_certificates_tmp
    </cfquery>
  </cfif>

  <cfset session.m_ca = 17>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: IMPORT CA    --->
<!--- ===================== --->
<cfif action is "import_ca">
  <cfparam name="form.import_ca_name" default="">
  <cfparam name="form.make_default_import" default="">

  <cfset import_name = trim(form.import_ca_name)>

  <!--- Validate name --->
  <cfif import_name is "">
    <cfset session.m_ca = 30>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z0-9 ]", import_name) GT 0>
    <cfset session.m_ca = 31>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate --->
  <cfquery name="checkImportDup" datasource="hermes">
    SELECT COUNT(*) as cnt FROM ca_settings WHERE ca_commonname = <cfqueryparam value="#import_name#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkImportDup.cnt GT 0>
    <cfset session.m_ca = 18>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <!--- Check file uploads --->
  <cfif NOT StructKeyExists(form, "import_ca_cert") OR form.import_ca_cert is "">
    <cfset session.m_ca = 32>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif NOT StructKeyExists(form, "import_ca_key") OR form.import_ca_key is "">
    <cfset session.m_ca = 33>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <cfset ca_directory = REReplace(import_name, "[^A-Za-z0-9]+", "", "all")>

  <!--- Create CA directory structure --->
  <cfset caPath = "/opt/hermes/CA/#ca_directory#">
  <cftry>
    <cfexecute name="/bin/mkdir" arguments="-p #caPath#/root_ca/certs #caPath#/root_ca/crl #caPath#/root_ca/newcerts #caPath#/root_ca/private #caPath#/root_ca/requests #caPath#/root_ca/PFX" timeout="60"></cfexecute>
    <cfexecute name="/usr/bin/touch" arguments="#caPath#/root_ca/serial #caPath#/root_ca/index.txt #caPath#/root_ca/crlnumber" timeout="60"></cfexecute>
    <cfexecute name="/bin/bash" arguments="-c 'echo 0100 > #caPath#/root_ca/serial'" timeout="60"></cfexecute>
    <cfexecute name="/bin/bash" arguments="-c 'echo 0100 > #caPath#/root_ca/crlnumber'" timeout="60"></cfexecute>
    <cfcatch type="any">
      <cfset session.m_ca = 34>
      <cflocation url="view_internal_ca.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <!--- Upload cert and key --->
  <cftry>
    <cffile action="upload" filefield="import_ca_cert" destination="#caPath#/root_ca/certs/" nameconflict="overwrite">
    <cffile action="rename" source="#caPath#/root_ca/certs/#cffile.serverFile#" destination="#caPath#/root_ca/certs/cacert.pem">
    <cffile action="upload" filefield="import_ca_key" destination="#caPath#/root_ca/private/" nameconflict="overwrite">
    <cffile action="rename" source="#caPath#/root_ca/private/#cffile.serverFile#" destination="#caPath#/root_ca/private/cakey.pem">
    <cfcatch type="any">
      <cfset session.m_ca = 35>
      <cflocation url="view_internal_ca.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <!--- Validate uploaded certificate and key --->
  <cfset certPath = "#caPath#/root_ca/certs/cacert.pem">
  <cfset keyPath = "#caPath#/root_ca/private/cakey.pem">
  <cfif NOT isDefined("customtrans3")>
    <cfinclude template="./inc/generate_customtrans.cfm">
  </cfif>

  <!--- Verify cert is valid X.509 --->
  <cfset validateScript = "">
  <cfset validateScript = validateScript & "CERT_MOD=$(openssl x509 -noout -modulus -in #certPath# 2>&1)" & chr(10)>
  <cfset validateScript = validateScript & "if [ $? -ne 0 ]; then echo 'INVALID_CERT'; exit 1; fi" & chr(10)>
  <!--- Verify key is valid private key --->
  <cfset validateScript = validateScript & "KEY_MOD=$(openssl rsa -noout -modulus -in #keyPath# 2>&1)" & chr(10)>
  <cfset validateScript = validateScript & "if [ $? -ne 0 ]; then echo 'INVALID_KEY'; exit 1; fi" & chr(10)>
  <!--- Verify cert and key match (compare modulus) --->
  <cfset validateScript = validateScript & "CERT_HASH=$(echo ""$CERT_MOD"" | openssl md5)" & chr(10)>
  <cfset validateScript = validateScript & "KEY_HASH=$(echo ""$KEY_MOD"" | openssl md5)" & chr(10)>
  <cfset validateScript = validateScript & 'if [ "$CERT_HASH" != "$KEY_HASH" ]; then echo "KEY_MISMATCH"; exit 1; fi' & chr(10)>
  <!--- Verify cert is a CA cert (has CA:TRUE) --->
  <cfset validateScript = validateScript & "IS_CA=$(openssl x509 -noout -text -in #certPath# 2>/dev/null | grep 'CA:TRUE')" & chr(10)>
  <cfset validateScript = validateScript & 'if [ -z "$IS_CA" ]; then echo "NOT_CA"; exit 1; fi' & chr(10)>
  <cfset validateScript = validateScript & "echo 'VALID'" & chr(10)>

  <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_validate_ca.sh" output="#validateScript#">
  <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_validate_ca.sh" timeout="60"></cfexecute>
  <cftry>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_validate_ca.sh" timeout="60" variable="validateResult" arguments=""></cfexecute>
    <cfcatch type="any">
      <cfset validateResult = "ERROR">
    </cfcatch>
  </cftry>
  <cfif fileExists("/opt/hermes/tmp/#customtrans3#_validate_ca.sh")>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_validate_ca.sh">
  </cfif>

  <cfset validateResult = trim(validateResult)>
  <cfif validateResult is "INVALID_CERT">
    <!--- Clean up uploaded files --->
    <cfexecute name="/bin/rm" arguments="-rf #caPath#" timeout="60"></cfexecute>
    <cfset session.m_ca = 48>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif validateResult is "INVALID_KEY">
    <cfexecute name="/bin/rm" arguments="-rf #caPath#" timeout="60"></cfexecute>
    <cfset session.m_ca = 49>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif validateResult is "KEY_MISMATCH">
    <cfexecute name="/bin/rm" arguments="-rf #caPath#" timeout="60"></cfexecute>
    <cfset session.m_ca = 50>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif validateResult is "NOT_CA">
    <cfexecute name="/bin/rm" arguments="-rf #caPath#" timeout="60"></cfexecute>
    <cfset session.m_ca = 51>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>
  <cfif validateResult is not "VALID">
    <cfexecute name="/bin/rm" arguments="-rf #caPath#" timeout="60"></cfexecute>
    <cfset session.m_ca = 35>
    <cflocation url="view_internal_ca.cfm" addtoken="no">
  </cfif>

  <!--- Generate openssl.cnf from template for this CA directory --->
  <cftry>
    <cffile action="read" file="/opt/hermes/templates/rootca_openssl.cnf" variable="opensslTemplate">
    <cfset opensslTemplate = REReplace(opensslTemplate, "CA-DIRECTORY", ca_directory, "ALL")>
    <cffile action="write" file="#caPath#/root_ca/openssl.cnf" output="#opensslTemplate#">
    <!--- Create cachain.pem (copy of CA cert, needed for PFX export) --->
    <cffile action="copy" source="#caPath#/root_ca/certs/cacert.pem" destination="#caPath#/root_ca/cachain.pem">
    <cfcatch type="any">
      <cfset session.m_ca = 34>
      <cflocation url="view_internal_ca.cfm" addtoken="no">
    </cfcatch>
  </cftry>

  <!--- Read cert to get expiry info via openssl --->
  <cfset certExpiry = "">
  <cftry>
    <cfinclude template="./inc/generate_customtrans.cfm">
    <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_get_cert_expiry.sh"
      output="date -d ""$(openssl x509 -enddate -noout -in #caPath#/root_ca/certs/cacert.pem 2>/dev/null | sed 's/notAfter=//')"" '+%Y-%m-%d' 2>/dev/null">
    <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_get_cert_expiry.sh" timeout="60"></cfexecute>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_get_cert_expiry.sh" timeout="60" variable="certEndDate" arguments=""></cfexecute>
    <cfif fileExists("/opt/hermes/tmp/#customtrans3#_get_cert_expiry.sh")>
      <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_get_cert_expiry.sh">
    </cfif>
    <!--- Script now outputs yyyy-mm-dd directly via date command --->
    <cfset certEndDate = trim(certEndDate)>
    <cfif certEndDate is not "" AND REFind("^\d{4}-\d{2}-\d{2}$", certEndDate)>
      <cfset certExpiry = certEndDate>
    <cfelse>
      <cfset certExpiry = DateFormat(DateAdd("yyyy", 5, Now()), "yyyy-mm-dd")>
    </cfif>
    <cfcatch type="any">
      <cfset certExpiry = DateFormat(DateAdd("yyyy", 5, Now()), "yyyy-mm-dd")>
    </cfcatch>
  </cftry>

  <!--- Handle default --->
  <cfset ca_default = 2>
  <cfif form.make_default_import is "1">
    <cfset ca_default = 1>
    <cfquery datasource="hermes">
      UPDATE ca_settings SET default2 = '2'
    </cfquery>
  <cfelse>
    <cfquery name="checkAnyCA2" datasource="hermes">
      SELECT COUNT(*) as cnt FROM ca_settings
    </cfquery>
    <cfif checkAnyCA2.cnt EQ 0>
      <cfset ca_default = 1>
    </cfif>
  </cfif>

  <!--- Insert CA record --->
  <cfquery datasource="hermes" result="importCAResult">
    INSERT INTO ca_settings
    (validity, encryption, ca_commonname, organizationname, unitname, stateprovincename, countryname, applied, expires, default2, ca_directory)
    VALUES (
      '0',
      'imported',
      <cfqueryparam value="#import_name#" cfsqltype="cf_sql_varchar">,
      'Imported', 'Imported', 'Imported', 'XX',
      '1',
      <cfqueryparam value="#certExpiry#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_default#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ca_directory#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Import into Ciphermail with full registration --->
  <cftry>
    <cfif NOT isDefined("customtrans3")>
      <cfinclude template="./inc/generate_customtrans.cfm">
    </cfif>

    <!--- Import cert into Ciphermail (idempotent - skips if already imported) --->
    <cffile action="write"
        file="/opt/hermes/tmp/#customtrans3#_import_ca.sh"
        output="cat #caPath#/root_ca/certs/cacert.pem | docker exec -i hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CertStore --import-certificates 2>&1">
    <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_import_ca.sh" timeout="60"></cfexecute>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_import_ca.sh" timeout="240" variable="importResult" arguments=""></cfexecute>
    <cfif fileExists("/opt/hermes/tmp/#customtrans3#_import_ca.sh")>
      <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_import_ca.sh">
    </cfif>

    <!--- Extract actual CN from the cert file for Ciphermail lookup --->
    <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_get_cn.sh"
      output="openssl x509 -noout -subject -in #caPath#/root_ca/certs/cacert.pem 2>/dev/null | sed -n 's/.*CN\s*=\s*//p' | sed 's/,.*//' | tr -d ' '">
    <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_get_cn.sh" timeout="60"></cfexecute>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_get_cn.sh" timeout="60" variable="certCN" arguments=""></cfexecute>
    <cfif fileExists("/opt/hermes/tmp/#customtrans3#_get_cn.sh")>
      <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_get_cn.sh">
    </cfif>
    <cfset certCN = trim(certCN)>

    <!--- Find the cert in Ciphermail by actual cert CN --->
    <cfquery name="getnewcert" datasource="djigzo">
      SELECT * FROM cm_certificates
      WHERE LOWER(cm_subject) LIKE <cfqueryparam value="%cn=#LCase(certCN)#%" cfsqltype="cf_sql_varchar">
      ORDER BY cm_id DESC LIMIT 1
    </cfquery>

    <cfif getnewcert.recordcount GTE 1>
      <!--- Use the first match (take most recent if duplicates) --->
      <cfset djigzoCertId = getnewcert.cm_id>
      <cfset djigzoThumbprint = getnewcert.cm_thumbprint>

      <!--- Set as root certificate --->
      <cfquery datasource="djigzo">
        UPDATE cm_certificates SET cm_store_name = 'roots' WHERE cm_id = <cfqueryparam value="#djigzoCertId#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <!--- Add to trust list if not already there --->
      <cfquery name="checkthumb" datasource="djigzo">
        SELECT cm_thumbprint FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#djigzoThumbprint#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <cfif checkthumb.recordcount LT 1>
        <cfquery name="getmax" datasource="djigzo">
          SELECT MAX(cm_id) as maxid FROM cm_ctl
        </cfquery>
        <cfset nextid = (getmax.maxid is "" ? 1 : getmax.maxid + 1)>

        <cfquery datasource="djigzo">
          INSERT INTO cm_ctl (cm_id, cm_name, cm_thumbprint)
          VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'global', <cfqueryparam value="#djigzoThumbprint#" cfsqltype="cf_sql_varchar">)
        </cfquery>
        <cfquery datasource="djigzo">
          INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
          VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'whitelisted', 'status')
        </cfquery>
        <cfquery datasource="djigzo">
          INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
          VALUES (<cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">, 'false', 'allowExpired')
        </cfquery>
      </cfif>

      <!--- Update hermes ca_settings with Ciphermail references --->
      <cfquery datasource="hermes">
        UPDATE ca_settings
        SET ca_djigzo_id = <cfqueryparam value="#djigzoCertId#" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#importCAResult.GENERATED_KEY#" cfsqltype="cf_sql_integer">
      </cfquery>
    </cfif>

    <cfcatch type="any">
      <!--- CA files saved but Ciphermail registration failed --->
    </cfcatch>
  </cftry>

  <cfset session.m_ca = 36>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE CA    --->
<!--- ===================== --->
<cfif action is "delete_ca">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery name="getcaname" datasource="hermes">
      SELECT * FROM ca_settings WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Check for issued certificates --->
    <cfquery name="getcacerts" datasource="hermes">
      SELECT COUNT(*) as cnt FROM recipient_certificates WHERE ca_id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcacerts.cnt GT 0>
      <cfset session.m_ca = 40>
      <cflocation url="view_internal_ca.cfm" addtoken="no">
    </cfif>

    <!--- Delete from Ciphermail --->
    <cftry>
      <cfif getcaname.ca_djigzo_id is not "">
        <!--- Delete by known Ciphermail ID --->
        <cfquery name="getthumbprint" datasource="djigzo">
          SELECT cm_id, cm_thumbprint FROM cm_certificates WHERE cm_id = <cfqueryparam value="#getcaname.ca_djigzo_id#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif getthumbprint.recordcount GTE 1>
          <cfquery datasource="djigzo">
            DELETE FROM cm_certificates WHERE cm_id = <cfqueryparam value="#getcaname.ca_djigzo_id#" cfsqltype="cf_sql_varchar">
          </cfquery>
          <cfquery name="getctl" datasource="djigzo">
            SELECT * FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getthumbprint.cm_thumbprint#" cfsqltype="cf_sql_varchar">
          </cfquery>
          <cfif getctl.recordcount GTE 1>
            <cfquery datasource="djigzo">
              DELETE FROM cm_ctl_cm_name_values WHERE cm_ctl = <cfqueryparam value="#getctl.cm_id#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfquery datasource="djigzo">
              DELETE FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getthumbprint.cm_thumbprint#" cfsqltype="cf_sql_varchar">
            </cfquery>
          </cfif>
        </cfif>
      </cfif>

      <!--- Also clean up any certs matching this CA by name or actual cert CN (catches orphaned entries) --->
      <!--- Try to read actual CN from cert file if it exists --->
      <cfset deleteCertCN = getcaname.ca_commonname>
      <cfset deleteCertPath = "/opt/hermes/CA/#getcaname.ca_directory#/root_ca/certs/cacert.pem">
      <cfif fileExists(deleteCertPath)>
        <cftry>
          <cfinclude template="./inc/generate_customtrans.cfm">
          <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_get_del_cn.sh"
            output="openssl x509 -noout -subject -in #deleteCertPath# 2>/dev/null | sed -n 's/.*CN\s*=\s*//p' | sed 's/,.*//' | tr -d ' '">
          <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_get_del_cn.sh" timeout="60"></cfexecute>
          <cfexecute name="/opt/hermes/tmp/#customtrans3#_get_del_cn.sh" timeout="60" variable="deleteCertCN" arguments=""></cfexecute>
          <cfif fileExists("/opt/hermes/tmp/#customtrans3#_get_del_cn.sh")>
            <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_get_del_cn.sh">
          </cfif>
          <cfset deleteCertCN = trim(deleteCertCN)>
          <cfif deleteCertCN is ""><cfset deleteCertCN = getcaname.ca_commonname></cfif>
          <cfcatch><cfset deleteCertCN = getcaname.ca_commonname></cfcatch>
        </cftry>
      </cfif>

      <cfquery name="getOrphanCerts" datasource="djigzo">
        SELECT cm_id, cm_thumbprint FROM cm_certificates
        WHERE LOWER(cm_subject) LIKE <cfqueryparam value="%cn=#LCase(deleteCertCN)#%" cfsqltype="cf_sql_varchar">
        <cfif LCase(deleteCertCN) is not LCase(getcaname.ca_commonname)>
          OR LOWER(cm_subject) LIKE <cfqueryparam value="%cn=#LCase(getcaname.ca_commonname)#%" cfsqltype="cf_sql_varchar">
        </cfif>
      </cfquery>
      <cfloop query="getOrphanCerts">
        <cfquery datasource="djigzo">
          DELETE FROM cm_certificates WHERE cm_id = <cfqueryparam value="#cm_id#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfquery name="getOrphanCtl" datasource="djigzo">
          SELECT * FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#cm_thumbprint#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif getOrphanCtl.recordcount GTE 1>
          <cfquery datasource="djigzo">
            DELETE FROM cm_ctl_cm_name_values WHERE cm_ctl = <cfqueryparam value="#getOrphanCtl.cm_id#" cfsqltype="cf_sql_varchar">
          </cfquery>
          <cfquery datasource="djigzo">
            DELETE FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#cm_thumbprint#" cfsqltype="cf_sql_varchar">
          </cfquery>
        </cfif>
      </cfloop>
      <cfcatch type="any"></cfcatch>
    </cftry>

    <!--- Delete CA directory --->
    <cfset currentDirectory = "/opt/hermes/CA/#getcaname.ca_directory#">
    <cfif DirectoryExists(currentDirectory)>
      <cfexecute name="/bin/rm" arguments="-rf #currentDirectory#" timeout="60"></cfexecute>
    </cfif>

    <!--- Delete from database --->
    <cfquery datasource="hermes">
      DELETE FROM ca_settings WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset session.m_ca = 41>
  </cfif>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: SET DEFAULT  --->
<!--- ===================== --->
<cfif action is "set_default">
  <cfif StructKeyExists(form, "default_id") AND IsNumeric(form.default_id)>
    <cfquery datasource="hermes">
      UPDATE ca_settings SET default2 = '2'
    </cfquery>
    <cfquery datasource="hermes">
      UPDATE ca_settings SET default2 = '1' WHERE id = <cfqueryparam value="#form.default_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m_ca = 42>
  </cfif>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: RENEW CA     --->
<!--- ===================== --->
<cfif action is "renew_ca">
  <cfif StructKeyExists(form, "renew_id") AND IsNumeric(form.renew_id)>
    <cfquery name="getRenewCA" datasource="hermes">
      SELECT * FROM ca_settings WHERE id = <cfqueryparam value="#form.renew_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getRenewCA.recordcount GTE 1>
      <cfset caDir = "/opt/hermes/CA/#getRenewCA.ca_directory#/root_ca">
      <cfset certFile = "#caDir#/certs/cacert.pem">
      <cfset keyFile = "#caDir#/private/cakey.pem">
      <cfset configFile = "#caDir#/openssl.cnf">

      <cfif fileExists(certFile) AND fileExists(keyFile)>
        <cftry>
          <cfinclude template="./inc/generate_customtrans.cfm">

          <!--- Remove old cert from Ciphermail before re-importing --->
          <cfif getRenewCA.ca_djigzo_id is not "">
            <cftry>
              <cfquery name="getOldThumb" datasource="djigzo">
                SELECT cm_id, cm_thumbprint FROM cm_certificates WHERE cm_id = <cfqueryparam value="#getRenewCA.ca_djigzo_id#" cfsqltype="cf_sql_varchar">
              </cfquery>
              <cfif getOldThumb.recordcount GTE 1>
                <cfquery datasource="djigzo">
                  DELETE FROM cm_certificates WHERE cm_id = <cfqueryparam value="#getRenewCA.ca_djigzo_id#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfquery name="getOldCtl" datasource="djigzo">
                  SELECT * FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getOldThumb.cm_thumbprint#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <cfif getOldCtl.recordcount GTE 1>
                  <cfquery datasource="djigzo">
                    DELETE FROM cm_ctl_cm_name_values WHERE cm_ctl = <cfqueryparam value="#getOldCtl.cm_id#" cfsqltype="cf_sql_varchar">
                  </cfquery>
                  <cfquery datasource="djigzo">
                    DELETE FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getOldThumb.cm_thumbprint#" cfsqltype="cf_sql_varchar">
                  </cfquery>
                </cfif>
              </cfif>
              <cfcatch type="any"></cfcatch>
            </cftry>
          </cfif>

          <!--- Snapshot certs before renew --->
          <cfquery datasource="djigzo">DELETE FROM cm_certificates_tmp</cfquery>
          <cfquery datasource="djigzo">INSERT INTO cm_certificates_tmp SELECT * FROM cm_certificates</cfquery>

          <!--- Calculate days from today to current expiry + 5 years --->
          <cfset newExpiryDate = DateAdd("yyyy", 5, getRenewCA.expires)>
          <cfset daysFromNow = DateDiff("d", Now(), newExpiryDate)>
          <cfif daysFromNow LT 1825><cfset daysFromNow = 1825></cfif>

          <!--- Re-sign the CA cert and re-import into Ciphermail --->
          <cfset renewScript = "">
          <cfset renewScript = renewScript & "openssl x509 -in #certFile# -days #daysFromNow# -out #certFile#.new -signkey #keyFile#" & chr(10)>
          <cfset renewScript = renewScript & "mv #certFile#.new #certFile#" & chr(10)>
          <!--- Update cachain.pem too --->
          <cfset renewScript = renewScript & "cp #certFile# #caDir#/cachain.pem" & chr(10)>
          <!--- Import renewed cert into Ciphermail --->
          <cfset renewScript = renewScript & "cat #certFile# | docker exec -i hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CertStore --import-certificates 2>/dev/null" & chr(10)>
          <!--- Output the new expiry date --->
          <cfset renewScript = renewScript & "openssl x509 -enddate -noout -in #certFile# 2>/dev/null | sed 's/notAfter=//'" & chr(10)>

          <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_renew_ca.sh" output="#renewScript#">
          <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_renew_ca.sh" timeout="60"></cfexecute>
          <cfexecute name="/opt/hermes/tmp/#customtrans3#_renew_ca.sh" timeout="240" variable="renewResult" arguments=""></cfexecute>
          <cfif fileExists("/opt/hermes/tmp/#customtrans3#_renew_ca.sh")>
            <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_renew_ca.sh">
          </cfif>

          <!--- Find the new cert in Ciphermail and register in trust list --->
          <cfquery name="getNewRenewCert" datasource="djigzo">
            SELECT * FROM cm_certificates WHERE cm_thumbprint NOT IN (SELECT cm_thumbprint FROM cm_certificates_tmp)
          </cfquery>
          <cfif getNewRenewCert.recordcount EQ 1>
            <cfquery datasource="djigzo">
              UPDATE cm_certificates SET cm_store_name = 'roots' WHERE cm_id = <cfqueryparam value="#getNewRenewCert.cm_id#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfquery name="checkRenewThumb" datasource="djigzo">
              SELECT cm_thumbprint FROM cm_ctl WHERE cm_thumbprint = <cfqueryparam value="#getNewRenewCert.cm_thumbprint#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfif checkRenewThumb.recordcount LT 1>
              <cfquery name="getmaxctl" datasource="djigzo">SELECT MAX(cm_id) as maxid FROM cm_ctl</cfquery>
              <cfset nextctlid = (getmaxctl.maxid is "" ? 1 : getmaxctl.maxid + 1)>
              <cfquery datasource="djigzo">
                INSERT INTO cm_ctl (cm_id, cm_name, cm_thumbprint)
                VALUES (<cfqueryparam value="#nextctlid#" cfsqltype="cf_sql_varchar">, 'global', <cfqueryparam value="#getNewRenewCert.cm_thumbprint#" cfsqltype="cf_sql_varchar">)
              </cfquery>
              <cfquery datasource="djigzo">
                INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
                VALUES (<cfqueryparam value="#nextctlid#" cfsqltype="cf_sql_varchar">, 'whitelisted', 'status')
              </cfquery>
              <cfquery datasource="djigzo">
                INSERT INTO cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name)
                VALUES (<cfqueryparam value="#nextctlid#" cfsqltype="cf_sql_varchar">, 'false', 'allowExpired')
              </cfquery>
            </cfif>
            <!--- Update hermes with new Ciphermail ID --->
            <cfquery datasource="hermes">
              UPDATE ca_settings SET ca_djigzo_id = <cfqueryparam value="#getNewRenewCert.cm_id#" cfsqltype="cf_sql_varchar">
              WHERE id = <cfqueryparam value="#form.renew_id#" cfsqltype="cf_sql_integer">
            </cfquery>
          </cfif>
          <cfquery datasource="djigzo">DELETE FROM cm_certificates_tmp</cfquery>

          <!--- Read expiry from renewed cert in a clean separate call --->
          <cfset newExpires = "">
          <cffile action="write" file="/opt/hermes/tmp/#customtrans3#_get_renew_expiry.sh"
            output="date -d ""$(openssl x509 -enddate -noout -in #certFile# 2>/dev/null | sed 's/notAfter=//')"" '+%Y-%m-%d' 2>/dev/null">
          <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_get_renew_expiry.sh" timeout="60"></cfexecute>
          <cftry>
            <cfexecute name="/opt/hermes/tmp/#customtrans3#_get_renew_expiry.sh" timeout="60" variable="newExpiryRaw" arguments=""></cfexecute>
            <cfset newExpiryRaw = trim(newExpiryRaw)>
            <cfif newExpiryRaw is not "" AND REFind("^\d{4}-\d{2}-\d{2}$", newExpiryRaw)>
              <cfset newExpires = newExpiryRaw>
            </cfif>
            <cfcatch>
              <cfset newExpires = "">
            </cfcatch>
          </cftry>
          <cfif fileExists("/opt/hermes/tmp/#customtrans3#_get_renew_expiry.sh")>
            <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_get_renew_expiry.sh">
          </cfif>
          <cfif newExpires is "">
            <cfset newExpires = DateFormat(DateAdd("yyyy", 5, Now()), "yyyy-mm-dd")>
          </cfif>
          <cfquery datasource="hermes">
            UPDATE ca_settings SET expires = <cfqueryparam value="#newExpires#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#form.renew_id#" cfsqltype="cf_sql_integer">
          </cfquery>

          <cfset session.m_ca = 43>
          <cfcatch type="any">
            <cfset session.m_ca = 44>
          </cfcatch>
        </cftry>
      <cfelse>
        <cfset session.m_ca = 44>
      </cfif>
    </cfif>
  </cfif>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- Read CA download security setting --->
<cfset allowCADownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_CA_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowCADownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<!--- Load existing CAs --->
<cfquery name="getca" datasource="hermes">
  SELECT * FROM ca_settings ORDER BY ca_commonname ASC
</cfquery>

<!--- ===================== --->
<!--- ALERTS               --->
<!--- ===================== --->
<cfif m is 1>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The CA Common Name cannot be empty.</p></div>
</cfif>
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The CA Common Name must contain only letters, numbers, and spaces.</p></div>
</cfif>
<cfif m is 9>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Organization/Company Name cannot be empty.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Organization/Company Name contains invalid characters.</p></div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Organization Unit cannot be empty.</p></div>
</cfif>
<cfif m is 12>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Organization Unit contains invalid characters.</p></div>
</cfif>
<cfif m is 13>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The State/Province cannot be empty.</p></div>
</cfif>
<cfif m is 14>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The State/Province must contain only letters.</p></div>
</cfif>
<cfif m is 15>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Country Code must be exactly 2 letters (e.g. US, GB, DE).</p></div>
</cfif>
<cfif m is 16>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Country Code must contain only letters.</p></div>
</cfif>
<cfif m is 17>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Internal Certificate Authority created successfully.</p></div>
</cfif>
<cfif m is 18>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate</h4><p>A Certificate Authority with that name already exists.</p></div>
</cfif>
<cfif m is 19>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>An error occurred while creating the Certificate Authority. Please check the logs.</p></div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The CA Name for import cannot be empty.</p></div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The CA Name must contain only letters, numbers, and spaces.</p></div>
</cfif>
<cfif m is 32>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a CA certificate file to upload.</p></div>
</cfif>
<cfif m is 33>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a CA private key file to upload.</p></div>
</cfif>
<cfif m is 34>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to create CA directory structure.</p></div>
</cfif>
<cfif m is 35>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to upload CA certificate or private key file.</p></div>
</cfif>
<cfif m is 36>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External Certificate Authority imported successfully.</p></div>
</cfif>
<cfif m is 40>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Cannot Delete</h4><p>This Certificate Authority has issued certificates. Delete the associated user certificates first.</p></div>
</cfif>
<cfif m is 41>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Certificate Authority deleted successfully.</p></div>
</cfif>
<cfif m is 42>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Default Certificate Authority updated.</p></div>
</cfif>
<cfif m is 43>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>Certificate Authority extended by 5 years from its previous expiration date.</p></div>
</cfif>
<cfif m is 44>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to renew Certificate Authority. Certificate or key files may be missing.</p></div>
</cfif>
<cfif m is 45>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Access Denied</h4><p>CA file downloads are disabled. Set <code>ALLOW_CA_DOWNLOAD=yes</code> in <code>/opt/hermes/config/security.conf</code> to enable.</p></div>
</cfif>
<cfif m is 46>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Invalid download request.</p></div>
</cfif>
<cfif m is 47>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>CA file not found on disk.</p></div>
</cfif>
<cfif m is 48>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Certificate</h4><p>The uploaded file is not a valid X.509 certificate. Please upload a PEM-encoded CA certificate.</p></div>
</cfif>
<cfif m is 49>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Private Key</h4><p>The uploaded file is not a valid RSA private key. Please upload a PEM-encoded private key.</p></div>
</cfif>
<cfif m is 50>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Key Mismatch</h4><p>The certificate and private key do not match. The private key must correspond to the uploaded certificate.</p></div>
</cfif>
<cfif m is 51>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Not a CA Certificate</h4><p>The uploaded certificate does not have the CA:TRUE basic constraint. Only CA certificates can be imported here.</p></div>
</cfif>

<!--- PAGE GUIDE --->
<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">This page manages internal Certificate Authorities (CAs) used by Ciphermail for S/MIME email encryption. You can <strong>create</strong> a new CA by filling in the organization details and certificate parameters, or <strong>import</strong> an existing external CA by uploading the certificate and private key files.</p>
  <p class="mb-0">Each CA can issue S/MIME certificates for recipients. The <strong>default</strong> CA is used when creating new recipient certificates. A CA cannot be deleted if it has issued certificates -- delete the recipient certificates first.</p>
</div>

<!--- ===================== --->
<!--- CREATE INTERNAL CA   --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleCreateCA" title="Expand">
        <i class="fas fa-chevron-down"></i>
      </button>
      <i class="fas fa-plus-circle"></i> Create Internal CA
    </h3>
  </div>
  <div class="collapse" id="createCACollapse">
    <div class="card-body">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="create_ca">
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="ca_commonname" class="form-label">CA Common Name</label>
            <input type="text" class="form-control" id="ca_commonname" name="ca_commonname" maxlength="50" required
              placeholder="e.g. My Organization Root CA">
            <small class="text-muted">Letters, numbers, and spaces only</small>
          </div>
          <div class="col-md-3">
            <label class="form-label">Validity</label>
            <select class="form-select" name="validity">
              <option value="1825" selected>5 Years (Recommended)</option>
              <option value="1460">4 Years</option>
              <option value="1095">3 Years</option>
              <option value="730">2 Years</option>
              <option value="365">1 Year</option>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label">Key Length</label>
            <select class="form-select" name="encryption">
              <option value="4096" selected>4096-bit (Recommended)</option>
              <option value="2048">2048-bit</option>
            </select>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-4">
            <label for="organizationname" class="form-label">Organization/Company Name</label>
            <input type="text" class="form-control" id="organizationname" name="organizationname" maxlength="50" required>
          </div>
          <div class="col-md-4">
            <label for="unitname" class="form-label">Organization Unit</label>
            <input type="text" class="form-control" id="unitname" name="unitname" maxlength="50" required>
          </div>
          <div class="col-md-2">
            <label for="stateprovincename" class="form-label">State/Province</label>
            <input type="text" class="form-control" id="stateprovincename" name="stateprovincename" maxlength="50" required>
          </div>
          <div class="col-md-2">
            <label for="countryname" class="form-label">Country Code</label>
            <input type="text" class="form-control" id="countryname" name="countryname" maxlength="2" required
              placeholder="US">
            <small class="text-muted">2-letter ISO code</small>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-3">
            <div class="form-check">
              <cfquery name="checkdefault" datasource="hermes">
                SELECT COUNT(*) as cnt FROM ca_settings WHERE default2 = '1'
              </cfquery>
              <cfif checkdefault.cnt LT 1>
                <input type="hidden" name="make_default" value="1">
                <input class="form-check-input" type="checkbox" checked disabled>
              <cfelse>
                <input class="form-check-input" type="checkbox" name="make_default" value="1" id="make_default">
              </cfif>
              <label class="form-check-label" for="make_default">Make Default CA</label>
            </div>
          </div>
        </div>
        <button type="submit" class="btn btn-primary"
          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating CA...';this.form.submit();">
          <i class="fas fa-plus"></i> Create CA
        </button>
      </form>
    </div>
  </div>
</div>

<!--- ===================== --->
<!--- IMPORT EXTERNAL CA   --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleImportCA" title="Expand">
        <i class="fas fa-chevron-down"></i>
      </button>
      <i class="fas fa-upload"></i> Import External CA
    </h3>
  </div>
  <div class="collapse" id="importCACollapse">
    <div class="card-body">
      <form method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="action" value="import_ca">
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="import_ca_name" class="form-label">CA Name</label>
            <input type="text" class="form-control" id="import_ca_name" name="import_ca_name" maxlength="50" required
              placeholder="e.g. External Root CA">
            <small class="text-muted">A friendly name for this CA. Letters, numbers, and spaces only.</small>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="import_ca_cert" class="form-label">CA Certificate (PEM)</label>
            <input type="file" class="form-control" id="import_ca_cert" name="import_ca_cert" accept=".pem,.crt,.cer" required>
            <small class="text-muted">PEM-encoded CA certificate file (.pem, .crt, .cer)</small>
          </div>
          <div class="col-md-6">
            <label for="import_ca_key" class="form-label">CA Private Key (PEM)</label>
            <input type="file" class="form-control" id="import_ca_key" name="import_ca_key" accept=".pem,.key" required>
            <small class="text-muted">PEM-encoded private key file (.pem, .key)</small>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="make_default_import" value="1" id="make_default_import">
              <label class="form-check-label" for="make_default_import">Make Default CA</label>
            </div>
          </div>
        </div>
        <button type="submit" class="btn btn-primary"
          onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Importing...';this.form.submit();">
          <i class="fas fa-upload"></i> Import CA
        </button>
      </form>
    </div>
  </div>
</div>

<!--- ===================== --->
<!--- EXISTING CAs TABLE   --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Existing Certificate Authorities</h3>
  </div>
  <div class="card-body">
    <cfif getca.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No Certificate Authorities found. Create or import one above.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table id="caTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th>CA Common Name</th>
            <th>Type</th>
            <th>Expires</th>
            <th>Key Length</th>
            <th style="width: 80px">Default</th>
            <th style="width: 220px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getca">
            <cfquery name="getCACertCount" datasource="hermes">
              SELECT COUNT(*) as cnt FROM recipient_certificates WHERE ca_id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <tr>
              <td>#encodeForHTML(ca_commonname)#</td>
              <td>
                <cfif encryption is "imported">
                  <span class="badge bg-info">Imported</span>
                <cfelse>
                  <span class="badge bg-primary">Internal</span>
                </cfif>
              </td>
              <td>
                <cfset daysLeft = DateDiff("d", Now(), expires)>
                #DateFormat(expires, "yyyy-mm-dd")#
                <cfif daysLeft LT 90 AND daysLeft GTE 0>
                  <span class="badge bg-warning text-dark ms-1">#daysLeft# days</span>
                <cfelseif daysLeft LT 0>
                  <span class="badge bg-danger ms-1">Expired</span>
                </cfif>
              </td>
              <td>
                <cfif encryption is not "imported">
                  #encodeForHTML(encryption)#-bit
                <cfelse>
                  <!--- Read key length from cert file for imported CAs --->
                  <cfset importedKeyLen = "">
                  <cftry>
                    <cfexecute name="/usr/bin/openssl"
                      arguments="x509 -noout -text -in /opt/hermes/CA/#ca_directory#/root_ca/certs/cacert.pem"
                      variable="certText" errorVariable="certTextErr" timeout="30" />
                    <cfset keyMatch = REFind("Public-Key:\s*\((\d+)\s*bit\)", certText, 1, true)>
                    <cfif keyMatch.pos[1] GT 0>
                      <cfset importedKeyLen = Mid(certText, keyMatch.pos[2], keyMatch.len[2])>
                    </cfif>
                    <cfcatch></cfcatch>
                  </cftry>
                  <cfif importedKeyLen is not "">#importedKeyLen#-bit<cfelse>N/A</cfif>
                </cfif>
              </td>
              <td class="text-center">
                <cfif default2 is "1">
                  <span class="badge bg-success">YES</span>
                <cfelse>
                  <form method="post" class="d-inline">
                    <input type="hidden" name="action" value="set_default">
                    <input type="hidden" name="default_id" value="#id#">
                    <button type="submit" class="btn btn-sm btn-outline-secondary" title="Set as default">
                      <i class="fas fa-check"></i>
                    </button>
                  </form>
                </cfif>
              </td>
              <td class="text-center">
                <cfif allowCADownload>
                  <button type="button" class="btn btn-sm btn-outline-secondary" title="Download CA Certificate"
                    onclick="downloadCAFile('#id#', 'cert');">
                    <i class="fas fa-file-download"></i>
                  </button>
                  <button type="button" class="btn btn-sm btn-outline-warning" title="Download Private Key"
                    onclick="downloadCAFile('#id#', 'key');">
                    <i class="fas fa-key"></i>
                  </button>
                <cfelse>
                  <span title="ALLOW_CA_DOWNLOAD disabled in security.conf" data-bs-toggle="tooltip">
                    <button class="btn btn-sm btn-outline-secondary" disabled><i class="fas fa-file-download"></i></button>
                  </span>
                </cfif>
                <button type="button" class="btn btn-sm btn-outline-primary" title="Renew CA Certificate"
                  onclick="confirmRenewCA('#id#', '#encodeForJavaScript(ca_commonname)#');">
                  <i class="fas fa-sync-alt"></i>
                </button>
                <cfif getCACertCount.cnt LT 1>
                  <button type="button" class="btn btn-sm btn-danger" title="Delete CA"
                    onclick="confirmDeleteCA('#id#', '#encodeForJavaScript(ca_commonname)#');">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                <cfelse>
                  <span title="#getCACertCount.cnt# certificate(s) issued - delete certificates first" data-bs-toggle="tooltip">
                    <button type="button" class="btn btn-sm btn-danger" disabled>
                      <i class="fas fa-trash-alt"></i>
                    </button>
                  </span>
                </cfif>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
    </cfif>
  </div>
</div>

<!--- DELETE FORM --->
<form id="deleteCAForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete_ca">
  <input type="hidden" name="delete_id" id="delete_ca_id" value="">
</form>

<!--- RENEW FORM --->
<form id="renewCAForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="renew_ca">
  <input type="hidden" name="renew_id" id="renew_ca_id" value="">
</form>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


<script>
$(document).ready(function() {
  // Toggle buttons
  var createBtn = document.getElementById('toggleCreateCA');
  var createCollapse = document.getElementById('createCACollapse');
  var importBtn = document.getElementById('toggleImportCA');
  var importCollapse = document.getElementById('importCACollapse');

  if (createBtn) {
    createBtn.addEventListener('click', function() {
      new bootstrap.Collapse(createCollapse, {toggle: true});
    });
    createCollapse.addEventListener('shown.bs.collapse', function() {
      createBtn.querySelector('i').classList.remove('fa-chevron-down');
      createBtn.querySelector('i').classList.add('fa-chevron-up');
      createBtn.title = 'Collapse';
    });
    createCollapse.addEventListener('hidden.bs.collapse', function() {
      createBtn.querySelector('i').classList.remove('fa-chevron-up');
      createBtn.querySelector('i').classList.add('fa-chevron-down');
      createBtn.title = 'Expand';
    });
  }

  if (importBtn) {
    importBtn.addEventListener('click', function() {
      new bootstrap.Collapse(importCollapse, {toggle: true});
    });
    importCollapse.addEventListener('shown.bs.collapse', function() {
      importBtn.querySelector('i').classList.remove('fa-chevron-down');
      importBtn.querySelector('i').classList.add('fa-chevron-up');
      importBtn.title = 'Collapse';
    });
    importCollapse.addEventListener('hidden.bs.collapse', function() {
      importBtn.querySelector('i').classList.remove('fa-chevron-up');
      importBtn.querySelector('i').classList.add('fa-chevron-down');
      importBtn.title = 'Expand';
    });
  }

  // DataTable
  var caTableEl = document.getElementById('caTable');
  if (caTableEl) {
    $(caTableEl).DataTable({
      dom: 'Blfrtip',
      buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
      stateSave: true,
      lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
      order: [[1, 'asc']],
      columnDefs: [
        { orderable: false, targets: [5] },
        { searchable: false, targets: [5] }
      ]
    });
  }

  // Tooltips
  var tooltipEls = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  tooltipEls.forEach(function(el) { new bootstrap.Tooltip(el); });
});

function confirmDeleteCA(id, name) {
  if (!confirm('Delete Certificate Authority "' + name + '"? This cannot be undone.')) return;
  document.getElementById('delete_ca_id').value = id;
  document.getElementById('deleteCAForm').submit();
}

function confirmRenewCA(id, name) {
  if (!confirm('Extend Certificate Authority "' + name + '" by 5 years from its current expiration date?')) return;
  document.getElementById('renew_ca_id').value = id;
  document.getElementById('renewCAForm').submit();
}

function downloadCAFile(id, type) {
  document.getElementById('caDownloadFrame').src = 'inc/download_ca_file.cfm?id=' + id + '&type=' + type;
  // Hide preloader after download starts (cfcontent doesn't trigger page load events)
  setTimeout(function() {
    var preloader = document.querySelector('.preloader');
    if (preloader) { preloader.style.display = 'none'; preloader.style.opacity = '0'; }
  }, 1000);
}
</script>

<iframe id="caDownloadFrame" style="display:none;"></iframe>

</body>
</html>
