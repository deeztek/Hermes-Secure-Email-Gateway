#!/bin/bash
/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --set-property user.onlySignWhenEncrypt --value THE-SIGN --email THE-RECIPIENT
