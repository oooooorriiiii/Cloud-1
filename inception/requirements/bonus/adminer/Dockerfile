FROM alpine:latest

RUN apk update && apk add --no-cache \
    php83 php83-common php83-session php83-iconv php83-json \
    php83-gd php83-curl php83-xml php83-mysqli php83-imap \
    php83-cgi php83-pdo php83-pdo_mysql php83-soap php83-posix \
    php83-gettext php83-ldap php83-ctype php83-dom wget

WORKDIR /var/www

# Adminer本体のダウンロード
RUN wget "https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php" -O index.php && \
    chown -R root:root /var/www

EXPOSE 8080

# PHPビルトインサーバーで起動
CMD ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www"]