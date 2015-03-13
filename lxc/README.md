## Install lxc

    sudo apt-get install lxc

## Launch unprivileged container

    mkdir -p ~/.config/lxc
    echo "lxc.id_map = u 0 100000 65536" > ~/.config/lxc/default.conf
    echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf
    echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
    echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
    echo "$USER veth lxcbr0 2" | sudo tee -a /etc/lxc/lxc-usernet

    sudo usermod --add-subuids 100000-165536 $USER
    sudo usermod --add-subgids 100000-165536 $USER

## Create first container

    lxc-create -t download -n rstudio-server -- -d ubuntu -r trusty -a amd64
    lxc-start -n rstudio-server -d
    lxc-attach -n rstudio-server

## Install R and RStudio Server
 
    echo 'deb http://ftp.igh.cnrs.fr/pub/CRAN/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
    apt-get update && apt-get -y upgrade

    apt-get -y install \
        curl \
        gdebi-core \
        git \
        libapparmor1 \
        nginx-extras \
        r-base \
        r-base-dev \
        supervisor \
        vim \
        wget

    apt-get -y install libcurl4-gnutls-dev

     wget http://download2.rstudio.org/rstudio-server-0.98.1087-amd64.deb
     gdebi -n rstudio-server-0.98.1087-amd64.deb && rm -f rstudio-server-0.98.1087-amd64.deb

     (adduser --disabled-password --gecos "" rstudio && echo "rstudio:****"|chpasswd) # ignore error
     mkdir -p /etc/nginx/ssl
     openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
    sudo cp rstudio-nginx.conf ~/.local/share/lxc/rstudio-server/rootfs/etc/nginx/sites-enabled/

    service nginx restart

Route traffic:

     sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 10.0.3.72

