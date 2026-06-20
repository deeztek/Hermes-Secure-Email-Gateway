#!/bin/bash
USERNAME=THE-USERNAME
PASSWORD=THE-PASSWORD
TRANSACTION=THE-TRANSACTION

/usr/local/bin/docker exec hermes_db_server /usr/bin/mariadb --local-infile=1 -u $USERNAME -p$PASSWORD hermes  -e "LOAD DATA LOCAL INFILE '/opt/hermes/tmp/$TRANSACTION-mailqueue_list' INTO TABLE postfix_queue FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' IGNORE 1 LINES (QueueID,Sender,Recipient,ConnectionStatus,MsgStatus);"

