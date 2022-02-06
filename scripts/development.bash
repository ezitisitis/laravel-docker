#!/usr/bin/env bash

mkdir -p /run/php

composer install
php artisan key:generate
php artisan storage:link
php artisan migrate:fresh --seed

php-fpm8.1 -F -R