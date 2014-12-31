FROM ubuntu:trusty
MAINTAINER geraudster

RUN echo 'deb http://ftp.igh.cnrs.fr/pub/CRAN/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN apt-get update && apt-get -y upgrade

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

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
RUN wget http://download2.rstudio.org/rstudio-server-0.98.1087-amd64.deb
RUN gdebi -n rstudio-server-0.98.1087-amd64.deb && rm -f rstudio-server-0.98.1087-amd64.deb
RUN (adduser --disabled-password --gecos "" rstudio && echo "rstudio:rstudio"|chpasswd)
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
ADD rstudio-nginx.conf /etc/nginx/sites-enabled/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 443
CMD ["/usr/bin/supervisord"]

