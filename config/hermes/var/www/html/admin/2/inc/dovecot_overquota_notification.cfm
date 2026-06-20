<cfif StructKeyExists(url, "user") AND StructKeyExists(url, "percent")>

    <cfif IsValid("email", #url.user#) AND IsValid("integer", #url.percent#)>
    
       
    <cfset sendemail = 1>
     
   
    <cfelse>
    
    <cfset sendemail = 0>

    <!--- /CFIF IsValid --->
    </cfif>

    <cfelse>

    <cfset sendemail = 0>
    
    <!--- /CFIF StructKeyExists(url, "sendemail") --->
    </cfif>
    

      
<cfif #sendemail# is "1">


<cfquery name="getpostmaster" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>

<cfquery name="getuserdetails" datasource="hermes">
    select name, quota from mailboxes where username = '#url.user#'
    </cfquery>
   
<cfset mailboxsize = #getuserdetails.quota#/1024/1024/1024>

<cfif #url.percent# GTE 99> 

    <cfmail from="#getpostmaster.value#" to="#TRIM(url.user)#" subject="[Hermes SEG] Mailbox Quota Exceeded!!" type="HTML" server="hermes_postfix_dkim" port="10026">




        <HTML>
            <head><title>Hermes SEG Mailbox Quota Exceeded Notification</title>
     
            </head>

            <body>
                <!--- Style Tag in the Body, not Head, for Email --->
     
     <style type="text/css">
     table.bottomBorder { border-collapse:collapse; }
     table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
     </style>
     
     <div align="center">

        *** Please do not reply to this e-mail. This mailbox is not monitored ***
     </div>
  
     
     <table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
       <tr style="height: 75px;">
         <td style="background-color: rgb(255,255,255);">
           <p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" style="max-height: 80px; width: auto;" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p>
         </td>
       </tr>
     
     
     
           <td  align="center">
 
                     
     
          <h2>Mailbox Quota Exceeded Notification for #getuserdetails.name#</h2>

          <p>

            Your mailbox <b>(jsmith@example.com)</b> has reached <b>100%</b> usage. You will no longer be able to send or receive e-mail until you bring the usage below 100% by deleting unnecessary messages from your mailbox including the <b>Trash</b> folder. Your mailbox has <b>0.02 GB</b> of storage quota. If you need additional storage please contact to your Administrator.

        
     </p>

    </td>
     
           </table>
     
            </body>
         </HTML>


         <cfmailparam
         file="/opt/hermes/email/hermes_top_banner_email.png"
         contentid="hermeslogo"
         disposition="inline"
         />
         
         <cfmailparam
         file="/opt/hermes/email/view_icon.png"
         contentid="hermesview"
         disposition="inline"
         />
         
         <cfmailparam
         file="/opt/hermes/email/assign_icon.png"
         contentid="hermesrelease"
         disposition="inline"
         />
         
         </cfmail>
 

        <cfelseif #url.percent# LT 99 AND #url.percent# GTE 80>    

            <cfmail from="#getpostmaster.value#" to="#TRIM(url.user)#" subject="[Hermes SEG] Mailbox Quota Notification" type="HTML" server="hermes_postfix_dkim" port="10026">

        <HTML>
           <head><title>Hermes SEG Mailbox Quota Notification</title>
    
           </head>
           <body>
               <!--- Style Tag in the Body, not Head, for Email --->

    
    <style type="text/css">
    table.bottomBorder { border-collapse:collapse; }
    table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
    </style>
    
    <div align="center">

        *** Please do not reply to this e-mail. This mailbox is not monitored ***
     </div>


    <table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
      <tr style="height: 75px;">
        <td style="background-color: rgb(255,255,255);">
          <p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" style="max-height: 80px; width: auto;" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p>
        </td>
      </tr>
    
    
    

    
      <td  align="center">
          
    
          <h2>Mailbox Quota Notification for #getuserdetails.name#</h2>
    
          <p>
            Your mailbox <b>(#url.user#)</b> has reached <b>#url.percent#%</b> usage. Once your mailbox reaches 100% usage you will no longer be able to send or receive e-mail. Please delete unnecessary messages from your mailbox including the <b>Trash</b> folder. Your mailbox has <b>#Numberformat (mailboxsize, '____.__')# GB</b> of storage quota. If you need additional storage please contact to your Administrator.
 
       
    </p>
    
</td>
    
          </table>
    
           </body>
        </HTML>
    


        <cfmailparam
        file="/opt/hermes/email/hermes_top_banner_email.png"
        contentid="hermeslogo"
        disposition="inline"
        />
        
        <cfmailparam
        file="/opt/hermes/email/view_icon.png"
        contentid="hermesview"
        disposition="inline"
        />
        
        <cfmailparam
        file="/opt/hermes/email/assign_icon.png"
        contentid="hermesrelease"
        disposition="inline"
        />
        
        </cfmail>
   



    <cfelseif #url.percent# EQ -100>    

        <cfmail from="#getpostmaster.value#" to="#TRIM(url.user)#" subject="[Hermes SEG] Mailbox Under Quota Notification" type="HTML" server="hermes_postfix_dkim" port="10026">

    <HTML>
       <head><title>Hermes SEG Mailbox Under Quota Notification</title>

       </head>
       <body>
           <!--- Style Tag in the Body, not Head, for Email --->


<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>

<div align="center">

    *** Please do not reply to this e-mail. This mailbox is not monitored ***
 </div>


<table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
  <tr style="height: 75px;">
    <td style="background-color: rgb(255,255,255);">
      <p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" style="max-height: 80px; width: auto;" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p>
    </td>
  </tr>





  <td  align="center">
      

      <h2>Mailbox Under Quota Notification for #getuserdetails.name#</h2>

      <p>
        Your mailbox <b>(#url.user#)</b> is no longer over quota. You can now resume sending and receiving e-mail as usual.

   
</p>

</td>

      </table>

       </body>
    </HTML>



    <cfmailparam
    file="/opt/hermes/email/hermes_top_banner_email.png"
    contentid="hermeslogo"
    disposition="inline"
    />
    
    <cfmailparam
    file="/opt/hermes/email/view_icon.png"
    contentid="hermesview"
    disposition="inline"
    />
    
    <cfmailparam
    file="/opt/hermes/email/assign_icon.png"
    contentid="hermesrelease"
    disposition="inline"
    />
    
    </cfmail>


<!--- /CFIF #url.percent# --->
        </cfif>



        <!--- /CFIF #sendemail# is "1" --->
    </cfif>
    
    