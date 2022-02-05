#!/usr/bin/env bash

mkdir -p /run/php

composer install
php artisan migrate

php-fpm8.1 -F -R