
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


<html lang="en">
    <head>
    
    
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Hermes SEG | Error</title>
    
      <!-- Google Font: Source Sans Pro -->
      <!---
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
      --->
      <!-- Font Awesome -->
      <link rel="stylesheet" href="./plugins/fontawesome-free/css/all.min.css">
      <!-- icheck bootstrap -->
      <link rel="stylesheet" href="./plugins/icheck-bootstrap/icheck-bootstrap.min.css">
      <!-- Theme style -->
      <link rel="stylesheet" href="./dist/css/adminlte.min.css">
    </head>
    

<div class="alert alert-danger" style="display: inline-block; text-align: center;"><i class="fa fa-exclamation-triangle fa-5x"></i>
	<p>We apologize for the inconvenience but a system error has occurred or malicious activity has been detected or database credentials are missing/incorrect</p>

<cfparam name = "m" default = ""> 
<cfif #m# is not "">

<cfoutput>
<p>
<h5>Page Specific Error below</h5>
#m#
</p>
</cfoutput>

<!--- /CFIF #m# is not "" --->
</cfif>



	

	<p>Attempting to modify a URL parameter or form input or attempting to use certain keywords such as (select, update etc.) in form fields will generate this error. Please go back to retry your operation without modifying any system URLs and/or change your form input with fields that are not banned. Additionally, verify the database credentials are correct under System --&gt; System Settings.</p>

	<p>If you have any further questions, please contact support</p>
</div>