<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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

<cfoutput>
<cfset theUrl="/user-auth/?uid=#session.uid#&dest=1&mid=666&sid=666">
</cfoutput>

<!-- cfheaders anti cache--> 
<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT"> 
<CFHEADER NAME="Pragma" VALUE="no-cache"> 
<CFHEADER NAME="cache-control" VALUE="no-cache"> 
<!-- meta anti cache--> 
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"> 
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<!-- Kills the login session Variables --> 
<CFSET Session.UserLoggedin = FALSE> 
<cfset session.owner = "">
<cfset session.email = "">
<cfset session.uid = "">
<cfset session.train_bayes = "">
<cfset session.download_msg = "">

<cflocation url="#theUrl#" addtoken="false">

