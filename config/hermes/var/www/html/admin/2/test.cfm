<cfinclude template="./inc/generate_customtrans.cfm">

<cfquery name="getparents" datasource="hermes">
  select distinct(parameter), parent_name, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
  </cfquery>

<!--- Create postconf script starts here --->
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_postconf.sh"
    output = ""
    addNewLine = "no">

<cfloop query="getparents">

  <cfquery name="getchildren" datasource="hermes">
  select parameter from parameters where child='1' and parent_name = '#getparents.parameter#' and enabled = '1' order by order1 asc
  </cfquery>

    
    <cffile action = "append"
    file = "/opt/hermes/tmp/#customtrans3#_postconf.sh"
    output = '/usr/sbin/postconf -e "#getparents.parameter# = #ValueList(getchildren.parameter,", ")#"'
    addNewLine = "yes">
    
    </cfloop>
    
    
    <!--- CONVERT TO UNIX --->
    <cftry>
    <cfexecute name="/usr/bin/dos2unix"
    arguments="/opt/hermes/tmp/#customtrans3#_postconf.sh"
    timeout="10" />
            
    <cfcatch type="any">
        
    <cfset m="Generate Postfix Configuration: There was an error executing /usr/bin/dos2unix">
    <cfinclude template="error.cfm">
    <cfabort>   
        
    </cfcatch>
    </cftry>