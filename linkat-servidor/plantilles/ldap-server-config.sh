#!/bin/bash

## Instalador LDAP server

ldapadd -x -D cn=admin,dc=__DOMAIN__ -w __PASSROOT__ -f ldapconfig.ldif
ldapadd -x -D cn=admin,dc=__DOMAIN__ -w __PASSROOT__ -f grups.ldif
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f uid_index.ldif
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif
systemctl restart syslog.service

sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"
certtool --generate-self-signed --load-privkey /etc/ssl/private/cakey.pem --template /etc/ssl/ca.info --outfile /etc/ssl/certs/cacert.pem
certtool --generate-privkey --sec-param Medium --outfile /etc/ssl/private/servidor_slapd_key.pem
certtool --generate-certificate --load-privkey /etc/ssl/private/servidor_slapd_key.pem --load-ca-certificate /etc/ssl/certs/cacert.pem --load-ca-privkey /etc/ssl/private/cakey.pem --template /etc/ssl/servidor.info --outfile /etc/ssl/certs/servidor_slapd_cert.pem

chgrp openldap /etc/ssl/private/servidor_slapd_key.pem
chmod 0640 /etc/ssl/private/servidor_slapd_key.pem
gpasswd -a openldap ssl-cert

systemctl restart slapd.service

ldapmodify -Y EXTERNAL -H ldapi:/// -f certinfo.ldif

#dpkg-reconfigure ldap-auth-config

auth-client-config -t nss -p lac_ldap

DEBIAN_FRONTEND=noninteractive pam-auth-update
