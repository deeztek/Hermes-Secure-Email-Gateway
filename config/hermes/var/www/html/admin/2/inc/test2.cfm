<cftry>  
   
    <cfexecute name = "/opt/hermes/scripts/ufw_ban_ip.sh"
    arguments="-inputformat none"
  timeout = "120">
 
    </cfexecute>

  <cfcatch>

    <cfif #cfcatch.detail# contains "Rule inserted">
        <cfoutput>Inserted</cfoutput>
        <cfelse>
            <cfoutput>Not inserted</cfoutput>
        </cfif>

      <!--- DEBUG --->
 
    <cfdump var="#cfcatch#">


    </cfcatch>
  
  </cftry>

