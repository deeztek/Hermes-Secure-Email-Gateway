<cfquery name="getsystoken" datasource="hermes">
    select token from api_tokens where name='Built-In System' and system='1' and active='1'
    </cfquery>