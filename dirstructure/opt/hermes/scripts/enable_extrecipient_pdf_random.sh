cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.password --value "" --encrypt --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value false --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.otpEnabled --value true --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.autoCreateClientSecret --value true --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordLength --value 16 --email THE-RECIPIENT



