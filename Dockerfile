FROM php:8.1-apache

# 1. Instalacja bibliotek systemowych oraz rozszerzeń PHP wymaganych przez Gibbona i Composer
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mysqli gd xml zip intl \
    && a2enmod rewrite dir

# 2. Pobranie i instalacja Composera
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 3. Pobranie źródeł Gibbon v27.0.00
RUN curl -L https://github.com/GibbonEdu/core/archive/refs/tags/v27.0.00.tar.gz | tar -xz --strip-components=1 -C /var/www/html/

WORKDIR /var/www/html

# 4. Instalacja zależności Composera z flagami ignorującymi ograniczenia środowiska budowania
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-reqs

# 5. Kopiowanie konfiguracji i bazy
COPY config.php /var/www/html/config.php
COPY gibbon.sql /var/www/html/gibbon.sql

# 6. Konfiguracja Apache i uprawnień
RUN echo "DirectoryIndex index.php index.html" > /etc/apache2/mods-available/dir.conf && \
    echo "<Directory /var/www/html>\n\tOptions -Indexes +FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# 7. Inicjalizacja bazy i start Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $check = $pdo->query("SHOW TABLES LIKE '\''gibbonAction'\''"); if ($check && $check->rowCount() == 0) { $pdo->exec("SET SESSION sql_require_primary_key = OFF;"); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql); }' && apache2-foreground
