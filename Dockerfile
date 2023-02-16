FROM php:7.2.34-apache

RUN apt-get update && apt-get install -y libmcrypt-dev zlib1g-dev libpng-dev
RUN docker-php-ext-install pdo pdo_mysql gd
RUN printf "\n" | pecl install mcrypt-1.0.5
RUN docker-php-ext-enable mcrypt

WORKDIR /a2billing

RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer update
RUN composer install

WORKDIR /var/www/html/

RUN cp -rf /a2billing/admin /var/www/html
RUN cp -rf /a2billing/admin /var/www/html
RUN cp -rf /a2billing/acustomerdmin /var/www/html
RUN cp -rf /a2billing/common /var/www/html



EXPOSE 80
CMD ["apache2-foreground"]