cd /usr/share/djigzo

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --add-domain THE-DOMAIN

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.locality --value internal --domain THE-DOMAIN

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value noEncryption --domain THE-DOMAIN

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --domain THE-DOMAIN

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value false --domain THE-DOMAIN

/usr/bin/java -cp djigzo.jar mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --domain THE-DOMAIN
