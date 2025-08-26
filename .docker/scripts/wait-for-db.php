#!/usr/bin/env php
<?php
$dbName = '🐬' . getenv('MARIADB_HOST');

echo "⌛ Waiting for database $dbName\n";

function dbIsUp(string $dbName): bool {
    try {
        $dsn = 'mysql:dbname='.getenv('MARIADB_DATABASE').';host='.getenv('MARIADB_HOST');
        new PDO($dsn, getenv('MARIADB_USER'), getenv('MARIADB_PASSWORD'));
    } catch(Exception $e) {
        echo "⛔ Unable to conect to $dbName server: " . $e->getMessage()."\n";
        return false;
    }
    return true;
}

while(!dbIsUp($dbName)) {
    sleep(1);
}

echo "✅ Database $dbName ready\n";