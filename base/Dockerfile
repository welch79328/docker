FROM php:7.0-apache

# set php.ini
RUN echo "upload_max_filesize = 2048M" >> /etc/php.ini \
&&  echo "post_max_size = 2048M" >> /etc/php.ini

# redis xdebug
RUN pecl install redis-4.0.2 \
    && pecl install xdebug-2.6.0 \
    && docker-php-ext-enable redis xdebug

# php module
RUN docker-php-ext-install opcache bcmath pdo_mysql mysqli gd pgsql

# apt-get
RUN apt-get update \
  && apt-get install -y git libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev \
  && apt-get clean

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# phalcon
RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git && cd cphalcon/build && ./install && docker-php-ext-enable phalcon
RUN cd ../../ && rm -rf ./cphalcon/

# apache ssl & rewrite
RUN a2enmod rewrite
RUN a2enmod ssl

