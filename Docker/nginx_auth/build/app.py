from flask import Flask, request, Response
from ldap3 import Server, Connection, ALL, SUBTREE

# Read the LDAP bind password from the Docker secret file (using uppercase name)
def get_ldap_bind_password():
    try:
        with open('/run/secrets/AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD', 'r') as f:
            return f.read().strip()
    except Exception:
        return None

LDAP_ADDRESS = 'ldap://hermes_openldap:1389'
BASE_DN = 'dc=hermes,dc=local'
USERS_DN = 'ou=users'
USER_SEARCH_BASE = f"{USERS_DN},{BASE_DN}"
USER_SEARCH_FILTER = "(&(uid={username})(objectClass=inetOrgPerson))"
LDAP_BIND_DN = 'cn=hermes-ldap-admin,dc=hermes,dc=local'
LDAP_BIND_PASSWORD = get_ldap_bind_password()

app = Flask(__name__)

def find_user_dn(username):
    server = Server(LDAP_ADDRESS, get_info=ALL)
    with Connection(server, user=LDAP_BIND_DN, password=LDAP_BIND_PASSWORD, auto_bind=True) as conn:
        search_filter = USER_SEARCH_FILTER.format(username=username)
        conn.search(
            search_base=USER_SEARCH_BASE,
            search_filter=search_filter,
            search_scope=SUBTREE,
            attributes=["dn"]
        )
        if conn.entries:
            return conn.entries[0].entry_dn
    return None

def ldap_authenticate(username, password):
    user_dn = find_user_dn(username)
    if not user_dn:
        return False
    server = Server(LDAP_ADDRESS, get_info=ALL)
    try:
        conn = Connection(server, user=user_dn, password=password, auto_bind=True)
        return conn.bound
    except Exception:
        return False

@app.route('/auth', methods=['POST'])
def auth():
    user = request.form.get('user')
    password = request.form.get('password')
    protocol = request.form.get('protocol')

    if not user or not password:
        return Response("Auth-Status: Invalid request\nAuth-Wait: 3\n", mimetype='text/plain')

    if ldap_authenticate(user, password):
        response = "Auth-Status: OK\nAuth-Server: 127.0.0.1\n"
        if protocol == "imap":
            response += "Auth-Port: 143\n"
        elif protocol == "pop3":
            response += "Auth-Port: 110\n"
        elif protocol == "smtp":
            response += "Auth-Port: 587\n"
        return Response(response, mimetype='text/plain')
    else:
        return Response("Auth-Status: Invalid login or password\nAuth-Wait: 3\n", mimetype='text/plain')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9000)

