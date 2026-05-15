<cfquery name="getrandom_512" datasource="hermes" result="getrandom_results">
  select random_letter as random_512 from captcha_list order by RAND() limit 30
  </cfquery>
  
  <cfquery name="insert_salt_512" datasource="hermes" result="stResult512">
  insert into salt
  (salt)
  values
  ('<cfoutput query="getrandom_512">#TRIM(random_512)#</cfoutput>')
  </cfquery>
  
  <cfquery name="getsalt_512" datasource="hermes">
  select salt as salt_512 from salt where id='#stResult512.GENERATED_KEY#'
  </cfquery>
  
  <cfset salt512=#getsalt_512.salt_512#>
  
  <cfquery name="deletesalt512" datasource="hermes">
  delete from salt where id='#stResult512.GENERATED_KEY#'
  </cfquery>


<cfset saltHash512=Hash(salt512, 'SHA-512', 'UTF-8') />

<cfset passwordHash512=Hash("password" & saltHash512, 'SHA-512', 'UTF-8') />

<cfset passwordandsalt = #lcase(passwordHash512 & saltHash512)#>

<cfset passwordandsalt = "{SSHA512.hex}#passwordandsalt#">

<cfoutput>
Salt: #lcase(saltHash512)#<br>
Password: #lcase(passwordHash512)#<br>
saltandpassword: #passwordandsalt#
</cfoutput>