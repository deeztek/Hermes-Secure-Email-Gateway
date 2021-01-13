cd /usr/share/djigzo

#Set user.otbEnabled to true in order to fix Github Issue #9
/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.otpEnabled --value true --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.pdf.replySender --value PDFREPLY-SENDER --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.portal.baseURL --value PORTAL-URL --global

#/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.sendEncryptionNotification --value ENCRYPT-RECEIPT --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.subjectTrigger --value SUBJECT-TRIGGER --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.subjectTriggerEnabled --value SUBJECT-ENABLE --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.subjectTriggerRemovePattern --value TRIGGER-REMOVE --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.serverSecret --value SERVER-SECRET --encrypt --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.clientSecret --value CLIENT-SECRET --encrypt --global

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.systemMailSecret --value MAIL-SECRET --encrypt --global





