FROM php:7.2.34-apache

RUN apt-get update && apt-get install -y libmcrypt-dev zlib1g-dev libpng-dev
RUN docker-php-ext-install pdo pdo_mysql gd mysqli gettext
RUN docker-php-ext-enable pdo pdo_mysql gd mysqli gettext
RUN printf "\n" | pecl install mcrypt-1.0.5
RUN docker-php-ext-enable mcrypt

COPY ./a2billing /usr/local/src/a2billing
COPY ./.docker/a2billing.conf /etc/a2billing.conf
COPY ./.docker/mysql_bootstrap.sh /mysql_bootstrap.sh
COPY ./.docker/mysql-bootstrap-files/ /usr/local/src/a2billing/DataBase/mysql-5.x/

WORKDIR /var/www/html/

RUN ln -s /usr/local/src/a2billing/admin /var/www/html
RUN ln -s /usr/local/src/a2billing/agent /var/www/html
RUN ln -s /usr/local/src/a2billing/customer /var/www/html
RUN ln -s /usr/local/src/a2billing/common /var/www/html

RUN chmod 755 /usr/local/src/a2billing/admin/templates_c
RUN chmod 755 /usr/local/src/a2billing/customer/templates_c
RUN chmod 755 /usr/local/src/a2billing/agent/templates_c
RUN chown -Rf www-data:www-data /usr/local/src/a2billing/admin/templates_c
RUN chown -Rf www-data:www-data /usr/local/src/a2billing/customer/templates_c
RUN chown -Rf www-data:www-data /usr/local/src/a2billing/agent/templates_c

RUN chown www-data:www-data /var/www/html/



EXPOSE 80
CMD ["apache2-foreground"]
