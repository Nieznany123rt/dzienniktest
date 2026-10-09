FROM php:8.1-apache

# Instalacja rozszerzeń PHP oraz klienta MySQL
RUN apt-get update && apt-get install -y default-mysql-client && docker-php-ext-install pdo pdo_mysql mysqli

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD mysql --ssl-mode=REQUIRED -h "$MYSQLHOST" -P "$MYSQLPORT" -u "$MYSQLUSER" -p"$MYSQLPASSWORD" "$MYSQLDATABASE" < /var/www/html/gibbon.sql && apache2-foreground
