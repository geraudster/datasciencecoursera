## Launch a VM

TODO

## Install docker

    sudo sh -c "apt-get update && apt-get -y upgrade"
    sudo apt-get install docker.io

## Starting RStudio Server Docker image

    sudo docker pull geraudster/rstudio-server
    sudo docker run -p 443:443 -d -t geraudster/rstudio-server

