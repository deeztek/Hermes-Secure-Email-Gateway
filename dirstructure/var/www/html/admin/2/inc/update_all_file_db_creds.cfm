
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


<!--- UPDATE /opt/hermes/creds/ SECTION STARTS HERE --->

<cffile action = "write"
    file = "/opt/hermes/creds/hermes_username"
    output = "#show_mysql_username_hermes#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/hermes_password"
    output = "#show_mysql_password_hermes#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/syslog_username"
    output = "#show_mysql_username_syslog#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/syslog_password"
    output = "#show_mysql_password_syslog#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/ciphermail_username"
    output = "#show_mysql_username_djigzo#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/ciphermail_password"
    output = "#show_mysql_password_djigzo#"
    nameconflict="overwrite"> 
    
    
    <cffile action = "write"
    file = "/opt/hermes/creds/opendmarc_username"
    output = "#show_mysql_username_opendmarc#"
    nameconflict="overwrite"> 

    <cffile action = "write"
    file = "/opt/hermes/creds/opendmarc_password"
    output = "#show_mysql_password_opendmarc#"
    nameconflict="overwrite"> 


<!--- UPDATE /opt/hermes/creds/ SECTION ENDS HERE --->