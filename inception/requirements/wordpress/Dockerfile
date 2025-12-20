FROM alpine:latest

RUN apk update && apk add --no-cache \
    php83 php83-fpm php83-mysqli php83-json php83-curl \
    php83-dom php83-exif php83-fileinfo php83-mbstring \
    php83-openssl php83-xml php83-zip php83-phar \
    wget mariadb-client

RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php83/php.ini

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/usr/local/bin/script.sh"]