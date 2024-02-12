FROM php:8.0.2-apache

RUN apt-get update -y && apt-get install -y libpng-dev zlib1g-dev libzip-dev libpq-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install gd zip pdo pdo_pgsql

RUN pecl install mongodb \
    && echo "extension=mongodb.so" >> /usr/local/etc/php/php.ini

# Xdebug
ENV XDEBUG_VERSION=3.3.1
RUN pecl install xdebug-${XDEBUG_VERSION}
RUN docker-php-ext-enable xdebug
RUN echo 'xdebug.mode=develop,debug' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/xdebug.ini

RUN chown -R www-data:www-data /var/www/html
# Enable mod rewrite
RUN a2enmod rewrite
