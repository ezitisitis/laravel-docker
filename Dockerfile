FROM ubuntu:20.04 AS latest

# Setup pre-requisites
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /var/www

# Setup server timezone
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

# Install system dependencies
RUN apt-get update \
    && apt-get install -y \
    wget  \
    curl  \
    apt-transport-https \
    software-properties-common  \
    dirmngr  \
    lsb-release  \
    libpng-dev  \
    libonig-dev \
    libxml2-dev  \
    gnupg gosu  \
    ca-certificates \
    zip  \
    unzip  \
    git  \
    rsync  \
    sqlite3  \
    libcap2-bin  \
    python3

RUN mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && apt-get update

# Setup PHP
RUN apt-get install -y \
    php8.1  \
    php8.1-fpm \
    php8.1-cli  \
    php8.1-dev  \
    php8.1-sqlite3 \
    php8.1-gd  \
    php8.1-curl  \
    php8.1-memcached  \
    php8.1-imap  \
    php8.1-mysql \
    php8.1-mbstring  \
    php8.1-xml  \
    php8.1-zip  \
    php8.1-bcmath  \
    php8.1-soap \
    php8.1-intl  \
    php8.1-readline  \
    php8.1-msgpack  \
    php8.1-igbinary \
    php8.1-ldap  \
    php8.1-redis

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

COPY scripts/latest.bash /usr/local/bin/bootstrap
COPY configs/php.ini /etc/php/8.1/cli/conf.d/99-app.ini
COPY configs/php-fpm-pool.conf /etc/php/8.1/fpm/pool.d/www.conf
RUN chmod +x /usr/local/bin/bootstrap

ENTRYPOINT ["/usr/local/bin/bootstrap"]

FROM latest AS development

RUN apt-get update \
RUN apt-get install -y php8.1-xdebug
RUN echo "[xdebug]" > /etc/php/8.1/cli/conf.d/20-xdebug.ini; \
    echo "zend_extension=xdebug.so" >> /etc/php/8.1/cli/conf.d/20-xdebug.ini; \
    echo "xdebug.mode=coverage" >> /etc/php/8.1/cli/conf.d/20-xdebug.ini

COPY scripts/development.bash /usr/local/bin/bootstrap
COPY configs/development/php.ini /etc/php/8.1/cli/conf.d/99-app.ini
RUN chmod +x /usr/local/bin/bootstrap

ENTRYPOINT ["/usr/local/bin/bootstrap"]

FROM latest AS npm

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install -y \
    build-essential  \
    nodejs \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/npm.bash /usr/local/bin/bootstrap
RUN chmod +x /usr/local/bin/bootstrap

ENTRYPOINT ["/usr/local/bin/bootstrap"]

FROM development AS npm-dev

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install -y \
    build-essential  \
    nodejs \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/npm-dev.bash /usr/local/bin/bootstrap
RUN chmod +x /usr/local/bin/bootstrap

ENTRYPOINT ["/usr/local/bin/bootstrap"]