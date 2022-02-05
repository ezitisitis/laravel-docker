#!/usr/bin/env bash

mkdir -p /run/php

composer install
php artisan migrate

npm install
npm run production

php-fpm8.1 -F -R