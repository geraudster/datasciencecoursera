This project aims to provide a Docker image for a secured RStudio Server. I have 
created this image for working on project of [Coursera's Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1?utm_medium=dashboard). This
image can then be deployed on cloud environment (like Amazon, or runabove.com), if you 
are short on RAM or CPU with your desktop computer (great for training [Random Forests](https://www.kaggle.com/wiki/RandomForests).


## TL;DR Usage

Creating image:

    sudo docker build -t geraudster/rstudio-server .

Using it:

    sudo docker run -p 443:443 -d -t geraudster/rstudio-server

Then open https://localhost, (login with rstudio/rstudio).

Change password via RStudio shell window.

## Use with data container

Start the data container:

    sudo docker run --name rstudio-data geraudster/rstudio-server echo "Starting data container..."

Start RStudio container:

    sudo docker run --rm --volumes-from=rstudio-data -p 443:443 -d -t geraudster/rstudio-server

Access data volume:

    sudo docker run --rm -it -u rstudio --volumes-from=rstudio-data geraudster/rstudio-server bash

## Explanation

First we build the image from an Ubuntu/Trusty:

    FROM ubuntu:trusty
    MAINTAINER geraudster

    RUN echo 'deb http://ftp.igh.cnrs.fr/pub/CRAN/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
    RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
    RUN apt-get update && apt-get -y upgrade

Then we have some environment variables to set:

    RUN locale-gen en_US.UTF-8  
    ENV LANG en_US.UTF-8  
    ENV LANGUAGE en_US:en  
    ENV LC_ALL en_US.UTF-8  

We need some packages to install RStudio Server:

    RUN apt-get -y install \
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

Then we can install RStudio Server:

    RUN wget http://download2.rstudio.org/rstudio-server-0.98.1087-amd64.deb
    RUN gdebi -n rstudio-server-0.98.1087-amd64.deb && rm -f rstudio-server-0.98.1087-amd64.deb

We will use supervisor to launch RStudio and Nginx:

    RUN (adduser --disabled-password --gecos "" rstudio && echo "rstudio:rstudio"|chpasswd)
    RUN mkdir -p /var/log/supervisor
    ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

Let's configure SSL:

    RUN mkdir -p /etc/nginx/ssl
    RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
    ADD rstudio-nginx.conf /etc/nginx/sites-enabled/
    RUN echo "daemon off;" >> /etc/nginx/nginx.conf
    EXPOSE 443

The final word, start supervisor daemon:

    CMD ["/usr/bin/supervisord"]

## TODO

* Generate random password for rstudio user
* Add data volume to keep R files

## Links

* https://github.com/mgymrek/docker-rstudio-server
* http://jaredmarkell.com/docker-and-locales/
* https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy
* https://labs.runabove.com/docker/
