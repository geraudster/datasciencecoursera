#!/usr/bin/env bash
# Run as root

RSTUDIO_SERVER_PKG=rstudio-server-0.99.892-amd64.deb

read -p 'rstudio user password: ' -s PASSWORD
echo

echo '**** Adding CRAN repository...'
echo 'deb http://ftp.igh.cnrs.fr/pub/CRAN/bin/linux/debian jessie-cran3/' >> /etc/apt/sources.list
apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480
apt-get update && apt-get -y upgrade

echo '**** Hacking locales...'
apt-get -y install locales
sed -i.bak 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen en_US.UTF-8
LANG en_US.UTF-8
LANGUAGE en_US:en
LC_ALL en_US.UTF-8

echo '**** Launching big install...'
apt-get -y install \
    build-dep \
    curl \
    gdebi-core \
    git \
    libapparmor1 \
    libcurl4-gnutls-dev \
    nginx-extras \
    r-base \
    r-base-dev \
    supervisor \
    vim \
    wget

echo '**** Installing rstudio-server...'
wget http://download2.rstudio.org/$RSTUDIO_SERVER_PKG
gdebi -n $RSTUDIO_SERVER_PKG && rm -f $RSTUDIO_SERVER_PKG
(adduser --disabled-password --gecos "" rstudio && echo "rstudio:$PASSWORD"|chpasswd)

echo '**** Reverse proxy configuration...'
mkdir -p /etc/nginx/ssl
openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
cp rstudio-nginx.conf /etc/nginx/sites-enabled/

echo 'Finished! Could be a good idea to reboot now...'
