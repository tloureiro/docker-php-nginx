#!/bin/bash

# TODO - check if files exist before downloading
# TODO - check if database exist before creating it
# TODO - add nginx wp conf
# TODO - add variable for version

#start database just to install basic wp stuff
mysqld_safe --datadir="/var/lib/mysql" --nowatch
wp core download
wp core config --dbname=wordpress --dbuser=root
wp db create
wp core install --url=localhost --title=adamo --admin_user=admin --admin_password=admin --admin_email=o@o.com
#now we stop it
mysqld stop

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf




# how to use env vars fallback
#	: ${WORDPRESS_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
#	if [ "$WORDPRESS_DB_USER" = 'root' ]; then
#		: ${WORDPRESS_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
#	fi
#	: ${WORDPRESS_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
#	: ${WORDPRESS_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-wordpress}}
