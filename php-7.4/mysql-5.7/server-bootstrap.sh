#!/bin/bash

if [ ! -d /run/php ]; then
  mkdir -p /run/php
fi

php-fpm7.4 -F
