#!/bin/bash
/usr/local/bin/docker exec hermes_ciphermail /usr/bin/java -cp '/usr/share/djigzo/lib/*' mitm.application.djigzo.tools.CLITool --encode-password THE-PASSWORD >> /opt/hermes/tmp/THE-CODE_password
