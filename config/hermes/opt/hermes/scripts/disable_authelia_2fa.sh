#REPLACE ALL INSTANCES OF TWO_FACTOR WITH ONE_FACTOR IN /ETC/AUTHELIA/USERS_DATABASE.YML
/bin/sed -i -e "s/two_factor/one_factor/g" "/etc/authelia/users_database.yml"

#RESTART AUTHELIA
/bin/systemctl restart authelia

echo "2FA Disabled for ALL Users"
