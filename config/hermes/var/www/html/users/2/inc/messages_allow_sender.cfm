
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

<cfparam name = "successallowsender" default = "0">
  <cfif StructKeyExists(session, "successallowsender")>
  <cfif session.successallowsender is not "">
  <cfset successallowsender = session.successallowsender>
  </cfif>
  </cfif>

  <cfparam name = "successallowsender_email" default = "">
  <cfif StructKeyExists(session, "successallowsender_email")>
  <cfif session.successallowsender_email is not "">
  <cfset successallowsender_email = session.successallowsender_email>
  </cfif>
  </cfif>

  <cfparam name = "failureallowsender" default = "0">
  <cfif StructKeyExists(session, "failureallowsender")>
  <cfif session.failureallowsender is not "">
  <cfset failureallowsender = session.failureallowsender>
  </cfif>
  </cfif>

  <cfparam name = "failureallowsender_email" default = "">
  <cfif StructKeyExists(session, "failureallowsender_email")>
  <cfif session.failureallowsender_email is not "">
  <cfset failureallowsender_email = session.failureallowsender_email>
  </cfif>
  </cfif>

<cfquery name="getrid" datasource="hermes">
    SELECT rid from msgrcpt where mail_id like binary '#getemail.mail_id#'
    </cfquery>

    <cfquery name="gettoaddr" datasource="hermes">
    SELECT email as toAddress FROM maddr where id = <cfqueryparam value = #getrid.rid# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    <cfquery name="getrecipientid" datasource="hermes">
    select id, recipient from recipients where recipient = '#gettoaddr.toAddress#'
    </cfquery>


    <cfif #getrecipientid.recordcount# GTE 1>

    <cfset recipient = #getrecipientid.id#>

    <cfquery name="getsenderid" datasource="hermes">
        SELECT sid from msgs where mail_id like binary '#getemail.mail_id#' and secret_id like binary '#getemail.secret_id#'
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
          'W'
        )
        </cfquery>

        <cfset session.successallowsender=#successallowsender#+1>
        <cfset session.successallowsender_email= successallowsender_email & "#sender# <br>">

        <cfelseif checkexists.recordcount GTE 1>

        <cfset session.failureallowsender=#failureallowsender#+1>
        <cfset session.failureallowsender_email= failureallowsender_email & "#sender# <br>">

        </cfif>

    <cfelse>

    <cfset session.m = 2>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    <cfabort>

    </cfif>


