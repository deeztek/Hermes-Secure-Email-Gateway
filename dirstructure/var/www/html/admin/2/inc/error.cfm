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