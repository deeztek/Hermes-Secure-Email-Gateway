  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->
  
<cfset build = "#trim(ListGetAt(cfhttp.FileContent, 3, "#chr(64)#"))#">
<cfset released = "#trim(ListGetAt(cfhttp.FileContent, 4, "#chr(64)#"))#">
<cfset filename = "#trim(ListGetAt(cfhttp.FileContent, 5, "#chr(64)#"))#">
<cfset releasenote = "#trim(ListGetAt(cfhttp.FileContent, 6, "#chr(64)#"))#">
<cfset releasenotefile = "#trim(ListGetAt(cfhttp.FileContent, 7, "#chr(64)#"))#">
<cfset mysqlroot = "#trim(ListGetAt(cfhttp.FileContent, 8, "#chr(64)#"))#">
<cfset dev = "#trim(ListGetAt(cfhttp.FileContent, 9, "#chr(64)#"))#">
<cfset remoteexpiration = "#trim(ListGetAt(cfhttp.FileContent, 10, "#chr(64)#"))#">
    
<table class="table table-striped"  style="width:100%">
<thead>
<tr>
  <th>Action</th>    
  <th>Status</th> 
  <th>Release Note</th>
  <th>Build No</th>
  <th>Release Date</th>
  <th>Install Date</th>
  <th>MySQL Root</th>
  <th>DEV Release</th>

</tr>
</thead>
<tbody>





<cfoutput>

<cfif FileExists("/opt/hermes/updates/#filename#")>

<tr>

  <cfif #mysqlroot# is "1">

    <td>


        <button a href="##installupdate_modal_mysql"  type="button" id="install" class="btn btn-secondary" data-toggle="modal" data-file="#filename#" data-build="#build#" data-released="#released#"><i class="fas fa-download"></i></button>

   


    </td>

<cfelse>

    <td>

        

<a href="##installupdate_modal"  type="button" id="install" class="btn btn-secondary" data-toggle="modal" data-file="#filename#" data-build="#build#" data-released="#released#">Install</a>




    </td>

    <!--- /CFIF #mysqlroot# is --->
</cfif>

<td>Downloaded</td>


  <cfelse>

  <td>

<cfoutput>
    <form name="Download" method="post">
    </cfoutput>
        <input type="hidden" name="action" value="downloadupdate" action="">
        <input type="hidden" name="file" value="#filename#">
        <input type="hidden" name="dev_release" value="#session.dev_release#">
        
          <input type="submit" class="btn btn-secondary" name="" value="Download" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
          </div>
            
          </form>



  </td>

  <td>Not Downloaded</td>


<!--- /CFIF FileExists("/opt/hermes/updates/#filename#") --->
</cfif>






  <td>


    <button onClick="window.open('https://updates.deeztek.com/downloads/hermes-#build#-release.txt');" type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-ip="" data-address="" data-note="" data-hermesadmin="" data-ciphermailadmin=""><i class="fas fa-search"></i></button>
    
    
    </td>



<td>#build#</td>

<td>
#released#
</td>

<td>

</td>

<cfif #mysqlroot# is "1">
<td>YES</td>

<cfelse>
<td>NO</td>

<!--- /CFIF #mysqlroot# is --->
</cfif>


<cfif #dev# is "1">
<td>YES</td>

<cfelse>
<td>NO</td>

<!--- /CFIF #dev# is --->
</cfif>

</tr>

</cfoutput>



<cfoutput query = "getupdates">

<tr>

<td></td>

<td>Installed</td>

<td>

  <button onClick="window.open('https://updates.deeztek.com/downloads/hermes-#build#-release.txt');" type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-ip="" data-address="" data-note="" data-hermesadmin="" data-ciphermailadmin=""><i class="fas fa-search"></i></button>
        
  </td>

  <td>#build#</td>

  <td>N/A</td>

  <td>#dateformat(date_installed, "mm/dd/yyyy")#</td>
  <td>N/A</td>
  <td>N/A</td>

</tr>

</cfoutput>






</tbody>

<tfoot>
<tr>

  <th>Action</th>   
  <th>Status</th> 
  <th>Release Note</th> 
  <th>Build No</th>
  <th>Release Date</th>
  <th>Install Date</th>
  <th>MySQL Root</th>
  <th>DEV Release</th>

</tr>
</tfoot>

</table>