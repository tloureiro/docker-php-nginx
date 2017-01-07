#!/bin/bash

umask 0000;

mysql_install_db;

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'admin'";
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION";
mysql -uroot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'";
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION";

chmod -R 777 /var/lib/mysql;
chmod -R 777 /dump;
chmod -R 777 /var/www/html;

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf;
