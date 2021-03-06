<cfparam name = "StartRow" default = "0"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "25"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>


<cfparam name = "s" default = ""> 
<cfif IsDefined("url.s") is "True">
<cfif url.s is not "">
<cfset s = url.s>
</cfif></cfif>

<cfparam name = "f" default = ""> 
<cfif IsDefined("url.f") is "True">
<cfif url.f is not "">
<cfset f = url.f>
</cfif></cfif>

<cfparam name = "a" default = ""> 
<cfif IsDefined("url.a") is "True">
<cfif url.a is not "">
<cfset a = url.a>
</cfif></cfif>


<cfparam name = "mid" default = ""> 
<cfif IsDefined("url.mid") is "True">
<cfif url.mid is not "">
<cfset mid = url.mid>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 


<cfparam name = "m3" default = ""> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif> 

<cfparam name = "startdate" default = ""> 
<cfif IsDefined("url.startdate") is "True">
<cfif url.startdate is not "">
<cfif isValid("date", #url.startdate#)> 
<cfset startdate = url.startdate>
<cfelseif NOT isValid("date", #url.startdate#)>
<cflocation url="error.cfm?reason=startdateinvalid" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("url.enddate") is "True">
<cfif url.enddate is not "">
<cfif isValid("date", #url.enddate#)> 
<cfset enddate = url.enddate>
<cfelseif NOT isValid("date", #url.enddate#)>
<cflocation url="error.cfm?reason=enddateinvalid" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "starttime" default = ""> 
<cfif IsDefined("url.starttime") is "True">
<cfif url.starttime is not "">
<cfif isValid("time", #url.starttime#)> 
<cfset starttime = url.starttime>
<cfelseif NOT isValid("time", #url.starttime#)>
<cflocation url="error.cfm?reason=starttimeinvalid" addtoken="no">
</cfif>
</cfif>
</cfif>

<cfparam name = "endtime" default = ""> 
<cfif IsDefined("url.endtime") is "True">
<cfif url.endtime is not "">
<cfif isValid("time", #url.endtime#)> 
<cfset endtime = url.endtime>
<cfelseif NOT isValid("time", #url.endtime#)>
<cflocation url="error.cfm?reason=endtimeinvalid" addtoken="no">
</cfif>
</cfif>
</cfif>


<cfoutput>
<cfparam name="URL.redirect"
 default="view_message.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&startdate=#startdate#&enddate=#enddate#&starttime=#starttime#&endtime=#endtime#&action=#action#&m3=#m3#&a=#a#&s=#s#&f=#f#&mid=#URLEncodedFormat(Trim(url.mid))#">
</cfoutput>

<html>

<head>
<title>Loading...</title>
<script language="JavaScript">
if(document.images) image1 = new Image(); image1.src = 'ajax-loader.gif';
</script>
<cfoutput><meta http-equiv="refresh" content="3;url=#URL.redirect#"></cfoutput>
</head>
<br><br><br><br><br><br><br><br>
<body style="background-image: url(ajax-loader.gif); background-repeat: no-repeat; background-position: 50% 50%;">

</body>

</html>