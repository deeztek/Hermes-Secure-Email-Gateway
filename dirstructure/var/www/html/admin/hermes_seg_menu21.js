//----------DHTML Menu Created using AllWebMenus PRO ver 5.3-#934---------------
//C:\Users\dino.edwards\Dropbox\sites\hermes_secure_email_gateway_1404\hermes_secure_email_gateway_1404\AWM\hermes_secure_email_gateway2.awm
var awmMenuName='hermes_seg_menu2';
var awmLibraryBuild=934;
var awmLibraryPath='/awmdata';
var awmImagesPath='/awmdata/hermes_seg_menu2';
var awmSupported=(navigator.appName + navigator.appVersion.substring(0,1)=="Netscape5" || document.all || document.layers || navigator.userAgent.indexOf('Opera')>-1 || navigator.userAgent.indexOf('Konqueror')>-1)?1:0;
if (awmSupported){
var nua=navigator.userAgent,scriptNo=(nua.indexOf('Chrome')>-1)?2:((nua.indexOf('Safari')>-1)?2:(nua.indexOf('Gecko')>-1)?2:((nua.indexOf('Opera')>-1)?2:1));
var mpi=document.location,xt="";
var mpa=mpi.protocol+"//"+mpi.host;
var mpi=mpi.protocol+"//"+mpi.host+mpi.pathname;
if(scriptNo==1){oBC=document.all.tags("BASE");if(oBC && oBC.length) if(oBC[0].href) mpi=oBC[0].href;}
while (mpi.search(/\\/)>-1) mpi=mpi.replace("\\","/");
mpi=mpi.substring(0,mpi.lastIndexOf("/")+1);
var mpin=mpi;
var e=document.getElementsByTagName("SCRIPT");
for (var i=0;i<e.length;i++){if (e[i].src){if (e[i].src.indexOf(awmMenuName+".js")!=-1){xt=e[i].src.split("/");if (xt[xt.length-1]==awmMenuName+".js"){xt=e[i].src.substring(0,e[i].src.length-awmMenuName.length-3);if (e[i].src.indexOf("://")!=-1){mpi=xt;}else{if(xt.substring(0,1)=="/")mpi=mpa+xt; else mpi+=xt;}}}}}
while (mpi.search(/\/\.\//)>-1) {mpi=mpi.replace("/./","/");}
var awmMenuPath=mpi.substring(0,mpi.length-1);
while (awmMenuPath.search("'")>-1) {awmMenuPath=awmMenuPath.replace("'","%27");}
document.write("<SCRIPT SRC='"+(awmMenuPath+awmLibraryPath).replace(/\/$/,"")+"/awmlib"+scriptNo+".js'><\/SCRIPT>");
var n=null;
awmzindex=1000;
}

var awmImageName='';
var awmPosID='';
var awmPosClass='';
var awmSubmenusFrame='';
var awmSubmenusFrameOffset;
var awmOptimize=0;
var awmHash='VGGUKTMOBOIQAWCCOIUOUUDAPGQE';
var awmNoMenuPrint=1;
var awmUseTrs=0;
var awmSepr=["0","","",""];
var awmMarg=[0,0,0,0];
function awmBuildMenu(){
if (awmSupported){
awmImagesColl=["arrow-down.png",10,5,"arrow-down-over.png",10,5,"BackgroundTile.gif",2,42,"arrow-right.png",5,10];
awmCreateCSS(0,1,0,n,n,n,n,n,'none','0','#000000','1px 1px 1px 1',0,'6px 6px 6px 6px / 6px 6px 6px 6px',n);
awmCreateCSS(1,2,1,'#FFFFFF',n,n,'14px Tahoma, Arial, Helvetica, sans-serif',n,'none','0','#000000','10px 2px 10px 0',1,'0px / 0px',n);
awmCreateCSS(0,2,1,'#F77108',n,n,'14px Tahoma, Arial, Helvetica, sans-serif',n,'none','0','#000000','10px 2px 10px 0',1,'0px / 0px',n);
awmCreateCSS(0,1,0,n,n,2,n,n,'solid','1','#D4D4D4','10px 0px 10px 0',0,'6px / 6px','rgba(0,0,0,0.2) 0px 10px 50px 3px');
awmCreateCSS(1,2,0,'#465567','#C0C1C4',2,'13px Tahoma, Arial, Helvetica, sans-serif',n,'none','0','#000000','7px 14px 7px 14',1,'0px / 0px',n);
awmCreateCSS(0,2,0,'#465567','#DCDEE4',n,'13px Tahoma, Arial, Helvetica, sans-serif',n,'solid none solid none','1px 0px 1px 0','#BABDC5 #000000 #FFFFFF #000000','7px 14px 7px 14',1,'0px / 0px',n);
var s0=awmCreateMenu(0,0,0,0,1,0,0,0,0,10,10,1,1,0,1,0,1,n,n,100,1,0,0,0,900,-1,1,200,200,0,0,1,"0,0,0",n,n,n,n,n,n,n,n,0,0,0,0,0,0,0,0,1,0,0,2,n,n,'',n,0,[],0,"");
it=s0.addItemWithImages(1,2,2,"System",n,n,"",n,n,n,3,3,3,0,1,1,"",n,n,n,n,n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,1,n);
var s1=it.addSubmenu(0,0,10,2,3,0,0,3,0,1,0,n,n,100,-1,1,0,-1,1,200,200,0,0,"0,0,0",1,"0",1,0,"");
it=s1.addItemWithImages(4,5,5,"Network Settings",n,n,"",n,n,n,3,3,3,n,n,n,"network_settings.cfm",n,n,n,"network_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,3,n);
it=s1.addItemWithImages(4,5,5,"Console SSL Settings",n,n,"",n,n,n,3,3,3,n,n,n,"console_ssl_settings.cfm",n,n,n,"console_ssl_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,29,n);
it=s1.addItemWithImages(4,5,5,"Admin Console Firewall",n,n,"",n,n,n,3,3,3,n,n,n,"firewall_settings.cfm",n,n,n,"firewall_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,32,n);
it=s1.addItemWithImages(4,5,5,"AD Integration",n,n,"",n,n,n,3,3,3,n,n,n,"ad_integration.cfm",n,n,n,"ad_integration.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,4,n);
it=s1.addItemWithImages(4,5,5,"System Settings",n,n,"",n,n,n,3,3,3,n,n,n,"./system_settings.cfm",n,n,n,"./system_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,5,n);
it=s1.addItemWithImages(4,5,5,"System Status",n,n,"",n,n,n,3,3,3,n,n,n,"index.cfm",n,n,n,"index.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,8,n);
it=s1.addItemWithImages(4,5,5,"Mail Queue Management",n,n,"",n,n,n,3,3,3,n,n,n,"loading_queue.cfm",n,n,n,"loading_queue.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,49,n);
it=s1.addItemWithImages(4,5,5,"System Logs",n,n,"",n,n,n,3,3,3,n,n,n,"system_logs.cfm",n,n,n,"system_logs.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,24,n);
it=s1.addItemWithImages(4,5,5,"Change Password",n,n,"",n,n,n,3,3,3,n,n,n,"./change_password.cfm",n,n,n,"./change_password.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,6,n);
it=s1.addItemWithImages(4,5,5,"System Backup",n,n,"",n,n,n,3,3,3,n,n,n,"system_backup.cfm",n,n,n,"system_backup.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,28,n);
it=s1.addItemWithImages(4,5,5,"System Restore",n,n,"",n,n,n,3,3,3,n,n,n,"system_restore.cfm",n,n,n,"system_restore.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,39,n);
it=s1.addItemWithImages(4,5,5,"Email Archive",n,n,"",n,n,n,3,3,3,n,n,n,"email_archive.cfm",n,n,n,"email_archive.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,44,n);
it=s1.addItemWithImages(4,5,5,"System Update",n,n,"",n,n,n,3,3,3,n,n,n,"system_update.cfm",n,n,n,"system_update.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,42,n);
it=s1.addItemWithImages(4,5,5,"System Reboot &amp; Shutdown",n,n,"",n,n,n,3,3,3,n,n,n,"system_restart.cfm",n,n,n,"system_restart.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,21,n);
it=s0.addItemWithImages(1,2,2,"Gateway",n,n,"",n,n,n,3,3,3,0,1,1,"",n,n,n,n,n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,9,n);
var s1=it.addSubmenu(0,0,10,2,3,0,0,3,0,1,0,n,n,100,-1,2,0,-1,1,200,200,0,0,"0,0,0",1,"0",1,0,"");
it=s1.addItemWithImages(4,5,5,"Certificate Signing Request",n,n,"",n,n,n,3,3,3,n,n,n,"create_csr.cfm",n,n,n,"create_csr.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,41,n);
it=s1.addItemWithImages(4,5,5,"SMTP TLS Settings",n,n,"",n,n,n,3,3,3,n,n,n,"smtp_tls_settings.cfm",n,n,n,"smtp_tls_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,30,n);
it=s1.addItemWithImages(4,5,5,"SMTP TLS Policy",n,n,"",n,n,n,3,3,3,n,n,n,"smtp_tls_policy.cfm",n,n,n,"smtp_tls_policy.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,36,n);
it=s1.addItemWithImages(4,5,5,"Relay Host",n,n,"",n,n,n,3,3,3,n,n,n,"relay_host.cfm",n,n,n,"relay_host.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,26,n);
it=s1.addItemWithImages(4,5,5,"Relay Domains",n,n,"",n,n,n,3,3,3,n,n,n,"relay_domains_new.cfm",n,n,n,"relay_domains_new.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,10,n);
it=s1.addItemWithImages(4,5,5,"Relay IPs &amp; Networks",n,n,"",n,n,n,3,3,3,n,n,n,"select.cfm",n,n,n,"select.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,11,n);
it=s1.addItemWithImages(4,5,5,"Internal Recipients",n,n,"",n,n,n,3,3,3,n,n,n,"recipients.cfm",n,n,n,"recipients.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,12,n);
it=s1.addItemWithImages(4,5,5,"Virtual Recipients",n,n,"",n,n,n,3,3,3,n,n,n,"./virtual.cfm",n,n,n,"./virtual.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,2,n);
it=s0.addItemWithImages(1,2,2,"Content Checks",n,n,"",n,n,n,3,3,3,0,1,1,"",n,n,n,n,n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,13,n);
var s1=it.addSubmenu(0,0,10,2,3,0,0,3,0,1,0,n,n,100,-1,3,0,-1,1,200,200,0,0,"0,0,0",1,"0",1,0,"");
it=s1.addItemWithImages(4,5,5,"Perimeter Checks",n,n,"",n,n,n,3,3,3,n,n,n,"perimeter_configuration.cfm",n,n,n,"perimeter_configuration.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,14,n);
it=s1.addItemWithImages(4,5,5,"RBL Configuration",n,n,"",n,n,n,3,3,3,n,n,n,"rbl.cfm",n,n,n,"rbl.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,15,n);
it=s1.addItemWithImages(4,5,5,"IP &amp; Network Override",n,n,"",n,n,n,3,3,3,n,n,n,"rbl_override.cfm",n,n,n,"rbl_override.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,17,n);
it=s1.addItemWithImages(4,5,5,"Sender Check Bypass",n,n,"",n,n,n,3,3,3,n,n,n,"sender_bypass.cfm",n,n,n,"sender_bypass.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,18,n);
it=s1.addItemWithImages(4,5,5,"DKIM Configuration",n,n,"",n,n,n,3,3,3,n,n,n,"dkim_configuration.cfm",n,n,n,"dkim_configuration.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,50,n);
it=s1.addItemWithImages(4,5,5,"DKIM Trusted Hosts",n,n,"",n,n,n,3,3,3,n,n,n,"dkim_trusted_hosts.cfm",n,n,n,"dkim_trusted_hosts.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,51,n);
it=s1.addItemWithImages(4,5,5,"DKIM Sign",n,n,"",n,n,n,3,3,3,n,n,n,"dkim_sign.cfm",n,n,n,"dkim_sign.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,52,n);
it=s1.addItemWithImages(4,5,5,"Antivirus Settings",n,n,"",n,n,n,3,3,3,n,n,n,"antivirus_settings.cfm",n,n,n,"antivirus_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,43,n);
it=s1.addItemWithImages(4,5,5,"Antivirus Signature Feeds",n,n,"",n,n,n,3,3,3,n,n,n,"antivirus_signature_feeds.cfm",n,n,n,"antivirus_signature_feeds.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,45,n);
it=s1.addItemWithImages(4,5,5,"Antivirus Signature Bypass",n,n,"",n,n,n,3,3,3,n,n,n,"antivirus_signature_bypass.cfm",n,n,n,"antivirus_signature_bypass.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,46,n);
it=s1.addItemWithImages(4,5,5,"Antispam Settings",n,n,"",n,n,n,3,3,3,n,n,n,"spam_settings.cfm",n,n,n,"spam_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,27,n);
it=s1.addItemWithImages(4,5,5,"Custom Antispam Filter Tests",n,n,"",n,n,n,3,3,3,n,n,n,"spam_filter_tests.cfm",n,n,n,"spam_filter_tests.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,35,n);
it=s1.addItemWithImages(4,5,5,"Initialize Pyzor",n,n,"",n,n,n,3,3,3,n,n,n,"initialize_pyzor.cfm",n,n,n,"initialize_pyzor.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,37,n);
it=s1.addItemWithImages(4,5,5,"Initialize Vipul&#39;s Razor",n,n,"",n,n,n,3,3,3,n,n,n,"initialize_razor.cfm",n,n,n,"initialize_razor.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,38,n);
it=s1.addItemWithImages(4,5,5,"Clear Bayes Database",n,n,"",n,n,n,3,3,3,n,n,n,"clear_bayes.cfm",n,n,n,"clear_bayes.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,33,n);
it=s1.addItemWithImages(4,5,5,"Custom File Extensions",n,n,"",n,n,n,3,3,3,n,n,n,"file_extensions.cfm",n,n,n,"file_extensions.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,34,n);
it=s1.addItemWithImages(4,5,5,"Custom File Expressions",n,n,"",n,n,n,3,3,3,n,n,n,"file_expressions.cfm",n,n,n,"file_expressions.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,40,n);
it=s1.addItemWithImages(4,5,5,"Message Rules",n,n,"",n,n,n,3,3,3,n,n,n,"message_rules.cfm",n,n,n,"message_rules.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,48,n);
it=s1.addItemWithImages(4,5,5,"File Rules",n,n,"",n,n,n,3,3,3,n,n,n,"file_rules.cfm",n,n,n,"file_rules.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,31,n);
it=s1.addItemWithImages(4,5,5,"SVF Policies",n,n,"",n,n,n,3,3,3,n,n,n,"spam_policies.cfm",n,n,n,"spam_policies.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,16,n);
it=s1.addItemWithImages(4,5,5,"Message History &amp; Archive",n,n,"",n,n,n,3,3,3,n,n,n,"loading4.cfm",n,n,n,"loading4.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,25,n);
it=s0.addItemWithImages(1,2,2,"Encryption",n,n,"",n,n,n,3,3,3,0,1,1,"",n,n,n,n,n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,19,n);
var s1=it.addSubmenu(0,0,10,2,3,0,0,3,0,1,0,n,n,100,-1,4,0,-1,1,200,200,0,0,"0,0,0",1,"0",1,0,"");
it=s1.addItemWithImages(4,5,5,"Internal Certficate Authority",n,n,"",n,n,n,3,3,3,n,n,n,"ca_settings.cfm",n,n,n,"ca_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,20,n);
it=s1.addItemWithImages(4,5,5,"PGP Key Servers",n,n,"",n,n,n,3,3,3,n,n,n,"key_servers.cfm",n,n,n,"key_servers.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,47,n);
it=s1.addItemWithImages(4,5,5,"Encryption Settings",n,n,"",n,n,n,3,3,3,n,n,n,"encryption_settings.cfm",n,n,n,"encryption_settings.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,7,n);
it=s1.addItemWithImages(4,5,5,"Internal Recipients Encryption",n,n,"",n,n,n,3,3,3,n,n,n,"internal_encryption_users.cfm",n,n,n,"internal_encryption_users.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,0,n);
it=s1.addItemWithImages(4,5,5,"External Recipients Encryption",n,n,"",n,n,n,3,3,3,n,n,n,"external_encryption_users.cfm",n,n,n,"external_encryption_users.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,22,n);
it=s0.addItemWithImages(1,2,2,"Logout",n,n,"",n,n,n,3,3,3,n,n,n,"./logout.cfm",n,n,n,"./logout.cfm",n,130,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,23,n);
s0.pm.buildMenu();
}}