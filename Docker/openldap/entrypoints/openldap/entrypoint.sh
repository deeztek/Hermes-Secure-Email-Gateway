#!/bin/bash
set -e

echo "Starting rsyslog...."
/usr/sbin/rsyslogd

###############################################################################
# 0. Gather secrets and environment variables
###############################################################################

LDAP_ADMIN_PASS=$(cat /run/secrets/LDAP_ADMIN_PASSWORD)
LDAP_USER_PASS=$(cat /run/secrets/LDAP_USER_PASSWORD)
LDAP_DOMAIN=${LDAP_DOMAIN:-hermes.local}
LDAP_ADMIN_USERNAME=${LDAP_ADMIN_USERNAME:-hermes-ldap-admin}
LDAP_USER_USERNAME=${LDAP_USER_USERNAME:-hermes-ldap-user}
LDAP_GROUPS=${LDAP_GROUPS:-"admins relays mailboxes two_factor one_factor readers"}

LDAP_BASE_DN="dc=$(echo "$LDAP_DOMAIN" | sed 's/\./,dc=/g')"
LDAPI_URI="ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi"
SLAPD_CONFIG_DIR="/etc/ldap/slapd.d"
LDAP_DB_DIR="/var/lib/ldap/$LDAP_DOMAIN"

LDAP_ADMIN_DN="cn=$LDAP_ADMIN_USERNAME,$LDAP_BASE_DN"
LDAP_USER_DN="cn=$LDAP_USER_USERNAME,$LDAP_BASE_DN"
READERS_GROUP_DN="cn=readers,ou=groups,$LDAP_BASE_DN"
MDB_DN="olcDatabase={1}mdb,cn=config"

###############################################################################
# 1. Ensure required directories and permissions
###############################################################################

mkdir -p "$SLAPD_CONFIG_DIR"
mkdir -p "$LDAP_DB_DIR"
mkdir -p /var/run/slapd
chown -R root:root /etc/ldap /var/lib/ldap /var/run/slapd
chmod 0777 /var/run/slapd
chmod 0777 "$LDAP_DB_DIR"
rm -rf /var/run/slapd/slapd.pid /var/run/slapd/slapd.args
mkdir -p /tmp/schema-config
chmod 700 /tmp/schema-config

###############################################################################
# 2. Bootstrap slapd.d with all required schemas and ACLs
###############################################################################

if [ ! -d "$SLAPD_CONFIG_DIR" ] || [ -z "$(ls -A "$SLAPD_CONFIG_DIR")" ]; then
  echo "Bootstrapping slapd.d..."
cat >/tmp/min-slapd.conf <<EOF
include /usr/local/etc/openldap/schema/core.schema
include /usr/local/etc/openldap/schema/cosine.schema
include /usr/local/etc/openldap/schema/nis.schema
include /usr/local/etc/openldap/schema/inetorgperson.schema
include /usr/local/etc/openldap/schema/remoteauth.schema

modulepath /usr/local/libexec/openldap
moduleload back_mdb.la
moduleload argon2.la
moduleload remoteauth.la
password-hash {ARGON2}

loglevel $LDAP_LOG_LEVEL

pidfile     /var/run/slapd/slapd.pid
argsfile    /var/run/slapd/slapd.args

database        config
rootdn          cn=config
access to *
  by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
  by * none


database        mdb
maxsize         1073741824
suffix          $LDAP_BASE_DN
directory       $LDAP_DB_DIR
rootdn          $LDAP_ADMIN_DN

index objectClass eq
index uid,uidNumber,gidNumber,memberUid eq
index cn,sn,mail eq,sub
EOF
  slaptest -f /tmp/min-slapd.conf -F "$SLAPD_CONFIG_DIR" -n 0
  chown -R root:root "$SLAPD_CONFIG_DIR"
  else
  echo "slapd.d already bootstrapped. Nothing to do..."
fi

###############################################################################
# 3. Start slapd in background so LDAPI works for config mutations
###############################################################################

echo "Starting slapd for LDAPI configuration..."
/usr/local/libexec/slapd -F "$SLAPD_CONFIG_DIR" -h "ldap:/// $LDAPI_URI" -u root -g root -d 128 &
SLAPD_PID=$!

for i in {1..60}; do
  [ -S /var/run/slapd/ldapi ] && break
  sleep 1
done
chmod 0777 /var/run/slapd/ldapi 2>/dev/null || true
for i in {1..20}; do
  ldapwhoami -Y EXTERNAL -H "$LDAPI_URI" &>/dev/null && break
  sleep 1
done

########################################################################################################
# 4. Check for existence of required ACLs to manage config and authenticate and if they don't exist add
#######################################################################################################

cat <<EOF > /tmp/add-peercred-acl.ldif
dn: $MDB_DN
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage by * break
olcAccess: {1}to * by dn.exact="$LDAP_ADMIN_DN" manage by * break
olcAccess: {2}to * by group.exact="$READERS_GROUP_DN" read by * break
olcAccess: {3}to attrs=userPassword by anonymous auth by * break
olcAccess: {4}to * by * none
EOF

ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$MDB_DN" olcAccess > /tmp/current-acl.txt

