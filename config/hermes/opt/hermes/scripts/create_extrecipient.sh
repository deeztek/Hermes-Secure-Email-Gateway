#!/bin/bash
/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --add-user THE-RECIPIENT

/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.locality --value external --email THE-RECIPIENT
