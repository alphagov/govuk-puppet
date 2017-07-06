#!/bin/bash

MAIN_SITE="www.training.publishing.service.gov.uk"
SITE_LIST="`ls /etc/nginx/sites-enabled | grep training.publishing.service.gov.uk`"$'\n'"${MAIN_SITE}"
CS_SITE_LIST=`printf "${SITE_LIST}" | paste -s -d, -`
EMAIL="govuk-dev@digital.cabinet-office.gov.uk"
NGINX_CONF_DIR="/etc/nginx"
LETSENCRYPT_DIR="/etc/letsencrypt"

#Certbot starts up its own webserver to perform the ACME protocol
sudo service nginx stop

#Add repository and install certbot
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot

sudo certbot certonly --staging --cert-name ${MAIN_SITE} -m ${EMAIL} -n -d ${CS_SITE_LIST} --agree-tos --standalone

rm -f ${NGINX_CONF_DIR}/ssl/*

while read -r LINE; do
    sudo ln -sf ${LETSENCRYPT_DIR}/live/${MAIN_SITE}/fullchain.pem ${NGINX_CONF_DIR}/ssl/${LINE}.crt
    sudo ln -sf ${LETSENCRYPT_DIR}/live/${MAIN_SITE}/privkey.pem ${NGINX_CONF_DIR}/ssl/${LINE}.key
done <<< "$SITE_LIST"

sudo service nginx start