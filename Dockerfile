FROM php:7.4-apache
# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
# apache configs + document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public/
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers
# xdebug
RUN pecl install xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.default_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.idekey = VSCODE" >> /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.remote_connect_back = on" >> /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini
# RUN echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "fastcgi.logging = 0" >> /usr/local/etc/php/conf.d/php.ini
RUN echo "log_errors = on" >> /usr/local/etc/php/conf.d/php.ini
RUN echo "display_errors = off" >> /usr/local/etc/php/conf.d/php.ini
# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
