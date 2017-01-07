FROM ubuntu:latest


FROM ubuntu:latest

# apt-gets
RUN apt-get update
RUN apt-get install -y curl git nano less bash git bash-completion
RUN apt-get install -y nginx mariadb-server imagemagick
RUN apt-get install -y php7.0*
RUN apt-get remove -y  php7.0-snmp 
RUN apt-get install -y pkg-config libmagickwand-dev libmagickcore-dev mcrypt supervisor php-xdebug phpunit

# custom installs
RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp
RUN alias wp='wp --allow-root'

# Configure nginx
# COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
RUN service php7.0-fpm start
RUN mkdir -p /var/log/php-fpm

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# nvm / node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install node"

# create some structure and modify permissions
RUN mkdir /dump

# Add wp creation script
COPY createwp /usr/bin/createwp
RUN chmod +x /usr/bin/createwp

# some final configurations
ADD config/my.cnf /etc/mysql/mariadb.conf.d/60-my.cnf
RUN echo 'umask 0000' >> ~/.bashrc


COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html/

ENV TERM xterm

EXPOSE 80 443 3306

# prep init
COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
CMD ["init.sh"]
