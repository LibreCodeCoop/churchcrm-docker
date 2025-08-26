#!/bin/bash

# Set uid of host machine
usermod --non-unique --uid "${HOST_UID}" www-data
groupmod --non-unique --gid "${HOST_GID}" www-data

export NVM_DIR="/root/.nvm"
. "$NVM_DIR/nvm.sh"

# Clone ChurchCRM repository, if needed
if [ ! -d ".git" ]; then
    git config --global --add safe.directory /var/www/html
    git init
    git remote add origin "${CHURCHCRM_REPOSITORY}"
    git fetch --depth=1 origin "${CHURCHRCM_VERSION}"
    git checkout "${CHURCHRCM_VERSION}"
    git submodule update --init --recursive
fi

if [ -n "$LANGUAGE" ]; then
    sed -i -e "s/# ${LANGUAGE} UTF-8/${LANGUAGE} UTF-8/" /etc/locale.gen
    locale-gen
    update-locale
    echo "🌐 The locale ${LANGUAGE} has been successfully enabled."
fi

# Wait for database
php /var/www/scripts/wait-for-db.php

cd /var/www/html

if [ ! -d "/var/www/html/node_modules" ]; then
    # Install Node.js dependencies
    npm install
    # Build the frontend
    npm run deploy
fi

if [ ! -f "/var/www/html/src/Include/Config.php" ]; then
    # Copy the example configuration file if needed
    cp /var/www/example.config/Config.php /var/www/html/src/Include/Config.php
    # Set permissions so that the web server can write to the config file
    chmod 660 /var/www/html/src/Include/Config.php
fi

chown www-data:www-data -R /var/www/html

# Start PHP-FPM
if [[ "$HTTP_PORT" != 80 ]]; then
    echo "💙 ChurchCRM is up! Access http://localhost:$HTTP_PORT"
else
    echo "💙 ChurchCRM is up! Access http://localhost"
fi
exec "$@"
