# Dockerfile for Laravel demo
FROM php:8.3-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libonig-dev libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set workdir
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies and prepare Laravel
RUN composer install --no-dev --optimize-autoloader \
 && php -r "file_exists('.env') || copy('.env.example', '.env');" \
 && php artisan key:generate \
 && mkdir -p /app/database && touch /app/database/database.sqlite

ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/app/database/database.sqlite

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
