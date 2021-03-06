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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Calendar</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="473">
            <tr valign="top" align="left">
              <td width="23" height="10"></td>
              <td width="450"></td>
            </tr>
            <tr valign="top" align="left">
              <td></td>
              <td width="450" id="Text36" class="TextObject">
                <p style="text-align: center; margin-bottom: 0px;"><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
   <title>Calendar</title>
</head>

<body>

<cfheader name="Expires" value="#Now()#">

<!--- Set the month and year parameters to equal the current values 
  if they do not exist. --->	
<cfparam name="month" default="#DatePart("m", Now())#">
<cfparam name="year" default="#DatePart("yyyy", Now())#">

<!--- Set the requested (or current) month/year date and determine the 
  number of days in the month. --->
<cfset ThisMonthYear = CreateDate(year, month, '1')>
<cfset Days = DaysInMonth(ThisMonthYear)>

<!--- Set the values for the previous and next months for the back/next links. --->
<cfset LastMonthYear = DateAdd("m", -1, ThisMonthYear)>
<cfset LastMonth = DatePart("m", LastMonthYear)>
<cfset LastYear = DatePart("yyyy", LastMonthYear)>

<cfset NextMonthYear = DateAdd("m", 1, ThisMonthYear)>
<cfset NextMonth = DatePart("m", NextMonthYear)>
<cfset NextYear = DatePart("yyyy", NextMonthYear)>

<script language="JavaScript">
<!--

// function to populate the date on the form and to close this window. --->
function ShowDate(DayOfMonth) {
  <cfoutput>
    var FormName="#FormName#";
    var FieldName="#FieldName#";
    var DateToShow="#month#/" + DayOfMonth + "/#year#";
    eval("self.opener.document." + FormName + "." + FieldName + ".value=DateToShow");
    window.close();
</cfoutput>
}

//-->
</script>

<table border="0">
  <tr>
    <td align="center">
      <!--- Display the current month/year as well as the back/next links. --->
      <cfoutput>
      <span class="label">
      <nobr>
        <a href="calendar.cfm?month=#LastMonth#&year=#LastYear#&FormName=#URLEncodedFormat(FormName)#&FieldName=#URLEncodedFormat(FieldName)#">&lt;&lt;</a>
        &nbsp;&nbsp;#MonthAsString(month)#&nbsp;#year#&nbsp;&nbsp;
        <a href="calendar.cfm?month=#NextMonth#&year=#NextYear#&FormName=#URLEncodedFormat(FormName)#&FieldName=#URLEncodedFormat(FieldName)#">&gt;&gt;</a>
      </nobr>
      </span>
      </cfoutput><p>

      <table border="1">
        <!--- Display the day of week headers.  I've truncated the values to display only 
          the first three letters of each day of the week.  --->
        <tr>
          <cfloop from="1" to="7" index="LoopDay">
            <cfoutput>
              <td width="50" align="center">
                <span class="label">#Left(DayOfWeekAsString(LoopDay), 3)#</span>
              </td>
            </cfoutput>
          </cfloop>
        </tr>

        <!--- Set the ThisDay variable to 0.  This value will remain 0 until the day 
          of the week on which the first day of the month falls on is reached. --->
        <cfset ThisDay = 0>

        <!--- Loop through until the number of days in the month is reached.  --->
        <cfloop condition="ThisDay LTE Days">
          <tr>
            <!--- Loop through each day of the week. --->
            <cfloop from="1" to="7" index="LoopDay">
              <!--- If ThisDay is still 0, check to see if the current day of the week 
                in the loop matches the day of the week for the first day of the 
                month. --->
              <!--- If the values match, set ThisDay to 1. --->
              <!--- Otherwise, the value will remain 0 until the correct day of 
                the week is found. --->
              <cfif ThisDay IS 0>
                <cfif DayOfWeek(ThisMonthYear) IS LoopDay>
                  <cfset ThisDay=1>
                </cfif>
              </cfif>
              <!--- If the ThisDay value is still 0, or it is greater than the number 
                of days in the month, display nothing in the column. --->
              <!--- Otherwise, display the day of the month and increment the value. --->
              <cfif (ThisDay IS NOT 0) AND (ThisDay LTE Days)>
                <cfoutput>
                  <td align="center">
                    <a href="javascript:ShowDate(#ThisDay#)"><span class="small">#ThisDay#</span></a>
                  </td>
                </cfoutput>
                <cfset ThisDay=ThisDay + 1>
              <cfelse>
                <td>&nbsp;</td>
              </cfif>
            </cfloop>
          </tr>
        </cfloop>
      </table>
    </td>
  </tr>
</table><p>

</body>
</html>
&nbsp;</p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
   