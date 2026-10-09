FROM php:8.1-apache

# Instalacja wszystkich wymaganych zależności systemowych i rozszerzeń PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip intl mbstring gettext \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Włączenie mod_rewrite
RUN a2enmod rewrite

# Pobranie kodu Gibbona i wygenerowanie autoloader-a
WORKDIR /var/www/html
RUN curl -L -o gibbon.zip https://github.com/GibbonEdu/core/archive/refs/tags/v27.0.00.zip \
    && unzip gibbon.zip \
    && cp -r core-27.0.00/* . \
    && rm -rf core-27.0.00 gibbon.zip \
    && composer install --no-dev --optimize-autoloader --ignore-platform-reqs \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
RUN rm -f /var/www/html/config.php
