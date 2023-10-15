#!/bin/bash
docker exec -u www-data -it nextcloud  sh -c 'export OC_PASS="THE-PASSWORD" && /var/www/html/occ user:add --password-from-env --display-name "FULL-NAME" THE-USERNAME'

docker exec -u www-data nextcloud /var/www/html/occ mail:account:create THE-USERNAME "FULL-NAME" THE-EMAIL THE-IMAP-SERVER 993 ssl THE-IMAP-USERNAME THE-IMAP-PASSWORD THE-SMTP-SERVER 587 tls THE-SMTP-USERNAME THE-SMTP-PASSWORD password
