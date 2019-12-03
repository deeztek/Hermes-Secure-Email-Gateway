//----------DHTML Menu Created using AllWebMenus PRO ver 5.3-#934---------------
//C:\Users\dino.edwards\Dropbox\sites\hermes_secure_email_gateway_1404\hermes_secure_email_gateway_1404\AWM\hermes_secure_email_gateway_users.awm
var awmMenuName='hermes_seg_menu_users';
var awmLibraryBuild=934;
var awmLibraryPath='/awmdata';
var awmImagesPath='/awmdata/hermes_seg_menu_users';
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
var awmHash='IIWAGUEUGPBIXYJOFEVUFKYAUQFB';
var awmNoMenuPrint=1;
var awmUseTrs=0;
var awmSepr=["0","","",""];
var awmMarg=[0,0,0,0];
function awmBuildMenu(){
if (awmSupported){
awmImagesColl=["cross.png",9,9];
awmCreateCSS(0,1,0,n,n,n,n,n,'none','0','#000000','0px 0px 0px 0',0,'0px / 0px',n);
awmCreateCSS(1,2,1,'#FFFFFF',n,n,'bold 12px Verdana, Arial, Helvetica, sans-serif',n,'none','0','#000000','6px 8px 6px 8',1,'0px / 0px',n);
awmCreateCSS(0,2,1,'#FF0000',n,n,'bold 12px Verdana, Arial, Helvetica, sans-serif',n,'none','0','#000000','6px 8px 6px 8',1,'0px / 0px',n);
var s0=awmCreateMenu(0,0,0,0,1,0,0,0,0,10,10,0,1,0,0,1,1,n,n,100,1,0,0,0,0,-1,1,200,200,0,0,0,"0,0,0",n,n,n,n,n,n,n,n,0,0,0,0,0,0,0,0,1,0,0,2,n,n,'',n,0,[],0,"");
it=s0.addItemWithImages(1,2,2,"Mail Statistics &nbsp;",n,n,"",n,n,n,3,3,3,n,n,n,"index.cfm",n,n,n,"index.cfm",n,0,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,1,n);
it=s0.addItemWithImages(1,2,2,"Report Settings &nbsp;",n,n,"",n,n,n,3,3,3,n,n,n,"user_reports.cfm",n,n,n,"user_reports.cfm",n,0,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,2,n);
it=s0.addItemWithImages(1,2,2,"History &amp; Archive &nbsp;",n,n,"",n,n,n,3,3,3,n,n,n,"loading.cfm",n,n,n,"loading.cfm",n,0,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,9,n);
it=s0.addItemWithImages(1,2,2,"Sender Filters &nbsp;",n,n,"",n,n,n,3,3,3,n,n,n,"user_filters.cfm",n,n,n,"user_filters.cfm",n,0,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,13,n);
it=s0.addItemWithImages(1,2,2,"Spam/Virus Policy &nbsp;",n,n,"",n,n,n,3,3,3,n,n,n,"user_policy.cfm",n,n,n,"user_policy.cfm",n,0,0,2,n,n,n,n,n,n,0,0,0,0,0,n,n,n,0,0,0,19,n);
s0.pm.buildMenu();
}}