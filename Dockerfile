FROM php:8.1-apache

# Instalacja zależności systemowych i rozszerzeń PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Włączenie mod_rewrite
RUN a2enmod rewrite

# Pobranie i rozpakowanie oficjalnego wydania Gibbona (z gotowym folderem vendor)
WORKDIR /var/www/html
RUN curl -L -o gibbon.zip https://github.com/GibbonEdu/core/releases/download/v27.0.00/GibbonEduCore-v27.0.00.zip \
    && unzip gibbon.zip \
    && rm gibbon.zip \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
