
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>test2</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="531">
    <tr valign="top" align="left">
      <td width="50" height="41"></td>
      <td width="481"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="481" id="Text442" class="TextObject"><cfset date = "2018-11-11">
<cfset theDate = REReplaceNoCase(date,"-","","all")>

<cfoutput>The Date: #theDate#<br></cfoutput>

<cfquery name="year1" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 10
</cfquery>

<cfquery name="insert_year1" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="year1">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getyear1" datasource="#datasource#">
select salt as year1 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset year1_salt=#getyear1.year1#>

<cfoutput>Year1 Salt: #year1_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="year2" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 3
</cfquery>

<cfquery name="insert_year2" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="year2">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getyear2" datasource="#datasource#">
select salt as year2 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset year2_salt=#getyear2.year2#>

<cfoutput>Year2 Salt: #year2_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="year3" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 1
</cfquery>

<cfquery name="insert_year3" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="year3">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getyear3" datasource="#datasource#">
select salt as year3 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset year3_salt=#getyear3.year3#>

<cfoutput>Year3 Salt: #year3_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="year4" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 4
</cfquery>

<cfquery name="insert_year4" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="year4">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getyear4" datasource="#datasource#">
select salt as year4 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset year4_salt=#getyear4.year4#>

<cfoutput>Year4 Salt: #year4_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="month1" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 2
</cfquery>

<cfquery name="insert_month1" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="month1">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getmonth1" datasource="#datasource#">
select salt as month1 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset month1_salt=#getmonth1.month1#>

<cfoutput>Month1 Salt: #month1_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="month2" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 2
</cfquery>

<cfquery name="insert_month2" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="month2">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getmonth2" datasource="#datasource#">
select salt as month2 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset month2_salt=#getmonth2.month2#>

<cfoutput>Month2 Salt: #month2_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="day1" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 6
</cfquery>

<cfquery name="insert_day1" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="day1">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getday1" datasource="#datasource#">
select salt as day1 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset day1_salt=#getday1.day1#>

<cfoutput>Day1 Salt: #day1_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="day2" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 3
</cfquery>

<cfquery name="insert_day2" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="day2">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getday2" datasource="#datasource#">
select salt as day2 from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset day2_salt=#getday2.day2#>

<cfoutput>Day2 Salt: #day2_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfquery name="last" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all3 order by RAND() limit 1
</cfquery>

<cfquery name="insert_last" datasource="#datasource#" result="stResult512">
insert into salt
(salt)
values
('<cfoutput query="last">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="getlast" datasource="#datasource#">
select salt as last from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>

<cfset last_salt=#getlast.last#>

<cfoutput>Last Salt: #last_salt#</cfoutput><br>

<cfquery name="deletesalt" datasource="#datasource#">
delete from salt where id='#stResult512.GENERATED_KEY#'
</cfquery>


<cfset year1="#mid(theDate, 1, 1)#">
<cfset year2="#mid(theDate, 2, 1)#">
<cfset year3="#mid(theDate, 3, 1)#">
<cfset year4="#mid(theDate, 4, 1)#">
<cfset month1="#mid(theDate, 5, 1)#">
<cfset month2="#mid(theDate, 6, 1)#">
<cfset day1="#mid(theDate, 7, 1)#">
<cfset day2="#mid(theDate, 8, 1)#">



<cfoutput>The Date Again: <br>#year1#<br>#year2#<br>#year3#<br>#year4#<br>#month1#<br>#month2#<br>#day1#<br>#day2#<br></cfoutput>

<cfset theResponse="#LCase(year1_salt)##year1##LCase(year2_salt)##year2##LCase(year3_salt)##year3##LCase(year4_salt)##year4##LCase(month1_salt)##month1##LCase(month2_salt)##month2##LCase(day1_salt)##day1##LCase(day2_salt)##day2##LCase(last_salt)#-e2a8aca48c5b24df14c6e0ab0b30df7ed50fa97bc22fd706c71a7eebe96a8b67">

<cfoutput>The Response: #theResponse#</cfoutput><br>

<cfset right64=#Right(theResponse,64)#>
<cfset left40=#Left(theResponse,40)#>

<cfoutput>Right 64: #right64#</cfoutput><br>

<cfoutput>Left 40: #left40#</cfoutput><br>

<cfset response="SUCCESS">

<cfexecute name = "/opt/hermes/scripts/dmidecode"
arguments=""
timeout = "60">
</cfexecute>

<cffile action="read" file="/usr/share/UUID" variable="temp1">

<cfset temp2="#REReplace("#temp1#","#chr(10)#","","ALL")#">

<cfset temp3="#REReplace("#temp2#","#chr(13)#","","ALL")#">
<cfset temp4="#REReplace("#temp3#","","","ALL")#">
<cfset temp5="#REReplace("#temp4#","UUID:","","ALL")#">

<cfset temp5 = #trim(temp5)#>


<cfoutput> String to Hash: #temp5##response#</cfoutput><br>

<cfset theHash=Hash(temp5 & response, 'SHA-256', 'UTF-8')>

<cfoutput>The Hash: #theHash#</cfoutput>
        <p style="margin-bottom: 0px;">&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
   