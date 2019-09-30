#!/bin/bash

sudo mkdir -p /srv/app/onlyoffice/DocumentServer/data/certs
sudo mkdir -p /srv/app/onlyoffice/DocumentServer/logs
sudo mkdir -p /srv/app/onlyoffice/DocumentServer/lib
sudo mkdir -p /srv/app/onlyoffice/DocumentServer/db

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /srv/app/onlyoffice/DocumentServer/data/certs/onlyoffice.key -out /srv/app/onlyoffice/DocumentServer/data/certs/onlyoffice.crt -subj "/C=ES/ST=Catalunya/L=Barcelona/O=Generalitat de Catalunya/OU=Departament Ensenyament/CN=xtec.cat"

#openssl dhparam -out dhparam.pem 2048

docker pull linkat/onlyoffice

#sudo docker run -i -t -d -p 10445:443 --restart=always \
#    -v /srv/app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
#    -v /srv/app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
#    -v /srv/app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
#    -v /srv/app/onlyoffice/DocumentServer/db:/var/lib/postgresql  linkat/onlyoffice

sudo nextcloud.occ app:install onlyoffice
sudo nextcloud.occ app:enable onlyoffice
sudo nextcloud.occ config:app:set onlyoffice DocumentServerUrl --value="https://__IP__:10445/"
sudo nextcloud.occ config:system:set onlyoffice verify_peer_off --value="true"
sudo snap restart nextcloud
