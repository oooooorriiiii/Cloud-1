#!/bin/sh

while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
    wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=admin_user --admin_password=admin_password --admin_email=admin@student.42.fr --allow-root
    wp user create $MYSQL_USER user@student.42.fr --role=author --user_pass=$MYSQL_PASSWORD --allow-root
fi

echo "Starting PHP-FPM..."
exec php-fpm83 -F