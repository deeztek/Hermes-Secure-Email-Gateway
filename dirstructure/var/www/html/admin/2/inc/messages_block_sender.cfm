
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
  
  <!--- /CFIF for session.successblocksender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successblocksender --->
  </cfif>

  <cfparam name = "successblocksender_email" default = "">
  <cfif StructKeyExists(session, "successblocksender_email")>
  <cfif session.successblocksender_email is not "">
  <cfset successblocksender_email = session.successblocksender_email>
  
  <!--- /CFIF for session.successblocksender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successblocksender_email --->
  </cfif>

  <cfoutput>Success Block Sender: #successblocksender#</cfoutput><br>
  
  <cfparam name = "failureblocksender" default = "0">
  <cfif StructKeyExists(session, "failureblocksender")>
  <cfif session.failureblocksender is not "">
  <cfset failureblocksender = session.failureblocksender>
  
  <!--- /CFIF for session.failureblocksender is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureblocksender --->
  </cfif>

  <cfoutput>Failure Block Sender: #failureblocksender#</cfoutput><br>
  
  <cfparam name = "failureblocksender_email" default = "">
  <cfif StructKeyExists(session, "failureblocksender_email")>
  <cfif session.failureblocksender_email is not "">
  <cfset failureblocksender_email = session.failureblocksender_email>
  
  <!--- /CFIF for session.failureblocksender_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureblocksender_email --->
  </cfif>
  
  <cfoutput>Failure Block Sender Email: #failureblocksender_email#</cfoutput><br>


  <cfparam name = "failureinvalidrecipient_email" default = "0">
  <cfif StructKeyExists(session, "failureinvalidrecipient_email")>
  <cfif session.failureinvalidrecipient_email is not "">
  <cfset failureinvalidrecipient_email = session.failureinvalidrecipient_email>
  
  <!--- /CFIF for session.failureinvalidrecipient is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureinvalidrecipient --->
  </cfif>

  <cfoutput>Failure Invalid Recipient Email: #failureinvalidrecipient_email#</cfoutput><br>
  

<cfquery name="getrid" datasource="hermes">
    SELECT rid from msgrcpt where mail_id like binary '#theMailId#' 
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
        SELECT sid from msgs where mail_id like binary '#theMailId#' and secret_id like binary '#theSecretId#'
        </cfquery>
        
        <cfquery name="getsenderemail" datasource="hermes">
        SELECT email from maddr where id='#getsenderid.sid#'
        </cfquery>
        
        <cfset sender="#getsenderemail.email#">
        
        <cfquery name="checkexists" datasource="hermes">
        SELECT receiver, sender from mailaddr_temp where receiver='#gettoaddr.toAddress#' and sender='#sender#'
        </cfquery>
        
        <cfif #checkexists.recordcount# LT 1>
        
        
        <cfquery name="checksenderemail" datasource="hermes">
        select id, email from mailaddr where email='#sender#'
        </cfquery>
        
        
        
        <cfif #checksenderemail.recordcount# LT 1>
        
        
        <cfquery name="insertsender" datasource="hermes" result="stSender">
        insert into mailaddr
        (email)
        values
        ('#sender#')
        </cfquery>
        
        <cfquery name="add" datasource="hermes" result="stResult">
        insert into mailaddr_temp
        (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
        values
        ('#recipient#', '#stSender.GENERATED_KEY#', '#sender#', 'BLOCK', 'insert', '#gettoaddr.toAddress#', '1')
        </cfquery>
        
        <cfquery name="insertwb" datasource="hermes">
        insert into wblist
        (rid, sid, wb)
        values
        ('#recipient#', '#stSender.GENERATED_KEY#', 'B')
        </cfquery>
        
        <cfset session.successblocksender=#successblocksender#+1>
        <cfset session.successblocksender_email= successblocksender_email & "#sender# <br>">
        
        
        <cfelseif #checksenderemail.recordcount# GTE 1>
        
        
        <cfquery name="add" datasource="hermes" result="stResult">
        insert into mailaddr_temp
        (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
        values
        ('#recipient#', '#checksenderemail.id#', '#sender#', 'BLOCK', 'insert', '#gettoaddr.toAddress#', '1')
        </cfquery>
        
        <cfquery name="insertwb" datasource="hermes">
        insert into wblist
        (rid, sid, wb)
        values
        ('#recipient#', '#checksenderemail.id#', 'B')
        </cfquery>
        
        <cfset session.successblocksender=#successblocksender#+1>
        <cfset session.successblocksender_email= successblocksender_email & "#sender# <br>">
        
            <!--- /CFIF #checksenderemail.recordcount# --->
        </cfif>
        
        
        
        <cfelseif #checkexists.recordcount# GTE 1>
    
        <cfset session.failureblocksender=#failureblocksender#+1>
        <cfset session.failureblocksender_email= failureblocksender_email & "#sender# <br>">
        
        <!--- /CFIF #checkexists.recordcount# --->
        </cfif>
        

    <cfelseif #getrecipientid.recordcount# LT 1>

        <cfquery name="getsenderid" datasource="hermes">
            SELECT sid from msgs where mail_id like binary '#theMailId#' and secret_id like binary '#theSecretId#'
            </cfquery>
            
            <cfquery name="getsenderemail" datasource="hermes">
            SELECT email from maddr where id='#getsenderid.sid#'
            </cfquery>
            
            <cfset sender="#getsenderemail.email#">

<cfset session.failureblocksender=#failureblocksender#+1>
<cfset session.failureinvalidrecipient_email= failureinvalidrecipient_email & "#sender# <br>">
    
     
    <!--- /CFIF #getrecipientid.recordcount# --->
    </cfif>
    
    

    