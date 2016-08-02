FROM alpine:latest

# Install base packages
RUN apk --update add mariadb nginx supervisor --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Install php
RUN apk add php7 php7-dev php7-fpm php7-json php7-zlib php7-xml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-gd php7-iconv php7-mcrypt php7-curl php7-opcache php7-ctype php7-apcu \
    php7-intl php7-bcmath php7-dom php7-xmlreader  --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Install some extra stuff
RUN apk add less mysql mariadb-client curl nano bash git --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Create system db's
RUN mysql_install_db --user=mysql

# php alias
RUN ln -s /usr/bin/php7 /usr/bin/php

# wp-cli
RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 80 443 3306

CMD ["init.sh"]