if grep -q 'dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"' /tmp/current-acl.txt && \
   grep -q "dn.exact=\"$LDAP_ADMIN_DN\"" /tmp/current-acl.txt && \
   grep -q 'attrs=userPassword by anonymous auth' /tmp/current-acl.txt && \
   grep -q 'by \* none' /tmp/current-acl.txt; then
  echo "Required ACLs already exist; nothing to do."
else
  echo "Adding missing required ACLs..."
  ldapmodify -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/add-peercred-acl.ldif
fi


###############################################################################
# 6. Create the main LDAP database and the root password as needed
###############################################################################

LDAP_ADMIN_PASSWORD_HASH=$(/usr/local/sbin/slappasswd -o module-load=argon2.so -h '{ARGON2}' -s "$LDAP_ADMIN_PASS")

if ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "olcDatabase={1}mdb,cn=config" -s base dn 2>/dev/null | grep "dn:" >/dev/null; then
  # Database exists; update password
  cat <<EOF > /tmp/reset-rootpw.ldif
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $LDAP_ADMIN_PASSWORD_HASH
EOF

  ldapmodify -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/reset-rootpw.ldif
else
  # Database does not exist; add with password
  cat <<EOF > /tmp/add-mdb-db.ldif
dn: olcDatabase={1}mdb,cn=config
changetype: add
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: {1}mdb
olcSuffix: $LDAP_BASE_DN
olcRootDN: $LDAP_ADMIN_DN
olcRootPW: $LDAP_ADMIN_PASSWORD_HASH
olcDbDirectory: $LDAP_DB_DIR
olcDbIndex: objectClass eq
olcDbIndex: uid,uidNumber,gidNumber,memberUid eq
olcDbIndex: cn,sn,mail eq,sub
olcAccess: to * by dn.exact="$LDAP_ADMIN_DN" manage by * none
EOF

  ldapmodify -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/add-mdb-db.ldif || true
fi

###############################################################################
# 7. Create base DN if absent
###############################################################################

if ! ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$LDAP_BASE_DN" -s base dn 2>/dev/null | grep -q "dn:"; then 
 cat <<EOF > /tmp/base-dn.ldif
dn: $LDAP_BASE_DN
objectClass: dcObject
objectClass: organization
dc: $(echo "$LDAP_DOMAIN" | cut -d'.' -f1)
o: $(echo "$LDAP_DOMAIN")
EOF

ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/base-dn.ldif

else

echo "Base DN already exists. Nothing to do...."

fi


###############################################################################
# 8. Add a demo/test user, if missing
###############################################################################

USER_DN="cn=${LDAP_USER_USERNAME},${LDAP_BASE_DN}"
USER_PASSWORD_HASH=$(/usr/local/sbin/slappasswd -o module-load=argon2.so -h "{ARGON2}" -s "$LDAP_USER_PASS")

cat <<EOF > /tmp/add-user.ldif
dn: $USER_DN
objectClass: inetOrgPerson
cn: Hermes User
sn: User
uid: ${LDAP_USER_USERNAME}
userPassword: ${USER_PASSWORD_HASH}
mail: hermes-user@hermes.local
EOF

if ! ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$USER_DN" dn 2>/dev/null | grep -q "dn:"; then
  ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/add-user.ldif

else
	echo "demo/test user already exists. Nothing to do...."
fi

###############################################################################
# 9. Create ou=groups and dynamically add group entries
###############################################################################

GROUPS_OU="ou=groups,$LDAP_BASE_DN"
cat <<EOF > /tmp/groups-ou.ldif
dn: $GROUPS_OU
objectClass: top
objectClass: organizationalUnit
ou: groups
EOF

if ! ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$GROUPS_OU" -s base dn 2>/dev/null | grep -q "dn:"; then

  echo "Adding Groups OU"
  ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/groups-ou.ldif

else

  echo "Groups OU already exists. Nothing to do..."
fi

for grp in $LDAP_GROUPS; do
  GRP_DN="cn=${grp},ou=groups,${LDAP_BASE_DN}"
  cat <<EOF > /tmp/add-group.ldif
dn: $GRP_DN
objectClass: groupOfNames
objectClass: top
cn: $grp
member: cn=${LDAP_USER_USERNAME},${LDAP_BASE_DN}
EOF
  if ! ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$GRP_DN" -s base dn 2>/dev/null | grep -q "dn:"; then
    ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/add-group.ldif

else
  echo "$GRP_DN already exists. Skipping..."
  fi
done


###############################################################################
# 9a. Create ou=users
###############################################################################

USERS_OU="ou=users,$LDAP_BASE_DN"
cat <<EOF > /tmp/users-ou.ldif
dn: $USERS_OU
objectClass: top
objectClass: organizationalUnit
ou: users
EOF

if ! ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "$USERS_OU" -s base dn 2>/dev/null | grep -q "dn:"; then
  ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f /tmp/users-ou.ldif

else
  echo "Users OU already exists. Nothing to do..."
fi

###############################################################################
# 9b. Cleanup temporary LDIF files
###############################################################################

rm -f /tmp/*.ldif

###############################################################################
# 10. Stop background slapd, launch in foreground
###############################################################################

kill -INT "$SLAPD_PID" 2>/dev/null || true
sleep 3
rm -f /var/run/slapd/slapd.pid /var/run/slapd/slapd.args

echo "Starting slapd as main service..."
exec /usr/local/libexec/slapd -F "$SLAPD_CONFIG_DIR" -h "ldap:/// $LDAPI_URI" -u root -g root -d 256

