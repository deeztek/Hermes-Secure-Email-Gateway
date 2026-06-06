#!/bin/bash

#Set Font Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

#The script below assumes you have a install docker

#Ensure Script is run as root and if not exit
if [ `id -u` -ne 0 ]; then
      echo "${RED}This script must be executed as root, Exiting... ${RESET}"
      exit 1
   fi

#Check if /usr/bin/docker exists and if not exit
if [ ! -f "/usr/bin/docker" ]; then
      echo "${RED}Docker does not seem to be installed. Please install Docker and try again. Exiting for now... ${RESET}"
      exit 1
   fi


#GET INPUTS
echo "Certbot Certificate Staging" | boxes -d stone -p a2v1

PS3='Ensure that both ports 80/TCP and 443/TCP are Internet accessible and the Hermes SEG FQDN you are going to use is pointing to the public IP address of this machine. Do you wish to continue?: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            echo "Starting Certbot Certificate Staging"

          
          break
            ;;
        "No")

            echo "Exiting Certbot Certificate Staging";
            exit
            ;;

        *) echo "invalid option $REPLY";;
    esac
done

#=== GET USER INPUTS STARTS HERE ===

read -p "Enter the FQDN of your Hermes SEG (Example: smtp.domain.tld):"  HERMES_FQDN

if [ -z "$HERMES_FQDN" ]
then
      echo "${RED}The Hermes FQDN cannot be empty ${RESET}"
      exit
fi

#Export the variable
export HERMES_FQDN

docker run -it --rm --name hermes_certbot -v ./config/hermes/var/www/html:/var/www/certbot -v ./config/certbot/conf:/etc/letsencrypt -v ./config/certbot/logs:/var/log certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot --email someone@example.com --agree-tos --no-eff-email --dry-run -d $HERMES_FQDN
