#!/usr/bin/env bash

mkdir -p /run/php

composer install
php artisan migrate:fresh --seed

npm install
npm run development

php-fpm8.1 -F -R