#!/bin/bash
/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.encryptMode --value mandatory --email THE-RECIPIENT

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pdf.encryptionAllowed --value false --email THE-RECIPIENT

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.pgp.enabled --value false --email THE-RECIPIENT

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.sMIMEEnabled --value true --email THE-RECIPIENT
