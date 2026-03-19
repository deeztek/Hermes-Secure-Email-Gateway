
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

<cfparam name = "successblocksender" default = "0">
  <cfif StructKeyExists(session, "successblocksender")>
  <cfif session.successblocksender is not "">
  <cfset successblocksender = session.successblocksender>
  </cfif>
  </cfif>

  <cfparam name = "successblocksender_email" default = "">
  <cfif StructKeyExists(session, "successblocksender_email")>
  <cfif session.successblocksender_email is not "">
  <cfset successblocksender_email = session.successblocksender_email>
  </cfif>
  </cfif>

  <cfparam name = "failureblocksender" default = "0">
  <cfif StructKeyExists(session, "failureblocksender")>
  <cfif session.failureblocksender is not "">
  <cfset failureblocksender = session.failureblocksender>
  </cfif>
  </cfif>

  <cfparam name = "failureblocksender_email" default = "">
  <cfif StructKeyExists(session, "failureblocksender_email")>
  <cfif session.failureblocksender_email is not "">
  <cfset failureblocksender_email = session.failureblocksender_email>
  </cfif>
  </cfif>

  <cfparam name = "failureinvalidrecipient_email" default = "0">
  <cfif StructKeyExists(session, "failureinvalidrecipient_email")>
  <cfif session.failureinvalidrecipient_email is not "">
  <cfset failureinvalidrecipient_email = session.failureinvalidrecipient_email>
  </cfif>
  </cfif>

<cfquery name="getrid" datasource="hermes">
    SELECT rid from msgrcpt where mail_id like binary '#theMailId#'
    </cfquery>

    <cfquery name="gettoaddr" datasource="hermes">
    SELECT email as toAddress FROM maddr where id = <cfqueryparam value = #getrid.rid# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    <cfquery name="getrecipientid" datasource="hermes">
    select id, recipient from recipients where recipient = '#gettoaddr.toAddress#'
    </cfquery>


    <cfif getrecipientid.recordcount GTE 1>

    <cfset recipient = getrecipientid.id>

    <cfquery name="getsenderid" datasource="hermes">
        SELECT sid from msgs where mail_id like binary '#theMailId#' and secret_id like binary '#theSecretId#'
        </cfquery>

        <cfquery name="getsenderemail" datasource="hermes">
        SELECT email from maddr where id='#getsenderid.sid#'
        </cfquery>

        <cfset sender="#getsenderemail.email#">

        <!--- Resolve or create mailaddr entry for sender --->
        <cfquery name="checksenderemail" datasource="hermes">
        select id from mailaddr where email='#sender#'
        </cfquery>

        <cfif checksenderemail.recordcount LT 1>
          <cfquery name="insertsender" datasource="hermes" result="stSender">
          insert into mailaddr (email) values ('#sender#')
          </cfquery>
          <cfset senderMailaddrId = stSender.GENERATED_KEY>
        <cfelse>
          <cfset senderMailaddrId = checksenderemail.id>
        </cfif>

        <!--- Check for duplicate in wblist --->
        <cfquery name="checkexists" datasource="hermes">
        SELECT rid FROM wblist
        WHERE rid=<cfqueryparam value="#recipient#" cfsqltype="cf_sql_integer">
          AND sid=<cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif checkexists.recordcount LT 1>

        <cfquery name="insertwb" datasource="hermes">
        insert into wblist (rid, sid, wb)
        values (
          <cfqueryparam value="#recipient#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
          'B'
        )
        </cfquery>

        <cfset session.successblocksender=#successblocksender#+1>
        <cfset session.successblocksender_email= successblocksender_email & "#sender# <br>">

        <cfelseif checkexists.recordcount GTE 1>

        <cfset session.failureblocksender=#failureblocksender#+1>
        <cfset session.failureblocksender_email= failureblocksender_email & "#sender# <br>">

        </cfif>

    <cfelseif getrecipientid.recordcount LT 1>

        <cfquery name="getsenderid" datasource="hermes">
            SELECT sid from msgs where mail_id like binary '#theMailId#' and secret_id like binary '#theSecretId#'
            </cfquery>

            <cfquery name="getsenderemail" datasource="hermes">
            SELECT email from maddr where id='#getsenderid.sid#'
            </cfquery>

            <cfset sender="#getsenderemail.email#">

<cfset session.failureblocksender=#failureblocksender#+1>
<cfset session.failureinvalidrecipient_email= failureinvalidrecipient_email & "#sender# <br>">

    </cfif>


