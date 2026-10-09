FROM php:8.1-apache

# Instalacja niezbędnych rozszerzeń PHP do obsługi bazy
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Import bazy przez PHP i uruchomienie serwera Apache
CMD php -r '$pdo = new PDO("mysql:host=".getenv("MYSQLHOST").";port=".getenv("MYSQLPORT").";dbname=".getenv("MYSQLDATABASE"), getenv("MYSQLUSER"), getenv("MYSQLPASSWORD"), [PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false]); $sql = file_get_contents("/var/www/html/gibbon.sql"); $pdo->exec($sql);' && apache2-foreground
