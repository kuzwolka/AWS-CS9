FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt -y update && apt -y upgrade
RUN apt -y install apache2
RUN apt -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get -y install php7.2 php7.2-fpm php7.2-cli php7.2-xml php7.2-mysql
RUN apt-get -y install libapache2-mod-php7.2 php7.2-mbstring php7.2-gd php7.2-curl
RUN update-alternatives --list php
RUN update-alternatives --set php /usr/bin/php7.2

COPY ./xe/ /var/www/html
RUN sed 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/apache2.conf
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
RUN chmod 707 /var/www/html
RUN rm -rf /var/www/html/index.html