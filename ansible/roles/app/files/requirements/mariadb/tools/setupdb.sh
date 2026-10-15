#!/bin/bash
set -e

chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

first_time=0
if [ ! -f "/var/lib/mysql/.initialized" ]; then
  touch /var/lib/mysql/.initialized
  first_time=1
fi

service mariadb start

ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
WORDPRESS_DB_PASSWORD="$(cat /run/secrets/db_password)"

while ! mysqladmin ping ; do
    sleep 2
done

if [ "$first_time" = "1" ]; then
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';"
fi

mysql -uroot -p"${ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -uroot -p"${ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
mysql -uroot -p"${ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${WORDPRESS_DB_USER}'@'%';"
mysql -uroot -p"${ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p"${ROOT_PASSWORD}" shutdown

exec mysqld