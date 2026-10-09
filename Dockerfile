FROM php:8.1-apache

# Instalacja rozszerzeń PHP oraz włączenie mod_rewrite dla Apache
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite

# Kopiowanie plików aplikacji
COPY . /var/www/html/

# Zmiana DocumentRoot na katalog główny z odpowiednimi uprawnieniami
RUN sed -i 's|/var/www/html|/var/www/html|g' /etc/apache2/sites-available/000-default.conf && \
    echo "<Directory /var/www/html>\n\tOptions -Indexes +FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
    chown -R www-data:www-data /var/www/html

EXPOSE 80

# Import bazy wyłączający requirement primary key + uruchomienie Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $pdo->exec("SET SESSION sql_require_primary_key = OFF;"); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql);' && apache2-foreground
