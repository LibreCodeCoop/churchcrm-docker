#!/bin/bash

# Set uid of host machine
usermod --non-unique --uid "${HOST_UID}" www-data
groupmod --non-unique --gid "${HOST_GID}" www-data

export NVM_DIR="/root/.nvm"
. "$NVM_DIR/nvm.sh"

# Clone ChurchCRM repository, if needed
if [ ! -f "/var/www/html/src/composer.json" ]; then
    rm -rf /var/www/html/* /var/www/html/.git

    git config --global --add safe.directory /var/www/html
    git init
    git remote add origin "${CHURCHCRM_REPOSITORY}"

    TARGET_REF="${CHURCHCRM_VERSION}"
    if [ -z "${TARGET_REF}" ]; then
        TARGET_REF=$(git ls-remote --symref "${CHURCHCRM_REPOSITORY}" HEAD | awk '/^ref:/ {sub("refs/heads/", "", $2); print $2; exit}')
    fi
    if [ -z "${TARGET_REF}" ]; then
        TARGET_REF="master"
    fi

    if ! git fetch --depth=1 origin "${TARGET_REF}"; then
        echo "⛔ Unable to fetch '${TARGET_REF}' from ${CHURCHCRM_REPOSITORY}"
        exit 1
    fi

    git checkout --detach FETCH_HEAD
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

if [ ! -d "/var/www/html/src/vendor" ]; then
    cd /var/www/html/src
    composer install --no-interaction --prefer-dist --optimize-autoloader
    cd /var/www/html
fi

if [ "${RUN_FRONTEND_BUILD}" = "true" ]; then
    if [ ! -d "/var/www/html/node_modules" ]; then
        npm ci || npm install
    fi

    if npm run | grep -q '^  deploy$'; then
        npm run deploy
    elif npm run | grep -q '^  build$'; then
        npm run build
    else
        echo "⛔ Could not find a supported build script (deploy/build)"
        exit 1
    fi
fi

if [ ! -f "/var/www/html/src/Include/Config.php" ]; then
    # Copy the example configuration file if needed
    cp /var/www/example.config/Config.php /var/www/html/src/Include/Config.php
    # Set permissions so that the web server can write to the config file
    chmod 660 /var/www/html/src/Include/Config.php
fi

mkdir -p /var/www/html/src/logs
chmod -R a+rw /var/www/html/src/logs

chown www-data:www-data -R /var/www/html

# Start PHP-FPM
if [[ "$HTTP_PORT" != 80 ]]; then
    echo "💙 ChurchCRM is up! Access http://localhost:$HTTP_PORT"
else
    echo "💙 ChurchCRM is up! Access http://localhost"
fi
exec "$@"
