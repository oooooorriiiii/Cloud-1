#!/bin/sh

while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root

    # Redis
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root    

    wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
    wp user create $MYSQL_USER $MYSQL_EMAIL --role=author --user_pass=$MYSQL_PASSWORD --allow-root

    # Redis
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

echo "Starting PHP-FPM..."
exec php-fpm83 -F