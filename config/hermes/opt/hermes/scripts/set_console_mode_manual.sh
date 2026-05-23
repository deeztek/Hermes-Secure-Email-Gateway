#!/bin/bash

HERMES_SQL_USERNAME=`cat /opt/hermes/creds/hermes_username`
HERMES_SQL_PASSWORD=`cat /opt/hermes/creds/hermes_password`


PS3='Select the Console Mode you wish to set:'
options=("ip" "fqdn")
select opt in "${options[@]}"
do
    case $opt in
        "ip")

            echo "Setting IP Console Mode"

          break
            ;;
        "fqdn")

            echo "Setting FQDN Console Mode";
            break
            ;;

        *) echo "Invalid option $REPLY ";;
    esac
done


read -p "Enter the IP or FQDN you wish to set (Enter valid IP if setting IP Mode or valid FQDN if setting FQDN Mode:"  CONSOLE_HOST


echo "Setting Console Mode and Host"

mysql -h localhost -u $HERMES_SQL_USERNAME -p$HERMES_SQL_PASSWORD -e "use hermes; update parameters2 set value2='$opt'  where parameter='console.mode';"
mysql -h localhost -u $HERMES_SQL_USERNAME -p$HERMES_SQL_PASSWORD -e "use hermes; update parameters2 set value2='$CONSOLE_HOST' where parameter='console.host';"

echo "Done!!!"

