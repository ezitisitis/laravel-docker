FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /var/www

# Setup server timezone
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

# Install server dependencies
RUN apt-get update && \
    apt install -y \
    gcc \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    libpcre3-dev \
    build-essential \
    curl \
    wget \
    gnupg2 \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    software-properties-common

RUN apt install software-properties-common && \
    add-apt-repository ppa:ondrej/php

# Install git, 
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    openssh-client \
    rsync \
    git \
    unzip \
    bzip2 \
    mysql-client \
    gpg-agent \
    curl \
    gnupg \
    php-pear

# Installing php and extensions
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    php8.0-cli \
    php8.0-curl \
    php8.0-dom \
    php8.0-fpm \
    php8.0-gd \
    php8.0-intl \
    php8.0-iconv \
    php8.0-mbstring \
    php8.0-mysql \
    php8.0-soap \
    php8.0-xml \
    php8.0-xmlreader \
    php8.0-xmlwriter \
    php8.0-zip \
    php8.0-bcmath \
    php8.0-xdebug \
    php8.0-dev 

RUN pecl channel-update https://pecl.php.net/channel.xml \
    && pecl install swoole \
    && pecl clear-cache \
    && rm -rf /tmp/* /var/tmp/*

RUN mkdir -p /run/php-fpm/

# Supress composer root warning
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy composer from already built image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY server-bootstrap /usr/local/bin/server-bootstrap
COPY php.ini /etc/php/8.0/cli/conf.d/99-app.ini
COPY php-pfm-pool.conf /etc/php/8.0/fpm/pool.d/www.conf
RUN chmod +x /usr/local/bin/server-bootstrap
ENTRYPOINT ["/bin/bash", "/usr/local/bin/server-bootstrap"]
