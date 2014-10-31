FROM ubuntu:trusty
MAINTAINER geraudster

RUN echo 'deb http://ftp.igh.cnrs.fr/pub/CRAN/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get upgrade
RUN apt-get -y install vim git r-base r-base-dev \
	gdebi-core \
	libapparmor1
RUN wget http://download2.rstudio.org/rstudio-server-0.98.1087-amd64.deb
RUN gdebi rstudio-server-0.98.1087-amd64.deb


