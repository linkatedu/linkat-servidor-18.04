#!/bin/bash

check()
{
if  [ ! "$?" -eq 0 ]; then
	exit 22
fi
}

ldapadd -x -D cn=admin,dc=__DOMAIN__ -w "__PASSROOT__" -f ldapconfig.ldif
check

ldapadd -x -D cn=admin,dc=__DOMAIN__ -w "__PASSROOT__" -f grups.ldif
check

sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f uid_index.ldif
check

sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f corba.ldif
check

sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif
check

sudo systemctl restart syslog.service

sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"
check
sudo certtool --generate-self-signed \
       --load-privkey /etc/ssl/private/cakey.pem \
       --template /etc/ssl/ca.info \
       --outfile /etc/ssl/certs/cacert.pem
check

sudo certtool --generate-privkey \
	--sec-param Medium \
	--outfile /etc/ssl/private/servidor_slapd_key.pem
check

sudo certtool --generate-certificate \
	--load-privkey /etc/ssl/private/servidor_slapd_key.pem \
	--load-ca-certificate /etc/ssl/certs/cacert.pem \
	--load-ca-privkey /etc/ssl/private/cakey.pem \
	--template /etc/ssl/servidor.info \
	--outfile /etc/ssl/certs/servidor_slapd_cert.pem
check

sudo chgrp openldap /etc/ssl/private/servidor_slapd_key.pem
check

sudo chmod 0640 /etc/ssl/private/servidor_slapd_key.pem
check

sudo gpasswd -a openldap ssl-cert
check

sudo systemctl restart slapd.service
check

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f certinfo.ldif
check
