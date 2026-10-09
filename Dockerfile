FROM php:8.1-apache

# Instalacja klientów, pobranie certyfikatu Aiven CA i instalacja rozszerzeń PHP
RUN apt-get update && apt-get install -y default-mysql-client curl && \
    curl -sS https://aiven.io/ca.pem -o /etc/ssl/certs/aiven-ca.pem && \
    docker-php-ext-install pdo pdo_mysql mysqli

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Uruchomienie importu z podanym certyfikatem CA i start Apache
CMD mysql --ssl-ca=/etc/ssl/certs/aiven-ca.pem -h "$MYSQLHOST" -P "$MYSQLPORT" -u "$MYSQLUSER" -p"$MYSQLPASSWORD" "$MYSQLDATABASE" < /var/www/html/gibbon.sql && apache2-foreground
