#!/bin/bash


# Install and Configure Nextcloud via snap
sudo snap install nextcloud
if [ -f /etc/modalitat_linkat ]; then
        sudo /usr/share/linkat/linkat-servidor/configurador/files/nextcloud-resetpass.sh > /dev/null 2>&1
else
        sudo nextcloud.manual-install lnadmin __PASSLNADMIN__
fi
sudo nextcloud.enable-https self-signed
sudo snap set nextcloud ports.http=81
sudo snap set nextcloud ports.https=10443
sudo snap set nextcloud php.memory-limit=512M
sudo nextcloud.occ config:system:set trusted_domains 1 --value="__IP__"
sudo nextcloud.occ config:system:set trusted_domains 2 --value="__NAME__.__DOMAIN__"
sudo nextcloud.occ config:system:set trusted_domains 3 --value="localhost"
sudo snap run nextcloud.occ app:install user_ldap
sudo snap run nextcloud.occ app:enable user_ldap
sudo nextcloud.occ config:app:set user_ldap ldapAgentName --value="dc=__DOMAIN__"
sudo nextcloud.occ config:app:set user_ldap ldapBase --value="dc=__DOMAIN__"
#sudo nextcloud.occ config:app:set user_ldap ldap_agent_password --value="__PASSROOT__"
sudo nextcloud.occ config:app:set user_ldap ldap_base --value="dc=__DOMAIN__"
sudo nextcloud.occ config:app:set user_ldap ldap_base_groups --value="ou=Groups,dc=__DOMAIN__"
sudo nextcloud.occ config:app:set user_ldap ldap_base_users --value="ou=People,dc=__DOMAIN__"
sudo nextcloud.occ config:app:set user_ldap ldap_configuration_active --value="1"
sudo nextcloud.occ config:app:set user_ldap ldap_display_name --value="cn"
#sudo nextcloud.occ config:app:set user_ldap ldap_dn --value="cn=admin,dc=__DOMAIN__"
sudo nextcloud.occ config:app:set user_ldap ldap_group_filter --value="(&(|(objectclass=posixGroup)))"
sudo nextcloud.occ config:app:set user_ldap ldap_group_member_assoc_attribute --value="gidNumber"
sudo nextcloud.occ config:app:set user_ldap ldap_groupfilter_objectclass --value="posixGroup"
sudo nextcloud.occ config:app:set user_ldap ldap_host --value="127.0.0.1"
sudo nextcloud.occ config:app:set user_ldap ldap_login_filter --value="(&(|(objectclass=inetOrgPerson)(objectclass=person)(objectclass=posixAccount))(|(uid=%uid)))"
sudo nextcloud.occ config:app:set user_ldap ldap_loginfilter_attributes --value="uid"
sudo nextcloud.occ config:app:set user_ldap ldap_port --value="389"
sudo nextcloud.occ config:app:set user_ldap ldap_tls --value="0"
sudo nextcloud.occ config:app:set user_ldap ldap_userfilter_objectclass --value="inetOrgPerson\nperson\nposixAccount"
sudo nextcloud.occ config:app:set user_ldap ldap_userlist_filter --value="(|(objectclass=inetOrgPerson)(objectclass=person)(objectclass=posixAccount))"
sudo nextcloud.occ config:app:set user_ldap types --value="authentication"
#sudo snap restart nextcloud
sudo nextcloud.occ app:install onlyoffice
sudo nextcloud.occ app:enable onlyoffice
sudo nextcloud.occ config:app:set onlyoffice DocumentServerUrl --value="https://__IP__:10445/"
sudo nextcloud.occ config:app:set onlyoffice editFormats --value="{\"csv\":\"false\",\"doc\":\"false\",\"docm\":\"false\",\"docx\":\"true\",\"dotx\":\"false\",\"epub\":\"false\",\"html\":\"false\",\"odp\":\"false\",\"ods\":\"true\",\"odt\":\"true\",\"pdf\":\"false\",\"potm\":\"false\",\"potx\":\"false\",\"ppsm\":\"false\",\"ppsx\":\"false\",\"ppt\":\"false\",\"pptm\":\"false\",\"pptx\":\"true\",\"rtf\":\"false\",\"txt\":\"false\",\"xls\":\"false\",\"xlsm\":\"false\",\"xlsx\":\"true\",\"xltm\":\"false\",\"xltx\":\"false\"}"
sudo nextcloud.occ config:app:set onlyoffice defFormats --value="{\"csv\":\"false\",\"doc\":\"true\",\"docm\":\"false\",\"docx\":\"true\",\"dotx\":\"false\",\"epub\":\"false\",\"html\":\"false\",\"odp\":\"true\",\"ods\":\"true\",\"odt\":\"true\",\"pdf\":\"true\",\"potm\":\"false\",\"potx\":\"false\",\"ppsm\":\"false\",\"ppsx\":\"false\",\"ppt\":\"true\",\"pptm\":\"false\",\"pptx\":\"true\",\"rtf\":\"false\",\"txt\":\"false\",\"xls\":\"true\",\"xlsm\":\"false\",\"xlsx\":\"true\",\"xltm\":\"false\",\"xltx\":\"false\"}"
#sudo nextcloud.occ config:app:set --value https:\/\/__IP__:10445\/ onlyoffice DocumentServerUrl
sudo nextcloud.occ config:system:set onlyoffice verify_peer_off --value="true"
# Resolve onlyoffice connection error
sudo nextcloud.occ config:app:delete onlyoffice settings_error
# Change default nextcloud storage folder
if [ ! -f /etc/modalitat_linkat ]; then
	sudo snap disable nextcloud
	sudo mkdir -p /srv/app/nextcloud 
	sudo mv /var/snap/nextcloud/common/nextcloud/data/ /srv/app/nextcloud/
	sudo mkdir /var/snap/nextcloud/common/nextcloud/data/
	sudo mount --bind /srv/app/nextcloud/data/ /var/snap/nextcloud/common/nextcloud/data/
	sudo echo "/srv/app/nextcloud/data/        /var/snap/nextcloud/common/nextcloud/data/      none    bind    0       0" >> /etc/fstab
	sudo snap enable nextcloud
fi

sudo snap restart nextcloud
