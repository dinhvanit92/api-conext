FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip
# xdebug
RUN pecl install xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini

RUN echo "fastcgi.logging = 0" >> /usr/local/etc/php/conf.d/php.ini
RUN echo "log_errors = on" >> /usr/local/etc/php/conf.d/php.ini
RUN echo "display_errors = on" >> /usr/local/etc/php/conf.d/php.ini
# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
RUN apt-get update && apt-get install -y
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN apt-get update && apt-get install -y libmcrypt-dev \
    mariadb-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt