#!/bin/bash

check()
{
if  [ ! "$?" -eq 0 ]; then
        exit 22
fi
}

###SAMBA###
sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f samba.ldif
check

sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f samba_indices.ldif
check

sudo smbpasswd -w "__PASSROOT__"
check

/usr/share/linkat/linkat-servidor/configurador/files/smbldap-populate.sh
check

sudo auth-client-config -t nss -p lac_ldap
check

LOCALSID=$(sudo net getlocalsid | awk ' {print $6} ')
sed -i s/__LOCALSID__/"$LOCALSID"/g /etc/webmin/ldap-useradmin/config

