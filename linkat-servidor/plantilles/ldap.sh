#!/bin/bash


ldapadd -x -D cn=admin,dc=__DOMAIN__ -w __PASSROOT__ -f ldapconfig.ldif
ldapadd -x -D cn=admin,dc=__DOMAIN__ -w __PASSROOT__ -f grups.ldif
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f uid_index.ldif
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif
sudo systemctl restart syslog.service

sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"
sudo certtool --generate-self-signed --load-privkey /etc/ssl/private/cakey.pem --template /etc/ssl/ca.info --outfile /etc/ssl/certs/cacert.pem
sudo certtool --generate-privkey --sec-param Medium --outfile /etc/ssl/private/servidor_slapd_key.pem
sudo certtool --generate-certificate --load-privkey /etc/ssl/private/servidor_slapd_key.pem --load-ca-certificate /etc/ssl/certs/cacert.pem --load-ca-privkey /etc/ssl/private/cakey.pem --template /etc/ssl/servidor.info --outfile /etc/ssl/certs/servidor_slapd_cert.pem

sudo chgrp openldap /etc/ssl/private/servidor_slapd_key.pem
sudo chmod 0640 /etc/ssl/private/servidor_slapd_key.pem

sudo gpasswd -a openldap ssl-cert

sudo systemctl restart slapd.service

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f certinfo.ldif

sudo auth-client-config -t nss -p lac_ldap

pam-auth-update
