FROM php:8.1-apache

# Instalacja rozszerzeń PHP i włączenie mod_rewrite oraz dir
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite dir

# Kopiowanie plików do kontenera
COPY . /var/www/html/

# Zmiana DocumentRoot na /var/www/html/public (z fallbackiem na root)
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/apache2.conf && \
    echo "<Directory /var/www/html>\n\tOptions -Indexes +FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Import bazy (jeśli brak tabel) + uruchomienie Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $check = $pdo->query("SHOW TABLES LIKE '\''gibbonAction'\''"); if ($check && $check->rowCount() == 0) { $pdo->exec("SET SESSION sql_require_primary_key = OFF;"); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql); }' && apache2-foreground
