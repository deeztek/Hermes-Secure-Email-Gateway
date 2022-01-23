

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

<cfquery name="getmainparams" datasource="hermes">
  select distinct(parameter), id, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
  </cfquery>

<cfloop query="getmainparams">
  <cfoutput>
  <cfquery name="getchildren" datasource="hermes">
  select * from parameters where child='1' and parent = '#getmainparams.id#' and enabled = '1' order by order1 asc
  </cfquery>
  
  <cfquery name="insert" datasource="hermes">
  insert into command 
  (command, trans_id)
  values
  ('/usr/sbin/postconf -e "#getmainparams.parameter# = #ValueList(getchildren.parameter,", ")#"#chr(10)#', '#customtrans3#')
  </cfquery>
  
  </cfoutput>
  </cfloop> 
  
  <cfquery name="getcommand" datasource="hermes">
  select * from command where trans_id = '#customtrans3#'
  </cfquery>
  
  <cffile action = "write" 
  file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
  output = "/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP#chr(10)#"
  addnewline="no">
  
  <cfoutput query="getcommand">
  
  <cffile action = "APPEND" 
  file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
  output = "#command#"
  addnewline="no">
  
  </cfoutput>
  

  <cfquery name="deletecommand" datasource="hermes">
  delete from command where trans_id = '#customtrans3#'
  </cfquery>
  
  

  <!--- MAKE POSTFIX CONFIG SCRIPT EXECUTABLE --->
  <cftry>
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
timeout = "60">
</cfexecute>
            
    <cfcatch type="any">
        
    <cfset m="Generate Postfix Configuration: There was an error making /opt/hermes/tmp/_apply.sh executable">
    <cfinclude template="error.cfm">
    <cfabort>   
        
    </cfcatch>
    </cftry>


  <!--- RUN POSTFIX CONFIG SCRIPT --->
  <cftry>
  
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
    outputfile ="/dev/null"
    arguments="-inputformat none"
    timeout = "240">
    </cfexecute>
                
        <cfcatch type="any">
            
        <cfset m="Generate Postfix Configuration: There was an error running /opt/hermes/tmp/_apply.sh ">
        <cfinclude template="error.cfm">
        <cfabort>   
            
        </cfcatch>
        </cftry>
    

  
<!--- delete /opt/hermes/tmp/#customtrans3#_apply.sh file --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_apply.sh")>
  
  <cffile
  action = "delete"
  file = "/opt/hermes/tmp/#customtrans3#_apply.sh">    
  
  </cfif>





