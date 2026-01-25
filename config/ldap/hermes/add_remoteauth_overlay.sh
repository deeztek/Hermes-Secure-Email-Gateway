#!/bin/bash

# Define local variables
LDAPI_URI="ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi"
TMP_LDIF="/tmp/remoteauth.ldif"

# Step 1: Find the MDB database index
MDB_INDEX=$(ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "cn=config" '(objectClass=olcDatabaseConfig)' dn |
  grep "mdb,cn=config" | grep -o '{[0-9]*}' | grep -o '[0-9]*')

# Step 2: Find next available overlay index for this MDB
NEXT_OVERLAY_INDEX=$(ldapsearch -Y EXTERNAL -H "$LDAPI_URI" -b "olcDatabase={$MDB_INDEX}mdb,cn=config" '(objectClass=olcOverlayConfig)' dn |
  grep -o '{[0-9]*}' | grep -o '[0-9]*' | sort -n | tail -1 | awk '{print $1+1}')
# If no overlays exist, default to 0
if [[ -z "$NEXT_OVERLAY_INDEX" ]]; then
  NEXT_OVERLAY_INDEX=0
fi

# Step 3: Create LDIF file for remoteauth overlay
cat <<EOF > "$TMP_LDIF"
dn: olcOverlay={$NEXT_OVERLAY_INDEX}remoteauth,olcDatabase={$MDB_INDEX}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcRemoteAuthCfg
olcOverlay: {$NEXT_OVERLAY_INDEX}remoteauth
olcRemoteAuthDNAttribute: seeAlso
olcRemoteAuthDomainAttribute: associatedDomain
#olcRemoteAuthDefaultRealm: deeztek
olcRemoteAuthDefaultDomain: deeztek
#olcRemoteAuthMapping: deeztek file:///usr/local/openldap/etc/openldap/deeztek.list
olcRemoteAuthMapping: deeztek homedc01.deeztek.com
olcRemoteAuthTLS: starttls=no tls_reqcert=never
olcRemoteAuthRetryCount: 3
EOF

# Step 4: Add the overlay using ldapadd
ldapadd -Y EXTERNAL -H "$LDAPI_URI" -f "$TMP_LDIF"

