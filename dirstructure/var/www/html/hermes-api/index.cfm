
<cfset reqData = GetHttpRequestData() />

<!--- CHECK FOR X-FORWARDED-FOR HEADER --->

<cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Forwarded-For" )>

<!--- Get IP using X-Forwarded-For --->
<cfset theIP=#GetHttpRequestData().headers['X-Forwarded-For']#>

<!---
<cfoutput>#theIP#</cfoutput>
--->


<!--- If IP contains multiple IPs separated by comma due to reverse proxy in front of Hermes --->
<cfif #theIP# contains ",">

<cfoutput>Invalid Request: X-Forwarded-For is invalid</cfoutput>
<cfabort>

<!---
<!--- Get the left most value which is most likely the client IP --->
<cfset theIP = #trim(ListGetAt(theIP, 1, ","))#>
--->


<cfelseif #theIP# is "">

<cfoutput>Invalid Request: X-Forwarded-For is blank</cfoutput>
<cfabort>

<!--- /CFIF  #theIP# contains --->
</cfif>

<cfelse>

<cfset theIP=#cgi.remote_addr#>

<!---
<cfoutput>Invalid Request: X-Forwarded-For is missing</cfoutput>
<cfabort>
--->

<!--- /CFIF IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Forwarded-For" ) --->
</cfif>


<!--- CHECK FOR X-ORIGINAL-URL HEADER --->

    <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Original-URL" )>
    
    <cfset theUrl=#GetHttpRequestData().headers['X-Original-URL']#>
    
    <!--- If theUrl is empty --->
    <cfif #theUrl# is "">

    <cfoutput>Invalid Request: X-Original-URL is blank</cfoutput>
    <cfabort>

    <!--- /CFIf theUrl is "" --->
    </cfif>
    
    <cfelse>
    
    <cfoutput>Invalid Request: X-Original-URL is missing</cfoutput>
    <cfabort>
    
    <!--- /CFIF IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Original-URL" ) --->
    </cfif>

    <!--- CHECK FOR X-TOKEN HEADER --->

    <cfif IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Token" )>
    
        <!--- Get Token using X-Token --->
        <cfset theToken=#GetHttpRequestData().headers['X-Token']#>
        
        <!--- If X-token is empty --->
        <cfif #theToken# is "">
    
        <cfoutput>Invalid Request: X-Token is blank</cfoutput>
        <cfabort>

        <cfelse>

        <cfset step = 1>
    
        <!--- /CFIf theToken is "" --->
        </cfif>
        
        
        <cfelse>
        
        <cfoutput>Invalid Request: X-Token is missing</cfoutput>
        <cfabort>
        
        <!--- /CFIF IsStruct( reqData ) AND StructKeyExists( reqData, "Headers" ) AND IsStruct( reqData.Headers ) AND StructKeyExists( reqData.Headers , "X-Token" ) --->
        </cfif>

<cfif #step# is "1">

    <cfquery name="gettoken" datasource="hermes">
        select token, ip from api_tokens where token like binary '#theToken#'
        </cfquery>
        
        <cfif #gettoken.recordcount# EQ 1>
        
        <cfloop index="theIpAddresses" list="#gettoken.ip#" delimiters=",">
        
        <cfset compare_ip = Compare(#theIP#, #trim(theIpAddresses)#)>
        
        <cfif #compare_ip# is "0">
        
        <!--- GENERATE VERIFY TOKEN --->
        <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
        select random_letter as random from captcha_list_all2 order by RAND() limit 32
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
            
        <cfset VerifyToken=#gettrans.customtrans2#>
            
        <cfquery name="deletetrans" datasource="hermes">
        delete from salt where id='#stResult.GENERATED_KEY#'
        </cfquery>
        
        <!--- INSERT VERIFY TOKEN IN DATABASE --->
        <CFQUERY NAME="createverifytoken" DATASOURCE="hermes">
        update api_tokens set verify = '#verifytoken#'
        where token like binary '#theToken#'
        </CFQUERY>



<cfexecute name="/usr/bin/curl"
arguments="-X 'POST' -k 'http://127.0.0.1:8888/#theUrl#' -H 'accept: */*' -H 'X-Token: #theToken#' -H 'X-Verify-Token: #VerifyToken#'"
variable="curlresult"
timeout="10" />

        
        <!---
        <cfoutput>Redirect: #theUrl#</cfoutput><br>       
        --->
        <cfoutput>Authorized</cfoutput>
           
        <cfelse>
        
        <cfoutput>Unauthorized Access: Invalid IP (#theIP#)</cfoutput> 
        
        
        <!--- /CFIF compare_ip is --->
        </cfif>
        
        </cfloop>
        
        <cfelseif #gettoken.recordcount# GT 1>
        
        <cfoutput>Unauthorized Access: Invalid Token GT 1</cfoutput> 
        <cfabort>
        
        <cfelseif #gettoken.recordcount# LT 1>
        
        <cfoutput>Unauthorized Access: Invalid Token LT 1</cfoutput> 
        <cfabort>
        
        <cfelse>
        <cfoutput>Unauthorized Access: Invalid Token Else</cfoutput> 
        <cfabort>
        
        <!--- gettoken.recordcount --->
        </cfif>

<!--- /CFIF step is 1 --->
</cfif>


