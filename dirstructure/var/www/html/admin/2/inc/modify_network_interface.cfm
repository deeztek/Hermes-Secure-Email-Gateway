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

<cffile action="read" file="/opt/hermes/conf_files/50-cloud-init.yaml.HERMES.static" variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","THE-INTERFACE","#THEINTERFACE#","ALL")#">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
 variable="interfaces">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-ADDRESS","#ServerAddress#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-SUBNET","#ServerSubnet#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-GATEWAY","#ServerGateway#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
 variable="interfaces">



<cfset theServerDNS="#ServerDNS1#">
<cfif #ServerDNS2# is not "">
<cfset
 theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2#">
</cfif>
<cfif #ServerDNS3# is not "">
<cfset
 theServerDNS="#ServerDNS1##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS2##chr(10)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)##chr(32)#- #ServerDNS3#">
</cfif>

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DNS","#theServerDNS#","ALL")#">


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
 variable="interfaces">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#50-cloud-init.yaml.HERMES.static"
    output = "#REReplace("#interfaces#","SERVER-DOMAIN","#ServerDomain#","ALL")#">