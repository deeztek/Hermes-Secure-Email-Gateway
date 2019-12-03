cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.otpEnabled --value false --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value false --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordValidityInterval --value "-60000" --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.password --value THE-PASSWORD --encrypt --email THE-RECIPIENT

