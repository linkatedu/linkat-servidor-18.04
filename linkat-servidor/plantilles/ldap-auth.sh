#!/bin/bash
## LDAP Authentication

check()
{
if  [ ! "$?" -eq 0 ]; then
        exit 22
fi
}

# debconf-set-selections ldap-auth-config
# check /etc/ldap.secret
sudo auth-client-config -t nss -p lac_ldap
check

sudo pam-auth-update
check
