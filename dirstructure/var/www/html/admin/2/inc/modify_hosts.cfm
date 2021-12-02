
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