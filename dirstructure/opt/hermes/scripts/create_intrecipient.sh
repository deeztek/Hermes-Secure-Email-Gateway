cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --add-user THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.locality --value internal --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value noEncryption --email THE-RECIPIENT

