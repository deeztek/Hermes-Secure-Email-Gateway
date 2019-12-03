cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value true --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --email THE-RECIPIENT
