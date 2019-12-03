/bin/mkdir /opt/hermes/tmp/hermes-HERMES-BUILD

/bin/tar -xvzf /opt/hermes/tmp/hermes-HERMES-BUILD.tar.gz -C /opt/hermes/tmp/hermes-HERMES-BUILD

/bin/sed -i 's/HERMES-SQL-USERNAME/HERMESSQLUSERNAME/g' /opt/hermes/tmp/hermes-HERMES-BUILD/install.sh

/bin/sed -i 's/HERMES-SQL-PASSWORD/HERMESSQLPASSWORD/g' /opt/hermes/tmp/hermes-HERMES-BUILD/install.sh

/bin/chmod +x /opt/hermes/tmp/hermes-HERMES-BUILD/install.sh

/opt/hermes/tmp/hermes-HERMES-BUILD/install.sh

