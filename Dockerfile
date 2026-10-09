FROM php:8.1-apache

# Instalacja rozszerzeń PHP oraz włączenie wymaganych modułów Apache
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite dir

# Kopiowanie plików aplikacji do serwera
COPY . /var/www/html/

# Konfiguracja Apache: wskazanie index.php, zezwolenie na nadpisywanie `.htaccess` i uprawnienia
RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf && \
    echo "<Directory /var/www/html>\n\tOptions -Indexes +FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Import bazy (tylko jeśli tabele nie istnieją) + uruchomienie Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $check =$pdo->query("SHOW TABLES LIKE '\''gibbonAction'\''"); if ($check &&$check->rowCount() == 0) { $pdo->exec("SET SESSION sql_require_primary_key = OFF;"); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql); }' && apache2-foreground
