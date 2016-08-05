#!/bin/bash

# TODO - check if files exist before downloading
# TODO - check if database exist before creating it
# TODO - add nginx wp conf
# TODO - fix nginx config file (it doenst handle /wp-admin well

#start database just to install basic wp stuff
mysqld_safe --datadir="/var/lib/mysql" --nowatch
wp core download --version=${WP_VERSION:=${WP_VERSION:-latest}}
wp core config --dbname=wordpress --dbuser=root
wp db create
wp core install --url=localhost:${WP_PORT:=${WP_PORT:-80}} --title="Version ${WP_VERSION:=${WP_VERSION:-latest}}" --admin_user=admin --admin_password=admin --admin_email=o@o.com --skip-email
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
