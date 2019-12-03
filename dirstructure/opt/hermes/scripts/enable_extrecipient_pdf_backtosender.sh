cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.password --value "" --encrypt --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordsSendToOriginator --value true --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordValidityInterval --value PASSWORD-AGE --email THE-RECIPIENT

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.passwordLength --value PASSWORD-LENGTH --email THE-RECIPIENT



