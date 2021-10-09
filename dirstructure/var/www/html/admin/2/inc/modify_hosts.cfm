<cffile action="read" file="/opt/hermes/conf_files/hosts.HERMES" variable="hosts">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#hosts"
      output = "#REReplace("#hosts#","SERVER-NAME","#ServerName#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#hosts" variable="hosts">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#hosts"
      output = "#REReplace("#hosts#","SERVER-DOMAIN","#ServerDomain#","ALL")#">
      
  <!--- MODIFY /etc/mailname --->    
  
  <cffile action="read" file="/opt/hermes/conf_files/mailname.HERMES" variable="mailname">
  
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#mailname"
      output = "#REReplace("#mailname#","SERVER-NAME","#ServerName#","ALL")#">
  
  <cffile action="read" file="/opt/hermes/tmp/#customtrans3#mailname" variable="mailname">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#mailname"
      output = "#REReplace("#mailname#","SERVER-DOMAIN","#ServerDomain#","ALL")#">