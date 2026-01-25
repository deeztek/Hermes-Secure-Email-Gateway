####################################################################
# RemoteAuth Example Database Block
####################################################################

database        mdb
suffix          "dc=deeztek,dc=com"
directory       /var/lib/ldap/remoteauth-deeztek.com
rootdn          "dc=deeztek,dc=com"

# Minimal indexes (optional, since no real users are stored here)
index   objectClass eq

####################################################################
# Remoteauth Overlay Configuration
####################################################################

# Overlay must be enabled for the current database block
overlay remoteauth

# Specify the DN and domain attributes that map local entries to remote domains
remoteauth_dn_attribute        seeAlso
remoteauth_domain_attribute    associatedDomain

# Use as the mapping key to external directory. Use ldaps for SSL on port 636.
remoteauth_mapping partners ldap://homedc01.deeztek.com:389

# TLS and cert validation settings as needed
remoteauth_starttls            FALSE
remoteauth_validate_certs      FALSE
remoteauth_cacert_file         

# Optionally set retry policy for remote bind attempts
remoteauth_retry_count         5

