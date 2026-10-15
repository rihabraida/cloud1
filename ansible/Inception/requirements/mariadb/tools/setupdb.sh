#!/bin/bash
set -e

chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

service mariadb start

ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
WORDPRESS_DB_PASSWORD="$(cat /run/secrets/db_password)"

# Wait until the server answers (works whether or not root has a password yet)
until mysqladmin ping --silent 2>/dev/null \
   || mysqladmin -uroot -p"${ROOT_PASSWORD}" ping --silent 2>/dev/null; do
    sleep 2
done

if mysql -e "SELECT 1" >/dev/null 2>&1; then
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';"
fi

mysql -uroot -p"${ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -uroot -p"${ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
mysql -uroot -p"${ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${WORDPRESS_DB_USER}'@'%';"
mysql -uroot -p"${ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p"${ROOT_PASSWORD}" shutdown

exec mysqld