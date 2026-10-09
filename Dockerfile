FROM php:8.1-apache

# Instalacja narzędzi, rozszerzeń PHP i włączenie modułów Apache
RUN apt-get update && apt-get install -y wget unzip libpng-dev libjpeg-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql mysqli gd && \
    a2enmod rewrite dir

# Pobranie i rozpakowanie oficjalnej paczki Gibbon v27.0.00 do /var/www/html
RUN wget https://github.com/GibbonEdu/core/releases/download/v27.0.00/Gibbonv27.0.00.zip -O /tmp/gibbon.zip && \
    unzip /tmp/gibbon.zip -d /var/www/html/ && \
    rm /tmp/gibbon.zip

# Kopiowanie plików konfiguracyjnych i bazy z repozytorium do kontenera
COPY config.php /var/www/html/config.php
COPY gibbon.sql /var/www/html/gibbon.sql

# Ustawienie uprawnień dla Apache
RUN echo "DirectoryIndex index.php index.html" > /etc/apache2/mods-available/dir.conf && \
    echo "<Directory /var/www/html>\n\tOptions -Indexes +FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Import bazy (tylko jeśli tabele nie istnieją) + uruchomienie Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $check = $pdo->query("SHOW TABLES LIKE '\''gibbonAction'\''"); if ($check && $check->rowCount() == 0) { $pdo->exec("SET SESSION sql_require_primary_key = OFF;"); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql); }' && apache2-foreground
