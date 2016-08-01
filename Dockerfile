FROM alpine:latest

# Install packages
RUN apk --update add mariadb php7 php7-fpm nginx supervisor --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Install some extra stuff
RUN apk add nano bash git composer --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
