/bin/cp /var/www/WEB-INF/railo/cfclasses/CF_var_www282/hermes/* /opt/hermes/compile/hermes
/bin/cp /var/www/WEB-INF/railo/cfclasses/CF_var_www282/main/* /opt/hermes/compile/main
/bin/cp /var/www/WEB-INF/railo/cfclasses/CF_var_www282/users/* /opt/hermes/compile/users
/bin/cp /var/www/WEB-INF/railo/cfclasses/CF_var_www282/schedule/* /opt/hermes/compile/schedule

/usr/bin/rename  's/_cfm\$cf.class/.cfm/g' /opt/hermes/compile/hermes/*
/usr/bin/rename  's/_cfm\$cf.class/.cfm/g' /opt/hermes/compile/main/*
/usr/bin/rename  's/_cfm\$cf.class/.cfm/g' /opt/hermes/compile/users/*
/usr/bin/rename  's/_cfm\$cf.class/.cfm/g' /opt/hermes/compile/schedule/*

/bin/rm -rf /var/www/hermes/*.cfm
/bin/rm -rf /var/www/main/*.cfm
/bin/rm -rf /var/www/users/*.cfm
/bin/rm -rf /var/www/schedule/*.cfm

/bin/cp /opt/hermes/compile/hermes/*.cfm /var/www/hermes
/bin/cp /opt/hermes/compile/main/*.cfm /var/www/main
/bin/cp /opt/hermes/compile/users/*.cfm /var/www/users
/bin/cp /opt/hermes/compile/schedule/*.cfm /var/www/schedule

/bin/rm -rf /opt/hermes/compile/hermes/*.cfm
/bin/rm -rf /opt/hermes/compile/main/*.cfm
/bin/rm -rf /opt/hermes/compile/users/*.cfm
/bin/rm -rf /opt/hermes/compile/schedule/*.cfm

/bin/mv /var/www/hermes/application.cfm /var/www/hermes/Application.cfm
/bin/mv /var/www/users/application.cfm /var/www/users/Application.cfm
/bin/mv /var/www/main/application.cfm /var/www/main/Application.cfm
/bin/mv /var/www/schedule/application.cfm /var/www/schedule/Application.cfm
